/*
    FISHING BOATS SYSTEM
    Free-to-use boats for fishing zones (Reefer model only)
    Admin Level 8+ management
*/

#if defined _fishing_boats_included
    #endinput
#endif
#define _fishing_boats_included

// Constants
#define MAX_FISHING_BOATS       200  // Total boats across all zones
#define MAX_BOATS_PER_ZONE      10   // Limit per zone
#define FISHING_BOAT_MODEL      453  // Reefer only

// Dialogs
#define DIALOG_BOAT_CREATE      9040
#define DIALOG_BOAT_EDIT_MENU   9041
#define DIALOG_BOAT_DELETE      9042
#define DIALOG_BOAT_LIST        9043
#define DIALOG_BOAT_EDIT_POS    9044

// Boat data
enum E_FISHING_BOAT
{
    bID,
    bZoneID,
    bZoneName[64],
    Float:bPosX,
    Float:bPosY,
    Float:bPosZ,
    Float:bPosA,
    bModelID,
    bCreatedBy,
    bool:bActive,
    bVehicleID,
    Text3D:bLabel
}

new FishingBoats[MAX_FISHING_BOATS][E_FISHING_BOAT];
new TotalFishingBoats = 0;
new PlayerEditingBoat[MAX_PLAYERS] = {-1, ...};

// Initialize boat data
stock InitBoatData()
{
    for(new i = 0; i < MAX_FISHING_BOATS; i++)
    {
        FishingBoats[i][bID] = 0;
        FishingBoats[i][bActive] = false;
        FishingBoats[i][bVehicleID] = INVALID_VEHICLE_ID;
        FishingBoats[i][bLabel] = Text3D:INVALID_3DTEXT_ID;
    }
    printf("[FISHING BOATS] Boat data initialized");
}

// Load boats from database
stock LoadFishingBoatsFromDB()
{
    InitBoatData();
    new query[256];
    format(query, sizeof(query),
        "SELECT * FROM fishing_boats WHERE is_active = 1 ORDER BY zone_id, id ASC");
    mysql_tquery(connectionID, query, "OnLoadBoats");
    printf("[FISHING BOATS] Loading boats from database...");
}

forward OnLoadBoats();
public OnLoadBoats()
{
    new rows = cache_get_row_count(connectionID);
    printf("[FISHING BOATS] OnLoadBoats callback - rows found: %d", rows);
    
    if(rows == 0)
    {
        printf("[FISHING BOATS] No boats found in database");
        return;
    }
    
    TotalFishingBoats = 0;
    for(new i = 0; i < rows && i < MAX_FISHING_BOATS; i++)
    {
        FishingBoats[i][bID] = cache_get_field_content_int(i, "id");
        FishingBoats[i][bZoneID] = cache_get_field_content_int(i, "zone_id");
        FishingBoats[i][bPosX] = cache_get_field_content_float(i, "pos_x");
        FishingBoats[i][bPosY] = cache_get_field_content_float(i, "pos_y");
        FishingBoats[i][bPosZ] = cache_get_field_content_float(i, "pos_z");
        FishingBoats[i][bPosA] = cache_get_field_content_float(i, "pos_a");
        FishingBoats[i][bModelID] = cache_get_field_content_int(i, "model_id");
        FishingBoats[i][bCreatedBy] = cache_get_field_content_int(i, "created_by");
        FishingBoats[i][bActive] = true;
        
        // Get zone name
        new zoneid = FishingBoats[i][bZoneID];
        format(FishingBoats[i][bZoneName], 64, "Unknown Zone");
        for(new z = 0; z < TotalZones; z++)
        {
            if(Zones[z][zID] == zoneid)
            {
                format(FishingBoats[i][bZoneName], 64, "%s", Zones[z][zName]);
                break;
            }
        }
        
        CreateBoatVehicle(i);
        
        TotalFishingBoats++;
    }
    printf("[FISHING BOATS] Successfully loaded %d boats from database", TotalFishingBoats);
}

