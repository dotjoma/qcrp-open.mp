/*
    FISHING RPG SYSTEM - CATCH MODULE
    Fish generation, rarity calculation, weight system
*/

#if defined _fishing_catch_included
    #endinput
#endif
#define _fishing_catch_included

// ============================================
// FISH SPECIES DATABASE
// ============================================

stock LoadFishSpecies()
{
    
    // ===== BEACH ZONES =====
    // Common fish
    AddFishSpecies("Sardine", RARITY_COMMON, 0.2, 0.5, 50, 5, ZONE_TYPE_BEACH, "any");
    AddFishSpecies("Mackerel", RARITY_COMMON, 0.5, 1.2, 75, 8, ZONE_TYPE_BEACH, "any");
    
    // Uncommon fish
    AddFishSpecies("Sea Bass", RARITY_UNCOMMON, 1.0, 3.0, 150, 15, ZONE_TYPE_BEACH, "any");
    AddFishSpecies("Snapper", RARITY_UNCOMMON, 1.5, 3.5, 180, 18, ZONE_TYPE_BEACH, "morning");
    
    // Rare fish
    AddFishSpecies("Grouper", RARITY_RARE, 3.0, 8.0, 400, 40, ZONE_TYPE_BEACH, "any");
    AddFishSpecies("Barracuda", RARITY_RARE, 4.0, 10.0, 500, 50, ZONE_TYPE_BEACH, "evening");
    
    // Legendary fish
    AddFishSpecies("Golden Marlin", RARITY_LEGENDARY, 15.0, 30.0, 2000, 200, ZONE_TYPE_BEACH, "night");
    
    // ===== RIVER ZONES =====
    // Common fish
    AddFishSpecies("Catfish", RARITY_COMMON, 0.8, 2.0, 60, 6, ZONE_TYPE_RIVER, "any");
    AddFishSpecies("Carp", RARITY_COMMON, 1.0, 3.0, 80, 8, ZONE_TYPE_RIVER, "any");
    
    // Uncommon fish
    AddFishSpecies("Pike", RARITY_UNCOMMON, 2.0, 5.0, 170, 17, ZONE_TYPE_RIVER, "morning");
    AddFishSpecies("Trout", RARITY_UNCOMMON, 1.5, 4.0, 140, 14, ZONE_TYPE_RIVER, "any");
    
    // Rare fish
    AddFishSpecies("Salmon", RARITY_RARE, 4.0, 12.0, 440, 45, ZONE_TYPE_RIVER, "morning");
    AddFishSpecies("Sturgeon", RARITY_RARE, 8.0, 20.0, 700, 70, ZONE_TYPE_RIVER, "any");
    
    // Legendary fish
    AddFishSpecies("Ancient Catfish", RARITY_LEGENDARY, 25.0, 50.0, 3000, 300, ZONE_TYPE_RIVER, "night");
    
    // ===== LAKE ZONES =====
    // Common fish
    AddFishSpecies("Bluegill", RARITY_COMMON, 0.3, 0.8, 55, 5, ZONE_TYPE_LAKE, "any");
    AddFishSpecies("Perch", RARITY_COMMON, 0.5, 1.5, 70, 7, ZONE_TYPE_LAKE, "any");
    
    // Uncommon fish
    AddFishSpecies("Walleye", RARITY_UNCOMMON, 1.5, 4.0, 160, 16, ZONE_TYPE_LAKE, "evening");
    AddFishSpecies("Crappie", RARITY_UNCOMMON, 1.0, 2.5, 120, 12, ZONE_TYPE_LAKE, "any");
    
    // Rare fish
    AddFishSpecies("Muskie", RARITY_RARE, 5.0, 15.0, 560, 55, ZONE_TYPE_LAKE, "any");
    AddFishSpecies("Lake Trout", RARITY_RARE, 3.0, 10.0, 400, 40, ZONE_TYPE_LAKE, "morning");
    
    // Legendary fish
    AddFishSpecies("Crystal Bass", RARITY_LEGENDARY, 20.0, 40.0, 2400, 250, ZONE_TYPE_LAKE, "night");
    
    // ===== DEEP SEA ZONES =====
    // Common fish
    AddFishSpecies("Tuna", RARITY_COMMON, 5.0, 15.0, 200, 20, ZONE_TYPE_DEEPSEA, "any");
    AddFishSpecies("Bonito", RARITY_COMMON, 3.0, 8.0, 160, 16, ZONE_TYPE_DEEPSEA, "any");
    
    // Uncommon fish
    AddFishSpecies("Mahi-Mahi", RARITY_UNCOMMON, 8.0, 20.0, 360, 35, ZONE_TYPE_DEEPSEA, "any");
    AddFishSpecies("Wahoo", RARITY_UNCOMMON, 10.0, 25.0, 440, 45, ZONE_TYPE_DEEPSEA, "morning");
    
    // Rare fish
    AddFishSpecies("Swordfish", RARITY_RARE, 30.0, 80.0, 1000, 100, ZONE_TYPE_DEEPSEA, "any");
    AddFishSpecies("Sailfish", RARITY_RARE, 25.0, 70.0, 900, 90, ZONE_TYPE_DEEPSEA, "evening");
    
    // Legendary fish
    AddFishSpecies("Leviathan", RARITY_LEGENDARY, 100.0, 200.0, 10000, 1000, ZONE_TYPE_DEEPSEA, "night");
    
    printf("[FISHING] Loaded %d fish species", TotalFishSpecies);
}

