/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : vuethink

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2020-07-21 09:08:44
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for oa_admin_project_rcd
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_project_rcd`;
CREATE TABLE `oa_admin_project_rcd` (
  `id` int(11) NOT NULL,
  `atitude` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '服务态度',
  `fnstime` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '完成时间',
  `fnseffect` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '完成效果',
  `adjust` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '实际调整',
  `creative` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '主动创新',
  `itemsTotal` float(10,2) DEFAULT '0.00' COMMENT '项目得分总计',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of oa_admin_project_rcd
-- ----------------------------
INSERT INTO `oa_admin_project_rcd` VALUES ('26', '积极沟通', '提前', '达到预期', '难度降低', '无', '1.44');
INSERT INTO `oa_admin_project_rcd` VALUES ('16', '积极沟通', '提前', '超出预期', '难度提高', '重大改进方案', '4.21');
INSERT INTO `oa_admin_project_rcd` VALUES ('27', '积极沟通', '提前', '超出预期', '难度提高', '局部改进建议', '3.37');
INSERT INTO `oa_admin_project_rcd` VALUES ('23', '积极沟通', '提前', '超出预期', '难度提高', '重大改进方案', '4.21');
