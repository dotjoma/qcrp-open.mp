/*
    FISHING ZONE ACTORS SYSTEM
    NPCs for selling fish and accessing fishing shop
    Admin Level 8+ management
*/

#if defined _fishing_actors_included
    #endinput
#endif
#define _fishing_actors_included

// Constants
#define MAX_FISHING_ACTORS      100
#define ACTOR_INTERACTION_RANGE 3.0

// Dialogs
#define DIALOG_ACTOR_CREATE         9030
#define DIALOG_ACTOR_EDIT_MENU      9031
#define DIALOG_ACTOR_DELETE         9032
#define DIALOG_ACTOR_LIST           9033
#define DIALOG_ACTOR_EDIT_NAME      9034
#define DIALOG_ACTOR_EDIT_SKIN      9035
#define DIALOG_ACTOR_INTERACTION    9036
#define DIALOG_ACTOR_SELL_CONFIRM   9037

// Actor data
enum E_FISHING_ACTOR
{
    aID,
    aZoneID,
    aName[64],
    Float:aPosX,
    Float:aPosY,
    Float:aPosZ,
    Float:aPosA,
    aSkinID,
    aCreatedBy,
    bool:aActive,
    aActorID,
    Text3D:aLabel
}

new FishingActors[MAX_FISHING_ACTORS][E_FISHING_ACTOR];
new TotalFishingActors = 0;
new PlayerEditingActor[MAX_PLAYERS] = {-1, ...};
new PlayerNearActor[MAX_PLAYERS] = {-1, ...};

// Initialize actor data
stock InitActorData()
{
    for(new i = 0; i < MAX_FISHING_ACTORS; i++)
    {
        FishingActors[i][aID] = 0;
        FishingActors[i][aActive] = false;
        FishingActors[i][aActorID] = INVALID_ACTOR_ID;
        FishingActors[i][aLabel] = Text3D:INVALID_3DTEXT_ID;
    }
    printf("[FISHING ACTORS] Actor data initialized");
}

// Load actors from database
stock LoadFishingActorsFromDB()
{
    InitActorData();
    new query[256];
    format(query, sizeof(query),
        "SELECT * FROM fishing_actors WHERE is_active = 1 ORDER BY zone_id, id ASC");
    mysql_tquery(connectionID, query, "OnLoadActors");
    printf("[FISHING ACTORS] Loading actors from database...");
}

forward OnLoadActors();
public OnLoadActors()
{
    new rows = cache_get_row_count(connectionID);
    printf("[FISHING ACTORS] OnLoadActors callback - rows found: %d", rows);
    
    if(rows == 0)
    {
        printf("[FISHING ACTORS] No actors found in database");
        return;
    }
    
    TotalFishingActors = 0;
    for(new i = 0; i < rows && i < MAX_FISHING_ACTORS; i++)
    {
        FishingActors[i][aID] = cache_get_field_content_int(i, "id");
        FishingActors[i][aZoneID] = cache_get_field_content_int(i, "zone_id");
        cache_get_field_content(i, "actor_name", FishingActors[i][aName], connectionID, 64);
        FishingActors[i][aPosX] = cache_get_field_content_float(i, "pos_x");
        FishingActors[i][aPosY] = cache_get_field_content_float(i, "pos_y");
        FishingActors[i][aPosZ] = cache_get_field_content_float(i, "pos_z");
        FishingActors[i][aPosA] = cache_get_field_content_float(i, "pos_a");
        FishingActors[i][aSkinID] = cache_get_field_content_int(i, "skin_id");
        FishingActors[i][aCreatedBy] = cache_get_field_content_int(i, "created_by");
        FishingActors[i][aActive] = true;
        
        CreateFishingActor(i);
        TotalFishingActors++;
    }
    printf("[FISHING ACTORS] Successfully loaded %d actors from database", TotalFishingActors);
}

