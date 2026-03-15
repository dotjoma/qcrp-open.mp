/*
    FISHING RPG SYSTEM - ZONES MODULE
    Zone detection and turf integration
*/

#if defined _fishing_zones_included
    #endinput
#endif
#define _fishing_zones_included

// ============================================
// FISHING ZONES
// ============================================

stock LoadFishingZones()
{
    // Zone 1: Santa Maria Beach
    FishingZones[0][zoneID] = 1;
    format(FishingZones[0][zoneName], 64, "Santa Maria Beach");
    FishingZones[0][zoneMinX] = -2000.0;
    FishingZones[0][zoneMinY] = -1500.0;
    FishingZones[0][zoneMaxX] = -1000.0;
    FishingZones[0][zoneMaxY] = -500.0;
    FishingZones[0][zoneTurfID] = 1; // Example turf ID
    format(FishingZones[0][zoneTimeBonusType], 32, "morning");
    
    // Zone 2: Flint River
    FishingZones[1][zoneID] = 2;
    format(FishingZones[1][zoneName], 64, "Flint River");
    FishingZones[1][zoneMinX] = -1500.0;
    FishingZones[1][zoneMinY] = 500.0;
    FishingZones[1][zoneMaxX] = -500.0;
    FishingZones[1][zoneMaxY] = 1500.0;
    FishingZones[1][zoneTurfID] = 2;
    format(FishingZones[1][zoneTimeBonusType], 32, "morning");
    
    // Zone 3: Fisher's Lagoon
    FishingZones[2][zoneID] = 3;
    format(FishingZones[2][zoneName], 64, "Fisher's Lagoon");
    FishingZones[2][zoneMinX] = 1000.0;
    FishingZones[2][zoneMinY] = -2000.0;
    FishingZones[2][zoneMaxX] = 2000.0;
    FishingZones[2][zoneMaxY] = -1000.0;
    FishingZones[2][zoneTurfID] = -1; // No turf
    format(FishingZones[2][zoneTimeBonusType], 32, "evening");
    
    // Zone 4: Deep Sea (Ocean)
    FishingZones[3][zoneID] = 4;
    format(FishingZones[3][zoneName], 64, "Deep Sea");
    FishingZones[3][zoneMinX] = -3000.0;
    FishingZones[3][zoneMinY] = -3000.0;
    FishingZones[3][zoneMaxX] = -2000.0;
    FishingZones[3][zoneMaxY] = -1500.0;
    FishingZones[3][zoneTurfID] = -1;
    format(FishingZones[3][zoneTimeBonusType], 32, "night");
    
    TotalFishingZones = 4;
}

stock GetPlayerFishingZone(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < TotalFishingZones; i++)
    {
        if(x >= FishingZones[i][zoneMinX] && x <= FishingZones[i][zoneMaxX] &&
           y >= FishingZones[i][zoneMinY] && y <= FishingZones[i][zoneMaxY])
        {
            return FishingZones[i][zoneID];
        }
    }
    
    return -1; // Not in any fishing zone
}

stock IsPlayerInFishingZone(playerid)
{
    return (GetPlayerFishingZone(playerid) != -1);
}

// ============================================
// TURF INTEGRATION
// ============================================

stock GetZoneTurfOwner(zone_id)
{
    #pragma unused zone_id
    // This should integrate with your gang/turf system
    // Example implementation:
    /*
    if(FishingZones[zone_id][zoneTurfID] == -1)
        return -1; // No turf
    
    new turfID = FishingZones[zone_id][zoneTurfID];
    return TurfData[turfID][turfOwnerGangID];
    */
    
    return -1; // Placeholder
}

stock GetTurfBiteSpeedBonus(zone_id, playerid)
{
    #pragma unused playerid
    new turfOwner = GetZoneTurfOwner(zone_id);
    
    if(turfOwner == -1)
        return 0; // No turf owner
    
    // Check if player is in the gang that owns the turf
    // Example:
    /*
    if(PlayerData[playerid][pGangID] == turfOwner)
        return 10; // 10% bite speed bonus for gang members
    */
    
    return 0;
}

stock GiveTurfOwnerCut(zone_id, fishValue)
{
    new turfOwner = GetZoneTurfOwner(zone_id);
    
    if(turfOwner == -1)
        return;
    
    // Give 5% of fish value to gang treasury
    new cut = floatround(fishValue * 0.05);
    
    // Example:
    /*
    GangData[turfOwner][gangTreasury] += cut;
    SaveGangData(turfOwner);
    */
}


