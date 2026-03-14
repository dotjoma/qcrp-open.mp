# Fishing Wait-State System - Quick Start Guide

## 🎣 What You Just Got

A complete fishing wait-state system where:
- Players wait for fish to bite (3-15 seconds depending on skill level)
- Higher fishing level = faster bite times
- Smooth animation integration
- Database-ready with existing `fishingskill` field

---

## 🚀 Quick Test (5 Minutes)

### Step 1: Load the Filterscript
Add to your `server.cfg`:
```
filterscripts fishing_txd
```

### Step 2: Restart Server
Restart your SA-MP server.

### Step 3: Test In-Game

```
/setfishlevel 1    // Set yourself to beginner level
/fish              // Start fishing
// Wait 10-15 seconds for fish to bite
// Minigame will appear when fish bites

/setfishlevel 10   // Set yourself to expert level  
/fish              // Start fishing
// Wait only 3-5 seconds for fish to bite
```

---

## 📊 How The System Works

### Wait Time Formula

```
Level 1:  12-15 seconds wait
Level 2:  10-13 seconds wait
Level 3:  9-11 seconds wait
Level 4:  8-10 seconds wait
Level 5:  6-9 seconds wait
Level 6:  5-7 seconds wait
Level 7:  4-6 seconds wait
Level 8:  4-5 seconds wait
Level 9:  3-4 seconds wait
Level 10: 3-5 seconds wait
```

### Visual Flow

```
Player types /fish
    ↓
Fishing rod attached
    ↓
Baseball bat animation (1 second)
    ↓
Sword idle animation starts
    ↓
Wait state begins (timer starts)
    ↓
Countdown shows every 3 seconds
    ↓
Fish bites! (sound + message)
    ↓
Minigame UI appears
    ↓
Player catches fish
```

---

## 🔧 Integration with Your Gamemode

### Option 1: Quick Integration (Recommended)

Copy the relevant sections from `GAMEMODE_INTEGRATION_EXAMPLE.pwn` to your gamemode:

1. **Add to player data enum** (Section 1)
2. **Load fishing level on login** (Section 2)
3. **Add fishing checks to /fish command** (Section 3)
4. **Add cancel fishing on movement** (Section 4)
5. **Add experience system** (Section 5)

### Option 2: Minimal Integration

Just load the fishing level from database:

```pawn
// In your OnPlayerLogin callback
public OnPlayerLogin(playerid)
{
    // ... your existing code ...
    
    // Load fishing skill from database
    new fishingLevel;
    cache_get_value_name_int(0, "fishingskill", fishingLevel);
    
    // Send to filterscript
    CallRemoteFunction("SetPlayerFishingLevel", "ii", playerid, fishingLevel);
}
```

---

## 🎮 Available Commands

### Player Commands
- `/fish` - Start fishing with wait state
- `/fishtd` - Start fishing minigame directly (testing)
- `/fishingstats` - View fishing statistics (add to gamemode)

### Admin/Testing Commands
- `/setfishlevel [1-10]` - Set fishing level for testing
- `/setfishinglevel [playerid] [level]` - Admin command (add to gamemode)

---

## 📁 Files Created

1. **fishing_txd.pwn** - Main filterscript (modified)
   - Added wait state system
   - Added probability calculations
   - Added timer management

2. **FISHING_WAIT_STATE_README.md** - Complete documentation
   - System overview
   - Technical details
   - Integration guide
   - Troubleshooting

3. **GAMEMODE_INTEGRATION_EXAMPLE.pwn** - Copy-paste examples
   - Player data structure
   - Database loading
   - Experience system
   - Helper functions

4. **QUICK_START_GUIDE.md** - This file
   - Quick testing
   - Basic integration
   - Command reference

---

## 🔍 Testing Checklist

- [ ] Filterscript loads without errors
- [ ] `/setfishlevel 1` sets level to 1
- [ ] `/fish` starts wait state
- [ ] Countdown shows in GameText
- [ ] Fish bites after 10-15 seconds (level 1)
- [ ] Minigame UI appears after bite
- [ ] `/setfishlevel 10` reduces wait time
- [ ] Fish bites after 3-5 seconds (level 10)

---

## 🐛 Common Issues

### "Fish never bites"
**Solution:** Check if timer is being killed elsewhere. Add debug messages.

### "Wait time is wrong"
**Solution:** Adjust `MIN_WAIT_TIME` and `MAX_WAIT_TIME` in fishing_txd.pwn

### "Animation doesn't play"
**Solution:** Make sure player is not in vehicle and not already in animation

### "Fishing level not loading"
**Solution:** Check database connection and field name (`fishingskill`)

---

## 🎯 Next Steps

### Immediate (Today)
1. Test the system with different levels
2. Adjust wait times if needed
3. Add basic checks (has rod, has bait)

### Short Term (This Week)
1. Integrate with your gamemode's player data
2. Add database loading on login
3. Implement experience/leveling system
4. Add fishing zones (near water check)

### Long Term (Future)
1. Add bait quality system
2. Add rare fish with longer waits
3. Add fishing competitions
4. Add fishing achievements
5. Add weather/time effects

---

## 📞 Support

If you need help:
1. Check `FISHING_WAIT_STATE_README.md` for detailed docs
2. Review `GAMEMODE_INTEGRATION_EXAMPLE.pwn` for code examples
3. Test with `/setfishlevel` command first
4. Add debug messages to track timer execution

---

## 🎉 You're Ready!

The system is fully functional and ready to test. Start with `/setfishlevel` and `/fish` commands to see it in action!

**Pro Tip:** Test with level 10 first (3-5 second wait) to quickly verify everything works, then test level 1 (10-15 seconds) to see the full range.

Good luck with your fishing system! 🎣
