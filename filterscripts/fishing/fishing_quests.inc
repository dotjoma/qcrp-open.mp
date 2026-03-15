/*
    FISHING RPG SYSTEM - QUEST MODULE
    Daily quest system and progress tracking
*/

#if defined _fishing_quests_included
    #endinput
#endif
#define _fishing_quests_included

// Quest types
#define QUEST_TYPE_CATCH_AMOUNT     0
#define QUEST_TYPE_CATCH_RARITY     1
#define QUEST_TYPE_CATCH_WEIGHT     2
#define QUEST_TYPE_SUBMIT_SPECIES   3  // Submit specific fish species to actor

// ============================================
// DAILY QUESTS
// ============================================

stock LoadDailyQuests()
{
    // Quest 1: Catch 5 fish
    DailyQuests[0][questID] = 1;
    DailyQuests[0][questType] = QUEST_TYPE_CATCH_AMOUNT;
    DailyQuests[0][questTargetAmount] = 5;
    DailyQuests[0][questTargetRarity] = -1;
    DailyQuests[0][questTargetWeight] = 0.0;
    DailyQuests[0][questTargetSpeciesID] = 0;
    DailyQuests[0][questTokenReward] = 5;
    format(DailyQuests[0][questDescription], 128, "Catch 5 fish");
    
    // Quest 2: Catch 10 fish
    DailyQuests[1][questID] = 2;
    DailyQuests[1][questType] = QUEST_TYPE_CATCH_AMOUNT;
    DailyQuests[1][questTargetAmount] = 10;
    DailyQuests[1][questTargetRarity] = -1;
    DailyQuests[1][questTargetWeight] = 0.0;
    DailyQuests[1][questTargetSpeciesID] = 0;
    DailyQuests[1][questTokenReward] = 5;
    format(DailyQuests[1][questDescription], 128, "Catch 10 fish");
    
    // Quest 3: Catch 1 uncommon fish
    DailyQuests[2][questID] = 3;
    DailyQuests[2][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[2][questTargetAmount] = 1;
    DailyQuests[2][questTargetRarity] = RARITY_UNCOMMON;
    DailyQuests[2][questTargetWeight] = 0.0;
    DailyQuests[2][questTargetSpeciesID] = 0;
    DailyQuests[2][questTokenReward] = 5;
    format(DailyQuests[2][questDescription], 128, "Catch 1 Uncommon fish");
    
    // Quest 4: Catch 1 rare fish
    DailyQuests[3][questID] = 4;
    DailyQuests[3][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[3][questTargetAmount] = 1;
    DailyQuests[3][questTargetRarity] = RARITY_RARE;
    DailyQuests[3][questTargetWeight] = 0.0;
    DailyQuests[3][questTargetSpeciesID] = 0;
    DailyQuests[3][questTokenReward] = 5;
    format(DailyQuests[3][questDescription], 128, "Catch 1 Rare fish");
    
    // Quest 5: Catch 1 legendary fish
    DailyQuests[4][questID] = 5;
    DailyQuests[4][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[4][questTargetAmount] = 1;
    DailyQuests[4][questTargetRarity] = RARITY_LEGENDARY;
    DailyQuests[4][questTargetWeight] = 0.0;
    DailyQuests[4][questTargetSpeciesID] = 0;
    DailyQuests[4][questTokenReward] = 5;
    format(DailyQuests[4][questDescription], 128, "Catch 1 Legendary fish");
    
    // Quest 6: Catch fish totaling 10kg
    DailyQuests[5][questID] = 6;
    DailyQuests[5][questType] = QUEST_TYPE_CATCH_WEIGHT;
    DailyQuests[5][questTargetAmount] = 0;
    DailyQuests[5][questTargetRarity] = -1;
    DailyQuests[5][questTargetWeight] = 10.0;
    DailyQuests[5][questTargetSpeciesID] = 0;
    DailyQuests[5][questTokenReward] = 5;
    format(DailyQuests[5][questDescription], 128, "Catch fish totaling 10kg");
    
    // Quest 7: Catch fish totaling 25kg
    DailyQuests[6][questID] = 7;
    DailyQuests[6][questType] = QUEST_TYPE_CATCH_WEIGHT;
    DailyQuests[6][questTargetAmount] = 0;
    DailyQuests[6][questTargetRarity] = -1;
    DailyQuests[6][questTargetWeight] = 25.0;
    DailyQuests[6][questTargetSpeciesID] = 0;
    DailyQuests[6][questTokenReward] = 5;
    format(DailyQuests[6][questDescription], 128, "Catch fish totaling 25kg");
    
    // Quest 8: Catch 3 uncommon fish
    DailyQuests[7][questID] = 8;
    DailyQuests[7][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[7][questTargetAmount] = 3;
    DailyQuests[7][questTargetRarity] = RARITY_UNCOMMON;
    DailyQuests[7][questTargetWeight] = 0.0;
    DailyQuests[7][questTargetSpeciesID] = 0;
    DailyQuests[7][questTokenReward] = 5;
    format(DailyQuests[7][questDescription], 128, "Catch 3 Uncommon fish");
    
    // Quest 9: Submit 3 Sardines to fishing actor
    DailyQuests[8][questID] = 9;
    DailyQuests[8][questType] = QUEST_TYPE_SUBMIT_SPECIES;
    DailyQuests[8][questTargetAmount] = 3;
    DailyQuests[8][questTargetRarity] = -1;
    DailyQuests[8][questTargetWeight] = 0.0;
    DailyQuests[8][questTargetSpeciesID] = 1; // Sardine
    DailyQuests[8][questTokenReward] = 5;
    format(DailyQuests[8][questDescription], 128, "Submit 3 Sardines to fishing actor");
    
    // Quest 10: Submit 2 Sea Bass to fishing actor
    DailyQuests[9][questID] = 10;
    DailyQuests[9][questType] = QUEST_TYPE_SUBMIT_SPECIES;
    DailyQuests[9][questTargetAmount] = 2;
    DailyQuests[9][questTargetRarity] = -1;
    DailyQuests[9][questTargetWeight] = 0.0;
    DailyQuests[9][questTargetSpeciesID] = 3; // Sea Bass
    DailyQuests[9][questTokenReward] = 5;
    format(DailyQuests[9][questDescription], 128, "Submit 2 Sea Bass to fishing actor");
    
    // Quest 11: Submit 1 Grouper to fishing actor
    DailyQuests[10][questID] = 11;
    DailyQuests[10][questType] = QUEST_TYPE_SUBMIT_SPECIES;
    DailyQuests[10][questTargetAmount] = 1;
    DailyQuests[10][questTargetRarity] = -1;
    DailyQuests[10][questTargetWeight] = 0.0;
    DailyQuests[10][questTargetSpeciesID] = 5; // Grouper
    DailyQuests[10][questTokenReward] = 5;
    format(DailyQuests[10][questDescription], 128, "Submit 1 Grouper to fishing actor");
    
    // Quest 12: Submit 2 Catfish to fishing actor
    DailyQuests[11][questID] = 12;
    DailyQuests[11][questType] = QUEST_TYPE_SUBMIT_SPECIES;
    DailyQuests[11][questTargetAmount] = 2;
    DailyQuests[11][questTargetRarity] = -1;
    DailyQuests[11][questTargetWeight] = 0.0;
    DailyQuests[11][questTargetSpeciesID] = 8; // Catfish
    DailyQuests[11][questTokenReward] = 5;
    format(DailyQuests[11][questDescription], 128, "Submit 2 Catfish to fishing actor");
    
    // Quest 13: Submit 1 Salmon to fishing actor
    DailyQuests[12][questID] = 13;
    DailyQuests[12][questType] = QUEST_TYPE_SUBMIT_SPECIES;
    DailyQuests[12][questTargetAmount] = 1;
    DailyQuests[12][questTargetRarity] = -1;
    DailyQuests[12][questTargetWeight] = 0.0;
    DailyQuests[12][questTargetSpeciesID] = 11; // Salmon
    DailyQuests[12][questTokenReward] = 5;
    format(DailyQuests[12][questDescription], 128, "Submit 1 Salmon to fishing actor");
    
    TotalDailyQuests = 13;
}

stock AssignDailyQuest(playerid)
{
    // Assign random quest based on player level
    new availableQuests[MAX_DAILY_QUESTS];
    new availableCount = 0;
    
    for(new i = 0; i < TotalDailyQuests; i++)
    {
        // Filter quests by difficulty
        if(DailyQuests[i][questType] == QUEST_TYPE_CATCH_RARITY)
        {
            if(DailyQuests[i][questTargetRarity] == RARITY_LEGENDARY && PlayerFishingData[playerid][pFishingLevel] < 30)
                continue; // Skip legendary quests for low level players
            
            if(DailyQuests[i][questTargetRarity] == RARITY_RARE && PlayerFishingData[playerid][pFishingLevel] < 15)
                continue;
        }
        
        availableQuests[availableCount++] = i;
    }
    
    if(availableCount > 0)
    {
        new selectedIdx = availableQuests[random(availableCount)];
        PlayerFishingData[playerid][pDailyQuestID] = DailyQuests[selectedIdx][questID];
        PlayerFishingData[playerid][pDailyQuestProgress] = 0;
        PlayerFishingData[playerid][pDailyQuestCompleted] = false;
        
        SavePlayerFishingData(playerid);
        
        new string[128];
        format(string, sizeof(string), 
            "{3498DB}[DAILY QUEST]{FFFFFF} New quest: %s (Reward: {F39C12}%d tokens{FFFFFF})",
            DailyQuests[selectedIdx][questDescription],
            DailyQuests[selectedIdx][questTokenReward]);
        SendClientMessage(playerid, -1, string);
    }
}


stock UpdateDailyQuestProgress(playerid, fish_rarity, Float:fishWeight)
{
    #pragma unused fish_rarity
    if(PlayerFishingData[playerid][pDailyQuestCompleted])
        return;
    
    new playerQuestID = PlayerFishingData[playerid][pDailyQuestID];
    if(playerQuestID == 0) return;
    
    // Find quest data
    new questIdx = -1;
    for(new i = 0; i < TotalDailyQuests; i++)
    {
        if(DailyQuests[i][questID] == playerQuestID)
        {
            questIdx = i;
            break;
        }
    }
    
    if(questIdx == -1) return;
    
    // Update progress based on quest type
    switch(DailyQuests[questIdx][questType])
    {
        case QUEST_TYPE_CATCH_AMOUNT:
        {
            PlayerFishingData[playerid][pDailyQuestProgress]++;
            
            new string[128];
            format(string, sizeof(string), 
                "{3498DB}[QUEST]{FFFFFF} Progress: %d/%d fish caught",
                PlayerFishingData[playerid][pDailyQuestProgress],
                DailyQuests[questIdx][questTargetAmount]);
            SendClientMessage(playerid, -1, string);
            
            if(PlayerFishingData[playerid][pDailyQuestProgress] >= DailyQuests[questIdx][questTargetAmount])
            {
                CompleteDailyQuest(playerid, questIdx);
            }
        }
        
        case QUEST_TYPE_CATCH_RARITY:
        {
            if(fish_rarity == DailyQuests[questIdx][questTargetRarity])
            {
                PlayerFishingData[playerid][pDailyQuestProgress]++;
                
                new string[128];
                format(string, sizeof(string), 
                    "{3498DB}[QUEST]{FFFFFF} Progress: %d/%d %s fish caught",
                    PlayerFishingData[playerid][pDailyQuestProgress],
                    DailyQuests[questIdx][questTargetAmount],
                    GetRarityName(DailyQuests[questIdx][questTargetRarity]));
                SendClientMessage(playerid, -1, string);
                
                if(PlayerFishingData[playerid][pDailyQuestProgress] >= DailyQuests[questIdx][questTargetAmount])
                {
                    CompleteDailyQuest(playerid, questIdx);
                }
            }
        }
        
        case QUEST_TYPE_CATCH_WEIGHT:
        {
            new Float:currentWeight = float(PlayerFishingData[playerid][pDailyQuestProgress]) / 100.0;
            currentWeight += fishWeight;
            PlayerFishingData[playerid][pDailyQuestProgress] = floatround(currentWeight * 100.0);
            
            new string[128];
            format(string, sizeof(string), 
                "{3498DB}[QUEST]{FFFFFF} Progress: %.2fkg/%.2fkg",
                currentWeight,
                DailyQuests[questIdx][questTargetWeight]);
            SendClientMessage(playerid, -1, string);
            
            if(currentWeight >= DailyQuests[questIdx][questTargetWeight])
            {
                CompleteDailyQuest(playerid, questIdx);
            }
        }
    }
    
    SavePlayerFishingData(playerid);
}

stock CompleteDailyQuest(playerid, questIdx)
{
    PlayerFishingData[playerid][pDailyQuestCompleted] = true;
    
    // Give reward
    new tokenReward = DailyQuests[questIdx][questTokenReward];
    PlayerFishingData[playerid][pFishingTokens] += tokenReward;
    
    new string[256];
    format(string, sizeof(string), 
        "{2ECC71}______________________________________");
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, -1, 
        "{2ECC71}- {FFFFFF}DAILY QUEST COMPLETED!");
    
    format(string, sizeof(string), 
        "{2ECC71}- {FFFFFF}Reward: {F39C12}%d Fishing Tokens", tokenReward);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}______________________________________");
    SendClientMessage(playerid, -1, string);
    
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    
    SavePlayerFishingData(playerid);
}

// ============================================
// QUEST COMMANDS
// ============================================

CMD:fishquest(playerid, params[])
{
    if(PlayerFishingData[playerid][pDailyQuestID] == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[QUEST]{FFFFFF} You don't have an active quest!");
        return 1;
    }
    
    // Find quest data
    new questIdx = -1;
    for(new i = 0; i < TotalDailyQuests; i++)
    {
        if(DailyQuests[i][questID] == PlayerFishingData[playerid][pDailyQuestID])
        {
            questIdx = i;
            break;
        }
    }
    
    if(questIdx == -1) return 1;
    
    new string[256];
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    SendClientMessage(playerid, -1, "{3498DB}[DAILY QUEST]");
    
    format(string, sizeof(string), 
        "{FFFFFF}Quest: %s", DailyQuests[questIdx][questDescription]);
    SendClientMessage(playerid, -1, string);
    
    if(PlayerFishingData[playerid][pDailyQuestCompleted])
    {
        SendClientMessage(playerid, -1, "{2ECC71}Status: COMPLETED!");
        SendClientMessage(playerid, -1, "{FFFFFF}New quest available tomorrow!");
    }
    else
    {
        switch(DailyQuests[questIdx][questType])
        {
            case QUEST_TYPE_CATCH_AMOUNT:
            {
                format(string, sizeof(string), 
                    "{FFFFFF}Progress: {3498DB}%d/%d {FFFFFF}fish",
                    PlayerFishingData[playerid][pDailyQuestProgress],
                    DailyQuests[questIdx][questTargetAmount]);
                SendClientMessage(playerid, -1, string);
            }
            
            case QUEST_TYPE_CATCH_RARITY:
            {
                format(string, sizeof(string), 
                    "{FFFFFF}Progress: {3498DB}%d/%d {FFFFFF}%s fish",
                    PlayerFishingData[playerid][pDailyQuestProgress],
                    DailyQuests[questIdx][questTargetAmount],
                    GetRarityName(DailyQuests[questIdx][questTargetRarity]));
                SendClientMessage(playerid, -1, string);
            }
            
            case QUEST_TYPE_CATCH_WEIGHT:
            {
                new Float:currentWeight = float(PlayerFishingData[playerid][pDailyQuestProgress]) / 100.0;
                format(string, sizeof(string), 
                    "{FFFFFF}Progress: {3498DB}%.2fkg/%.2fkg",
                    currentWeight,
                    DailyQuests[questIdx][questTargetWeight]);
                SendClientMessage(playerid, -1, string);
            }
            
            case QUEST_TYPE_SUBMIT_SPECIES:
            {
                format(string, sizeof(string), 
                    "{FFFFFF}Progress: {3498DB}%d/%d {FFFFFF}%s submitted",
                    PlayerFishingData[playerid][pDailyQuestProgress],
                    DailyQuests[questIdx][questTargetAmount],
                    FishSpecies[DailyQuests[questIdx][questTargetSpeciesID] - 1][fishName]);
                SendClientMessage(playerid, -1, string);
                SendClientMessage(playerid, -1, "{FFFFFF}Press {FFFF00}Y{FFFFFF} near a fishing actor and select {FFFF00}'Submit Quest Fish'{FFFFFF}");
            }
        }
        
        format(string, sizeof(string), 
            "{FFFFFF}Reward: {F39C12}%d Fishing Tokens",
            DailyQuests[questIdx][questTokenReward]);
        SendClientMessage(playerid, -1, string);
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "___________________________________");
    
    return 1;
}

CMD:newquest(playerid, params[])
{
    if(!PlayerFishingData[playerid][pDailyQuestCompleted])
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[QUEST]{FFFFFF} Complete your current quest first!");
        return 1;
    }
    
    // Check cooldown (24 hours)
    // This should be implemented with a timestamp system
    
    AssignDailyQuest(playerid);
    return 1;
}


// ============================================
// QUEST FISH SUBMISSION
// ============================================

// Dialog IDs are defined in fishing_profile.inc to avoid include order issues

// Helper function to get player's current quest index
stock GetPlayerQuestIndex(playerid)
{
    new playerQuestID = PlayerFishingData[playerid][pDailyQuestID];
    if(playerQuestID == 0) return -1;
    
    for(new i = 0; i < TotalDailyQuests; i++)
    {
        if(DailyQuests[i][questID] == playerQuestID)
        {
            return i;
        }
    }
    
    return -1;
}

stock ShowQuestSubmitMenu(playerid)
{
    // Check if player has a submit quest
    if(PlayerFishingData[playerid][pDailyQuestCompleted])
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[QUEST]{FFFFFF} You've already completed your daily quest!");
        return;
    }
    
    new questIdx = GetPlayerQuestIndex(playerid);
    if(questIdx == -1 || DailyQuests[questIdx][questType] != QUEST_TYPE_SUBMIT_SPECIES)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[QUEST]{FFFFFF} Your current quest doesn't require fish submission!");
        SendClientMessage(playerid, -1, "{FFFFFF}Use /quest to check your current quest.");
        return;
    }
    
    // Get target species info
    new targetSpeciesID = DailyQuests[questIdx][questTargetSpeciesID];
    new targetAmount = DailyQuests[questIdx][questTargetAmount];
    
    // Query player's inventory for the target species
    new query[512];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT COUNT(*) as fish_count FROM fishing_inventory WHERE player_id = %d AND fish_species_id = %d",
        PlayerFishingData[playerid][pFishingDBID],
        targetSpeciesID);
    
    mysql_tquery(connectionID, query, "OnCheckQuestFish", "iii", playerid, targetSpeciesID, targetAmount);
}

