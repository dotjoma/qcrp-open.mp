/*
    FISHING RPG SYSTEM - LEADERBOARD MODULE
    Global fishing statistics and rankings
*/

#if defined _fishing_leaderboard_included
    #endinput
#endif
#define _fishing_leaderboard_included

// ============================================
// LEADERBOARD MANAGEMENT
// ============================================

stock UpdateLeaderboard(playerid)
{
    // Update or insert player's leaderboard entry
    new query[512];
    new playerName[24];
    GetPlayerName(playerid, playerName, 24);
    
    // Use the stored database ID from PlayerFishingData
    new dbID = PlayerFishingData[playerid][pFishingDBID];
    
    mysql_format(connectionID, query, sizeof(query),
        "INSERT INTO fishing_leaderboard (player_id, player_name, total_caught, biggest_weight, legendary_count) VALUES (%d, '%e', %d, %f, %d) ON DUPLICATE KEY UPDATE player_name = '%e', total_caught = %d, biggest_weight = %f, legendary_count = %d",
        dbID,
        playerName,
        PlayerFishingData[playerid][pFishingTotalCaught],
        PlayerFishingData[playerid][pFishingBiggestWeight],
        PlayerFishingData[playerid][pFishingLegendaryCount],
        playerName,
        PlayerFishingData[playerid][pFishingTotalCaught],
        PlayerFishingData[playerid][pFishingBiggestWeight],
        PlayerFishingData[playerid][pFishingLegendaryCount]);
    
    mysql_tquery(connectionID, query);
}

// ============================================
// LEADERBOARD COMMANDS
// ============================================

CMD:fishtop(playerid, params[])
{
    new type[16];
    if(sscanf(params, "s[16]", type))
    {
        SendClientMessage(playerid, -1, "Usage: /fishtop [type]");
        SendClientMessage(playerid, -1, "Types: total, weight, legendary");
        return 1;
    }
    
    if(!strcmp(type, "total", true))
    {
        ShowTopTotalCaught(playerid);
    }
    else if(!strcmp(type, "weight", true))
    {
        ShowTopBiggestWeight(playerid);
    }
    else if(!strcmp(type, "legendary", true))
    {
        ShowTopLegendary(playerid);
    }
    else
    {
        SendClientMessage(playerid, 0xE74C3CFF, "Invalid type! Use: total, weight, or legendary");
    }
    
    return 1;
}

stock ShowTopTotalCaught(playerid)
{
    new query[256], queryStr[128];
    format(queryStr, sizeof(queryStr), 
        "SELECT player_name, total_caught FROM fishing_leaderboard ORDER BY total_caught DESC LIMIT 10");
    mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
    mysql_tquery(connectionID, query, "OnLoadTopTotalCaught", "i", playerid);
}

forward OnLoadTopTotalCaught(playerid);
public OnLoadTopTotalCaught(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "No leaderboard data available!");
        return;
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "═══ TOP FISHERMEN (Total Caught) ═══");
    
    for(new i = 0; i < rows; i++)
    {
        new playerName[24], totalCaught, temp[24];
        cache_get_field_content(i, "player_name", temp, connectionID, 24);
        format(playerName, sizeof(playerName), "%s", temp);
        totalCaught = cache_get_field_content_int(i, "total_caught");
        
        new string[128];
        format(string, sizeof(string), 
            "{3498DB}%d. {FFFFFF}%s - {2ECC71}%d fish", 
            i + 1, playerName, totalCaught);
        SendClientMessage(playerid, -1, string);
    }
}

stock ShowTopBiggestWeight(playerid)
{
    new query[256], queryStr[128];
    format(queryStr, sizeof(queryStr), 
        "SELECT player_name, biggest_weight FROM fishing_leaderboard ORDER BY biggest_weight DESC LIMIT 10");
    mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
    mysql_tquery(connectionID, query, "OnLoadTopBiggestWeight", "i", playerid);
}

