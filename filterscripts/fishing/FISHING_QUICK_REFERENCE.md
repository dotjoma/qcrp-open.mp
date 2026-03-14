# 🎣 Fishing RPG System - Quick Reference Card

## 📦 Files Created

```
filterscripts/
├── fishing_rpg_master.pwn          # Main file (include this)
├── fishing_data_structures.inc     # All data structures
├── fishing_core.inc                # Core system & leveling
├── fishing_equipment.inc           # Rods & bait
├── fishing_catch.inc               # Fish generation & rarity
├── fishing_zones.inc               # Zones & turf integration
├── fishing_quests.inc              # Daily quest system
├── fishing_tournament.inc          # Tournament events
├── fishing_leaderboard.inc         # Rankings & stats
├── FISHING_RPG_SYSTEM_DESIGN.md    # Complete design doc
├── FISHING_RPG_IMPLEMENTATION.md   # Implementation guide
└── FISHING_QUICK_REFERENCE.md      # This file
```

---

## 🚀 Quick Setup (5 Minutes)

### 1. Database Setup
```sql
-- Run this SQL query
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

CREATE TABLE `fishing_leaderboard` (
  `player_id` INT(10) PRIMARY KEY,
  `player_name` VARCHAR(24) NOT NULL,
  `total_caught` INT(10) DEFAULT 0,
  `biggest_weight` FLOAT DEFAULT 0.0,
  `legendary_count` INT(10) DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2. Add to Gamemode
```pawn
#include "fishing_rpg_master.pwn"

public OnPlayerLogin(playerid)
{
    LoadPlayerFishingData(playerid);
}
```

### 3. Test In-Game
```
/fishinfo          - View system info
/fishstats         - View your stats
/fishzones         - See fishing locations
/fish              - Start fishing!
```

---

## 📊 System Stats

| Feature | Count |
|---------|-------|
| Fishing Rods | 6 |
| Bait Types | 5 |
| Fishing Zones | 4 |
| Fish Species | 30+ |
| Rarity Tiers | 4 |
| Max Level | 100 |
| Daily Quests | 8 |
| Tournament Types | 3 |

---

## 🎮 Player Commands

```
/fish                    - Start fishing
/fishstats [playerid]    - View fishing statistics
/fishquest               - View daily quest
/fishzone                - Current zone info
/fishzones               - List all zones
/fishingshop             - Equipment shop
/fishtop [type]          - Leaderboards
/tournamentstatus        - Tournament info
/tournamentleaders       - Tournament rankings
/fishhelp                - Command list
/fishinfo                - System information
```

---

## 🛠️ Admin Commands

```
/starttournament [type] [minutes]  - Start tournament
  Types: 0=Biggest, 1=Most, 2=Rarest
  
