# 🎣 RPG Fishing System - Implementation Guide

## Quick Start

### Step 1: Database Setup

Run these SQL queries on your database:

```sql
-- Add columns to players table
ALTER TABLE `players` ADD COLUMN `fishing_level` INT(10) DEFAULT 1;
ALTER TABLE `players` ADD COLUMN `fishing_exp` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_tokens` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_rod_id` INT(10) DEFAULT 1;
ALTER TABLE `players` ADD COLUMN `fishing_bait_id` INT(10) DEFAULT 1;
ALTER TABLE `players` ADD COLUMN `fishing_bait_amount` INT(10) DEFAULT 10;
ALTER TABLE `players` ADD COLUMN `fishing_combo` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_total_caught` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_biggest_weight` FLOAT DEFAULT 0.0;
ALTER TABLE `players` ADD COLUMN `fishing_legendary_count` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_daily_quest_id` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_daily_progress` INT(10) DEFAULT 0;
ALTER TABLE `players` ADD COLUMN `fishing_daily_completed` INT(10) DEFAULT 0;

-- Create leaderboard table
CREATE TABLE `fishing_leaderboard` (
  `player_id` INT(10) PRIMARY KEY,
  `player_name` VARCHAR(24) NOT NULL,
  `total_caught` INT(10) DEFAULT 0,
  `biggest_weight` FLOAT DEFAULT 0.0,
  `legendary_count` INT(10) DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Step 2: Include Files

Add to your filterscript or gamemode:

```pawn
#include <a_mysql>
#include "fishing_data_structures.inc"
#include "fishing_core.inc"
#include "fishing_equipment.inc"
#include "fishing_catch.inc"
#include "fishing_zones.inc"
```

### Step 3: Initialize System

```pawn
public OnFilterScriptInit()
{
    InitializeFishingSystem();
    return 1;
}

public OnPlayerConnect(playerid)
{
    ResetPlayerFishingData(playerid);
    return 1;
}
```

---

## System Features Overview

### ✅ Implemented Features

1. **Equipment System**
   - 6 fishing rods with progressive bonuses
   - 5 bait types with different effects
   - Token-based economy

2. **Fish Rarity System**
   - 4 rarity tiers (Common, Uncommon, Rare, Legendary)
   - 30+ fish species
   - Dynamic probability calculation

3. **Fishing Zones**
   - 4 unique zones (Beach, River, Lake, Deep Sea)
   - Zone-specific fish
   - Turf integration support

4. **Weight System**
   - Random weight generation per fish
   - Weight affects selling price
   - Leaderboard tracking

5. **Time of Day Bonuses**
   - Morning: Faster bites
   - Night: Rare fish chance
   - Zone-specific bonuses

6. **Combo System**
   - 3 combo tiers (x3, x5, x10)
   - Progressive bonuses
   - Resets on failure

7. **Experience & Leveling**
   - 100 levels
   - Progressive EXP curve
   - Token rewards on level up

---

## Core Mechanics

### Bite Time Calculation

```pawn
// Base wait time from existing system
baseWaitTime = MAX_WAIT_TIME - ((fishingLevel - 1) * reductionPerLevel);

// Apply equipment bonuses
rodBonus = FishingRods[rodID][rodBiteSpeedBonus]; // 0-50%
baitBonus = FishingBait[baitID][baitBiteSpeedBonus]; // 0-40%

// Apply zone bonuses
timeBonus = GetTimeOfDayBiteBonus(zoneID); // 0-20%
turfBonus = GetTurfBiteSpeedBonus(zoneID, playerid); // 0-10%

// Apply combo bonus
if(combo >= 10) comboBonus = 20;
else if(combo >= 5) comboBonus = 10;
else if(combo >= 3) comboBonus = 5;

// Calculate final wait time
totalBonus = rodBonus + baitBonus + timeBonus + turfBonus + comboBonus;
finalWaitTime = baseWaitTime * (100 - totalBonus) / 100;
```

### Rarity Calculation

```pawn
// Base rare chance
baseRareChance = 10 + (fishingLevel / 2); // 10-60%

