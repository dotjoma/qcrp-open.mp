# Fishing Audit System

Centralized audit logging for all fishing-related transactions and events.

## Setup

1. Run the SQL file to create the audit table:
```sql
SOURCE fishing_audit_table.sql;
```

## Tracked Events

The system logs the following actions:

### LEVEL_UP
- Triggered when player reaches a new fishing level
- Logs: New level, tokens earned

### BUY_ROD
- Triggered when player purchases a fishing rod
- Logs: Rod name, rod ID, price paid

### BUY_BAIT
- Triggered when player purchases bait
- Logs: Bait name, bait ID, quantity (10), price paid

### SELL_FISH
- Triggered when player sells fish inventory
- Logs: Number of fish sold, total money earned

### CATCH_FISH (Future)
- Can be added to track individual fish catches
- Would log: Fish species, weight, rarity

## Table Structure

```sql
fishing_audit (
    id              - Auto-increment primary key
    player_id       - Player's database ID
    user_id         - Player's user ID
    username        - Player's name at time of action
    action_type     - Type of action (ENUM)
    item_name       - Name of item involved
    item_id         - ID of item involved
    quantity        - Quantity of items
    amount          - Money/tokens involved
    player_level    - Player's fishing level at time
    player_exp      - Player's fishing exp at time
    player_tokens   - Player's fishing tokens at time
    details         - Additional context (TEXT)
    created_at      - Timestamp of action
)
```

## Query Examples

### View all transactions for a player
```sql
SELECT * FROM fishing_audit 
WHERE user_id = 1 
ORDER BY created_at DESC;
```

### View all purchases today
```sql
SELECT * FROM fishing_audit 
WHERE action_type IN ('BUY_ROD', 'BUY_BAIT') 
AND DATE(created_at) = CURDATE();
```

### Total money spent by player
```sql
SELECT username, SUM(amount) as total_spent 
FROM fishing_audit 
WHERE user_id = 1 
AND action_type IN ('BUY_ROD', 'BUY_BAIT')
GROUP BY username;
```

### Total money earned from selling fish
```sql
SELECT username, SUM(amount) as total_earned 
FROM fishing_audit 
WHERE user_id = 1 
AND action_type = 'SELL_FISH'
GROUP BY username;
```

### Level progression history
```sql
SELECT created_at, details 
FROM fishing_audit 
WHERE user_id = 1 
AND action_type = 'LEVEL_UP'
ORDER BY created_at ASC;
```

## Benefits

1. **Audit Trail** - Complete history of all fishing transactions
2. **Anti-Cheat** - Detect suspicious patterns or exploits
3. **Analytics** - Track economy balance and player progression
4. **Support** - Help players with transaction disputes
5. **Debugging** - Identify issues with fishing system

## Console Logging

All audit entries also print to server console:
```
[FISHING AUDIT] PlayerName (ID: 5) | Action: BUY_ROD | Item: Advanced Rod | Qty: 1 | Amount: $5000
```