/setfishlevel [playerid] [level]   - Set fishing level
```

---

## 🎣 Equipment Tiers

### Rods
```
Basic      (Lv1)  - Free         - No bonuses
Amateur    (Lv5)  - 50 tokens    - +10% bite, +5% rare
Pro        (Lv15) - 150 tokens   - +20% bite, +10% rare
Expert     (Lv30) - 300 tokens   - +30% bite, +15% rare
Master     (Lv50) - 500 tokens   - +40% bite, +25% rare
Legendary  (Lv75) - 1000 tokens  - +50% bite, +35% rare
```

### Bait
```
Worm            - Free        - No bonuses
Shrimp          - 20 tokens   - +15% bite, +5% rare
Minnow          - 50 tokens   - +20% bite, +10% rare
Golden          - 100 tokens  - +30% bite, +20% rare
Legendary Lure  - 200 tokens  - +40% bite, +30% rare
```

---

## 🐟 Fish Rarity

```
Common      - 70% chance  - Low value
Uncommon    - 20% chance  - Medium value
Rare        - 8% chance   - High value
Legendary   - 2% chance   - Extreme value
```

---

## 🗺️ Fishing Zones

```
1. Santa Maria Beach  - Coastal fish
2. Flint River        - Freshwater fish
3. Fisher's Lagoon    - Lake fish
4. Deep Sea           - Ocean giants
```

---

## ⏰ Time Bonuses

```
Morning   (6-12)  - +15% bite speed
Afternoon (12-18) - Normal
Evening   (18-24) - +15% bite speed
Night     (0-6)   - +20% bite speed, +10% rare chance
```

---

## 🔥 Combo System

```
x3  Combo - +5% bite speed, +5% rare chance
x5  Combo - +10% bite speed, +10% rare chance
x10 Combo - +20% bite speed, +15% rare chance
```

---

## 🎯 Daily Quests

```
Catch 5 fish           - 10 tokens
Catch 10 fish          - 25 tokens
Catch 1 Uncommon       - 15 tokens
Catch 1 Rare           - 30 tokens
Catch 1 Legendary      - 100 tokens
Catch 10kg total       - 20 tokens
Catch 25kg total       - 40 tokens
Catch 3 Uncommon       - 35 tokens
```

---

## 🏆 Tournaments

### Types
```
Biggest Fish  - Heaviest single catch wins
Most Fish     - Total catches wins
Rarest Fish   - Rarity points win
```

### Rewards
```
$50,000
200 Fishing Tokens
50 Special Bait
```

---

## 💰 Token Economy

### Earning
```
Level Up      - 5 tokens per level
Daily Quests  - 10-100 tokens
Tournaments   - 200 tokens
```

### Spending
```
Fishing Rods  - 50-1000 tokens
Bait (x10)    - 20-200 tokens
```

---

## 📈 Leveling

```
Level 1→2:   100 EXP
Level 2→3:   250 EXP
Level 3→4:   450 EXP
...
Formula: 50 + (level² × 10)
```

---

## 🔧 Integration Points

### Required Functions
```pawn
LoadPlayerFishingData(playerid)      - On login
SavePlayerFishingData(playerid)      - On disconnect
OnPlayerCatchFish(playerid)          - On successful catch
OnPlayerFailCatch(playerid)          - On failed catch
GenerateFish(playerid, zoneID)       - Generate fish
IsPlayerInFishingZone(playerid)      - Check location
```

### Optional (Turf Integration)
```pawn
GetZoneTurfOwner(zoneID)
GetTurfBiteSpeedBonus(zoneID, playerid)
GiveTurfOwnerCut(zoneID, fishValue)
```

---

## 🐛 Troubleshooting

### Fish not generating
```
✓ Check player is in valid zone
✓ Verify fish species loaded
✓ Check zone ID matches
```

### Bonuses not working
```
✓ Verify equipment IDs
✓ Check calculation order
✓ Ensure data loads
```

### Database errors
```
✓ Check MySQL connection
✓ Verify table structure
✓ Check column names
```

---

## 📞 Support Files

- `FISHING_RPG_SYSTEM_DESIGN.md` - Complete system design
- `FISHING_RPG_IMPLEMENTATION.md` - Step-by-step guide
- `FISHING_QUICK_REFERENCE.md` - This file

---

## ✅ Testing Checklist

```
[ ] Database tables created
[ ] System initializes
[ ] Player data loads
[ ] Equipment bonuses work
[ ] Fish generation works
[ ] Weight system works
[ ] Rarity system works
[ ] Combo system works
[ ] Daily quests work
[ ] Tournaments work
[ ] Leaderboards work
[ ] All commands work
[ ] Data saves properly
```

---

## 🎉 Quick Start Example

```pawn
// 1. Player logs in
LoadPlayerFishingData(playerid);

// 2. Player goes to beach
// Use /fishzone to check

// 3. Player types /fish
if(IsPlayerInFishingZone(playerid))
{
    GenerateFish(playerid, zoneID);
    StartFishingWait(playerid);
}

// 4. Fish bites (after wait)
// Player plays minigame

// 5. Success!
OnPlayerCatchFish(playerid);
// Shows catch info, gives rewards, updates stats

// 6. Failure
OnPlayerFailCatch(playerid);
// Resets combo, shows message
```

---

**System Version:** 1.0.0  
**Compatibility:** SA-MP 0.3.7+  
**Dependencies:** a_mysql (R41+), sscanf2, zcmd

**Ready to fish!** 🎣
