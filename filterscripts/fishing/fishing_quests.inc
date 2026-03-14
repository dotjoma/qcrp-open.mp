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
    DailyQuests[0][questTokenReward] = 1;
    format(DailyQuests[0][questDescription], 128, "Catch 5 fish");
    
    // Quest 2: Catch 10 fish
    DailyQuests[1][questID] = 2;
    DailyQuests[1][questType] = QUEST_TYPE_CATCH_AMOUNT;
    DailyQuests[1][questTargetAmount] = 10;
    DailyQuests[1][questTargetRarity] = -1;
    DailyQuests[1][questTargetWeight] = 0.0;
    DailyQuests[1][questTokenReward] = 1;
    format(DailyQuests[1][questDescription], 128, "Catch 10 fish");
    
    // Quest 3: Catch 1 uncommon fish
    DailyQuests[2][questID] = 3;
    DailyQuests[2][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[2][questTargetAmount] = 1;
    DailyQuests[2][questTargetRarity] = RARITY_UNCOMMON;
    DailyQuests[2][questTargetWeight] = 0.0;
    DailyQuests[2][questTokenReward] = 1;
    format(DailyQuests[2][questDescription], 128, "Catch 1 Uncommon fish");
    
    // Quest 4: Catch 1 rare fish
    DailyQuests[3][questID] = 4;
    DailyQuests[3][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[3][questTargetAmount] = 1;
    DailyQuests[3][questTargetRarity] = RARITY_RARE;
    DailyQuests[3][questTargetWeight] = 0.0;
    DailyQuests[3][questTokenReward] = 1;
    format(DailyQuests[3][questDescription], 128, "Catch 1 Rare fish");
    
    // Quest 5: Catch 1 legendary fish
    DailyQuests[4][questID] = 5;
    DailyQuests[4][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[4][questTargetAmount] = 1;
    DailyQuests[4][questTargetRarity] = RARITY_LEGENDARY;
    DailyQuests[4][questTargetWeight] = 0.0;
    DailyQuests[4][questTokenReward] = 1;
    format(DailyQuests[4][questDescription], 128, "Catch 1 Legendary fish");
    
    // Quest 6: Catch fish totaling 10kg
    DailyQuests[5][questID] = 6;
    DailyQuests[5][questType] = QUEST_TYPE_CATCH_WEIGHT;
    DailyQuests[5][questTargetAmount] = 0;
    DailyQuests[5][questTargetRarity] = -1;
    DailyQuests[5][questTargetWeight] = 10.0;
    DailyQuests[5][questTokenReward] = 1;
    format(DailyQuests[5][questDescription], 128, "Catch fish totaling 10kg");
    
    // Quest 7: Catch fish totaling 25kg
    DailyQuests[6][questID] = 7;
    DailyQuests[6][questType] = QUEST_TYPE_CATCH_WEIGHT;
    DailyQuests[6][questTargetAmount] = 0;
    DailyQuests[6][questTargetRarity] = -1;
    DailyQuests[6][questTargetWeight] = 25.0;
    DailyQuests[6][questTokenReward] = 1;
    format(DailyQuests[6][questDescription], 128, "Catch fish totaling 25kg");
    
    // Quest 8: Catch 3 uncommon fish
    DailyQuests[7][questID] = 8;
    DailyQuests[7][questType] = QUEST_TYPE_CATCH_RARITY;
    DailyQuests[7][questTargetAmount] = 3;
    DailyQuests[7][questTargetRarity] = RARITY_UNCOMMON;
    DailyQuests[7][questTargetWeight] = 0.0;
    DailyQuests[7][questTokenReward] = 1;
    format(DailyQuests[7][questDescription], 128, "Catch 3 Uncommon fish");
    
    TotalDailyQuests = 8;
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
        "{2ECC71}╔════════════════════════════════════╗");
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(playerid, -1, 
        "{2ECC71}║ {FFFFFF}DAILY QUEST COMPLETED!");
    
    format(string, sizeof(string), 
        "{2ECC71}║ {FFFFFF}Reward: {F39C12}%d Fishing Tokens", tokenReward);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}╚════════════════════════════════════╝");
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
    
    SendClientMessage(playerid, 0x3498DBFF, "═══════════════════════════════════");
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
        }
        
        format(string, sizeof(string), 
            "{FFFFFF}Reward: {F39C12}%d Fishing Tokens",
            DailyQuests[questIdx][questTokenReward]);
        SendClientMessage(playerid, -1, string);
    }
    
    SendClientMessage(playerid, 0x3498DBFF, "═══════════════════════════════════");
    
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
