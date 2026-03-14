/*
    ================================================================
    
    FISHING RPG SYSTEM - MASTER FILE
    Complete RPG-style fishing system with progression and economy
    
    Features:
    • 6 Fishing Rods with progressive bonuses
    • 5 Bait types with different effects
    • 4 Fishing Zones with unique fish
    • 30+ Fish species with rarity system
    • Weight-based pricing and leaderboards
    • Time-of-day bonuses
    • Combo catch system
    • Daily quest system
    • Fishing tournaments
    • Token economy
    • Gang turf integration
    • Experience & leveling (100 levels)
    
    ================================================================
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>
#include <audio-plugin>

// ============================================
// EXTERNAL VARIABLES FROM GAMEMODE
// ============================================

// MySQL connection handle from gamemode
new connectionID = 0; // Initialize to 0, will be set by gamemode

// Function to set MySQL handle from gamemode
forward SetFishingMySQLHandle(handle);
public SetFishingMySQLHandle(handle)
{
    connectionID = handle;
    printf("[FISHING] MySQL handle set: %d", connectionID);
    
    // Initialize the fishing system now that we have MySQL
    InitializeFishingSystem();
    
    // Test the connection immediately
    new testQuery[128];
    format(testQuery, sizeof(testQuery), "SELECT COUNT(*) as total FROM players");
    mysql_tquery(connectionID, testQuery, "OnTestMySQLConnection");
    
    return 1;
}

forward OnTestMySQLConnection();
public OnTestMySQLConnection()
{
    if(cache_get_row_count(connectionID))
    {
        new total = cache_get_field_content_int(0, "total");
        printf("[FISHING] MySQL connection test SUCCESS - Total players in table: %d", total);
    }
    else
    {
        printf("[FISHING] MySQL connection test FAILED - Cannot access players table!");
        printf("[FISHING] Make sure the 'players' table exists in your database!");
    }
}

// Player info array from gamemode
enum pInfo {
    pAdmin,
    // Add other fields as needed
}
new PlayerInfo[MAX_PLAYERS][pInfo];

// ============================================
// INCLUDE ALL FISHING MODULES
// ============================================

#include "fishing_data_structures.inc"
#include "fishing_zones_manager.inc"
#include "fishing_boats.inc"
#include "fishing_actors.inc"
#include "fishing_core.inc"
#include "fishing_equipment.inc"
#include "fishing_catch.inc"
#include "fishing_audio.inc"
// #include "fishing_zones.inc" // REMOVED - Using database zones only
#include "fishing_quests.inc"
#include "fishing_tournament.inc"
#include "fishing_leaderboard.inc"
#include "fishing_profile.inc"

// ============================================
// FILTERSCRIPT CALLBACKS
// ============================================

public OnFilterScriptInit()
{
    print("\n================================================================");
    print("  FISHING RPG SYSTEM v1.0");
    print("  Loading...");
    print("  WAITING FOR MYSQL CONNECTION FROM GAMEMODE...");
    print("================================================================\n");
    
    // Don't initialize yet, wait for MySQL handle
    // InitializeFishingSystem() will be called after MySQL is set
    
    // Start boat checkpoint checker timer (runs every second)
    SetTimer("CheckBoatCheckpoints", 1000, true);
    
    return 1;
}

public OnFilterScriptExit()
{
    CleanupZones();  // Cleanup zone visuals
    CleanupBoats();  // Cleanup boats
    CleanupActors(); // Cleanup actors
    
    print("\n================================================================");
    print("  FISHING RPG SYSTEM - UNLOADED");
    print("================================================================\n");
    
    return 1;
}

public OnPlayerConnect(playerid)
{
    ResetPlayerFishingData(playerid);
    ShowFishingZonesToPlayer(playerid); // Show all fishing zones on map
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerFishingData(playerid);
    OnPlayerDisconnectZonePreview(playerid); // Cleanup zone preview
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    // When player enters a vehicle
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        
        // Check if it's a fishing boat
        if(IsFishingBoat(vehicleid))
        {
            new Float:health;
            GetVehicleHealth(vehicleid, health);
            
            new boatIdx = GetFishingBoatIndex(vehicleid);
            
            printf("[FISHING BOAT DEBUG] Player %d entered fishing boat", playerid);
            printf("[FISHING BOAT DEBUG] Vehicle ID: %d | Boat Index: %d", vehicleid, boatIdx);
            printf("[FISHING BOAT DEBUG] Vehicle Health: %.2f", health);
            
            // Send message to player
            SendClientMessage(playerid, 0x2ECC71FF, 
                "{2ECC71}[FISHING BOAT]{FFFFFF} This boat is protected from damage!");
        }
    }
    // When player exits a vehicle (becomes on foot or other state)
    else if((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && 
            (newstate == PLAYER_STATE_ONFOOT || newstate == PLAYER_STATE_WASTED || newstate == PLAYER_STATE_SPAWNED))
    {
        // Just log the exit, but DON'T stop protection
        // Debug: Check which boat the player exited
        for(new i = 0; i < TotalFishingBoats; i++)
        {
            if(FishingBoats[i][bActive])
            {
                printf("[FISHING BOAT DEBUG] Player %d exited boat index %d, protection continues via gamemode patch", playerid, i);
            }
        }
    }
    
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Y key (YES key) - Interact with fishing actors
    if(newkeys & KEY_YES)
    {
        new actoridx = CheckPlayerNearActor(playerid);
        if(actoridx != -1)
        {
            ShowActorInteractionMenu(playerid, actoridx);
            return 1;
        }
    }
    return 1;
}

// Public function for CallRemoteFunction from other filterscripts
forward IsPlayerOnFishingBoat(playerid);
public IsPlayerOnFishingBoat(playerid)
{
    // Must be on foot
    new playerState = GetPlayerState(playerid);
    if(playerState != PLAYER_STATE_ONFOOT)
    {
        printf("[BOAT CHECK] Player %d not on foot (state: %d)", playerid, playerState);
        return 0;
    }
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    printf("[BOAT CHECK] Player %d pos: %.2f, %.2f, %.2f | Total boats: %d", playerid, x, y, z, TotalFishingBoats);
    
    // Check all fishing boats to see if player is standing on one
    for(new i = 0; i < TotalFishingBoats; i++)
    {
        if(!FishingBoats[i][bActive]) continue;
        if(FishingBoats[i][bVehicleID] == INVALID_VEHICLE_ID) continue;
        
        new Float:boatX, Float:boatY, Float:boatZ, Float:boatAngle;
        GetVehiclePos(FishingBoats[i][bVehicleID], boatX, boatY, boatZ);
        GetVehicleZAngle(FishingBoats[i][bVehicleID], boatAngle);
        
        // Rectangular detection: boat is longer (front/back) than wide (sides)
        // Width (sides/localX): 2.5 units, Length (front/back/localY): 5.2 units
        // Offset: 1.0 units (shift detection area towards back/deck)
        new Float:halfWidth = 2.5;   // X-axis (sides)
        new Float:halfLength = 5.3;  // Y-axis (front/back)
        new Float:offsetY = 1.0;    // Positive = towards back (where deck is)
        
        // Rotate player position relative to boat angle
        new Float:dx = x - boatX;
        new Float:dy = y - boatY;
        new Float:angleRad = -boatAngle * 3.14159 / 180.0;
        new Float:localX = dx * floatcos(angleRad, degrees) - dy * floatsin(angleRad, degrees);
        new Float:localY = (dx * floatsin(angleRad, degrees) + dy * floatcos(angleRad, degrees)) - offsetY;
        
        printf("[BOAT CHECK] Boat #%d (VID:%d) pos: %.2f, %.2f, %.2f | Angle: %.2f | LocalPos: %.2f, %.2f | Z-diff: %.2f", 
            FishingBoats[i][bID], FishingBoats[i][bVehicleID], boatX, boatY, boatZ, boatAngle, localX, localY, z - boatZ);
        
        // Check if player is within rectangular bounds and above boat
        if(floatabs(localX) <= halfWidth && floatabs(localY) <= halfLength && z >= boatZ && z <= (boatZ + 5.0))
        {
            printf("[BOAT CHECK] Player %d IS ON fishing boat #%d!", playerid, FishingBoats[i][bID]);
            return 1; // Player is on a fishing boat
        }
    }
    
    printf("[BOAT CHECK] Player %d NOT on any fishing boat", playerid);
    return 0; // Player is not on any fishing boat
}

// ============================================
// BOAT CHECKPOINT SYSTEM
// ============================================

forward CheckBoatCheckpoints();
public CheckBoatCheckpoints()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid)) continue;
        
        // Skip checkpoint checking if player is currently fishing (wait state or minigame active)
        // This prevents performance issues during fishing
        new isWaiting = CallRemoteFunction("IsPlayerInFishingWaitState", "i", playerid);
        if(isWaiting || PlayerFishingData[playerid][pIsFishing])
        {
            continue;
        }
        
        // Check if player is on a fishing boat
        new bool:onBoat = false;
        new boatZoneID = -1;
        new playerState = GetPlayerState(playerid);
        
        // Check if on foot (standing on boat deck)
        if(playerState == PLAYER_STATE_ONFOOT)
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            
            // Check all fishing boats
            for(new i = 0; i < TotalFishingBoats; i++)
            {
                if(!FishingBoats[i][bActive]) continue;
                if(FishingBoats[i][bVehicleID] == INVALID_VEHICLE_ID) continue;
                
                new Float:boatX, Float:boatY, Float:boatZ, Float:boatAngle;
                GetVehiclePos(FishingBoats[i][bVehicleID], boatX, boatY, boatZ);
                GetVehicleZAngle(FishingBoats[i][bVehicleID], boatAngle);
                
                // Same rectangular detection as IsPlayerOnFishingBoat
                new Float:halfWidth = 2.5;
                new Float:halfLength = 5.3;
                new Float:offsetY = 1.0;
                
                new Float:dx = x - boatX;
                new Float:dy = y - boatY;
                new Float:angleRad = -boatAngle * 3.14159 / 180.0;
                new Float:localX = dx * floatcos(angleRad, degrees) - dy * floatsin(angleRad, degrees);
                new Float:localY = (dx * floatsin(angleRad, degrees) + dy * floatcos(angleRad, degrees)) - offsetY;
                
                if(floatabs(localX) <= halfWidth && floatabs(localY) <= halfLength && z >= boatZ && z <= (boatZ + 5.0))
                {
                    onBoat = true;
                    boatZoneID = FishingBoats[i][bZoneID];
                    break;
                }
            }
        }
        // Check if driving or passenger in fishing boat
        else if(playerState == PLAYER_STATE_DRIVER || playerState == PLAYER_STATE_PASSENGER)
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                // Check if this vehicle is a fishing boat
                for(new i = 0; i < TotalFishingBoats; i++)
                {
                    if(FishingBoats[i][bActive] && FishingBoats[i][bVehicleID] == vehicleid)
                    {
                        onBoat = true;
                        boatZoneID = FishingBoats[i][bZoneID];
                        break;
                    }
                }
            }
        }
        
        // Update checkpoint based on boat status
        if(onBoat && boatZoneID != -1)
        {
            // Player is on boat - set checkpoint if not already set or zone changed
            if(!PlayerFishingData[playerid][pBoatCheckpointActive] || PlayerFishingData[playerid][pBoatCheckpointZoneID] != boatZoneID)
            {
                // Find the zone
                new zoneIdx = -1;
                for(new z = 0; z < TotalZones; z++)
                {
                    if(Zones[z][zID] == boatZoneID)
                    {
                        zoneIdx = z;
                        break;
                    }
                }
                
                if(zoneIdx != -1)
                {
                    SetPlayerCheckpoint(playerid, Zones[zoneIdx][zPosX], Zones[zoneIdx][zPosY], Zones[zoneIdx][zPosZ], 3.0);
                    PlayerFishingData[playerid][pBoatCheckpointActive] = true;
                    PlayerFishingData[playerid][pBoatCheckpointZoneID] = boatZoneID;
                }
            }
        }
        else
        {
            // Player is NOT on boat - remove checkpoint if active
            if(PlayerFishingData[playerid][pBoatCheckpointActive])
            {
                DisablePlayerCheckpoint(playerid);
                PlayerFishingData[playerid][pBoatCheckpointActive] = false;
                PlayerFishingData[playerid][pBoatCheckpointZoneID] = -1;
            }
        }
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    printf("[FISHING DEBUG] OnDialogResponse called - dialogid: %d", dialogid);
    printf("[FISHING DEBUG] DIALOG_FISHING_PROFILE=%d, DIALOG_FISHING_HELP=%d", DIALOG_FISHING_PROFILE, DIALOG_FISHING_HELP);
    
    // Forward to equipment module for fishing shop dialogs
    if(dialogid >= DIALOG_FISHING_SHOP_MAIN && dialogid <= DIALOG_FISHING_BUY_CONFIRM)
    {
        printf("[FISHING DEBUG] Forwarding to equipment dialog handler");
        return OnFishingEquipmentDialogResponse(playerid, dialogid, response, listitem, inputtext);
    }
    
    // Zone manager dialogs (including create type dialog 9009)
    if((dialogid >= DIALOG_FISHZONE_CREATE_TYPE && dialogid <= DIALOG_FISHZONE_EDIT_TIME) || dialogid == DIALOG_FISHZONE_CREATE)
    {
        printf("[FISHING DEBUG] Forwarding to zone dialog handler - dialogid=%d", dialogid);
        return OnFishZoneDialogResponse(playerid, dialogid, response, listitem, inputtext);
    }
    
    // Boat dialogs
    if(dialogid >= DIALOG_BOAT_CREATE && dialogid <= DIALOG_BOAT_EDIT_POS)
    {
        // Boat dialogs are handled in commands, no dialog response needed
        return 1;
    }
    
    // Actor dialogs
    if(dialogid >= DIALOG_ACTOR_CREATE && dialogid <= DIALOG_ACTOR_SELL_CONFIRM)
    {
        printf("[FISHING DEBUG] Forwarding to actor dialog handler");
        return OnFishActorDialogResponse(playerid, dialogid, response, listitem, inputtext);
    }
    
    // Profile/Inventory dialogs (9020-9024)
    printf("[FISHING DEBUG] Checking profile dialogs: %d >= %d && %d <= %d", dialogid, DIALOG_FISHING_PROFILE, dialogid, DIALOG_FISHING_HELP);
    if(dialogid >= DIALOG_FISHING_PROFILE && dialogid <= DIALOG_FISHING_HELP)
    {
        printf("[FISHING DEBUG] Forwarding to profile dialog handler");
        return OnFishingProfileDialogResponse(playerid, dialogid, response, listitem, inputtext);
    }
    
    printf("[FISHING DEBUG] Dialog not handled by fishing system");
    return 0;
}

// ============================================
// HELPER COMMANDS
// ============================================

CMD:fishhelp(playerid, params[])
{
    new adminLevel = CallRemoteFunction("GetPlayerAdminLevel", "i", playerid);
    
    new dialog[2048];
    format(dialog, sizeof(dialog),
        "{3498DB}FISHING SYSTEM COMMANDS\n\n\
        {FFFFFF}/fish {95A5A6}- Start fishing\n\
        {FFFFFF}/fishprofile {95A5A6}- View your fishing profile & inventory\n\
        {FFFFFF}/myfish {95A5A6}- View your fish inventory\n\
        {FFFFFF}/fishstats [playerid] {95A5A6}- View fishing stats\n\
        {FFFFFF}/fishquest {95A5A6}- View daily quest\n\
        {FFFFFF}/fishzone info {95A5A6}- View current zone info\n\
        {FFFFFF}/fishzone list {95A5A6}- List all fishing zones\n\
        {FFFFFF}/fishtop [total/weight/legendary] {95A5A6}- Leaderboards\n\
        {FFFFFF}/tournamentstatus {95A5A6}- View tournament status\n\
        {FFFFFF}/tournamentleaders {95A5A6}- Tournament leaderboard\n\n\
        {2ECC71}FISHING ACTOR SERVICES\n\
        {FFFFFF}Press {FFFF00}Y{FFFFFF} near fishing actors to:\n\
        {FFFFFF}  Sell Fish {FFFF00}(/sellfish)\n\
        {FFFFFF}  Fishing Shop {FFFF00}(/fishingshop)\n\n\
        {00BFFF}FISHING BOATS\n\
        {FFFFFF}Free boats available at fishing zones\n\
        {FFFFFF}Look for {00BFFF}Reefer{FFFFFF} boats near actors");
    
    // Add admin commands if player is admin level 8+
    if(adminLevel >= 8)
    {
        strcat(dialog, "\n\n{F39C12}ADMIN COMMANDS (Level 8+)\n\n");
        strcat(dialog, "{FFFF00}ZONE MANAGEMENT\n");
        strcat(dialog, "{FFFFFF}/fishzone create {95A5A6}- Create new zone\n");
        strcat(dialog, "{FFFFFF}/fishzone edit [id] {95A5A6}- Edit zone\n");
        strcat(dialog, "{FFFFFF}/fishzone delete [id] {95A5A6}- Delete zone\n");
        strcat(dialog, "{FFFFFF}/fishzone goto [id] {95A5A6}- Teleport to zone\n\n");
        strcat(dialog, "{00BFFF}BOAT MANAGEMENT\n");
        strcat(dialog, "{FFFFFF}/fishboat create [zoneid] {95A5A6}- Create boat\n");
        strcat(dialog, "{FFFFFF}/fishboat delete [boatid] {95A5A6}- Delete boat\n");
        strcat(dialog, "{FFFFFF}/fishboat list [zoneid] {95A5A6}- List boats\n");
        strcat(dialog, "{FFFFFF}/fishboat move [boatid] {95A5A6}- Move boat\n");
        strcat(dialog, "{FFFFFF}/fishboat respawnall {95A5A6}- Respawn all boats\n\n");
        strcat(dialog, "{2ECC71}ACTOR MANAGEMENT\n");
        strcat(dialog, "{FFFFFF}/fishactor create [zoneid] {95A5A6}- Create actor\n");
        strcat(dialog, "{FFFFFF}/fishactor edit [actorid] {95A5A6}- Edit actor\n");
        strcat(dialog, "{FFFFFF}/fishactor delete [actorid] {95A5A6}- Delete actor\n");
        strcat(dialog, "{FFFFFF}/fishactor list [zoneid] {95A5A6}- List actors\n");
        strcat(dialog, "{FFFFFF}/fishactor move [actorid] {95A5A6}- Move actor");
    }
    
    ShowPlayerDialog(playerid, DIALOG_FISHING_HELP, DIALOG_STYLE_MSGBOX,
        "{3498DB}Fishing System Help", dialog, "Close", "");
    
    return 1;
}

CMD:fishinfo(playerid, params[])
{
    new string[512];
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    SendClientMessage(playerid, -1, "{3498DB}[FISHING SYSTEM INFO]");
    
    format(string, sizeof(string), 
        "{FFFFFF}• {2ECC71}%d {FFFFFF}Fishing Rods available", TotalFishingRods);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}• {2ECC71}%d {FFFFFF}Bait types available", TotalFishingBait);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}• {2ECC71}%d {FFFFFF}Fishing Zones (Admin Managed)", TotalZones);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}• {2ECC71}%d {FFFFFF}Fish Species", TotalFishSpecies);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}• {2ECC71}%d {FFFFFF}Daily Quests", TotalDailyQuests);
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, -1, "{FFFFFF}Features:");
    SendClientMessage(playerid, -1, "{FFFFFF}  • Rarity System (Common to Legendary)");
    SendClientMessage(playerid, -1, "{FFFFFF}  • Weight-based pricing");
    SendClientMessage(playerid, -1, "{FFFFFF}  • Time-of-day bonuses");
    SendClientMessage(playerid, -1, "{FFFFFF}  • Combo catch system");
    SendClientMessage(playerid, -1, "{FFFFFF}  • Fishing tournaments");
    SendClientMessage(playerid, -1, "{FFFFFF}  • Token economy");
    SendClientMessage(playerid, -1, "{FFFFFF}  • 100 levels of progression");
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    
    return 1;
}

CMD:myfish(playerid, params[])
{
    // Show player's fish inventory
    new query[256], queryStr[128];
    format(queryStr, sizeof(queryStr),
        "SELECT * FROM fishing_inventory WHERE player_id = %d ORDER BY caught_at DESC LIMIT 20",
        PlayerFishingData[playerid][pFishingDBID]);
    mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
    
    mysql_tquery(connectionID, query, "OnShowFishInventory", "i", playerid);
    return 1;
}

forward OnShowFishInventory(playerid);
public OnShowFishInventory(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, 
            "{E74C3C}[FISHING]{FFFFFF} You don't have any fish in your inventory!");
        return 1;
    }
    
    new string[256], temp1[64], temp2[16], temp3[64];
    new Float:weight, value, totalValue = 0;
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    SendClientMessage(playerid, -1, "{3498DB}[YOUR FISH INVENTORY]");
    
    for(new i = 0; i < rows; i++)
    {
        cache_get_field_content(i, "fish_name", temp1, connectionID, 64);
        cache_get_field_content(i, "fish_rarity", temp2, connectionID, 16);
        weight = cache_get_field_content_float(i, "fish_weight");
        value = cache_get_field_content_int(i, "fish_value");
        totalValue += value;
        
        new rarityColor[16];
        if(!strcmp(temp2, "legendary", true)) format(rarityColor, sizeof(rarityColor), "{F39C12}");
        else if(!strcmp(temp2, "rare", true)) format(rarityColor, sizeof(rarityColor), "{9B59B6}");
        else if(!strcmp(temp2, "uncommon", true)) format(rarityColor, sizeof(rarityColor), "{3498DB}");
        else format(rarityColor, sizeof(rarityColor), "{95A5A6}");
        
        format(string, sizeof(string), 
            "{FFFFFF}%d. %s%s {FFFFFF}(%.2fkg) - {2ECC71}$%d",
            i+1, rarityColor, temp1, weight, value);
        SendClientMessage(playerid, -1, string);
    }
    
    format(string, sizeof(string), 
        "{FFFFFF}Total Fish: {3498DB}%d {FFFFFF}| Total Value: {2ECC71}$%d",
        rows, totalValue);
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, -1, "{FFFFFF}Use /sellfish to sell all your fish!");
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    
    return 1;
}

CMD:sellfish(playerid, params[])
{
    // Check if player is near a fishing actor
    new actoridx = CheckPlayerNearActor(playerid);
    if(actoridx == -1)
    {
        SendClientMessage(playerid, 0xE74C3CFF, 
            "{E74C3C}[FISHING]{FFFFFF} You must be near a fishing actor to sell fish!");
        SendClientMessage(playerid, -1, 
            "{FFFFFF}Press {FFFF00}Y{FFFFFF} near a fishing actor to access services.");
        return 1;
    }
    
    // Sell all fish in inventory
    new query[256], queryStr[128];
    format(queryStr, sizeof(queryStr),
        "SELECT SUM(fish_value) as total_value, COUNT(*) as fish_count FROM fishing_inventory WHERE player_id = %d",
        PlayerFishingData[playerid][pFishingDBID]);
    mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
    
    mysql_tquery(connectionID, query, "OnSellFish", "i", playerid);
    return 1;
}

forward OnSellFish(playerid);
public OnSellFish(playerid)
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
    
    // Give money to player (call gamemode function)
    CallRemoteFunction("GivePlayerCashEx", "ii", playerid, totalValue);
    
    // Delete sold fish from inventory
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "DELETE FROM fishing_inventory WHERE player_id = %d",
        PlayerFishingData[playerid][pFishingDBID]);
    
    mysql_tquery(connectionID, query);
    
    // Show success message
    new string[128];
    format(string, sizeof(string), 
        "{2ECC71}[FISHING]{FFFFFF} You sold {3498DB}%d fish {FFFFFF}for {2ECC71}$%d{FFFFFF}!",
        fishCount, totalValue);
    SendClientMessage(playerid, -1, string);
    
    GameTextForPlayer(playerid, "~g~FISH SOLD!", 2000, 3);
    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
    
    printf("[FISHING] Player %d sold %d fish for $%d", playerid, fishCount, totalValue);
    
    return 1;
}

// ============================================
// UTILITY FUNCTIONS
// ============================================

stock GetPlayerNameEx(playerid, name[], size = 24)
{
    GetPlayerName(playerid, name, size);
    return 1;
}

// ============================================
// GAMEMODE INTEGRATION - PUBLIC FUNCTIONS
// ============================================

// These functions can be called from the main gamemode using CallRemoteFunction

forward GetPlayerDatabaseID(playerid);
public GetPlayerDatabaseID(playerid)
{
    // This will be called from gamemode to get user_id
    // The gamemode should call: CallRemoteFunction("OnRequestUserID", "ii", playerid, user_id);
    return 0; // Not used directly, gamemode will send user_id via callback
}

forward OnPlayerLoginFishing(playerid, user_id);
public OnPlayerLoginFishing(playerid, user_id)
{
    printf("[FISHING DEBUG] OnPlayerLoginFishing called - playerid: %d, user_id: %d", playerid, user_id);
    
    // Called from gamemode when player logs in
    // Gamemode should call: CallRemoteFunction("OnPlayerLoginFishing", "ii", playerid, user_id);
    CheckOrCreateFishingPlayer(playerid, user_id);
    return 1;
}

stock CheckOrCreateFishingPlayer(playerid, user_id)
{
    printf("[FISHING DEBUG] CheckOrCreateFishingPlayer - playerid: %d, user_id: %d", playerid, user_id);
    printf("[FISHING DEBUG] MySQL connectionID: %d", connectionID);
    
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT id, user_id, username, fishing_level FROM players WHERE user_id = %d", user_id);
    
    printf("[FISHING DEBUG] Executing query: %s", query);
    
    mysql_tquery(connectionID, query, "OnCheckFishingPlayer", "ii", playerid, user_id);
}

forward OnTestQuery(playerid);
public OnTestQuery(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows > 0)
    {
        new total = cache_get_field_content_int(0, "total");
        printf("[FISHING DEBUG] Test query - Total players in table: %d", total);
    }
    else
    {
        printf("[FISHING DEBUG] Test query - Failed to get count!");
    }
}

forward OnCheckFishingPlayer(playerid, user_id);
public OnCheckFishingPlayer(playerid, user_id)
{
    printf("[FISHING DEBUG] OnCheckFishingPlayer callback - playerid: %d, user_id: %d", playerid, user_id);
    printf("[FISHING DEBUG] MySQL connectionID in callback: %d", connectionID);
    
    new rows = cache_get_row_count(connectionID);
    
    printf("[FISHING DEBUG] OnCheckFishingPlayer - Rows returned: %d", rows);
    
    if(rows > 0)
    {
        // Debug: Print what we found
        new id = cache_get_field_content_int(0, "id");
        new found_user_id = cache_get_field_content_int(0, "user_id");
        new username[24];
        cache_get_field_content(0, "username", username, connectionID, 24);
        new fishing_level = cache_get_field_content_int(0, "fishing_level");
        
        printf("[FISHING DEBUG] Found player - id: %d, user_id: %d, username: %s, fishing_level: %d", 
            id, found_user_id, username, fishing_level);
    }
    
    if(rows == 0)
    {
        printf("[FISHING DEBUG] No fishing player found in players table, creating new one...");
        
        // Create fishing player with direct INSERT
        new username[24], query[512];
        GetPlayerName(playerid, username, 24);
        
        // Insert new player with default fishing values (no equipment)
        mysql_format(connectionID, query, sizeof(query),
            "INSERT INTO players (user_id, username, fishing_level, fishing_exp, fishing_tokens, fishing_rod_id, fishing_bait_id, fishing_bait_amount, fishing_combo, fishing_total_caught, fishing_biggest_weight, fishing_legendary_count, fishing_daily_quest_id, fishing_daily_progress, fishing_daily_completed) VALUES (%d, '%e', 1, 0, 0, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0)",
            user_id, username);
        
        printf("[FISHING DEBUG] Executing INSERT query: %s", query);
        
        mysql_tquery(connectionID, query, "OnCreateFishingPlayer", "ii", playerid, user_id);
    }
    else
    {
        printf("[FISHING DEBUG] Fishing player exists in players table, loading data...");
        
        // Load fishing data
        LoadPlayerFishingData(playerid, user_id);
    }
}

forward OnInitializeFishingData(playerid, user_id);
public OnInitializeFishingData(playerid, user_id)
{
    printf("[FISHING DEBUG] OnInitializeFishingData callback - playerid: %d, user_id: %d", playerid, user_id);
    
    // Now load the fishing data
    LoadPlayerFishingData(playerid, user_id);
    
    // Assign daily quest
    AssignDailyQuest(playerid);
    
    SendClientMessage(playerid, 0x2ECC71FF, 
        "{2ECC71}[FISHING]{FFFFFF} Welcome to the fishing system! Type /fishhelp");
    
    SendClientMessage(playerid, 0xF39C12FF,
        "{F39C12}[FISHING]{FFFFFF} Visit /fishingshop to buy your first rod and bait!");
}

forward OnCreateFishingPlayer(playerid, user_id);
public OnCreateFishingPlayer(playerid, user_id)
{
    printf("[FISHING DEBUG] OnCreateFishingPlayer callback - playerid: %d, user_id: %d", playerid, user_id);
    
    new insert_id = cache_insert_id();
    printf("[FISHING DEBUG] OnCreateFishingPlayer - Insert ID: %d", insert_id);
    
    if(insert_id > 0)
    {
        // Store the database ID immediately
        PlayerFishingData[playerid][pFishingDBID] = insert_id;
        
        // Initialize with default values (same as what was inserted)
        PlayerFishingData[playerid][pFishingLevel] = 1;
        PlayerFishingData[playerid][pFishingExp] = 0;
        PlayerFishingData[playerid][pFishingTokens] = 0;
        PlayerFishingData[playerid][pFishingRodID] = 0;
        PlayerFishingData[playerid][pFishingBaitID] = 0;
        PlayerFishingData[playerid][pFishingBaitAmount] = 0;
        PlayerFishingData[playerid][pFishingCombo] = 0;
        PlayerFishingData[playerid][pFishingTotalCaught] = 0;
        PlayerFishingData[playerid][pFishingBiggestWeight] = 0.0;
        PlayerFishingData[playerid][pFishingLegendaryCount] = 0;
        PlayerFishingData[playerid][pDailyQuestID] = 0;
        PlayerFishingData[playerid][pDailyQuestProgress] = 0;
        PlayerFishingData[playerid][pDailyQuestCompleted] = false;
        
        // Assign daily quest
        AssignDailyQuest(playerid);
        
        printf("[FISHING] Created new fishing player - playerid: %d, DB ID: %d", playerid, insert_id);
        
        SendClientMessage(playerid, 0x2ECC71FF, 
            "{2ECC71}[FISHING]{FFFFFF} Welcome to the fishing system! Type /fishhelp");
        
        SendClientMessage(playerid, 0xF39C12FF,
            "{F39C12}[FISHING]{FFFFFF} Visit /fishingshop to buy your first rod and bait!");
    }
    else
    {
        printf("[FISHING] ERROR: Failed to create fishing player for user_id %d", user_id);
    }
}

// ============================================
// HELPER FUNCTIONS FOR EXTERNAL CALLS
// ============================================

forward GetPlayerFishingRod(playerid);
public GetPlayerFishingRod(playerid)
{
    return PlayerFishingData[playerid][pFishingRodID];
}

// Note: GetPlayerFishingBait, ConsumeFishingBait, and BreakFishingCombo
// are now defined in fishing_core.inc

// ============================================
// NOTES FOR INTEGRATION
// ============================================

/*
    TO INTEGRATE WITH YOUR GAMEMODE:
    
    1. Add to server.cfg:
       filterscripts fishing_txd fishing_rpg_master
    
    2. In your gamemode's OnPlayerLogin callback, add:
       CallRemoteFunction("OnPlayerLoginFishing", "ii", playerid, PlayerData[playerid][pUserID]);
    
    3. The filterscript will automatically:
       - Check if player has fishing account
       - Create account if needed
       - Load fishing data
    
    4. In OnPlayerDisconnect, data saves automatically
    
    5. For /fish command integration, see FISHING_TODO_CHECKLIST.md
    
    EXAMPLE GAMEMODE CODE:
    
    public OnPlayerLogin(playerid)
    {
        // ... your existing login code ...
        
        // Add this line for fishing system
        new user_id = PlayerData[playerid][pUserID]; // or however you store it
        CallRemoteFunction("OnPlayerLoginFishing", "ii", playerid, user_id);
        
        return 1;
    }
*/

