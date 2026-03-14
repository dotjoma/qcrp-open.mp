/*
    FISHING RPG SYSTEM - EQUIPMENT MODULE
    Rod and bait system management
*/

#if defined _fishing_equipment_included
    #endinput
#endif
#define _fishing_equipment_included

// ============================================
// FISHING RODS
// ============================================

stock LoadFishingRods()
{
    // Load from database or define static data
    // Example static data:
    
    // Rod 1: Basic Rod
    FishingRods[0][rodID] = 1;
    format(FishingRods[0][rodName], 64, "Basic Fishing Rod");
    FishingRods[0][rodBiteSpeedBonus] = 0;
    FishingRods[0][rodRareChanceBonus] = 0;
    FishingRods[0][rodComboBonus] = 0;
    FishingRods[0][rodTokenPrice] = 2500; // Cash price
    FishingRods[0][rodRequiredLevel] = 1;
    
    // Rod 2: Amateur Rod
    FishingRods[1][rodID] = 2;
    format(FishingRods[1][rodName], 64, "Amateur Fishing Rod");
    FishingRods[1][rodBiteSpeedBonus] = 10;
    FishingRods[1][rodRareChanceBonus] = 5;
    FishingRods[1][rodComboBonus] = 5;
    FishingRods[1][rodTokenPrice] = 5000; // Cash price
    FishingRods[1][rodRequiredLevel] = 5;
    
    // Rod 3: Pro Rod
    FishingRods[2][rodID] = 3;
    format(FishingRods[2][rodName], 64, "Pro Fishing Rod");
    FishingRods[2][rodBiteSpeedBonus] = 20;
    FishingRods[2][rodRareChanceBonus] = 10;
    FishingRods[2][rodComboBonus] = 10;
    FishingRods[2][rodTokenPrice] = 10000; // Cash price
    FishingRods[2][rodRequiredLevel] = 15;
    
    // Rod 4: Expert Rod
    FishingRods[3][rodID] = 4;
    format(FishingRods[3][rodName], 64, "Expert Fishing Rod");
    FishingRods[3][rodBiteSpeedBonus] = 30;
    FishingRods[3][rodRareChanceBonus] = 15;
    FishingRods[3][rodComboBonus] = 15;
    FishingRods[3][rodTokenPrice] = 25000; // Cash price
    FishingRods[3][rodRequiredLevel] = 30;
    
    // Rod 5: Master Rod
    FishingRods[4][rodID] = 5;
    format(FishingRods[4][rodName], 64, "Master Fishing Rod");
    FishingRods[4][rodBiteSpeedBonus] = 40;
    FishingRods[4][rodRareChanceBonus] = 25;
    FishingRods[4][rodComboBonus] = 20;
    FishingRods[4][rodTokenPrice] = 50000; // Cash price
    FishingRods[4][rodRequiredLevel] = 50;
    
    // Rod 6: Legendary Rod
    FishingRods[5][rodID] = 6;
    format(FishingRods[5][rodName], 64, "Legendary Fishing Rod");
    FishingRods[5][rodBiteSpeedBonus] = 50;
    FishingRods[5][rodRareChanceBonus] = 35;
    FishingRods[5][rodComboBonus] = 30;
    FishingRods[5][rodTokenPrice] = 100000; // Cash price
    FishingRods[5][rodRequiredLevel] = 75;
    
    TotalFishingRods = 6;
}

stock GetRodData(rod_id, &biteBonus, &rareBonus, &comboBonus)
{
    for(new i = 0; i < TotalFishingRods; i++)
    {
        if(FishingRods[i][rodID] == rod_id)
        {
            biteBonus = FishingRods[i][rodBiteSpeedBonus];
            rareBonus = FishingRods[i][rodRareChanceBonus];
            comboBonus = FishingRods[i][rodComboBonus];
            return 1;
        }
    }
    return 0;
}


// ============================================
// FISHING BAIT
// ============================================