// Equipment bonuses
rodRareBonus = FishingRods[rodID][rodRareChanceBonus]; // 0-35%
baitRareBonus = FishingBait[baitID][baitRareChanceBonus]; // 0-30%

// Time bonus
if(timeOfDay == NIGHT) timeRareBonus = 10;

// Combo bonus
if(combo >= 10) comboRareBonus = 15;
else if(combo >= 5) comboRareBonus = 10;
else if(combo >= 3) comboRareBonus = 5;

// Final calculation
finalRareChance = baseRareChance + rodRareBonus + baitRareBonus + 
                  timeRareBonus + comboRareBonus;

// Cap at 80%
if(finalRareChance > 80) finalRareChance = 80;

// Determine rarity
roll = random(100);
if(roll < finalRareChance / 20) return LEGENDARY; // 5% of rare chance
if(roll < finalRareChance / 6) return RARE; // 15% of rare chance
if(roll < finalRareChance / 3) return UNCOMMON; // 30% of rare chance
return COMMON;
```


### Weight Calculation

```pawn
// Generate random weight within species range
weight = minWeight + (random(1000) / 1000.0) * (maxWeight - minWeight);

// Calculate value based on weight
weightRatio = (weight - minWeight) / (maxWeight - minWeight);
finalValue = baseValue + (baseValue * weightRatio * 0.5);
```

---

## Complete Command List

### Player Commands

| Command | Description |
|---------|-------------|
| `/fish` | Start fishing with wait state |
| `/fishstats [playerid]` | View fishing statistics |
| `/fishquest` | View current daily quest |
| `/fishzone` | View current zone information |
| `/fishzones` | List all fishing zones |
| `/fishingshop` | Open fishing equipment shop |
| `/fishtop [type]` | View leaderboards (total/weight/legendary) |
| `/tournamentstatus` | View active tournament status |
| `/tournamentleaders` | View tournament leaderboard |

### Admin Commands

| Command | Description |
| `/starttournament [type] [duration]` | Start fishing tournament |
| `/setfishlevel [playerid] [level]` | Set player fishing level |

---

## Integration Steps

### 1. Add Include Files

In your main gamemode or filterscript:

```pawn
#include <a_mysql>
#include "fishing_data_structures.inc"
#include "fishing_core.inc"
#include "fishing_equipment.inc"
#include "fishing_catch.inc"
#include "fishing_zones.inc"
#include "fishing_quests.inc"
#include "fishing_tournament.inc"
#include "fishing_leaderboard.inc"
```

### 2. Initialize System

```pawn
public OnGameModeInit()
{
    InitializeFishingSystem();
    return 1;
}
```

### 3. Player Connection

```pawn
public OnPlayerConnect(playerid)
{
    ResetPlayerFishingData(playerid);
    return 1;
}