// Create boat vehicle and label
stock CreateBoatVehicle(idx)
{
    if(idx < 0 || idx >= MAX_FISHING_BOATS) return;
    
    // Create vehicle
    FishingBoats[idx][bVehicleID] = CreateVehicle(FishingBoats[idx][bModelID],
        FishingBoats[idx][bPosX], FishingBoats[idx][bPosY], FishingBoats[idx][bPosZ],
        FishingBoats[idx][bPosA], -1, -1, 600000); // 600000 = respawn after 10 minutes if destroyed
    
    // Set vehicle health to full
    // The gamemode patch will ensure this is always 1000.0 for fishing boats
    SetVehicleHealth(FishingBoats[idx][bVehicleID], 1000.0);
    
    // Create 3D label attached to vehicle
    new labelText[128];
    format(labelText, sizeof(labelText),
        "{00BFFF}%s Boat {FFFFFF}(ID: {FFFF00}#%d{FFFFFF})\n{FFFFFF}Free to use\n{FFFF00}Press F/Enter to board",
        FishingBoats[idx][bZoneName], FishingBoats[idx][bID]);
    
    FishingBoats[idx][bLabel] = Create3DTextLabel(labelText, 0x00BFFFFF,
        0.0, 0.0, 0.0, 15.0, 0, 1);
    
    // Attach label to vehicle
    Attach3DTextLabelToVehicle(FishingBoats[idx][bLabel], FishingBoats[idx][bVehicleID], 0.0, 0.0, 1.0);
    
    printf("[FISHING BOATS] Created boat #%d (%s) (Vehicle ID: %d) for zone %d",
        FishingBoats[idx][bID], FishingBoats[idx][bZoneName], FishingBoats[idx][bVehicleID], FishingBoats[idx][bZoneID]);
}

// Destroy boat vehicle and label
stock DestroyBoatVehicle(idx)
{
    if(idx < 0 || idx >= MAX_FISHING_BOATS) return;
    
    if(FishingBoats[idx][bVehicleID] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(FishingBoats[idx][bVehicleID]);
        FishingBoats[idx][bVehicleID] = INVALID_VEHICLE_ID;
    }
    
    if(FishingBoats[idx][bLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(FishingBoats[idx][bLabel]);
        FishingBoats[idx][bLabel] = Text3D:INVALID_3DTEXT_ID;
    }
}

// Count boats in a zone
stock GetZoneBoatCount(zoneid)
{
    new count = 0;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bActive] && FishingBoats[i][bZoneID] == zoneid)
            count++;
    }
    return count;
}