stock LoadFishingBait()
{
    // Bait 1: Basic Worm
    FishingBait[0][baitID] = 1;
    format(FishingBait[0][baitName], 64, "Worm Bait");
    FishingBait[0][baitBiteSpeedBonus] = 0;
    FishingBait[0][baitRareChanceBonus] = 0;
    FishingBait[0][baitTokenPrice] = 1; // $100 for 10 worms
    
    // Bait 2: Shrimp
    FishingBait[1][baitID] = 2;
    format(FishingBait[1][baitName], 64, "Shrimp Bait");
    FishingBait[1][baitBiteSpeedBonus] = 15;
    FishingBait[1][baitRareChanceBonus] = 5;
    FishingBait[1][baitTokenPrice] = 2;
    
    // Bait 3: Minnow
    FishingBait[2][baitID] = 3;
    format(FishingBait[2][baitName], 64, "Minnow Bait");
    FishingBait[2][baitBiteSpeedBonus] = 20;
    FishingBait[2][baitRareChanceBonus] = 10;
    FishingBait[2][baitTokenPrice] = 5;
    
    // Bait 4: Golden Bait
    FishingBait[3][baitID] = 4;
    format(FishingBait[3][baitName], 64, "Golden Bait");
    FishingBait[3][baitBiteSpeedBonus] = 30;
    FishingBait[3][baitRareChanceBonus] = 20;
    FishingBait[3][baitTokenPrice] = 10;
    
    // Bait 5: Legendary Lure
    FishingBait[4][baitID] = 5;
    format(FishingBait[4][baitName], 64, "Legendary Lure");
    FishingBait[4][baitBiteSpeedBonus] = 40;
    FishingBait[4][baitRareChanceBonus] = 30;
    FishingBait[4][baitTokenPrice] = 20;
    
    TotalFishingBait = 5;
}

stock GetBaitData(bait_id, &biteBonus, &rareBonus)
{
    for(new i = 0; i < TotalFishingBait; i++)
    {
        if(FishingBait[i][baitID] == bait_id)
        {
            biteBonus = FishingBait[i][baitBiteSpeedBonus];
            rareBonus = FishingBait[i][baitRareChanceBonus];
            return 1;
        }
    }
    return 0;
}

// ============================================
// HELPER FUNCTIONS FOR BONUSES
// ============================================

forward GetPlayerBiteSpeedBonus(playerid);
public GetPlayerBiteSpeedBonus(playerid)
{
    new rod_bite, rod_rare, rod_combo;
    GetRodData(PlayerFishingData[playerid][pFishingRodID], rod_bite, rod_rare, rod_combo);
    
    new bait_bite, bait_rare;
    GetBaitData(PlayerFishingData[playerid][pFishingBaitID], bait_bite, bait_rare);
    
    return rod_bite + bait_bite;
}

forward GetPlayerRareChanceBonus(playerid);
public GetPlayerRareChanceBonus(playerid)
{
    new rod_bite, rod_rare, rod_combo;
    GetRodData(PlayerFishingData[playerid][pFishingRodID], rod_bite, rod_rare, rod_combo);
    
    new bait_bite, bait_rare;
    GetBaitData(PlayerFishingData[playerid][pFishingBaitID], bait_bite, bait_rare);
    
    return rod_rare + bait_rare;
}

forward GetPlayerComboBonus(playerid);
public GetPlayerComboBonus(playerid)
{
    new rod_bite, rod_rare, rod_combo;
    GetRodData(PlayerFishingData[playerid][pFishingRodID], rod_bite, rod_rare, rod_combo);
    
    return rod_combo;
}

// ============================================
// DIALOG IDS
// ============================================

#define DIALOG_FISHING_SHOP_MAIN    9000
#define DIALOG_FISHING_SHOP_RODS    9001
#define DIALOG_FISHING_SHOP_BAIT    9002
#define DIALOG_FISHING_BUY_CONFIRM  9003

// ============================================
// EQUIPMENT COMMANDS
// ============================================

CMD:fishingshop(playerid, params[])
{
    // Check if player is near a fishing actor
    new actoridx = CheckPlayerNearActor(playerid);
    if(actoridx == -1)
    {
        SendClientMessage(playerid, 0xE74C3CFF, 
            "{E74C3C}[FISHING]{FFFFFF} You must be near a fishing actor to access the shop!");
        SendClientMessage(playerid, -1, 
            "{FFFFFF}Press {FFFF00}Y{FFFFFF} near a fishing actor to access services.");
        return 1;
    }
    
    ShowFishingShopMain(playerid);
    return 1;
}

stock ShowFishingShopMain(playerid)
{
    new cash = CallRemoteFunction("GetPlayerCash", "i", playerid);
    new string[512];
    format(string, sizeof(string), 
        "{2ECC71}Fishing Rods\n\
        {3498DB}Fishing Bait",
        cash,
        PlayerFishingData[playerid][pFishingTokens]);
    
    new header[256];
    format(header, sizeof(header), 
        "{2ECC71}Fishing Shop {FFFFFF}| Cash: {2ECC71}$%d {FFFFFF}| Tokens: {3498DB}%d",
        cash,
        PlayerFishingData[playerid][pFishingTokens]);
    
    ShowPlayerDialog(playerid, DIALOG_FISHING_SHOP_MAIN, DIALOG_STYLE_LIST, 
        header, string, "Select", "Close");
}