// ============================================
// TIME OF DAY BONUSES
// ============================================

stock GetTimeOfDayBiteBonus(zone_id)
{
    new currentTime = GetTimeOfDay();
    
    // Find zone index
    new zoneIdx = -1;
    for(new i = 0; i < TotalFishingZones; i++)
    {
        if(FishingZones[i][zoneID] == zone_id)
        {
            zoneIdx = i;
            break;
        }
    }
    
    if(zoneIdx == -1) return 0;
    
    // Check if zone has time bonus
    if(!strcmp(FishingZones[zoneIdx][zoneTimeBonusType], "morning", true) && currentTime == TIME_MORNING)
        return 15; // 15% faster bite in morning
    
    if(!strcmp(FishingZones[zoneIdx][zoneTimeBonusType], "night", true) && currentTime == TIME_NIGHT)
        return 20; // 20% faster bite at night
    
    if(!strcmp(FishingZones[zoneIdx][zoneTimeBonusType], "evening", true) && currentTime == TIME_EVENING)
        return 15; // 15% faster bite in evening
    
    return 0;
}

stock GetZoneInfo(playerid)
{
    new zone_id = GetPlayerFishingZone(playerid);
    
    if(zone_id == -1)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} You are not in a fishing zone!");
        return 0;
    }
    
    // Find zone index
    new zoneIdx = -1;
    for(new i = 0; i < TotalFishingZones; i++)
    {
        if(FishingZones[i][zoneID] == zone_id)
        {
            zoneIdx = i;
            break;
        }
    }
    
    if(zoneIdx == -1) return 0;
    
    new string[256];
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    
    format(string, sizeof(string), 
        "{3498DB}[ZONE]{FFFFFF} %s", 
        FishingZones[zoneIdx][zoneName]);
    SendClientMessage(playerid, -1, string);
    
    // Time bonus
    new timeBonus = GetTimeOfDayBiteBonus(zone_id);
    if(timeBonus > 0)
    {
        format(string, sizeof(string), 
            "{2ECC71}- Time Bonus:{FFFFFF} +%d%% bite speed (%s)", 
            timeBonus, GetTimeOfDayName());
        SendClientMessage(playerid, -1, string);
    }
    
    // Turf bonus
    new turfBonus = GetTurfBiteSpeedBonus(zone_id, playerid);
    if(turfBonus > 0)
    {
        format(string, sizeof(string), 
            "{2ECC71}- Gang Territory Bonus:{FFFFFF} +%d%% bite speed", 
            turfBonus);
        SendClientMessage(playerid, -1, string);
    }
    
    // Available fish
    SendClientMessage(playerid, -1, "{3498DB}Available Fish:");
    
    new fishCount = 0;
    for(new i = 0; i < TotalFishSpecies; i++)
    {
        if(FishSpecies[i][fishZoneID] == zone_id)
        {
            new rarityColor[16];
            format(rarityColor, sizeof(rarityColor), GetRarityColor(FishSpecies[i][fishRarity]));
            
            format(string, sizeof(string), 
                "  %s%s {FFFFFF}(%.1f-%.1fkg)", 
                rarityColor, FishSpecies[i][fishName],
                FishSpecies[i][fishMinWeight], FishSpecies[i][fishMaxWeight]);
            SendClientMessage(playerid, -1, string);
            
            fishCount++;
            if(fishCount >= 10) break; // Limit display
        }
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    
    return 1;
}

// ============================================
// ZONE COMMANDS (OLD - kept for compatibility)
// ============================================

CMD:fishzoneinfo(playerid, params[])
{
    GetZoneInfo(playerid);
    return 1;
}

CMD:fishzones(playerid, params[])
{
    SendClientMessage(playerid, 0x3498DBFF, "═══ FISHING ZONES ═══");
    
    for(new i = 0; i < TotalFishingZones; i++)
    {
        new string[128];
        format(string, sizeof(string), 
            "{3498DB}%d.{FFFFFF} %s {FFFFFF}(Time Bonus: %s)", 
            i + 1, FishingZones[i][zoneName], FishingZones[i][zoneTimeBonusType]);
        SendClientMessage(playerid, -1, string);
    }
    
    SendClientMessage(playerid, -1, "{FFFFFF}Use {3498DB}/fishzone{FFFFFF} to see your current zone info");
    
    return 1;
}
