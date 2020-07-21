/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : vuethink

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2020-07-21 09:08:30
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for oa_admin_project_dfcltrcd
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_project_dfcltrcd`;
CREATE TABLE `oa_admin_project_dfcltrcd` (
  `id` int(11) NOT NULL,
  `techtypes` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '技术栈',
  `prjtype` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '业务类型',
  `scale` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目大小',
  `urgency` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目工期',
  `experience` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '项目经验',
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '开发者角色',
  `techsTotal` float(10,2) DEFAULT '0.00' COMMENT '难度评分总计',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of oa_admin_project_dfcltrcd
-- ----------------------------
INSERT INTO `oa_admin_project_dfcltrcd` VALUES ('16', 'Html/H5,微信开发,小程序,JS/jQuery,CSS/CSS3,Apache/Nginx', '样式优化', '', '紧急', '全新', '包干', '337.50');
INSERT INTO `oa_admin_project_dfcltrcd` VALUES ('26', 'CDN', '单页面全新制作', '', '适度缩紧', '全新', '主导', '145.20');
INSERT INTO `oa_admin_project_dfcltrcd` VALUES ('27', 'Html/H5,CSS/CSS3,Memcache,Apache/Nginx,JS/jQuery,Linux,微信开发,FTP,小程序,Vue,PHP,MySQL,Redis', '单页面改版/翻新', '', '紧急', '重复', '辅助', '117.00');
INSERT INTO `oa_admin_project_dfcltrcd` VALUES ('18', 'CDN', '单页面改版/翻新', '', '适度缩紧', '全新', '包干', '178.20');
INSERT INTO `oa_admin_project_dfcltrcd` VALUES ('22', 'Apache/Nginx,微信开发', '单页面改版/翻新', '', '适度缩紧', '参考', '包干', '190.08');
INSERT INTO `oa_admin_project_dfcltrcd` VALUES ('23', 'Memcache', '单功能点开发/优化/修改', '', '无期限', '全新', '包干', '58.50');