stock AddFishSpecies(const name[], rarity, Float:minWeight, Float:maxWeight, baseValue, expReward, zone_type, const timeRestriction[])
{
    new idx = TotalFishSpecies;
    
    FishSpecies[idx][fishID] = idx + 1;
    format(FishSpecies[idx][fishName], 64, "%s", name);
    FishSpecies[idx][fishRarity] = rarity;
    FishSpecies[idx][fishMinWeight] = minWeight;
    FishSpecies[idx][fishMaxWeight] = maxWeight;
    FishSpecies[idx][fishBaseValue] = baseValue;
    FishSpecies[idx][fishExpReward] = expReward;
    FishSpecies[idx][fishZoneID] = zone_type; // Now stores zone TYPE instead of zone ID
    format(FishSpecies[idx][fishTimeRestriction], 32, "%s", timeRestriction);
    
    TotalFishSpecies++;
    return idx;
}


// ============================================
// FISH GENERATION & RARITY CALCULATION
// ============================================

forward GenerateFish(playerid, zone_type);
public GenerateFish(playerid, zone_type)
{
    printf("[FISHING DEBUG] GenerateFish called - playerid: %d, zone_type: %d", playerid, zone_type);
    printf("[FISHING DEBUG] TotalFishSpecies loaded: %d", TotalFishSpecies);
    
    // Calculate total bonuses
    new rodBiteBonus, rodRareBonus, rodComboBonus_unused;
    GetRodData(PlayerFishingData[playerid][pFishingRodID], rodBiteBonus, rodRareBonus, rodComboBonus_unused);
    
    new baitBiteBonus, baitRareBonus;
    GetBaitData(PlayerFishingData[playerid][pFishingBaitID], baitBiteBonus, baitRareBonus);
    
    // Calculate rarity chance
    new baseRareChance = 10 + (PlayerFishingData[playerid][pFishingLevel] / 2); // 10-60%
    new totalRareBonus = rodRareBonus + baitRareBonus;
    
    // Combo bonus (using rodComboBonus from equipment)
    if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER3)
        totalRareBonus += 15;
    else if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER2)
        totalRareBonus += 10;
    else if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER1)
        totalRareBonus += 5;
    
    // Time of day bonus
    new timeOfDay = GetTimeOfDay();
    if(timeOfDay == TIME_NIGHT)
        totalRareBonus += 10; // Night bonus for rare fish
    
    new finalRareChance = baseRareChance + totalRareBonus;
    if(finalRareChance > 80) finalRareChance = 80; // Cap at 80%
    
    // Determine rarity
    new targetRarity = DetermineRarity(finalRareChance);
    
    printf("[FISHING DEBUG] Target rarity: %d, Time of day: %d", targetRarity, timeOfDay);
    
    // Get available fish for this zone TYPE and rarity
    new availableFish[MAX_FISH_SPECIES];
    new availableCount = 0;
    
    for(new i = 0; i < TotalFishSpecies; i++)
    {
        if(FishSpecies[i][fishZoneID] != zone_type) continue; // Match by zone TYPE
        if(FishSpecies[i][fishRarity] != targetRarity) continue;
        
        // Check time restriction
        if(!strcmp(FishSpecies[i][fishTimeRestriction], "any", true))
        {
            availableFish[availableCount++] = i;
        }
        else if(!strcmp(FishSpecies[i][fishTimeRestriction], "morning", true) && timeOfDay == TIME_MORNING)
        {
            availableFish[availableCount++] = i;
        }
        else if(!strcmp(FishSpecies[i][fishTimeRestriction], "night", true) && timeOfDay == TIME_NIGHT)
        {
            availableFish[availableCount++] = i;
        }
        else if(!strcmp(FishSpecies[i][fishTimeRestriction], "evening", true) && timeOfDay == TIME_EVENING)
        {
            availableFish[availableCount++] = i;
        }
    }
    
    printf("[FISHING DEBUG] Available fish count: %d", availableCount);
    
    // If no fish available for this rarity, try lower rarity
    if(availableCount == 0 && targetRarity > RARITY_COMMON)
    {
        printf("[FISHING DEBUG] No fish found for rarity %d, trying again...", targetRarity);
        return GenerateFish(playerid, zone_type); // Recursive call
    }
    
    // Select random fish from available
    if(availableCount > 0)
    {
        new selectedIdx = availableFish[random(availableCount)];
        
        printf("[FISHING DEBUG] Selected fish index: %d, Fish name: %s", selectedIdx, FishSpecies[selectedIdx][fishName]);
        
        // Generate weight
        new Float:weight = FishSpecies[selectedIdx][fishMinWeight] + 
            (random(1000) / 1000.0) * (FishSpecies[selectedIdx][fishMaxWeight] - FishSpecies[selectedIdx][fishMinWeight]);
        
        // Calculate value based on weight
        new value = CalculateFishValue(FishSpecies[selectedIdx][fishBaseValue], weight, 
            FishSpecies[selectedIdx][fishMinWeight], FishSpecies[selectedIdx][fishMaxWeight]);
        
        // Store caught fish data
        CaughtFish[playerid][caughtFishID] = FishSpecies[selectedIdx][fishID];
        format(CaughtFish[playerid][caughtFishName], 64, "%s", FishSpecies[selectedIdx][fishName]);
        CaughtFish[playerid][caughtFishRarity] = FishSpecies[selectedIdx][fishRarity];
        CaughtFish[playerid][caughtFishWeight] = weight;
        CaughtFish[playerid][caughtFishValue] = value;
        CaughtFish[playerid][caughtFishExp] = FishSpecies[selectedIdx][fishExpReward];
        
        printf("[FISHING DEBUG] Fish generated successfully - Name: %s, Weight: %.2f, Value: %d", 
            CaughtFish[playerid][caughtFishName], CaughtFish[playerid][caughtFishWeight], CaughtFish[playerid][caughtFishValue]);
        
        return 1;
    }
    
    printf("[FISHING DEBUG] No fish available! availableCount: %d", availableCount);
    return 0;
}