// Admin commands
CMD:fishboat(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    if(adminLevel < 8)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Admin level 8+ required");
    
    new subcmd[32], boatid;
    if(sscanf(params, "s[32]D(-1)", subcmd, boatid))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "--- FISHING BOAT MANAGEMENT ---");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat create [zoneid] - Create boat at your position");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat delete [boatid]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat list [zoneid] - List boats in zone");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat goto [boatid]");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat move [boatid] - Move boat to your position");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat savepos [boatid] - Save current boat position");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat respawn [boatid] - Respawn boat");
        SendClientMessage(playerid, -1, "{FFFFFF}/fishboat respawnall - Respawn all boats");
        return 1;
    }
    
    if(!strcmp(subcmd, "create", true))
    {
        if(boatid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishboat create [zoneid]");
        return cmd_fishboat_create(playerid, boatid);
    }
    else if(!strcmp(subcmd, "delete", true))
    {
        if(boatid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishboat delete [boatid]");
        return cmd_fishboat_delete(playerid, boatid);
    }
    else if(!strcmp(subcmd, "list", true))
    {
        return cmd_fishboat_list(playerid, boatid);
    }
    else if(!strcmp(subcmd, "goto", true))
    {
        if(boatid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishboat goto [boatid]");
        return cmd_fishboat_goto(playerid, boatid);
    }
    else if(!strcmp(subcmd, "move", true))
    {
        if(boatid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishboat move [boatid]");
        return cmd_fishboat_move(playerid, boatid);
    }
    else if(!strcmp(subcmd, "savepos", true))
    {
        if(boatid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishboat savepos [boatid]");
        return cmd_fishboat_savepos(playerid, boatid);
    }
    else if(!strcmp(subcmd, "respawn", true))
    {
        if(boatid == -1) return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Usage: /fishboat respawn [boatid]");
        return cmd_fishboat_respawn(playerid, boatid);
    }
    else if(!strcmp(subcmd, "respawnall", true))
    {
        return cmd_fishboat_respawnall(playerid, "");
    }
    return 1;
}

cmd_fishboat_create(playerid, zoneid)
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
    
    // Check boat limit
    if(GetZoneBoatCount(zoneid) >= MAX_BOATS_PER_ZONE)
    {
        new string[128];
        format(string, sizeof(string), "{E74C3C}[ERROR]{FFFFFF} Zone already has maximum %d boats!", MAX_BOATS_PER_ZONE);
        return SendClientMessage(playerid, 0xE74C3CFF, string);
    }
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    new query[512];
    mysql_format(connectionID, query, sizeof(query),
        "INSERT INTO fishing_boats (zone_id, pos_x, pos_y, pos_z, pos_a, model_id, created_by) VALUES (%d, %f, %f, %f, %f, %d, %d)",
        zoneid, x, y, z, a, FISHING_BOAT_MODEL, playerid);
    
    mysql_tquery(connectionID, query, "OnCreateBoat", "iffffi", playerid, x, y, z, a, zoneid);
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Creating boat...");
    return 1;
}

forward OnCreateBoat(playerid, Float:x, Float:y, Float:z, Float:a, zoneid);
public OnCreateBoat(playerid, Float:x, Float:y, Float:z, Float:a, zoneid)
{
    new insert_id = cache_insert_id();
    if(insert_id > 0 && TotalFishingBoats < MAX_FISHING_BOATS)
    {
        new idx = TotalFishingBoats;
        FishingBoats[idx][bID] = insert_id;
        FishingBoats[idx][bZoneID] = zoneid;
        FishingBoats[idx][bPosX] = x;
        FishingBoats[idx][bPosY] = y;
        FishingBoats[idx][bPosZ] = z;
        FishingBoats[idx][bPosA] = a;
        FishingBoats[idx][bModelID] = FISHING_BOAT_MODEL;
        FishingBoats[idx][bCreatedBy] = playerid;
        FishingBoats[idx][bActive] = true;
        
        // Get zone name
        format(FishingBoats[idx][bZoneName], 64, "Unknown Zone");
        for(new z = 0; z < TotalZones; z++)
        {
            if(Zones[z][zID] == zoneid)
            {
                format(FishingBoats[idx][bZoneName], 64, "%s", Zones[z][zName]);
                break;
            }
        }
        
        CreateBoatVehicle(idx);
        TotalFishingBoats++;
        
        new string[128];
        format(string, sizeof(string),
            "{2ECC71}[FISHING]{FFFFFF} Boat created! ID: {00BFFF}#%d {FFFFFF}| Zone: {FFFF00}%s",
            insert_id, FishingBoats[idx][bZoneName]);
        SendClientMessage(playerid, -1, string);
    }
    else SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Failed to create boat!");
}

cmd_fishboat_delete(playerid, boatid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bID] == boatid && FishingBoats[i][bActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Boat not found!");
    
    // Delete from database
    new query[128];
    mysql_format(connectionID, query, sizeof(query),
        "DELETE FROM fishing_boats WHERE id = %d", boatid);
    mysql_tquery(connectionID, query);
    
    // Destroy vehicle
    DestroyBoatVehicle(idx);
    
    // Remove from memory
    for(new i = idx; i < TotalFishingBoats - 1; i++)
    {
        FishingBoats[i] = FishingBoats[i + 1];
    }
    TotalFishingBoats--;
    
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Boat deleted!");
    return 1;
}

cmd_fishboat_list(playerid, zoneid)
{
    if(zoneid == -1)
    {
        SendClientMessage(playerid, 0x00BFFFFF, "--- ALL FISHING BOATS ---");
        for(new i = 0; i < TotalFishingBoats; i++)
        {
            if(!FishingBoats[i][bActive]) continue;
            new string[256];
            format(string, sizeof(string), "{FFFFFF}Boat #{00BFFF}%d {FFFFFF}| Zone: {FFFF00}%d {FFFFFF}| Vehicle ID: {00FF00}%d",
                FishingBoats[i][bID], FishingBoats[i][bZoneID], FishingBoats[i][bVehicleID]);
            SendClientMessage(playerid, -1, string);
        }
    }
    else
    {
        new string[128];
        format(string, sizeof(string), "--- BOATS IN ZONE #%d ---", zoneid);
        SendClientMessage(playerid, 0x00BFFFFF, string);
        
        new count = 0;
        for(new i = 0; i < TotalFishingBoats; i++)
        {
            if(!FishingBoats[i][bActive] || FishingBoats[i][bZoneID] != zoneid) continue;
            format(string, sizeof(string), "{FFFFFF}Boat #{00BFFF}%d {FFFFFF}| Vehicle ID: {00FF00}%d",
                FishingBoats[i][bID], FishingBoats[i][bVehicleID]);
            SendClientMessage(playerid, -1, string);
            count++;
        }
        
        format(string, sizeof(string), "{FFFFFF}Total: {00BFFF}%d{FFFFFF}/%d boats", count, MAX_BOATS_PER_ZONE);
        SendClientMessage(playerid, -1, string);
    }
    return 1;
}

cmd_fishboat_goto(playerid, boatid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bID] == boatid && FishingBoats[i][bActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Boat not found!");
    
    SetPlayerPos(playerid, FishingBoats[idx][bPosX], FishingBoats[idx][bPosY], FishingBoats[idx][bPosZ] + 2.0);
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Teleported to boat!");
    return 1;
}

cmd_fishboat_move(playerid, boatid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bID] == boatid && FishingBoats[i][bActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Boat not found!");
    
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    // Just teleport the vehicle, don't save to database
    SetVehiclePos(FishingBoats[idx][bVehicleID], x, y, z);
    SetVehicleZAngle(FishingBoats[idx][bVehicleID], a);
    
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Boat moved to your position!");
    SendClientMessage(playerid, -1, "{FFFFFF}Use {FFFF00}/fishboat savepos [boatid]{FFFFFF} to save this position permanently.");
    return 1;
}

cmd_fishboat_respawn(playerid, boatid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bID] == boatid && FishingBoats[i][bActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Boat not found!");
    
    // Destroy and recreate the vehicle at saved position
    DestroyBoatVehicle(idx);
    CreateBoatVehicle(idx);
    
    SendClientMessage(playerid, 0x2ECC71FF, "{2ECC71}[FISHING]{FFFFFF} Boat respawned at saved position!");
    return 1;
}

cmd_fishboat_respawnall(playerid, params[])
{
    new count = 0, skipped = 0;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(!FishingBoats[i][bActive]) continue;
        
        // Skip boats that are occupied (player inside or near)
        if(IsBoatOccupied(i))
        {
            skipped++;
            continue;
        }
        
        // Destroy and recreate each unoccupied vehicle at saved position
        DestroyBoatVehicle(i);
        CreateBoatVehicle(i);
        count++;
    }
    
    new string[128];
    if(skipped > 0)
    {
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Respawned %d boats. Skipped %d occupied boats.", count, skipped);
    }
    else
    {
        format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} Respawned %d boats at their saved positions!", count);
    }
    SendClientMessage(playerid, -1, string);
    return 1;
}

cmd_fishboat_savepos(playerid, boatid)
{
    new idx = -1;
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bID] == boatid && FishingBoats[i][bActive])
        {
            idx = i;
            break;
        }
    }
    
    if(idx == -1)
        return SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} Boat not found!");
    
    // Check if player is in the boat
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid != FishingBoats[idx][bVehicleID])
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]{FFFFFF} You must be driving this boat to save its position!");
        return 1;
    }
    
    // Get current vehicle position and angle
    new Float:x, Float:y, Float:z, Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    
    // Update boat data
    FishingBoats[idx][bPosX] = x;
    FishingBoats[idx][bPosY] = y;
    FishingBoats[idx][bPosZ] = z;
    FishingBoats[idx][bPosA] = a;
    
    // Update database
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "UPDATE fishing_boats SET pos_x = %f, pos_y = %f, pos_z = %f, pos_a = %f WHERE id = %d",
        x, y, z, a, boatid);
    mysql_tquery(connectionID, query);
    
    new string[128];
    format(string, sizeof(string), 
        "{2ECC71}[FISHING]{FFFFFF} Boat position saved! Pos: (%.2f, %.2f, %.2f) Angle: %.2f",
        x, y, z, a);
    SendClientMessage(playerid, -1, string);
    SendClientMessage(playerid, -1, "{FFFFFF}The boat will respawn at this position.");
    
    return 1;
}

