/*
    FISHING RPG SYSTEM - CORE MODULE
    Player data management, database operations, initialization
*/

#if defined _fishing_core_included
    #endinput
#endif
#define _fishing_core_included

#include "fishing_data_structures.inc"

// ============================================
// INITIALIZATION
// ============================================

stock InitializeFishingSystem()
{
    printf("[FISHING] Initializing RPG Fishing System...");
    
    LoadFishingRods();
    LoadFishingBait();
    LoadFishingZonesFromDB();  // Load zones from database only
    LoadFishingBoatsFromDB();  // Load boats
    LoadFishingActorsFromDB(); // Load actors
    LoadFishSpecies();
    LoadDailyQuests();
    
    printf("[FISHING] System initialized successfully!");
    printf("[FISHING] - Rods: %d", TotalFishingRods);
    printf("[FISHING] - Bait: %d", TotalFishingBait);
    printf("[FISHING] - Zones: %d", TotalZones);
    printf("[FISHING] - Boats: %d", TotalFishingBoats);
    printf("[FISHING] - Actors: %d", TotalFishingActors);
    printf("[FISHING] - Species: %d", TotalFishSpecies);
    printf("[FISHING] - Daily Quests: %d", TotalDailyQuests);
}

// ============================================
// PLAYER DATA MANAGEMENT
// ============================================

stock ResetPlayerFishingData(playerid)
{
    PlayerFishingData[playerid][pFishingLevel] = 1;
    PlayerFishingData[playerid][pFishingExp] = 0;
    PlayerFishingData[playerid][pFishingTokens] = 0;
    PlayerFishingData[playerid][pFishingRodID] = 0; // No rod
    PlayerFishingData[playerid][pFishingBaitID] = 0; // No bait
    PlayerFishingData[playerid][pFishingBaitAmount] = 0; // No bait
    PlayerFishingData[playerid][pFishingCombo] = 0;
    PlayerFishingData[playerid][pIsFishing] = false;
    PlayerFishingData[playerid][pFishingZoneID] = -1;
    PlayerFishingData[playerid][pFishingMissCount] = 0;
    PlayerFishingData[playerid][pFishingTotalCaught] = 0;
    PlayerFishingData[playerid][pFishingBiggestWeight] = 0.0;
    PlayerFishingData[playerid][pFishingLegendaryCount] = 0;
    PlayerFishingData[playerid][pDailyQuestID] = 0;
    PlayerFishingData[playerid][pDailyQuestProgress] = 0;
    PlayerFishingData[playerid][pDailyQuestCompleted] = false;
    PlayerFishingData[playerid][pTournamentScore] = 0.0;
    PlayerFishingData[playerid][pTournamentCaught] = 0;
    PlayerFishingData[playerid][pBoatCheckpointActive] = false;
    PlayerFishingData[playerid][pBoatCheckpointZoneID] = -1;
}

stock LoadPlayerFishingData(playerid, user_id)
{
    printf("[FISHING DEBUG] LoadPlayerFishingData called - playerid: %d, user_id: %d", playerid, user_id);
    printf("[FISHING DEBUG] Using connectionID: %d", connectionID);
    
    new query[256], queryStr[128];
    format(queryStr, sizeof(queryStr), "SELECT * FROM players WHERE user_id = %d", user_id);
    mysql_format(connectionID, query, sizeof(query), "%s", queryStr);
    
    printf("[FISHING DEBUG] Executing SELECT query: %s", query);
    mysql_tquery(connectionID, query, "OnLoadPlayerFishing", "i", playerid);
}