// ============================================
// HELPER FUNCTIONS FOR MINIGAME
// ============================================

forward GetCaughtFishRarity(playerid);
public GetCaughtFishRarity(playerid)
{
    return CaughtFish[playerid][caughtFishRarity];
}

forward Float:GetCaughtFishWeight(playerid);
public Float:GetCaughtFishWeight(playerid)
{
    return CaughtFish[playerid][caughtFishWeight];
}

forward Float:GetCaughtFishMinWeight(playerid);
public Float:GetCaughtFishMinWeight(playerid)
{
    // Find the fish species to get min weight
    for(new i = 0; i < TotalFishSpecies; i++)
    {
        if(FishSpecies[i][fishID] == CaughtFish[playerid][caughtFishID])
        {
            return FishSpecies[i][fishMinWeight];
        }
    }
    return 0.0;
}

forward Float:GetCaughtFishMaxWeight(playerid);
public Float:GetCaughtFishMaxWeight(playerid)
{
    // Find the fish species to get max weight
    for(new i = 0; i < TotalFishSpecies; i++)
    {
        if(FishSpecies[i][fishID] == CaughtFish[playerid][caughtFishID])
        {
            return FishSpecies[i][fishMaxWeight];
        }
    }
    return 1.0;
}

stock DetermineRarity(rareChance)
{
    new roll = random(100);
    
    // Legendary: 5% of rare chance
    if(roll < (rareChance / 20))
        return RARITY_LEGENDARY;
    
    // Rare: 15% of rare chance
    if(roll < (rareChance / 6))
        return RARITY_RARE;
    
    // Uncommon: 30% of rare chance
    if(roll < (rareChance / 3))
        return RARITY_UNCOMMON;
    
    // Common: everything else
    return RARITY_COMMON;
}

