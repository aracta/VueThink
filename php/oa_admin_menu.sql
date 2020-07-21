/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : vuethink

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2020-07-21 09:08:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for oa_admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_menu`;
CREATE TABLE `oa_admin_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `pid` int(11) unsigned DEFAULT '0' COMMENT '上级菜单ID',
  `title` varchar(32) DEFAULT '' COMMENT '菜单名称',
  `url` varchar(127) DEFAULT '' COMMENT '链接地址',
  `icon` varchar(64) DEFAULT '' COMMENT '图标',
  `menu_type` tinyint(4) DEFAULT NULL COMMENT '菜单类型',
  `sort` tinyint(4) unsigned DEFAULT '0' COMMENT '排序（同级有效）',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态',
  `rule_id` int(11) DEFAULT NULL COMMENT '权限id',
  `module` varchar(50) DEFAULT NULL,
  `menu` varchar(50) DEFAULT NULL COMMENT '三级菜单吗',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COMMENT='【配置】后台菜单表';

-- ----------------------------
-- Records of oa_admin_menu
-- ----------------------------
INSERT INTO `oa_admin_menu` VALUES ('52', '0', '管理', '/home/users/list', '', '1', '0', '1', '59', 'Administrative', '');
INSERT INTO `oa_admin_menu` VALUES ('53', '52', '系统配置', '', '', '1', '0', '1', '61', 'Administrative', '');
INSERT INTO `oa_admin_menu` VALUES ('54', '53', '后台菜单', '/home/menu/list', '', '1', '5', '1', '21', 'Administrative', 'menu');
INSERT INTO `oa_admin_menu` VALUES ('55', '53', '系统参数', '/home/config/add', '', '1', '0', '1', '29', 'Administrative', 'systemConfig');
INSERT INTO `oa_admin_menu` VALUES ('56', '53', '后端权限', '/home/rule/list', '', '1', '10', '1', '13', 'Administrative', 'rule');
INSERT INTO `oa_admin_menu` VALUES ('57', '52', '组织架构', '', '', '1', '0', '1', '63', 'Administrative', '');
INSERT INTO `oa_admin_menu` VALUES ('58', '57', '岗位管理', '/home/position/list', '', '1', '0', '1', '31', 'Administrative', 'position');
INSERT INTO `oa_admin_menu` VALUES ('59', '57', '部门管理', '/home/structures/list', '', '1', '0', '1', '39', 'Administrative', 'structures');
INSERT INTO `oa_admin_menu` VALUES ('60', '61', '用户组管理', '/home/groups/list', '', '1', '10', '1', '47', 'Administrative', 'groups');
INSERT INTO `oa_admin_menu` VALUES ('61', '52', '用户管理', '', '', '1', '0', '1', '62', 'Administrative', '');
INSERT INTO `oa_admin_menu` VALUES ('62', '61', '用户列表', '/home/users/list', '', '1', '0', '1', '55', 'Administrative', 'users');
INSERT INTO `oa_admin_menu` VALUES ('63', '65', '项目管理', '', '', '1', '0', '1', '65', 'Project', '');
INSERT INTO `oa_admin_menu` VALUES ('64', '63', '项目列表', '/home/projects/list', '', '2', '0', '1', '66', 'Project', 'projects');
INSERT INTO `oa_admin_menu` VALUES ('65', '0', '项目', '', '', '1', '0', '1', '65', 'Project', '');
