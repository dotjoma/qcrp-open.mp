/*
    FISHING RPG SYSTEM - DATA STRUCTURES
    All enums, arrays, and constants for the fishing system
*/

#if defined _fishing_data_included
    #endinput
#endif
#define _fishing_data_included

// ============================================
// FISHING CONSTANTS
// ============================================

#define MAX_FISHING_RODS        10
#define MAX_FISHING_BAIT        10
#define MAX_FISHING_ZONES       20
#define MAX_FISH_SPECIES        50
#define MAX_DAILY_QUESTS        10

// Rarity multipliers
#define RARITY_COMMON           0
#define RARITY_UNCOMMON         1
#define RARITY_RARE             2
#define RARITY_LEGENDARY        3

// Time of day
#define TIME_MORNING            6
#define TIME_AFTERNOON          12
#define TIME_EVENING            18
#define TIME_NIGHT              0

// Combo thresholds
#define COMBO_TIER1             3
#define COMBO_TIER2             5
#define COMBO_TIER3             10

// Fishing mechanics
#define MAX_FISHING_MISSES      3

// Inventory
#define MAX_FISH_INVENTORY      50  // Maximum fish a player can hold

// Tournament types
#define TOURNAMENT_BIGGEST      0
#define TOURNAMENT_MOST         1
#define TOURNAMENT_RAREST       2

// ============================================
// PLAYER FISHING DATA
// ============================================

enum E_FISHING_PLAYER_DATA
{
    // Database ID (from players table)
    pFishingDBID,
    
    // Core stats
    pFishingLevel,
    pFishingExp,
    pFishingTokens,
    
    // Equipment
    pFishingRodID,
    pFishingBaitID,
    pFishingBaitAmount,
    
    // Session data
    pFishingCombo,
    bool:pIsFishing,
    pFishingZoneID,
    pFishingMissCount,  // Track misses during fishing attempt
    
    // Statistics
    pFishingTotalCaught,
    Float:pFishingBiggestWeight,
    pFishingLegendaryCount,
    
    // Daily quest
    pDailyQuestID,
    pDailyQuestProgress,
    bool:pDailyQuestCompleted,
    
    // Tournament
    Float:pTournamentScore,
    pTournamentCaught,
    
    // Wait state tracking
    pFishingWaitState,
    
    // Boat checkpoint tracking
    bool:pBoatCheckpointActive,
    pBoatCheckpointZoneID
}
new PlayerFishingData[MAX_PLAYERS][E_FISHING_PLAYER_DATA];

// ============================================
// FISHING ROD DATA
// ============================================

enum E_FISHING_ROD
{
    rodID,
    rodName[64],
    rodBiteSpeedBonus,      // Percentage (0-100)
    rodRareChanceBonus,     // Percentage (0-100)
    rodComboBonus,          // Percentage (0-100)
    rodTokenPrice,
    rodRequiredLevel
}
new FishingRods[MAX_FISHING_RODS][E_FISHING_ROD];
new TotalFishingRods = 0;


// ============================================
// FISHING BAIT DATA
// ============================================

enum E_FISHING_BAIT
{
    baitID,
    baitName[64],
    baitBiteSpeedBonus,     // Percentage (0-100)
    baitRareChanceBonus,    // Percentage (0-100)
    baitTokenPrice
}
new FishingBait[MAX_FISHING_BAIT][E_FISHING_BAIT];
new TotalFishingBait = 0;

// ============================================
// FISHING ZONE DATA (REMOVED - Using database zones only)
// ============================================
// Static zones removed - all zones now managed via database
// See fishing_zones_manager.inc for zone management

// ============================================
// FISH SPECIES DATA
// ============================================

enum E_FISH_SPECIES
{
    fishID,
    fishName[64],
    fishRarity,             // 0=common, 1=uncommon, 2=rare, 3=legendary
    Float:fishMinWeight,
    Float:fishMaxWeight,
    fishBaseValue,          // Base selling price
    fishExpReward,
    fishZoneID,             // Which zone this fish appears in
    fishTimeRestriction[32] // "morning", "night", "any"
}
new FishSpecies[MAX_FISH_SPECIES][E_FISH_SPECIES];
new TotalFishSpecies = 0;

// ============================================
// DAILY QUEST DATA
// ============================================

enum E_DAILY_QUEST
{
    questID,
    questType,              // 0=catch amount, 1=catch rarity, 2=catch weight
    questTargetAmount,
    questTargetRarity,      // For rarity quests
    Float:questTargetWeight,// For weight quests
    questTokenReward,
    questDescription[128]
}
new DailyQuests[MAX_DAILY_QUESTS][E_DAILY_QUEST];
new TotalDailyQuests = 0;

// ============================================
// TOURNAMENT DATA
// ============================================

enum E_TOURNAMENT_DATA
{
    bool:tournamentActive,
    tournamentType,         // 0=biggest, 1=most, 2=rarest
    tournamentStartTime,
    tournamentEndTime,
    tournamentWinnerID,
    tournamentWinnerName[24],
    Float:tournamentWinnerScore
}
new TournamentData[E_TOURNAMENT_DATA];

// Tournament participant data
new Float:TournamentPlayerScore[MAX_PLAYERS];
new TournamentPlayerCaught[MAX_PLAYERS];

// ============================================
// CAUGHT FISH DATA (temporary)
// ============================================

enum E_CAUGHT_FISH
{
    caughtFishID,
    caughtFishName[64],
    caughtFishRarity,
    Float:caughtFishWeight,
    caughtFishValue,
    caughtFishExp
}
new CaughtFish[MAX_PLAYERS][E_CAUGHT_FISH];

// ============================================
// HELPER FUNCTIONS
// ============================================

stock GetRarityName(rarity)
{
    new rarityName[32];
    switch(rarity)
    {
        case RARITY_COMMON: rarityName = "Common";
        case RARITY_UNCOMMON: rarityName = "Uncommon";
        case RARITY_RARE: rarityName = "Rare";
        case RARITY_LEGENDARY: rarityName = "Legendary";
        default: rarityName = "Unknown";
    }
    return rarityName;
}

stock GetRarityColor(rarity)
{
    new color[16];
    switch(rarity)
    {
        case RARITY_COMMON: color = "{FFFFFF}";
        case RARITY_UNCOMMON: color = "{2ECC71}";
        case RARITY_RARE: color = "{3498DB}";
        case RARITY_LEGENDARY: color = "{F39C12}";
        default: color = "{FFFFFF}";
    }
    return color;
}

stock GetTimeOfDay()
{
    new hour = gettime() / 3600 % 24;
    
    if(hour >= 6 && hour < 12) return TIME_MORNING;
    if(hour >= 12 && hour < 18) return TIME_AFTERNOON;
    if(hour >= 18 && hour < 24) return TIME_EVENING;
    return TIME_NIGHT;
}

stock GetTimeOfDayName()
{
    new timeName[32];
    new timeOfDay = GetTimeOfDay();
    
    switch(timeOfDay)
    {
        case TIME_MORNING: timeName = "Morning";
        case TIME_AFTERNOON: timeName = "Afternoon";
        case TIME_EVENING: timeName = "Evening";
        case TIME_NIGHT: timeName = "Night";
        default: timeName = "Unknown";
    }
    return timeName;
}