stock CalculateFishValue(baseValue, Float:weight, Float:minWeight, Float:maxWeight)
{
    // Value scales with weight
    new Float:weightRatio = (weight - minWeight) / (maxWeight - minWeight);
    new value = baseValue + floatround(baseValue * weightRatio * 0.5);
    return value;
}

// ============================================
// CATCH SUCCESS HANDLER
// ============================================

forward OnPlayerCatchFish(playerid);
public OnPlayerCatchFish(playerid)
{
    printf("[FISHING DEBUG] OnPlayerCatchFish called for playerid: %d", playerid);
    printf("[FISHING DEBUG] pFishingDBID: %d", PlayerFishingData[playerid][pFishingDBID]);
    printf("[FISHING DEBUG] pFishingLevel: %d", PlayerFishingData[playerid][pFishingLevel]);
    printf("[FISHING DEBUG] pFishingTotalCaught: %d", PlayerFishingData[playerid][pFishingTotalCaught]);
    
    // Consume bait on successful catch
    ConsumeFishingBait(playerid);
    
    // Update statistics
    PlayerFishingData[playerid][pFishingTotalCaught]++;
    PlayerFishingData[playerid][pFishingCombo]++;
    
    printf("[FISHING DEBUG] After increment - pFishingTotalCaught: %d, pFishingCombo: %d", 
        PlayerFishingData[playerid][pFishingTotalCaught],
        PlayerFishingData[playerid][pFishingCombo]);
    
    // Check for biggest fish
    if(CaughtFish[playerid][caughtFishWeight] > PlayerFishingData[playerid][pFishingBiggestWeight])
    {
        PlayerFishingData[playerid][pFishingBiggestWeight] = CaughtFish[playerid][caughtFishWeight];
    }
    
    // Count legendary fish
    if(CaughtFish[playerid][caughtFishRarity] == RARITY_LEGENDARY)
    {
        PlayerFishingData[playerid][pFishingLegendaryCount]++;
        
        // Announce to server
        new string[128], playerName[24];
        GetPlayerNameEx(playerid, playerName, sizeof(playerName));
        format(string, sizeof(string), 
            "{F39C12}[FISHING]{FFFFFF} %s caught a {F39C12}LEGENDARY %s{FFFFFF} weighing {F39C12}%.2fkg{FFFFFF}!",
            playerName, CaughtFish[playerid][caughtFishName], CaughtFish[playerid][caughtFishWeight]);
        SendClientMessageToAll(-1, string);
    }
    
    // Display catch info
    ShowCatchInfo(playerid);
    
    // Log the catch to fishing_log table
    LogFishCatch(playerid);
    
    // Add fish to player's inventory
    AddFishToInventory(playerid);
    
    // Give rewards (only experience, no cash - players must sell fish)
    GiveFishingExperience(playerid, CaughtFish[playerid][caughtFishExp]);
    
    // Update daily quest
    UpdateDailyQuestProgress(playerid, CaughtFish[playerid][caughtFishRarity], CaughtFish[playerid][caughtFishWeight]);
    
    // Update tournament
    if(TournamentData[tournamentActive])
    {
        UpdateTournamentScore(playerid, CaughtFish[playerid][caughtFishWeight], CaughtFish[playerid][caughtFishRarity]);
    }
    
    // Save data
    SavePlayerFishingData(playerid);
    UpdateLeaderboard(playerid);
}

