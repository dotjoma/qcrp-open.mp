# 🎣 RPG Fishing System - Complete Design Document

## Table of Contents
1. Database Schema
2. System Architecture
3. Data Structures
4. Core Mechanics
5. Implementation Guide

---

## 1. DATABASE SCHEMA

### Players Table Additions
```sql
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
```

### New Tables

```sql
-- Fishing Rods Table
CREATE TABLE `fishing_rods` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `bite_speed_bonus` INT(10) DEFAULT 0,
  `rare_chance_bonus` INT(10) DEFAULT 0,
  `combo_bonus` INT(10) DEFAULT 0,
  `token_price` INT(10) DEFAULT 0,
  `required_level` INT(10) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fishing Bait Table
CREATE TABLE `fishing_bait` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `bite_speed_bonus` INT(10) DEFAULT 0,
  `rare_chance_bonus` INT(10) DEFAULT 0,
  `token_price` INT(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fishing Zones Table
CREATE TABLE `fishing_zones` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `min_x` FLOAT NOT NULL,
  `min_y` FLOAT NOT NULL,
  `max_x` FLOAT NOT NULL,
  `max_y` FLOAT NOT NULL,
  `turf_id` INT(10) DEFAULT 0,
  `time_bonus_type` VARCHAR(32) DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fish Species Table
CREATE TABLE `fishing_species` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `rarity` ENUM('common','uncommon','rare','legendary') DEFAULT 'common',
  `min_weight` FLOAT DEFAULT 1.0,
  `max_weight` FLOAT DEFAULT 5.0,
  `base_value` INT(10) DEFAULT 50,
  `exp_reward` INT(10) DEFAULT 10,
  `zone_id` INT(10) DEFAULT 0,
  `time_restriction` VARCHAR(32) DEFAULT 'any'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Fishing Leaderboard Table
CREATE TABLE `fishing_leaderboard` (
  `player_id` INT(10) PRIMARY KEY,
  `player_name` VARCHAR(24) NOT NULL,
  `total_caught` INT(10) DEFAULT 0,
  `biggest_weight` FLOAT DEFAULT 0.0,
  `legendary_count` INT(10) DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fishing Daily Quests Table
CREATE TABLE `fishing_daily_quests` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `quest_type` ENUM('catch_amount','catch_rarity','catch_weight') NOT NULL,
  `target_amount` INT(10) DEFAULT 5,
  `target_rarity` VARCHAR(32) DEFAULT 'any',
  `target_weight` FLOAT DEFAULT 0.0,
  `token_reward` INT(10) DEFAULT 10,
  `description` VARCHAR(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fishing Tournament Table
CREATE TABLE `fishing_tournament` (
  `id` INT(10) PRIMARY KEY AUTO_INCREMENT,
  `is_active` TINYINT(1) DEFAULT 0,
  `start_time` INT(10) DEFAULT 0,
  `end_time` INT(10) DEFAULT 0,
  `tournament_type` ENUM('biggest','most','rarest') DEFAULT 'biggest',
  `winner_id` INT(10) DEFAULT 0,
  `winner_name` VARCHAR(24) DEFAULT 'None',
  `winner_score` FLOAT DEFAULT 0.0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 2. SYSTEM ARCHITECTURE

### Module Structure
```
Fishing System
├── Core Module (fishing_core.inc)
│   ├── Player data management
│   ├── Database operations
│   └── Initialization
├── Equipment Module (fishing_equipment.inc)
│   ├── Rod system
│   └── Bait system
├── Catch Module (fishing_catch.inc)
│   ├── Fish generation
│   ├── Rarity calculation
│   └── Weight system
├── Zone Module (fishing_zones.inc)
│   ├── Zone detection
│   └── Turf integration
├── Quest Module (fishing_quests.inc)
│   ├── Daily quest system
│   └── Progress tracking
├── Tournament Module (fishing_tournament.inc)
│   ├── Event management
│   └── Leaderboard
└── Economy Module (fishing_economy.inc)
    ├── Token system
    └── Fish selling
```
