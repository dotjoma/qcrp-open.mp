# ✅ Fishing System - Final Setup Checklist

## Database Setup ✅ (DONE)

```
[✓] Ran fishing_players_table.sql
[✓] Players table created
[✓] Fishing columns added
[✓] Leaderboard table created
[✓] Foreign keys set up
```

---

## File Organization

### Current Structure (Perfect! No changes needed)

```
filterscripts/
├── fishing_rpg_master.pwn          ← Main file
├── fishing_data_structures.inc     ← Data structures (UPDATED ✅)
├── fishing_core.inc                ← Core system (UPDATED ✅)
├── fishing_equipment.inc           ← Equipment system
├── fishing_catch.inc               ← Fish generation
├── fishing_zones.inc               ← Zones & turf
├── fishing_quests.inc              ← Daily quests
├── fishing_tournament.inc          ← Tournaments
├── fishing_leaderboard.inc         ← Leaderboards
└── fishing_txd.pwn                 ← Original minigame
```

**Status:** ✅ All files in correct location

---

## Compilation

### Step 1: Compile fishing_rpg_master.pwn

```
[ ] 1. Open pawno.exe
[ ] 2. File > Open > filterscripts/fishing_rpg_master.pwn
[ ] 3. Press F5 to compile
[ ] 4. Check for errors
[ ] 5. Verify fishing_rpg_master.amx created
```

**Expected Output:**
```
Pawn compiler 3.10.10
Header size: ... bytes
Code size: ... bytes
Data size: ... bytes
Stack/heap size: 16384 bytes
Total requirements: ... bytes

Done.
```

---

## Server Configuration

### Step 2: Update server.cfg

```
[ ] Open server.cfg
[ ] Find line: filterscripts ...
[ ] Add: fishing_rpg_master
```

**Example:**
```ini
# Before
filterscripts fishing_txd

# After
filterscripts fishing_txd fishing_rpg_master
```

---

## Gamemode Integration

### Step 3: Add Auto-Create Code

Add this to your gamemode's OnPlayerLogin:

```pawn
// In GM_Nuron.pwn or your main gamemode

public OnPlayerLogin(playerid)
{
    // ... your existing login code ...
    
    // Add this for fishing system
    new user_id = PlayerData[playerid][pUserID]; // Your existing user ID
    CheckOrCreateFishingPlayer(playerid, user_id);
    
    return 1;
}

// Add these functions
stock CheckOrCreateFishingPlayer(playerid, user_id)
{
    new query[256];
    mysql_format(MySQL, query, sizeof(query),
        "SELECT id FROM players WHERE user_id = %d", user_id);
    mysql_tquery(MySQL, query, "OnCheckFishingPlayer", "ii", playerid, user_id);
}

forward OnCheckFishingPlayer(playerid, user_id);
public OnCheckFishingPlayer(playerid, user_id)
{
    new rows;
    cache_get_row_count(rows);
    
    if(rows == 0)
    {
        // Create fishing player
        new username[24], query[256];
        GetPlayerName(playerid, username, 24);
        
        mysql_format(MySQL, query, sizeof(query),
            "CALL CreateFishingPlayer(%d, '%e')", user_id, username);
        mysql_tquery(MySQL, query, "OnCreateFishingPlayer", "ii", playerid, user_id);
    }
    else
    {
        // Load fishing data
        CallRemoteFunction("LoadPlayerFishingData", "ii", playerid, user_id);
    }
}

forward OnCreateFishingPlayer(playerid, user_id);
public OnCreateFishingPlayer(playerid, user_id)
{
    SendClientMessage(playerid, 0x2ECC71FF, 
        "{2ECC71}[FISHING]{FFFFFF} Welcome to the fishing system! Type /fishhelp");
    
    // Load fishing data
    CallRemoteFunction("LoadPlayerFishingData", "ii", playerid, user_id);
}
```

**Checklist:**
```
[ ] Added CheckOrCreateFishingPlayer function
[ ] Added OnCheckFishingPlayer callback
[ ] Added OnCreateFishingPlayer callback
[ ] Called from OnPlayerLogin
[ ] Tested compilation
```

---

## Testing

### Step 4: Start Server & Test

```
[ ] 1. Start SA-MP server
[ ] 2. Check server_log.txt for errors
[ ] 3. Connect to server
[ ] 4. Login with your account
[ ] 5. Type /fishhelp
[ ] 6. Type /fishinfo
[ ] 7. Type /fishstats
```

**Expected Messages:**
```
[FISHING] Initializing RPG Fishing System...
[FISHING] Loaded 6 fish species
[FISHING] Loaded 6 fishing rods
[FISHING] Loaded 5 fishing bait
[FISHING] Loaded 4 fishing zones
[FISHING] Loaded 30+ fish species
[FISHING] Loaded 8 daily quests
[FISHING] System initialized successfully!
```

