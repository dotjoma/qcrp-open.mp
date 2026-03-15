-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 15, 2026 at 07:12 AM
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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateFishingPlayer` (IN `p_user_id` INT, IN `p_username` VARCHAR(24))   BEGIN
    -- Check if player already exists
    IF NOT EXISTS (SELECT 1 FROM players WHERE user_id = p_user_id) THEN
        INSERT INTO players (user_id, username)
        VALUES (p_user_id, p_username);
        
        SELECT CONCAT('Created fishing player for: ', p_username) as Result;
    ELSE
        SELECT CONCAT('Fishing player already exists for: ', p_username) as Result;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `actors`
--

CREATE TABLE `actors` (
  `id` int(10) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `actorskin` smallint(5) DEFAULT 2,
  `actoranim` smallint(5) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `actors`
--

INSERT INTO `actors` (`id`, `name`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `world`, `actorskin`, `actoranim`) VALUES
(409, 'mechanic', 320.138, -1862.74, 7.657, 285.193, 0, 171, 0);

-- --------------------------------------------------------

--
-- Table structure for table `anticheat_settings`
--

CREATE TABLE `anticheat_settings` (
  `ac_code` int(2) NOT NULL,
  `ac_code_trigger_type` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `anticheat_settings`
--

INSERT INTO `anticheat_settings` (`ac_code`, `ac_code_trigger_type`) VALUES
(0, 2),
(1, 2),
(2, 1),
(3, 2),
(4, 1),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 2),
(22, 2),
(23, 2),
(24, 2),
(25, 1),
(26, 2),
(27, 2),
(28, 2),
(29, 2),
(30, 2),
(31, 2),
(32, 2),
(33, 1),
(34, 2),
(35, 2),
(36, 2),
(37, 0),
(38, 1),
(39, 0),
(40, 0),
(41, 0),
(42, 2),
(43, 2),
(44, 0),
(45, 2),
(46, 2),
(47, 2),
(48, 1),
(49, 1),
(50, 1),
(51, 2),
(52, 1);

-- --------------------------------------------------------

--
-- Table structure for table `arrest`
--

CREATE TABLE `arrest` (
  `id` int(10) NOT NULL,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `arrest`
--

INSERT INTO `arrest` (`id`, `pos_x`, `pos_y`, `pos_z`, `interior`, `world`) VALUES
(296, 1525.06, -1677.69, 5.891, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `atm`
--

CREATE TABLE `atm` (
  `atmID` int(12) NOT NULL,
  `atmmodel` int(12) DEFAULT 980,
  `atmx` float DEFAULT 0,
  `atmy` float DEFAULT 0,
  `atmz` float DEFAULT 0,
  `atmrx` float DEFAULT 0,
  `atmry` float DEFAULT 0,
  `atmrz` float DEFAULT 0,
  `atminterior` int(12) DEFAULT 0,
  `atmworld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auctions`
--

CREATE TABLE `auctions` (
  `id` int(11) NOT NULL,
  `BiddingFor` varchar(64) NOT NULL DEFAULT '(none)',
  `InProgress` int(11) NOT NULL DEFAULT 0,
  `Bid` int(11) NOT NULL DEFAULT 0,
  `Bidder` int(11) NOT NULL DEFAULT 0,
  `Expires` int(11) NOT NULL DEFAULT 0,
  `Wining` varchar(24) NOT NULL DEFAULT '(none)',
  `Increment` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(10) NOT NULL,
  `username` varchar(24) DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `bannedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reason` varchar(128) DEFAULT NULL,
  `permanent` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bb_music`
--

