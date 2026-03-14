# ✅ Fishing System - TODO Checklist

## Immediate Tasks (Core Integration)

### 🔴 Critical (Kailangan para gumana ang system)

#### Database Connection
```
[ ] 1. Run SQL setup script (database/fishing_rpg_setup.sql)
[ ] 2. Verify all columns added to players table
[ ] 3. Verify fishing_leaderboard table created
[ ] 4. Test database connection
```

#### MySQL Integration
```
[ ] 5. Define MySQL handle variable
      Location: fishing_core.inc
      Code: new MySQL; // or your existing handle name

[ ] 6. Implement GetPlayerDatabaseID()
      Location: fishing_rpg_master.pwn
      Code: return PlayerData[playerid][pSQLID];

[ ] 7. Uncomment LoadPlayerFishingData() queries
      Location: fishing_core.inc
      Lines: ~50-70

[ ] 8. Uncomment SavePlayerFishingData() queries
      Location: fishing_core.inc
      Lines: ~80-100

[ ] 9. Test data loading on player login
[ ] 10. Test data saving on player disconnect
```

#### Wait System Integration
```
[ ] 11. Add bonus calculations to StartFishingWait()
       Location: fishing_txd.pwn
       Add: GetRodData(), GetBaitData(), GetTimeOfDayBiteBonus()

[ ] 12. Apply bonuses to wait time calculation
       Formula: waitTime = waitTime * (100 - totalBonus) / 100

[ ] 13. Test wait time with different equipment
[ ] 14. Test wait time at different times of day
[ ] 15. Test combo bonuses
```

#### Fish Generation Integration
```
[ ] 16. Add zone check to /fish command
       Code: if(!IsPlayerInFishingZone(playerid)) return;

[ ] 17. Call GenerateFish() before starting wait
       Code: GenerateFish(playerid, FishingZones[zoneIdx][zoneID]);

[ ] 18. Test fish generation in all zones
[ ] 19. Verify rarity calculation works
[ ] 20. Verify weight generation works
```

#### Minigame Integration
```
[ ] 21. Call OnPlayerCatchFish() on successful catch
       Location: fishing_txd.pwn, OnPlayerKeyStateChange
       
[ ] 22. Call OnPlayerFailCatch() on failed catch
       Location: fishing_txd.pwn, OnPlayerKeyStateChange

[ ] 23. Test catch success flow
[ ] 24. Test catch failure flow
[ ] 25. Verify rewards given correctly
```

#### Bait System
```
[ ] 26. Add bait check to /fish command
       Code: if(PlayerFishingData[playerid][pFishingBaitAmount] < 1)

[ ] 27. Consume bait on fishing attempt
       Code: PlayerFishingData[playerid][pFishingBaitAmount]--;

[ ] 28. Test bait consumption
[ ] 29. Test "out of bait" message
[ ] 30. Verify bait saves to database
```

---

### 🟡 Important (Para sa full functionality)

#### Equipment Shop
```
[ ] 31. Create fishing_shop_dialogs.inc file
[ ] 32. Implement DIALOG_FISHING_SHOP_MAIN response
[ ] 33. Implement DIALOG_FISHING_SHOP_RODS response
[ ] 34. Implement DIALOG_FISHING_SHOP_BAIT response
[ ] 35. Add purchase validation (tokens, level)
[ ] 36. Add token deduction on purchase
[ ] 37. Add equipment equip on purchase
[ ] 38. Test rod purchase flow
[ ] 39. Test bait purchase flow
[ ] 40. Test "not enough tokens" message
```

#### Player Data Loading
```
[ ] 41. Call LoadPlayerFishingData() in OnPlayerLogin
       Location: Your gamemode's login callback

[ ] 42. Call SavePlayerFishingData() in OnPlayerDisconnect
       Location: Your gamemode's disconnect callback

[ ] 43. Test data persistence (login/logout)
[ ] 44. Verify all stats load correctly
[ ] 45. Verify all stats save correctly
```

#### Daily Quest System
```
[ ] 46. Add daily quest reset timer
       Code: SetTimer("CheckDailyQuestReset", 3600000, true);

[ ] 47. Implement CheckDailyQuestReset() function
[ ] 48. Test quest reset at midnight
[ ] 49. Test quest assignment on reset
[ ] 50. Verify quest progress saves
```

---

### 🟢 Optional (Nice to have)

#### Turf Integration
```
[ ] 51. Implement GetZoneTurfOwner()
       Connect to your gang/turf system

[ ] 52. Implement GetTurfBiteSpeedBonus()
       Check if player's gang owns turf

[ ] 53. Implement GiveTurfOwnerCut()
       Add money to gang treasury

[ ] 54. Test turf bonuses
[ ] 55. Test gang treasury cuts
```

#### Notifications
```
[ ] 56. Create fishing_notifications.inc
[ ] 57. Implement level up textdraw
[ ] 58. Implement combo counter textdraw
[ ] 59. Implement tournament timer textdraw
[ ] 60. Test all notifications
```