public OnPlayerLogin(playerid)
{
    LoadPlayerFishingData(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerFishingData(playerid);
    return 1;
}
```

### 4. Integrate with Existing Fishing System

Modify your existing `/fish` command:

```pawn
CMD:fish(playerid, params[])
{
    // Check if player has fishing rod
    if(PlayerFishingData[playerid][pFishingRodID] == 0)
    {
        SendClientMessage(playerid, COLOR_RED, "You don't have a fishing rod!");
        return 1;
    }
    
    // Check if player has bait
    if(PlayerFishingData[playerid][pFishingBaitAmount] < 1)
    {
        SendClientMessage(playerid, COLOR_RED, "You don't have any bait!");
        return 1;
    }
    
    // Check if in fishing zone
    if(!IsPlayerInFishingZone(playerid))
    {
        SendClientMessage(playerid, COLOR_RED, "You need to be in a fishing zone!");
        SendClientMessage(playerid, -1, "Use /fishzones to see available zones");
        return 1;
    }
    
    // Check if already fishing
    if(PlayerFishingData[playerid][pIsFishing])
    {
        SendClientMessage(playerid, COLOR_RED, "You are already fishing!");
        return 1;
    }
    
    // Use one bait
    PlayerFishingData[playerid][pFishingBaitAmount]--;
    
    // Get zone
    new zoneIdx = GetPlayerFishingZone(playerid);
    PlayerFishingData[playerid][pFishingZoneID] = zoneIdx;
    
    // Generate fish for this zone
    GenerateFish(playerid, FishingZones[zoneIdx][zoneID]);
    
    // Start fishing wait state (your existing system)
    // The wait time will be modified by equipment bonuses
    StartFishingWithBonuses(playerid);
    
    return 1;
}
```

### 5. Modify Wait Time Calculation

In your `StartFishingWait` function:

```pawn
forward StartFishingWait(playerid);
public StartFishingWait(playerid)
{
    // ... existing code ...
    
    // Calculate base wait time
    new waitTime = MAX_WAIT_TIME - ((fishingLevel - 1) * reductionPerLevel);
    
    // Apply equipment bonuses
    new rodBiteBonus, rodRareBonus, rodComboBonus;
    GetRodData(PlayerFishingData[playerid][pFishingRodID], rodBiteBonus, rodRareBonus, rodComboBonus);
    
    new baitBiteBonus, baitRareBonus;
    GetBaitData(PlayerFishingData[playerid][pFishingBaitID], baitBiteBonus, baitRareBonus);
    
    // Apply zone bonuses
    new timeBonus = GetTimeOfDayBiteBonus(PlayerFishingData[playerid][pFishingZoneID]);
    new turfBonus = GetTurfBiteSpeedBonus(PlayerFishingData[playerid][pFishingZoneID], playerid);
    
    // Apply combo bonus
    new comboBonus = 0;
    if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER3)
        comboBonus = 20;
    else if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER2)
        comboBonus = 10;
    else if(PlayerFishingData[playerid][pFishingCombo] >= COMBO_TIER1)
        comboBonus = 5;
    
    // Calculate total bonus
    new totalBonus = rodBiteBonus + baitBiteBonus + timeBonus + turfBonus + comboBonus;
    
    // Apply bonus to wait time
    waitTime = waitTime * (100 - totalBonus) / 100;
    
    // Add variance
    new variance = waitTime / 5;
    waitTime = waitTime - variance + random(variance * 2);
    
    // Store bite time
    FishingBiteTime[playerid] = FishingWaitStartTime[playerid] + waitTime;
    
    // ... rest of existing code ...
}
```

### 6. Handle Catch Success/Failure

When player successfully catches fish (in your minigame):

```pawn
// On successful catch
OnPlayerCatchFish(playerid);

