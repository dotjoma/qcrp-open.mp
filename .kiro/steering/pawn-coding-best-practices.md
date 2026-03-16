---
inclusion: auto
description: PAWN coding best practices - variable naming conventions, reference parameters, and avoiding enum field name conflicts
---

# PAWN Coding Best Practices

## Variable Naming Conflicts

**CRITICAL**: Avoid using the same variable names as enum field names when passing variables by reference.

### Problem Example:
```pawn
enum E_FISHING_ROD {
    rodID,
    rodName[64],
    rodBiteSpeedBonus,
    rodComboBonus
}

stock GetRodData(rod_id, &biteBonus, &rareBonus, &comboBonus) {
    // Function implementation
}

// ❌ BAD - Variable name matches enum field name
public SomeFunction(playerid) {
    new rodBiteBonus, rodRareBonus, rodComboBonus;  // rodComboBonus conflicts!
    GetRodData(id, rodBiteBonus, rodRareBonus, rodComboBonus);
    // Error: argument type mismatch (argument 4)
}
```

### Solution:
```pawn
// ✅ GOOD - Use different variable names
public SomeFunction(playerid) {
    new rod_bite, rod_rare, rod_combo;  // Different names, no conflict
    GetRodData(id, rod_bite, rod_rare, rod_combo);
    // Works perfectly!
}
```

### Why This Happens:
- PAWN compiler can confuse local variable names with enum field names
- This especially happens with reference parameters (`&parameter`)
- Results in "argument type mismatch" errors

### Best Practice:
- Use underscores or different naming conventions for local variables
- Keep enum field names descriptive (e.g., `rodComboBonus`)
- Use shorter local variable names (e.g., `rod_combo`, `combo_bonus`)

## Reference Parameters

When declaring variables that will be passed as reference parameters:

```pawn
// ❌ BAD - Don't initialize in declaration
new rodBiteBonus = 0, rodRareBonus = 0;
GetRodData(id, rodBiteBonus, rodRareBonus, comboBonus);

// ✅ GOOD - Declare without initialization
new rod_bite, rod_rare, rod_combo;
GetRodData(id, rod_bite, rod_rare, rod_combo);
```

## Summary
- Avoid variable name conflicts with enum fields
- Don't initialize variables meant for reference parameters
- Use clear, distinct naming conventions