// Create actor and label
stock CreateFishingActor(idx)
{
    if(idx < 0 || idx >= MAX_FISHING_ACTORS) return;
    
    // Create actor
    FishingActors[idx][aActorID] = CreateActor(FishingActors[idx][aSkinID],
        FishingActors[idx][aPosX], FishingActors[idx][aPosY], FishingActors[idx][aPosZ],
        FishingActors[idx][aPosA]);
    
    SetActorInvulnerable(FishingActors[idx][aActorID], true);
    
    // Create 3D label
    new labelText[256];
    format(labelText, sizeof(labelText),
        "{2ECC71}%s {FFFFFF}(ID: {FFFF00}#%d{FFFFFF})\n{FFFFFF}Fisherman\n{FFFF00}Press Y to interact\n{FFFFFF}Sell Fish\n{FFFFFF}Fishing Shop",
        FishingActors[idx][aName], FishingActors[idx][aID]);
    
    FishingActors[idx][aLabel] = Create3DTextLabel(labelText, 0x2ECC71FF,
        FishingActors[idx][aPosX], FishingActors[idx][aPosY], FishingActors[idx][aPosZ] + 0.5,
        10.0, 0, 0);
    
    printf("[FISHING ACTORS] Created actor #%d (%s) for zone %d",
        FishingActors[idx][aID], FishingActors[idx][aName], FishingActors[idx][aZoneID]);
}

// Destroy actor and label
stock DestroyFishingActor(idx)
{
    if(idx < 0 || idx >= MAX_FISHING_ACTORS) return;
    
    if(FishingActors[idx][aActorID] != INVALID_ACTOR_ID)
    {
        DestroyActor(FishingActors[idx][aActorID]);
        FishingActors[idx][aActorID] = INVALID_ACTOR_ID;
    }
    
    if(FishingActors[idx][aLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(FishingActors[idx][aLabel]);
        FishingActors[idx][aLabel] = Text3D:INVALID_3DTEXT_ID;
    }
}

// Check if player is near any actor
stock CheckPlayerNearActor(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < TotalFishingActors; i++)
    {
        if(!FishingActors[i][aActive]) continue;
        
        new Float:distance = floatsqroot(
            floatpower(x - FishingActors[i][aPosX], 2.0) +
            floatpower(y - FishingActors[i][aPosY], 2.0) +
            floatpower(z - FishingActors[i][aPosZ], 2.0)
        );
        
        if(distance <= ACTOR_INTERACTION_RANGE)
        {
            PlayerNearActor[playerid] = i;
            return i;
        }
    }
    
    PlayerNearActor[playerid] = -1;
    return -1;
}

// Show actor interaction menu
stock ShowActorInteractionMenu(playerid, actoridx)
{
    if(actoridx < 0 || actoridx >= MAX_FISHING_ACTORS) return;
    
    new dialog[512];
    format(dialog, sizeof(dialog),
        "{FFFFFF}Welcome to {2ECC71}%s's{FFFFFF} fishing service!\n\n\
        What would you like to do?\n\n\
        {FFFF00}Sell Fish{FFFFFF} - Sell your caught fish for money\n\
        {FFFF00}Fishing Shop{FFFFFF} - Buy rods, bait, and equipment",
        FishingActors[actoridx][aName]);
    
    ShowPlayerDialog(playerid, DIALOG_ACTOR_INTERACTION, DIALOG_STYLE_LIST,
        "{2ECC71}Fishing Services", "{FFFFFF}Sell Fish\n{FFFFFF}Fishing Shop", "Select", "Cancel");
}