stock ShowFishingRodsShop(playerid)
{
    printf("[FISHING EQUIPMENT DEBUG] ShowFishingRodsShop called for player %d", playerid);
    
    new cash = CallRemoteFunction("GetPlayerCash", "i", playerid);
    new string[2048], line[256];
    
    // Build list of rods (each rod is ONE list item)
    for(new i = 0; i < TotalFishingRods; i++)
    {
        new status[64];
        if(PlayerFishingData[playerid][pFishingRodID] == FishingRods[i][rodID])
            format(status, sizeof(status), "{2ECC71}[OWNED] ");
        else if(PlayerFishingData[playerid][pFishingLevel] < FishingRods[i][rodRequiredLevel])
            format(status, sizeof(status), "{E74C3C}[LOCKED - Lvl %d] ", FishingRods[i][rodRequiredLevel]);
        else
            format(status, sizeof(status), "");
        
        format(line, sizeof(line), 
            "%s%s {FFFFFF}- Speed:+%d%% Rare:+%d%% Combo:+%d%% - $%d",
            status,
            FishingRods[i][rodName],
            FishingRods[i][rodBiteSpeedBonus],
            FishingRods[i][rodRareChanceBonus],
            FishingRods[i][rodComboBonus],
            FishingRods[i][rodTokenPrice]); // Removed * 1000
        
        strcat(string, line);
        if(i < TotalFishingRods - 1) strcat(string, "\n");
    }
    
    new header[256];
    format(header, sizeof(header), 
        "{2ECC71}Fishing Rods {FFFFFF}| Cash: {2ECC71}$%d {FFFFFF}| Tokens: {3498DB}%d",
        cash,
        PlayerFishingData[playerid][pFishingTokens]);
    
    printf("[FISHING EQUIPMENT DEBUG] Showing DIALOG_FISHING_SHOP_RODS (%d) with %d rods", DIALOG_FISHING_SHOP_RODS, TotalFishingRods);
    ShowPlayerDialog(playerid, DIALOG_FISHING_SHOP_RODS, DIALOG_STYLE_LIST, 
        header, string, "Buy", "Back");
}

stock ShowFishingBaitShop(playerid)
{
    printf("[FISHING EQUIPMENT DEBUG] ShowFishingBaitShop called for player %d", playerid);
    
    new cash = CallRemoteFunction("GetPlayerCash", "i", playerid);
    new string[1536], line[256];
    
    // Build list of baits (each bait is ONE list item)
    for(new i = 0; i < TotalFishingBait; i++)
    {
        format(line, sizeof(line), 
            "%s {FFFFFF}- Speed:+%d%% Rare:+%d%% - $%d (x10)",
            FishingBait[i][baitName],
            FishingBait[i][baitBiteSpeedBonus],
            FishingBait[i][baitRareChanceBonus],
            FishingBait[i][baitTokenPrice] * 100);
        
        strcat(string, line);
        if(i < TotalFishingBait - 1) strcat(string, "\n");
    }
    
    new header[256];
    new currentBait[64];
    
    if(PlayerFishingData[playerid][pFishingBaitID] > 0)
        format(currentBait, sizeof(currentBait), "%s", FishingBait[PlayerFishingData[playerid][pFishingBaitID]-1][baitName]);
    else
        format(currentBait, sizeof(currentBait), "None");
    
    format(header, sizeof(header), 
        "{3498DB}Fishing Bait {FFFFFF}| Cash: {2ECC71}$%d {FFFFFF}| Current: {3498DB}%s {FFFFFF}(x%d)",
        cash,
        currentBait,
        PlayerFishingData[playerid][pFishingBaitAmount]);
    
    printf("[FISHING EQUIPMENT DEBUG] Showing DIALOG_FISHING_SHOP_BAIT (%d) with %d baits", DIALOG_FISHING_SHOP_BAIT, TotalFishingBait);
    ShowPlayerDialog(playerid, DIALOG_FISHING_SHOP_BAIT, DIALOG_STYLE_LIST, 
        header, string, "Buy", "Back");
}


// ============================================
// DIALOG RESPONSE HANDLER
// ============================================

