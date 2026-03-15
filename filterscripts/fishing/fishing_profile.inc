/*
    FISHING PROFILE & INVENTORY SYSTEM
    Comprehensive player fishing data viewer
*/

#if defined _fishing_profile_included
    #endinput
#endif
#define _fishing_profile_included

// Dialog IDs are now defined in fishing_data_structures.inc

// ============================================
// MAIN PROFILE COMMAND
// ============================================

CMD:fishprofile(playerid, params[])
{
    ShowFishingProfile(playerid);
    return 1;
}

CMD:fishingprofile(playerid, params[])
{
    ShowFishingProfile(playerid);
    return 1;
}

stock ShowFishingProfile(playerid)
{
    // Get rod name
    new rodNameStr[64] = "None";
    if(PlayerFishingData[playerid][pFishingRodID] > 0)
    {
        for(new i = 0; i < TotalFishingRods; i++)
        {
            if(FishingRods[i][rodID] == PlayerFishingData[playerid][pFishingRodID])
            {
                format(rodNameStr, sizeof(rodNameStr), "%s", FishingRods[i][rodName]);
                break;
            }
        }
    }
    
    // Get bait name
    new baitNameStr[64] = "None";
    if(PlayerFishingData[playerid][pFishingBaitID] > 0)
    {
        format(baitNameStr, sizeof(baitNameStr), "%s", 
            FishingBait[PlayerFishingData[playerid][pFishingBaitID]-1][baitName]);
    }
    
    // Clean list - each line is one option
    new string[256];
    format(string, sizeof(string),
        "{2ECC71}View Fish Inventory\n\
        {3498DB}View Equipment Details\n\
        {F39C12}View Statistics\n\
        {E74C3C}Close");
    
    // Put info in header
    new header[256];
    format(header, sizeof(header),
        "{2ECC71}Fishing Profile {FFFFFF}| Lvl {2ECC71}%d {FFFFFF}| Tokens {3498DB}%d {FFFFFF}| Rod: {FFFF00}%s {FFFFFF}| Bait: {FFFF00}%s {FFFFFF}(x%d)",
        PlayerFishingData[playerid][pFishingLevel],
        PlayerFishingData[playerid][pFishingTokens],
        rodNameStr,
        baitNameStr,
        PlayerFishingData[playerid][pFishingBaitAmount]);
    
    ShowPlayerDialog(playerid, DIALOG_FISHING_PROFILE, DIALOG_STYLE_LIST,
        header, string, "Select", "Close");
}

// ============================================
// FISH INVENTORY VIEWER
// ============================================

stock ShowFishInventoryDialog(playerid)
{
    printf("[FISHING PROFILE DEBUG] ShowFishInventoryDialog called for player %d", playerid);
    
    new query[256];
    mysql_format(connectionID, query, sizeof(query),
        "SELECT fish_name, fish_rarity, fish_weight, fish_value FROM fishing_inventory WHERE player_id = %d ORDER BY caught_at DESC LIMIT 20",
        PlayerFishingData[playerid][pFishingDBID]);
    
    printf("[FISHING PROFILE DEBUG] Query: %s", query);
    mysql_tquery(connectionID, query, "OnShowFishInventoryDialog", "i", playerid);
}

// Note: OnShowFishInventoryDialog callback is in fishing_rpg_master.pwn

// ============================================
// EQUIPMENT DETAILS VIEWER
// ============================================

stock ShowEquipmentDetails(playerid)
{
    new string[1024];
    
    // Rod details
    new rodInfo[256] = "{E74C3C}No rod equipped";
    if(PlayerFishingData[playerid][pFishingRodID] > 0)
    {
        for(new i = 0; i < TotalFishingRods; i++)
        {
            if(FishingRods[i][rodID] == PlayerFishingData[playerid][pFishingRodID])
            {
                format(rodInfo, sizeof(rodInfo),
                    "{2ECC71}%s\n\
                    {FFFFFF}Bite Speed Bonus: {2ECC71}+%d%%\n\
                    {FFFFFF}Rare Chance Bonus: {3498DB}+%d%%\n\
                    {FFFFFF}Combo Bonus: {F39C12}+%d%%\n\
                    {FFFFFF}Required Level: {FFFF00}%d",
                    FishingRods[i][rodName],
                    FishingRods[i][rodBiteSpeedBonus],
                    FishingRods[i][rodRareChanceBonus],
                    FishingRods[i][rodComboBonus],
                    FishingRods[i][rodRequiredLevel]);
                break;
            }
        }
    }
    
    // Bait details
    new baitInfo[256] = "{E74C3C}No bait equipped";
    if(PlayerFishingData[playerid][pFishingBaitID] > 0)
    {
        new baitIdx = PlayerFishingData[playerid][pFishingBaitID] - 1;
        format(baitInfo, sizeof(baitInfo),
            "{3498DB}%s {FFFFFF}(x%d)\n\
            {FFFFFF}Bite Speed Bonus: {2ECC71}+%d%%\n\
            {FFFFFF}Rare Chance Bonus: {3498DB}+%d%%",
            FishingBait[baitIdx][baitName],
            PlayerFishingData[playerid][pFishingBaitAmount],
            FishingBait[baitIdx][baitBiteSpeedBonus],
            FishingBait[baitIdx][baitRareChanceBonus]);
    }
    
    format(string, sizeof(string),
        "________________________________________\n\n\
        {2ECC71}FISHING ROD\n\
        ________________________________________\n\
        %s\n\n\
        ________________________________________\n\n\
        {3498DB}FISHING BAIT\n\
        ________________________________________\n\
        %s\n\n\
        ________________________________________\n\n\
        {FFFFFF}Use {FFFF00}/fishingshop {FFFFFF}to buy equipment!",
        rodInfo, baitInfo);
    
    ShowPlayerDialog(playerid, DIALOG_FISHING_EQUIPMENT, DIALOG_STYLE_MSGBOX,
        "{3498DB}Equipment Details", string, "Back", "Close");
}