// On failed catch
OnPlayerFailCatch(playerid);
```

---

## Equipment Progression

### Fishing Rods

| Rod | Level | Bite Speed | Rare Chance | Combo | Price |
|-----|-------|------------|-------------|-------|-------|
| Basic | 1 | +0% | +0% | +0% | Free |
| Amateur | 5 | +10% | +5% | +5% | 50 tokens |
| Pro | 15 | +20% | +10% | +10% | 150 tokens |
| Expert | 30 | +30% | +15% | +15% | 300 tokens |
| Master | 50 | +40% | +25% | +20% | 500 tokens |
| Legendary | 75 | +50% | +35% | +30% | 1000 tokens |

### Fishing Bait

| Bait | Bite Speed | Rare Chance | Price (per 10) |
|------|------------|-------------|----------------|
| Worm | +0% | +0% | Free |
| Shrimp | +15% | +5% | 20 tokens |
| Minnow | +20% | +10% | 50 tokens |
| Golden | +30% | +20% | 100 tokens |
| Legendary Lure | +40% | +30% | 200 tokens |

---

## Fish Species by Zone

### Beach Zone
- Common: Sardine, Mackerel
- Uncommon: Sea Bass, Snapper
- Rare: Grouper, Barracuda
- Legendary: Golden Marlin

### River Zone
- Common: Catfish, Carp
- Uncommon: Pike, Trout
- Rare: Salmon, Sturgeon
- Legendary: Ancient Catfish

### Lake Zone
- Common: Bluegill, Perch
- Uncommon: Walleye, Crappie
- Rare: Muskie, Lake Trout
- Legendary: Crystal Bass

### Deep Sea Zone
- Common: Tuna, Bonito
- Uncommon: Mahi-Mahi, Wahoo
- Rare: Swordfish, Sailfish
- Legendary: Leviathan

---

## Daily Quest Types

### Catch Amount Quests
- Catch 5 fish (10 tokens)
- Catch 10 fish (25 tokens)

### Catch Rarity Quests
- Catch 1 Uncommon (15 tokens)
- Catch 1 Rare (30 tokens)
- Catch 1 Legendary (100 tokens)
- Catch 3 Uncommon (35 tokens)

### Catch Weight Quests
- Catch 10kg total (20 tokens)
- Catch 25kg total (40 tokens)

---

## Tournament Types

### Biggest Fish Tournament
- Winner: Player with heaviest single fish
- Duration: 10-30 minutes
- Rewards: $50,000 + 200 tokens + 50 bait

### Most Fish Tournament
- Winner: Player with most fish caught
- Duration: 10-30 minutes
- Rewards: $50,000 + 200 tokens + 50 bait

### Rarest Fish Tournament
- Winner: Player with highest rarity score
- Scoring: Common=1, Uncommon=5, Rare=15, Legendary=50
- Duration: 10-30 minutes
- Rewards: $50,000 + 200 tokens + 50 bait

---

## Token Economy

### Earning Tokens
- Level up: 5 tokens per level
- Daily quests: 10-100 tokens
- Tournament win: 200 tokens

### Spending Tokens
- Fishing rods: 50-1000 tokens
- Bait (per 10): 20-200 tokens

---

## Testing Checklist

- [ ] Database tables created
- [ ] All include files added
- [ ] System initializes without errors
- [ ] Player data loads on login
- [ ] Equipment bonuses apply correctly
- [ ] Fish generation works in all zones
- [ ] Weight system calculates properly
- [ ] Rarity system works as expected
- [ ] Combo system tracks correctly
- [ ] Daily quests assign and complete
- [ ] Tournaments start and end properly
- [ ] Leaderboards update correctly
- [ ] All commands work
- [ ] Data saves on disconnect

---

## Performance Optimization

### Database Queries
- Use prepared statements
- Batch updates when possible
- Index leaderboard columns

### Memory Management
- Clear unused fish data
- Reset tournament data after events
- Periodic leaderboard cleanup

### Timer Optimization
- Use single timer for multiple checks
- Avoid creating timers per player
- Kill timers on disconnect

---

## Future Enhancements

1. **Fishing Achievements**
   - Catch 100 fish
   - Catch all legendary fish
   - Reach level 100

2. **Seasonal Events**
   - Summer fishing festival
   - Winter ice fishing
   - Special holiday fish

3. **Fishing Crews**
   - Team-based tournaments
   - Shared bonuses
   - Crew leaderboards

4. **Advanced Equipment**
   - Fishing boats
   - Sonar devices
   - Tackle boxes

5. **Fish Market**
   - Player-to-player trading
   - Dynamic fish prices
   - Bulk selling bonuses

---

## Support & Troubleshooting

### Common Issues

**Fish not generating:**
- Check if player is in valid zone
- Verify fish species loaded
- Check zone ID matches species

**Bonuses not applying:**
- Verify equipment IDs are correct
- Check bonus calculation order
- Ensure data loads properly

**Leaderboard not updating:**
- Check MySQL connection
- Verify table structure
- Check player database ID

**Tournament not ending:**
- Verify timer is set
- Check tournament active flag
- Ensure callback is public

---

## Credits

- System Design: RPG Fishing Framework
- Database Schema: MySQL 5.7+
- Compatibility: SA-MP 0.3.7+
- Dependencies: a_mysql (R41+)

---

**System Version:** 1.0.0  
**Last Updated:** 2024  
**License:** Custom Implementation