stock ShowCatchInfo(playerid)
{
    printf("[FISHING DEBUG] ShowCatchInfo called for playerid: %d", playerid);
    printf("[FISHING DEBUG] Fish Name: %s", CaughtFish[playerid][caughtFishName]);
    printf("[FISHING DEBUG] Fish Rarity: %d", CaughtFish[playerid][caughtFishRarity]);
    printf("[FISHING DEBUG] Fish Weight: %.2f", CaughtFish[playerid][caughtFishWeight]);
    printf("[FISHING DEBUG] Fish Value: %d", CaughtFish[playerid][caughtFishValue]);
    printf("[FISHING DEBUG] Fish Exp: %d", CaughtFish[playerid][caughtFishExp]);
    
    // Play catch sound based on rarity
    // Stop the looping fishing music first
    StopFishingMusic(playerid);
    
    // Play success sound for all catches
    PlayCatchSuccessSound(playerid);
    
    new string[256];
    new rarityColor[16];
    format(rarityColor, sizeof(rarityColor), GetRarityColor(CaughtFish[playerid][caughtFishRarity]));
    
    format(string, sizeof(string), 
        "~g~FISH CAUGHT!");
    GameTextForPlayer(playerid, string, 2000, 3);
    
    format(string, sizeof(string), 
        "{2ECC71}_____________________________________");
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}- {FFFFFF}You caught: %s%s", 
        rarityColor, CaughtFish[playerid][caughtFishName]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}- {FFFFFF}Rarity: %s%s", 
        rarityColor, GetRarityName(CaughtFish[playerid][caughtFishRarity]));
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}- {FFFFFF}Weight: {3498DB}%.2fkg", 
        CaughtFish[playerid][caughtFishWeight]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}- {FFFFFF}Estimated Value: {2ECC71}$%d {FFFFFF}(sell at fish shop)", 
        CaughtFish[playerid][caughtFishValue]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), 
        "{2ECC71}- {FFFFFF}Experience: {3498DB}+%d", 
        CaughtFish[playerid][caughtFishExp]);
    SendClientMessage(playerid, -1, string);
    
    if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER1)
    {
        format(string, sizeof(string), 
            "{2ECC71}- {FFFFFF}Combo: {F39C12}x%d", 
            PlayerFishingData[playerid][pFishingCombo]);
        SendClientMessage(playerid, -1, string);
    }
    
    format(string, sizeof(string), 
        "{2ECC71}_____________________________________");
    SendClientMessage(playerid, -1, string);
}

stock OnPlayerFailCatch(playerid)
{
    // Reset combo
    if(PlayerFishingData[playerid][pFishingCombo] > 0)
    {
        new string[64];
        format(string, sizeof(string), 
            "{E74C3C}[FISHING]{FFFFFF} Combo broken! (was x%d)", 
            PlayerFishingData[playerid][pFishingCombo]);
        SendClientMessage(playerid, -1, string);
        
        PlayerFishingData[playerid][pFishingCombo] = 0;
    }
    
    SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} The fish got away!");
    GameTextForPlayer(playerid, "~r~FISH ESCAPED!", 2000, 3);
}

// ============================================
// FISHING LOG & INVENTORY SYSTEM
// ============================================