// Admin commands
CMD:fishactor(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Admin level 8+ required");
    
    new subcmd[32], actorid;
    if(sscanf(params, "s[32]D(-1)", subcmd, actorid))
    {
        SendClientMessage(playerid, 0x2ECC71FF, "--- FISHING ACTOR MANAGEMENT ---");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishactor create [zoneid] - Create actor at your position");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishactor edit [actorid]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishactor delete [actorid]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishactor list [zoneid]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishactor goto [actorid]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishactor move [actorid] - Move actor to your position");
        return 1;
    }
    
    if(!strcmp(subcmd, "create", true))
    {
        if(actorid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishactor create [zoneid]");
        return cmd_fishactor_create(playerid, actorid);
    }
    else if(!strcmp(subcmd, "edit", true))
    {
        if(actorid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishactor edit [actorid]");
        return cmd_fishactor_edit(playerid, actorid);
    }
    else if(!strcmp(subcmd, "delete", true))
    {
        if(actorid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishactor delete [actorid]");
        return cmd_fishactor_delete(playerid, actorid);
    }
    else if(!strcmp(subcmd, "list", true))
    {
        return cmd_fishactor_list(playerid, actorid);
    }
    else if(!strcmp(subcmd, "goto", true))
    {
        if(actorid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishactor goto [actorid]");
        return cmd_fishactor_goto(playerid, actorid);
    }
    else if(!strcmp(subcmd, "move", true))
    {
        if(actorid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishactor move [actorid]");
        return cmd_fishactor_move(playerid, actorid);
    }
    return 1;
}

cmd_fishactor_create(playerid, zoneid)
{
    // Check if zone exists
    new zoneIdx = -1;
    for(new i = 0; i < TotalZones; i++)
    {
        if(Zones[i][zID] == zoneid && Zones[i][zActive])
        {
            zoneIdx = i;
            break;
        }
    }
    
    if(zoneIdx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Zone not found!");
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    new query[512];
    mysql_format(connectionID, query, sizeof(query),
        "INSERT INTO fishing_actors (zone_id, actor_name, pos_x, pos_y, pos_z, pos_a, skin_id, created_by) VALUES (%d, 'Fisherman', %f, %f, %f, %f, 158, %d)",
        zoneid, x, y, z, a, playerid);
    
    mysql_tquery(connectionID, query, "OnCreateActor", "iffffi", playerid, x, y, z, a, zoneid);
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Creating actor...");
    return 1;
}

forward OnCreateActor(playerid, Float:x, Float:y, Float:z, Float:a, zoneid);
public OnCreateActor(playerid, Float:x, Float:y, Float:z, Float:a, zoneid)
{
    new insert_id = cache_insert_id();
    if(insert_id > 0 && TotalFishingActors < MAX_FISHING_ACTORS)
    {
        new idx = TotalFishingActors;
        FishingActors[idx][aID] = insert_id;
        FishingActors[idx][aZoneID] = zoneid;
        format(FishingActors[idx][aName], 64, "Fisherman");
        FishingActors[idx][aPosX] = x;
        FishingActors[idx][aPosY] = y;
        FishingActors[idx][aPosZ] = z;
        FishingActors[idx][aPosA] = a;
        FishingActors[idx][aSkinID] = 158;
        FishingActors[idx][aCreatedBy] = playerid;
        FishingActors[idx][aActive] = true;
        
        CreateFishingActor(idx);
        TotalFishingActors++;
        
        new string[128];
        format(string, sizeof(string),
            "{2ECC71}[FISHING]{FFFFFF} Actor created! ID: {2ECC71}#%d {FFFFFF}| Use {FFFF00}/fishactor edit %d",
            insert_id, insert_id);
        SendClientMessage(playerid, -1, string);
    }
    else SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Failed to create actor!");
}

cmd_fishactor_edit(playerid, actorid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingActors; i++)
    {
        if(FishingActors[i][aID] == actorid && FishingActors[i][aActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Actor not found!");
    
    PlayerEditingActor[playerid] = idx;
    
    new dialog[512];
    format(dialog, sizeof(dialog),
        "{FFFFFF}Edit Name (Current: {2ECC71}%s{FFFFFF})\n\
        {FFFFFF}Edit Skin (Current: {FFFF00}%d{FFFFFF})\n\
        {FFFFFF}Move to My Position\n\
        {FF0000}Cancel",
        FishingActors[idx][aName], FishingActors[idx][aSkinID]);
    
    ShowPlayerDialog(playerid, DIALOG_ACTOR_EDIT_MENU, DIALOG_STYLE_LIST,
        "{2ECC71}Edit Fishing Actor", dialog, "Select", "Cancel");
    return 1;
}

cmd_fishactor_delete(playerid, actorid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingActors; i++)
    {
        if(FishingActors[i][aID] == actorid && FishingActors[i][aActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Actor not found!");
    
    // Delete from database
    new query[128];
    mysql_format(connectionID, query, sizeof(query),
        "DELETE FROM fishing_actors WHERE id = %d", actorid);
    mysql_tquery(connectionID, query);
    
    // Destroy actor
    DestroyFishingActor(idx);
    
    // Remove from memory
    for(new i = idx; i < TotalFishingActors - 1; i++)
    {
        FishingActors[i] = FishingActors[i + 1];
    }
    TotalFishingActors--;
    
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Actor deleted!");
    return 1;
}

cmd_fishactor_list(playerid, zoneid)
{
    if(zoneid == -1)
    {
        SendClientMessage(playerid, 0x2ECC71FF, "--- ALL FISHING ACTORS ---");
        for(new i = 0; i < TotalFishingActors; i++)
        {
            if(!FishingActors[i][aActive]) continue;
            new string[256];
            format(string, sizeof(string), "{FFFFFF}Actor #{2ECC71}%d {FFFFFF}| {2ECC71}%s {FFFFFF}| Zone: {FFFF00}%d",
                FishingActors[i][aID], FishingActors[i][aName], FishingActors[i][aZoneID]);
            SendClientMessage(playerid, -1, string);
        }
    }
    else
    {
        new string[128];
        format(string, sizeof(string), "--- ACTORS IN ZONE #%d ---", zoneid);
        SendClientMessage(playerid, 0x2ECC71FF, string);
        
        for(new i = 0; i < TotalFishingActors; i++)
        {
            if(!FishingActors[i][aActive] || FishingActors[i][aZoneID] != zoneid) continue;
            format(string, sizeof(string), "{FFFFFF}Actor #{2ECC71}%d {FFFFFF}| {2ECC71}%s",
                FishingActors[i][aID], FishingActors[i][aName]);
            SendClientMessage(playerid, -1, string);
        }
    }
    return 1;
}

cmd_fishactor_goto(playerid, actorid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingActors; i++)
    {
        if(FishingActors[i][aID] == actorid && FishingActors[i][aActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Actor not found!");
    
    SetPlayerPos(playerid, FishingActors[idx][aPosX] + 2.0, FishingActors[idx][aPosY], FishingActors[idx][aPosZ]);
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Teleported to actor!");
    return 1;
}

cmd_fishactor_move(playerid, actorid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingActors; i++)
    {
        if(FishingActors[i][aID] == actorid && FishingActors[i][aActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Actor not found!");
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    FishingActors[idx][aPosX] = x;
    FishingActors[idx][aPosY] = y;
    FishingActors[idx][aPosZ] = z;
    FishingActors[idx][aPosA] = a;
    
    // Update database
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "UPDATE fishing_actors SET pos_x = %f, pos_y = %f, pos_z = %f, pos_a = %f WHERE id = %d",
        x, y, z, a, actorid);
    mysql_tquery(connectionID, query);
    
    // Recreate actor
    DestroyFishingActor(idx);
    CreateFishingActor(idx);
    
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Actor moved to your position!");
    return 1;
}

// Dialog responses
stock OnFishActorDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ACTOR_INTERACTION)
    {
        if(!response) return 1;
        
        if(listitem == 0)
        {
            // Sell Fish - call sellfish functionality
            // Check if player is near an actor first
            if(PlayerNearActor[playerid] == -1)
            {
                SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} You must be near a fishing actor to sell fish!");
                return 1;
            }
            
            // Call the sell fish query
            new query[256], queryStr[128];
            format(queryStr, sizeof(queryStr),
                "SELECT SUM(fish_value) as total_value, COUNT(*) as fish_count FROM fishing_inventory WHERE player_id = %d",
                PlayerFishingData[playerid][pFishingDBID]);
            mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
            mysql_tquery(connectionID, query, "OnSellFishFromActor", "i", playerid);
        }
        else if(listitem == 1)
        {
            // Fishing Shop - show the shop
            ShowFishingShopMain(playerid);
        }
    }
    else if(dialogid == DIALOG_ACTOR_EDIT_MENU)
    {
        if(!response || PlayerEditingActor[playerid] == -1) return 1;
        new idx = PlayerEditingActor[playerid];
        
        switch(listitem)
        {
            case 0: ShowPlayerDialog(playerid, DIALOG_ACTOR_EDIT_NAME, DIALOG_STYLE_INPUT,
                "{2ECC71}Edit Actor Name", "{FFFFFF}Enter new actor name:", "Save", "Cancel");
            case 1: ShowPlayerDialog(playerid, DIALOG_ACTOR_EDIT_SKIN, DIALOG_STYLE_INPUT,
                "{2ECC71}Edit Actor Skin", "{FFFFFF}Enter new skin ID (0-311):", "Save", "Cancel");
            case 2:
            {
                new Float:x, Float:y, Float:z, Float:a;
                GetPlayerPos(playerid, x, y, z);
                GetPlayerFacingAngle(playerid, a);
                
                FishingActors[idx][aPosX] = x;
                FishingActors[idx][aPosY] = y;
                FishingActors[idx][aPosZ] = z;
                FishingActors[idx][aPosA] = a;
                
                new query[256];
                mysql_format(connectionID, query, sizeof(query),
                    "UPDATE fishing_actors SET pos_x = %f, pos_y = %f, pos_z = %f, pos_a = %f WHERE id = %d",
                    x, y, z, a, FishingActors[idx][aID]);
                mysql_tquery(connectionID, query);
                
                DestroyFishingActor(idx);
                CreateFishingActor(idx);
                
                SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Actor position updated!");
                PlayerEditingActor[playerid] = -1;
            }
        }
    }
    else if(dialogid == DIALOG_ACTOR_EDIT_NAME)
    {
        if(!response || PlayerEditingActor[playerid] == -1) return 1;
        new idx = PlayerEditingActor[playerid];
        
        if(strlen(inputtext) < 3 || strlen(inputtext) > 63)
        {
            SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Name must be 3-63 characters!");
            return 1;
        }
        
        format(FishingActors[idx][aName], 64, "%s", inputtext);
        
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE fishing_actors SET actor_name = '%e' WHERE id = %d", inputtext, FishingActors[idx][aID]);
        mysql_tquery(connectionID, query);
        
        DestroyFishingActor(idx);
        CreateFishingActor(idx);
        
        new string[128];
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Actor name updated to: {2ECC71}%s", inputtext);
        SendClientMessage(playerid, -1, string);
        PlayerEditingActor[playerid] = -1;
    }
    else if(dialogid == DIALOG_ACTOR_EDIT_SKIN)
    {
        if(!response || PlayerEditingActor[playerid] == -1) return 1;
        new idx = PlayerEditingActor[playerid];
        
        new skinid = strval(inputtext);
        if(skinid < 0 || skinid > 311)
        {
            SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Skin ID must be 0-311!");
            return 1;
        }
        
        FishingActors[idx][aSkinID] = skinid;
        
        new query[256];
        mysql_format(connectionID, query, sizeof(query),
            "UPDATE fishing_actors SET skin_id = %d WHERE id = %d", skinid, FishingActors[idx][aID]);
        mysql_tquery(connectionID, query);
        
        DestroyFishingActor(idx);
        CreateFishingActor(idx);
        
        new string[128];
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Actor skin updated to: {FFFF00}%d", skinid);
        SendClientMessage(playerid, -1, string);
        PlayerEditingActor[playerid] = -1;
    }
    return 1;
}

// Cleanup
stock CleanupActors()
{
    for(new i = 0; i < TotalFishingActors; i++)
        DestroyFishingActor(i);
    printf("[FISHING ACTORS] Cleaned up %d actors", TotalFishingActors);
}

// Callback for selling fish from actor
forward OnSellFishFromActor(playerid);
public OnSellFishFromActor(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, 
            "{E74C3C}[FISHING]{FFFFFF} You don't have any fish to sell!");
        return 1;
    }
    
    new totalValue = cache_get_field_content_int(0, "total_value");
    new fishCount = cache_get_field_content_int(0, "fish_count");
    
    if(fishCount == 0 || totalValue == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, 
            "{E74C3C}[FISHING]{FFFFFF} You don't have any fish to sell!");
        return 1;
    }
    
    // Give money to player
    CallRemoteFunction("GivePlayerCashEx", "ii", playerid, totalValue);
    
    // Delete sold fish from inventory
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "DELETE FROM fishing_inventory WHERE player_id = %d",
        PlayerFishingData[playerid][pFishingDBID]);
    mysql_tquery(connectionID, query);
    
    // Success message
    new string[128];
    format(string, sizeof(string), 
        "{2ECC71}[FISHING]{FFFFFF} Sold {3498DB}%d{FFFFFF} fish for {2ECC71}$%d{FFFFFF}!",
        fishCount, totalValue);
    SendClientMessage(playerid, -1, string);
    
    return 1;
}
