# 🎣 Fishing System - Phase 2 Roadmap

## Gabay para sa Future Development

Itong document ay naglalaman ng lahat ng features na pwede pang i-implement pagkatapos ng core fishing system. Organized by priority at difficulty level.

---

## 📊 Current Status

### ✅ Phase 1 - Core System (COMPLETED)
- Basic fishing mechanics
- Equipment system (rods & bait)
- Fish rarity & weight system
- Fishing zones
- Experience & leveling
- Daily quests
- Tournaments
- Leaderboards

### 🔄 Phase 1.5 - Integration (IN PROGRESS)
- Equipment shop dialogs
- Database integration
- Bonus calculations
- Minigame integration

---

## 🚀 Phase 2 - Enhanced Features

### Priority: HIGH ⭐⭐⭐

#### 1. Equipment Shop Dialog System
**Difficulty:** Easy  
**Time Estimate:** 2-3 hours  
**Dependencies:** None

**Description:**
Complete dialog system para sa pagbili ng rods at bait.

**Implementation:**
```pawn
// Dialog IDs
#define DIALOG_FISHING_SHOP_MAIN    9000
#define DIALOG_FISHING_SHOP_RODS    9001
#define DIALOG_FISHING_SHOP_BAIT    9002
#define DIALOG_CONFIRM_PURCHASE     9003

// Main shop menu
ShowPlayerDialog(playerid, DIALOG_FISHING_SHOP_MAIN, DIALOG_STYLE_LIST,
    "{3498DB}Fishing Shop",
    "View Fishing Rods\nView Fishing Bait\nMy Equipment\nClose",
    "Select", "Cancel");

// Rod selection
// Show list of rods with prices and requirements
// Check if player has enough tokens
// Check if player meets level requirement
// Purchase and equip

// Bait selection
// Show list of bait with prices
// Check if player has enough tokens
// Purchase bait (add to inventory)
```

**Files to Create:**
- `fishing_shop_dialogs.inc`

**Testing:**
- [ ] Shop menu opens
- [ ] Can view all rods
- [ ] Can view all bait
- [ ] Purchase validation works
- [ ] Token deduction works
- [ ] Equipment equips properly

---

#### 2. Bait Consumption System
**Difficulty:** Easy  
**Time Estimate:** 1 hour  
**Dependencies:** None

**Description:**
Automatic bait consumption kada fishing attempt.

**Implementation:**
```pawn
// In /fish command or StartFishingWait
if(PlayerFishingData[playerid][pFishingBaitAmount] < 1)
{
    SendClientMessage(playerid, COLOR_RED, 
        "{E74C3C}[FISHING]{FFFFFF} Wala ka nang bait! Bumili sa /fishingshop");
    return 0;
}

// Consume 1 bait
PlayerFishingData[playerid][pFishingBaitAmount]--;

// Show notification
new string[64];
format(string, sizeof(string), 
    "{3498DB}[BAIT]{FFFFFF} Remaining: %d", 
    PlayerFishingData[playerid][pFishingBaitAmount]);
SendClientMessage(playerid, -1, string);

// Auto-save
SavePlayerFishingData(playerid);

// Warning when low
if(PlayerFishingData[playerid][pFishingBaitAmount] <= 5)
{
    SendClientMessage(playerid, COLOR_ORANGE, 
        "{F39C12}[WARNING]{FFFFFF} Malapit ka nang maubusan ng bait!");
}
```

**Testing:**
- [ ] Bait consumed per fishing attempt
- [ ] Warning shows when low
- [ ] Can't fish without bait
- [ ] Bait count saves to database

---

#### 3. Daily Quest Reset Timer
**Difficulty:** Easy  
**Time Estimate:** 1-2 hours  
**Dependencies:** None

**Description:**
Automatic reset ng daily quests every 24 hours.

