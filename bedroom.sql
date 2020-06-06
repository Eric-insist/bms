/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80018
 Source Host           : localhost:3306
 Source Schema         : bedroom

 Target Server Type    : MySQL
 Target Server Version : 80018
 File Encoding         : 65001

 Date: 06/06/2020 11:11:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_apply
-- ----------------------------
DROP TABLE IF EXISTS `t_apply`;
CREATE TABLE `t_apply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL COMMENT '申请人id',
  `user_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请人姓名',
  `type` int(4) NULL DEFAULT NULL COMMENT '申请类型1：换寝 2：维修',
  `apply_time` datetime(0) NULL DEFAULT NULL COMMENT '申请时间',
  `state` int(4) NULL DEFAULT NULL COMMENT '审核状态1:未审核2:已审核',
  `room_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '寝室号',
  `tower_no` int(11) NULL DEFAULT NULL COMMENT '寝室楼栋号',
  `description` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `new_room_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '新寝室号',
  `submit_time` datetime(0) NULL DEFAULT NULL COMMENT '审批时间',
  `result` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核结果',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_apply
-- ----------------------------
INSERT INTO `t_apply` VALUES (1, 2, NULL, 2, '2020-04-10 13:50:48', 1, '4218', 4, '灯坏了（自然损坏）', NULL, NULL, NULL);
INSERT INTO `t_apply` VALUES (2, 2, NULL, 1, '2020-04-11 11:59:05', 2, '4218', 4, '换寝室到4217', '4217', NULL, '同意');
INSERT INTO `t_apply` VALUES (3, 2, NULL, 1, '2020-04-25 22:06:25', 1, '4217', 4, '换寝(从4217换到4218)', '4218', NULL, NULL);
INSERT INTO `t_apply` VALUES (4, 2, NULL, 2, '2020-04-25 22:42:42', 1, '4217', 4, '水龙头坏了(自然损坏)', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for t_late
-- ----------------------------
DROP TABLE IF EXISTS `t_late`;
CREATE TABLE `t_late`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '学号',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `room_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '寝室号',
  `time` datetime(0) NULL DEFAULT NULL COMMENT '晚归时间',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '晚归原因',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '录入人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '学生晚归信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_late
-- ----------------------------
INSERT INTO `t_late` VALUES (1, '2016407021', NULL, '', '2020-04-27 11:12:32', '吃饭', 1);
INSERT INTO `t_late` VALUES (2, '2016407021', NULL, NULL, '2020-04-27 00:00:00', '测试', 1);

-- ----------------------------
-- Table structure for t_lifan
-- ----------------------------
DROP TABLE IF EXISTS `t_lifan`;
CREATE TABLE `t_lifan`  (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '学号',
  `out_time` datetime(0) NULL DEFAULT NULL COMMENT '离校时间',
  `in_time` datetime(0) NULL DEFAULT NULL COMMENT '返校时间',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '离校原因',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '录入人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_lifan
-- ----------------------------
INSERT INTO `t_lifan` VALUES (1, '2016407021', '2020-04-27 00:00:00', '2020-04-28 00:00:00', '放假', 1);
INSERT INTO `t_lifan` VALUES (2, '2016407021', '2020-04-27 00:00:00', '2020-04-29 00:00:00', '测试', 1);

-- ----------------------------
-- Table structure for t_log
-- ----------------------------
DROP TABLE IF EXISTS `t_log`;
CREATE TABLE `t_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户姓名',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '操作内容的的描述',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '1=新增，2=修改，3=删除，4=查询',
  `time` datetime(0) NOT NULL COMMENT '操作时间',
  `organ_id` int(11) NULL DEFAULT NULL COMMENT '机构id',
  `organ_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构编码',
  `organ_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 92 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志\r\n\r\n' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_log
-- ----------------------------
INSERT INTO `t_log` VALUES (86, 1, NULL, '登陆了系统', 4, '2020-05-19 22:39:45', 1, NULL, NULL);
INSERT INTO `t_log` VALUES (87, 1, NULL, '访问了入住办理页面', 4, '2020-05-19 22:39:53', 1, NULL, NULL);
INSERT INTO `t_log` VALUES (88, 1, NULL, '访问了审批中心页面', 4, '2020-05-19 22:39:57', 1, NULL, NULL);
INSERT INTO `t_log` VALUES (89, 1, NULL, '登陆了系统', 4, '2020-05-20 11:04:17', 1, NULL, NULL);
INSERT INTO `t_log` VALUES (90, 1, NULL, '访问了用户管理页面', 4, '2020-05-20 11:04:34', 1, NULL, NULL);
INSERT INTO `t_log` VALUES (91, 1, NULL, '访问了学生列表页面', 4, '2020-05-20 11:07:33', 1, NULL, NULL);

-- ----------------------------
-- Table structure for t_organ
-- ----------------------------
DROP TABLE IF EXISTS `t_organ`;
CREATE TABLE `t_organ`  (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `organ_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构名称',
  `short_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构简称',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构路径',
  `parent_id` int(20) NULL DEFAULT NULL COMMENT '父机构id',
  `parent_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父机构名称',
  `level` tinyint(4) NULL DEFAULT NULL COMMENT '层级',
  `flag` tinyint(4) NULL DEFAULT 1 COMMENT '是否显示（表示删除）',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_organ
-- ----------------------------
INSERT INTO `t_organ` VALUES (1, '学校', NULL, '0', 0, NULL, 1, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (2, '藏学学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (3, '外国语学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (4, '教育科学学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (5, '理工学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (6, '音乐舞蹈学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (7, '美术学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (8, '文学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (9, '经济与管理学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (10, '法学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (11, '马克思主义学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (12, '农学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (13, '历史文化与旅游学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (14, '体育学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (15, '预科教育学院', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (16, '宿舍办公室', NULL, '0.1', 1, '学校', 2, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (17, '1641', NULL, '0.1.5', 5, '理工学院', 3, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (18, '1642', NULL, '0.1.5', 5, '理工学院', 3, 1, '2020-02-25 17:30:57', NULL);
INSERT INTO `t_organ` VALUES (19, '1641', NULL, '0.1.2', 2, '藏学学院', 3, 1, '2020-05-19 10:14:43', NULL);
INSERT INTO `t_organ` VALUES (20, '1642', NULL, '0.1.2', 2, '藏学学院', 3, 1, '2020-05-19 10:15:03', NULL);
INSERT INTO `t_organ` VALUES (21, '1741', NULL, '0.1.5', 5, '理工学院', 3, 1, '2020-05-19 10:15:35', NULL);
INSERT INTO `t_organ` VALUES (22, '1742', NULL, '0.1.5', 5, '理工学院', 3, 1, '2020-05-19 10:15:43', NULL);

-- ----------------------------
-- Table structure for t_outsider
-- ----------------------------
DROP TABLE IF EXISTS `t_outsider`;
CREATE TABLE `t_outsider`  (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `in_time` datetime(0) NULL DEFAULT NULL COMMENT '进入时间',
  `out_time` datetime(0) NULL DEFAULT NULL COMMENT '离开时间',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_outsider
-- ----------------------------
INSERT INTO `t_outsider` VALUES (2, '测试01', '12345678910', '2020-05-04 03:04:04', '2020-05-04 05:03:04', '测试');
INSERT INTO `t_outsider` VALUES (3, '测试02', '12345678910', '2020-05-19 19:46:37', '2020-05-19 20:46:40', '测试');

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `describe` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_role
-- ----------------------------
INSERT INTO `t_role` VALUES (1, '系统管理员', '管理整个系统', '2019-12-12 15:22:51', '2019-12-12 15:22:58');
INSERT INTO `t_role` VALUES (2, '宿舍管理员', '管理宿舍', '2019-12-12 15:22:54', '2019-12-12 15:23:00');
INSERT INTO `t_role` VALUES (3, '辅导员', '管理学生', '2019-12-12 15:22:54', '2019-12-12 15:22:54');
INSERT INTO `t_role` VALUES (4, '学生', '学生权限', '2019-12-12 15:22:55', '2019-12-12 15:23:02');
INSERT INTO `t_role` VALUES (5, '维修人员', '进行维修工作', '2020-01-17 13:40:57', '2020-01-17 13:40:58');

-- ----------------------------
-- Table structure for t_room
-- ----------------------------
DROP TABLE IF EXISTS `t_room`;
CREATE TABLE `t_room`  (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `room_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '寝室号',
  `tower_no` int(11) NULL DEFAULT NULL COMMENT '宿舍楼编号（几栋）',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '寝室联系方式',
  `user_id` int(20) NULL DEFAULT NULL COMMENT '室长id',
  `real_person` int(4) NULL DEFAULT 0 COMMENT '实际入住人数',
  `max_person` int(4) NULL DEFAULT NULL COMMENT '最多入住人数',
  `flag` tinyint(4) NULL DEFAULT 1 COMMENT '是否显示（表示删除）',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `room_man` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '寝室信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_room
-- ----------------------------
INSERT INTO `t_room` VALUES (1, '1104', 1, '12345678910', NULL, 0, 3, 1, '2020-02-03 14:24:03', '2020-04-21 11:29:52', NULL);
INSERT INTO `t_room` VALUES (2, '1102', 1, '12345678911', NULL, 0, 4, 1, '2020-02-03 14:24:49', '2020-05-05 11:12:05', NULL);
INSERT INTO `t_room` VALUES (3, '2103', 2, '12345678912', NULL, 0, 4, 1, '2020-02-03 14:26:14', '2020-02-27 16:21:18', NULL);
INSERT INTO `t_room` VALUES (4, '2101', 2, '12345678920', NULL, 0, 4, 1, '2020-02-03 14:26:56', NULL, NULL);
INSERT INTO `t_room` VALUES (5, '2201', 2, '12345678922', NULL, 0, 4, 1, '2020-02-03 14:27:26', NULL, NULL);
INSERT INTO `t_room` VALUES (6, '4218', 4, '123456', NULL, 1, 4, 1, '2020-02-26 16:13:06', NULL, NULL);
INSERT INTO `t_room` VALUES (7, '4222', 4, NULL, NULL, 0, 4, 1, '2020-02-26 17:18:08', '2020-04-06 17:07:55', NULL);
INSERT INTO `t_room` VALUES (8, '4216', 4, NULL, NULL, 0, 4, 1, '2020-02-26 17:22:07', NULL, NULL);
INSERT INTO `t_room` VALUES (9, '4217', 4, NULL, NULL, 1, 4, 1, '2020-02-26 17:25:02', NULL, NULL);
INSERT INTO `t_room` VALUES (11, '3456', 3, NULL, NULL, 0, 4, 1, '2020-04-14 16:33:12', NULL, NULL);
INSERT INTO `t_room` VALUES (12, '1103', 1, NULL, NULL, 0, 4, 1, '2020-04-21 09:20:38', NULL, NULL);

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `salt` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `age` int(10) NULL DEFAULT NULL COMMENT '年龄',
  `sex` int(10) NULL DEFAULT NULL COMMENT '性别',
  `id_card` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `organ_id` int(20) NULL DEFAULT NULL COMMENT '机构id',
  `organ_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构名称',
  `parent_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父机构名称',
  `student_class` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `room_id` int(11) NULL DEFAULT NULL COMMENT '房间id',
  `in_date` datetime(0) NULL DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `home` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `live_place` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `flag` int(4) NULL DEFAULT NULL,
  `role_id` int(4) NULL DEFAULT NULL,
  `tower_no` int(4) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', NULL, '超级管理员', NULL, NULL, NULL, 1, '学校', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, '2020-04-16 19:10:55', NULL);
INSERT INTO `t_user` VALUES (2, '2016407021', 'e10adc3949ba59abbe56e057f20f883e', NULL, '测试01', 21, 1, '123456789123456789', 18, NULL, NULL, NULL, 9, '2020-04-16 00:00:00', '12345678910', '四川成都', '四川成都', 1, 4, NULL, '2020-04-16 19:14:48', NULL);
INSERT INTO `t_user` VALUES (3, '4001', 'e10adc3949ba59abbe56e057f20f883e', NULL, '4栋管理员', 21, 1, '123456789123456789', 16, NULL, NULL, NULL, NULL, NULL, '12345678910', NULL, NULL, 1, 2, 4, '2020-04-21 13:26:09', NULL);
INSERT INTO `t_user` VALUES (4, '2016407052', 'e10adc3949ba59abbe56e057f20f883e', NULL, '测试2', 21, 1, '123456789123456789', 18, NULL, NULL, NULL, 6, '2020-04-22 00:00:00', '12345678910', '四川', '四川', 1, 4, NULL, '2020-04-22 09:46:24', NULL);

SET FOREIGN_KEY_CHECKS = 1;
