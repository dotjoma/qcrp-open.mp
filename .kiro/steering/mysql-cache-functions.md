---
inclusion: auto
fileMatchPattern: '**/*.pwn'
description: MySQL cache function syntax reference for PAWN - correct usage of cache_get_row_count, cache_get_field_content_int, and related functions
---

# MySQL Cache Functions - Correct Syntax

This project uses MySQL plugin R39-6 or similar version. When working with MySQL cache functions in PAWN, use the correct syntax:

## Common MySQL Cache Functions

### Getting Row Count
```pawn
// CORRECT
new rows = cache_get_row_count(connectionID);

// WRONG - Don't use this
new rows;
cache_get_row_count(rows);
```

### Getting Integer Values
```pawn
// CORRECT - No connectionID parameter at the end
new value = cache_get_field_content_int(row, "column_name");

// WRONG - Don't add connectionID at the end
new value = cache_get_field_content_int(row, "column_name", connectionID);
```

### Getting Float Values
```pawn
// CORRECT
new Float:value = cache_get_field_content_float(row, "column_name");

// WRONG
new Float:value = cache_get_field_content_float(row, "column_name", connectionID);
```

### Getting String Values
```pawn
// CORRECT - connectionID is used here for strings
new string[64];
cache_get_field_content(row, "column_name", string, connectionID, sizeof(string));
```

## Quick Reference

| Function | Correct Syntax |
|----------|---------------|
| Row count | `cache_get_row_count(connectionID)` |
| Integer | `cache_get_field_content_int(row, "field")` |
| Float | `cache_get_field_content_float(row, "field")` |
| String | `cache_get_field_content(row, "field", dest, connectionID, size)` |

## Common Mistakes to Avoid

1. Adding `connectionID` parameter to `cache_get_field_content_int()` - this causes "undefined symbol" errors
2. Using `cache_get_row_count(rows)` instead of assigning the return value directly
3. Forgetting that string functions DO need the connectionID parameter

## Example Usage

```pawn
forward OnLoadPlayerData(playerid);
public OnLoadPlayerData(playerid)
{
    new rows = cache_get_row_count(connectionID);
    
    if(rows > 0)
    {
        // Load integers and floats - no connectionID
        new id = cache_get_field_content_int(0, "id");
        new level = cache_get_field_content_int(0, "level");
        new Float:health = cache_get_field_content_float(0, "health");
        
        // Load strings - needs connectionID
        new username[24];
        cache_get_field_content(0, "username", username, connectionID, 24);
        
        printf("Loaded: %s (ID: %d, Level: %d, Health: %.1f)", 
            username, id, level, health);
    }
}
```

When you encounter MySQL-related compilation errors, always check if you're using the correct cache function syntax as shown above.