**Implementation:**
```pawn
// In OnGameModeInit
SetTimer("CheckDailyQuestReset", 3600000, true); // Check every hour

forward CheckDailyQuestReset();
public CheckDailyQuestReset()
{
    new hour = gettime() / 3600 % 24;
    
    // Reset at 12:00 AM server time
    if(hour == 0)
    {
        // Reset all online players
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(!IsPlayerConnected(i)) continue;
            
            if(PlayerFishingData[i][pDailyQuestCompleted])
            {
                PlayerFishingData[i][pDailyQuestCompleted] = false;
                PlayerFishingData[i][pDailyQuestProgress] = 0;
                AssignDailyQuest(i);
                
                SendClientMessage(i, COLOR_GREEN, 
                    "{2ECC71}[DAILY QUEST]{FFFFFF} New quest available!");
            }
        }
        
        // Reset database for offline players
        mysql_tquery(MySQL, 
            "UPDATE players SET fishing_daily_completed = 0, \
            fishing_daily_progress = 0 WHERE fishing_daily_completed = 1");
        
        printf("[FISHING] Daily quests reset at %02d:00", hour);
    }
}
```

**Alternative:** Use timestamp-based system
```pawn
// Store last quest completion timestamp
new PlayerFishingData[playerid][pDailyQuestTimestamp];

// Check if 24 hours passed
if(gettime() - PlayerFishingData[playerid][pDailyQuestTimestamp] >= 86400)
{
    // Allow new quest
}
```

**Testing:**
- [ ] Quests reset at correct time
- [ ] Online players get new quests
- [ ] Offline players reset on login
- [ ] No duplicate resets

---

#### 4. Notification System (TextDraws)
**Difficulty:** Medium  
**Time Estimate:** 4-5 hours  
**Dependencies:** None

**Description:**
Visual notifications para sa important events.

**Features:**
- Level up notification
- Combo counter display
- Tournament timer
- Quest progress bar
- Rare fish alert

**Implementation:**
```pawn
// Level Up Notification
new PlayerText:LevelUpTD[MAX_PLAYERS][5];

stock ShowLevelUpNotification(playerid, newLevel)
{
    // Create animated textdraw
    LevelUpTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.0, 200.0, 
        "~g~LEVEL UP!");
    PlayerTextDrawAlignment(playerid, LevelUpTD[playerid][0], 2);
    PlayerTextDrawFont(playerid, LevelUpTD[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, LevelUpTD[playerid][0], 0.5, 2.0);
    PlayerTextDrawShow(playerid, LevelUpTD[playerid][0]);
    
    // Auto-hide after 3 seconds
    SetTimerEx("HideLevelUpTD", 3000, false, "i", playerid);
}

// Combo Counter
new PlayerText:ComboTD[MAX_PLAYERS];

stock UpdateComboDisplay(playerid)
{
    if(PlayerFishingData[playerid][pFishingCombo] >= 3)
    {
        new string[32];
        format(string, sizeof(string), 
            "~y~COMBO ~w~x%d", 
            PlayerFishingData[playerid][pFishingCombo]);
        
        PlayerTextDrawSetString(playerid, ComboTD[playerid], string);
        PlayerTextDrawShow(playerid, ComboTD[playerid]);
    }
    else
    {
        PlayerTextDrawHide(playerid, ComboTD[playerid]);
    }
}

// Tournament Timer
new Text:TournamentTimerTD;

stock UpdateTournamentTimer()
{
    if(!TournamentData[tournamentActive]) return;
    
    new timeLeft = TournamentData[tournamentEndTime] - gettime();
    new minutes = timeLeft / 60;
    new seconds = timeLeft % 60;
    
    new string[64];
    format(string, sizeof(string), 
        "~y~TOURNAMENT~n~~w~%02d:%02d", minutes, seconds);
    
    TextDrawSetString(TournamentTimerTD, string);
}
```

**Files to Create:**
- `fishing_notifications.inc`

**Testing:**
- [ ] Level up shows correctly
- [ ] Combo counter updates
- [ ] Tournament timer accurate
- [ ] No textdraw leaks
- [ ] Proper cleanup on disconnect

