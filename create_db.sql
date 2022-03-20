SET AUTOCOMMIT = OFF;

START TRANSACTION;

DROP TABLE types;

COMMIT;

START TRANSACTION;

DROP TABLE shares;

COMMIT;


START TRANSACTION;

CREATE DATABASE database_lua;

COMMIT;

START TRANSACTION;

CREATE TABLE `types` (
  `id` int(11) NOT NULL,
  `type_name` VARCHAR(20) NOT NULL,
  `type_full_name` VARCHAR(50) NOT NULL
);

COMMIT;

START TRANSACTION;

INSERT INTO `types` (`id`, `type_name`, `type_full_name`) VALUES
(1, 'CPShares', 'Cumulative Preference Shares'),
(2, 'NCPShares', 'Non Cumulative Preference Shares'),
(3, 'IPShares', 'Irredeemable Preference Shares'),
(4, 'PPShares', 'Participating Preference Shares'),
(5, 'CPShares', 'Convertible Preference Shares');

COMMIT;

START TRANSACTION;

CREATE TABLE `shares` (
  `id` int(10) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `bid` int(10) NOT NULL,
  `ask` int(10) NOT NULL,
  `typeid` int(10) NOT NULL
);

COMMIT;

START TRANSACTION;

INSERT INTO `shares` (`id`, `name`, `bid`, `ask`, `typeid`) VALUES
(1, 'CPShares1', 10, 12, 1),
(2, 'CPShares2', 11, 13, 1),
(3, 'CPShares3', 12, 14, 1),
(4, 'CPShares4', 13, 14, 1),
(5, 'NCPShares1', 22, 23, 2),
(6, 'NCPShares2', 22, 23, 2),
(7, 'NCPShares3', 22, 23, 2),
(8, 'NCPShares4', 22, 23, 2),
(9, 'IPShares1',  33, 34, 3),
(10, 'IPShares2', 33, 34, 3),
(11, 'IPShares3', 33, 34, 3),
(12, 'IPShares4', 33, 34, 3),
(13, 'IPShares5', 33, 34, 3);

COMMIT;