// Cleanup
stock CleanupBoats()
{
    for(new i = 0; i < TotalFishingBoats; i++)
        DestroyBoatVehicle(i);
    printf("[FISHING BOATS] Cleaned up %d boats", TotalFishingBoats);
}


// Helper function to check if vehicle is a fishing boat
stock IsFishingBoat(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bActive] && FishingBoats[i][bVehicleID] == vehicleid)
            return 1;
    }
    return 0;
}

// Get fishing boat index by vehicle ID
stock GetFishingBoatIndex(vehicleid)
{
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(FishingBoats[i][bActive] && FishingBoats[i][bVehicleID] == vehicleid)
            return i;
    }
    return -1;
}



// Check if boat has any players (inside or standing on deck)
stock IsBoatOccupied(idx)
{
    if(idx < 0 || idx >= MAX_FISHING_BOATS) return 0;
    if(!FishingBoats[idx][bActive]) return 0;
    
    new vehicleid = FishingBoats[idx][bVehicleID];
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    
    // Check if any player is inside the boat (driver/passenger)
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        
        // Check if player is inside the boat
        if(GetPlayerVehicleID(i) == vehicleid)
            return 1;
        
        // Check if player is standing on the boat deck (on foot, near boat)
        if(GetPlayerState(i) == PLAYER_STATE_ONFOOT)
        {
            new Float:px, Float:py, Float:pz;
            GetPlayerPos(i, px, py, pz);
            
            new Float:boatX, Float:boatY, Float:boatZ, Float:boatAngle;
            GetVehiclePos(vehicleid, boatX, boatY, boatZ);
            GetVehicleZAngle(vehicleid, boatAngle);
            
            // Rectangular detection: boat is longer (front/back) than wide (sides)
            // Width (sides/localX): 2.5 units, Length (front/back/localY): 5.2 units
            // Offset: 1.0 units (shift detection area towards back/deck)
            new Float:halfWidth = 2.5;   // X-axis (sides)
            new Float:halfLength = 5.3;  // Y-axis (front/back)
            new Float:offsetY = 1.0;    // Positive = towards back (where deck is)
            
            // Rotate player position relative to boat angle
            new Float:dx = px - boatX;
            new Float:dy = py - boatY;
            new Float:angleRad = -boatAngle * 3.14159 / 180.0;
            new Float:localX = dx * floatcos(angleRad, degrees) - dy * floatsin(angleRad, degrees);
            new Float:localY = (dx * floatsin(angleRad, degrees) + dy * floatcos(angleRad, degrees)) - offsetY;
            
            // Check if player is within rectangular bounds and above boat
            if(floatabs(localX) <= halfWidth && floatabs(localY) <= halfLength && pz >= boatZ && pz <= (boatZ + 5.0))
                return 1; // Player is standing on boat deck
        }
    }
    return 0;
}