---
title: TD-Streamer Setup and Configuration
description: Complete guide for setting up PawnPlus TD-Streamer to remove textdraw limits and enable unlimited textdraws in SA-MP
tags: [textdraw, td-streamer, pawnplus, optimization, limits]
---

# TD-Streamer Setup and Configuration

## Overview

The **TD-Streamer** (TextDraw Streamer) is a library that removes the hardcoded SA-MP textdraw limits by using lazy creation and automatic cleanup. Instead of creating all textdraws at once, it only creates them when they need to be shown, and destroys them when hidden.

### Default SA-MP Limits
- **Global TextDraws**: 2048 maximum
- **Player TextDraws**: 256 per player maximum

### With TD-Streamer
- **No limits** - Create thousands of textdraws
- **Automatic memory management** - Only visible textdraws use slots
- **Same API** - No code changes needed

---

## Requirements

### 1. PawnPlus Plugin

TD-Streamer requires the **PawnPlus plugin** to function.

**Installation:**
1. Download from: https://github.com/IllidanS4/PawnPlus/releases/latest
2. Extract `PawnPlus.dll` (Windows) or `PawnPlus.so` (Linux)
3. Copy to `plugins/` folder
4. Add to `server.cfg`:
   ```
   plugins crashdetect pawncmd PawnPlus sampvoice sscanf streamer ...
   ```

**Important:** PawnPlus must be loaded BEFORE other plugins that use it.

### 2. Include Files

Required includes in your gamemode:
```pawn
#include <a_samp>
#include <PawnPlus>
#include <td-streamer>  // or <td-streamer-global> and <td-streamer-player>
```

**Critical:** TD-Streamer MUST be included BEFORE any other libraries that hook textdraw functions (like weapon-config, YSF, SKY, etc.)

---

## How It Works

### Normal SA-MP Behavior
```pawn
new Text:td = TextDrawCreate(x, y, "Text");  // Creates textdraw (uses 1 slot)
TextDrawShowForPlayer(playerid, td);          // Shows it
TextDrawHideForPlayer(playerid, td);          // Hides it (slot still used)
TextDrawDestroy(td);                          // Destroys it (frees slot)
```

### TD-Streamer Behavior
```pawn
new Text:td = TextDrawCreate(x, y, "Text");  // Stores data only (no slot used)
TextDrawShowForPlayer(playerid, td);          // NOW creates actual textdraw + shows
TextDrawHideForPlayer(playerid, td);          // Destroys textdraw (frees slot)
```

**Key Benefits:**
- Textdraws only exist when visible
- Automatic slot management
- No manual cleanup needed
- Same function names (plug & play)

---

## Integration with Weapon-Config

### The Problem

The `weapon-config.inc` library also hooks textdraw functions for tracking purposes. When both libraries try to hook the same functions, conflicts occur:

1. TD-Streamer hooks textdraw functions first
2. Weapon-config hooks them again, overriding TD-Streamer
3. Textdraws created through weapon-config don't have TD-Streamer's data structure
4. Results in crashes and missing textdraws

### The Solution

We modified `weapon-config.inc` to detect TD-Streamer and disable its own textdraw hooking:

```pawn
// At the top of weapon-config.inc
#if defined _TDS_global_included || defined _TDS_player_included
    #define WC_DISABLE_TD_HOOKS
#endif

// All textdraw hooks are wrapped with:
#if !defined WC_DISABLE_TD_HOOKS
    // weapon-config's textdraw hooks
#endif
```

**Result:** TD-Streamer handles ALL textdraw operations, weapon-config's hooks are disabled.

---

## Fixed Issues

### Issue 1: Invalid String References

**Problem:** TD-Streamer tried to delete invalid string references from textdraws created outside its system.

**Fix:** Added `str_valid()` check before deleting strings:

```pawn
// In td-streamer-global.inc and td-streamer-player.inc
stock TDS_TextDrawSetString(Text:text, const string[]) {
    // ... code ...
    
    if(str_valid(data[E_TD_STRING])) {  // ✅ Check if valid first
        str_delete(data[E_TD_STRING]);
    }
    data[E_TD_STRING] = str_new(string);
    
    // ... code ...
}
```

### Issue 2: Weapon-Config Hook Conflicts

**Problem:** Weapon-config's textdraw hooks overrode TD-Streamer's hooks.

**Fix:** Added conditional compilation to disable weapon-config hooks when TD-Streamer is present:

```pawn
// weapon-config.inc now checks for TD-Streamer
#if defined _TDS_global_included || defined _TDS_player_included
    #define WC_DISABLE_TD_HOOKS
#endif

// All hooks wrapped with:
#if !defined WC_DISABLE_TD_HOOKS
    #define TextDrawCreate WC_TextDrawCreate
    // ... other hooks ...
#endif
```

### Issue 3: PlayerTextDraw Redefinition Warnings

**Problem:** Both libraries defined the same PlayerTextDraw functions, causing compiler warnings.

**Fix:** Modified weapon-config to check for TD-Streamer's guards before defining:

```pawn
#if defined _ALS_PlayerTDSetProportional || defined _ALS_PlayerTextDrawSetProportio
    #undef PlayerTextDrawSetProportional
#else
    #define _ALS_PlayerTextDrawSetProportio
#endif
#if !defined _ALS_PlayerTDSetProportional  // ✅ Only define if TD-Streamer didn't
    #define PlayerTextDrawSetProportional WC_PlayerTextDrawSetProportiona
#endif
```

---

## Include Order (CRITICAL)

The order of includes is crucial for proper operation:

