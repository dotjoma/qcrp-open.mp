-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 12, 2026 at 05:57 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gtasamp_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `custom_skins`
--

CREATE TABLE `custom_skins` (
  `id` int(11) NOT NULL,
  `skin_id` int(11) NOT NULL COMMENT 'Custom skin ID (20001-30000 for open.mp)',
  `skin_name` varchar(64) NOT NULL COMMENT 'Display name of the skin',
  `model_file` varchar(128) NOT NULL COMMENT 'DFF model filename',
  `texture_file` varchar(128) NOT NULL COMMENT 'TXD texture filename',
  `base_skin_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Fallback skin ID for clients without mod (0-311)',
  `requires_vip` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'VIP only skin?',
  `min_level` int(11) NOT NULL DEFAULT 0 COMMENT 'Minimum level required',
  `cost` int(11) NOT NULL DEFAULT 0 COMMENT 'Purchase cost (0 = free)',
  `download_url` varchar(255) DEFAULT NULL COMMENT 'Direct download URL for launcher',
  `file_size` int(11) DEFAULT 0 COMMENT 'Total file size in bytes',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `custom_skins`
--
-- NOTE: open.mp requires skin IDs between 20001-30000 for custom character models
-- Changed from 1000+ to 20001+ to comply with open.mp AddCharModel requirements
--

INSERT INTO `custom_skins` (`id`, `skin_id`, `skin_name`, `model_file`, `texture_file`, `base_skin_id`, `requires_vip`, `min_level`, `cost`, `download_url`, `file_size`, `created_at`, `updated_at`) VALUES
(1, 20001, 'Board Crasher', 'board_crasher.dff', 'board_crasher.txd', 0, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-12 08:13:15'),
(2, 20002, 'Mikoto Mikasa School', 'Mikoto_School.dff', 'Mikoto_School.txd', 12, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-12 08:13:15'),
(3, 20003, 'Mikoto Mikasa Swimsuit', 'Mikoto_Swimsuit.dff', 'Mikoto_Swimsuit.txd', 12, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-12 08:13:15'),
(4, 20004, 'Mikoto Mikasa Pajamas', 'Mikoto_Pajamas.dff', 'Mikoto_Pajamas.txd', 12, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-12 08:13:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `custom_skins`
--
ALTER TABLE `custom_skins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `skin_id` (`skin_id`),
  ADD KEY `requires_vip` (`requires_vip`),
  ADD KEY `min_level` (`min_level`),
  ADD KEY `idx_custom_skins_cost` (`cost`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `custom_skins`
--
ALTER TABLE `custom_skins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