stock OnFishingEquipmentDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    printf("[FISHING EQUIPMENT DEBUG] Dialog: %d, Response: %d, Listitem: %d", dialogid, response, listitem);
    
    switch(dialogid)
    {
        case DIALOG_FISHING_SHOP_MAIN:
        {
            if(!response) return 1;
            
            printf("[FISHING EQUIPMENT DEBUG] Main shop - listitem: %d", listitem);
            
            switch(listitem)
            {
                case 0: 
                {
                    printf("[FISHING EQUIPMENT DEBUG] Showing Fishing Rods Shop");
                    ShowFishingRodsShop(playerid); // Fishing Rods
                }
                case 1: 
                {
                    printf("[FISHING EQUIPMENT DEBUG] Showing Fishing Bait Shop");
                    ShowFishingBaitShop(playerid); // Fishing Bait
                }
            }
            return 1;
        }
        
        case DIALOG_FISHING_SHOP_RODS:
        {
            if(!response)
            {
                ShowFishingShopMain(playerid);
                return 1;
            }
            
            if(listitem >= TotalFishingRods) return 1;
            
            new rodIndex = listitem;
            new rodPrice = FishingRods[rodIndex][rodTokenPrice]; // Removed * 1000
            
            // Check if already owned
            if(PlayerFishingData[playerid][pFishingRodID] == FishingRods[rodIndex][rodID])
            {
                SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} You already own this fishing rod!");
                ShowFishingRodsShop(playerid);
                return 1;
            }
            
            // Check level requirement
            if(PlayerFishingData[playerid][pFishingLevel] < FishingRods[rodIndex][rodRequiredLevel])
            {
                new string[128];
                format(string, sizeof(string), "{E74C3C}[FISHING]{FFFFFF} You need to be level %d to buy this rod!", 
                    FishingRods[rodIndex][rodRequiredLevel]);
                SendClientMessage(playerid, 0xE74C3CFF, string);
                ShowFishingRodsShop(playerid);
                return 1;
            }
            
            // Check if player has enough cash
            new playerCash = CallRemoteFunction("GetPlayerCash", "i", playerid);
            if(playerCash < rodPrice)
            {
                new string[128];
                format(string, sizeof(string), "{E74C3C}[FISHING]{FFFFFF} You don't have enough cash! You need $%d.", rodPrice);
                SendClientMessage(playerid, 0xE74C3CFF, string);
                ShowFishingRodsShop(playerid);
                return 1;
            }
            
            // Show confirmation dialog
            SetPVarInt(playerid, "FishingShopItem", rodIndex);
            SetPVarInt(playerid, "FishingShopType", 0); // 0 = rod
            
            new string[256];
            format(string, sizeof(string), 
                "{FFFFFF}Are you sure you want to buy:\n\n\
                {2ECC71}%s\n\n\
                {FFFFFF}Speed Bonus: {2ECC71}+%d%%\n\
                {FFFFFF}Rare Chance: {2ECC71}+%d%%\n\
                {FFFFFF}Combo Bonus: {2ECC71}+%d%%\n\n\
                {F39C12}Price: {FFFFFF}$%d",
                FishingRods[rodIndex][rodName],
                FishingRods[rodIndex][rodBiteSpeedBonus],
                FishingRods[rodIndex][rodRareChanceBonus],
                FishingRods[rodIndex][rodComboBonus],
                rodPrice);
            
            ShowPlayerDialog(playerid, DIALOG_FISHING_BUY_CONFIRM, DIALOG_STYLE_MSGBOX, 
                "{2ECC71}Confirm Purchase", string, "Buy", "Cancel");
            return 1;
        }
        
        case DIALOG_FISHING_SHOP_BAIT:
        {
            if(!response)
            {
                ShowFishingShopMain(playerid);
                return 1;
            }
            
            if(listitem >= TotalFishingBait) return 1;
            
            new baitIndex = listitem;
            new baitPrice = FishingBait[baitIndex][baitTokenPrice] * 100;
            
            // Check if player has enough cash
            new playerCash = CallRemoteFunction("GetPlayerCash", "i", playerid);
            if(playerCash < baitPrice)
            {
                new string[128];
                format(string, sizeof(string), "{E74C3C}[FISHING]{FFFFFF} You don't have enough cash! You need $%d.", baitPrice);
                SendClientMessage(playerid, 0xE74C3CFF, string);
                ShowFishingBaitShop(playerid);
                return 1;
            }
            
            // Show confirmation dialog
            SetPVarInt(playerid, "FishingShopItem", baitIndex);
            SetPVarInt(playerid, "FishingShopType", 1); // 1 = bait
            
            new string[256];
            format(string, sizeof(string), 
                "{FFFFFF}Are you sure you want to buy:\n\n\
                {3498DB}%s {FFFFFF}(x10)\n\n\
                {FFFFFF}Speed Bonus: {2ECC71}+%d%%\n\
                {FFFFFF}Rare Chance: {2ECC71}+%d%%\n\n\
                {F39C12}Price: {FFFFFF}$%d",
                FishingBait[baitIndex][baitName],
                FishingBait[baitIndex][baitBiteSpeedBonus],
                FishingBait[baitIndex][baitRareChanceBonus],
                baitPrice);
            
            ShowPlayerDialog(playerid, DIALOG_FISHING_BUY_CONFIRM, DIALOG_STYLE_MSGBOX, 
                "{3498DB}Confirm Purchase", string, "Buy", "Cancel");
            return 1;
        }
        
        case DIALOG_FISHING_BUY_CONFIRM:
        {
            if(!response)
            {
                DeletePVar(playerid, "FishingShopItem");
                DeletePVar(playerid, "FishingShopType");
                ShowFishingShopMain(playerid);
                return 1;
            }
            
            new itemIndex = GetPVarInt(playerid, "FishingShopItem");
            new itemType = GetPVarInt(playerid, "FishingShopType");
            
            if(itemType == 0) // Rod purchase
            {
                new rodPrice = FishingRods[itemIndex][rodTokenPrice]; // Removed * 1000
                
                // Double check cash
                new playerCash = CallRemoteFunction("GetPlayerCash", "i", playerid);
                if(playerCash < rodPrice)
                {
                    SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} You don't have enough cash!");
                    DeletePVar(playerid, "FishingShopItem");
                    DeletePVar(playerid, "FishingShopType");
                    return 1;
                }
                
                // Process purchase
                CallRemoteFunction("GivePlayerCashEx", "ii", playerid, -rodPrice);
                PlayerFishingData[playerid][pFishingRodID] = FishingRods[itemIndex][rodID];
                
                // Update database
                new query[256];
                format(query, sizeof(query), 
                    "UPDATE fishing_players SET rod_id = %d WHERE player_id = %d",
                    FishingRods[itemIndex][rodID],
                    PlayerFishingData[playerid][pFishingDBID]);
                mysql_tquery(connectionID, query);
                
                new string[128];
                format(string, sizeof(string), "{2ECC71}[FISHING]{FFFFFF} You purchased a %s for $%d!", 
                    FishingRods[itemIndex][rodName], rodPrice);
                SendClientMessage(playerid, 0x2ECC71FF, string);
            }
            else // Bait purchase
            {
                new baitPrice = FishingBait[itemIndex][baitTokenPrice] * 100;
                
                // Double check cash
                new playerCash = CallRemoteFunction("GetPlayerCash", "i", playerid);
                if(playerCash < baitPrice)
                {
                    SendClientMessage(playerid, 0xE74C3CFF, "{E74C3C}[FISHING]{FFFFFF} You don't have enough cash!");
                    DeletePVar(playerid, "FishingShopItem");
                    DeletePVar(playerid, "FishingShopType");
                    return 1;
                }
                
                // Process purchase
                CallRemoteFunction("GivePlayerCashEx", "ii", playerid, -baitPrice);
                PlayerFishingData[playerid][pFishingBaitID] = FishingBait[itemIndex][baitID];
                PlayerFishingData[playerid][pFishingBaitAmount] += 10;
                
                // Update database
                new query[256];
                format(query, sizeof(query), 
                    "UPDATE fishing_players SET bait_id = %d, bait_amount = %d WHERE player_id = %d",
                    FishingBait[itemIndex][baitID],
                    PlayerFishingData[playerid][pFishingBaitAmount],
                    PlayerFishingData[playerid][pFishingDBID]);
                mysql_tquery(connectionID, query);
                
                new string[128];
                format(string, sizeof(string), "{3498DB}[FISHING]{FFFFFF} You purchased 10x %s for $%d!", 
                    FishingBait[itemIndex][baitName], baitPrice);
                SendClientMessage(playerid, 0x3498DBFF, string);
            }
            
            DeletePVar(playerid, "FishingShopItem");
            DeletePVar(playerid, "FishingShopType");
            ShowFishingShopMain(playerid);
            return 1;
        }
    }
    
    return 0;
}