forward OnCheckQuestFish(playerid, targetSpeciesID, targetAmount);
public OnCheckQuestFish(playerid, targetSpeciesID, targetAmount)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[QUEST]{FFFFFF} You don't have the required fish!");
        return;
    }
    
    new fishCount = cache_get_field_content_int(0, "fish_count");
    
    if(fishCount < targetAmount)
    {
        new string[256];
        format(string, sizeof(string),
            "{E74C3C}[QUEST]{FFFFFF} You need {FFFF00}%d %s{FFFFFF} but only have {FFFF00}%d{FFFFFF}!",
            targetAmount, FishSpecies[targetSpeciesID - 1][fishName], fishCount);
        SendClientMessage(playerid, -1, string);
        return;
    }
    
    // Show confirmation dialog
    new dialog[512];
    format(dialog, sizeof(dialog),
        "{FFFFFF}You have {2ECC71}%d %s{FFFFFF} in your inventory.\n\n\
        Your quest requires {FFFF00}%d %s{FFFFFF}.\n\n\
        {FFFFFF}Submit these fish to complete your quest?\n\n\
        {F39C12}Reward: {FFFFFF}%d Fishing Tokens",
        fishCount, FishSpecies[targetSpeciesID - 1][fishName],
        targetAmount, FishSpecies[targetSpeciesID - 1][fishName],
        DailyQuests[GetPlayerQuestIndex(playerid)][questTokenReward]);
    
    SetPVarInt(playerid, "QuestSubmitSpeciesID", targetSpeciesID);
    SetPVarInt(playerid, "QuestSubmitAmount", targetAmount);
    
    ShowPlayerDialog(playerid, DIALOG_QUEST_SUBMIT_CONFIRM, DIALOG_STYLE_MSGBOX,
        "{3498DB}Submit Quest Fish", dialog, "Submit", "Cancel");
}