CREATE TABLE `bb_music` (
  `boomboxid` int(11) NOT NULL,
  `playeruid` int(11) NOT NULL,
  `musicname` varchar(24) NOT NULL,
  `musicurl` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `bb_music`
--

INSERT INTO `bb_music` (`boomboxid`, `playeruid`, `musicname`, `musicurl`) VALUES
(269, 7221, 'Until I Found You', 'http://b.top4top.io/m_2658zgroa0.mp3'),
(270, 7221, 'Atlantis', 'http://b.top4top.io/m_2658fbrsv0.mp3'),
(271, 7221, 'Uhaw', 'http://e.top4top.io/m_26586jgdf0.mp3'),
(272, 7221, 'Bmw', 'http://e.top4top.io/m_2626na7um1.mp3'),
(273, 7221, 'Elavate', 'http://l.top4top.io/m_26225xgsc0.mp3'),
(274, 7221, 'Umaasa. ', 'http://k.top4top.io/m_2655l8l2t0.mp3'),
(275, 7221, 'Bawat Piyesa', 'http://b.top4top.io/m_2658fd1pc0.mp3'),
(276, 7221, 'Pasilyo', 'http://l.top4top.io/m_2594tb1y31.mp3'),
(277, 7224, 'Sanctuary', 'http://e.top4top.io/m_2658kzlhe0.mp3'),
(278, 7224, 'Dungaw', 'http://e.top4top.io/m_265824lp90.mp3'),
(279, 7224, 'Araw-araw', 'http://h.top4top.io/m_2658o7oqw0.mp3'),
(280, 7224, 'Bawat Piyesa', 'http://b.top4top.io/m_2658fd1pc0.mp3'),
(281, 7224, 'Unang Sayaw', 'http://i.top4top.io/m_2658qpt5q0.mp3'),
(282, 7224, 'Need You More Today ', 'http://l.top4top.io/m_2658e2r8r0.mp3'),
(283, 7224, 'Pink Skies', 'http://h.top4top.io/m_26581qfkd0.mp3'),
(284, 7224, 'Dear ', 'http://d.top4top.io/m_26587djz70.mp3'),
(285, 7224, 'The ones we once loved', 'http://e.top4top.io/m_26589ehgh0.mp3'),
(286, 7224, 'Dulo', 'http://i.top4top.io/m_2658f1h7b0.mp3'),
(287, 7224, 'Eroplanong papel ', 'http://h.top4top.io/m_2658d9foh0.mp3'),
(288, 7224, 'Fallen ', 'http://j.top4top.io/m_2626yteed0.mp3'),
(289, 7224, '13 - Lany', 'http://l.top4top.io/m_2626fprq51.mp3'),
(290, 7224, 'Double Take', 'http://k.top4top.io/m_263378d6f1.mp3'),
(291, 7224, 'Those eyes', 'http://h.top4top.io/m_2655mtprm0.mp3'),
(292, 7224, 'Musika', 'http://e.top4top.io/m_26557vzzz0.mp3'),
(293, 7224, 'Hatid', 'http://i.top4top.io/m_2655lrv6e0.mp3'),
(294, 7224, 'Umaasa', 'http://k.top4top.io/m_2655l8l2t0.mp3'),
(295, 7224, 'Pasilyo', 'http://l.top4top.io/m_2594tb1y31.mp3'),
(296, 7242, 'https://youtu.be/gt-v_Y', 'https://youtu.be/gt-v_YCkaMY'),
(297, 7253, 'http://d.top4top.io/m_2', 'http://d.top4top.io/m_26333ez850.mp3'),
(298, 7224, 'Kiyo', 'http://b.top4top.io/m_26260zm1j2.mp3'),
(300, 7461, 'Rainbow ', 'http://k.top4top.io/m_2686m4cx30.mp3'),
(301, 7461, 'Napagod na', 'http://f.top4top.io/m_2686mbdot2.mp3'),
(302, 7461, 'Pasilyo', 'http://j.top4top.io/m_2685l10930.mp3'),
(303, 7461, 'Uhaw Dilaw', 'http://k.top4top.io/m_2685ha1hs1.mp3'),
(306, 7461, 'Cupid', 'http://j.top4top.io/m_2680pon0q1.mp3'),
(307, 7461, 'Bahala na bukas', 'http://b.top4top.io/m_2618bgrqc0.mp3'),
(308, 7461, 'DAB', 'http://j.top4top.io/m_2618gc8j10.mp3'),
(309, 7461, 'Jollibee ', 'http://i.top4top.io/m_2618lqf400.mp3'),
(311, 7461, 'Lagi nalang', 'http://f.top4top.io/m_2618n55xa3.mp3'),
(313, 7473, 'Uhaw', 'http://e.top4top.io/m_26586jgdf0.mp3'),
(314, 7473, 'Demonyo', 'http://j.top4top.io/m_2658wjglp0.mp3'),
(315, 7473, 'Rapstar', 'http://h.top4top.io/m_26559ydxx0.mp3'),
(316, 7473, 'Musika', 'http://e.top4top.io/m_26557vzzz0.mp3'),
(317, 7473, 'Dulo', 'http://i.top4top.io/m_2658f1h7b0.mp3'),
(318, 7473, 'Lumang Harana', 'http://i.top4top.io/m_2687936hx0.mp3'),
(319, 7473, 'Best Part', 'http://e.top4top.io/m_2687hdrjb0.mp3'),
(320, 7473, 'Elevate', 'http://l.top4top.io/m_26225xgsc0.mp3'),
(321, 7473, 'One day', 'http://k.top4top.io/m_26267dgzh0.mp3'),
(322, 7473, 'BMW', 'http://e.top4top.io/m_2626na7um1.mp3'),
(323, 7473, 'demdayz', 'http://e.top4top.io/m_2698a7csa0.mp3'),
(324, 7473, '69', 'http://b.top4top.io/m_2698a1do40.mp3'),
(325, 7473, 'Black mafia', 'http://e.top4top.io/m_2688kkd1s0.mp3'),
(326, 7427, 'Tuss Brother ', 'http://l.top4top.io/m_2687qorzf1.mp3'),
(327, 7427, 'Careless whisper ', 'http://l.top4top.io/m_2701eejja1.mp3'),
(328, 7427, 'Crashing Oside Mafia', 'http://h.top4top.io/m_2697e3a040.mp3'),
(329, 7427, 'Upuan Glock 9', 'http://f.top4top.io/m_2701qeskb2.mp3'),
(330, 7427, 'Money Trees', 'http://j.top4top.io/m_2701xh4ey1.mp3'),
(331, 7479, 'mew', 'http://f.top4top.oi/m_2701qeskb2.mp3'),
(333, 7481, 'h', 'h'),
(335, 7473, 'Kalmado', 'http://b.top4top.io/m_2698a1do40.mp3'),
(348, 7493, 'crashing-osm', 'http://h.top4top.io/m_2697e3a040.mp3'),
(349, 7493, 'Dont play with us', 'http://g.top4top.io/m_2618zinz10.mp3'),
(350, 7493, '20 deep', 'http://j.top4top.io/m_2618v35sl3.mp3'),
(351, 7493, 'Go ghetta', 'http://k.top4top.io/m_2618r75na4.mp3'),
(352, 7493, 'quicksand', 'http://i.top4top.io/m_2626bjumy1.mp3'),
(353, 7493, 'Redboys', 'https://j.top4top.io/m_2624c7fhd0.mp3'),
(354, 7493, 'Sex sounds', 'http://l.top4top.io/m_26265d8m01.mp3'),
(355, 7493, 'all girl are the same', 'http://e.top4top.io/m_2626tgcig0.mp3'),
(356, 7493, 'limbo', 'http://d.top4top.io/m_2633jw5qb6.mp3'),
(357, 7493, 'marlboro black', 'http://h.top4top.io/m_2633p9jc11.mp3'),
(359, 7493, 'hit dif x good days', 'http://b.top4top.io/m_26802lgjv2.mp3'),
(360, 7493, 'move on', 'http://i.top4top.io/m_2636xqlmg5.mp3'),
(362, 7493, 'follow my lead', 'http://j.top4top.io/m_26265ygsw0.mp3'),
(363, 7493, 'elevate', 'http://l.top4top.io/m_26225xgsc0.mp3'),
(364, 7493, 'young wild', 'http://l.top4top.io/m_2626n871e0.mp3'),
(365, 7493, 'ano na', 'http://b.top4top.io/m_26260zm1j2.mp3'),
(366, 7493, 'Mood', 'http://b.top4top.io/m_2626z7f113.mp3'),
(367, 7493, 'Japanese denim', 'http://j.top4top.io/m_2678svc4y4.mp3'),
(368, 7493, 'Ballin', 'http://k.top4top.io/m_2685sd9i40.mp3'),
(369, 7493, 'Reminder', 'http://l.top4top.io/m_2685umhke0.mp3'),
(370, 7493, 'Snooze', 'http://l.top4top.io/m_2685umhke0.mp3'),
(371, 7475, 'uhaw', 'http://e.top4top.io/m_26586jgdf0.mp3'),
(372, 7461, 'Crashing', 'http://h.top4top.io/m_2697e3a040.mp3'),
(373, 7461, 'Paa sa lupa', 'http://h.top4top.io/m_2702thpg20.mp3'),
(374, 7461, 'We belong together ', 'http://k.top4top.io/m_2680f6uh40.mp3'),
(375, 7461, 'Angel like you', 'http://l.top4top.io/m_2686xdrgi1.mp3'),
(377, 7461, 'Paraluman', 'http://k.top4top.io/m_2680ywj1n4.mp3'),
(378, 7461, 'Wicked Games', 'http://b.top4top.io/m_2636p5y3b4.mp3'),
(379, 7461, 'Starboy', 'http://l.top4top.io/m_26360ph5n3.mp3'),
(380, 7461, 'Love don\'t change ', 'http://j.top4top.io/m_26361jrvw4.mp3'),
(381, 7461, 'So-Sick', 'http://h.top4top.io/m_2636a5m042.mp3'),
(382, 7461, 'Goodbyes', 'http://l.top4top.io/m_2636l8zyf8.mp3'),
(383, 7461, 'Move on', 'http://i.top4top.io/m_2636xqlmg5.mp3'),
(384, 7461, 'I.F.L.Y', 'http://h.top4top.io/m_263635ljv4.mp3'),
(385, 7461, 'Love', 'http://e.top4top.io/m_2636hxnxi2.mp3'),
(386, 7461, 'Jopay', 'http://d.top4top.io/m_26333ez850.mp3'),
(387, 7461, 'Esmi', 'http://b.top4top.io/m_263334nh12.mp3'),
(388, 7461, 'Beer', 'http://l.top4top.io/m_2633y2kj00.mp3'),
(389, 7461, 'Wake up in the Sky', 'http://h.top4top.io/m_26339dmao1.mp3'),
(390, 7461, 'It\'s you', 'http://e.top4top.io/m_2633zasj17.mp3'),
(391, 7461, 'BMW', 'http://e.top4top.io/m_2626na7um1.mp3'),
(392, 7461, 'Ano na', 'http://b.top4top.io/m_26260zm1j2.mp3'),
(393, 7461, 'Sexy sound', 'http://l.top4top.io/m_26265d8m01.mp3'),
(396, 7461, 'Habulab', 'http://l.top4top.io/m_2626ceaa32.mp3'),
(397, 7461, 'it\'s you', 'http://b.top4top.io/m_262678jpf3.mp3'),
(398, 7461, 'Tricks ', 'http://l.top4top.io/m_2626hsyx91.mp3'),
(399, 7461, 'One day', 'http://k.top4top.io/m_26267dgzh0.mp3'),
(400, 7461, 'Elevate', 'http://l.top4top.io/m_26225xgsc0.mp3'),
(401, 7461, 'The way lige goes ', 'http://d.top4top.io/m_26260783x4.mp3'),
(402, 7461, 'Eh papaano', 'http://k.top4top.io/m_2626hs5gy0.mp3'),
(403, 7461, 'G.O.A.T', 'http://h.top4top.io/m_2626n7k3a0.mp3'),
(404, 7461, 'Hale', 'http://b.top4top.io/m_2626egsq02.mp3'),
(405, 7461, 'Go Ghetta', 'http://k.top4top.io/m_2618r75na4.mp3'),
(406, 7461, '20Deep', 'http://j.top4top.io/m_2618v35sl3.mp3'),
(408, 7461, 'Big boy', 'http://b.top4top.io/m_26184ssip0.mp3'),
(409, 7461, 'Normal girl', 'http://l.top4top.io/m_261872b3i5.mp3'),
(415, 7508, 'http://stream.zeno.fm/8', 'http://stream.zeno.fm/8vkvanqxw5qvv	'),
(416, 7473, 'Crashing', 'http://h.top4top.io/m_2697e3a040.mp3'),
(417, 7473, 'Upuan', 'http://f.top4top.io/m_2701qeskb2.mp3'),
(418, 7473, 'Tuss Brother', 'http://l.top4top.io/m_2687qorzf1.mp3'),
(419, 7473, 'Beer', 'http://l.top4top.io/m_2633y2kj00.mp3'),
(420, 7475, 'gang gang', 'http://e.top4top.io/m_2688kkd1s0.mp3'),
(431, 7520, 'Its you', 'http://b.top4top.io/m_262678jpf3.mp3'),
(432, 7520, 'starboy', 'http://l.top4top.io/m_26360ph5n3.mp3'),
(434, 7493, 'Take it easy', 'http://a.top4top.io/m_2698feph50.mp3'),
(435, 7493, 'BAT NGAYON ', 'http://b.top4top.io/m_2626nyoz72.mp3'),
(436, 7493, 'Rapstar', 'http://h.top4top.io/m_26559ydxx0.mp3'),
(437, 7493, 'Death bed', 'http://j.top4top.io/m_2633grm1m0.mp3'),
(438, 7493, 'Esmi', 'http://b.top4top.io/m_263334nh12.mp3'),
(439, 7493, 'G.O.A.T', 'http://h.top4top.io/m_2626n7k3a0.mp3'),
(440, 7493, 'After last night', 'http://l.top4top.io/m_2626hfqji4.mp3'),
(441, 7493, 'Save your tears', 'http://e.top4top.io/m_2687udzde0.mp3'),
(442, 7493, 'BNK', 'http://h.top4top.io/m_2695ttryh0.mp3'),
(443, 7493, 'TU$$', 'http://l.top4top.io/m_2687qorzf1.mp3'),
(444, 7493, 'YNW', 'http://k.top4top.io/m_2695wi2uj0.mp3'),
(445, 7493, 'Money trees', 'http://j.top4top.io/m_2701xh4ey1.mp3'),
(446, 7493, 'Wake up in the sky ', 'http://h.top4top.io/m_26339dmao1.mp3'),
(450, 7520, 'Death bed', 'http://j.top4top.io/m_2633grm1m0.mp3'),
(451, 7520, 'The weekend', 'http://l.top4top.io/m_2685umhke0.mp3'),
(452, 7520, 'Mockingbird ', 'http://i.top4top.io/m_2658gk7hm0.mp3'),
(453, 7520, 'Mood', 'http://b.top4top.io/m_2626z7f113.mp3'),
(454, 7520, 'Subtance', 'http://d.top4top.io/m_2636j9jc91.mp3'),
(456, 7461, 'szs1', 'http://c.top4top.io/m_2684a599d0.mp3'),
(466, 7422, 'TUSS', 'http://l.top4top.io/m_2687qorzf1.mp3'),
(467, 7422, 'Malboro Black', 'http://h.top4top.io/m_2633p9jc11.mp3'),
(468, 7422, 'GOODSH*T', 'http://b.top4top.io/m_2698a1do40.mp3'),
(469, 7422, 'KALMADO', 'http://k.top4top.io/m_2698f7ekh0.mp3'),
(470, 7422, 'Take it easy', 'http://a.top4top.io/m_2698feph50.mp3'),
(471, 7422, 'Black Mafia', 'http://e.top4top.io/m_2688kkd1s0.mp3'),
(472, 7520, 'Wanna be yours', 'http://i.top4top.io/m_2718fs8r00.mp3'),
(473, 7520, 'Sunflower ', 'http://i.top4top.io/m_2718p0o4p0.mp3'),
(474, 7520, 'cutie', 'http://b.top4top.io/m_2716lcp6b0.mp3'),
(475, 7520, 'treasure', 'http://f.top4top.io/m_2716ntay40.mp3'),
(476, 7520, 'billie jean', 'http://f.top4top.io/m_2716dvdg40.mp3'),
(477, 7520, 'binibini', 'http://c.top4top.io/m_2699df9oe0.mp3'),
(478, 7520, 'seat', 'http://l.top4top.io/m_2699t1umc1.mp3'),
(479, 7520, 'collide', 'http://h.top4top.io/m_2612ke37y7.mp3'),
(480, 7536, 'Oside Mafia', 'http://b.top4top.io/m_2716e0x9s0.mp3'),
(483, 7536, 'Crashing By Oside.', 'http://h.top4top.io/m_2697e3a040.mp3'),
(484, 7536, 'Troll', 'http://h.top4top.io/m_26975rxhv0.mp3'),
(485, 7536, '24 Bars by Mark', 'http://d.top4top.io/m_2698l59su9.mp3'),
(486, 7536, 'Redboyz', 'http://i.top4top.io/m_2695mqsqy9.mp3'),
(488, 7547, 'drugs in the club by os', 'drugs in the club by oside mafia'),
(489, 7536, 'Money Trees.', 'http://j.top4top.io/m_2701xh4ey1.mp3'),
(491, 7536, 'Ama namin', 'http://g.top4top.io/m_2697sva1bO.mp3'),
(492, 7551, 'gustl', 'http://c.top4top.io/m_27158634t0.mp3'),
(493, 7551, 'gusto', 'http://l.top4top.io/m_2719b0voe0.mp3'),
(494, 7551, 'mnm', 'http://k.top4top.io/m_2719bmx9f0.mp3'),
(495, 7551, 'mpl', 'http://i.top4top.io/m_2719xk6i10.mp3'),
(496, 7536, 'Gta San Andreas', 'http://d.top4top.io/m_2719159t20.mp3'),
(497, 7534, 'bullet', 'muli'),
(500, 7472, 'I WANNA BE YOURS', 'https://www.deezer.com/track/70322142)'),
(501, 7551, 'call out my name', 'http://h.top4top.io/m_2720a8od30.mp3'),
(502, 7551, 'after hours', 'http://l.top4top.io/m_2720mc00s0.mp3'),
(503, 7419, 'https://a.wejfknwejfker', 'https://a.wejfknwejfkerf.org/dl.php?id=0d0dba5498014a7f098c0c2a112d21e9'),
(504, 7453, 'Ligaya', 'http://l.top4top.io/m_2698xgcd00.mp3'),
(505, 7453, 'So-Sick', 'http://h.top4top.io/m_2636a5m042.mp3'),
(506, 7453, 'i.f.l.y', 'http://h.top4top.io/m_263635ljv4.mp3'),
(508, 7509, 'https://www.youtube.com', 'https://www.youtube.com/watch?v=6ZaDjWueaoA'),
(509, 7473, 'Money tress', 'http://j.top4top.io/m_2701xh4ey1.mp3');

-- --------------------------------------------------------

--
-- Table structure for table `billboards`
--

CREATE TABLE `billboards` (
  `id` int(11) NOT NULL,
  `text` varchar(100) NOT NULL,
  `rentby` varchar(54) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'None',
  `cost` int(11) NOT NULL,
  `rentdate` int(11) NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `posRX` float NOT NULL,
  `posRY` float NOT NULL,
  `posRZ` float NOT NULL,
  `int` int(11) NOT NULL,
  `vw` int(11) NOT NULL,
  `model` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `id` int(10) NOT NULL,
  `ownerid` int(10) DEFAULT 0,
  `owner` varchar(24) DEFAULT 'Nobody',
  `name` varchar(64) DEFAULT 'Unamed Business',
  `message` varchar(128) DEFAULT 'Welcome to the business!',
  `type` tinyint(2) DEFAULT 0,
  `openint` tinyint(1) DEFAULT 0,
  `price` int(10) DEFAULT 0,
  `entryfee` int(10) DEFAULT 0,
  `locked` tinyint(1) DEFAULT 1,
  `timestamp` int(10) DEFAULT 0,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `int_x` float DEFAULT 0,
  `int_y` float DEFAULT 0,
  `int_z` float DEFAULT 0,
  `int_a` float DEFAULT 0,
  `loadpoint_x` float DEFAULT 0,
  `loadpoint_y` float DEFAULT 0,
  `loadpoint_z` float DEFAULT 0,
  `loadpointinterior` tinyint(2) DEFAULT 0,
  `loadpointworld` int(10) DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `outsideint` tinyint(2) DEFAULT 0,
  `outsidevw` int(10) DEFAULT 0,
  `cash` int(10) DEFAULT 0,
  `products` int(10) DEFAULT 500,
  `robbed` smallint(6) NOT NULL DEFAULT 3,
  `robbing` int(11) DEFAULT NULL,
  `prices0` int(11) NOT NULL DEFAULT 0,
  `prices1` int(11) NOT NULL DEFAULT 0,
  `prices2` int(11) NOT NULL DEFAULT 0,
  `prices3` int(11) NOT NULL DEFAULT 0,
  `prices4` int(11) NOT NULL DEFAULT 0,
  `prices5` int(11) NOT NULL DEFAULT 0,
  `prices6` int(11) NOT NULL DEFAULT 0,
  `prices7` int(11) NOT NULL DEFAULT 0,
  `prices8` int(11) NOT NULL DEFAULT 0,
  `prices9` int(11) NOT NULL DEFAULT 0,
  `prices10` int(11) NOT NULL DEFAULT 0,
  `prices11` int(11) NOT NULL DEFAULT 0,
  `prices12` int(11) NOT NULL DEFAULT 0,
  `prices13` int(11) NOT NULL DEFAULT 0,
  `prices14` int(11) NOT NULL DEFAULT 0,
  `prices15` int(11) NOT NULL DEFAULT 0,
  `prices16` int(11) NOT NULL DEFAULT 0,
  `prices17` int(11) NOT NULL DEFAULT 0,
  `prices18` int(11) NOT NULL DEFAULT 0,
  `prices19` int(11) NOT NULL DEFAULT 0,
  `prices20` int(11) NOT NULL DEFAULT 0,
  `prices21` int(11) NOT NULL DEFAULT 0,
  `prices22` int(11) NOT NULL DEFAULT 0,
  `prices23` int(11) NOT NULL DEFAULT 0,
  `prices24` int(11) NOT NULL DEFAULT 0,
  `Car0PosX` float NOT NULL DEFAULT 0,
  `Car0PosY` float NOT NULL DEFAULT 0,
  `Car0PosZ` float NOT NULL DEFAULT 0,
  `Car0PosAngle` float NOT NULL DEFAULT 0,
  `Car0ModelId` int(11) NOT NULL DEFAULT 0,
  `Car0Price` int(11) NOT NULL DEFAULT 0,
  `Car1PosX` float NOT NULL DEFAULT 0,
  `Car1PosY` float NOT NULL DEFAULT 0,
  `Car1PosZ` float NOT NULL DEFAULT 0,
  `Car1PosAngle` float NOT NULL DEFAULT 0,
  `Car1ModelId` int(11) NOT NULL DEFAULT 0,
  `Car1Price` int(11) NOT NULL DEFAULT 0,
  `Car2PosX` float NOT NULL DEFAULT 0,
  `Car2PosY` float NOT NULL DEFAULT 0,
  `Car2PosZ` float NOT NULL DEFAULT 0,
  `Car2PosAngle` float NOT NULL DEFAULT 0,
  `Car2ModelId` int(11) NOT NULL DEFAULT 0,
  `Car2Price` int(11) NOT NULL DEFAULT 0,
  `Car3PosX` float NOT NULL DEFAULT 0,
  `Car3PosY` float NOT NULL DEFAULT 0,
  `Car3PosZ` float NOT NULL DEFAULT 0,
  `Car3PosAngle` float NOT NULL DEFAULT 0,
  `Car3ModelId` int(11) NOT NULL DEFAULT 0,
  `Car3Price` int(11) NOT NULL DEFAULT 0,
  `Car1Stock` int(11) NOT NULL DEFAULT 0,
  `Car2Stock` int(11) NOT NULL DEFAULT 0,
  `Car3Stock` int(11) NOT NULL DEFAULT 0,
  `Car1Order` int(11) NOT NULL DEFAULT 0,
  `Car2Order` int(11) NOT NULL DEFAULT 0,
  `Car3Order` int(11) NOT NULL DEFAULT 0,
  `Car4PosX` float NOT NULL DEFAULT 0,
  `Car4PosY` float NOT NULL DEFAULT 0,
  `Car4PosZ` float NOT NULL DEFAULT 0,
  `Car4PosAngle` float NOT NULL DEFAULT 0,
  `Car4ModelId` int(11) NOT NULL DEFAULT 0,
  `Car4Price` int(11) NOT NULL DEFAULT 0,
  `Car5PosX` int(11) NOT NULL DEFAULT 0,
  `Car5PosY` float NOT NULL DEFAULT 0,
  `Car5PosZ` float NOT NULL DEFAULT 0,
  `Car5PosAngle` float NOT NULL DEFAULT 0,
  `Car5ModelId` int(11) NOT NULL DEFAULT 0,
  `Car5Price` int(11) NOT NULL DEFAULT 0,
  `Car6PosX` float NOT NULL DEFAULT 0,
  `Car6PosY` float NOT NULL DEFAULT 0,
  `Car6PosZ` float NOT NULL DEFAULT 0,
  `Car6PosAngle` float NOT NULL DEFAULT 0,
  `Car6ModelId` int(11) NOT NULL DEFAULT 0,
  `Car6Price` int(11) NOT NULL DEFAULT 0,
  `Car7PosX` float NOT NULL DEFAULT 0,
  `Car7PosY` float NOT NULL DEFAULT 0,
  `Car7PosZ` float NOT NULL DEFAULT 0,
  `Car7PosAngle` float NOT NULL DEFAULT 0,
  `Car7ModelId` int(11) NOT NULL DEFAULT 0,
  `Car7Price` int(11) NOT NULL DEFAULT 0,
  `Car8PosX` float NOT NULL DEFAULT 0,
  `Car8PosY` float NOT NULL DEFAULT 0,
  `Car8PosZ` float NOT NULL DEFAULT 0,
  `Car8PosAngle` float NOT NULL DEFAULT 0,
  `Car8ModelId` int(11) NOT NULL DEFAULT 0,
  `Car8Price` int(11) NOT NULL DEFAULT 0,
  `Car9PosX` float NOT NULL DEFAULT 0,
  `Car9PosY` float NOT NULL DEFAULT 0,
  `Car9PosZ` float NOT NULL DEFAULT 0,
  `Car9PosAngle` float NOT NULL DEFAULT 0,
  `Car9ModelId` int(11) NOT NULL DEFAULT 0,
  `Car9Price` int(11) NOT NULL DEFAULT 0,
  `PurchaseX` float NOT NULL DEFAULT 0,
  `PurchaseY` float NOT NULL DEFAULT 0,
  `PurchaseZ` float NOT NULL DEFAULT 0,
  `PurchaseAngle` float NOT NULL DEFAULT 0,
  `cVehicleX` float DEFAULT 0,
  `cVehicleY` float DEFAULT 0,
  `cVehicleZ` float DEFAULT 0,
  `cVehicleA` float DEFAULT 0,
  `actorskin` smallint(5) DEFAULT 2,
  `actorbiz_x` float DEFAULT 0,
  `actorbiz_y` float DEFAULT 0,
  `actorbiz_z` float DEFAULT 0,
  `actorbiz_a` float DEFAULT 0,
  `actorbizworld` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `businesses`
--

INSERT INTO `businesses` (`id`, `ownerid`, `owner`, `name`, `message`, `type`, `openint`, `price`, `entryfee`, `locked`, `timestamp`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `int_x`, `int_y`, `int_z`, `int_a`, `loadpoint_x`, `loadpoint_y`, `loadpoint_z`, `loadpointinterior`, `loadpointworld`, `interior`, `world`, `outsideint`, `outsidevw`, `cash`, `products`, `robbed`, `robbing`, `prices0`, `prices1`, `prices2`, `prices3`, `prices4`, `prices5`, `prices6`, `prices7`, `prices8`, `prices9`, `prices10`, `prices11`, `prices12`, `prices13`, `prices14`, `prices15`, `prices16`, `prices17`, `prices18`, `prices19`, `prices20`, `prices21`, `prices22`, `prices23`, `prices24`, `Car0PosX`, `Car0PosY`, `Car0PosZ`, `Car0PosAngle`, `Car0ModelId`, `Car0Price`, `Car1PosX`, `Car1PosY`, `Car1PosZ`, `Car1PosAngle`, `Car1ModelId`, `Car1Price`, `Car2PosX`, `Car2PosY`, `Car2PosZ`, `Car2PosAngle`, `Car2ModelId`, `Car2Price`, `Car3PosX`, `Car3PosY`, `Car3PosZ`, `Car3PosAngle`, `Car3ModelId`, `Car3Price`, `Car1Stock`, `Car2Stock`, `Car3Stock`, `Car1Order`, `Car2Order`, `Car3Order`, `Car4PosX`, `Car4PosY`, `Car4PosZ`, `Car4PosAngle`, `Car4ModelId`, `Car4Price`, `Car5PosX`, `Car5PosY`, `Car5PosZ`, `Car5PosAngle`, `Car5ModelId`, `Car5Price`, `Car6PosX`, `Car6PosY`, `Car6PosZ`, `Car6PosAngle`, `Car6ModelId`, `Car6Price`, `Car7PosX`, `Car7PosY`, `Car7PosZ`, `Car7PosAngle`, `Car7ModelId`, `Car7Price`, `Car8PosX`, `Car8PosY`, `Car8PosZ`, `Car8PosAngle`, `Car8ModelId`, `Car8Price`, `Car9PosX`, `Car9PosY`, `Car9PosZ`, `Car9PosAngle`, `Car9ModelId`, `Car9Price`, `PurchaseX`, `PurchaseY`, `PurchaseZ`, `PurchaseAngle`, `cVehicleX`, `cVehicleY`, `cVehicleZ`, `cVehicleA`, `actorskin`, `actorbiz_x`, `actorbiz_y`, `actorbiz_z`, `actorbiz_a`, `actorbizworld`) VALUES
(1, 2, 'Ven_Spark', 'Ven Dealership', '', 9, 1, 999999999, 0, 1, 1687089445, 542.516, -1298.18, 17.236, -3.215, 6.016, -31.035, 1003.55, 0, 0, 0, 0, 0, 0, 10, 3000001, 0, 0, 0, 500, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(2, 1, 'Joma_Nuron', 'Bakal Store', 'Welcome', 1, 1, 999999999, 0, 0, 1708619809, 1368.39, -1279.83, 13.547, 90.607, 316.287, -169.647, 999.601, 0, 0, 0, 0, 0, 0, 6, 3000002, 0, 0, 65952, 439, 0, NULL, 1500, 1500, 1500, 700, 1500, 1500, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(3, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} 7/11 (500 Products left). Type /buy to purchase from this business.', 0, 1, 999999999, 0, 1, 0, 1917.38, -1775.71, 13.669, -179.577, -27.438, -57.611, 1003.55, 0, 1931.81, -1782.26, 13.383, 0, 0, 6, 3000003, 0, 0, 0, 475, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1917.41, -1773.68, 13.669, 179.002, 0),
(4, 1, 'Joma_Nuron', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Clothing Line (500 Products left). Type /buy or /myskin to purchase from this business.', 2, 1, 999999999, 0, 0, 1708525872, 1095.63, -1439.94, 15.798, -95.715, 204.386, -168.459, 1000.52, 0, 0, 0, 0, 0, 0, 14, 3000004, 0, 0, 0, 500, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(5, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} 7/11 (500 Products left). Type /buy to purchase from this business.', 0, 1, 999999999, 0, 1, 0, 1158.64, -1435.73, 15.798, 161.687, -27.438, -57.611, 1003.55, 0, 0, 0, 0, 0, 0, 6, 3000005, 0, 0, 0, 498, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(6, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Electronic Shop. /buy to get electronic device.', 5, 1, 999999999, 0, 1, 0, 1102.98, -1457.66, 15.367, 74.12, 22.287, 2044.68, -32.062, 358.34, 0, 0, 0, 0, 0, 3, 3000006, 0, 0, 0, 494, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(7, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Pharmacy (500 Products left). Type /buy to purchase from this business.', 7, 1, 999999999, 0, 1, 0, 1133.38, -1370.03, 13.984, 176.505, 6.016, -31.035, 1003.55, 0, 0, 0, 0, 0, 0, 10, 3000007, 0, 0, 0, 484, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(11, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Ammunation (500 Products left). Type /buy to purchase from this business.', 1, 1, 999999999, 0, 0, 0, 1161.16, -1466.97, 15.797, 107.875, 316.287, -169.647, 999.601, 0, 0, 0, 0, 0, 0, 6, 3000011, 0, 0, 85500, 495, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 312.678, -167.764, 999.594, 359.851, 3000011),
(13, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Gym. /buy to purchase a fighting style.', 3, 1, 999999999, 0, 1, 0, 1111.89, -1370.03, 13.984, 173.909, 773.78, -78.258, 1000.66, 0, 0, 0, 0, 0, 0, 7, 3000013, 0, 0, 0, 500, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(14, 1, 'Joma_Nuron', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Resturant (500 Products left). Type /buy to purchase from this business.', 4, 1, 999999999, 0, 1, 1708705144, 1097.66, -1370.03, 13.984, -180, 363.328, -74.65, 1001.51, 315, 0, 0, 0, 0, 0, 10, 3000014, 0, 0, 0, 423, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(15, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Resturant (500 Products left). Type /buy to purchase from this business.', 4, 1, 999999999, 0, 1, 0, 1126.15, -1370.03, 13.984, 175.163, 363.328, -74.65, 1001.51, 315, 0, 0, 0, 0, 0, 10, 3000015, 0, 0, 0, 439, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(16, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} 7/11 (500 Products left). Type /buy to purchase from this business.', 0, 1, 999999999, 0, 1, 0, 1104.72, -1370.03, 13.984, 171.271, -27.438, -57.611, 1003.55, 0, 0, 0, 0, 0, 0, 6, 3000016, 0, 0, 0, 482, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(17, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Electronic Shop. /buy to get electronic device.', 5, 1, 999999999, 0, 1, 0, 1119.23, -1370.04, 13.553, 71.366, 22.287, 2044.68, -32.062, 358.34, 0, 0, 0, 0, 0, 3, 3000017, 0, 0, 0, 493, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(18, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} 7/11 (500 Products left). Type /buy to purchase from this business.', 0, 1, 999999999, 0, 1, 0, 1352.49, -1759.25, 13.508, -2.756, -27.438, -57.611, 1003.55, 0, 0, 0, 0, 0, 0, 6, 3000018, 0, 0, 0, 500, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(19, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Resturant (500 Products left). Type /buy to purchase from this business.', 4, 1, 999999999, 0, 1, 0, 1038.19, -1340.73, 13.742, -7.377, 363.328, -74.65, 1001.51, 315, 0, 0, 0, 0, 0, 10, 3000019, 0, 0, 0, 490, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(20, 1, 'Joma_Nuron', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Clothing Line (500 Products left). Type /buy or /myskin to purchase from this business.', 2, 1, 999999999, 0, 0, 1710510712, 1219.3, -1428.51, 13.383, 8.599, 204.386, -168.459, 1000.52, 0, 0, 0, 0, 0, 0, 14, 3000020, 0, 0, 0, 498, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 204.34, -157.83, 1000.52, 181.916, 3000020),
(21, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} 7/11 (500 Products left). Type /buy to purchase from this business.', 0, 0, 999999999, 0, 1, 0, 1409.42, -2712.21, 13.604, -95.794, -27.438, -57.611, 1003.55, 0, 0, 0, 0, 0, 0, 6, 3000021, 0, 0, 0, 500, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0),
(22, 0, 'Nobody', 'Unnamed Business', 'Welcome to {FFFFFF}Nobody\'s{32CD32} Club/Bar (500 Products left). Type /buy to purchase from this business.', 6, 0, 999999999, 0, 0, 0, 1638.37, -1584.19, 13.617, -176.76, 501.869, -68.005, 998.758, 179.612, 0, 0, 0, 0, 0, 11, 3000022, 0, 0, 0, 500, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `changes`
--

CREATE TABLE `changes` (
  `slot` tinyint(2) DEFAULT NULL,
  `text` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `charges`
--

CREATE TABLE `charges` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `chargedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reason` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clothing`
--

CREATE TABLE `clothing` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `modelid` smallint(5) DEFAULT NULL,
  `boneid` tinyint(2) DEFAULT NULL,
  `attached` tinyint(1) DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `scale_x` float DEFAULT NULL,
  `scale_y` float DEFAULT NULL,
  `scale_z` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `clothing`
--

INSERT INTO `clothing` (`id`, `uid`, `name`, `modelid`, `boneid`, `attached`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`, `scale_x`, `scale_y`, `scale_z`) VALUES
(9, 1, 'Custom Toy', 356, 1, 0, 0.132, 0.13, 0.106, -7.8, 156.6, 17.8, 1, 1, 1),
(10, 1, 'Custom Toy', 19006, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `crates`
--

CREATE TABLE `crates` (
  `id` int(11) NOT NULL,
  `cbObject` int(11) DEFAULT 964,
  `Facility` int(11) NOT NULL DEFAULT 0,
  `Group` int(11) NOT NULL DEFAULT -1,
  `CrateX` float(20,5) NOT NULL DEFAULT 0.00000,
  `CrateY` float(20,5) NOT NULL DEFAULT 0.00000,
  `CrateZ` float(20,5) NOT NULL DEFAULT 0.00000,
  `InVehicle` int(11) NOT NULL DEFAULT -1,
  `OnVehicle` int(11) NOT NULL DEFAULT -1,
  `Int` int(11) NOT NULL DEFAULT 0,
  `VW` int(11) NOT NULL DEFAULT 0,
  `Materials` int(11) NOT NULL DEFAULT 0,
  `Gun1` int(11) NOT NULL DEFAULT 0,
  `GunAmount1` int(11) NOT NULL DEFAULT 0,
  `Gun2` int(11) NOT NULL DEFAULT 0,
  `GunAmount2` int(11) NOT NULL DEFAULT 0,
  `Gun3` int(11) NOT NULL DEFAULT 0,
  `GunAmount3` int(11) NOT NULL DEFAULT 0,
  `Gun4` int(11) NOT NULL DEFAULT 0,
  `GunAmount4` int(11) NOT NULL DEFAULT 0,
  `Gun5` int(11) NOT NULL DEFAULT 0,
  `GunAmount5` int(11) NOT NULL DEFAULT 0,
  `Gun6` int(11) NOT NULL DEFAULT 0,
  `GunAmount6` int(11) NOT NULL DEFAULT 0,
  `Gun7` int(11) NOT NULL DEFAULT 0,
  `GunAmount7` int(11) NOT NULL DEFAULT 0,
  `Gun8` int(11) NOT NULL DEFAULT 0,
  `GunAmount8` int(11) NOT NULL DEFAULT 0,
  `Gun9` int(11) NOT NULL DEFAULT 0,
  `GunAmount9` int(11) NOT NULL DEFAULT 0,
  `Gun10` int(11) NOT NULL DEFAULT 0,
  `GunAmount10` int(11) NOT NULL DEFAULT 0,
  `Gun11` int(11) NOT NULL DEFAULT 0,
  `GunAmount11` int(11) NOT NULL DEFAULT 0,
  `Gun12` int(11) NOT NULL DEFAULT 0,
  `GunAmount12` int(11) NOT NULL DEFAULT 0,
  `Gun13` int(11) NOT NULL DEFAULT 0,
  `GunAmount13` int(11) NOT NULL DEFAULT 0,
  `Gun14` int(11) NOT NULL DEFAULT 0,
  `GunAmount14` int(11) NOT NULL DEFAULT 0,
  `Gun15` int(11) NOT NULL DEFAULT 0,
  `GunAmount16` int(11) NOT NULL DEFAULT 0,
  `GunAmount15` int(11) NOT NULL DEFAULT 0,
  `Gun16` int(11) NOT NULL DEFAULT 0,
  `PlacedBy` varchar(24) NOT NULL DEFAULT 'Unknown',
  `Lifespan` int(11) NOT NULL DEFAULT 0,
  `Transfer` int(1) NOT NULL DEFAULT 0,
  `DoorID` int(11) NOT NULL DEFAULT -1,
  `DoorType` int(11) NOT NULL DEFAULT -1,
  `Price` int(11) NOT NULL DEFAULT 0,
  `Paid` int(1) NOT NULL DEFAULT 0,
  `Active` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `crates`
--

INSERT INTO `crates` (`id`, `cbObject`, `Facility`, `Group`, `CrateX`, `CrateY`, `CrateZ`, `InVehicle`, `OnVehicle`, `Int`, `VW`, `Materials`, `Gun1`, `GunAmount1`, `Gun2`, `GunAmount2`, `Gun3`, `GunAmount3`, `Gun4`, `GunAmount4`, `Gun5`, `GunAmount5`, `Gun6`, `GunAmount6`, `Gun7`, `GunAmount7`, `Gun8`, `GunAmount8`, `Gun9`, `GunAmount9`, `Gun10`, `GunAmount10`, `Gun11`, `GunAmount11`, `Gun12`, `GunAmount12`, `Gun13`, `GunAmount13`, `Gun14`, `GunAmount14`, `Gun15`, `GunAmount16`, `GunAmount15`, `Gun16`, `PlacedBy`, `Lifespan`, `Transfer`, `DoorID`, `DoorType`, `Price`, `Paid`, `Active`) VALUES
(14, 964, 0, -1, 0.00000, 0.00000, 0.00000, -1, -1, 0, 0, 0, 30, 509, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Unknown', 0, 0, -1, -1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `custom_skins`
--

CREATE TABLE `custom_skins` (
  `id` int(11) NOT NULL,
  `skin_id` int(11) NOT NULL COMMENT 'Custom skin ID (1000+)',
  `skin_name` varchar(64) NOT NULL COMMENT 'Display name of the skin',
  `model_file` varchar(128) NOT NULL COMMENT 'DFF model filename',
  `texture_file` varchar(128) NOT NULL COMMENT 'TXD texture filename',
  `base_skin_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Fallback skin ID for clients without mod',
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

INSERT INTO `custom_skins` (`id`, `skin_id`, `skin_name`, `model_file`, `texture_file`, `base_skin_id`, `requires_vip`, `min_level`, `cost`, `download_url`, `file_size`, `created_at`, `updated_at`) VALUES
(1, 20001, 'Board Crasher', 'board_crasher.dff', 'board_crasher.txd', 58, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-14 13:23:06'),
(2, 20002, 'Mikoto Mikasa School', 'Mikoto_School.dff', 'Mikoto_School.txd', 63, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-14 13:23:11'),
(3, 20003, 'Mikoto Mikasa Swimsuit', 'Mikoto_Swimsuit.dff', 'Mikoto_Swimsuit.txd', 64, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-14 13:23:14'),
(4, 20004, 'Mikoto Mikasa Pajamas', 'Mikoto_Pajamas.dff', 'Mikoto_Pajamas.txd', 65, 0, 1, 0, NULL, 0, '2026-03-12 08:13:15', '2026-03-14 13:23:18');

-- --------------------------------------------------------

--
-- Table structure for table `deliverpt`
--

CREATE TABLE `deliverpt` (
  `id` int(10) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `iconid` smallint(5) DEFAULT 1240,
  `type` smallint(5) DEFAULT 0,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `deliverpt`
--

INSERT INTO `deliverpt` (`id`, `name`, `iconid`, `type`, `pos_x`, `pos_y`, `pos_z`, `interior`, `world`) VALUES
(284, 'Allsaints Hospital', 1240, 0, 1141.85, -1330.4, 13.631, 0, 0),
(285, 'County General Hospital ', 1240, 0, 2032.87, -1413.54, 16.992, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `divisions`
--

CREATE TABLE `divisions` (
  `id` tinyint(2) DEFAULT NULL,
  `divisionid` tinyint(2) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `entrances`
--

CREATE TABLE `entrances` (
  `id` int(10) NOT NULL,
  `ownerid` int(10) DEFAULT 0,
  `owner` varchar(24) DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `iconid` smallint(5) DEFAULT 1239,
  `locked` tinyint(1) DEFAULT 0,
  `radius` float DEFAULT 3,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `int_x` float DEFAULT 0,
  `int_y` float DEFAULT 0,
  `int_z` float DEFAULT 0,
  `int_a` float DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `outsideint` int(10) DEFAULT 0,
  `outsidevw` int(10) DEFAULT 0,
  `adminlevel` tinyint(2) DEFAULT 0,
  `factiontype` tinyint(2) DEFAULT 0,
  `vip` tinyint(2) DEFAULT 0,
  `vehicles` tinyint(1) DEFAULT 0,
  `freeze` tinyint(1) DEFAULT 0,
  `password` varchar(64) DEFAULT 'None',
  `label` tinyint(1) DEFAULT 1,
  `mapicon` tinyint(2) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `entrances`
--

INSERT INTO `entrances` (`id`, `ownerid`, `owner`, `name`, `iconid`, `locked`, `radius`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `int_x`, `int_y`, `int_z`, `int_a`, `interior`, `world`, `outsideint`, `outsidevw`, `adminlevel`, `factiontype`, `vip`, `vehicles`, `freeze`, `password`, `label`, `mapicon`) VALUES
(292, 0, NULL, 'Police Department', 1247, 0, 3, 1555.43, -1675.71, 16.195, 92.929, -451.325, 2216.5, 1601.09, 83.047, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 30),
(294, 0, NULL, 'Allsaints Hospital', 1241, 0, 3, 1174.53, -1323.74, 14.789, 95.151, 1265.52, -1291.47, 1061.15, 96.634, 0, 2, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 22),
(295, 0, NULL, 'San Fierro Hospital', 1239, 0, 3, -2655.58, 637.91, 14.453, 182.237, -1110.62, 2000.93, -58.92, 184.341, 0, 3, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 22),
(296, 0, NULL, 'City Hall', 954, 0, 3, 1481.38, -1786.82, 24.083, 176.448, -1840.09, 2874.17, 760.77, 86.293, 0, 4, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(297, 0, NULL, 'DMV', 1239, 0, 3, 1375.1, -2706.23, 13.558, 0.969, 1414.4, 435.802, -39.135, 87.666, 0, 5, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 24),
(298, 0, NULL, 'Drug Laboratory', 1580, 0, 3, 2351.77, -1170.46, 28.073, 188.815, 2319.01, -1786.6, 1600.75, 89.923, 0, 6, 0, 0, 0, 0, 0, 0, 1, 'druglabpassword', 1, 0),
(299, 0, NULL, 'Meth Laboratory', 1578, 0, 3, 2165.88, -1671.25, 15.079, 17.568, 770.868, -1109.8, -43.262, 175.831, 0, 7, 0, 0, 0, 0, 0, 0, 1, 'password123', 1, 1),
(301, 0, NULL, 'International Bank', 1212, 0, 3, 1462.37, -1011.07, 26.844, 177.84, 1388.58, -220.597, 1000.87, 87.939, 0, 9, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 52),
(302, 0, NULL, 'Adonis Gey Bar', 1239, 0, 3, 2421.52, -1219.48, 25.546, 184.326, 2181.68, -364.424, 399.769, 182.927, 0, 10, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(303, 0, NULL, 'Casino', 1239, 0, 3, 1022.54, -1121.68, 23.872, -4.929, 1049.94, -74.962, 1003.86, 273.145, 0, 11, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 25),
(304, 0, NULL, 'VIP Lounge', 1239, 0, 3, 554.811, -1632.27, 17.348, 91.409, 494.652, 479.509, 609.938, 176.517, 0, 12, 0, 0, 0, 0, 1, 0, 1, 'None', 1, 25),
(306, 0, NULL, 'Balcony', 1239, 0, 3, 586.125, -1639.8, 35.055, 273.362, 586.125, -1639.8, 35.055, 273.362, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(311, 0, NULL, 'Bitcoin Center', 1239, 0, 3, 487.151, -1639.38, 23.703, 174.547, 1590.35, 350.719, 1002.31, 181.29, 0, 15, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(312, 0, NULL, 'Federal Bureau of Investigation', 19130, 0, 3, 328.007, -1512.28, 36.033, -124.615, -451.325, 2216.5, 1601.09, 83.047, 0, 4000312, 0, 0, 0, 0, 0, 0, 1, 'None', 1, -1),
(314, 0, NULL, 'WHITE HOUSE', 1239, 0, 3, 1122.71, -2037.13, 69.894, -99.753, 0, 0, 0, 0, 0, 4000314, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(316, 0, NULL, 'Hitman Headquarter', 1239, 0, 3, 2780.22, -1425.79, 16.25, -179.204, 2739.48, -1451.35, 871.747, 272.435, 0, 19, 0, 0, 0, 5, 0, 0, 1, 'None', 1, 0),
(324, 0, NULL, 'Rooftop Access', 1239, 0, 3, 1712.63, -1640.53, 20.224, 44.601, 677.446, -465.686, 22.57, 184.97, 0, 4000324, 18, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(325, 0, NULL, 'Office of Aliyah_Seraffina', 1239, 0, 3, 1232.12, -810.973, 1084.01, -174.084, 0, 0, 0, 0, 0, 4000325, 5, 1000946, 0, 0, 0, 0, 0, 'None', 1, -1),
(330, 0, NULL, 'Rooftop', 1318, 0, 3, -464.908, 2209.8, 1601.09, -96.686, 1565.3, -1665.75, 28.396, 350.056, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(331, 0, NULL, 'Rooftop', 19130, 0, 3, 1174.63, -1341.74, 13.994, 178.196, 1161.6, -1329.91, 31.615, 46.798, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(332, 0, NULL, 'ROOF', 1239, 0, 3, 1568.56, -1689.97, 6.219, 175.032, 1575.9, -1638.92, 28.402, 112.476, 0, 4000332, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(342, 0, NULL, 'VIP Garage', 1239, 0, 3, 604.76, -1651.22, 16.177, 84.925, -4399.05, 870.672, 986.712, 358.807, 0, 0, 0, 0, 0, 0, 1, 0, 1, 'None', 1, 0),
(345, 0, NULL, '069 Hermanos De Latinos', 1313, 0, 3, 2313.28, 56.357, 26.484, -113.152, 226.296, 1114.44, 1080.98, 92.805, 5, 4000345, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(346, 0, NULL, 'ROOF', 1239, 0, 3, 2259.38, -1135.84, 1050.64, -95.128, 2307.94, 54.871, 31.483, 269.005, 0, 4000346, 10, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(347, 0, NULL, 'ROOF', 1239, 0, 3, 246.032, 1120.69, 1084.99, 76.394, 2309.3, 54.896, 30.483, 290.297, 0, 4000347, 5, 4000335, 0, 0, 0, 0, 0, 'None', 1, -1),
(348, 0, NULL, 'ROOFTOP', 1239, 0, 3, 41.755, -1619.31, 11.189, 170.749, 46.845, -1604.16, 21.158, 251.237, 0, 4000348, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(351, 0, NULL, 'Rooftop', 1239, 0, 3, -464.908, 2209.83, 1601.09, 91.354, 333.279, -1497.35, 76.539, 67.827, 0, 4000351, 0, 1, 0, 0, 0, 0, 1, 'None', 1, 0),
(353, 0, NULL, 'Estados Unidos', 1313, 0, 3, 725.494, -1440.45, 13.539, -1.405, 140.376, 1365.92, 1083.86, 338.258, 5, 4000353, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(362, 0, NULL, 'CHINA TOWN', 1239, 0, 3, 2275.28, -929.975, 28.037, -92.922, -2170.39, 635.391, 1052.38, 178.414, 1, 4000362, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(363, 0, NULL, 'STAR TOWER', 1239, 0, 3, 1570.44, -1337.46, 16.484, -42.573, 1548.65, -1363.74, 326.218, 359.606, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(367, 0, NULL, 'Prison', 19300, 0, 5, -463.559, 2223.54, 1601.68, 268.627, 1207.03, -1314.32, 797.55, 268.555, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(371, 0, NULL, 'Rooftop', 1239, 0, 3, 1280.21, -793.704, 88.315, 170.534, 1267.73, -777.541, 95.965, 270.222, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(372, 0, NULL, 'ROOFTOP', 1239, 0, 3, 1279.91, -813.356, 83.597, -175.854, 1275.63, -775.102, 95.964, 176.481, 0, 4000372, 0, 0, 0, 0, 0, 0, 0, 'None', 0, 0),
(378, 0, NULL, 'ROOFTOP', 19300, 0, 3, 1268.64, -1640.38, 13.547, -83.638, 1274.17, -1641.58, 27.375, 355.299, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(384, 0, NULL, 'House 1', 1239, 0, 3, 1711.52, 1455.29, 1145.78, -86.597, 1011.39, 2412.09, 1501.08, 91.022, 0, 45, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(385, 0, NULL, 'House 2', 1239, 0, 3, 1711.82, 1459.59, 1145.78, -90.983, 1423.88, -367.033, 1781.8, 358.876, 0, 46, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(386, 0, NULL, 'House 3', 1239, 0, 3, 1712.29, 1462.95, 1145.78, -83.777, -2678.53, 1810.24, 1501.09, 89.475, 0, 47, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(387, 0, NULL, 'house 4', 1239, 0, 3, 1713.07, 1466.61, 1145.78, -86.283, 887.484, 1918.37, -88.974, 90.125, 0, 48, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(391, 0, NULL, 'Las Brahman Tiradores Hermano\'s', 1313, 0, 3, 2770.7, -1628.73, 12.172, 166.429, 493.435, -24.292, 1000.68, 313.204, 17, 4000391, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(392, 0, NULL, 'Eternity Nonly', 1313, 0, 3, 1259.64, -785.362, 92.031, 70.264, 1133.27, -15.676, 1000.68, 345.966, 12, 4000392, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(393, 0, NULL, '1', 1239, 0, 3, 1257.56, -800.919, 84.141, -176.733, 1133.92, -15.498, 1000.68, 344.012, 12, 4000393, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(397, 5547, 'Avrielle_Natsumi', 'Los Nevados Surrenios', 1313, 0, 3, 1684.41, -2086.65, 13.547, -5.551, 234.582, 1063.71, 1084.21, 109.601, 6, 4000397, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(399, 0, NULL, 'MeatShop', 1239, 0, 3, 2414.23, -1425.89, 23.985, 94.316, 1477.08, 277.557, 904.616, 1.096, 0, 4000399, 0, 0, 0, 0, 0, 0, 1, 'None', 1, -1),
(401, 0, NULL, 'Meth lab', 1239, 0, 3, 1517.97, -1565.63, 23.547, 177.537, 771.001, -1108.97, -43.262, 182.032, 0, 4000401, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1),
(402, 0, NULL, 'press \'Y\' to open', 19300, 0, 1, 665.114, -1307.34, 13.461, 181.282, 0, 0, 0, 0, 0, 4000402, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(404, 0, NULL, 'press \'Y\' to open', 19300, 0, 1, 783.207, -1152.41, 23.479, 89.016, 0, 0, 0, 0, 0, 4000404, 0, 0, 0, 0, 0, 0, 0, 'None', 1, 0),
(406, 0, NULL, 'EXIT', 1239, 0, 3, 1266.23, -1291.52, 1061.15, 91.759, 1174.39, -1323.79, 14.789, 266.371, 0, 4000406, 0, 1, 0, 0, 0, 0, 1, 'None', 1, 0),
(407, 0, NULL, 'EXIT', 1239, 0, 3, 1266.56, -1291.65, 1061.15, 85.944, 1174.52, -1323.86, 14.789, 275.92, 0, 4000407, 0, 0, 0, 0, 0, 0, 1, 'None', 1, 0),
(408, 0, NULL, 'EXIT', 1239, 0, 3, -1839.86, 2874.25, 760.77, 85.217, 1481.51, -1787.05, 24.083, 30.18, 0, 4000408, 0, 0, 0, 0, 0, 0, 0, 'None', 1, -1);

-- --------------------------------------------------------

--
-- Table structure for table `factionbanned`
--

CREATE TABLE `factionbanned` (
  `uid` int(11) NOT NULL,
  `timeremain` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `factiongarage`
--

CREATE TABLE `factiongarage` (
  `id` int(11) NOT NULL,
  `factionid` int(2) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `interior` int(11) NOT NULL,
  `world` int(11) NOT NULL,
  `iconid` int(11) NOT NULL DEFAULT 1239,
  `label` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `factionlockers`
--

CREATE TABLE `factionlockers` (
  `id` int(11) NOT NULL,
  `factionid` int(2) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `interior` int(11) NOT NULL,
  `world` int(11) NOT NULL,
  `iconid` int(11) NOT NULL DEFAULT 1239,
  `label` int(11) NOT NULL DEFAULT 1,
  `weapon_kevlar` int(1) NOT NULL DEFAULT 0,
  `weapon_medkit` int(1) NOT NULL DEFAULT 0,
  `weapon_nitestick` int(1) NOT NULL DEFAULT 0,
  `weapon_mace` int(1) NOT NULL DEFAULT 0,
  `weapon_deagle` int(1) NOT NULL DEFAULT 0,
  `weapon_shotgun` int(1) NOT NULL DEFAULT 0,
  `weapon_mp5` int(1) NOT NULL DEFAULT 0,
  `weapon_m4` int(1) NOT NULL DEFAULT 0,
  `weapon_spas12` int(1) NOT NULL DEFAULT 0,
  `weapon_sniper` int(1) NOT NULL DEFAULT 0,
  `weapon_camera` int(1) NOT NULL DEFAULT 0,
  `weapon_fire_extinguisher` int(1) NOT NULL DEFAULT 0,
  `weapon_painkillers` int(1) NOT NULL DEFAULT 0,
  `weapon_medals` int(10) DEFAULT 0,
  `price_kevlar` int(10) NOT NULL DEFAULT 0,
  `price_medkit` int(10) NOT NULL DEFAULT 0,
  `price_nitestick` int(10) NOT NULL DEFAULT 0,
  `price_mace` int(10) NOT NULL DEFAULT 0,
  `price_deagle` int(10) NOT NULL DEFAULT 0,
  `price_shotgun` int(10) NOT NULL DEFAULT 0,
  `price_mp5` int(10) NOT NULL DEFAULT 0,
  `price_m4` int(10) NOT NULL DEFAULT 0,
  `price_spas12` int(10) NOT NULL DEFAULT 0,
  `price_sniper` int(10) NOT NULL DEFAULT 0,
  `price_camera` int(10) NOT NULL DEFAULT 0,
  `price_fire_extinguisher` int(10) NOT NULL DEFAULT 0,
  `price_painkillers` int(10) NOT NULL DEFAULT 0,
  `price_medals` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `factionlockers`
--

INSERT INTO `factionlockers` (`id`, `factionid`, `pos_x`, `pos_y`, `pos_z`, `interior`, `world`, `iconid`, `label`, `weapon_kevlar`, `weapon_medkit`, `weapon_nitestick`, `weapon_mace`, `weapon_deagle`, `weapon_shotgun`, `weapon_mp5`, `weapon_m4`, `weapon_spas12`, `weapon_sniper`, `weapon_camera`, `weapon_fire_extinguisher`, `weapon_painkillers`, `weapon_medals`, `price_kevlar`, `price_medkit`, `price_nitestick`, `price_mace`, `price_deagle`, `price_shotgun`, `price_mp5`, `price_m4`, `price_spas12`, `price_sniper`, `price_camera`, `price_fire_extinguisher`, `price_painkillers`, `price_medals`) VALUES
(1, 1, -481.936, 2211.97, 1601.09, 0, 0, 1242, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 3, 318.874, -1864.96, 4.043, 0, 0, 1242, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `factionpay`
--

CREATE TABLE `factionpay` (
  `id` tinyint(2) DEFAULT NULL,
  `rank` tinyint(2) DEFAULT NULL,
  `amount` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `factionranks`
--

CREATE TABLE `factionranks` (
  `id` tinyint(2) DEFAULT NULL,
  `rank` tinyint(2) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `id` tinyint(2) DEFAULT NULL,
  `name` varchar(48) DEFAULT NULL,
  `shortname` tinytext DEFAULT NULL,
  `leader` varchar(24) DEFAULT 'No-one',
  `type` tinyint(2) DEFAULT 0,
  `color` int(10) DEFAULT -1,
  `rankcount` tinyint(2) DEFAULT 6,
  `lockerx` float DEFAULT 0,
  `lockery` float DEFAULT 0,
  `lockerz` float DEFAULT 0,
  `lockerinterior` tinyint(2) DEFAULT 0,
  `lockerworld` int(10) DEFAULT 0,
  `turftokens` int(11) DEFAULT 0,
  `factionchat` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `factions`
--

INSERT INTO `factions` (`id`, `name`, `shortname`, `leader`, `type`, `color`, `rankcount`, `lockerx`, `lockery`, `lockerz`, `lockerinterior`, `lockerworld`, `turftokens`, `factionchat`) VALUES
(1, 'CONR-RP POLICE DEPARTMENT', NULL, 'No-one', 1, 591329792, 6, 0, 0, 0, 0, 0, 3, 0),
(2, 'CONR-RP MEDICAL DEPARTMENT', NULL, 'No-one', 2, -11472640, 6, 0, 0, 0, 0, 0, 0, 0),
(3, 'CONR-RP MECHANIC DEPARTMENT', NULL, 'No-one', 7, 852308480, 6, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `factionskins`
--

CREATE TABLE `factionskins` (
  `id` tinyint(2) DEFAULT NULL,
  `slot` tinyint(2) DEFAULT NULL,
  `skinid` smallint(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faction_vehicle`
--

CREATE TABLE `faction_vehicle` (
  `ID` int(10) NOT NULL,
  `Model` smallint(3) DEFAULT 0,
  `Faction` int(10) DEFAULT 0,
  `Price` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fishing_actors`
--

CREATE TABLE `fishing_actors` (
  `id` int(11) NOT NULL,
  `zone_id` int(11) NOT NULL,
  `actor_name` varchar(64) NOT NULL DEFAULT 'Fisherman',
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `pos_a` float NOT NULL DEFAULT 0,
  `skin_id` int(11) NOT NULL DEFAULT 158,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fishing_actors`
--

INSERT INTO `fishing_actors` (`id`, `zone_id`, `actor_name`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `skin_id`, `created_by`, `created_at`, `is_active`) VALUES
(1, 5, 'Fisherman', 532.619, -1898.52, 2.193, 173.194, 158, 0, '2026-03-09 09:36:46', 1),
(2, 1, 'Fisherman', 1286.14, -2648.84, 5.289, 164.914, 158, 0, '2026-03-09 12:49:32', 1),
(3, 3, 'Fisherman', 216.236, 146.699, 2.43, 187.947, 158, 0, '2026-03-13 16:43:04', 1),
(4, 9, 'Fisherman', -1520.79, 161.295, 3.555, 135.612, 158, 0, '2026-03-14 19:18:46', 1);

-- --------------------------------------------------------

--
-- Table structure for table `fishing_audit`
--

CREATE TABLE `fishing_audit` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(24) NOT NULL,
  `action_type` enum('LEVEL_UP','BUY_ROD','BUY_BAIT','SELL_FISH','CATCH_FISH') NOT NULL,
  `item_name` varchar(64) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `amount` int(11) DEFAULT 0,
  `player_level` int(11) DEFAULT 1,
  `player_exp` int(11) DEFAULT 0,
  `player_tokens` int(11) DEFAULT 0,
  `details` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fishing_audit`
--

INSERT INTO `fishing_audit` (`id`, `player_id`, `user_id`, `username`, `action_type`, `item_name`, `item_id`, `quantity`, `amount`, `player_level`, `player_exp`, `player_tokens`, `details`, `created_at`) VALUES
(1, 10, 0, 'Joma_Nuron', 'BUY_ROD', 'Basic Fishing Rod', 1, 1, 2500, 1, 0, 0, 'Purchased Basic Fishing Rod for $2500', '2026-03-14 14:34:41'),
(2, 10, 0, 'Joma_Nuron', 'BUY_BAIT', 'Golden Bait', 4, 10, 1000, 1, 0, 0, 'Purchased 10x Golden Bait for $1000', '2026-03-14 14:35:46'),
(3, 10, 0, 'Joma_Nuron', 'BUY_BAIT', 'Golden Bait', 4, 10, 1000, 1, 0, 0, 'Purchased 10x Golden Bait for $1000', '2026-03-14 14:35:50'),
(4, 10, 0, 'Joma_Nuron', 'BUY_BAIT', 'Golden Bait', 4, 10, 1000, 1, 0, 0, 'Purchased 10x Golden Bait for $1000', '2026-03-14 14:35:54'),
(5, 10, 0, 'Joma_Nuron', 'LEVEL_UP', '', 0, 0, 10, 2, 0, 10, 'Level 2 reached, earned 10 tokens', '2026-03-14 17:57:35'),
(6, 10, 0, 'Joma_Nuron', 'LEVEL_UP', '', 0, 0, 15, 3, 0, 26, 'Level 3 reached, earned 15 tokens', '2026-03-14 18:30:14'),
(7, 10, 0, 'Joma_Nuron', 'BUY_BAIT', 'Legendary Lure', 5, 10, 2000, 3, 127, 31, 'Purchased 10x Legendary Lure for $2000', '2026-03-14 19:29:53'),
(8, 10, 0, 'Joma_Nuron', 'BUY_BAIT', 'Legendary Lure', 5, 10, 2000, 3, 127, 31, 'Purchased 10x Legendary Lure for $2000', '2026-03-14 19:30:04'),
(9, 10, 0, 'Joma_Nuron', 'LEVEL_UP', '', 0, 0, 20, 4, 0, 51, 'Level 4 reached, earned 20 tokens', '2026-03-14 19:30:37'),
(10, 10, 0, 'Joma_Nuron', 'LEVEL_UP', '', 0, 0, 25, 5, 0, 76, 'Level 5 reached, earned 25 tokens', '2026-03-14 19:33:22'),
(11, 10, 0, 'Joma_Nuron', 'BUY_ROD', 'Amateur Fishing Rod', 2, 1, 5000, 5, 0, 76, 'Purchased Amateur Fishing Rod for $5000', '2026-03-14 19:34:10');

-- --------------------------------------------------------

--
-- Table structure for table `fishing_boats`
--

CREATE TABLE `fishing_boats` (
  `id` int(11) NOT NULL,
  `zone_id` int(11) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `pos_a` float NOT NULL DEFAULT 0,
  `model_id` int(11) NOT NULL DEFAULT 453,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fishing_boats`
--

INSERT INTO `fishing_boats` (`id`, `zone_id`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `model_id`, `created_by`, `created_at`, `is_active`) VALUES
(1, 5, 516.146, -1917.52, -0.217, 174.776, 453, 0, '2026-03-09 09:49:20', 1),
(2, 5, 524.023, -1918.55, -0.381, 178.328, 453, 0, '2026-03-09 10:58:30', 1),
(3, 1, 1254.95, -2664.14, -0.507, 120.508, 453, 0, '2026-03-09 12:50:19', 1),
(4, 5, 533.298, -1918.78, -0.395, 171.023, 453, 0, '2026-03-09 15:14:38', 1),
(5, 5, 506.949, -1916.94, -0.27, 171.943, 453, 0, '2026-03-09 16:48:19', 1),
(6, 5, 542.414, -1919.21, -0.333, 181.512, 453, 0, '2026-03-09 16:49:19', 1),
(7, 3, 218.442, 162.089, -0.294, 350.307, 453, 0, '2026-03-13 16:43:35', 1),
(8, 9, -1520.1, 173.738, -0.475, 314.475, 453, 0, '2026-03-14 19:19:48', 1),
(9, 9, -1516.04, 169.452, -0.33, 311.28, 453, 0, '2026-03-14 19:21:03', 1),
(10, 9, -1511.65, 164.977, -0.373, 313.961, 453, 0, '2026-03-14 19:22:04', 1),
(11, 9, -1506.81, 160.167, -0.493, 311.8, 453, 0, '2026-03-14 19:22:55', 1),
(12, 9, -1501.84, 154.841, -0.465, 315.02, 453, 0, '2026-03-14 19:24:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `fishing_inventory`
--

CREATE TABLE `fishing_inventory` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `fish_name` varchar(64) NOT NULL,
  `fish_rarity` enum('common','uncommon','rare','legendary') NOT NULL,
  `fish_weight` float NOT NULL,
  `fish_value` int(10) UNSIGNED NOT NULL,
  `zone_id` int(10) UNSIGNED NOT NULL,
  `caught_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Player fish inventory - caught fish waiting to be sold';

-- --------------------------------------------------------

--
-- Table structure for table `fishing_leaderboard`
--

CREATE TABLE `fishing_leaderboard` (
  `player_id` int(10) UNSIGNED NOT NULL,
  `player_name` varchar(24) NOT NULL,
  `total_caught` int(10) UNSIGNED DEFAULT 0,
  `biggest_weight` float DEFAULT 0,
  `legendary_count` int(10) UNSIGNED DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Fishing leaderboard rankings';

--
-- Dumping data for table `fishing_leaderboard`
--

INSERT INTO `fishing_leaderboard` (`player_id`, `player_name`, `total_caught`, `biggest_weight`, `legendary_count`, `last_updated`) VALUES
(10, 'Joma_Nuron', 43, 66.95, 0, '2026-03-14 19:37:26');

-- --------------------------------------------------------

--
-- Table structure for table `fishing_log`
--

CREATE TABLE `fishing_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `fish_name` varchar(64) NOT NULL,
  `fish_rarity` enum('common','uncommon','rare','legendary') NOT NULL,
  `fish_weight` float NOT NULL,
  `fish_value` int(10) UNSIGNED NOT NULL,
  `zone_id` int(10) UNSIGNED NOT NULL,
  `caught_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Fishing catch history for analytics';

--
-- Dumping data for table `fishing_log`
--

INSERT INTO `fishing_log` (`id`, `player_id`, `fish_name`, `fish_rarity`, `fish_weight`, `fish_value`, `zone_id`, `caught_at`) VALUES
(1, 10, '', 'common', 0, 0, 0, '2026-03-08 11:09:28'),
(2, 10, '', 'common', 0, 0, 0, '2026-03-08 11:14:06'),
(3, 10, 'Sardine', 'common', 0.431, 28, 0, '2026-03-08 11:19:21'),
(4, 10, 'Sardine', 'common', 0.226, 21, 0, '2026-03-08 11:26:23'),
(5, 10, 'Sardine', 'common', 0.35, 25, 0, '2026-03-08 11:26:52'),
(6, 10, 'Mackerel', 'common', 1.075, 49, 0, '2026-03-08 11:27:43'),
(7, 10, 'Sardine', 'common', 0.459, 29, 0, '2026-03-08 11:30:08'),
(8, 10, 'Sardine', 'common', 0.401, 27, 0, '2026-03-08 11:36:37'),
(9, 10, 'Mackerel', 'common', 1.192, 52, 0, '2026-03-08 11:37:44'),
(10, 10, 'Sardine', 'common', 0.276, 23, 0, '2026-03-08 11:43:02'),
(11, 10, 'Mackerel', 'common', 0.682, 40, 0, '2026-03-08 17:23:53'),
(12, 10, 'Sardine', 'common', 0.214, 20, 0, '2026-03-08 19:20:23'),
(13, 10, 'Sardine', 'common', 0.208, 20, 0, '2026-03-08 19:21:09'),
(14, 10, 'Sea Bass', 'uncommon', 1.39, 82, 0, '2026-03-08 19:21:37'),
(15, 10, 'Sardine', 'common', 0.316, 24, 0, '2026-03-08 19:34:41'),
(16, 10, 'Mackerel', 'common', 0.757, 41, 0, '2026-03-08 19:42:36'),
(17, 10, 'Sardine', 'common', 0.273, 22, 0, '2026-03-08 19:42:58'),
(18, 10, 'Sardine', 'common', 0.447, 28, 0, '2026-03-08 19:47:15'),
(19, 10, 'Mackerel', 'common', 0.793, 42, 0, '2026-03-08 19:48:46'),
(20, 10, 'Mackerel', 'common', 0.735, 41, 0, '2026-03-08 19:52:57'),
(21, 10, 'Sardine', 'common', 0.224, 21, 0, '2026-03-08 19:56:10'),
(22, 10, 'Grouper', 'rare', 3.8, 216, 0, '2026-03-08 19:56:47'),
(23, 10, 'Mackerel', 'common', 0.87, 44, 0, '2026-03-08 20:07:52'),
(24, 10, 'Mackerel', 'common', 0.835, 43, 0, '2026-03-08 20:10:22'),
(25, 10, 'Mackerel', 'common', 0.975, 47, 0, '2026-03-08 20:10:44'),
(26, 10, 'Sardine', 'common', 0.296, 23, 0, '2026-03-08 20:11:19'),
(27, 10, 'Mackerel', 'common', 0.913, 45, 0, '2026-03-08 20:12:08'),
(28, 10, 'Sardine', 'common', 0.471, 29, 0, '2026-03-08 20:19:52'),
(29, 10, 'Mackerel', 'common', 0.536, 36, 0, '2026-03-08 20:20:17'),
(30, 10, 'Sea Bass', 'uncommon', 1.056, 76, 0, '2026-03-08 20:20:40'),
(31, 10, 'Sardine', 'common', 0.259, 22, 0, '2026-03-08 20:21:01'),
(32, 10, 'Sardine', 'common', 0.271, 22, 0, '2026-03-08 20:21:22'),
(33, 10, 'Sardine', 'common', 0.415, 27, 0, '2026-03-08 20:21:43'),
(34, 10, 'Mackerel', 'common', 0.557, 36, 0, '2026-03-08 20:22:20'),
(35, 10, 'Sardine', 'common', 0.203, 20, 0, '2026-03-08 20:22:45'),
(36, 10, 'Sardine', 'common', 0.447, 28, 0, '2026-03-08 20:23:06'),
(37, 10, 'Sardine', 'common', 0.348, 25, 0, '2026-03-08 20:23:30'),
(38, 10, 'Mackerel', 'common', 0.509, 35, 0, '2026-03-08 20:40:02'),
(39, 10, 'Mackerel', 'common', 0.949, 46, 0, '2026-03-08 20:40:26'),
(40, 10, 'Barracuda', 'rare', 8.362, 341, 0, '2026-03-08 20:40:45'),
(41, 10, 'Mackerel', 'common', 1.19, 52, 0, '2026-03-08 20:41:37'),
(42, 10, 'Mackerel', 'common', 0.909, 45, 0, '2026-03-08 20:41:59'),
(43, 10, 'Mackerel', 'common', 1.011, 48, 0, '2026-03-08 20:42:20'),
(44, 10, 'Mackerel', 'common', 0.783, 42, 0, '2026-03-09 07:39:23'),
(45, 10, 'Sardine', 'common', 0.439, 28, 0, '2026-03-09 07:41:28'),
(46, 10, 'Sardine', 'common', 0.334, 24, 0, '2026-03-09 07:41:56'),
(47, 10, 'Mackerel', 'common', 0.628, 38, 0, '2026-03-09 07:42:26'),
(48, 10, 'Mackerel', 'common', 0.599, 37, 0, '2026-03-09 07:59:48'),
(49, 10, 'Mackerel', 'common', 1.152, 51, 0, '2026-03-09 11:04:49'),
(50, 10, 'Sardine', 'common', 0.206, 20, 0, '2026-03-09 11:05:52'),
(51, 10, 'Sea Bass', 'uncommon', 1.416, 83, 0, '2026-03-09 11:06:18'),
(52, 10, '', 'common', 0, 0, 0, '2026-03-09 11:19:26'),
(53, 10, '', 'common', 0, 0, 0, '2026-03-09 11:20:07'),
(54, 10, 'Mackerel', 'common', 0.68, 39, 0, '2026-03-09 11:31:53'),
(55, 10, 'Mackerel', 'common', 0.616, 38, 0, '2026-03-09 11:32:30'),
(56, 10, 'Sardine', 'common', 0.374, 26, 0, '2026-03-09 11:41:45'),
(57, 10, 'Mackerel', 'common', 0.718, 40, 0, '2026-03-09 12:11:59'),
(58, 10, 'Sardine', 'common', 0.219, 21, 0, '2026-03-09 12:12:36'),
(59, 10, 'Sardine', 'common', 0.49, 30, 0, '2026-03-09 12:12:57'),
(60, 10, 'Sardine', 'common', 0.456, 29, 0, '2026-03-09 17:07:55'),
(61, 10, 'Mackerel', 'common', 0.733, 41, 0, '2026-03-09 17:08:35'),
(62, 10, 'Sardine', 'common', 0.338, 25, 0, '2026-03-09 18:12:26'),
(63, 10, 'Mackerel', 'common', 0.645, 39, 0, '2026-03-09 18:12:55'),
(64, 10, 'Grouper', 'rare', 4.805, 236, 0, '2026-03-09 18:13:20'),
(65, 10, 'Sardine', 'common', 0.223, 21, 0, '2026-03-09 18:13:41'),
(66, 10, 'Sea Bass', 'uncommon', 1.69, 88, 0, '2026-03-09 18:14:06'),
(67, 10, 'Mackerel', 'common', 0.518, 35, 0, '2026-03-09 18:14:31'),
(68, 10, 'Sardine', 'common', 0.239, 21, 0, '2026-03-09 18:14:54'),
(69, 10, 'Sardine', 'common', 0.356, 25, 0, '2026-03-09 18:15:42'),
(70, 10, 'Mackerel', 'common', 1.06, 49, 0, '2026-03-09 18:16:00'),
(71, 10, 'Sardine', 'common', 0.409, 27, 0, '2026-03-09 18:16:34'),
(72, 10, 'Sea Bass', 'uncommon', 2.862, 220, 0, '2026-03-09 18:33:14'),
(73, 10, 'Sea Bass', 'uncommon', 2.498, 206, 0, '2026-03-09 18:33:34'),
(74, 10, 'Sardine', 'common', 0.339, 62, 0, '2026-03-09 18:34:13'),
(75, 10, 'Mackerel', 'common', 1.159, 110, 0, '2026-03-09 18:34:34'),
(76, 10, 'Sardine', 'common', 0.406, 67, 0, '2026-03-09 18:34:56'),
(77, 10, 'Sardine', 'common', 0.245, 54, 0, '2026-03-09 18:35:18'),
(78, 10, 'Mackerel', 'common', 0.65, 83, 0, '2026-03-09 18:35:39'),
(79, 10, 'Mackerel', 'common', 0.877, 95, 0, '2026-03-09 18:36:58'),
(80, 10, 'Sardine', 'common', 0.23, 53, 0, '2026-03-09 18:37:15'),
(81, 10, 'Sardine', 'common', 0.291, 58, 0, '2026-03-09 18:40:13'),
(82, 10, 'Mackerel', 'common', 0.552, 78, 0, '2026-03-09 18:40:34'),
(83, 10, 'Sardine', 'common', 0.302, 59, 0, '2026-03-09 18:59:31'),
(84, 10, 'Sardine', 'common', 0.413, 68, 0, '2026-03-09 18:59:57'),
(85, 10, 'Sea Bass', 'uncommon', 1.268, 160, 0, '2026-03-09 19:00:15'),
(86, 10, 'Sardine', 'common', 0.372, 64, 0, '2026-03-09 19:00:34'),
(87, 10, 'Mackerel', 'common', 0.795, 91, 0, '2026-03-09 19:00:57'),
(88, 10, 'Barracuda', 'rare', 8.956, 706, 0, '2026-03-09 19:01:16'),
(89, 10, 'Sardine', 'common', 0.421, 68, 0, '2026-03-09 19:01:52'),
(90, 10, 'Sardine', 'common', 0.253, 54, 0, '2026-03-09 19:02:11'),
(91, 10, 'Sardine', 'common', 0.486, 74, 0, '2026-03-09 19:02:33'),
(92, 10, 'Sea Bass', 'uncommon', 2.946, 223, 0, '2026-03-09 19:02:51'),
(93, 10, 'Sardine', 'common', 0.343, 62, 0, '2026-03-09 19:03:08'),
(94, 10, 'Mackerel', 'common', 0.715, 87, 0, '2026-03-09 19:03:32'),
(95, 10, 'Sardine', 'common', 0.484, 74, 0, '2026-03-09 19:03:50'),
(96, 10, 'Mackerel', 'common', 0.858, 94, 0, '2026-03-09 19:04:06'),
(97, 10, 'Sardine', 'common', 0.39, 66, 0, '2026-03-09 19:04:27'),
(98, 10, 'Mackerel', 'common', 1.061, 105, 0, '2026-03-09 19:05:13'),
(99, 10, 'Mackerel', 'common', 0.746, 88, 0, '2026-03-09 19:41:58'),
(100, 10, 'Sardine', 'common', 0.484, 74, 0, '2026-03-09 20:20:11'),
(101, 10, 'Sardine', 'common', 0.229, 52, 0, '2026-03-09 20:20:34'),
(102, 10, 'Mackerel', 'common', 0.994, 101, 0, '2026-03-09 20:21:45'),
(103, 10, 'Mackerel', 'common', 0.901, 96, 0, '2026-03-09 20:22:05'),
(104, 10, 'Mackerel', 'common', 0.915, 97, 0, '2026-03-09 20:22:26'),
(105, 10, 'Mackerel', 'common', 0.712, 86, 0, '2026-03-09 21:25:57'),
(106, 10, 'Sardine', 'common', 0.355, 63, 0, '2026-03-09 21:35:43'),
(107, 10, 'Sardine', 'common', 0.475, 73, 0, '2026-03-09 21:41:24'),
(108, 10, 'Sardine', 'common', 0.444, 70, 0, '2026-03-09 22:04:51'),
(109, 10, 'Mackerel', 'common', 0.535, 77, 0, '2026-03-09 22:07:00'),
(110, 10, 'Mackerel', 'common', 1.161, 110, 0, '2026-03-09 22:09:52'),
(111, 10, 'Sardine', 'common', 0.312, 59, 0, '2026-03-09 22:15:10'),
(112, 10, 'Sardine', 'common', 0.283, 57, 0, '2026-03-09 22:19:45'),
(113, 10, 'Mackerel', 'common', 0.9, 96, 0, '2026-03-10 05:44:08'),
(114, 10, 'Mackerel', 'common', 1.108, 108, 0, '2026-03-10 05:46:07'),
(115, 10, 'Mackerel', 'common', 1.134, 109, 0, '2026-03-10 05:51:55'),
(116, 10, 'Mackerel', 'common', 0.557, 78, 0, '2026-03-10 06:31:46'),
(117, 10, 'Sardine', 'common', 0.299, 58, 0, '2026-03-10 06:32:18'),
(118, 10, 'Mackerel', 'common', 0.569, 79, 0, '2026-03-10 06:45:14'),
(119, 10, 'Mackerel', 'common', 0.608, 81, 0, '2026-03-10 06:45:32'),
(120, 10, 'Mackerel', 'common', 0.64, 82, 0, '2026-03-10 06:55:51'),
(121, 10, 'Sardine', 'common', 0.478, 73, 0, '2026-03-10 06:56:10'),
(122, 10, 'Sardine', 'common', 0.257, 55, 0, '2026-03-10 06:56:33'),
(123, 10, 'Mackerel', 'common', 0.601, 80, 0, '2026-03-10 06:56:48'),
(124, 10, 'Sardine', 'common', 0.223, 52, 0, '2026-03-10 06:57:04'),
(125, 10, 'Sardine', 'common', 0.457, 71, 0, '2026-03-10 06:57:21'),
(126, 10, 'Snapper', 'uncommon', 2.04, 204, 0, '2026-03-10 06:57:44'),
(127, 10, 'Sardine', 'common', 0.499, 75, 0, '2026-03-10 06:58:02'),
(128, 10, 'Grouper', 'rare', 5.305, 492, 0, '2026-03-10 07:06:17'),
(129, 10, 'Sardine', 'common', 0.462, 72, 0, '2026-03-10 07:06:42'),
(130, 10, 'Mackerel', 'common', 1.163, 111, 0, '2026-03-10 07:07:08'),
(131, 10, 'Sardine', 'common', 0.412, 68, 0, '2026-03-10 07:07:24'),
(132, 10, 'Sardine', 'common', 0.396, 66, 0, '2026-03-10 07:10:26'),
(133, 10, 'Mackerel', 'common', 0.576, 79, 0, '2026-03-10 07:17:53'),
(134, 10, 'Sardine', 'common', 0.292, 58, 0, '2026-03-10 07:22:12'),
(135, 10, 'Sardine', 'common', 0.278, 57, 0, '2026-03-10 07:22:38'),
(136, 10, 'Sardine', 'common', 0.478, 73, 0, '2026-03-10 07:28:33'),
(137, 10, 'Mackerel', 'common', 0.81, 92, 0, '2026-03-10 07:28:56'),
(138, 10, 'Mackerel', 'common', 0.689, 85, 0, '2026-03-10 07:32:20'),
(139, 10, 'Grouper', 'rare', 5.32, 493, 0, '2026-03-10 07:32:39'),
(140, 10, 'Sea Bass', 'uncommon', 2.99, 225, 0, '2026-03-10 07:35:42'),
(141, 10, 'Mackerel', 'common', 0.527, 76, 0, '2026-03-10 07:35:58'),
(142, 10, 'Mackerel', 'common', 0.84, 93, 0, '2026-03-10 07:36:46'),
(143, 10, 'Sardine', 'common', 0.403, 67, 0, '2026-03-10 07:37:02'),
(144, 10, 'Snapper', 'uncommon', 2.144, 209, 0, '2026-03-10 07:37:16'),
(145, 10, 'Sardine', 'common', 0.343, 62, 0, '2026-03-10 07:37:38'),
(146, 10, 'Sardine', 'common', 0.412, 68, 0, '2026-03-10 07:37:54'),
(147, 10, 'Mackerel', 'common', 0.706, 86, 0, '2026-03-10 07:38:12'),
(148, 10, 'Mackerel', 'common', 1.124, 108, 0, '2026-03-10 07:42:54'),
(149, 10, 'Mackerel', 'common', 0.74, 88, 0, '2026-03-10 07:43:06'),
(150, 10, 'Mackerel', 'common', 0.749, 88, 0, '2026-03-10 07:43:22'),
(151, 10, 'Sardine', 'common', 0.21, 51, 0, '2026-03-10 08:01:50'),
(152, 10, 'Sardine', 'common', 0.389, 66, 0, '2026-03-10 08:03:10'),
(153, 10, 'Sea Bass', 'uncommon', 2.362, 201, 0, '2026-03-10 08:03:25'),
(154, 10, 'Mackerel', 'common', 0.968, 100, 0, '2026-03-10 08:04:04'),
(155, 10, 'Mackerel', 'common', 1.008, 102, 0, '2026-03-10 08:04:19'),
(156, 10, 'Sea Bass', 'uncommon', 1.418, 166, 0, '2026-03-10 08:04:33'),
(157, 10, 'Snapper', 'uncommon', 2.428, 222, 0, '2026-03-10 08:04:50'),
(158, 10, 'Mackerel', 'common', 0.599, 80, 0, '2026-03-10 08:11:31'),
(159, 10, 'Sardine', 'common', 0.454, 71, 0, '2026-03-10 08:13:45'),
(160, 10, 'Sardine', 'common', 0.464, 72, 0, '2026-03-10 08:14:01'),
(161, 10, 'Mackerel', 'common', 0.968, 100, 0, '2026-03-10 08:14:15'),
(162, 10, 'Mackerel', 'common', 0.842, 93, 0, '2026-03-10 08:14:53'),
(163, 10, 'Mackerel', 'common', 0.887, 96, 0, '2026-03-10 10:15:19'),
(164, 10, 'Sardine', 'common', 0.309, 59, 0, '2026-03-10 10:15:41'),
(165, 10, 'Mackerel', 'common', 0.556, 78, 0, '2026-03-10 10:33:51'),
(166, 10, 'Mackerel', 'common', 0.592, 80, 0, '2026-03-10 10:34:06'),
(167, 10, 'Sardine', 'common', 0.352, 63, 0, '2026-03-10 10:36:58'),
(168, 10, 'Mackerel', 'common', 0.779, 90, 0, '2026-03-10 10:46:49'),
(169, 10, 'Mackerel', 'common', 0.637, 82, 0, '2026-03-10 10:49:11'),
(170, 10, 'Sardine', 'common', 0.297, 58, 0, '2026-03-10 12:49:38'),
(171, 10, 'Sardine', 'common', 0.499, 75, 0, '2026-03-10 12:50:57'),
(172, 10, 'Mackerel', 'common', 0.633, 82, 0, '2026-03-10 12:51:25'),
(173, 10, 'Mackerel', 'common', 0.652, 83, 0, '2026-03-10 12:53:11'),
(174, 10, 'Sardine', 'common', 0.201, 50, 0, '2026-03-10 17:42:09'),
(175, 10, 'Sardine', 'common', 0.27, 56, 0, '2026-03-10 18:56:44'),
(176, 10, 'Mackerel', 'common', 1.019, 103, 0, '2026-03-10 18:57:03'),
(177, 10, 'Mackerel', 'common', 0.676, 84, 0, '2026-03-10 18:57:24'),
(178, 10, 'Sea Bass', 'uncommon', 2.096, 191, 0, '2026-03-10 18:57:41'),
(179, 10, 'Mackerel', 'common', 0.643, 83, 0, '2026-03-10 18:58:25'),
(180, 10, 'Sardine', 'common', 0.477, 73, 0, '2026-03-11 12:19:39'),
(181, 10, 'Sardine', 'common', 0.356, 63, 0, '2026-03-13 16:38:36'),
(182, 10, 'Sardine', 'common', 0.238, 53, 0, '2026-03-13 16:38:56'),
(183, 10, 'Sardine', 'common', 0.489, 74, 0, '2026-03-13 16:39:24'),
(184, 10, 'Sardine', 'common', 0.383, 65, 0, '2026-03-13 16:39:42'),
(185, 10, 'Sardine', 'common', 0.256, 55, 0, '2026-03-13 16:39:56'),
(186, 10, 'Sardine', 'common', 0.289, 57, 0, '2026-03-13 16:40:24'),
(187, 10, 'Sardine', 'common', 0.399, 67, 0, '2026-03-13 16:41:14'),
(188, 10, 'Mackerel', 'common', 0.996, 102, 0, '2026-03-13 16:41:36'),
(189, 10, 'Mackerel', 'common', 1.196, 112, 0, '2026-03-13 16:41:56'),
(190, 10, 'Carp', 'common', 1.224, 84, 0, '2026-03-13 16:45:12'),
(191, 10, 'Catfish', 'common', 0.846, 61, 0, '2026-03-13 16:48:33'),
(192, 10, 'Trout', 'uncommon', 2.037, 155, 0, '2026-03-13 16:49:18'),
(193, 10, 'Catfish', 'common', 1.549, 79, 0, '2026-03-13 16:49:33'),
(194, 10, 'Catfish', 'common', 1.134, 68, 0, '2026-03-13 16:49:49'),
(195, 10, 'Carp', 'common', 2.436, 109, 0, '2026-03-13 16:50:09'),
(196, 10, 'Catfish', 'common', 0.894, 62, 0, '2026-03-13 16:50:27'),
(197, 10, 'Sea Bass', 'uncommon', 1.322, 162, 0, '2026-03-14 17:55:48'),
(198, 10, 'Sardine', 'common', 0.325, 60, 0, '2026-03-14 17:57:01'),
(199, 10, 'Grouper', 'rare', 6.73, 549, 0, '2026-03-14 17:57:35'),
(200, 10, 'Mackerel', 'common', 0.678, 85, 0, '2026-03-14 18:01:12'),
(201, 10, 'Mackerel', 'common', 1.024, 103, 0, '2026-03-14 18:05:06'),
(202, 10, 'Sea Bass', 'uncommon', 2.266, 197, 0, '2026-03-14 18:07:18'),
(203, 10, 'Mackerel', 'common', 0.98, 101, 0, '2026-03-14 18:22:23'),
(204, 10, 'Mackerel', 'common', 1.071, 106, 0, '2026-03-14 18:22:56'),
(205, 10, 'Sardine', 'common', 0.39, 66, 0, '2026-03-14 18:23:18'),
(206, 10, 'Sardine', 'common', 0.241, 53, 0, '2026-03-14 18:23:58'),
(207, 10, 'Sardine', 'common', 0.46, 72, 0, '2026-03-14 18:24:15'),
(208, 10, 'Sardine', 'common', 0.443, 70, 0, '2026-03-14 18:24:37'),
(209, 10, 'Sardine', 'common', 0.243, 54, 0, '2026-03-14 18:24:59'),
(210, 10, 'Sardine', 'common', 0.33, 61, 0, '2026-03-14 18:28:30'),
(211, 10, 'Sardine', 'common', 0.306, 59, 0, '2026-03-14 18:29:15'),
(212, 10, 'Grouper', 'rare', 7.645, 586, 0, '2026-03-14 18:30:14'),
(213, 10, 'Sardine', 'common', 0.201, 50, 0, '2026-03-14 18:49:10'),
(214, 10, 'Sea Bass', 'uncommon', 1.104, 154, 0, '2026-03-14 19:07:53'),
(215, 10, 'Sardine', 'common', 0.216, 51, 0, '2026-03-14 19:08:07'),
(216, 10, 'Sardine', 'common', 0.448, 71, 0, '2026-03-14 19:08:22'),
(217, 10, 'Sardine', 'common', 0.399, 67, 0, '2026-03-14 19:08:43'),
(218, 10, 'Tuna', 'common', 8.18, 232, 0, '2026-03-14 19:25:22'),
(219, 10, 'Bonito', 'common', 6.1, 210, 0, '2026-03-14 19:25:51'),
(220, 10, 'Bonito', 'common', 6.205, 211, 0, '2026-03-14 19:26:16'),
(221, 10, 'Tuna', 'common', 6.9, 219, 0, '2026-03-14 19:26:36'),
(222, 10, 'Tuna', 'common', 6.19, 212, 0, '2026-03-14 19:27:19'),
(223, 10, 'Tuna', 'common', 11.22, 262, 0, '2026-03-14 19:30:37'),
(224, 10, 'Bonito', 'common', 5.315, 197, 0, '2026-03-14 19:31:20'),
(225, 10, 'Bonito', 'common', 6.525, 216, 0, '2026-03-14 19:31:37'),
(226, 10, 'Sailfish', 'rare', 25.855, 909, 0, '2026-03-14 19:31:55'),
(227, 10, 'Bonito', 'common', 4.46, 183, 0, '2026-03-14 19:32:16'),
(228, 10, 'Bonito', 'common', 3.985, 176, 0, '2026-03-14 19:32:34'),
(229, 10, 'Tuna', 'common', 8.08, 231, 0, '2026-03-14 19:32:48'),
(230, 10, 'Tuna', 'common', 11.93, 269, 0, '2026-03-14 19:33:07'),
(231, 10, 'Tuna', 'common', 13.88, 289, 0, '2026-03-14 19:33:22'),
(232, 10, 'Bonito', 'common', 3.78, 172, 0, '2026-03-14 19:34:45'),
(233, 10, 'Tuna', 'common', 11.7, 267, 0, '2026-03-14 19:35:04'),
(234, 10, 'Tuna', 'common', 5.23, 202, 0, '2026-03-14 19:35:33'),
(235, 10, 'Tuna', 'common', 11.9, 269, 0, '2026-03-14 19:35:49'),
(236, 10, 'Bonito', 'common', 7.8, 237, 0, '2026-03-14 19:36:05'),
(237, 10, 'Swordfish', 'rare', 66.95, 1369, 0, '2026-03-14 19:36:19'),
(238, 10, 'Bonito', 'common', 3.45, 167, 0, '2026-03-14 19:36:50'),
(239, 10, 'Bonito', 'common', 4.62, 186, 0, '2026-03-14 19:37:26');

-- --------------------------------------------------------

--
-- Table structure for table `fishing_tournament_history`
--

CREATE TABLE `fishing_tournament_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `tournament_type` enum('biggest','most','rarest') NOT NULL,
  `winner_id` int(10) UNSIGNED NOT NULL,
  `winner_name` varchar(24) NOT NULL,
  `winner_score` float NOT NULL,
  `start_time` int(10) UNSIGNED NOT NULL,
  `end_time` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Fishing tournament winners history';

-- --------------------------------------------------------

--
-- Table structure for table `fishing_zones`
--

CREATE TABLE `fishing_zones` (
  `id` int(11) NOT NULL,
  `zone_name` varchar(64) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `radius` float NOT NULL DEFAULT 50,
  `zone_type` enum('Beach','River','Lake','Deep Sea') NOT NULL DEFAULT 'Lake',
  `time_bonus` enum('morning','afternoon','evening','night','none') DEFAULT 'none',
  `turf_id` int(11) DEFAULT -1,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fishing_zones`
--

INSERT INTO `fishing_zones` (`id`, `zone_name`, `pos_x`, `pos_y`, `pos_z`, `radius`, `zone_type`, `time_bonus`, `turf_id`, `created_by`, `created_at`, `updated_at`, `is_active`) VALUES
(1, 'Waikiki Beach', 1063.73, -2709.5, -0.425, 150, 'Beach', 'morning', -1, 10, '2026-03-08 15:34:41', '2026-03-08 16:31:07', 1),
(2, 'New Fishing Zone', 200.671, 380.691, -18.984, 50, 'River', 'none', -1, 10, '2026-03-08 16:18:21', '2026-03-08 16:21:15', 0),
(3, 'Arcos El Rio', 196.357, 381.403, -0.434, 150, 'River', 'afternoon', -1, 10, '2026-03-08 16:20:13', '2026-03-08 19:23:03', 1),
(5, 'Santa Maria Beach', 457.31, -2236.23, -0.429414, 130, 'Beach', 'evening', -1, 10, '2026-03-09 08:17:12', '2026-03-09 10:39:52', 1),
(9, 'Deepiero', -1376.47, 222.925, -0.503462, 100, 'Deep Sea', 'night', -1, 10, '2026-03-14 19:16:31', '2026-03-14 19:18:05', 1);

-- --------------------------------------------------------

--
-- Table structure for table `flags`
--

CREATE TABLE `flags` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `flaggedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fuelstation`
--

CREATE TABLE `fuelstation` (
  `fuelstationid` int(12) NOT NULL,
  `fuelstationmodel` int(12) DEFAULT 980,
  `fuelstationx` float DEFAULT 0,
  `fuelstationy` float DEFAULT 0,
  `fuelstationz` float DEFAULT 0,
  `fuelstationrx` float DEFAULT 0,
  `fuelstationry` float DEFAULT 0,
  `fuelstationrz` float DEFAULT 0,
  `fuelstationinterior` int(12) DEFAULT 0,
  `fuelstationworld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `fuelstation`
--

INSERT INTO `fuelstation` (`fuelstationid`, `fuelstationmodel`, `fuelstationx`, `fuelstationy`, `fuelstationz`, `fuelstationrx`, `fuelstationry`, `fuelstationrz`, `fuelstationinterior`, `fuelstationworld`) VALUES
(352, 3465, 1941.76, -1768.82, 13.6028, 0, 0, 358.64, 0, 0),
(354, 3465, 1941.84, -1777.01, 13.6028, 0, 0, 358.603, 0, 0),
(357, 3465, 998.022, -937.667, 42.1809, -0.2, -1.2, -81.6828, 0, 0),
(358, 3465, 1004.89, -936.724, 42.1795, 0, 0, -77.6602, 0, 0),
(359, 3465, 1009.75, -935.944, 42.1795, 0, -0.1, -84.5, 0, 0),
(360, 3465, 1002.84, -936.995, 42.1767, 1.0999, -1.1999, 98.3348, 0, 0),
(369, 3465, 2219.12, -2665.62, 13.9109, 0, 0, 176.343, 0, 0),
(370, 3465, 656.611, -558.531, 16.3358, 0, 0, 265.266, 0, 0),
(371, 3465, 657.416, -570.64, 16.3358, 0, 0, 259.546, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `id` int(10) NOT NULL,
  `houseid` int(10) DEFAULT NULL,
  `modelid` smallint(5) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `price` int(10) DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `interior` tinyint(2) DEFAULT NULL,
  `world` int(10) DEFAULT NULL,
  `door_opened` tinyint(1) DEFAULT 0,
  `door_locked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gangranks`
--

CREATE TABLE `gangranks` (
  `id` tinyint(2) DEFAULT NULL,
  `rank` tinyint(2) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gangs`
--

CREATE TABLE `gangs` (
  `id` tinyint(2) DEFAULT NULL,
  `name` varchar(32) DEFAULT 'None',
  `motd` varchar(128) DEFAULT 'None',
  `leader` varchar(24) DEFAULT 'No-one',
  `color` int(10) DEFAULT -256,
  `strikes` tinyint(1) DEFAULT 0,
  `reason1` varchar(328) DEFAULT 'None',
  `reason2` varchar(328) DEFAULT 'None',
  `reason3` varchar(328) DEFAULT 'None',
  `level` tinyint(2) DEFAULT 1,
  `points` int(10) DEFAULT 0,
  `turftokens` int(10) DEFAULT 0,
  `stash_x` float DEFAULT 0,
  `stash_y` float DEFAULT 0,
  `stash_z` float DEFAULT 0,
  `stashinterior` tinyint(2) DEFAULT 0,
  `stashworld` int(10) DEFAULT 0,
  `cash` int(10) DEFAULT 0,
  `materials` int(10) DEFAULT 0,
  `pot` int(10) DEFAULT 0,
  `crack` int(10) DEFAULT 0,
  `meth` int(10) DEFAULT 0,
  `painkillers` int(10) DEFAULT 0,
  `pistolammo` int(10) DEFAULT 0,
  `shotgunammo` int(10) DEFAULT 0,
  `smgammo` int(10) DEFAULT 0,
  `arammo` int(10) DEFAULT 0,
  `rifleammo` int(10) DEFAULT 0,
  `hpammo` int(10) DEFAULT 0,
  `poisonammo` int(10) DEFAULT 0,
  `fmjammo` int(10) DEFAULT 0,
  `weapon_0` tinyint(2) DEFAULT 0,
  `weapon_1` tinyint(2) DEFAULT 0,
  `weapon_2` tinyint(2) DEFAULT 0,
  `weapon_3` tinyint(2) DEFAULT 0,
  `weapon_4` tinyint(2) DEFAULT 0,
  `weapon_5` tinyint(2) DEFAULT 0,
  `weapon_6` tinyint(2) DEFAULT 0,
  `weapon_7` tinyint(2) DEFAULT 0,
  `weapon_8` tinyint(2) DEFAULT 0,
  `weapon_9` tinyint(2) DEFAULT 0,
  `weapon_10` tinyint(2) DEFAULT 0,
  `weapon_11` tinyint(4) DEFAULT 0,
  `weapon_12` tinyint(4) DEFAULT 0,
  `weapon_13` tinyint(4) DEFAULT 0,
  `weapon_14` tinyint(4) DEFAULT 0,
  `ammo_0` int(5) DEFAULT 0,
  `ammo_1` int(5) DEFAULT 0,
  `ammo_2` int(5) DEFAULT 0,
  `ammo_3` int(5) DEFAULT 0,
  `ammo_4` int(5) DEFAULT 0,
  `ammo_5` int(5) DEFAULT 0,
  `ammo_6` int(5) DEFAULT 0,
  `ammo_7` int(5) DEFAULT 0,
  `ammo_8` int(5) DEFAULT 0,
  `ammo_9` int(5) DEFAULT 0,
  `ammo_10` int(5) DEFAULT 0,
  `ammo_11` int(5) DEFAULT 0,
  `ammo_12` int(5) DEFAULT 0,
  `ammo_13` int(5) DEFAULT 0,
  `ammo_14` int(5) DEFAULT 0,
  `armsdealer` tinyint(1) DEFAULT 0,
  `drugdealer` tinyint(1) DEFAULT 0,
  `arms_x` float DEFAULT 0,
  `arms_y` float DEFAULT 0,
  `arms_z` float DEFAULT 0,
  `arms_a` float DEFAULT 0,
  `drug_x` float DEFAULT 0,
  `drug_y` float DEFAULT 0,
  `drug_z` float DEFAULT 0,
  `drug_a` float DEFAULT 0,
  `armsworld` int(10) DEFAULT 0,
  `drugworld` int(10) DEFAULT 0,
  `drugweed` int(10) DEFAULT 0,
  `drugcocaine` int(10) DEFAULT 0,
  `drugmeth` int(10) DEFAULT 0,
  `armsmaterials` int(10) DEFAULT 0,
  `armsprice_1` int(10) DEFAULT 0,
  `armsprice_2` int(10) DEFAULT 0,
  `armsprice_3` int(10) DEFAULT 0,
  `armsprice_4` int(10) DEFAULT 0,
  `armsprice_5` int(10) DEFAULT 0,
  `armsprice_6` int(10) DEFAULT 0,
  `armsprice_7` int(10) DEFAULT 0,
  `armsprice_8` int(10) DEFAULT 0,
  `weed_price` int(10) DEFAULT 0,
  `cocaine_price` int(10) DEFAULT 0,
  `meth_price` int(10) DEFAULT 0,
  `armshpammo` int(10) DEFAULT 0,
  `armspoisonammo` int(10) DEFAULT 0,
  `armsfmjammo` int(10) DEFAULT 0,
  `alliance` int(10) NOT NULL DEFAULT -1,
  `familychat` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gangskins`
--

CREATE TABLE `gangskins` (
  `id` tinyint(2) DEFAULT NULL,
  `slot` tinyint(2) DEFAULT NULL,
  `skinid` smallint(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `garages`
--

CREATE TABLE `garages` (
  `id` int(10) NOT NULL,
  `ownerid` int(10) DEFAULT 0,
  `owner` varchar(24) DEFAULT NULL,
  `type` tinyint(1) DEFAULT 0,
  `price` int(10) DEFAULT 0,
  `locked` tinyint(1) DEFAULT 0,
  `timestamp` int(10) DEFAULT 0,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `exit_x` float DEFAULT 0,
  `exit_y` float DEFAULT 0,
  `exit_z` float DEFAULT 0,
  `exit_a` float DEFAULT 0,
  `world` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gates`
--

CREATE TABLE `gates` (
  `gateID` int(12) NOT NULL,
  `gateModel` int(12) DEFAULT 980,
  `gateSpeed` float DEFAULT 0,
  `gateTime` int(12) DEFAULT 0,
  `gateX` float DEFAULT 0,
  `gateY` float DEFAULT 0,
  `gateZ` float DEFAULT 0,
  `gateRX` float DEFAULT 0,
  `gateRY` float DEFAULT 0,
  `gateRZ` float DEFAULT 0,
  `gateInterior` int(12) DEFAULT 0,
  `gateWorld` int(12) DEFAULT 0,
  `gateMoveX` float DEFAULT 0,
  `gateMoveY` float DEFAULT 0,
  `gateMoveZ` float DEFAULT 0,
  `gateMoveRX` float DEFAULT 0,
  `gateMoveRY` float DEFAULT 0,
  `gateMoveRZ` float DEFAULT 0,
  `gateLinkID` int(12) DEFAULT 0,
  `gateFaction` int(12) DEFAULT 0,
  `gatePass` varchar(32) DEFAULT NULL,
  `gateRadius` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gates`
--

INSERT INTO `gates` (`gateID`, `gateModel`, `gateSpeed`, `gateTime`, `gateX`, `gateY`, `gateZ`, `gateRX`, `gateRY`, `gateRZ`, `gateInterior`, `gateWorld`, `gateMoveX`, `gateMoveY`, `gateMoveZ`, `gateMoveRX`, `gateMoveRY`, `gateMoveRZ`, `gateLinkID`, `gateFaction`, `gatePass`, `gateRadius`) VALUES
(373, 980, 3, 0, 2769.58, -1900.75, 12.1217, 0, 0, -0.2021, 0, 0, 2769.58, -1900.75, 6.9917, 0, 0, -0.2021, -1, -1, 'Kyoto1', 5),
(375, 1569, 3, 0, 1726.77, 1460.41, 1144.72, 0, 0, 96.5162, 0, 0, 1726.77, 1460.41, 1144.72, 0, 0, -179.284, -1, -1, '', 5),
(376, 19325, 3, 0, 1715.57, -1642.76, 20.7563, 90, 0, 89.9147, 0, 0, 1718.74, -1642.76, 20.7563, 90, 0, 89.9147, -1, -1, '', 5),
(377, 985, 3, 0, 661.216, -1307.31, 14.1609, 0, 0, 179.943, 0, 0, 656.836, -1307.3, 14.1609, 0, 0, 179.943, 381, 9, '', 5),
(379, 985, 3, 0, 783.323, -1156.38, 24.1993, 0, 0, -90.0687, 0, 0, 783.318, -1160.41, 24.1993, 0, 0, -90.0687, 380, 9, '', 5),
(380, 986, 3, 0, 783.378, -1148.44, 24.1821, 0, 0, -90.7025, 0, 0, 783.43, -1144.24, 24.1821, 0, 0, -90.7025, 379, 9, '', 5),
(381, 986, 3, 0, 669.186, -1307.33, 14.1709, 0, 0, 179.863, 0, 0, 672.996, -1307.26, 14.1709, 0, 0, -179.636, 377, 9, '', 5),
(382, 985, 3, 0, 1718.03, -1604.46, 14.2368, 0, 0, 172.853, 0, 0, 1712.09, -1603.71, 14.2368, 0, 0, 172.853, 383, 8, '', 5),
(383, 986, 3, 0, 1725.9, -1605.65, 14.2468, 0, 0, 169.641, 0, 0, 1733.37, -1607.01, 14.2468, 0, 0, 169.641, 382, 8, '', 5),
(385, 980, 5, 0, 282.393, -1320.26, 55.4191, 0, 0, 33.485, 0, 0, 291.951, -1313.94, 55.4191, 0, 0, 33.485, 373, -1, '2003', 5),
(386, 1569, 20, 0, -458.891, 2206.19, 1600.1, 0, 0, 179.973, 0, 0, -457.411, 2206.19, 1600.1, 0, 0, 179.973, -1, 1, '', 2);

-- --------------------------------------------------------

--
-- Table structure for table `graffiti`
--

CREATE TABLE `graffiti` (
  `graffitiID` int(12) NOT NULL,
  `graffitiX` float DEFAULT 0,
  `graffitiY` float DEFAULT 0,
  `graffitiZ` float DEFAULT 0,
  `graffitiAngle` float DEFAULT 0,
  `graffitiColor` int(12) DEFAULT 0,
  `graffitiText` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `graffities`
--

CREATE TABLE `graffities` (
  `id` int(11) NOT NULL,
  `text` varchar(32) NOT NULL,
  `color` int(16) NOT NULL,
  `back_color` int(16) NOT NULL,
  `font` varchar(16) NOT NULL,
  `font_size` int(11) NOT NULL,
  `bold` int(11) NOT NULL,
  `creator` varchar(32) NOT NULL,
  `c_date` varchar(64) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `rotx` float NOT NULL,
  `roty` float NOT NULL,
  `rotz` float NOT NULL,
  `gotox` float NOT NULL,
  `gotoy` float NOT NULL,
  `gotoz` float NOT NULL,
  `interior` int(11) NOT NULL,
  `world` int(11) NOT NULL,
  `accepted` int(11) NOT NULL,
  `acceptor` varchar(32) NOT NULL,
  `a_date` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `greenzone`
--

CREATE TABLE `greenzone` (
  `id` int(10) NOT NULL,
  `min_x` float DEFAULT 0,
  `min_y` float DEFAULT 0,
  `max_x` float DEFAULT 0,
  `max_y` float DEFAULT 0,
  `height` float DEFAULT 0,
  `lx` float NOT NULL,
  `ly` float NOT NULL,
  `lz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `greenzone`
--

INSERT INTO `greenzone` (`id`, `min_x`, `min_y`, `max_x`, `max_y`, `height`, `lx`, `ly`, `lz`) VALUES
(52, 519.957, 811.998, 686.433, 931.025, -42.591, 589.892, 872.395, -42.497),
(53, -1191.3, -1149.27, -1070.62, -1076.85, 128.78, -1149.68, -1115.36, 128.272),
(54, 1704.54, -2431.11, 1747.68, -2393.49, 13.124, 1733.87, -2413.29, 13.555),
(57, 1438.68, -2298.85, 1450.67, -2276.72, 13.547, 1444.3, -2286.78, 13.547),
(61, 1240.71, -1319.46, 1266.22, -1278.31, 1062.2, 1240.71, -1277.92, 1061.15),
(62, 1146.25, -1386.48, 1247.85, -1290.09, 12.921, 1190.49, -1385.12, 13.354);

-- --------------------------------------------------------

--
-- Table structure for table `gunracks`
--

CREATE TABLE `gunracks` (
  `rackID` int(12) NOT NULL,
  `rackHouse` int(12) DEFAULT 0,
  `rackX` float DEFAULT 0,
  `rackY` float DEFAULT 0,
  `rackZ` float DEFAULT 0,
  `rackA` float DEFAULT 0,
  `rackInterior` int(12) DEFAULT 0,
  `rackWorld` int(12) DEFAULT 0,
  `rackWeapon1` int(12) DEFAULT 0,
  `rackAmmo1` int(12) DEFAULT 0,
  `rackWeapon2` int(12) DEFAULT 0,
  `rackAmmo2` int(12) DEFAULT 0,
  `rackWeapon3` int(12) DEFAULT 0,
  `rackAmmo3` int(12) DEFAULT 0,
  `rackWeapon4` int(12) DEFAULT 0,
  `rackAmmo4` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` int(10) NOT NULL,
  `ownerid` int(10) DEFAULT 0,
  `owner` varchar(24) DEFAULT 'Nobody',
  `name` varchar(64) DEFAULT NULL,
  `house_safepass` varchar(128) DEFAULT '',
  `house_safe` int(11) DEFAULT 0,
  `message` varchar(128) DEFAULT NULL,
  `type` tinyint(2) DEFAULT 0,
  `price` int(10) DEFAULT 0,
  `rentprice` int(10) DEFAULT 0,
  `level` tinyint(2) DEFAULT 0,
  `locked` tinyint(1) DEFAULT 0,
  `timestamp` int(10) DEFAULT 0,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `int_x` float DEFAULT 0,
  `int_y` float DEFAULT 0,
  `int_z` float DEFAULT 0,
  `int_a` float DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `outsideint` int(10) DEFAULT 0,
  `outsidevw` int(10) DEFAULT 0,
  `stash_x` float DEFAULT 0,
  `stash_y` float DEFAULT 0,
  `stash_z` float DEFAULT 0,
  `stashinterior` tinyint(2) DEFAULT 0,
  `stashworld` int(10) DEFAULT 0,
  `cash` int(10) DEFAULT 0,
  `materials` int(10) DEFAULT 0,
  `pot` int(10) DEFAULT 0,
  `crack` int(10) DEFAULT 0,
  `meth` int(10) DEFAULT 0,
  `painkillers` int(10) DEFAULT 0,
  `weapon_1` tinyint(2) DEFAULT 0,
  `weapon_2` tinyint(2) DEFAULT 0,
  `weapon_3` tinyint(2) DEFAULT 0,
  `weapon_4` tinyint(2) DEFAULT 0,
  `weapon_5` tinyint(2) DEFAULT 0,
  `weapon_6` tinyint(2) DEFAULT 0,
  `weapon_7` tinyint(2) DEFAULT 0,
  `weapon_8` tinyint(2) DEFAULT 0,
  `weapon_9` tinyint(2) DEFAULT 0,
  `weapon_10` tinyint(2) DEFAULT 0,
  `ammo_1` int(5) DEFAULT 0,
  `ammo_2` int(5) DEFAULT 0,
  `ammo_3` int(5) DEFAULT 0,
  `ammo_4` int(5) DEFAULT 0,
  `ammo_5` int(5) DEFAULT 0,
  `ammo_6` int(2) DEFAULT 0,
  `ammo_7` int(2) DEFAULT 0,
  `ammo_8` int(2) DEFAULT 0,
  `ammo_9` int(2) DEFAULT 0,
  `ammo_10` int(2) DEFAULT 0,
  `pistolammo` smallint(5) DEFAULT 0,
  `shotgunammo` smallint(5) DEFAULT 0,
  `smgammo` smallint(5) DEFAULT 0,
  `arammo` smallint(5) DEFAULT 0,
  `rifleammo` smallint(5) DEFAULT 0,
  `hpammo` smallint(5) DEFAULT 0,
  `poisonammo` smallint(5) DEFAULT 0,
  `fmjammo` smallint(5) DEFAULT 0,
  `robbed` smallint(6) NOT NULL DEFAULT 3,
  `robbing` int(11) NOT NULL DEFAULT 0,
  `lights` int(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `ownerid`, `owner`, `name`, `house_safepass`, `house_safe`, `message`, `type`, `price`, `rentprice`, `level`, `locked`, `timestamp`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `int_x`, `int_y`, `int_z`, `int_a`, `interior`, `world`, `outsideint`, `outsidevw`, `stash_x`, `stash_y`, `stash_z`, `stashinterior`, `stashworld`, `cash`, `materials`, `pot`, `crack`, `meth`, `painkillers`, `weapon_1`, `weapon_2`, `weapon_3`, `weapon_4`, `weapon_5`, `weapon_6`, `weapon_7`, `weapon_8`, `weapon_9`, `weapon_10`, `ammo_1`, `ammo_2`, `ammo_3`, `ammo_4`, `ammo_5`, `ammo_6`, `ammo_7`, `ammo_8`, `ammo_9`, `ammo_10`, `pistolammo`, `shotgunammo`, `smgammo`, `arammo`, `rifleammo`, `hpammo`, `poisonammo`, `fmjammo`, `robbed`, `robbing`, `lights`) VALUES
(1, 2, 'Ven_Spark', 'Ven\'s Mansion', '', 0, 'MGA BAHOG OTEN', 18, 14000000, 0, 0, 0, 1687139076, 298.272, -1337.58, 53.442, 34.296, 1298.87, -796.205, 1084.01, 0, 5, 1000001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(2, 1, 'Joma_Nuron', 'Ven Spark Mansion', '', 0, 'Ven pogi lang pwede dito fuck you', -1, 21000000, 0, 0, 0, 1709578363, 2878.48, -362.714, 7.204, 85.416, 1168.56, -204.893, 2027.67, 175.931, 0, 1000002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `keybind`
--

CREATE TABLE `keybind` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `btype` int(11) NOT NULL DEFAULT 0,
  `btext` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `keybind`
--

INSERT INTO `keybind` (`id`, `userid`, `bid`, `btype`, `btext`) VALUES
(1, 2, 0, 0, ''),
(2, 2, 1, 0, ''),
(3, 2, 2, 0, ''),
(4, 2, 3, 0, ''),
(5, 2, 4, 0, ''),
(6, 2, 5, 0, ''),
(7, 2, 6, 0, ''),
(8, 2, 7, 0, ''),
(9, 2, 8, 0, ''),
(10, 2, 9, 0, ''),
(11, 6, 0, 0, ''),
(12, 6, 1, 0, ''),
(13, 6, 2, 0, ''),
(14, 6, 3, 0, ''),
(15, 6, 4, 0, ''),
(16, 6, 5, 0, ''),
(17, 6, 6, 0, ''),
(18, 6, 7, 0, ''),
(19, 6, 8, 0, ''),
(20, 6, 9, 0, ''),
(21, 10, 0, 0, ''),
(22, 10, 1, 0, ''),
(23, 10, 2, 0, ''),
(24, 10, 3, 0, ''),
(25, 10, 4, 0, ''),
(26, 10, 5, 0, ''),
(27, 10, 6, 0, ''),
(28, 10, 7, 0, ''),
(29, 10, 8, 0, ''),
(30, 10, 9, 0, ''),
(31, 5, 0, 0, ''),
(32, 5, 1, 0, ''),
(33, 5, 2, 0, ''),
(34, 5, 3, 0, ''),
(35, 5, 4, 0, ''),
(36, 5, 5, 0, ''),
(37, 5, 6, 0, ''),
(38, 5, 7, 0, ''),
(39, 5, 8, 0, ''),
(40, 5, 9, 0, ''),
(41, 11, 0, 0, ''),
(42, 11, 1, 0, ''),
(43, 11, 2, 0, ''),
(44, 11, 3, 0, ''),
(45, 11, 4, 0, ''),
(46, 11, 5, 0, ''),
(47, 11, 6, 0, ''),
(48, 11, 7, 0, ''),
(49, 11, 8, 0, ''),
(50, 11, 9, 0, ''),
(51, 12, 0, 0, ''),
(52, 12, 1, 0, ''),
(53, 12, 2, 0, ''),
(54, 12, 3, 0, ''),
(55, 12, 4, 0, ''),
(56, 12, 5, 0, ''),
(57, 12, 6, 0, ''),
(58, 12, 7, 0, ''),
(59, 12, 8, 0, ''),
(60, 12, 9, 0, ''),
(61, 1, 0, 0, ''),
(62, 1, 1, 0, ''),
(63, 1, 2, 0, ''),
(64, 1, 3, 0, ''),
(65, 1, 4, 0, ''),
(66, 1, 5, 0, ''),
(67, 1, 6, 0, ''),
(68, 1, 7, 0, ''),
(69, 1, 8, 0, ''),
(70, 1, 9, 0, ''),
(71, 4, 0, 0, ''),
(72, 4, 1, 0, ''),
(73, 4, 2, 0, ''),
(74, 4, 3, 0, ''),
(75, 4, 4, 0, ''),
(76, 4, 5, 0, ''),
(77, 4, 6, 0, ''),
(78, 4, 7, 0, ''),
(79, 4, 8, 0, ''),
(80, 4, 9, 0, ''),
(81, 3, 0, 0, ''),
(82, 3, 1, 0, ''),
(83, 3, 2, 0, ''),
(84, 3, 3, 0, ''),
(85, 3, 4, 0, ''),
(86, 3, 5, 0, ''),
(87, 3, 6, 0, ''),
(88, 3, 7, 0, ''),
(89, 3, 8, 0, ''),
(90, 3, 9, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `kills`
--

CREATE TABLE `kills` (
  `id` int(10) NOT NULL,
  `killer_uid` int(10) DEFAULT NULL,
  `target_uid` int(10) DEFAULT NULL,
  `killer` varchar(24) DEFAULT NULL,
  `target` varchar(24) DEFAULT NULL,
  `reason` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `kills`
--

INSERT INTO `kills` (`id`, `killer_uid`, `target_uid`, `killer`, `target`, `reason`, `date`) VALUES
(1, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Colt 45', '2024-02-21 23:39:19'),
(2, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-02-21 23:40:15'),
(3, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-02-22 01:44:26'),
(4, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Shotgun', '2024-02-25 17:27:55'),
(5, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'MP5', '2024-03-02 23:43:15'),
(6, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-03 02:25:41'),
(7, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-03 02:25:51'),
(8, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-03 02:26:15'),
(9, 2, 1, 'Koy_Nuron', 'Joma_Nuron', 'Sniper', '2024-03-05 16:17:27'),
(10, 2, 1, 'Koy_Nuron', 'Joma_Nuron', 'MP5', '2024-03-05 16:20:39'),
(11, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Shotgun', '2024-03-05 16:21:16'),
(12, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-05 16:32:48'),
(13, 3, 4, 'Goro_Paciano', 'Tito_Badang', 'Deagle', '2024-03-08 20:26:06'),
(14, 4, 3, 'Muning', 'Goro_Paciano', 'AK-47', '2024-03-08 22:26:19'),
(15, 3, 4, 'Maxwell', 'Tito_Badang', 'AK-47', '2024-03-08 22:28:23'),
(16, 4, 3, 'Tito_Badang', 'Goro_Paciano', 'AK-47', '2024-03-08 22:35:16'),
(17, 4, 3, 'Tito_Badang', 'Goro_Paciano', 'AK-47', '2024-03-08 22:36:43'),
(18, 3, 4, 'Goro_Paciano', 'Tito_Badang', 'AK-47', '2024-03-08 22:37:43'),
(19, 4, 1, 'Muning', 'Stranger_0', 'AK-47', '2024-03-09 12:02:28'),
(20, 4, 1, 'Tito_Badang', 'Joma_Nuron', 'Mac-10', '2024-03-09 21:41:28'),
(21, 4, 3, 'Tito_Badang', 'Goro_Paciano', 'AK-47', '2024-03-09 22:32:53'),
(22, 3, 4, 'Goro_Paciano', 'Tito_Badang', 'Deagle', '2024-03-09 22:39:20'),
(23, 4, 3, 'Tito_Badang', 'Goro_Paciano', 'Knife', '2024-03-09 22:42:51'),
(24, 3, 4, 'Goro_Paciano', 'Tito_Badang', 'Deagle', '2024-03-09 22:44:00'),
(25, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-10 13:39:26'),
(26, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-03-15 00:06:53'),
(27, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-03-15 09:02:57'),
(28, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-03-15 09:08:48'),
(29, 2, 1, 'Koy_Nuron', 'Joma_Nuron', 'Deagle', '2024-03-15 09:36:44'),
(30, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'AK-47', '2024-03-15 09:41:25'),
(31, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-15 09:45:27'),
(32, 2, 1, 'Koy_Nuron', 'Joma_Nuron', 'Sniper', '2024-03-20 20:13:12'),
(33, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-03-20 20:16:03'),
(34, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-03-20 21:40:04'),
(35, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-21 09:09:56'),
(36, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Sniper', '2024-03-21 09:16:25'),
(37, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Deagle', '2024-03-21 09:26:37'),
(38, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Deagle', '2024-03-21 09:31:27'),
(39, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'AK-47', '2024-03-22 00:54:38'),
(40, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'M4', '2024-03-22 01:09:04'),
(41, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Deagle', '2024-03-22 01:20:05'),
(42, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Deagle', '2024-03-22 01:23:03'),
(43, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'AK-47', '2024-03-22 08:27:45'),
(44, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Shotgun', '2024-03-22 09:10:33'),
(45, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'Deagle', '2024-03-22 09:17:35'),
(46, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'AK-47', '2024-03-22 09:20:46'),
(47, 1, 2, 'Joma_Nuron', 'Koy_Nuron', 'AK-47', '2024-03-22 10:33:28');

-- --------------------------------------------------------

--
-- Table structure for table `label`
--

CREATE TABLE `label` (
  `id` int(10) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `iconid` smallint(5) DEFAULT 1239,
  `type` smallint(5) DEFAULT 0,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `label`
--

INSERT INTO `label` (`id`, `name`, `iconid`, `type`, `pos_x`, `pos_y`, `pos_z`, `interior`, `world`) VALUES
(304, 'OFFICE OF THE MAYOR', 1210, 0, -1857.54, 2867.3, 760.77, 0, 4),
(305, 'OFFICE OF THE VICE MAYOR', 1210, 0, -1857.53, 2880.6, 760.77, 0, 4),
(308, 'UGH', 1239, 0, 364.843, -2060.43, 15.398, 0, 0),
(313, 'Press \"Y\" to EXIT', 19300, 1, 1266.34, -1291.5, 1061.15, 0, 2),
(314, 'Press ( Y ) to EXIT', 1239, 1, 770.868, -1109.8, -43.262, 0, 7),
(315, 'Press ( Y ) to EXIT', 1239, 2, 2319.01, -1786.6, 1600.75, 0, 6),
(316, 'PRESS ( Y ) TO EXIT', 1239, 2, 1206.6, -1314.35, 796.788, 0, 0),
(317, 'PRESS ( Y ) TO GO BACK', 1239, 2, 1565.3, -1665.75, 28.396, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `landobjects`
--

CREATE TABLE `landobjects` (
  `id` int(10) NOT NULL,
  `landid` int(10) DEFAULT NULL,
  `modelid` smallint(5) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `price` int(10) DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `door_opened` tinyint(1) DEFAULT 0,
  `door_locked` tinyint(1) DEFAULT 0,
  `move_x` float DEFAULT 0,
  `move_y` float DEFAULT 0,
  `move_z` float DEFAULT 0,
  `move_rx` float DEFAULT 0,
  `move_ry` float DEFAULT 0,
  `move_rz` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `landobjects`
--

INSERT INTO `landobjects` (`id`, `landid`, `modelid`, `name`, `price`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`, `door_opened`, `door_locked`, `move_x`, `move_y`, `move_z`, `move_rx`, `move_ry`, `move_rz`) VALUES
(1157, 40, 19377, 'wall025', 100, 2207.16, -2135.27, 16.881, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1158, 40, 19377, 'wall025', 100, 2199.73, -2127.85, 16.753, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1159, 40, 19377, 'wall025', 100, 2192.42, -2120.31, 16.625, -89.3, -2, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1160, 40, 19377, 'wall025', 100, 2185.22, -2112.67, 16.497, -89.3, -2, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1161, 40, 19377, 'wall025', 100, 2177.73, -2105.37, 16.37, -89.3, -6.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1162, 40, 19377, 'wall025', 100, 2170.12, -2098.16, 16.243, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1163, 40, 19377, 'wall025', 100, 2162.71, -2090.74, 16.115, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1164, 40, 19377, 'wall025', 100, 2155.29, -2083.31, 15.987, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1165, 40, 19377, 'wall025', 100, 2222.1, -2089.99, 16.815, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1166, 40, 19377, 'wall025', 100, 2147.86, -2075.87, 15.858, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1167, 40, 19377, 'wall025', 100, 2140.43, -2068.43, 15.73, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1168, 40, 19377, 'wall025', 100, 2236.94, -2104.7, 16.978, -90.5, -4.3, -138.926, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1169, 40, 19377, 'wall025', 100, 2125.62, -2053.6, 15.474, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1170, 40, 19377, 'wall025', 100, 2118.2, -2046.17, 15.346, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1171, 40, 19377, 'wall025', 100, 2110.78, -2038.74, 15.218, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1172, 40, 19377, 'wall025', 100, 2110.97, -2031.61, 15.154, -89.3, -90.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1173, 40, 19377, 'wall025', 100, 2118.78, -2024.59, 15.152, -89.3, -90.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1174, 40, 19377, 'wall025', 100, 2126.58, -2017.57, 15.18, -89.3, -90.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1175, 40, 19377, 'wall025', 100, 2229.53, -2097.4, 16.943, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1176, 40, 19377, 'wall025', 100, 2134.38, -2010.57, 15.178, -89.3, -90.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1177, 40, 19377, 'wall025', 100, 2229.53, -2097.4, 16.943, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1178, 40, 19377, 'wall025', 100, 2142.13, -2003.61, 15.176, -89.3, -90.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1179, 40, 19377, 'wall025', 100, 2133.01, -2061.01, 15.602, -89.3, -3.7, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1180, 40, 19377, 'wall025', 100, 2214.96, -2082.86, 16.692, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1181, 40, 19377, 'wall025', 100, 2207.53, -2075.45, 16.564, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1182, 40, 19377, 'wall025', 100, 2200.1, -2068.04, 16.436, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1183, 40, 19377, 'wall025', 100, 2192.68, -2060.64, 16.308, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1184, 40, 19377, 'wall025', 100, 2185.29, -2053.26, 16.181, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1185, 40, 19376, 'wall024', 100, 2227.15, -2108.28, 12.462, 0, 89.9, -135.868, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1186, 40, 19377, 'wall025', 100, 2177.87, -2045.86, 16.053, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1188, 40, 19377, 'wall025', 100, 2170.44, -2038.45, 15.925, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1189, 40, 19377, 'wall025', 100, 2163.04, -2031.07, 15.798, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1190, 40, 19377, 'wall025', 100, 2155.61, -2023.66, 15.67, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1191, 40, 19377, 'wall025', 100, 2148.23, -2016.29, 15.543, -89.3, -3.8, -138.726, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1192, 40, 19325, 'Big window', 100, 2238.31, -2110.56, 14.539, 0, 0.6, -47.251, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1193, 40, 19376, 'wall024', 100, 2227.15, -2108.28, 12.462, 0, 89.9, -135.868, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1194, 40, 19377, 'wall025', 100, 2140.99, -2008.95, 15.407, -89.3, -3.8, -139.526, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1195, 40, 19325, 'Big window', 100, 2233.44, -2115.07, 14.539, 0, 0.6, -47.251, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1196, 40, 19376, 'wall024', 100, 2219.62, -2115.59, 12.48, 0, 89.9, -135.868, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1197, 40, 19376, 'wall024', 100, 2212.09, -2122.89, 12.498, 0, 89.9, -135.868, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1198, 40, 19325, 'Big window', 100, 2228.57, -2119.58, 14.539, 0, 0.6, -47.251, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1199, 40, 19376, 'wall024', 100, 2212.09, -2122.89, 12.498, 0, 89.9, -135.868, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1200, 40, 19325, 'Big window', 100, 2223.7, -2124.08, 14.539, 0, 0.6, -47.251, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1201, 40, 19325, 'Big window', 100, 2218.83, -2128.58, 14.539, 0, 0.6, -47.251, 0, 0, 0, 0, 0, -1000, -1000, -1000),
(1202, 40, 19325, 'Big window', 100, 2211.71, -2135.16, 14.539, 0, 0.6, -47.251, 0, 0, 0, 0, 0, -1000, -1000, -1000);

-- --------------------------------------------------------

--
-- Table structure for table `lands`
--

CREATE TABLE `lands` (
  `id` int(10) NOT NULL,
  `ownerid` int(10) DEFAULT 0,
  `owner` varchar(24) DEFAULT 'Nobody',
  `level` tinyint(2) DEFAULT 0,
  `price` int(10) DEFAULT 0,
  `min_x` float DEFAULT 0,
  `min_y` float DEFAULT 0,
  `max_x` float DEFAULT 0,
  `max_y` float DEFAULT 0,
  `height` float DEFAULT 0,
  `lx` float NOT NULL,
  `ly` float NOT NULL,
  `lz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lastdo`
--

CREATE TABLE `lastdo` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(328) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `lastdo`
--

INSERT INTO `lastdo` (`id`, `uid`, `date`, `description`) VALUES
(1, 3, '2024-03-09 22:03:50', 'chinupa');

-- --------------------------------------------------------

--
-- Table structure for table `lastme`
--

CREATE TABLE `lastme` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(328) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `lastme`
--

INSERT INTO `lastme` (`id`, `uid`, `date`, `description`) VALUES
(1, 1, '2024-02-21 22:36:33', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(2, 1, '2024-02-21 23:36:45', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(3, 1, '2024-02-21 23:39:15', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(4, 1, '2024-02-21 23:40:12', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(5, 1, '2024-02-22 01:35:05', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(6, 1, '2024-02-22 01:44:23', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(7, 1, '2024-02-22 01:45:38', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(8, 1, '2024-02-22 01:51:53', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(9, 1, '2024-03-09 21:52:55', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(10, 1, '2024-03-09 22:02:33', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(11, 1, '2024-03-10 13:35:57', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(12, 1, '2024-03-10 13:38:17', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(13, 1, '2024-03-14 23:42:45', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(14, 1, '2024-03-15 00:05:26', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(15, 1, '2024-03-15 08:11:31', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(16, 1, '2024-03-15 08:48:36', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(17, 1, '2024-03-15 09:02:05', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(18, 1, '2024-03-15 09:31:44', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(19, 1, '2024-03-15 09:40:22', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(20, 1, '2024-03-15 09:40:29', 'took his/her weapon from his/her backspine flicks the safety to [OFF] and ready to shoot any time.'),
(21, 1, '2026-03-06 02:53:41', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(22, 1, '2026-03-06 02:53:43', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(23, 1, '2026-03-06 02:53:44', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(24, 1, '2026-03-06 02:56:46', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(25, 1, '2026-03-06 02:57:58', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(26, 1, '2026-03-06 03:14:47', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(27, 1, '2026-03-06 03:27:39', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(28, 1, '2026-03-06 14:20:22', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(29, 1, '2026-03-06 14:20:23', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(30, 1, '2026-03-06 17:50:37', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(31, 1, '2026-03-07 22:30:23', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(32, 1, '2026-03-07 22:33:39', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.'),
(33, 1, '2026-03-09 16:18:51', 'Grab his weapon from his backspine, Reloads it and he flick the safety trigger to [OFF] and ready to shoot anytime.');

-- --------------------------------------------------------

--
-- Table structure for table `localbuyer`
--

CREATE TABLE `localbuyer` (
  `id` int(10) NOT NULL,
  `type` smallint(10) DEFAULT 1,
  `name` varchar(40) DEFAULT NULL,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `actorskin` smallint(5) DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_admin`
--

CREATE TABLE `log_admin` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `log_admin`
--

INSERT INTO `log_admin` (`id`, `date`, `description`) VALUES
(37, '2024-03-06 19:20:36', 'Joma_Nuron (uid: 1) has made Joma_Nuron (uid: 1) a mapper moderator.');

-- --------------------------------------------------------

--
-- Table structure for table `log_bans`
--

CREATE TABLE `log_bans` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_cheat`
--

CREATE TABLE `log_cheat` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_contracts`
--

CREATE TABLE `log_contracts` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_faction`
--

CREATE TABLE `log_faction` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_gang`
--

CREATE TABLE `log_gang` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_give`
--

CREATE TABLE `log_give` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_namechanges`
--

CREATE TABLE `log_namechanges` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_namehistory`
--

CREATE TABLE `log_namehistory` (
  `id` int(10) NOT NULL,
  `uid` int(10) DEFAULT NULL,
  `oldname` varchar(24) DEFAULT NULL,
  `newname` varchar(24) DEFAULT NULL,
  `changedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_property`
--

CREATE TABLE `log_property` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_punishments`
--

CREATE TABLE `log_punishments` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_referrals`
--

CREATE TABLE `log_referrals` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_vip`
--

CREATE TABLE `log_vip` (
  `id` int(10) NOT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `object`
--

CREATE TABLE `object` (
  `mobjID` int(11) NOT NULL,
  `mobjModel` int(11) NOT NULL DEFAULT 980,
  `mobjInterior` int(11) NOT NULL DEFAULT 0,
  `mobjWorld` int(11) NOT NULL DEFAULT 0,
  `mobjX` float NOT NULL DEFAULT 0,
  `mobjY` float NOT NULL DEFAULT 0,
  `mobjZ` float NOT NULL DEFAULT 0,
  `mobjRX` float NOT NULL DEFAULT 0,
  `mobjRY` float NOT NULL DEFAULT 0,
  `mobjRZ` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `object`
--

INSERT INTO `object` (`mobjID`, `mobjModel`, `mobjInterior`, `mobjWorld`, `mobjX`, `mobjY`, `mobjZ`, `mobjRX`, `mobjRY`, `mobjRZ`) VALUES
(1101, 974, 0, 0, 2760.58, -1900.94, 11.9246, 0, 0, -176.958),
(1103, 1280, 0, 0, 1708.47, -1634.37, 19.6118, 0, 0, -89.31),
(1104, 1280, 0, 0, 1705.25, -1634.41, 19.6118, 0, 0, -89.31),
(1107, 19447, 0, 0, 659.173, -1228.25, 16.8072, 0, 0, -26.1918),
(1108, 19447, 0, 0, 660.174, -1226.22, 16.8039, 0, 0, -26.2251),
(1109, 19447, 0, 0, 659.241, -1228.13, 18.9078, 0, 0, -26.1286),
(1110, 19447, 0, 0, 661.016, -1224.6, 19.7901, 0, 0, -26.2458),
(1111, 19447, 0, 0, 665.096, -1215.75, 16.97, 0, 0, -32.6188),
(1114, 19868, 0, 0, 664.2, -1217.03, 18.7262, 0, 0, 236.849),
(1115, 19868, 0, 0, 667.054, -1212.67, 18.7188, 0, 0, 236.849),
(1118, 19462, 0, 0, 1708.56, -1612.2, 14.2868, 0, 0, 0.1561),
(1119, 19462, 0, 0, 1708.58, -1621.76, 14.2868, 0, 0, -179.834),
(1124, 19370, 0, 0, 1731.4, -1606.8, 14.2768, 0, 0, -99.5525),
(1125, 19370, 0, 0, 1733.27, -1607.12, 14.286, 0, 0, -99.4987),
(1126, 19370, 0, 0, 1712.52, -1603.85, 14.2929, 0, 0, -97.3949),
(1127, 19370, 0, 0, 1710.8, -1603.62, 14.289, 0, 0, -96.2663),
(1128, 19443, 0, 0, 1713.3, -1603.95, 16.299, 0, 0, -97.0753),
(1129, 19443, 0, 0, 1730.63, -1606.67, 16.3168, 0, 0, -99.5857),
(1130, 1728, 0, 0, -914.788, 2673.98, 49.0628, 0, 0, 311.022),
(1131, 1814, 0, 0, -914.648, 2672.09, 49.0327, 0, 0, 138.42),
(1132, 2858, 0, 0, -915.162, 2671.9, 49.5503, 0, 0, 301.843);

-- --------------------------------------------------------

--
-- Table structure for table `paintball`
--

CREATE TABLE `paintball` (
  `id` int(2) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `password` varchar(128) DEFAULT '',
  `health` int(10) DEFAULT 100,
  `armor` int(10) DEFAULT 0,
  `time` int(10) DEFAULT 0,
  `ready` int(10) DEFAULT 0,
  `cbug` tinyint(1) DEFAULT 0,
  `money` int(10) DEFAULT 0,
  `weapon1` int(10) DEFAULT 0,
  `weapon2` int(10) DEFAULT 0,
  `weapon3` int(10) DEFAULT 0,
  `pos_x1` float DEFAULT NULL,
  `pos_y1` float DEFAULT NULL,
  `pos_z1` float DEFAULT NULL,
  `pos_a1` float DEFAULT NULL,
  `pos_x2` float DEFAULT NULL,
  `pos_y2` float DEFAULT NULL,
  `pos_z2` float DEFAULT NULL,
  `pos_a2` float DEFAULT NULL,
  `pos_x3` float DEFAULT NULL,
  `pos_y3` float DEFAULT NULL,
  `pos_z3` float DEFAULT NULL,
  `pos_a3` float DEFAULT NULL,
  `pos_x4` float DEFAULT NULL,
  `pos_y4` float DEFAULT NULL,
  `pos_z4` float DEFAULT NULL,
  `pos_a4` float DEFAULT NULL,
  `pos_x5` float DEFAULT NULL,
  `pos_y5` float DEFAULT NULL,
  `pos_z5` float DEFAULT NULL,
  `pos_a5` float DEFAULT NULL,
  `iconid` smallint(5) DEFAULT 1239,
  `type` smallint(5) DEFAULT 0,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `paintball`
--

INSERT INTO `paintball` (`id`, `name`, `password`, `health`, `armor`, `time`, `ready`, `cbug`, `money`, `weapon1`, `weapon2`, `weapon3`, `pos_x1`, `pos_y1`, `pos_z1`, `pos_a1`, `pos_x2`, `pos_y2`, `pos_z2`, `pos_a2`, `pos_x3`, `pos_y3`, `pos_z3`, `pos_a3`, `pos_x4`, `pos_y4`, `pos_z4`, `pos_a4`, `pos_x5`, `pos_y5`, `pos_z5`, `pos_a5`, `iconid`, `type`, `interior`, `world`) VALUES
(14, 'Dont Click this Arena', '', 100, 0, 0, 2, 0, 0, 0, 0, 0, 1676.62, 1461.03, 1153.62, 274.175, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 19300, 0, 0, 0),
(16, 'RC Battlefield', '', 100, 0, 0, 2, 0, 0, 24, 0, 0, -1128.39, 1057.54, 1346.41, 274.527, -977.283, 1061.08, 1345.67, 91.905, -1027.4, 1048.23, 1342.28, 88.382, -1067.91, 1092.81, 1343.15, 142.566, -1084.59, 1042.17, 1343.34, 359.684, 1239, 0, 10, 500),
(17, 'Las Venturas Police Department', '', 100, 0, 0, 2, 0, 0, 24, 29, 31, 286.792, 178.859, 1007.18, 89.079, 268.63, 186.238, 1008.17, 10.744, 246.033, 185.609, 1008.17, 2.308, 235.512, 149.917, 1003.03, 356.692, 217.08, 142.059, 1003.02, 272.694, 1239, 0, 3, 500),
(18, 'Kerala Ship', '', 100, 0, 0, 0, 0, 0, 0, 0, 0, -1411.83, 1490.3, 7.109, 250.369, -1372.43, 1491.02, 11.039, 208.382, -1471.21, 1490.71, 8.258, 270.713, -1455.3, 1481.12, 7.102, 294.526, -1383.66, 1489.02, 16.32, 150.079, 1239, 0, 0, 500),
(19, 'Las Venturas Ghost Town', '', 100, 0, 0, 0, 0, 2000, 0, 0, 0, -382.485, 2206.44, 42.424, 0.215, -411.29, 2263.22, 42.419, 254.644, -365.513, 2262.37, 42.484, 100.482, -456.494, 2223.27, 42.955, 259.031, -345.524, 2220.7, 42.483, 93.612, 1239, 0, 0, 500),
(20, 'Green Palms Factory', '', 100, 0, 0, 0, 0, 1000, 0, 0, 0, 248.671, 1476.65, 10.586, 134.914, 130.203, 1472.64, 10.61, 120.814, 120.29, 1352.18, 10.586, 226.408, 253.629, 1350.82, 10.586, 77.91, 193.676, 1372.63, 23.734, 6.47, 1239, 0, 0, 500);

-- --------------------------------------------------------

--
-- Table structure for table `phonebook`
--

CREATE TABLE `phonebook` (
  `name` varchar(24) DEFAULT NULL,
  `number` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `phonebookplayer`
--

CREATE TABLE `phonebookplayer` (
  `contactid` int(11) NOT NULL,
  `phonenumber` int(11) NOT NULL,
  `contactname` varchar(24) NOT NULL,
  `contactnumber` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `plantzone`
--

CREATE TABLE `plantzone` (
  `id` int(10) NOT NULL,
  `min_x` float DEFAULT 0,
  `min_y` float DEFAULT 0,
  `max_x` float DEFAULT 0,
  `max_y` float DEFAULT 0,
  `height` float DEFAULT 0,
  `lx` float NOT NULL,
  `ly` float NOT NULL,
  `lz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL COMMENT 'Foreign key to users.id',
  `username` varchar(24) NOT NULL COMMENT 'Cached from users table',
  `fishing_level` int(10) UNSIGNED DEFAULT 1,
  `fishing_exp` int(10) UNSIGNED DEFAULT 0,
  `fishing_tokens` int(10) UNSIGNED DEFAULT 0,
  `fishing_rod_id` int(10) UNSIGNED DEFAULT 0,
  `fishing_bait_id` int(10) UNSIGNED DEFAULT 0,
  `fishing_bait_amount` int(10) UNSIGNED DEFAULT 0,
  `fishing_combo` int(10) UNSIGNED DEFAULT 0,
  `fishing_total_caught` int(10) UNSIGNED DEFAULT 0,
  `fishing_biggest_weight` float DEFAULT 0,
  `fishing_legendary_count` int(10) UNSIGNED DEFAULT 0,
  `fishing_daily_quest_id` int(10) UNSIGNED DEFAULT 0,
  `fishing_daily_progress` int(10) UNSIGNED DEFAULT 0,
  `fishing_daily_completed` tinyint(1) DEFAULT 0,
  `fishing_daily_timestamp` int(10) UNSIGNED DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `current_custom_skin` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Fishing system player data - separate from main users table';

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `user_id`, `username`, `fishing_level`, `fishing_exp`, `fishing_tokens`, `fishing_rod_id`, `fishing_bait_id`, `fishing_bait_amount`, `fishing_combo`, `fishing_total_caught`, `fishing_biggest_weight`, `fishing_legendary_count`, `fishing_daily_quest_id`, `fishing_daily_progress`, `fishing_daily_completed`, `fishing_daily_timestamp`, `created_at`, `updated_at`, `current_custom_skin`) VALUES
(10, 1, 'Joma_Nuron', 5, 224, 76, 2, 5, 0, 1, 43, 66.95, 0, 7, 2956, 1, 0, '2026-03-08 09:48:21', '2026-03-14 19:37:26', 0);

-- --------------------------------------------------------

--
-- Table structure for table `player_custom_skins`
--

CREATE TABLE `player_custom_skins` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'Player UID',
  `skin_id` int(11) NOT NULL COMMENT 'Custom skin ID',
  `purchased_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `purchase_price` int(11) NOT NULL DEFAULT 0 COMMENT 'Price paid at purchase',
  `times_used` int(11) NOT NULL DEFAULT 0 COMMENT 'Usage counter',
  `last_used` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `player_custom_skins`
--

INSERT INTO `player_custom_skins` (`id`, `user_id`, `skin_id`, `purchased_at`, `purchase_price`, `times_used`, `last_used`) VALUES
(1, 1, 20002, '2026-03-12 17:22:30', 0, 16, '2026-03-14 14:02:08'),
(2, 1, 20004, '2026-03-12 17:51:11', 0, 7, '2026-03-14 14:02:12'),
(3, 1, 20001, '2026-03-13 17:54:59', 0, 12, '2026-03-14 14:02:05'),
(4, 1, 20003, '2026-03-13 18:03:36', 0, 6, '2026-03-14 14:02:10');

-- --------------------------------------------------------

--
-- Table structure for table `points`
--

CREATE TABLE `points` (
  `id` tinyint(2) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `capturedby` varchar(24) DEFAULT 'No-one',
  `capturedgang` tinyint(2) DEFAULT -1,
  `type` tinyint(2) DEFAULT 0,
  `time` tinyint(2) DEFAULT 12,
  `min_x` float DEFAULT 0,
  `min_y` float DEFAULT 0,
  `max_x` float DEFAULT 0,
  `max_y` float DEFAULT 0,
  `height` float DEFAULT 0,
  `lx` float NOT NULL,
  `ly` float NOT NULL,
  `lz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `points`
--

INSERT INTO `points` (`id`, `name`, `capturedby`, `capturedgang`, `type`, `time`, `min_x`, `min_y`, `max_x`, `max_y`, `height`, `lx`, `ly`, `lz`) VALUES
(1, 'Material 1', 'No-one', -1, 4, 0, 2256.68, -1120.58, 2293.7, -1085.58, 48.75, 2288.14, -1104.65, 38.587),
(2, 'Crack House', 'No-one', -1, 6, 0, 2312.64, -1194.36, 2361.85, -1167.36, 27.188, 2346.41, -1168.65, 27.566),
(3, 'Material 2', 'No-one', -1, 4, 0, 2355.1, -2038.88, 2404.1, -1982.17, 13.547, 2376.26, -2014.66, 14.412);

-- --------------------------------------------------------

--
-- Table structure for table `pooltables`
--

CREATE TABLE `pooltables` (
  `id` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `interior` int(11) NOT NULL,
  `world` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `pooltables`
--

INSERT INTO `pooltables` (`id`, `posx`, `posy`, `posz`, `interior`, `world`) VALUES
(1, 1212.68, -1422.1, 13.353, 0, 0),
(2, 1220.67, -1421.32, 13.294, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `publicgarage`
--

CREATE TABLE `publicgarage` (
  `id` int(12) NOT NULL,
  `name` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'Public Garage',
  `iconid` int(12) DEFAULT 1239,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `spos_x` float DEFAULT NULL,
  `spos_y` float DEFAULT NULL,
  `spos_z` float DEFAULT NULL,
  `interior` int(12) DEFAULT 0,
  `world` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rankings`
--

CREATE TABLE `rankings` (
  `holdid` int(11) NOT NULL,
  `Name` varchar(24) NOT NULL,
  `hours` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `rankings`
--

INSERT INTO `rankings` (`holdid`, `Name`, `hours`) VALUES
(1, 'Ven_Spark', 5),
(2, 'Trevor_Reeves', 1),
(3, 'Joma_Nuron', 139),
(4, 'Koy_Nuron', 17),
(5, 'Tito_Badang', 2),
(6, 'Goro_Paciano', 1);

-- --------------------------------------------------------

--
-- Table structure for table `rentvehicle`
--

CREATE TABLE `rentvehicle` (
  `name` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '''Unknown''',
  `id` int(12) NOT NULL,
  `iconid` int(12) DEFAULT 1239,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `interior` int(12) DEFAULT 0,
  `world` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rentvehicle`
--

INSERT INTO `rentvehicle` (`name`, `id`, `iconid`, `pos_x`, `pos_y`, `pos_z`, `interior`, `world`) VALUES
('Rent Na!', 4, 1239, 2373.53, -648.781, 127.45, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `rp_dealercars`
--

CREATE TABLE `rp_dealercars` (
  `ID` int(10) NOT NULL,
  `Model` smallint(3) DEFAULT 0,
  `Company` int(10) DEFAULT 0,
  `Price` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shots`
--

CREATE TABLE `shots` (
  `id` int(10) NOT NULL,
  `playerid` smallint(3) DEFAULT NULL,
  `weaponid` tinyint(2) DEFAULT NULL,
  `hittype` tinyint(2) DEFAULT NULL,
  `hitid` int(10) DEFAULT NULL,
  `hitplayer` varchar(24) DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `timestamp` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `speedcameras`
--

CREATE TABLE `speedcameras` (
  `speedID` int(11) NOT NULL,
  `speedRange` float DEFAULT 0,
  `speedLimit` float DEFAULT 0,
  `speedX` float DEFAULT 0,
  `speedY` float DEFAULT 0,
  `speedZ` float DEFAULT 0,
  `speedAngle` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surgery`
--

CREATE TABLE `surgery` (
  `id` int(11) NOT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `pos_r` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `texts`
--

CREATE TABLE `texts` (
  `id` int(10) NOT NULL,
  `sender_number` int(10) DEFAULT NULL,
  `recipient_number` int(10) DEFAULT NULL,
  `sender` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tollgates`
--

CREATE TABLE `tollgates` (
  `TollgateID` int(12) NOT NULL,
  `TollgateModel` int(12) DEFAULT 980,
  `TollgateSpeed` float DEFAULT 0,
  `TollgateTime` int(12) DEFAULT 0,
  `gateX` float DEFAULT 0,
  `gateY` float DEFAULT 0,
  `gateZ` float DEFAULT 0,
  `gateRX` float DEFAULT 0,
  `gateRY` float DEFAULT 0,
  `gateRZ` float DEFAULT 0,
  `TollgateInterior` int(12) DEFAULT 0,
  `TollgateWorld` int(12) DEFAULT 0,
  `gateMoveX` float DEFAULT 0,
  `gateMoveY` float DEFAULT 0,
  `gateMoveZ` float DEFAULT 0,
  `gateMoveRX` float DEFAULT 0,
  `gateMoveRY` float DEFAULT 0,
  `gateMoveRZ` float DEFAULT 0,
  `TollgateLinkID` int(12) DEFAULT 0,
  `TollgateRadius` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tollgates`
--

INSERT INTO `tollgates` (`TollgateID`, `TollgateModel`, `TollgateSpeed`, `TollgateTime`, `gateX`, `gateY`, `gateZ`, `gateRX`, `gateRY`, `gateRZ`, `TollgateInterior`, `TollgateWorld`, `gateMoveX`, `gateMoveY`, `gateMoveZ`, `gateMoveRX`, `gateMoveRY`, `gateMoveRZ`, `TollgateLinkID`, `TollgateRadius`) VALUES
(274, 968, 3, 5000, 50.6165, -1527.58, 4.8576, -0.5, 88.6998, 83.3665, 0, 0, 50.6165, -1527.58, 4.8576, -0.5, 5.9998, 83.3665, -1, 7),
(275, 968, 3, 5000, 49.9411, -1534.86, 4.8494, 0, -88.9, 83.8547, 0, 0, 49.9411, -1534.86, 4.8494, 0, -1.1, 83.8547, -1, 10),
(276, 968, 3, 0, 51.0184, -1286.5, 13.5147, 0, 88.9999, 125.665, 0, 0, 51.0184, -1286.5, 13.5147, 0, 2.4999, 125.665, -1, 7),
(277, 968, 3, 0, 71.4038, -1305.73, 12.1911, 0, 88.6, 130.457, 0, 0, 71.4038, -1305.73, 12.1911, 0, 0.5, 130.457, -1, 7),
(278, 968, 3, 0, -159.666, 371.208, 11.5881, 0, 88.5999, 165.766, 0, 0, -159.666, 371.208, 11.5881, 0, 2.2, 165.766, -1, 10),
(279, 968, 3, 0, -173.271, 374.716, 11.768, 0, -91, 163.912, 0, 0, -173.271, 374.716, 11.768, 0, -2, 163.912, -1, 11),
(280, 968, 3, 0, 514.609, 468.389, 18.8195, 0, 89.9999, 38.1968, 0, 0, 514.609, 468.389, 18.8195, 0, 3.2999, 38.1968, -1, 10),
(281, 968, 3, 0, 525.696, 477.15, 18.6996, 0, 89.0998, -141.645, 0, 0, 525.696, 477.15, 18.6996, 0, 2.5999, -141.645, -1, 10),
(282, 968, 3, 0, 1809.88, 819.352, 10.3441, 0, 88.2999, -179.735, 0, 0, 1809.88, 819.352, 10.3441, 0, -0.5, -179.735, -1, 8),
(283, 968, 3, 0, 1791.57, 810.524, 10.522, 0, -89.7, 0.3417, 0, 0, 1791.57, 810.524, 10.522, 0, -0.9, 0.3417, -1, 8);

-- --------------------------------------------------------

--
-- Table structure for table `turfs`
--

CREATE TABLE `turfs` (
  `id` tinyint(2) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `capturedby` varchar(24) DEFAULT 'No-one',
  `capturedgang` tinyint(2) DEFAULT -1,
  `type` tinyint(2) DEFAULT 0,
  `time` tinyint(2) DEFAULT 12,
  `min_x` float DEFAULT 0,
  `min_y` float DEFAULT 0,
  `max_x` float DEFAULT 0,
  `max_y` float DEFAULT 0,
  `height` float DEFAULT 0,
  `lx` float NOT NULL,
  `ly` float NOT NULL,
  `lz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `turfs`
--

INSERT INTO `turfs` (`id`, `name`, `capturedby`, `capturedgang`, `type`, `time`, `min_x`, `min_y`, `max_x`, `max_y`, `height`, `lx`, `ly`, `lz`) VALUES
(1, 'HOKKAIDO HIGH', 'No-one', -1, 10, 0, 687.346, -1299.05, 732.82, -1220.47, 13.481, 685.821, -1244.59, 14.374);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `uid` int(10) NOT NULL,
  `username` varchar(24) DEFAULT NULL,
  `password` varchar(129) DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  `lastlogin` datetime DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `setup` tinyint(1) DEFAULT 1,
  `gender` tinyint(1) DEFAULT 1,
  `age` tinyint(3) DEFAULT 18,
  `nation` tinyint(3) DEFAULT 0,
  `skin` smallint(3) DEFAULT 299,
  `BirthYear` int(10) DEFAULT 0,
  `BirthMonth` tinyint(5) DEFAULT 0,
  `BirthDay` tinyint(5) DEFAULT 0,
  `camera_x` float DEFAULT 0,
  `camera_y` float DEFAULT 0,
  `camera_z` float DEFAULT 0,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `interior` int(10) DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `cash` int(10) DEFAULT 10000,
  `bank` int(10) DEFAULT 10000,
  `paycheck` int(10) DEFAULT 0,
  `level` int(10) DEFAULT 1,
  `exp` int(10) DEFAULT 0,
  `minutes` smallint(3) DEFAULT 0,
  `hours` int(10) DEFAULT 0,
  `adminlevel` int(10) DEFAULT 0,
  `adminname` varchar(24) DEFAULT 'None',
  `helperlevel` tinyint(2) DEFAULT 0,
  `health` float DEFAULT 100,
  `armor` float DEFAULT 0,
  `upgradepoints` int(10) DEFAULT 0,
  `warnings` tinyint(3) DEFAULT 0,
  `injured` tinyint(1) DEFAULT 0,
  `hospital` tinyint(1) DEFAULT 0,
  `spawnhealth` float DEFAULT 50,
  `spawnarmor` float DEFAULT 0,
  `jailtype` tinyint(1) DEFAULT 0,
  `jailtime` int(10) DEFAULT 0,
  `factionmuted` tinyint(1) DEFAULT 0,
  `newbiemuted` tinyint(1) DEFAULT 0,
  `helpmuted` tinyint(1) DEFAULT 0,
  `admuted` tinyint(1) DEFAULT 0,
  `livemuted` tinyint(1) DEFAULT 0,
  `globalmuted` tinyint(1) DEFAULT 0,
  `amuted` tinyint(1) DEFAULT 0,
  `reportmuted` tinyint(2) DEFAULT 0,
  `reportwarns` tinyint(2) DEFAULT 0,
  `fightstyle` tinyint(2) DEFAULT 4,
  `locked` tinyint(1) DEFAULT 0,
  `accent` varchar(16) DEFAULT 'None',
  `cookies` int(10) DEFAULT 0,
  `phone` varchar(24) DEFAULT '0',
  `job` int(10) DEFAULT -1,
  `secondjob` tinyint(2) DEFAULT -1,
  `crimes` int(10) DEFAULT 0,
  `arrested` int(10) DEFAULT 0,
  `wantedlevel` tinyint(2) DEFAULT 0,
  `materials` int(10) DEFAULT 0,
  `pot` int(10) DEFAULT 0,
  `crack` int(10) DEFAULT 0,
  `meth` int(10) DEFAULT 0,
  `painkillers` int(10) DEFAULT 0,
  `seeds` int(10) DEFAULT 0,
  `ephedrine` int(10) DEFAULT 0,
  `muriaticacid` int(10) DEFAULT 0,
  `bakingsoda` int(10) DEFAULT 0,
  `cigars` int(10) DEFAULT 0,
  `walkietalkie` tinyint(1) DEFAULT 0,
  `channel` int(10) DEFAULT 0,
  `rentinghouse` int(10) DEFAULT 0,
  `spraycans` int(10) DEFAULT 0,
  `repairkit` int(10) DEFAULT 0,
  `toolkit` int(10) DEFAULT 0,
  `lockpick` int(10) DEFAULT 0,
  `crowbar` int(10) DEFAULT 0,
  `cablewire` int(10) DEFAULT 0,
  `blueprint` int(10) DEFAULT 0,
  `medals` int(10) DEFAULT 0,
  `stockfood` int(10) DEFAULT 0,
  `boombox` tinyint(1) DEFAULT 0,
  `mp3player` tinyint(1) DEFAULT 0,
  `phonebook` tinyint(1) DEFAULT 0,
  `fishingrod` tinyint(1) DEFAULT 0,
  `fishingbait` int(10) DEFAULT 0,
  `fishweight` int(10) DEFAULT 0,
  `components` int(10) DEFAULT 0,
  `courierskill` int(10) DEFAULT 0,
  `fishingskill` int(10) DEFAULT 0,
  `guardskill` int(10) DEFAULT 0,
  `weaponskill` int(10) DEFAULT 0,
  `9mmskill` int(10) DEFAULT 0,
  `uziskill` int(10) DEFAULT 0,
  `sawnoffskill` int(10) DEFAULT 0,
  `mechanicskill` int(10) DEFAULT 0,
  `lawyerskill` int(10) DEFAULT 0,
  `smugglerskill` int(10) DEFAULT 0,
  `toggletextdraws` tinyint(1) DEFAULT 0,
  `toggleooc` tinyint(1) DEFAULT 0,
  `togglephone` tinyint(1) DEFAULT 0,
  `toggleadmin` tinyint(1) DEFAULT 0,
  `togglehelper` tinyint(1) DEFAULT 0,
  `togglenewbie` tinyint(1) DEFAULT 0,
  `togglewt` tinyint(1) DEFAULT 0,
  `toggleradio` tinyint(1) DEFAULT 0,
  `togglevip` tinyint(1) DEFAULT 0,
  `togglemusic` tinyint(1) DEFAULT 0,
  `togglefaction` tinyint(1) DEFAULT 0,
  `togglegang` tinyint(1) DEFAULT 0,
  `togglenews` tinyint(1) DEFAULT 0,
  `toggleglobal` tinyint(1) DEFAULT 0,
  `togglecam` tinyint(1) DEFAULT 0,
  `carlicense` tinyint(1) DEFAULT 0,
  `nationalid` tinyint(1) DEFAULT 0,
  `theoretical` tinyint(12) DEFAULT 0,
  `vippackage` tinyint(2) NOT NULL DEFAULT 0,
  `viptime` int(10) DEFAULT 0,
  `vipcooldown` int(10) DEFAULT 0,
  `viptokens` int(11) NOT NULL DEFAULT 0,
  `weapon_0` tinyint(2) DEFAULT 0,
  `weapon_1` tinyint(2) DEFAULT 0,
  `weapon_2` tinyint(2) DEFAULT 0,
  `weapon_3` tinyint(2) DEFAULT 0,
  `weapon_4` tinyint(2) DEFAULT 0,
  `weapon_5` tinyint(2) DEFAULT 0,
  `weapon_6` tinyint(2) DEFAULT 0,
  `weapon_7` tinyint(2) DEFAULT 0,
  `weapon_8` tinyint(2) DEFAULT 0,
  `weapon_9` tinyint(2) DEFAULT 0,
  `weapon_10` tinyint(2) DEFAULT 0,
  `weapon_11` tinyint(2) DEFAULT 0,
  `weapon_12` tinyint(2) DEFAULT 0,
  `ammo_0` int(5) DEFAULT 0,
  `ammo_1` int(5) DEFAULT 0,
  `ammo_2` int(5) DEFAULT 0,
  `ammo_3` int(5) DEFAULT 0,
  `ammo_4` int(5) DEFAULT 0,
  `ammo_5` int(5) DEFAULT 0,
  `ammo_6` int(5) DEFAULT 0,
  `ammo_7` int(5) DEFAULT 0,
  `ammo_8` int(5) DEFAULT 0,
  `ammo_9` int(5) DEFAULT 0,
  `ammo_10` int(5) DEFAULT 0,
  `ammo_11` int(5) DEFAULT 0,
  `ammo_12` int(5) DEFAULT 0,
  `faction` tinyint(2) DEFAULT -1,
  `gang` tinyint(2) DEFAULT -1,
  `factionrank` tinyint(2) DEFAULT 0,
  `gangrank` tinyint(2) DEFAULT 0,
  `division` tinyint(2) DEFAULT -1,
  `contracted` int(10) DEFAULT 0,
  `contractby` varchar(24) DEFAULT 'Nobody',
  `bombs` int(10) DEFAULT 0,
  `completedhits` int(10) DEFAULT 0,
  `failedhits` int(10) DEFAULT 0,
  `reports` int(10) DEFAULT 0,
  `helprequests` int(10) DEFAULT 0,
  `speedometer` tinyint(1) DEFAULT 1,
  `factionmod` tinyint(1) DEFAULT 0,
  `gangmod` tinyint(1) DEFAULT 0,
  `eventstaff` tinyint(1) DEFAULT 0,
  `banappealer` tinyint(1) DEFAULT 0,
  `csr` tinyint(1) DEFAULT 0,
  `Streamerrole` tinyint(1) DEFAULT 0,
  `mappermod` tinyint(1) DEFAULT 0,
  `Dualsa47` tinyint(1) DEFAULT 0,
  `potplanted` tinyint(1) DEFAULT 0,
  `pottime` int(10) DEFAULT 0,
  `potgrams` int(10) DEFAULT 0,
  `pot_x` float DEFAULT 0,
  `pot_y` float DEFAULT 0,
  `pot_z` float DEFAULT 0,
  `pot_a` float DEFAULT 0,
  `inventoryupgrade` int(10) DEFAULT 0,
  `addictupgrade` int(10) DEFAULT 0,
  `traderupgrade` int(10) DEFAULT 0,
  `assetupgrade` int(10) DEFAULT 0,
  `pistolammo` smallint(5) DEFAULT 0,
  `shotgunammo` smallint(5) DEFAULT 0,
  `smgammo` smallint(5) DEFAULT 0,
  `arammo` smallint(5) DEFAULT 0,
  `rifleammo` smallint(5) DEFAULT 0,
  `hpammo` smallint(5) DEFAULT 0,
  `poisonammo` smallint(5) DEFAULT 0,
  `fmjammo` smallint(5) DEFAULT 0,
  `ammotype` tinyint(2) DEFAULT 0,
  `ammoweapon` tinyint(2) DEFAULT 0,
  `dmwarnings` tinyint(2) DEFAULT 0,
  `weaponrestricted` int(10) DEFAULT 0,
  `referral_uid` int(10) DEFAULT 0,
  `refercount` int(10) DEFAULT 0,
  `watch` tinyint(1) DEFAULT 0,
  `gps` tinyint(1) DEFAULT 0,
  `prisonedby` varchar(24) DEFAULT 'No-one',
  `prisonreason` varchar(128) DEFAULT 'None',
  `togglehud` tinyint(1) DEFAULT 1,
  `clothes` smallint(3) DEFAULT -1,
  `showturfs` tinyint(1) DEFAULT 0,
  `showpoints` tinyint(1) DEFAULT 0,
  `showlands` tinyint(1) DEFAULT 0,
  `watchon` tinyint(1) DEFAULT 0,
  `gpson` tinyint(1) DEFAULT 0,
  `doublexp` int(10) DEFAULT 0,
  `couriercooldown` int(10) DEFAULT 0,
  `pizzacooldown` int(10) DEFAULT 0,
  `detectivecooldown` int(10) DEFAULT 0,
  `robcooldown` int(10) DEFAULT 0,
  `driverliccooldown` int(10) DEFAULT 0,
  `duty` int(10) DEFAULT 0,
  `bandana` int(10) NOT NULL DEFAULT 0,
  `detectiveskill` int(11) DEFAULT 0,
  `gascan` int(11) DEFAULT 0,
  `refunded` int(11) DEFAULT 0,
  `backpack` int(11) DEFAULT 0,
  `bpcash` int(11) DEFAULT 0,
  `bpmaterials` int(11) DEFAULT 0,
  `bppot` int(11) DEFAULT 0,
  `bpcrack` int(11) DEFAULT 0,
  `bpmeth` int(11) DEFAULT 0,
  `bppainkillers` int(11) DEFAULT 0,
  `bpweapon_0` int(11) DEFAULT 0,
  `bpweapon_1` int(11) DEFAULT 0,
  `bpweapon_2` int(11) DEFAULT 0,
  `bpweapon_3` int(11) DEFAULT 0,
  `bpweapon_4` int(11) DEFAULT 0,
  `bpweapon_5` int(11) DEFAULT 0,
  `bpweapon_6` int(11) DEFAULT 0,
  `bpweapon_7` int(11) DEFAULT 0,
  `bpweapon_8` int(11) DEFAULT 0,
  `bpweapon_9` int(11) DEFAULT 0,
  `bpweapon_10` int(11) DEFAULT 0,
  `bpweapon_11` int(11) DEFAULT 0,
  `bpweapon_12` int(11) DEFAULT 0,
  `bpweapon_13` int(11) DEFAULT 0,
  `bpweapon_14` int(11) DEFAULT 0,
  `bpammo_0` int(5) DEFAULT 0,
  `bpammo_1` int(5) DEFAULT 0,
  `bpammo_2` int(5) DEFAULT 0,
  `bpammo_3` int(5) DEFAULT 0,
  `bpammo_4` int(5) DEFAULT 0,
  `bpammo_5` int(5) DEFAULT 0,
  `bpammo_6` int(5) DEFAULT 0,
  `bpammo_7` int(5) DEFAULT 0,
  `bpammo_8` int(5) DEFAULT 0,
  `bpammo_9` int(5) DEFAULT 0,
  `bpammo_10` int(5) DEFAULT 0,
  `bpammo_11` int(5) DEFAULT 0,
  `bpammo_12` int(5) DEFAULT 0,
  `bpammo_13` int(5) DEFAULT 0,
  `bpammo_14` int(5) DEFAULT 0,
  `bphpammo` int(11) DEFAULT 0,
  `bppoisonammo` int(11) DEFAULT 0,
  `bpfmjammo` int(11) DEFAULT 0,
  `formeradmin` int(2) NOT NULL DEFAULT 0,
  `deathcooldown` int(10) NOT NULL DEFAULT 0,
  `hunger` int(10) NOT NULL DEFAULT 100,
  `hungertimer` int(10) NOT NULL DEFAULT 0,
  `thirst` int(11) NOT NULL DEFAULT 100,
  `thirsttimer` int(11) NOT NULL DEFAULT 0,
  `stress` int(10) NOT NULL DEFAULT 100,
  `stresstimer` int(10) NOT NULL DEFAULT 0,
  `totalpatients` int(10) NOT NULL DEFAULT 0,
  `totalfires` int(10) NOT NULL DEFAULT 0,
  `rarecooldown` int(10) NOT NULL DEFAULT 0,
  `customtitle` varchar(64) NOT NULL DEFAULT '0',
  `radiotitle` varchar(64) NOT NULL DEFAULT '0',
  `customcolor` varchar(16) NOT NULL DEFAULT '0',
  `callsign` varchar(64) NOT NULL DEFAULT '0',
  `mask` int(10) NOT NULL DEFAULT 0,
  `maskid` varchar(34) DEFAULT '0',
  `diamonds` int(11) NOT NULL DEFAULT 0,
  `blindfold` int(10) NOT NULL DEFAULT 0,
  `rope` int(10) NOT NULL DEFAULT 0,
  `insurance` int(10) NOT NULL DEFAULT 0,
  `houseinsurance` varchar(24) DEFAULT '0',
  `passport` int(10) NOT NULL DEFAULT 0,
  `passportname` varchar(64) DEFAULT NULL,
  `passportlevel` int(10) NOT NULL DEFAULT 0,
  `passportskin` int(10) NOT NULL DEFAULT 0,
  `passportphone` int(10) NOT NULL DEFAULT 0,
  `marriedto` int(10) NOT NULL DEFAULT -1,
  `relationshipto` int(10) NOT NULL DEFAULT -1,
  `newbies` int(10) NOT NULL DEFAULT 0,
  `chatanim` tinyint(2) NOT NULL DEFAULT 0,
  `Lottery` int(11) NOT NULL DEFAULT 0,
  `LotteryB` int(11) NOT NULL DEFAULT 0,
  `flashlight` tinyint(2) NOT NULL DEFAULT 0,
  `candy` int(11) NOT NULL DEFAULT 0,
  `bitcoininvestor` int(11) DEFAULT 0,
  `bitcoins` int(11) NOT NULL DEFAULT 0,
  `thiefskill` int(11) DEFAULT 0,
  `thiefcooldown` int(11) DEFAULT 0,
  `cocainecooldown` int(11) DEFAULT 0,
  `gunlicense` tinyint(2) NOT NULL DEFAULT 0,
  `dirtycash` int(11) NOT NULL DEFAULT 0,
  `comserv` int(11) NOT NULL DEFAULT 0,
  `fmtime` int(11) DEFAULT 0,
  `facemask` int(11) DEFAULT 0,
  `covid` int(11) DEFAULT 0,
  `covidtime` int(11) DEFAULT 0,
  `firstaid` int(11) NOT NULL DEFAULT 0,
  `bandage` int(11) NOT NULL DEFAULT 0,
  `groupleader` tinyint(11) NOT NULL DEFAULT 0,
  `crew` tinyint(11) NOT NULL DEFAULT -1,
  `pgroup` tinyint(11) NOT NULL DEFAULT 0,
  `drugwater` int(10) DEFAULT 0,
  `drugpot` int(10) DEFAULT 0,
  `drugcrack` int(10) DEFAULT 0,
  `drugmuriatic` int(10) DEFAULT 0,
  `drughydrogen` int(10) DEFAULT 0,
  `drugbattery` int(10) DEFAULT 0,
  `drugacetone` int(10) DEFAULT 0,
  `drugethyl` int(10) DEFAULT 0,
  `drugsulfuric` int(10) DEFAULT 0,
  `druglithium` int(10) DEFAULT 0,
  `drugiodine` int(10) DEFAULT 0,
  `drugopium` int(10) DEFAULT 0,
  `drugamphetamine` int(10) DEFAULT 0,
  `drugbenzodioxol` int(10) DEFAULT 0,
  `gunlicensedate` int(10) DEFAULT 0,
  `getdrugs` int(10) DEFAULT -1,
  `bindslot1` varchar(150) DEFAULT NULL,
  `bindslot2` varchar(150) DEFAULT NULL,
  `bindslot3` varchar(150) DEFAULT NULL,
  `bindslot4` varchar(150) DEFAULT NULL,
  `bindslot5` varchar(150) DEFAULT NULL,
  `bindslot6` varchar(150) DEFAULT NULL,
  `bindslot7` varchar(150) DEFAULT NULL,
  `bindslot8` varchar(150) DEFAULT NULL,
  `SkinInventory0` smallint(3) DEFAULT -1,
  `SkinInventory1` smallint(3) DEFAULT -1,
  `SkinInventory2` smallint(3) DEFAULT -1,
  `giftcode` varchar(64) NOT NULL DEFAULT '0',
  `giftcodetype` int(10) DEFAULT 0,
  `platinumvoucher` int(10) DEFAULT 0,
  `goldvoucher` int(10) DEFAULT 0,
  `silvervoucher` int(10) DEFAULT 0,
  `bronzevoucher` int(10) DEFAULT 0,
  `carvoucher` int(10) DEFAULT 0,
  `voicechat` tinyint(1) DEFAULT 0,
  `verify` tinyint(1) DEFAULT 1,
  `verifycode` varchar(128) DEFAULT '0',
  `alreadychoose` int(1) DEFAULT 0,
  `code` int(10) DEFAULT 0,
  `verified` tinyint(1) DEFAULT 0,
  `discordtag` int(10) DEFAULT NULL,
  `discordname` varchar(128) DEFAULT NULL,
  `discordid` varchar(64) DEFAULT NULL,
  `ink` int(10) DEFAULT 0,
  `paper` int(10) DEFAULT 0,
  `wires` int(10) DEFAULT 0,
  `scrapmetal` int(10) DEFAULT 0,
  `woodstick` int(10) DEFAULT 0,
  `cement` int(10) DEFAULT 0,
  `pliers` int(10) DEFAULT 0,
  `blackcoins` int(10) DEFAULT 0,
  `rag` int(10) DEFAULT 0,
  `bshovel` int(10) DEFAULT 0,
  `bkatana` int(10) DEFAULT 0,
  `bpoolcue` int(10) DEFAULT 0,
  `bbrass` int(10) DEFAULT 0,
  `bgolfcue` int(10) DEFAULT 0,
  `bbaseballbat` int(10) DEFAULT 0,
  `food` int(10) DEFAULT 0,
  `drink` int(10) DEFAULT 0,
  `grapes` int(10) DEFAULT 0,
  `apple` int(10) DEFAULT 0,
  `bread` int(10) DEFAULT 0,
  `bottle` int(10) DEFAULT 0,
  `meat` int(10) DEFAULT 0,
  `bowner` int(10) DEFAULT 0,
  `bemployee` int(10) DEFAULT 0,
  `screw` int(10) DEFAULT 0,
  `irons` int(10) DEFAULT 0,
  `rollingpaper` int(10) NOT NULL DEFAULT 0,
  `schoolcomserv` int(11) NOT NULL DEFAULT 0,
  `bedtype` tinyint(1) NOT NULL DEFAULT 0,
  `bedtime` tinyint(10) NOT NULL DEFAULT 0,
  `adminhide` tinyint(1) NOT NULL DEFAULT 0,
  `bknife` int(11) NOT NULL DEFAULT 0,
  `amcount` int(11) NOT NULL DEFAULT 0,
  `login_date` date DEFAULT NULL,
  `ak47` int(11) DEFAULT NULL,
  `vest` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`uid`, `username`, `password`, `regdate`, `lastlogin`, `ip`, `setup`, `gender`, `age`, `nation`, `skin`, `BirthYear`, `BirthMonth`, `BirthDay`, `camera_x`, `camera_y`, `camera_z`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `interior`, `world`, `cash`, `bank`, `paycheck`, `level`, `exp`, `minutes`, `hours`, `adminlevel`, `adminname`, `helperlevel`, `health`, `armor`, `upgradepoints`, `warnings`, `injured`, `hospital`, `spawnhealth`, `spawnarmor`, `jailtype`, `jailtime`, `factionmuted`, `newbiemuted`, `helpmuted`, `admuted`, `livemuted`, `globalmuted`, `amuted`, `reportmuted`, `reportwarns`, `fightstyle`, `locked`, `accent`, `cookies`, `phone`, `job`, `secondjob`, `crimes`, `arrested`, `wantedlevel`, `materials`, `pot`, `crack`, `meth`, `painkillers`, `seeds`, `ephedrine`, `muriaticacid`, `bakingsoda`, `cigars`, `walkietalkie`, `channel`, `rentinghouse`, `spraycans`, `repairkit`, `toolkit`, `lockpick`, `crowbar`, `cablewire`, `blueprint`, `medals`, `stockfood`, `boombox`, `mp3player`, `phonebook`, `fishingrod`, `fishingbait`, `fishweight`, `components`, `courierskill`, `fishingskill`, `guardskill`, `weaponskill`, `9mmskill`, `uziskill`, `sawnoffskill`, `mechanicskill`, `lawyerskill`, `smugglerskill`, `toggletextdraws`, `toggleooc`, `togglephone`, `toggleadmin`, `togglehelper`, `togglenewbie`, `togglewt`, `toggleradio`, `togglevip`, `togglemusic`, `togglefaction`, `togglegang`, `togglenews`, `toggleglobal`, `togglecam`, `carlicense`, `nationalid`, `theoretical`, `vippackage`, `viptime`, `vipcooldown`, `viptokens`, `weapon_0`, `weapon_1`, `weapon_2`, `weapon_3`, `weapon_4`, `weapon_5`, `weapon_6`, `weapon_7`, `weapon_8`, `weapon_9`, `weapon_10`, `weapon_11`, `weapon_12`, `ammo_0`, `ammo_1`, `ammo_2`, `ammo_3`, `ammo_4`, `ammo_5`, `ammo_6`, `ammo_7`, `ammo_8`, `ammo_9`, `ammo_10`, `ammo_11`, `ammo_12`, `faction`, `gang`, `factionrank`, `gangrank`, `division`, `contracted`, `contractby`, `bombs`, `completedhits`, `failedhits`, `reports`, `helprequests`, `speedometer`, `factionmod`, `gangmod`, `eventstaff`, `banappealer`, `csr`, `Streamerrole`, `mappermod`, `Dualsa47`, `potplanted`, `pottime`, `potgrams`, `pot_x`, `pot_y`, `pot_z`, `pot_a`, `inventoryupgrade`, `addictupgrade`, `traderupgrade`, `assetupgrade`, `pistolammo`, `shotgunammo`, `smgammo`, `arammo`, `rifleammo`, `hpammo`, `poisonammo`, `fmjammo`, `ammotype`, `ammoweapon`, `dmwarnings`, `weaponrestricted`, `referral_uid`, `refercount`, `watch`, `gps`, `prisonedby`, `prisonreason`, `togglehud`, `clothes`, `showturfs`, `showpoints`, `showlands`, `watchon`, `gpson`, `doublexp`, `couriercooldown`, `pizzacooldown`, `detectivecooldown`, `robcooldown`, `driverliccooldown`, `duty`, `bandana`, `detectiveskill`, `gascan`, `refunded`, `backpack`, `bpcash`, `bpmaterials`, `bppot`, `bpcrack`, `bpmeth`, `bppainkillers`, `bpweapon_0`, `bpweapon_1`, `bpweapon_2`, `bpweapon_3`, `bpweapon_4`, `bpweapon_5`, `bpweapon_6`, `bpweapon_7`, `bpweapon_8`, `bpweapon_9`, `bpweapon_10`, `bpweapon_11`, `bpweapon_12`, `bpweapon_13`, `bpweapon_14`, `bpammo_0`, `bpammo_1`, `bpammo_2`, `bpammo_3`, `bpammo_4`, `bpammo_5`, `bpammo_6`, `bpammo_7`, `bpammo_8`, `bpammo_9`, `bpammo_10`, `bpammo_11`, `bpammo_12`, `bpammo_13`, `bpammo_14`, `bphpammo`, `bppoisonammo`, `bpfmjammo`, `formeradmin`, `deathcooldown`, `hunger`, `hungertimer`, `thirst`, `thirsttimer`, `stress`, `stresstimer`, `totalpatients`, `totalfires`, `rarecooldown`, `customtitle`, `radiotitle`, `customcolor`, `callsign`, `mask`, `maskid`, `diamonds`, `blindfold`, `rope`, `insurance`, `houseinsurance`, `passport`, `passportname`, `passportlevel`, `passportskin`, `passportphone`, `marriedto`, `relationshipto`, `newbies`, `chatanim`, `Lottery`, `LotteryB`, `flashlight`, `candy`, `bitcoininvestor`, `bitcoins`, `thiefskill`, `thiefcooldown`, `cocainecooldown`, `gunlicense`, `dirtycash`, `comserv`, `fmtime`, `facemask`, `covid`, `covidtime`, `firstaid`, `bandage`, `groupleader`, `crew`, `pgroup`, `drugwater`, `drugpot`, `drugcrack`, `drugmuriatic`, `drughydrogen`, `drugbattery`, `drugacetone`, `drugethyl`, `drugsulfuric`, `druglithium`, `drugiodine`, `drugopium`, `drugamphetamine`, `drugbenzodioxol`, `gunlicensedate`, `getdrugs`, `bindslot1`, `bindslot2`, `bindslot3`, `bindslot4`, `bindslot5`, `bindslot6`, `bindslot7`, `bindslot8`, `SkinInventory0`, `SkinInventory1`, `SkinInventory2`, `giftcode`, `giftcodetype`, `platinumvoucher`, `goldvoucher`, `silvervoucher`, `bronzevoucher`, `carvoucher`, `voicechat`, `verify`, `verifycode`, `alreadychoose`, `code`, `verified`, `discordtag`, `discordname`, `discordid`, `ink`, `paper`, `wires`, `scrapmetal`, `woodstick`, `cement`, `pliers`, `blackcoins`, `rag`, `bshovel`, `bkatana`, `bpoolcue`, `bbrass`, `bgolfcue`, `bbaseballbat`, `food`, `drink`, `grapes`, `apple`, `bread`, `bottle`, `meat`, `bowner`, `bemployee`, `screw`, `irons`, `rollingpaper`, `schoolcomserv`, `bedtype`, `bedtime`, `adminhide`, `bknife`, `amcount`, `login_date`, `ak47`, `vest`) VALUES
(1, 'Joma_Nuron', 'D990B2D42ED82D503FA1DC25A739125DBBAFA4FC51D16AD1142967E3C6E8B6663E8C709725B769143940322720B7BB0164E4F6D0E3C12C0127C89033460F574D', '2024-02-21 21:58:18', '2026-03-15 03:59:41', '127.0.0.1', 0, 1, 18, 1, 171, 1943, 10, 24, -1525.57, 166.466, 5.63, -1524.9, 163.984, 3.555, 104.993, 0, 0, 6942, 10965, 0, 6, 121, 26, 159, 10, 'None', 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, '0', 0, '9941', 3, -1, 0, 0, 6, 4950, 0, -6, 0, 0, 0, 0, 2, 2, 0, 1, 0, 0, 10, 1, 0, 0, 0, 0, 0, 0, -3, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 67, 0, 0, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 656, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, 0, 'Nobody', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 'No-one', 'None', 0, -1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1710514598, 0, 0, 0, 10, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43, 149, 35, 54, 21, 14, 0, 0, 0, '0', '0', '0', '0', 1, '0', 0, 6, 8, 0, '0', 0, NULL, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 25966, 0, 0, 0, 0, 0, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 171, -1, -1, '0', 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0, 0, 'gg.joma', NULL, 6, 5, 29, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 4, 6, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, NULL, 0, 2),
(2, 'Koy_Nuron', 'D990B2D42ED82D503FA1DC25A739125DBBAFA4FC51D16AD1142967E3C6E8B6663E8C709725B769143940322720B7BB0164E4F6D0E3C12C0127C89033460F574D', '2024-02-21 23:22:09', '2024-03-22 10:32:59', '152.32.96.18', 0, 1, 18, 1, 171, 1924, 1, 1, 1219.06, -1423.46, 12.648, 1218.89, -1422.23, 13.289, 304.961, 0, 0, 58659, 10250, 0, 1, 17, 30, 17, 10, 'None', 0, 100, 100, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, '8', 0, '11016', 3, -1, 0, 0, 6, 500, 0, 0, 0, 0, 0, 0, 0, 0, 27, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 15, 0, 0, 24, 25, 29, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 983, 973, 988, 973, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, 0, 'Nobody', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 'No-one', 'None', 1, -1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 203, 100, 16, 100, 12, 100, 21, 0, 0, 0, '0', '0', '0', '0', 1, '0', 0, 0, 0, 0, '0', 0, NULL, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 444, 0, 0, 0, 0, 0, 1, 1, 1, -1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 171, -1, -1, '0', 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0, 0, 'gg.koy', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 2),
(3, 'Goro_Paciano', '64E5426B67225808BCB8BC5B2C9201771FCF93155FC6FD820052F6FF72FA1F8A91AD558CD08F37402D4F1C56CAFB54F798FF793991C32A525AE0C35E6C95D29C', '2024-03-08 19:46:33', '2024-03-18 20:16:59', '158.62.73.164', 0, 1, 18, 1, 101, 2004, 3, 8, 1359.58, -1151.61, 24.951, 1355.76, -1161.92, 23.707, 114.725, 0, 0, 16000, 1003997, 0, 1, 1, 38, 1, 10, 'Angor', 0, 100, 0, 0, 1, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, '0', 0, '0', -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 24, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 957, 0, 0, 443, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, 0, 'Nobody', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'No-one', 'None', 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 100, 0, 100, 0, 0, 0, 0, '0', '0', '0', '0', 0, '0', 0, 0, 0, 0, '0', 0, NULL, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, -1, -1, '0', 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL),
(4, 'Tito_Badang', '2F9959B230A44678DD2DC29F037BA1159F233AA9AB183CE3A0678EAAE002E5AA6F27F47144A1A4365116D3DB1B58EC47896623B92D85CB2F191705DAF11858B8', '2024-03-08 20:05:10', '2024-03-09 22:52:30', '180.190.109.206', 0, 1, 18, 1, 230, 1924, 1, 10, 1434.21, -2285.36, 16.161, 1432.88, -2288.79, 13.383, 277.05, 0, 0, 1333930787, 10080, 0, 1, 2, 9, 2, 10, 'Shayrhod', 0, 100, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, '0', 0, '0', -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1710504387, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, 0, 'Nobody', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Goro_Paciano', 'dmer', 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 100, 0, 100, 0, 0, 0, 0, '0', '0', '0', '0', 0, '0', 0, 0, 0, 0, '0', 0, NULL, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 230, -1, -1, '0', 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL),
(5, 'Cain_Paciano', '3C94ECD8D4BEACCCB47E49A13518F08591519E8FB0BF18A369EEADB2D4D6C8259A8BA8615ADCD1B52D9B7C0EEE75126A109721460829E493FFA9F11AB46F6CE0', '2024-03-08 22:09:42', '2024-03-08 22:09:42', '136.158.10.252', 0, 1, 18, 1, 171, 1924, 1, 1, 1451.81, -2288.23, 14.296, 1450.84, -2289.48, 13.547, 73.198, 0, 0, 10000, 10000, 0, 1, 0, 9, 0, 0, 'None', 0, 100, 0, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, '0', 0, '0', -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1710511843, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, 0, 'Nobody', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'No-one', 'None', 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 100, 0, 100, 0, 0, 0, 0, '0', '0', '0', '0', 0, '0', 0, 0, 0, 0, '0', 0, NULL, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 171, -1, -1, '0', 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL),
(6, 'Rhod_Paciano', 'B5094EB626413D5A4055CA2D0FAAEBF3B3DC07BC8F5886B4403DDD4271693ACAE16F8A748061C0460C1034C0C2F0757C77C2411564A5799275B52EB23D8870C2', '2024-03-09 22:53:57', '2024-03-09 23:14:28', '112.203.131.4', 0, 1, 18, 1, 171, 2005, 4, 21, 1430.53, -2244.86, 15.027, 1428.4, -2245.51, 13.547, 196.841, 0, 0, 10000, 10000, 0, 69, 0, 20, 0, 10, 'None', 0, 100, 100, 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, '8', 0, '0', -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1710600908, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, 0, 'Nobody', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Angor', 'jailbreak at iloveyou', 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 100, 0, 100, 0, 0, 0, 0, '0', '0', '0', '0', 0, '0', 0, 0, 0, 0, '0', 0, NULL, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 171, -1, -1, '0', 0, 0, 0, 0, 0, 0, 0, 0, '0', 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(10) NOT NULL,
  `ownerid` int(10) DEFAULT 0,
  `owner` varchar(24) DEFAULT 'Nobody',
  `modelid` smallint(3) DEFAULT 0,
  `plate` varchar(32) DEFAULT '',
  `price` int(10) DEFAULT 0,
  `tickets` int(10) DEFAULT 0,
  `mileage` int(10) DEFAULT 0,
  `locked` tinyint(1) DEFAULT 0,
  `dlock` tinyint(1) DEFAULT 0,
  `dlocked` tinyint(1) DEFAULT 0,
  `fuel` tinyint(3) DEFAULT 100,
  `health` float DEFAULT 1000,
  `pos_x` float DEFAULT 0,
  `pos_y` float DEFAULT 0,
  `pos_z` float DEFAULT 0,
  `pos_a` float DEFAULT 0,
  `color1` smallint(3) DEFAULT 0,
  `color2` smallint(3) DEFAULT 0,
  `paintjob` smallint(3) DEFAULT -1,
  `interior` tinyint(2) DEFAULT 0,
  `world` int(10) DEFAULT 0,
  `neon` smallint(5) DEFAULT 0,
  `neonenabled` tinyint(1) DEFAULT 0,
  `trunk` tinyint(1) DEFAULT 0,
  `mod_1` smallint(4) DEFAULT 0,
  `mod_2` smallint(4) DEFAULT 0,
  `mod_3` smallint(4) DEFAULT 0,
  `mod_4` smallint(4) DEFAULT 0,
  `mod_5` smallint(4) DEFAULT 0,
  `mod_6` smallint(4) DEFAULT 0,
  `mod_7` smallint(4) DEFAULT 0,
  `mod_8` smallint(4) DEFAULT 0,
  `mod_9` smallint(4) DEFAULT 0,
  `mod_10` smallint(4) DEFAULT 0,
  `mod_11` smallint(4) DEFAULT 0,
  `mod_12` smallint(4) DEFAULT 0,
  `mod_13` smallint(4) DEFAULT 0,
  `mod_14` smallint(4) DEFAULT 0,
  `cash` int(10) DEFAULT 0,
  `materials` int(10) DEFAULT 0,
  `pot` int(10) DEFAULT 0,
  `crack` int(10) DEFAULT 0,
  `meth` int(10) DEFAULT 0,
  `painkillers` int(10) DEFAULT 0,
  `weapon_1` tinyint(2) DEFAULT 0,
  `weapon_2` tinyint(2) DEFAULT 0,
  `weapon_3` tinyint(2) DEFAULT 0,
  `ammo_1` int(5) DEFAULT 0,
  `ammo_2` int(5) DEFAULT 0,
  `ammo_3` int(5) DEFAULT 0,
  `gangid` tinyint(2) DEFAULT -1,
  `factiontype` tinyint(2) DEFAULT 0,
  `vippackage` tinyint(2) NOT NULL DEFAULT 0,
  `job` tinyint(2) DEFAULT -1,
  `respawndelay` int(10) DEFAULT 0,
  `pistolammo` smallint(5) DEFAULT 0,
  `shotgunammo` smallint(5) DEFAULT 0,
  `smgammo` smallint(5) DEFAULT 0,
  `arammo` smallint(5) DEFAULT 0,
  `rifleammo` smallint(5) DEFAULT 0,
  `hpammo` smallint(5) DEFAULT 0,
  `poisonammo` smallint(5) DEFAULT 0,
  `fmjammo` smallint(5) DEFAULT 0,
  `registered` int(11) NOT NULL DEFAULT 0,
  `siren` tinyint(2) DEFAULT 0,
  `rank` tinyint(3) DEFAULT 0,
  `alarm` int(11) NOT NULL DEFAULT 0,
  `impounded` tinyint(1) NOT NULL DEFAULT 0,
  `broken` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `ownerid`, `owner`, `modelid`, `plate`, `price`, `tickets`, `mileage`, `locked`, `dlock`, `dlocked`, `fuel`, `health`, `pos_x`, `pos_y`, `pos_z`, `pos_a`, `color1`, `color2`, `paintjob`, `interior`, `world`, `neon`, `neonenabled`, `trunk`, `mod_1`, `mod_2`, `mod_3`, `mod_4`, `mod_5`, `mod_6`, `mod_7`, `mod_8`, `mod_9`, `mod_10`, `mod_11`, `mod_12`, `mod_13`, `mod_14`, `cash`, `materials`, `pot`, `crack`, `meth`, `painkillers`, `weapon_1`, `weapon_2`, `weapon_3`, `ammo_1`, `ammo_2`, `ammo_3`, `gangid`, `factiontype`, `vippackage`, `job`, `respawndelay`, `pistolammo`, `shotgunammo`, `smgammo`, `arammo`, `rifleammo`, `hpammo`, `poisonammo`, `fmjammo`, `registered`, `siren`, `rank`, `alarm`, `impounded`, `broken`) VALUES
(1, 1, 'Toki_Ibanez', 550, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.547, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 2, 'Ven_Spark', 550, '', 0, 106, 19, 0, 0, 0, 75, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 3, 'Queen_Adonai', 550, '', 0, 0, 12, 0, 0, 0, 98, 692.212, 1997.06, -1599.34, 13.372, 63.041, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 2, 'Ven_Spark', 522, '', 0, 110, 68, 0, 0, 0, 49, 857.027, 863.093, -2174.01, 2.052, 2.898, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(5, 5, 'Sweet_Holmes', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(6, 7, 'Ven_Spark1', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(7, 6, 'Trevor_Reeves', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 8, 'Shawn_Z._McKington', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 9, 'Wrecker_Menice', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(10, 10, 'Ryan_Zoldyck', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(11, 2, 'Ven_Spark', 522, '', 0, 0, 1, 0, 0, 0, 100, 1000, 2870.96, -401.772, 6.777, 2.333, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(12, 11, 'Dayz_Lees', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(13, 12, 'Crystal_Forger', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(14, 1, 'Joma_Nuron', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.547, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(15, 2, 'Koy_Nuron', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(16, 1, 'Joma_Nuron', 560, 'CONR:RP-64', 0, 0, 377, 0, 0, 0, 83, 996.215, 1083.89, -1388.3, 13.508, 313.841, 1, 0, 3, 0, 0, 18648, 1, 3, 1139, 0, 1032, 1030, 0, 1010, 1028, 1080, 0, 0, 1169, 1141, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0),
(17, 3, 'Goro_Paciano', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(18, 4, 'Tito_Badang', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(19, 5, 'Cain_Paciano', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(20, 6, 'Rhod_Paciano', 481, '', 0, 0, 0, 0, 0, 0, 100, 1000, 1433.88, -2286.7, 13.5469, 86.54, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(21, 2, 'Koy_Nuron', 560, 'CONR:RP-65', 0, 0, 9, 0, 0, 0, 95, 965.086, 1414.65, -2702.59, 13.309, 201.468, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `vendorID` int(12) NOT NULL,
  `vendorModel` int(12) DEFAULT 980,
  `vendorPosX` float DEFAULT 0,
  `vendorPosY` float DEFAULT 0,
  `vendorPosZ` float DEFAULT 0,
  `vendorInterior` int(12) DEFAULT 0,
  `vendorWorld` int(12) DEFAULT 0,
  `vendorAngle` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `vendors`
--

INSERT INTO `vendors` (`vendorID`, `vendorModel`, `vendorPosX`, `vendorPosY`, `vendorPosZ`, `vendorInterior`, `vendorWorld`, `vendorAngle`) VALUES
(151, 1340, 2762.35, -1936.13, 13.4469, 0, 0, 356),
(152, 1340, 2776.07, -1959.68, 13.4469, 0, 0, 169),
(154, 1340, 1166.2, -2042.93, 68.9078, 0, 0, 250),
(155, 1340, 1165.11, -2029.84, 68.9078, 0, 0, 50);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_player_skin_collection`
-- (See below for the actual view)
--
CREATE TABLE `v_player_skin_collection` (
`user_id` int(11)
,`username` varchar(24)
,`skin_id` int(11)
,`skin_name` varchar(64)
,`requires_vip` tinyint(1)
,`purchased_at` timestamp
,`purchase_price` int(11)
,`times_used` int(11)
,`last_used` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_popular_custom_skins`
-- (See below for the actual view)
--
CREATE TABLE `v_popular_custom_skins` (
`skin_id` int(11)
,`skin_name` varchar(64)
,`requires_vip` tinyint(1)
,`min_level` int(11)
,`cost` int(11)
,`total_owners` bigint(21)
,`total_uses` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Table structure for table `weapons`
--

CREATE TABLE `weapons` (
  `uid` int(10) DEFAULT NULL,
  `slot` tinyint(2) DEFAULT NULL,
  `weaponid` tinyint(2) DEFAULT NULL,
  `ammo` smallint(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weaponsettings`
--

CREATE TABLE `weaponsettings` (
  `Name` varchar(24) NOT NULL,
  `WeaponID` tinyint(4) NOT NULL,
  `PosX` float DEFAULT -0.116,
  `PosY` float DEFAULT 0.189,
  `PosZ` float DEFAULT 0.088,
  `RotX` float DEFAULT 0,
  `RotY` float DEFAULT 44.5,
  `RotZ` float DEFAULT 0,
  `Bone` tinyint(4) NOT NULL DEFAULT 1,
  `Hidden` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure for view `v_player_skin_collection`
--
DROP TABLE IF EXISTS `v_player_skin_collection`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_player_skin_collection`  AS SELECT `pcs`.`user_id` AS `user_id`, `u`.`username` AS `username`, `cs`.`skin_id` AS `skin_id`, `cs`.`skin_name` AS `skin_name`, `cs`.`requires_vip` AS `requires_vip`, `pcs`.`purchased_at` AS `purchased_at`, `pcs`.`purchase_price` AS `purchase_price`, `pcs`.`times_used` AS `times_used`, `pcs`.`last_used` AS `last_used` FROM ((`player_custom_skins` `pcs` join `users` `u` on(`pcs`.`user_id` = `u`.`uid`)) join `custom_skins` `cs` on(`pcs`.`skin_id` = `cs`.`skin_id`)) ORDER BY `pcs`.`user_id` ASC, `pcs`.`purchased_at` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `v_popular_custom_skins`
--
DROP TABLE IF EXISTS `v_popular_custom_skins`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_popular_custom_skins`  AS SELECT `cs`.`skin_id` AS `skin_id`, `cs`.`skin_name` AS `skin_name`, `cs`.`requires_vip` AS `requires_vip`, `cs`.`min_level` AS `min_level`, `cs`.`cost` AS `cost`, count(`pcs`.`id`) AS `total_owners`, sum(`pcs`.`times_used`) AS `total_uses` FROM (`custom_skins` `cs` left join `player_custom_skins` `pcs` on(`cs`.`skin_id` = `pcs`.`skin_id`)) GROUP BY `cs`.`skin_id` ORDER BY sum(`pcs`.`times_used`) DESC, count(`pcs`.`id`) DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `actors`
--
ALTER TABLE `actors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `anticheat_settings`
--
ALTER TABLE `anticheat_settings`
  ADD UNIQUE KEY `ac_code` (`ac_code`);

--
-- Indexes for table `arrest`
--
ALTER TABLE `arrest`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`atmID`);

--
-- Indexes for table `auctions`
--
ALTER TABLE `auctions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bb_music`
--
ALTER TABLE `bb_music`
  ADD PRIMARY KEY (`boomboxid`);

--
-- Indexes for table `billboards`
--
ALTER TABLE `billboards`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message` (`message`);

--
-- Indexes for table `changes`
--
ALTER TABLE `changes`
  ADD UNIQUE KEY `slot` (`slot`);

--
-- Indexes for table `charges`
--
ALTER TABLE `charges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clothing`
--
ALTER TABLE `clothing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `crates`
--
ALTER TABLE `crates`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `deliverpt`
--
ALTER TABLE `deliverpt`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `divisions`
--
ALTER TABLE `divisions`
  ADD UNIQUE KEY `id` (`id`,`divisionid`);

--
-- Indexes for table `entrances`
--
ALTER TABLE `entrances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `factionbanned`
--
ALTER TABLE `factionbanned`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `factiongarage`
--
ALTER TABLE `factiongarage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `factionlockers`
--
ALTER TABLE `factionlockers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `factionpay`
--
ALTER TABLE `factionpay`
  ADD UNIQUE KEY `id` (`id`,`rank`);

--
-- Indexes for table `factionranks`
--
ALTER TABLE `factionranks`
  ADD UNIQUE KEY `id` (`id`,`rank`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `factionskins`
--
ALTER TABLE `factionskins`
  ADD UNIQUE KEY `id` (`id`,`slot`);

--
-- Indexes for table `faction_vehicle`
--
ALTER TABLE `faction_vehicle`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `fishing_actors`
--
ALTER TABLE `fishing_actors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_zone_id` (`zone_id`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `fishing_audit`
--
ALTER TABLE `fishing_audit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_id` (`player_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_action_type` (`action_type`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `fishing_boats`
--
ALTER TABLE `fishing_boats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_zone_id` (`zone_id`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `fishing_inventory`
--
ALTER TABLE `fishing_inventory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_id` (`player_id`),
  ADD KEY `idx_fish_rarity` (`fish_rarity`);

--
-- Indexes for table `fishing_leaderboard`
--
ALTER TABLE `fishing_leaderboard`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `idx_total_caught` (`total_caught`),
  ADD KEY `idx_biggest_weight` (`biggest_weight`),
  ADD KEY `idx_legendary_count` (`legendary_count`);

--
-- Indexes for table `fishing_log`
--
ALTER TABLE `fishing_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_id` (`player_id`),
  ADD KEY `idx_fish_rarity` (`fish_rarity`),
  ADD KEY `idx_caught_at` (`caught_at`),
  ADD KEY `idx_zone_id` (`zone_id`);

--
-- Indexes for table `fishing_tournament_history`
--
ALTER TABLE `fishing_tournament_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_winner_id` (`winner_id`),
  ADD KEY `idx_tournament_type` (`tournament_type`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `fishing_zones`
--
ALTER TABLE `fishing_zones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_active` (`is_active`),
  ADD KEY `idx_zone_type` (`zone_type`);

--
-- Indexes for table `flags`
--
ALTER TABLE `flags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuelstation`
--
ALTER TABLE `fuelstation`
  ADD PRIMARY KEY (`fuelstationid`);

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gangranks`
--
ALTER TABLE `gangranks`
  ADD UNIQUE KEY `id` (`id`,`rank`);

--
-- Indexes for table `gangs`
--
ALTER TABLE `gangs`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `gangskins`
--
ALTER TABLE `gangskins`
  ADD UNIQUE KEY `id` (`id`,`slot`);

--
-- Indexes for table `garages`
--
ALTER TABLE `garages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`gateID`);

--
-- Indexes for table `graffities`
--
ALTER TABLE `graffities`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `greenzone`
--
ALTER TABLE `greenzone`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `keybind`
--
ALTER TABLE `keybind`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kills`
--
ALTER TABLE `kills`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `label`
--
ALTER TABLE `label`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `landobjects`
--
ALTER TABLE `landobjects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lands`
--
ALTER TABLE `lands`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lastdo`
--
ALTER TABLE `lastdo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lastme`
--
ALTER TABLE `lastme`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `localbuyer`
--
ALTER TABLE `localbuyer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_admin`
--
ALTER TABLE `log_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_bans`
--
ALTER TABLE `log_bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_cheat`
--
ALTER TABLE `log_cheat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_contracts`
--
ALTER TABLE `log_contracts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_faction`
--
ALTER TABLE `log_faction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_gang`
--
ALTER TABLE `log_gang`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_give`
--
ALTER TABLE `log_give`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_namechanges`
--
ALTER TABLE `log_namechanges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_property`
--
ALTER TABLE `log_property`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_punishments`
--
ALTER TABLE `log_punishments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_referrals`
--
ALTER TABLE `log_referrals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_vip`
--
ALTER TABLE `log_vip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `object`
--
ALTER TABLE `object`
  ADD PRIMARY KEY (`mobjID`);

--
-- Indexes for table `paintball`
--
ALTER TABLE `paintball`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `phonebook`
--
ALTER TABLE `phonebook`
  ADD UNIQUE KEY `number` (`number`);

--
-- Indexes for table `phonebookplayer`
--
ALTER TABLE `phonebookplayer`
  ADD PRIMARY KEY (`contactid`);

--
-- Indexes for table `plantzone`
--
ALTER TABLE `plantzone`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_fishing_level` (`fishing_level`),
  ADD KEY `idx_fishing_tokens` (`fishing_tokens`),
  ADD KEY `idx_fishing_total_caught` (`fishing_total_caught`);

--
-- Indexes for table `player_custom_skins`
--
ALTER TABLE `player_custom_skins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_skin` (`user_id`,`skin_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `skin_id` (`skin_id`),
  ADD KEY `idx_player_custom_skins_purchased` (`purchased_at`),
  ADD KEY `idx_player_custom_skins_used` (`times_used`);

--
-- Indexes for table `points`
--
ALTER TABLE `points`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `pooltables`
--
ALTER TABLE `pooltables`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `publicgarage`
--
ALTER TABLE `publicgarage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rankings`
--
ALTER TABLE `rankings`
  ADD PRIMARY KEY (`holdid`);

--
-- Indexes for table `rentvehicle`
--
ALTER TABLE `rentvehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rp_dealercars`
--
ALTER TABLE `rp_dealercars`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `shots`
--
ALTER TABLE `shots`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `speedcameras`
--
ALTER TABLE `speedcameras`
  ADD PRIMARY KEY (`speedID`);

--
-- Indexes for table `surgery`
--
ALTER TABLE `surgery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `texts`
--
ALTER TABLE `texts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tollgates`
--
ALTER TABLE `tollgates`
  ADD PRIMARY KEY (`TollgateID`);

--
-- Indexes for table `turfs`
--
ALTER TABLE `turfs`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`vendorID`);

--
-- Indexes for table `weapons`
--
ALTER TABLE `weapons`
  ADD UNIQUE KEY `uid` (`uid`,`slot`);

--
-- Indexes for table `weaponsettings`
--
ALTER TABLE `weaponsettings`
  ADD PRIMARY KEY (`WeaponID`),
  ADD UNIQUE KEY `weapon` (`Name`,`WeaponID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `actors`
--
ALTER TABLE `actors`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=411;

--
-- AUTO_INCREMENT for table `arrest`
--
ALTER TABLE `arrest`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=297;

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auctions`
--
ALTER TABLE `auctions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bb_music`
--
ALTER TABLE `bb_music`
  MODIFY `boomboxid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=511;

--
-- AUTO_INCREMENT for table `billboards`
--
ALTER TABLE `billboards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `charges`
--
ALTER TABLE `charges`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clothing`
--
ALTER TABLE `clothing`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `crates`
--
ALTER TABLE `crates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `custom_skins`
--
ALTER TABLE `custom_skins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `deliverpt`
--
ALTER TABLE `deliverpt`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=286;

--
-- AUTO_INCREMENT for table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=410;

--
-- AUTO_INCREMENT for table `factionbanned`
--
ALTER TABLE `factionbanned`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5498;

--
-- AUTO_INCREMENT for table `factiongarage`
--
ALTER TABLE `factiongarage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `factionlockers`
--
ALTER TABLE `factionlockers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `faction_vehicle`
--
ALTER TABLE `faction_vehicle`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fishing_actors`
--
ALTER TABLE `fishing_actors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `fishing_audit`
--
ALTER TABLE `fishing_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `fishing_boats`
--
ALTER TABLE `fishing_boats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `fishing_inventory`
--
ALTER TABLE `fishing_inventory`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT for table `fishing_log`
--
ALTER TABLE `fishing_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=240;

--
-- AUTO_INCREMENT for table `fishing_tournament_history`
--
ALTER TABLE `fishing_tournament_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fishing_zones`
--
ALTER TABLE `fishing_zones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `flags`
--
ALTER TABLE `flags`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `fuelstation`
--
ALTER TABLE `fuelstation`
  MODIFY `fuelstationid` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=401;

--
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4687;

--
-- AUTO_INCREMENT for table `garages`
--
ALTER TABLE `garages`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `gates`
--
ALTER TABLE `gates`
  MODIFY `gateID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=388;

--
-- AUTO_INCREMENT for table `greenzone`
--
ALTER TABLE `greenzone`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `keybind`
--
ALTER TABLE `keybind`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `kills`
--
ALTER TABLE `kills`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `label`
--
ALTER TABLE `label`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=318;

--
-- AUTO_INCREMENT for table `landobjects`
--
ALTER TABLE `landobjects`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1203;

--
-- AUTO_INCREMENT for table `lands`
--
ALTER TABLE `lands`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lastdo`
--
ALTER TABLE `lastdo`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lastme`
--
ALTER TABLE `lastme`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `localbuyer`
--
ALTER TABLE `localbuyer`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=297;

--
-- AUTO_INCREMENT for table `log_admin`
--
ALTER TABLE `log_admin`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `log_bans`
--
ALTER TABLE `log_bans`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_cheat`
--
ALTER TABLE `log_cheat`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `log_contracts`
--
ALTER TABLE `log_contracts`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_faction`
--
ALTER TABLE `log_faction`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_gang`
--
ALTER TABLE `log_gang`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_give`
--
ALTER TABLE `log_give`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_namechanges`
--
ALTER TABLE `log_namechanges`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_property`
--
ALTER TABLE `log_property`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_punishments`
--
ALTER TABLE `log_punishments`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_referrals`
--
ALTER TABLE `log_referrals`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_vip`
--
ALTER TABLE `log_vip`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `object`
--
ALTER TABLE `object`
  MODIFY `mobjID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1141;

--
-- AUTO_INCREMENT for table `paintball`
--
ALTER TABLE `paintball`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `phonebookplayer`
--
ALTER TABLE `phonebookplayer`
  MODIFY `contactid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `plantzone`
--
ALTER TABLE `plantzone`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `player_custom_skins`
--
ALTER TABLE `player_custom_skins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pooltables`
--
ALTER TABLE `pooltables`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `publicgarage`
--
ALTER TABLE `publicgarage`
  MODIFY `id` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `rankings`
--
ALTER TABLE `rankings`
  MODIFY `holdid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `rentvehicle`
--
ALTER TABLE `rentvehicle`
  MODIFY `id` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `rp_dealercars`
--
ALTER TABLE `rp_dealercars`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shots`
--
ALTER TABLE `shots`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `speedcameras`
--
ALTER TABLE `speedcameras`
  MODIFY `speedID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `surgery`
--
ALTER TABLE `surgery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `texts`
--
ALTER TABLE `texts`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `tollgates`
--
ALTER TABLE `tollgates`
  MODIFY `TollgateID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=288;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `uid` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `vendorID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT for table `weaponsettings`
--
ALTER TABLE `weaponsettings`
  MODIFY `WeaponID` tinyint(4) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fishing_actors`
--
ALTER TABLE `fishing_actors`
  ADD CONSTRAINT `fishing_actors_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `fishing_zones` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fishing_boats`
--
ALTER TABLE `fishing_boats`
  ADD CONSTRAINT `fishing_boats_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `fishing_zones` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fishing_inventory`
--
ALTER TABLE `fishing_inventory`
  ADD CONSTRAINT `fishing_inventory_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fishing_leaderboard`
--
ALTER TABLE `fishing_leaderboard`
  ADD CONSTRAINT `fishing_leaderboard_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fishing_log`
--
ALTER TABLE `fishing_log`
  ADD CONSTRAINT `fishing_log_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fishing_tournament_history`
--
ALTER TABLE `fishing_tournament_history`
  ADD CONSTRAINT `fishing_tournament_history_ibfk_1` FOREIGN KEY (`winner_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_custom_skins`
--
ALTER TABLE `player_custom_skins`
  ADD CONSTRAINT `fk_player_custom_skins_skin` FOREIGN KEY (`skin_id`) REFERENCES `custom_skins` (`skin_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_player_custom_skins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`uid`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