forward OnLoadPlayerFishing(playerid);
public OnLoadPlayerFishing(playerid)
{
    printf("[FISHING DEBUG] OnLoadPlayerFishing callback - playerid: %d", playerid);
    
    new rows = cache_get_row_count(connectionID);
    
    printf("[FISHING DEBUG] Rows returned: %d", rows);
    
    if(rows)
    {
        // Store database ID for updates
        PlayerFishingData[playerid][pFishingDBID] = cache_get_field_content_int(0, "id");
        
        printf("[FISHING DEBUG] Loaded pFishingDBID: %d", PlayerFishingData[playerid][pFishingDBID]);
        
        // Load all fishing data
        PlayerFishingData[playerid][pFishingLevel] = cache_get_field_content_int(0, "fishing_level");
        PlayerFishingData[playerid][pFishingExp] = cache_get_field_content_int(0, "fishing_exp");
        PlayerFishingData[playerid][pFishingTokens] = cache_get_field_content_int(0, "fishing_tokens");
        PlayerFishingData[playerid][pFishingRodID] = cache_get_field_content_int(0, "fishing_rod_id");
        PlayerFishingData[playerid][pFishingBaitID] = cache_get_field_content_int(0, "fishing_bait_id");
        PlayerFishingData[playerid][pFishingBaitAmount] = cache_get_field_content_int(0, "fishing_bait_amount");
        PlayerFishingData[playerid][pFishingCombo] = cache_get_field_content_int(0, "fishing_combo");
        PlayerFishingData[playerid][pFishingTotalCaught] = cache_get_field_content_int(0, "fishing_total_caught");
        PlayerFishingData[playerid][pFishingBiggestWeight] = cache_get_field_content_float(0, "fishing_biggest_weight");
        PlayerFishingData[playerid][pFishingLegendaryCount] = cache_get_field_content_int(0, "fishing_legendary_count");
        PlayerFishingData[playerid][pDailyQuestID] = cache_get_field_content_int(0, "fishing_daily_quest_id");
        PlayerFishingData[playerid][pDailyQuestProgress] = cache_get_field_content_int(0, "fishing_daily_progress");
        
        new completed;
        completed = cache_get_field_content_int(0, "fishing_daily_completed");
        PlayerFishingData[playerid][pDailyQuestCompleted] = (completed == 1);
        
        // Assign daily quest if player doesn't have one
        if(PlayerFishingData[playerid][pDailyQuestID] == 0)
        {
            AssignDailyQuest(playerid);
        }
        
        printf("[FISHING] Loaded data for player %d (DB ID: %d, Level: %d)", 
            playerid, 
            PlayerFishingData[playerid][pFishingDBID],
            PlayerFishingData[playerid][pFishingLevel]);
    }
    else
    {
        printf("[FISHING] ERROR: No fishing data found for player %d", playerid);
    }
}

stock SavePlayerFishingData(playerid)
{
    printf("[FISHING DEBUG] SavePlayerFishingData called for playerid: %d", playerid);
    printf("[FISHING DEBUG] pFishingDBID: %d", PlayerFishingData[playerid][pFishingDBID]);
    
    // Make sure player has fishing account
    if(PlayerFishingData[playerid][pFishingDBID] == 0)
    {
        printf("[FISHING] WARNING: Cannot save - player %d has no fishing account", playerid);
        return 0;
    }
    
    // Update fishing data in players table
    new query[1024];
    mysql_format(connectionID, query, sizeof(query),
        "UPDATE players SET fishing_level = %d, fishing_exp = %d, fishing_tokens = %d, fishing_rod_id = %d, fishing_bait_id = %d, fishing_bait_amount = %d, fishing_combo = %d, fishing_total_caught = %d, fishing_biggest_weight = %f, fishing_legendary_count = %d, fishing_daily_quest_id = %d, fishing_daily_progress = %d, fishing_daily_completed = %d WHERE id = %d",
        PlayerFishingData[playerid][pFishingLevel],
        PlayerFishingData[playerid][pFishingExp],
        PlayerFishingData[playerid][pFishingTokens],
        PlayerFishingData[playerid][pFishingRodID],
        PlayerFishingData[playerid][pFishingBaitID],
        PlayerFishingData[playerid][pFishingBaitAmount],
        PlayerFishingData[playerid][pFishingCombo],
        PlayerFishingData[playerid][pFishingTotalCaught],
        PlayerFishingData[playerid][pFishingBiggestWeight],
        PlayerFishingData[playerid][pFishingLegendaryCount],
        PlayerFishingData[playerid][pDailyQuestID],
        PlayerFishingData[playerid][pDailyQuestProgress],
        PlayerFishingData[playerid][pDailyQuestCompleted] ? 1 : 0,
        PlayerFishingData[playerid][pFishingDBID]);
    
    mysql_tquery(connectionID, query);
    return 1;
}

// ============================================
// EXPERIENCE & LEVELING
// ============================================