// Callback for fish inventory dialog (from fishing_profile.inc)
forward OnShowFishInventoryDialog(playerid);
public OnShowFishInventoryDialog(playerid)
{
    printf("[FISHING PROFILE DEBUG] OnShowFishInventoryDialog callback - playerid: %d", playerid);
    
    new rows = cache_get_row_count(connectionID);
    printf("[FISHING PROFILE DEBUG] Rows found: %d", rows);
    
    if(rows == 0)
    {
        printf("[FISHING PROFILE DEBUG] No fish in inventory, showing empty message");
        ShowPlayerDialog(playerid, DIALOG_FISHING_INVENTORY, DIALOG_STYLE_MSGBOX,
            "{2ECC71}Fish Inventory",
            "{FFFFFF}Your inventory is empty!\n\n\
            {3498DB}Go fishing to catch some fish!",
            "Back", "Close");
        return 1;
    }
    
    new string[2048], line[128];
    new fishNameStr[64], rarityStr[16];
    new Float:weight, value, totalValue = 0;
    
    string[0] = EOS; // Initialize string
    
    for(new i = 0; i < rows && i < 20; i++)
    {
        cache_get_field_content(i, "fish_name", fishNameStr, connectionID, 64);
        cache_get_field_content(i, "fish_rarity", rarityStr, connectionID, 16);
        weight = cache_get_field_content_float(i, "fish_weight");
        value = cache_get_field_content_int(i, "fish_value");
        totalValue += value;
        
        new rarityColor[16];
        if(!strcmp(rarityStr, "Common", true))
            format(rarityColor, sizeof(rarityColor), "{FFFFFF}");
        else if(!strcmp(rarityStr, "Uncommon", true))
            format(rarityColor, sizeof(rarityColor), "{2ECC71}");
        else if(!strcmp(rarityStr, "Rare", true))
            format(rarityColor, sizeof(rarityColor), "{3498DB}");
        else if(!strcmp(rarityStr, "Legendary", true))
            format(rarityColor, sizeof(rarityColor), "{F39C12}");
        else
            format(rarityColor, sizeof(rarityColor), "{FFFFFF}");
        
        format(line, sizeof(line), "%s%s {FFFFFF}%.1fkg - $%d\n",
            rarityColor, fishNameStr, weight, value);
        strcat(string, line);
    }
    
    new header[256];
    format(header, sizeof(header),
        "{2ECC71}Fish Inventory {FFFFFF}(%d fish) | Total Value: {2ECC71}$%d",
        rows, totalValue);
    
    printf("[FISHING PROFILE DEBUG] Showing inventory dialog with %d fish", rows);
    ShowPlayerDialog(playerid, DIALOG_FISHING_INVENTORY, DIALOG_STYLE_MSGBOX,
        header, string, "Back", "Close");
    return 1;
}