stock OnQuestSubmitDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_QUEST_SUBMIT_CONFIRM)
    {
        if(!response)
        {
            DeletePVar(playerid, "QuestSubmitSpeciesID");
            DeletePVar(playerid, "QuestSubmitAmount");
            return 1;
        }
        
        new targetSpeciesID = GetPVarInt(playerid, "QuestSubmitSpeciesID");
        new targetAmount = GetPVarInt(playerid, "QuestSubmitAmount");
        
        // Delete the fish from inventory
        new query[512];
        mysql_format(connectionID, query, sizeof(query),
            "DELETE FROM fishing_inventory WHERE player_id = %d AND fish_species_id = %d LIMIT %d",
            PlayerFishingData[playerid][pFishingDBID],
            targetSpeciesID,
            targetAmount);
        
        mysql_tquery(connectionID, query);
        
        // Complete the quest
        new questIdx = GetPlayerQuestIndex(playerid);
        if(questIdx != -1)
        {
            PlayerFishingData[playerid][pDailyQuestProgress] = targetAmount;
            CompleteDailyQuest(playerid, questIdx);
        }
        
        DeletePVar(playerid, "QuestSubmitSpeciesID");
        DeletePVar(playerid, "QuestSubmitAmount");
        
        return 1;
    }
    
    return 0;
}