stock LogFishCatch(playerid)
{
    // Log catch to fishing_log table for analytics
    new query[512], rarityName[16];
    format(rarityName, sizeof(rarityName), "%s", GetRarityNameDB(CaughtFish[playerid][caughtFishRarity]));
    
    mysql_format(connectionID, query, sizeof(query),
        "INSERT INTO fishing_log (player_id, fish_name, fish_rarity, fish_weight, fish_value, zone_id) VALUES (%d, '%e', '%e', %f, %d, %d)",
        PlayerFishingData[playerid][pFishingDBID],
        CaughtFish[playerid][caughtFishName],
        rarityName,
        CaughtFish[playerid][caughtFishWeight],
        CaughtFish[playerid][caughtFishValue],
        PlayerFishingData[playerid][pFishingZoneID]);
    
    mysql_tquery(connectionID, query);
    
    printf("[FISHING DEBUG] Logged catch to fishing_log - player_id: %d, fish: %s", 
        PlayerFishingData[playerid][pFishingDBID], CaughtFish[playerid][caughtFishName]);
}

stock AddFishToInventory(playerid)
{
    // Check inventory space
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT COUNT(*) as count FROM fishing_inventory WHERE player_id = %d",
        PlayerFishingData[playerid][pFishingDBID]);
    
    mysql_tquery(connectionID, query, "OnCheckInventorySpace", "i", playerid);
}

forward OnCheckInventorySpace(playerid);
public OnCheckInventorySpace(playerid)
{
    new rows = cache_get_row_count(connectionID), count;
    
    if(rows)
    {
        count = cache_get_field_content_int(0, "count");
        
        if(count >= MAX_FISH_INVENTORY)
        {
            SendClientMessage(playerid, 0xE74C3CFF, 
                "{E74C3C}[FISHING]{FFFFFF} Your inventory is full! Sell some fish first. (/sellfish)");
            
            // Still give exp and update stats, but don't add to inventory
            return 1;
        }
    }
    
    // Add fish to inventory
    new query[512], rarityName[16];
    format(rarityName, sizeof(rarityName), "%s", GetRarityNameDB(CaughtFish[playerid][caughtFishRarity]));
    
    mysql_format(connectionID, query, sizeof(query),
        "INSERT INTO fishing_inventory (player_id, fish_name, fish_rarity, fish_weight, fish_value, zone_id) VALUES (%d, '%e', '%e', %f, %d, %d)",
        PlayerFishingData[playerid][pFishingDBID],
        CaughtFish[playerid][caughtFishName],
        rarityName,
        CaughtFish[playerid][caughtFishWeight],
        CaughtFish[playerid][caughtFishValue],
        PlayerFishingData[playerid][pFishingZoneID]);
    
    mysql_tquery(connectionID, query, "OnFishAddedToInventory", "i", playerid);
    
    return 1;
}

forward OnFishAddedToInventory(playerid);
public OnFishAddedToInventory(playerid)
{
    new insert_id = cache_insert_id();
    
    if(insert_id > 0)
    {
        new string[128];
        format(string, sizeof(string), 
            "{3498DB}[FISHING]{FFFFFF} Fish added to inventory! Use /myfish to view or /sellfish to sell.");
        SendClientMessage(playerid, -1, string);
        
        printf("[FISHING DEBUG] Fish added to inventory - ID: %d, player_id: %d", 
            insert_id, PlayerFishingData[playerid][pFishingDBID]);
    }
    else
    {
        SendClientMessage(playerid, 0xE74C3CFF, 
            "{E74C3C}[FISHING]{FFFFFF} Error adding fish to inventory!");
    }
}

stock GetRarityNameDB(rarity)
{
    new name[16];
    switch(rarity)
    {
        case RARITY_COMMON: name = "common";
        case RARITY_UNCOMMON: name = "uncommon";
        case RARITY_RARE: name = "rare";
        case RARITY_LEGENDARY: name = "legendary";
        default: name = "common";
    }
    return name;
}