---

### Priority: MEDIUM ⭐⭐

#### 5. Fishing Achievements System
**Difficulty:** Medium  
**Time Estimate:** 6-8 hours  
**Dependencies:** None

**Description:**
Achievement system with rewards.

**Achievements:**
```
Beginner Fisherman - Catch 10 fish (Reward: 50 tokens)
Intermediate Fisherman - Catch 100 fish (Reward: 100 tokens)
Expert Fisherman - Catch 500 fish (Reward: 250 tokens)
Master Fisherman - Catch 1000 fish (Reward: 500 tokens)

First Blood - Catch first fish (Reward: 25 tokens)
Rare Hunter - Catch 10 rare fish (Reward: 150 tokens)
Legend Hunter - Catch 1 legendary fish (Reward: 200 tokens)
Legend Master - Catch 10 legendary fish (Reward: 1000 tokens)

Heavy Hitter - Catch 10kg fish (Reward: 100 tokens)
Whale Hunter - Catch 50kg fish (Reward: 300 tokens)
Leviathan Slayer - Catch 100kg fish (Reward: 500 tokens)

Combo Starter - Reach 5x combo (Reward: 50 tokens)
Combo Master - Reach 10x combo (Reward: 150 tokens)
Combo God - Reach 25x combo (Reward: 500 tokens)

Zone Explorer - Fish in all zones (Reward: 200 tokens)
Time Traveler - Fish at all times of day (Reward: 150 tokens)
Quest Master - Complete 10 daily quests (Reward: 300 tokens)

Tournament Winner - Win any tournament (Reward: 500 tokens)
Tournament Champion - Win 5 tournaments (Reward: 1000 tokens)

Max Level - Reach level 100 (Reward: 2000 tokens + Special Rod)
```

**Database:**
```sql
CREATE TABLE `fishing_achievements` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `achievement_name` VARCHAR(64) NOT NULL,
  `achievement_desc` VARCHAR(128) NOT NULL,
  `requirement_type` VARCHAR(32) NOT NULL,
  `requirement_value` INT(10) NOT NULL,
  `token_reward` INT(10) NOT NULL,
  `special_reward` VARCHAR(64) DEFAULT NULL
);

CREATE TABLE `player_fishing_achievements` (
  `player_id` INT(10) NOT NULL,
  `achievement_id` INT(10) NOT NULL,
  `unlocked_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`player_id`, `achievement_id`)
);
```

**Commands:**
- `/fishachievements` - View all achievements
- `/myachievements` - View unlocked achievements

**Testing:**
- [ ] Achievements unlock correctly
- [ ] Rewards given properly
- [ ] Progress tracked accurately
- [ ] Notifications show
- [ ] Database saves

---

#### 6. Fishing Crews/Teams
**Difficulty:** Hard  
**Time Estimate:** 10-12 hours  
**Dependencies:** None

**Description:**
Team-based fishing system.

**Features:**
- Create fishing crew (max 5 members)
- Crew bonuses (shared XP, bonus tokens)
- Crew tournaments
- Crew leaderboards
- Crew chat
- Crew treasury

**Implementation:**
```pawn
enum E_FISHING_CREW
{
    crewID,
    crewName[64],
    crewLeaderID,
    crewMemberCount,
    crewMembers[5],
    crewLevel,
    crewExp,
    crewTreasury,
    crewTotalCaught,
    Float:crewBiggestFish
}
new FishingCrews[MAX_CREWS][E_FISHING_CREW];

// Crew bonuses
#define CREW_XP_BONUS       10  // +10% XP when fishing with crew
#define CREW_TOKEN_BONUS    5   // +5% tokens
#define CREW_BITE_BONUS     5   // +5% bite speed

