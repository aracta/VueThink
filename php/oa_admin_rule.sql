/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : vuethink

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2020-07-21 09:09:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for oa_admin_rule
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_rule`;
CREATE TABLE `oa_admin_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT '' COMMENT '名称',
  `name` varchar(100) DEFAULT '' COMMENT '定义',
  `level` tinyint(5) DEFAULT NULL COMMENT '级别。1模块,2控制器,3操作',
  `pid` int(11) DEFAULT '0' COMMENT '父id，默认0',
  `status` tinyint(3) DEFAULT '1' COMMENT '状态，1启用，0禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of oa_admin_rule
-- ----------------------------
INSERT INTO `oa_admin_rule` VALUES ('10', '系统基础功能', 'admin', '1', '0', '1');
INSERT INTO `oa_admin_rule` VALUES ('11', '权限规则', 'rules', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('13', '规则列表', 'index', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('14', '权限详情', 'read', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('15', '编辑权限', 'update', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('16', '删除权限', 'delete', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('17', '添加权限', 'save', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('18', '批量删除权限', 'deletes', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('19', '批量启用/禁用权限', 'enables', '3', '11', '1');
INSERT INTO `oa_admin_rule` VALUES ('20', '菜单管理', 'menus', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('21', '菜单列表', 'index', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('22', '添加菜单', 'save', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('23', '菜单详情', 'read', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('24', '编辑菜单', 'update', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('25', '删除菜单', 'delete', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('26', '批量删除菜单', 'deletes', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('27', '批量启用/禁用菜单', 'enables', '3', '20', '1');
INSERT INTO `oa_admin_rule` VALUES ('28', '系统管理', 'systemConfigs', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('29', '修改系统配置', 'save', '3', '28', '1');
INSERT INTO `oa_admin_rule` VALUES ('30', '岗位管理', 'posts', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('31', '岗位列表', 'index', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('32', '岗位详情', 'read', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('33', '编辑岗位', 'update', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('34', '删除岗位', 'delete', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('35', '添加岗位', 'save', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('36', '批量删除岗位', 'deletes', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('37', '批量启用/禁用岗位', 'enables', '3', '30', '1');
INSERT INTO `oa_admin_rule` VALUES ('38', '部门管理', 'structures', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('39', '部门列表', 'index', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('40', '部门详情', 'read', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('41', '编辑部门', 'update', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('42', '删除部门', 'delete', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('43', '添加部门', 'save', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('44', '批量删除部门', 'deletes', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('45', '批量启用/禁用部门', 'enables', '3', '38', '1');
INSERT INTO `oa_admin_rule` VALUES ('46', '用户组管理', 'groups', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('47', '用户组列表', 'index', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('48', '用户组详情', 'read', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('49', '编辑用户组', 'update', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('50', '删除用户组', 'delete', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('51', '添加用户组', 'save', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('52', '批量删除用户组', 'deletes', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('53', '批量启用/禁用用户组', 'enables', '3', '46', '1');
INSERT INTO `oa_admin_rule` VALUES ('54', '成员管理', 'users', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('55', '成员列表', 'index', '3', '54', '1');
INSERT INTO `oa_admin_rule` VALUES ('56', '成员详情', 'read', '3', '54', '1');
INSERT INTO `oa_admin_rule` VALUES ('57', '删除成员', 'delete', '3', '54', '1');
INSERT INTO `oa_admin_rule` VALUES ('59', '管理菜单', 'Adminstrative', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('61', '系统管理二级菜单', 'systemConfig', '1', '59', '1');
INSERT INTO `oa_admin_rule` VALUES ('62', '账户管理二级菜单', 'personnel', '3', '59', '1');
INSERT INTO `oa_admin_rule` VALUES ('63', '组织架构二级菜单', 'structures', '3', '59', '1');
INSERT INTO `oa_admin_rule` VALUES ('65', '项目管理', 'projects', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('66', '项目列表', 'index', '3', '65', '1');
INSERT INTO `oa_admin_rule` VALUES ('67', '编辑项目', 'update', '3', '65', '1');
INSERT INTO `oa_admin_rule` VALUES ('68', '项目难度评分', 'projectDfcltrcd', '1', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('69', '编辑和保存', 'update', '3', '68', '1');
INSERT INTO `oa_admin_rule` VALUES ('70', '添加项目', 'save', '3', '65', '1');
INSERT INTO `oa_admin_rule` VALUES ('71', '项目得分', 'projectRcd', '2', '10', '1');
INSERT INTO `oa_admin_rule` VALUES ('72', '编辑和保存', 'update', '3', '71', '1');
INSERT INTO `oa_admin_rule` VALUES ('73', '删除项目', 'delete', '3', '65', '1');