**In-Game Test:**
```
[ ] /fishhelp - Shows command list
[ ] /fishinfo - Shows system info
[ ] /fishstats - Shows your stats
[ ] /fishzones - Shows fishing zones
[ ] /fishquest - Shows daily quest
```

---

## Verification

### Step 5: Database Check

```sql
-- Check if your fishing player was created
SELECT * FROM players WHERE username = 'YourUsername';

-- Should show:
-- id, user_id, username, fishing_level=1, fishing_tokens=0, etc.
```

### Step 6: Log Check

Check `server_log.txt` for:
```
✅ [FISHING] System initialized successfully!
✅ [FISHING] Loaded data for player 0 (DB ID: 1, Level: 1)
❌ No SQL errors
❌ No "Cannot find include" errors
```

---

## Common Issues & Solutions

### Issue 1: "Cannot find include file"

**Error:**
```
fatal error 100: cannot read from file: "fishing_data_structures.inc"
```

**Solution:**
```
✓ Make sure all .inc files are in filterscripts/ folder
✓ Check file names match exactly (case-sensitive on Linux)
✓ Verify fishing_rpg_master.pwn uses quotes: #include "fishing_data_structures.inc"
```

### Issue 2: "Undefined symbol: MySQL"

**Error:**
```
error 017: undefined symbol "MySQL"
```

**Solution:**
```pawn
// Add to fishing_rpg_master.pwn
new MySQL; // Your MySQL handle

// Or if you have different handle name:
#define MySQL YourMySQLHandleName
```

### Issue 3: "No fishing data found"

**Error in log:**
```
[FISHING] ERROR: No fishing data found for player 0
```

**Solution:**
```
✓ Make sure OnPlayerLogin calls CheckOrCreateFishingPlayer
✓ Check if CreateFishingPlayer procedure exists in database
✓ Verify user_id is correct
✓ Check MySQL connection is working
```

### Issue 4: Filterscript not loading

**Problem:** Server starts but fishing system doesn't load

**Solution:**
```
✓ Check server.cfg has: filterscripts fishing_rpg_master
✓ Verify fishing_rpg_master.amx exists in filterscripts/ folder
✓ Check file permissions (Linux)
✓ Look for errors in server_log.txt
```

---

## Performance Check

### Step 7: Monitor Performance

```
[ ] Server starts without lag
[ ] No memory leaks
[ ] No timer spam in logs
[ ] Commands respond quickly
[ ] Database queries fast (<100ms)
```

**Check Query Time:**
```sql
-- Enable MySQL query logging
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';

-- Check slow queries
SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 10;
```

---

## Final Checklist

```
[✓] Database setup complete
[ ] Files organized correctly
[ ] fishing_rpg_master.pwn compiled
[ ] server.cfg updated
[ ] Gamemode integration added
[ ] Server starts without errors
[ ] Can login to server
[ ] Fishing commands work
[ ] Data loads from database
[ ] Data saves to database
[ ] No errors in server_log.txt
```

---

## Next Steps

Once everything is working:

### Phase 1.5: Core Integration (1-2 days)
```
[ ] Integrate with fishing_txd.pwn minigame
[ ] Add bonus calculations to wait time
[ ] Connect fish generation
[ ] Add success/failure handlers
[ ] Test full fishing flow
```

### Phase 2: Enhanced Features (1-2 weeks)
```
[ ] Equipment shop dialogs
[ ] Daily quest reset timer
[ ] Tournament auto-start
[ ] Notification system
[ ] See: FISHING_PHASE2_ROADMAP.md
```

---

## Support

### If You Need Help

1. **Check Documentation:**
   - FILE_ORGANIZATION_GUIDE.md
   - FISHING_DATABASE_INTEGRATION.md
   - FISHING_TODO_CHECKLIST.md

2. **Check Logs:**
   - server_log.txt
   - mysql_log.txt (if enabled)

3. **Test Queries:**
   ```sql
   SELECT * FROM players;
   DESCRIBE players;
   SHOW TABLES LIKE '%fishing%';
   ```

---

## Success Indicators

You'll know it's working when:

```
✅ Server starts with "[FISHING] System initialized successfully!"
✅ Player login shows "[FISHING] Loaded data for player..."
✅ /fishhelp shows command list
✅ /fishstats shows your fishing stats
✅ Database has your fishing player record
✅ No errors in server_log.txt
```

---

**Setup Version:** 1.0  
**Last Updated:** 2024  
**Status:** Ready for Testing

**Good luck! 🎣**