// ============================================
// HELPER FUNCTIONS FOR FISHING_TXD.PWN
// ============================================

// Get player fishing level from RPG system
forward GetPlayerFishingLevelRPG(playerid);
public GetPlayerFishingLevelRPG(playerid)
{
    return PlayerFishingData[playerid][pFishingLevel];
}

// Note: GetPlayerZone() already exists in fishing_zones_manager.inc
// It returns the zone index (-1 if not in a zone)

// Get zone ID from zone index
forward GetZoneIDFromIndex(zoneIdx);
public GetZoneIDFromIndex(zoneIdx)
{
    if(zoneIdx < 0 || zoneIdx >= TotalZones)
    {
        return -1; // Invalid zone index
    }
    return Zones[zoneIdx][zID];
}

// Get zone TYPE from zone index (for fish generation)
forward GetZoneTypeFromIndex(zoneIdx);
public GetZoneTypeFromIndex(zoneIdx)
{
    if(zoneIdx < 0 || zoneIdx >= TotalZones)
    {
        return -1; // Invalid zone index
    }
    return Zones[zoneIdx][zType];
}

// Get player fishing rod ID
forward GetPlayerFishingRodID(playerid);
public GetPlayerFishingRodID(playerid)
{
    return PlayerFishingData[playerid][pFishingRodID];
}