```pawn
// ✅ CORRECT ORDER
#include <a_samp>
#include <PawnPlus>
#include <td-streamer>        // MUST be before weapon-config
#include <weapon-config>      // After td-streamer
#include <other_includes>

// ❌ WRONG ORDER
#include <a_samp>
#include <weapon-config>      // Before td-streamer = CONFLICT
#include <PawnPlus>
#include <td-streamer>
```

**Rule:** TD-Streamer must be the FIRST library to hook textdraw functions.

---

## Usage Examples

### Creating Unlimited Textdraws

```pawn
// Create 1000 textdraws (would fail without TD-Streamer)
new Text:myTextDraws[1000];

for(new i = 0; i < 1000; i++) {
    myTextDraws[i] = TextDrawCreate(10.0, 10.0 + (i * 15.0), "Text");
    TextDrawFont(myTextDraws[i], 1);
    TextDrawLetterSize(myTextDraws[i], 0.3, 1.0);
}

// Show only 10 at a time (only 10 slots used)
for(new i = 0; i < 10; i++) {
    TextDrawShowForPlayer(playerid, myTextDraws[i]);
}
```

### Inventory System Example

```pawn
stock Inventory_Show(playerid) {
    // Show 20+ textdraws without worrying about limits
    for(new i = 0; i < 20; i++) {
        PlayerTextDrawShow(playerid, Background_TD[playerid][i]);
    }
    
    for(new i = 0; i < MAX_INVENTORY; i++) {
        if(InventoryData[playerid][i][invExists]) {
            PlayerTextDrawShow(playerid, Object_TD[playerid][i]);
            PlayerTextDrawShow(playerid, Text_TD[playerid][i]);
            PlayerTextDrawShow(playerid, AmountText_TD[playerid][i]);
        }
    }
}

stock Inventory_Close(playerid) {
    // Hide all textdraws - TD-Streamer automatically frees slots
    for(new i = 0; i < 20; i++) {
        PlayerTextDrawHide(playerid, Background_TD[playerid][i]);
        PlayerTextDrawHide(playerid, Object_TD[playerid][i]);
        PlayerTextDrawHide(playerid, Text_TD[playerid][i]);
        PlayerTextDrawHide(playerid, AmountText_TD[playerid][i]);
    }
}
```

---

## Troubleshooting

### Error: "File or function is not found" (pool_valid, str_new, etc.)

**Cause:** PawnPlus plugin not loaded.

**Solution:**
1. Check `plugins/` folder for `PawnPlus.dll` or `PawnPlus.so`
2. Verify `server.cfg` has `PawnPlus` in plugins line
3. Check `server_log.txt` for PawnPlus load confirmation

### Error: "string reference is invalid"

**Cause:** Textdraws created before TD-Streamer was loaded.

**Solution:**
1. Ensure TD-Streamer is included BEFORE weapon-config
2. Recompile gamemode
3. Restart server

### Textdraws Not Showing

**Cause:** Weapon-config hooks overriding TD-Streamer.

**Solution:**
1. Verify include order (TD-Streamer before weapon-config)
2. Check that `WC_DISABLE_TD_HOOKS` is defined in weapon-config
3. Recompile and restart

### Compiler Warnings: "redefinition of constant/macro"

**Cause:** Multiple libraries hooking same functions.

**Solution:**
1. Update weapon-config with TD-Streamer compatibility checks
2. Ensure proper include order
3. Recompile

---

## Performance Considerations

### Memory Usage

**Without TD-Streamer:**
- 1000 textdraws created = 1000 slots used (even if hidden)
- Hits limit quickly with complex UIs

**With TD-Streamer:**
- 1000 textdraws created, 50 visible = 50 slots used
- Scales to thousands of textdraws

### CPU Usage

- Minimal overhead for show/hide operations
- Lazy creation is faster than pre-creating all textdraws
- Automatic cleanup reduces memory fragmentation

### Best Practices

1. **Create textdraws once** - Store handles, don't recreate
2. **Hide when not needed** - Frees slots automatically
3. **Use PlayerTextDraws** - Per-player limits are separate
4. **Batch operations** - Show/hide multiple textdraws together

---

## Server Configuration

### server.cfg

```ini
# Ensure PawnPlus is loaded
plugins crashdetect pawncmd PawnPlus sampvoice sscanf streamer Whirlpool SKY YSF nativechecker chrono mysql discord-connector audio-plugin

# Other settings
maxplayers 50
port 7777
```

### Gamemode Includes

```pawn
#pragma warning disable 235

// Core (in order)
#include <a_samp>
#include <PawnPlus>
#include <td-streamer>        // BEFORE weapon-config
#include <a_actor>
#include <a_players>

// Debug
#include <crashdetect>

// Utility
#include <sscanf2>
#include <Pawn.CMD>

// Gameplay (weapon-config AFTER td-streamer)
#include <weapon-config>
#include <physics>
```

---

## Summary

✅ **TD-Streamer removes textdraw limits**
✅ **Requires PawnPlus plugin**
✅ **Must be included BEFORE weapon-config**
✅ **Automatic memory management**
✅ **Same API, no code changes needed**
✅ **Compatible with weapon-config (with modifications)**

**Result:** Unlimited textdraws with automatic slot management and zero code changes! 🚀

---

## References

- TD-Streamer: https://github.com/kristoisberg/samp-td-streamer
- PawnPlus: https://github.com/IllidanS4/PawnPlus
- SA-MP Wiki: https://www.open.mp/docs/scripting/functions/TextDrawCreate

---

**Last Updated:** 2024
**Status:** ✅ Working and Production Ready