#### Tournament System
```
[ ] 61. Add tournament auto-start timer (optional)
[ ] 62. Test manual tournament start
[ ] 63. Test tournament scoring
[ ] 64. Test tournament end
[ ] 65. Test tournament rewards
```

---

## Testing Checklist

### Basic Functionality
```
[ ] Player can type /fish
[ ] Player can see fishing zones with /fishzones
[ ] Player can view stats with /fishstats
[ ] Player can view quest with /fishquest
[ ] Player can open shop with /fishingshop
```

### Fishing Flow
```
[ ] Player goes to fishing zone
[ ] Player types /fish
[ ] Wait state starts with animation
[ ] Fish bites after calculated time
[ ] Minigame appears
[ ] Player catches fish successfully
[ ] Rewards given (money, exp, tokens)
[ ] Stats updated (total caught, weight, etc.)
[ ] Data saves to database
```

### Equipment System
```
[ ] Player can view rods in shop
[ ] Player can view bait in shop
[ ] Player can purchase rod (if has tokens)
[ ] Player can purchase bait (if has tokens)
[ ] Rod bonuses apply to wait time
[ ] Bait bonuses apply to wait time
[ ] Equipment saves to database
```

### Progression System
```
[ ] Player gains experience on catch
[ ] Player levels up at correct exp
[ ] Level up rewards given (tokens)
[ ] Level up message shows
[ ] Fishing level affects wait time
[ ] Fishing level affects rare chance
```

### Quest System
```
[ ] Player receives daily quest on login
[ ] Quest progress updates on catch
[ ] Quest completes when target reached
[ ] Quest rewards given (tokens)
[ ] Quest resets daily
```

### Tournament System
```
[ ] Admin can start tournament
[ ] Tournament announcement shows
[ ] Player catches count toward tournament
[ ] Tournament leaderboard updates
[ ] Tournament ends correctly
[ ] Winner announced
[ ] Winner receives rewards
```

### Leaderboard System
```
[ ] /fishtop total shows correct rankings
[ ] /fishtop weight shows correct rankings
[ ] /fishtop legendary shows correct rankings
[ ] Leaderboard updates on catch
[ ] Leaderboard saves to database
```

---

## Bug Testing

### Edge Cases
```
[ ] Player disconnects while fishing
[ ] Player dies while fishing
[ ] Player enters vehicle while fishing
[ ] Player teleports while fishing
[ ] Player runs out of bait mid-fishing
[ ] Player levels up during fishing
[ ] Tournament ends while player fishing
[ ] Daily quest completes during fishing
```

### Data Integrity
```
[ ] Negative values prevented (tokens, exp, etc.)
[ ] Maximum values enforced (level 100 cap)
[ ] Invalid equipment IDs handled
[ ] Invalid zone IDs handled
[ ] Database errors handled gracefully
```

### Performance
```
[ ] No timer leaks
[ ] No textdraw leaks
[ ] No memory leaks
[ ] Database queries optimized
[ ] No lag spikes during fishing
```

---

## Documentation

### Code Documentation
```
[ ] All functions have comments
[ ] All variables explained
[ ] All constants documented
[ ] Complex logic explained
```

### User Documentation
```
[ ] README updated
[ ] Command list updated
[ ] Feature list updated
[ ] Known issues documented
```

---

## Deployment Checklist

### Pre-Deployment
```
[ ] All critical tasks completed
[ ] All tests passed
[ ] Database backup created
[ ] Code reviewed
[ ] Performance tested
```

### Deployment
```
[ ] Upload files to server
[ ] Run SQL setup script
[ ] Restart server
[ ] Test on live server
[ ] Monitor for errors
```

### Post-Deployment
```
[ ] Announce new system to players
[ ] Monitor player feedback
[ ] Fix any reported bugs
[ ] Adjust balance if needed
```

---

## Progress Tracking

### Current Status
```
Phase 1 (Core System): ████████████████████ 100%
Phase 1.5 (Integration): ░░░░░░░░░░░░░░░░░░░░ 0%
Phase 2 (Enhancements): ░░░░░░░░░░░░░░░░░░░░ 0%
```

### Time Estimates
```
Critical Tasks: 8-10 hours
Important Tasks: 6-8 hours
Optional Tasks: 4-6 hours
Testing: 4-6 hours
Total: 22-30 hours
```

---

## Notes

### Important Reminders
- Backup database before running SQL scripts
- Test on development server first
- Keep original fishing_txd.pwn as backup
- Document any custom changes
- Update this checklist as you progress

### Common Issues
1. **MySQL connection fails**
   - Check MySQL handle name
   - Verify connection in OnGameModeInit
   - Check credentials

2. **Data not saving**
   - Verify SavePlayerFishingData() called
   - Check MySQL query syntax
   - Check column names match

3. **Bonuses not applying**
   - Verify equipment IDs correct
   - Check calculation order
   - Test with debug messages

4. **Fish not generating**
   - Check zone detection
   - Verify fish species loaded
   - Check zone ID matches

---

**Checklist Version:** 1.0  
**Last Updated:** 2024  
**Status:** Ready for Integration

**Tip:** Check off items as you complete them. Update progress percentage regularly!