// ============================================
// STATISTICS VIEWER
// ============================================

stock ShowFishingStatistics(playerid)
{
    new string[2048];
    
    // Calculate level progress
    new expNeeded = PlayerFishingData[playerid][pFishingLevel] * 100;
    new Float:progress = (float(PlayerFishingData[playerid][pFishingExp]) / float(expNeeded)) * 100.0;
    
    // Calculate current bonuses from level
    new baseRareChance = 10 + (PlayerFishingData[playerid][pFishingLevel] / 2);
    new levelBiteBonus = PlayerFishingData[playerid][pFishingLevel] * 2; // 2% per level
    
    // Get equipment bonuses
    new rod_bite = 0, rod_rare = 0, rod_combo = 0;
    GetRodData(PlayerFishingData[playerid][pFishingRodID], rod_bite, rod_rare, rod_combo);
    
    new bait_bite = 0, bait_rare = 0;
    GetBaitData(PlayerFishingData[playerid][pFishingBaitID], bait_bite, bait_rare);
    
    // Calculate total bonuses
    new totalBiteBonus = levelBiteBonus + rod_bite + bait_bite;
    new totalRareBonus = baseRareChance + rod_rare + bait_rare;
    
    // Get daily quest info
    new questInfo[128] = "{E74C3C}No active quest";
    if(PlayerFishingData[playerid][pDailyQuestID] > 0)
    {
        if(PlayerFishingData[playerid][pDailyQuestCompleted])
            format(questInfo, sizeof(questInfo), "{2ECC71}Completed!");
        else
        {
            new questIdx = PlayerFishingData[playerid][pDailyQuestID] - 1;
            format(questInfo, sizeof(questInfo), 
                "{FFFF00}In Progress {FFFFFF}(%d/%d)",
                PlayerFishingData[playerid][pDailyQuestProgress],
                DailyQuests[questIdx][questTargetAmount]);
        }
    }
    
    format(string, sizeof(string),
        "________________________________________\n\n\
        {2ECC71}LEVEL & EXPERIENCE\n\
        ________________________________________\n\
        {FFFFFF}Level: {2ECC71}%d\n\
        {FFFFFF}Experience: {3498DB}%d {FFFFFF}/ {FFFF00}%d {FFFFFF}(%.1f%%)\n\
        {FFFFFF}Tokens: {F39C12}%d\n\n\
        ________________________________________\n\n\
        {3498DB}CURRENT BONUSES\n\
        ________________________________________\n\
        {FFFFFF}Bite Speed Bonus: {2ECC71}+%d%%\n\
        {FFFFFF}Rare Fish Chance: {3498DB}%d%%\n\
        {FFFFFF}Combo Bonus: {F39C12}+%d%%\n\n\
        ________________________________________\n\n\
        {F39C12}FISHING STATS\n\
        ________________________________________\n\
        {FFFFFF}Total Fish Caught: {2ECC71}%d\n\
        {FFFFFF}Biggest Fish: {FFFF00}%.2f kg\n\
        {FFFFFF}Legendary Fish: {F39C12}%d\n\
        {FFFFFF}Current Combo: {E74C3C}%d\n\n\
        ________________________________________\n\n\
        {FFFF00}DAILY QUEST\n\
        ________________________________________\n\
        {FFFFFF}Status: %s",
        PlayerFishingData[playerid][pFishingLevel],
        PlayerFishingData[playerid][pFishingExp],
        expNeeded,
        progress,
        PlayerFishingData[playerid][pFishingTokens],
        totalBiteBonus,
        totalRareBonus,
        rod_combo,
        PlayerFishingData[playerid][pFishingTotalCaught],
        PlayerFishingData[playerid][pFishingBiggestWeight],
        PlayerFishingData[playerid][pFishingLegendaryCount],
        PlayerFishingData[playerid][pFishingCombo],
        questInfo);
    
    ShowPlayerDialog(playerid, DIALOG_FISHING_STATS, DIALOG_STYLE_MSGBOX,
        "{F39C12}Fishing Statistics", string, "Back", "Close");
}

// ============================================
// DIALOG RESPONSE HANDLER
// ============================================

stock OnFishingProfileDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    printf("[FISHING PROFILE DEBUG] Dialog: %d, Response: %d, Listitem: %d", dialogid, response, listitem);
    
    switch(dialogid)
    {
        case DIALOG_FISHING_PROFILE:
        {
            if(!response) return 1;
            
            printf("[FISHING PROFILE DEBUG] Main profile - listitem: %d", listitem);
            
            switch(listitem)
            {
                case 0: 
                {
                    printf("[FISHING PROFILE DEBUG] Showing Fish Inventory");
                    ShowFishInventoryDialog(playerid);
                }
                case 1: 
                {
                    printf("[FISHING PROFILE DEBUG] Showing Equipment Details");
                    ShowEquipmentDetails(playerid);
                }
                case 2: 
                {
                    printf("[FISHING PROFILE DEBUG] Showing Statistics");
                    ShowFishingStatistics(playerid);
                }
            }
            return 1;
        }
        
        case DIALOG_FISHING_INVENTORY:
        {
            if(response) ShowFishingProfile(playerid);
            return 1;
        }
        
        case DIALOG_FISHING_EQUIPMENT:
        {
            if(response) ShowFishingProfile(playerid);
            return 1;
        }
        
        case DIALOG_FISHING_STATS:
        {
            if(response) ShowFishingProfile(playerid);
            return 1;
        }
    }
    return 0;
}