forward OnLoadTopBiggestWeight(playerid);
public OnLoadTopBiggestWeight(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "No leaderboard data available!");
        return;
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "═══ TOP FISHERMEN (Biggest Fish) ═══");
    
    for(new i = 0; i < rows; i++)
    {
        new playerName[24], Float:biggestWeight, temp[24];
        cache_get_field_content(i, "player_name", temp, connectionID, 24);
        format(playerName, sizeof(playerName), "%s", temp);
        biggestWeight = cache_get_field_content_float(i, "biggest_weight");
        
        new string[128];
        format(string, sizeof(string), 
            "{3498DB}%d. {FFFFFF}%s - {F39C12}%.2fkg", 
            i + 1, playerName, biggestWeight);
        SendClientMessage(playerid, -1, string);
    }
}

stock ShowTopLegendary(playerid)
{
    new query[256], queryStr[128];
    format(queryStr, sizeof(queryStr), 
        "SELECT player_name, legendary_count FROM fishing_leaderboard ORDER BY legendary_count DESC LIMIT 10");
    mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
    mysql_tquery(connectionID, query, "OnLoadTopLegendary", "i", playerid);
}

forward OnLoadTopLegendary(playerid);
public OnLoadTopLegendary(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "No leaderboard data available!");
        return;
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "═══ TOP FISHERMEN (Legendary Catches) ═══");
    
    for(new i = 0; i < rows; i++)
    {
        new playerName[24], legendaryCount, temp[24];
        cache_get_field_content(i, "player_name", temp, connectionID, 24);
        format(playerName, sizeof(playerName), "%s", temp);
        legendaryCount = cache_get_field_content_int(i, "legendary_count");
        
        new string[128];
        format(string, sizeof(string), 
            "{3498DB}%d. {FFFFFF}%s - {F39C12}%d legendary", 
            i + 1, playerName, legendaryCount);
        SendClientMessage(playerid, -1, string);
    }
}

// ============================================
// PLAYER STATS COMMAND
// ============================================

CMD:fishstats(playerid, params[])
{
    new targetid = playerid;
    
    if(sscanf(params, "u", targetid))
    {
        targetid = playerid;
    }
    
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xE74C3CFF, "Player not connected!");
        return 1;
    }
    
    new targetName[24];
    GetPlayerName(targetid, targetName, 24);
    
    new string[256];
    
    SendClientMessage(playerid, 0x3498DBFF, "═══════════════════════════════════");
    
    format(string, sizeof(string), 
        "{3498DB}[FISHING STATS]{FFFFFF} %s", targetName);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Level: {2ECC71}%d {FFFFFF}| EXP: {3498DB}%d/%d",
        PlayerFishingData[targetid][pFishingLevel],
        PlayerFishingData[targetid][pFishingExp],
        GetRequiredFishingExp(PlayerFishingData[targetid][pFishingLevel]));
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Tokens: {F39C12}%d", 
        PlayerFishingData[targetid][pFishingTokens]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Rod: {3498DB}%s", 
        FishingRods[PlayerFishingData[targetid][pFishingRodID] - 1][rodName]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Bait: {3498DB}%s {FFFFFF}(x%d)", 
        FishingBait[PlayerFishingData[targetid][pFishingBaitID] - 1][baitName],
        PlayerFishingData[targetid][pFishingBaitAmount]);
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, -1, "{FFFFFF}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    
    format(string, sizeof(string), 
        "{FFFFFF}Total Caught: {2ECC71}%d fish", 
        PlayerFishingData[targetid][pFishingTotalCaught]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Biggest Fish: {F39C12}%.2fkg", 
        PlayerFishingData[targetid][pFishingBiggestWeight]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{FFFFFF}Legendary Caught: {F39C12}%d", 
        PlayerFishingData[targetid][pFishingLegendaryCount]);
    SendClientMessage(playerid, -1, string);
    
    if(PlayerFishingData[targetid][pFishingCombo] > 0)
    {
        format(string, sizeof(string), 
            "{FFFFFF}Current Combo: {F39C12}x%d", 
            PlayerFishingData[targetid][pFishingCombo]);
        SendClientMessage(playerid, -1, string);
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "═══════════════════════════════════");
    
    return 1;
}