stock GiveFishingExperience(playerid, amount)
{
    PlayerFishingData[playerid][pFishingExp] += amount;
    
    new string[128];
    format(string, sizeof(string), "{3498DB}[FISHING]{FFFFFF} +%d fishing experience!", amount);
    SendClientMessage(playerid, -1, string);
    
    // Check for level up
    new requiredExp = GetRequiredFishingExp(PlayerFishingData[playerid][pFishingLevel]);
    
    if(PlayerFishingData[playerid][pFishingExp] >= requiredExp && PlayerFishingData[playerid][pFishingLevel] < 100)
    {
        PlayerFishingData[playerid][pFishingLevel]++;
        PlayerFishingData[playerid][pFishingExp] = 0;
        
        OnFishingLevelUp(playerid);
    }
    
    SavePlayerFishingData(playerid);
}

stock GetRequiredFishingExp(level)
{
    // Progressive experience curve
    // Level 1->2: 100 exp
    // Level 2->3: 250 exp
    // Level 3->4: 450 exp
    // Formula: base * level * multiplier
    return 50 + (level * level * 10);
}

stock OnFishingLevelUp(playerid)
{
    new string[256];
    format(string, sizeof(string), 
        "{2ECC71}____________________________________");
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}FISHING LEVEL UP! {FFFFFF}Level {2ECC71}%d", 
        PlayerFishingData[playerid][pFishingLevel]);
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, -1, "{FFFFFF}Benefits:");
    SendClientMessage(playerid, -1, "{FFFFFF}• Faster fish bite times");
    SendClientMessage(playerid, -1, "{FFFFFF}• Increased rare fish chance");
    SendClientMessage(playerid, -1, "{FFFFFF}• Better combo bonuses");
    
    // Give token reward
    new tokenReward = PlayerFishingData[playerid][pFishingLevel] * 5;
    PlayerFishingData[playerid][pFishingTokens] += tokenReward;
    
    format(string, sizeof(string), 
        "{FFFFFF}Reward: {F39C12}%d Fishing Tokens", tokenReward);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}____________________________________");
    SendClientMessage(playerid, -1, string);
    
    GameTextForPlayer(playerid, "~g~LEVEL UP!", 3000, 3);
    
    // Play level up sound
    PlayLevelUpSound(playerid);
    
    SavePlayerFishingData(playerid);
}

// ============================================
// BAIT MANAGEMENT
// ============================================

forward ConsumeFishingBait(playerid);
public ConsumeFishingBait(playerid)
{
    if(PlayerFishingData[playerid][pFishingBaitAmount] > 0)
    {
        PlayerFishingData[playerid][pFishingBaitAmount]--;
        
        printf("[FISHING DEBUG] Bait consumed - playerid: %d, remaining: %d", 
            playerid, PlayerFishingData[playerid][pFishingBaitAmount]);
        
        // Warn player if running low on bait
        if(PlayerFishingData[playerid][pFishingBaitAmount] <= 5 && PlayerFishingData[playerid][pFishingBaitAmount] > 0)
        {
            new string[128];
            format(string, sizeof(string), 
                "{F39C12}[FISHING]{FFFFFF} Low on bait! Only {F39C12}%d{FFFFFF} remaining.", 
                PlayerFishingData[playerid][pFishingBaitAmount]);
            SendClientMessage(playerid, -1, string);
        }
        else if(PlayerFishingData[playerid][pFishingBaitAmount] == 0)
        {
            SendClientMessage(playerid, 0xE74C3CFF, 
                "{E74C3C}[FISHING]{FFFFFF} You're out of bait! Visit /fishingshop to buy more.");
        }
        
        SavePlayerFishingData(playerid);
    }
    return 1;
}

forward BreakFishingCombo(playerid);
public BreakFishingCombo(playerid)
{
    if(PlayerFishingData[playerid][pFishingCombo] > 0)
    {
        new string[128];
        format(string, sizeof(string), 
            "{E74C3C}[FISHING]{FFFFFF} Combo broken! Lost {E74C3C}%dx{FFFFFF} combo.", 
            PlayerFishingData[playerid][pFishingCombo]);
        SendClientMessage(playerid, -1, string);
        
        PlayerFishingData[playerid][pFishingCombo] = 0;
        SavePlayerFishingData(playerid);
    }
    return 1;
}

forward GetPlayerFishingBait(playerid);
public GetPlayerFishingBait(playerid)
{
    return PlayerFishingData[playerid][pFishingBaitAmount];
}

forward GetPlayerFishingLevel(playerid);
public GetPlayerFishingLevel(playerid)
{
    return PlayerFishingData[playerid][pFishingLevel];
}
