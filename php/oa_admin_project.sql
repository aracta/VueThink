/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : vuethink

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2020-07-21 09:08:18
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for oa_admin_project
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_project`;
CREATE TABLE `oa_admin_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0',
  `projectname` varchar(100) NOT NULL DEFAULT '' COMMENT '项目名称',
  `website` varchar(255) NOT NULL DEFAULT '' COMMENT '目标网站',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '项目简介',
  `demander` varchar(100) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `developer` varchar(100) NOT NULL DEFAULT '' COMMENT '开发者',
  `status` tinyint(3) NOT NULL DEFAULT '0',
  `createtime` datetime DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `finishedtime` datetime DEFAULT NULL,
  `prjtotal` float(10,2) DEFAULT NULL COMMENT '项目总得分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of oa_admin_project
-- ----------------------------
INSERT INTO `oa_admin_project` VALUES ('16', '0', '测试项目', '', '简介jiean简介fvc  sf\n这是顶顶顶顶是第二段\n222\n飞洒\n福克斯', '万晶', '石小洁', '1', '2020-06-10 14:33:26', '2020-06-16 14:33:30', '2020-07-15 02:20:52', '1420.88');
INSERT INTO `oa_admin_project` VALUES ('18', '0', 'gd', '', 'c当场出彩', 'c', 'f', '0', '2020-07-16 13:46:09', '2020-07-31 13:46:14', null, null);
INSERT INTO `oa_admin_project` VALUES ('21', '0', 'dfefffffgg', '', 'fes 解决解决军..\n..方法\n34', 'fes', 'sef', '0', '2020-07-16 13:56:04', '2020-07-30 13:53:47', null, null);
INSERT INTO `oa_admin_project` VALUES ('23', '0', '此处', '', '方法', '呃呃呃', '额', '0', '2020-07-16 14:15:16', '2020-07-22 14:11:57', null, '246.28');
INSERT INTO `oa_admin_project` VALUES ('26', '0', '你', '', '个', '个人', '的', '0', '2020-07-16 14:28:40', '2020-07-01 00:00:40', null, '209.09');
INSERT INTO `oa_admin_project` VALUES ('27', '0', '华绒苞藤', '', '个人', '个人', '个', '1', '2020-05-16 14:29:11', '2020-07-23 14:29:18', null, '394.29');
