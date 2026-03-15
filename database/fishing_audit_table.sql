-- Fishing Audit Log Table
-- Tracks all fishing-related transactions and events

CREATE TABLE IF NOT EXISTS fishing_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    user_id INT NOT NULL,
    username VARCHAR(24) NOT NULL,
    action_type ENUM('LEVEL_UP', 'BUY_ROD', 'BUY_BAIT', 'SELL_FISH', 'CATCH_FISH') NOT NULL,
    
    -- Transaction details
    item_name VARCHAR(64) DEFAULT NULL,
    item_id INT DEFAULT NULL,
    quantity INT DEFAULT 0,
    amount INT DEFAULT 0,  -- Money or tokens involved
    
    -- Player state at time of action
    player_level INT DEFAULT 1,
    player_exp INT DEFAULT 0,
    player_tokens INT DEFAULT 0,
    
    -- Additional context
    details TEXT DEFAULT NULL,
    
    -- Timestamp
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_player_id (player_id),
    INDEX idx_user_id (user_id),
    INDEX idx_action_type (action_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