// Start fishing music for player (called from fishing_txd.pwn)
forward StartFishingMusicForPlayer(playerid);
public StartFishingMusicForPlayer(playerid)
{
    StartFishingMusic(playerid);
    return 1;
}

// Play fishing start sound (called from fishing_txd.pwn)
forward PlayFishingStartSoundForPlayer(playerid);
public PlayFishingStartSoundForPlayer(playerid)
{
    PlayFishingStartSound(playerid);
    return 1;
}

// Play fishing strike sound (called from fishing_txd.pwn)
forward PlayFishingStrikeSoundForPlayer(playerid);
public PlayFishingStrikeSoundForPlayer(playerid)
{
    PlayFishingStrikeSound(playerid);
    return 1;
}

// Play fishing reel sound (called from fishing_txd.pwn)
forward PlayFishingReelSoundForPlayer(playerid);
public PlayFishingReelSoundForPlayer(playerid)
{
    PlayFishingReelSound(playerid);
    return 1;
}

// Stop fishing reel sound (called from fishing_txd.pwn)
forward StopFishingReelSoundForPlayer(playerid);
public StopFishingReelSoundForPlayer(playerid)
{
    StopFishingReelSound(playerid);
    return 1;
}

// Play reel battle sound (called from fishing_txd.pwn)
forward PlayReelBattleSoundForPlayer(playerid, intensity);
public PlayReelBattleSoundForPlayer(playerid, intensity)
{
    PlayReelBattleSound(playerid, intensity);
    return 1;
}

// Play catch success sound (called from fishing_txd.pwn)
forward PlayCatchSuccessSoundForPlayer(playerid);
public PlayCatchSuccessSoundForPlayer(playerid)
{
    PlayCatchSuccessSound(playerid);
    return 1;
}

// ============================================
// PUBLIC FUNCTIONS FOR GAMEMODE INTEGRATION
// ============================================

// Check if vehicle is a fishing boat (can be called from gamemode)
forward IsVehicleFishingBoat(vehicleid);
public IsVehicleFishingBoat(vehicleid)
{
    return IsFishingBoat(vehicleid);
}
// ============================================
// AUDIO CLEANUP FUNCTION
// ============================================

// Public function to cleanup all fishing audio for a player
// Called from fishing_txd.pwn via CallRemoteFunction
forward CleanupPlayerAudioForPlayer(playerid);
public CleanupPlayerAudioForPlayer(playerid)
{
    printf("[FISHING AUDIO] CleanupPlayerAudioForPlayer called for player %d", playerid);
    
    // Call the selective audio cleanup function from fishing_audio.inc
    // Exclude success sound so it can finish playing
    CleanupPlayerAudioExcept(playerid, true);
    
    return 1;
}