// Commands
CMD:createcrew(playerid, params[])
CMD:invitecrew(playerid, params[])
CMD:leavecrew(playerid, params[])
CMD:crewinfo(playerid, params[])
CMD:crewchat(playerid, params[])
CMD:crewdeposit(playerid, params[])
CMD:crewwithdraw(playerid, params[])
```

**Database:**
```sql
CREATE TABLE `fishing_crews` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `crew_name` VARCHAR(64) NOT NULL,
  `leader_id` INT(10) NOT NULL,
  `crew_level` INT(10) DEFAULT 1,
  `crew_exp` INT(10) DEFAULT 0,
  `crew_treasury` INT(10) DEFAULT 0,
  `total_caught` INT(10) DEFAULT 0,
  `biggest_fish` FLOAT DEFAULT 0.0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `fishing_crew_members` (
  `crew_id` INT(10) NOT NULL,
  `player_id` INT(10) NOT NULL,
  `joined_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`crew_id`, `player_id`)
);
```

**Testing:**
- [ ] Can create crew
- [ ] Can invite members
- [ ] Bonuses apply correctly
- [ ] Crew chat works
- [ ] Treasury system works
- [ ] Crew tournaments work

---

#### 7. Fishing Boat System
**Difficulty:** Hard  
**Time Estimate:** 8-10 hours  
**Dependencies:** Vehicle system

**Description:**
Purchasable fishing boats with bonuses.

**Features:**
- 3 boat types (Small, Medium, Large)
- Boat bonuses (speed, rare chance, capacity)
- Boat storage (store caught fish)
- Boat upgrades
- Deep sea access (requires boat)

**Boats:**
```
Small Boat
- Price: 50,000 + 500 tokens
- Capacity: 20 fish
- Bonus: +5% bite speed
- Access: Beach, River, Lake

Medium Boat
- Price: 150,000 + 1000 tokens
- Capacity: 50 fish
- Bonus: +10% bite speed, +5% rare chance
- Access: Beach, River, Lake, Shallow Sea

Large Boat
- Price: 500,000 + 2500 tokens
- Capacity: 100 fish
- Bonus: +15% bite speed, +10% rare chance
- Access: All zones including Deep Sea
```

**Implementation:**
```pawn
enum E_FISHING_BOAT
{
    boatID,
    boatOwnerID,
    boatType,
    Float:boatX,
    Float:boatY,
    Float:boatZ,
    Float:boatA,
    boatVehicleID,
    boatStoredFish,
    boatCapacity
}

CMD:buyboat(playerid, params[])
CMD:sellboat(playerid, params[])
CMD:boatstorage(playerid, params[])
CMD:upgradeboat(playerid, params[])
```

**Testing:**
- [ ] Can purchase boat
- [ ] Boat spawns correctly
- [ ] Storage system works
- [ ] Bonuses apply
- [ ] Deep sea access works

---

### Priority: LOW ⭐

#### 8. Seasonal Events
**Difficulty:** Medium  
**Time Estimate:** 6-8 hours  
**Dependencies:** None

**Description:**
Special fishing events during holidays.

**Events:**
```
Summer Fishing Festival (June-August)
- 2x XP
- Special summer fish
- Beach zone bonus

Winter Ice Fishing (December-February)
- Special ice fish
- Lake zone bonus
- Rare fish chance increased

Halloween Spooky Catch (October)
- Special spooky fish
- Night fishing bonus
- Legendary chance increased

Christmas Fishing (December 24-25)
- Special gift fish
- 3x tokens
- All bonuses active
```

**Implementation:**
```pawn
stock GetCurrentSeason()
{
    new month = gettime() / 2592000 % 12 + 1;
    
    if(month >= 6 && month <= 8) return SEASON_SUMMER;
    if(month >= 12 || month <= 2) return SEASON_WINTER;
    if(month == 10) return SEASON_HALLOWEEN;
    if(month == 12) return SEASON_CHRISTMAS;
    
    return SEASON_NORMAL;
}

stock ApplySeasonalBonuses(playerid, &xpBonus, &tokenBonus, &rareBonus)
{
    switch(GetCurrentSeason())
    {
        case SEASON_SUMMER: xpBonus += 100; // 2x XP
        case SEASON_WINTER: rareBonus += 15;
        case SEASON_HALLOWEEN: rareBonus += 20;
        case SEASON_CHRISTMAS: 
        {
            xpBonus += 100;
            tokenBonus += 200;
            rareBonus += 10;
        }
    }
}
```

**Testing:**
- [ ] Season detection works
- [ ] Bonuses apply correctly
- [ ] Special fish spawn
- [ ] Event announcements show

---

#### 9. Fish Market (Player Trading)
**Difficulty:** Hard  
**Time Estimate:** 12-15 hours  
**Dependencies:** None

**Description:**
Player-to-player fish trading system.

**Features:**
- List fish for sale
- Browse market
- Buy fish from other players
- Dynamic pricing
- Market tax (5%)
- Market history

**Implementation:**
```pawn
enum E_MARKET_LISTING
{
    listingID,
    sellerID,
    sellerName[24],
    fishName[64],
    fishRarity,
    Float:fishWeight,
    listingPrice,
    listedAt
}

CMD:fishmarket(playerid, params[])
CMD:listfish(playerid, params[])
CMD:buyfish(playerid, params[])
CMD:cancellist(playerid, params[])
```

**Database:**
```sql
CREATE TABLE `fishing_market` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `seller_id` INT(10) NOT NULL,
  `seller_name` VARCHAR(24) NOT NULL,
  `fish_name` VARCHAR(64) NOT NULL,
  `fish_rarity` VARCHAR(16) NOT NULL,
  `fish_weight` FLOAT NOT NULL,
  `price` INT(10) NOT NULL,
  `listed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_seller` (`seller_id`),
  INDEX `idx_rarity` (`fish_rarity`)
);
```

**Testing:**
- [ ] Can list fish
- [ ] Can browse market
- [ ] Can purchase fish
- [ ] Tax deduction works
- [ ] Market history saves

---

#### 10. Advanced Statistics & Analytics
**Difficulty:** Medium  
**Time Estimate:** 4-6 hours  
**Dependencies:** Fishing log table

**Description:**
Detailed statistics tracking.

**Stats to Track:**
- Fish caught per zone
- Fish caught per time of day
- Average fish weight
- Catch success rate
- Favorite fishing spot
- Most caught fish species
- Rarest fish caught
- Total money earned
- Total XP gained
- Fishing sessions
- Average session length

**Commands:**
- `/fishingstats` - Detailed personal stats
- `/fishinghistory` - Recent catches
- `/fishinganalytics` - Advanced analytics

**Implementation:**
```pawn
CMD:fishinganalytics(playerid, params[])
{
    // Query fishing_log table
    new query[512];
    mysql_format(MySQL, query, sizeof(query),
        "SELECT \
            COUNT(*) as total_catches, \
            AVG(fish_weight) as avg_weight, \
            MAX(fish_weight) as max_weight, \
            SUM(fish_value) as total_earned, \
            zone_id, \
            COUNT(CASE WHEN fish_rarity = 'legendary' THEN 1 END) as legendary_count \
        FROM fishing_log \
        WHERE player_id = %d \
        GROUP BY zone_id",
        GetPlayerDatabaseID(playerid));
    
    mysql_tquery(MySQL, query, "OnLoadFishingAnalytics", "i", playerid);
}
```

**Testing:**
- [ ] Stats calculate correctly
- [ ] History shows recent catches
- [ ] Analytics display properly
- [ ] Performance is acceptable

---

## 🔒 Anti-Cheat & Security

### Priority: HIGH (After Core Complete)

#### 11. Fishing Anti-Cheat
**Difficulty:** Medium  
**Time Estimate:** 6-8 hours  
**Dependencies:** Core system

**Checks:**
```pawn
// 1. Fishing Speed Check
new LastFishingTime[MAX_PLAYERS];

if(gettime() - LastFishingTime[playerid] < 5)
{
    // Too fast, possible bot
    SendAdminMessage(COLOR_RED, 
        "[ANTI-CHEAT] %s fishing too fast", GetPlayerNameEx(playerid));
}

// 2. Location Validation
if(!IsPlayerInFishingZone(playerid))
{
    // Fishing outside zone
    CancelFishing(playerid);
}

// 3. Catch Rate Monitoring
new FishingAttempts[MAX_PLAYERS];
new SuccessfulCatches[MAX_PLAYERS];

new Float:successRate = float(SuccessfulCatches[playerid]) / float(FishingAttempts[playerid]);

if(successRate > 0.95) // 95% success rate is suspicious
{
    // Possible minigame bypass
    SendAdminMessage(COLOR_RED, 
        "[ANTI-CHEAT] %s has %.1f%% catch rate", 
        GetPlayerNameEx(playerid), successRate * 100.0);
}

// 4. Token Earning Limits
new TokensEarnedToday[MAX_PLAYERS];

if(TokensEarnedToday[playerid] > 1000)
{
    // Earning too many tokens
    SendAdminMessage(COLOR_ORANGE, 
        "[WARNING] %s earned %d tokens today", 
        GetPlayerNameEx(playerid), TokensEarnedToday[playerid]);
}

// 5. Legendary Fish Frequency
new LegendaryCaughtToday[MAX_PLAYERS];

if(LegendaryCaughtToday[playerid] > 10)
{
    // Too many legendary catches
    SendAdminMessage(COLOR_RED, 
        "[ANTI-CHEAT] %s caught %d legendary fish today", 
        GetPlayerNameEx(playerid), LegendaryCaughtToday[playerid]);
}
```

**Admin Commands:**
- `/fishingac [playerid]` - View player's fishing stats
- `/resetfishingac [playerid]` - Reset AC flags
- `/banfishing [playerid]` - Ban from fishing

**Testing:**
- [ ] Speed check works
- [ ] Location validation works
- [ ] Catch rate monitoring works
- [ ] Token limits work
- [ ] Admin notifications work

---

## 📝 Documentation Updates

### After Each Feature

1. Update `FISHING_RPG_IMPLEMENTATION.md`
2. Update `FISHING_QUICK_REFERENCE.md`
3. Add to `FISHING_PHASE2_ROADMAP.md` (this file)
4. Create feature-specific docs if needed

---

## 🎯 Recommended Implementation Order

### Stage 1: Core Enhancements (1-2 weeks)
1. Equipment shop dialogs
2. Bait consumption
3. Daily quest reset
4. Notification system

### Stage 2: Engagement Features (2-3 weeks)
5. Achievements system
6. Fishing crews
7. Seasonal events

### Stage 3: Advanced Features (3-4 weeks)
8. Fishing boats
9. Fish market
10. Advanced analytics

### Stage 4: Security & Polish (1 week)
11. Anti-cheat system
12. Admin tools
13. Performance optimization

---

## 💡 Additional Ideas (Brainstorming)

### Future Considerations
- Fishing mini-games variety (different catch mechanics)
- Fishing competitions (weekly/monthly)
- Fishing licenses (VIP feature)
- Fishing pets (companions with bonuses)
- Fishing skills tree (specializations)
- Weather effects on fishing
- Moon phases affecting rare fish
- Fishing guilds (larger than crews)
- Fishing expeditions (group events)
- Legendary fish quests (special hunts)
- Fishing cosmetics (rod skins, boat colors)
- Fishing radio (music while fishing)
- Fishing photography (screenshot system)
- Fishing journal (personal log book)
- Fishing mentor system (teach newbies)

---

## 📞 Support & Maintenance

### Regular Maintenance Tasks
- Weekly: Check leaderboards for anomalies
- Monthly: Review fishing statistics
- Quarterly: Balance adjustments
- Yearly: Major feature updates

### Performance Monitoring
- Database query optimization
- Timer efficiency
- Memory usage
- Player feedback

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Status:** Planning Phase

**Note:** Itong roadmap ay living document. Update regularly based sa player feedback at server needs!
