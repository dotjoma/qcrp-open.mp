# Fishing Wait-State System Documentation

## Overview
This system implements a probability-based fishing wait mechanic where players must wait for a fish to bite before the minigame starts. The wait time is dynamically calculated based on the player's fishing skill level.

## How It Works

### 1. Starting to Fish
- Player uses `/fish` command
- Fishing rod is attached to player
- Baseball bat idle animation plays briefly
- After 1 second, `sword_idle` animation starts
- Wait state timer begins

### 2. Wait State Mechanics

#### Fishing Level Impact
The system uses the `fishingskill` field from the database to determine wait times:

| Fishing Level | Wait Time Range |
|--------------|-----------------|
| Level 1      | 10-15 seconds   |
| Level 5      | 6-9 seconds     |
| Level 10     | 3-5 seconds     |

**Formula:**
```pawn
waitTime = MAX_WAIT_TIME - ((fishingLevel - 1) * reductionPerLevel)
// With ±20% random variance
```

#### Configuration Constants
```pawn
#define MIN_WAIT_TIME       3000    // 3 seconds minimum
#define MAX_WAIT_TIME       15000   // 15 seconds maximum
#define WAIT_CHECK_INTERVAL 500     // Check every 500ms
```

### 3. Bite Detection
- System checks every 500ms if it's time for fish to bite
- When bite time is reached:
  - Success message displayed
  - Sound effect plays (ID: 1057)
  - Fishing minigame UI appears
  - Player can now catch the fish

### 4. Visual Feedback
- GameText shows countdown every 3 seconds
- Format: "Waiting... Xs"
- Helps player know system is working

## Commands

### `/fish`
Starts the fishing process with wait state.

**Requirements:**
- Player must not already be fishing
- Should have fishing rod (implement check in gamemode)

### `/setfishlevel [1-10]`
**Testing command** - Sets player's fishing level without database.

**Usage:**
```
/setfishlevel 1  // Longest wait time
/setfishlevel 10 // Shortest wait time
```

## Integration with Main Gamemode

### Loading Fishing Level on Player Login
Add this to your `OnPlayerLogin` or data loading function:

```pawn
// In your gamemode
#include <a_mysql>

public OnPlayerLogin(playerid)
{
    new query[128];
    mysql_format(MySQL, query, sizeof(query), 
        "SELECT fishingskill FROM players WHERE id = %d", 
        PlayerData[playerid][pSQLID]);
    mysql_tquery(MySQL, query, "OnLoadPlayerFishingData", "i", playerid);
}

forward OnLoadPlayerFishingData(playerid);
public OnLoadPlayerFishingData(playerid)
{
    new rows;
    cache_get_row_count(rows);
    
    if(rows)
    {
        new fishingLevel;
        cache_get_value_name_int(0, "fishingskill", fishingLevel);
        
        // Call filterscript function to set level
        CallRemoteFunction("SetPlayerFishingLevel", "ii", playerid, fishingLevel);
    }
}
```

### Updating Fishing Level
When player gains fishing experience:

```pawn
// In your gamemode
stock GiveFishingExperience(playerid, amount)
{
    PlayerData[playerid][pFishingExp] += amount;
    
    // Check for level up
    if(PlayerData[playerid][pFishingExp] >= GetRequiredExp(PlayerData[playerid][pFishingLevel]))
    {
        PlayerData[playerid][pFishingLevel]++;
        
        // Update in filterscript
        CallRemoteFunction("SetPlayerFishingLevel", "ii", playerid, PlayerData[playerid][pFishingLevel]);
        
        // Update database
        new query[128];
        mysql_format(MySQL, query, sizeof(query),
            "UPDATE players SET fishingskill = %d WHERE id = %d",
            PlayerData[playerid][pFishingLevel], PlayerData[playerid][pSQLID]);
        mysql_tquery(MySQL, query);
    }
}
```

## Functions Reference

### `StartFishingWait(playerid)`
**Called:** After initial animation (1 second delay)
**Purpose:** Initializes wait state and calculates bite time

### `CheckFishingBite(playerid)`
**Called:** Every 500ms while waiting
**Purpose:** Checks if fish should bite, shows countdown

### `OnFishBite(playerid)`
**Called:** When fish bites
**Purpose:** Triggers minigame start

### `CancelFishing(playerid)`
**Purpose:** Stops fishing process (for movement, damage, etc.)

**Usage:**
```pawn
// In your gamemode
public OnPlayerMove(playerid)
{
    CallRemoteFunction("CancelFishing", "i", playerid);
}
```

## Variables

### Per-Player Variables
```pawn
new bool:FishingWaitState[MAX_PLAYERS];      // Is player in wait state?
new FishingWaitTimer[MAX_PLAYERS];           // Timer ID for checking
new FishingWaitStartTime[MAX_PLAYERS];       // When waiting started
new FishingBiteTime[MAX_PLAYERS];            // When fish will bite
new PlayerFishingLevel[MAX_PLAYERS];         // Current fishing level
```

## Probability System Explained

The system uses **deterministic probability** rather than random checks:

1. **Calculate wait time** based on fishing level
2. **Add random variance** (±20%) for unpredictability
3. **Set exact bite time** = start_time + wait_time
4. **Check periodically** if current_time >= bite_time

This ensures:
- Consistent behavior
- No "unlucky" infinite waits
- Smooth progression with level increases
- Predictable testing

## Testing Guide

1. **Test Level 1 (Beginner):**
   ```
   /setfishlevel 1
   /fish
   // Should wait 10-15 seconds
   ```

2. **Test Level 5 (Intermediate):**
   ```
   /setfishlevel 5
   /fish
   // Should wait 6-9 seconds
   ```

3. **Test Level 10 (Expert):**
   ```
   /setfishlevel 10
   /fish
   // Should wait 3-5 seconds
   ```

## Future Enhancements

### Suggested Features:
1. **Bait Quality System** - Different baits affect wait time
2. **Location Bonuses** - Certain fishing spots have better bite rates
3. **Time of Day** - Fish bite faster at dawn/dusk
4. **Weather Effects** - Rain increases bite chance
5. **Combo System** - Consecutive catches reduce wait time temporarily
6. **Rare Fish** - Longer waits but better rewards

### Implementation Example (Bait Quality):
```pawn
// In StartFishingWait function
new baitQuality = GetPlayerBaitQuality(playerid); // 1-3
waitTime = waitTime - (baitQuality * 1000); // -1s per quality level
```

## Troubleshooting

### Fish never bites
- Check if `FishingWaitTimer` is being killed elsewhere
- Verify `GetTickCount()` is working
- Add debug messages in `CheckFishingBite`

### Wait time too long/short
- Adjust `MIN_WAIT_TIME` and `MAX_WAIT_TIME` constants
- Modify variance calculation (currently ±20%)

### Animation issues
- Ensure player is not in vehicle
- Check if other animations are interfering
- Verify attached object is created properly

## Credits
- Fishing minigame UI: Original fishing_txd.pwn
- Wait state system: Custom implementation
- Database integration: Uses existing `fishingskill` field
