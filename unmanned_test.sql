/*
 Navicat Premium Data Transfer

 Source Server         : 实训
 Source Server Type    : MySQL
 Source Server Version : 50717
 Source Host           : localhost:3306
 Source Schema         : unmanned_test

 Target Server Type    : MySQL
 Target Server Version : 50717
 File Encoding         : 65001

 Date: 27/07/2025 15:37:39
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for analysis_chart
-- ----------------------------
DROP TABLE IF EXISTS `analysis_chart`;
CREATE TABLE `analysis_chart`  (
  `chart_id` int(11) NOT NULL AUTO_INCREMENT,
  `chart_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图表名称',
  `chart_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图表类型',
  `data_source` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '数据来源',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`chart_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of analysis_chart
-- ----------------------------
INSERT INTO `analysis_chart` VALUES (1, '通过率排名', '柱状图', NULL, '2025-07-27 14:14:26');

-- ----------------------------
-- Table structure for control_station
-- ----------------------------
DROP TABLE IF EXISTS `control_station`;
CREATE TABLE `control_station`  (
  `station_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '无人平台控制站id',
  `station_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '控制站名称',
  `unit_id` int(11) NULL DEFAULT NULL COMMENT '所属参试单位',
  `station_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '控制站类型',
  `ip_address` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '控制站IP地址',
  `port` int(11) NULL DEFAULT NULL COMMENT '通信端口',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '连接状态（0-离线，1-在线）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(4) NULL DEFAULT NULL COMMENT '逻辑删除',
  PRIMARY KEY (`station_id`) USING BTREE,
  INDEX `fk1_unit_id`(`unit_id`) USING BTREE,
  CONSTRAINT `fk1_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `participate_unit` (`unit_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1002 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of control_station
-- ----------------------------
INSERT INTO `control_station` VALUES (1001, '无人机控制站A', 1, '无人机控制站', '192.168.1.001', 3033, 1, '2025-07-27 13:37:36', '2025-07-27 13:37:38', 0);

-- ----------------------------
-- Table structure for data_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `data_dictionary`;
CREATE TABLE `data_dictionary`  (
  `dict_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '字典id',
  `dict_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字典类型',
  `dict_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '键',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '值',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`dict_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of data_dictionary
-- ----------------------------
INSERT INTO `data_dictionary` VALUES (1, 'result', '0', '不通过', 1);
INSERT INTO `data_dictionary` VALUES (2, 'result', '1', '通过', 1);
INSERT INTO `data_dictionary` VALUES (3, 'result', '2', '未测试', 1);
INSERT INTO `data_dictionary` VALUES (4, 'user_status', '0', '禁用', 2);
INSERT INTO `data_dictionary` VALUES (5, 'user_status', '1', '正常', 2);
INSERT INTO `data_dictionary` VALUES (6, 'task_status', '0', '未开始', 3);
INSERT INTO `data_dictionary` VALUES (7, 'task_status', '1', '进行中', 3);
INSERT INTO `data_dictionary` VALUES (8, 'task_status', '2', '已完成', 3);
INSERT INTO `data_dictionary` VALUES (9, 'task_status', '3', '失败', 3);
INSERT INTO `data_dictionary` VALUES (10, 'is_delete', '0', '未删', 4);
INSERT INTO `data_dictionary` VALUES (11, 'is_delete', '1', '已删', 4);
INSERT INTO `data_dictionary` VALUES (12, 'station_status', '0', '离线', 5);
INSERT INTO `data_dictionary` VALUES (13, 'station_status', '1', '在线', 5);

-- ----------------------------
-- Table structure for instruction
-- ----------------------------
DROP TABLE IF EXISTS `instruction`;
CREATE TABLE `instruction`  (
  `instruction_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '指令id',
  `instruction_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '指令名称',
  `protocol_id` int(11) NULL DEFAULT NULL COMMENT '所属协议',
  `instruction_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '指令编码',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '指令内容',
  `instruction_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '指令类型',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(4) NULL DEFAULT NULL COMMENT '逻辑删除',
  PRIMARY KEY (`instruction_id`) USING BTREE,
  INDEX `fk2_protocol_id`(`protocol_id`) USING BTREE,
  CONSTRAINT `fk2_protocol_id` FOREIGN KEY (`protocol_id`) REFERENCES `protocol` (`protocol_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of instruction
-- ----------------------------
INSERT INTO `instruction` VALUES (1, '起飞指令', 1, 'CMD_TAKE_OFF', '{\"altitude\": 100, \"speed\": 10}', '控制指令', '2025-07-27 13:45:25', '2025-07-27 13:45:29', 0);

-- ----------------------------
-- Table structure for organization
-- ----------------------------
DROP TABLE IF EXISTS `organization`;
CREATE TABLE `organization`  (
  `org_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '组织机构id',
  `org_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机构名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '机构描述',
  PRIMARY KEY (`org_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of organization
-- ----------------------------
INSERT INTO `organization` VALUES (1, '测试部门', '负责测试的部门');

-- ----------------------------
-- Table structure for participate_unit
-- ----------------------------
DROP TABLE IF EXISTS `participate_unit`;
CREATE TABLE `participate_unit`  (
  `unit_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '参试单位id（唯一标识）',
  `unit_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位名称',
  `contact_person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `unit_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位类型',
  `address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位地址',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(4) NULL DEFAULT NULL COMMENT '逻辑删除',
  PRIMARY KEY (`unit_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of participate_unit
-- ----------------------------
INSERT INTO `participate_unit` VALUES (1, '西南交通大学', '张三', '13500131311', '科研机构', '成都市郫都区999号', '2025-07-27 13:35:52', '2025-07-27 13:35:56', 0);

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '权限id',
  `permission_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限名称',
  `permission_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限编码',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父权限',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '权限描述',
  PRIMARY KEY (`permission_id`) USING BTREE,
  INDEX `parent_id`(`parent_id`) USING BTREE,
  CONSTRAINT `parent_id` FOREIGN KEY (`parent_id`) REFERENCES `permission` (`permission_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES (1, '参试单位管理权限', 'unit:manage', NULL, '可管理参试单位信息');

-- ----------------------------
-- Table structure for protocol
-- ----------------------------
DROP TABLE IF EXISTS `protocol`;
CREATE TABLE `protocol`  (
  `protocol_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '协议唯一标识',
  `protocol_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '协议名称',
  `protocol_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '协议类型',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '协议描述',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(4) NULL DEFAULT NULL COMMENT '逻辑删除',
  PRIMARY KEY (`protocol_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of protocol
-- ----------------------------
INSERT INTO `protocol` VALUES (1, 'GJB7102-2010协议', '通信协议', '符合GJB7102-2010标准的协议', '2025-07-26 01:13:52', '2025-07-26 01:13:54', 0);

-- ----------------------------
-- Table structure for protocol_message_format
-- ----------------------------
DROP TABLE IF EXISTS `protocol_message_format`;
CREATE TABLE `protocol_message_format`  (
  `format_id` int(11) NOT NULL COMMENT '协议相关指令报文格式id',
  `protocol_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '所属协议',
  `field_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段名称',
  `data_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据类型',
  `length` int(11) NULL DEFAULT NULL COMMENT '字段长度',
  `sort` int(11) NULL DEFAULT NULL COMMENT '字段排序',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段描述',
  PRIMARY KEY (`format_id`) USING BTREE,
  INDEX `fk1_protocol_id`(`protocol_id`) USING BTREE,
  CONSTRAINT `fk1_protocol_id` FOREIGN KEY (`protocol_id`) REFERENCES `protocol` (`protocol_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of protocol_message_format
-- ----------------------------
INSERT INTO `protocol_message_format` VALUES (1, 1, '指令类型', 'INT', 4, 1, '标识指令的类型');

-- ----------------------------
-- Table structure for test_item
-- ----------------------------
DROP TABLE IF EXISTS `test_item`;
CREATE TABLE `test_item`  (
  `item_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '测试项id',
  `task_id` int(11) NULL DEFAULT NULL COMMENT '所属测试任务id',
  `item_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试项名称',
  `standard_requirement` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '标准要求',
  `instruction_id` int(11) NULL DEFAULT NULL COMMENT '执行指令',
  `result` tinyint(4) NULL DEFAULT NULL COMMENT '(0-不通过，1-通过，2未测试)',
  `result_desc` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '结果描述',
  `test_time` datetime NULL DEFAULT NULL COMMENT '测试时间',
  PRIMARY KEY (`item_id`) USING BTREE,
  INDEX `fk_instruction_id`(`instruction_id`) USING BTREE,
  INDEX `fk_task_id`(`task_id`) USING BTREE,
  CONSTRAINT `fk_instruction_id` FOREIGN KEY (`instruction_id`) REFERENCES `instruction` (`instruction_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_id` FOREIGN KEY (`task_id`) REFERENCES `test_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test_item
-- ----------------------------
INSERT INTO `test_item` VALUES (1, 1, '协议兼容性测试', '符合GJB7102-2010标准', 1, 2, '待测试', '2025-07-27 13:49:23');

-- ----------------------------
-- Table structure for test_report
-- ----------------------------
DROP TABLE IF EXISTS `test_report`;
CREATE TABLE `test_report`  (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NULL DEFAULT NULL COMMENT '所属测试任务',
  `report_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报告名称',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '报告内容',
  `pass_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '测试通过率',
  `generate_time` datetime NULL DEFAULT NULL COMMENT '生成时间',
  `export_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '导出文件路径',
  `generate_user` int(11) NULL DEFAULT NULL COMMENT '生成人',
  PRIMARY KEY (`report_id`) USING BTREE,
  INDEX `report_task_id`(`task_id`) USING BTREE,
  INDEX `report_generate_user`(`generate_user`) USING BTREE,
  CONSTRAINT `report_generate_user` FOREIGN KEY (`generate_user`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `report_task_id` FOREIGN KEY (`task_id`) REFERENCES `test_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test_report
-- ----------------------------
INSERT INTO `test_report` VALUES (1, 1, '无人机通信测试报告', '{\"summary\": \"测试初始化，待执行\"}', 0.00, '2025-07-27 13:50:31', '/reports/test_report_1.pdf', 1);

-- ----------------------------
-- Table structure for test_task
-- ----------------------------
DROP TABLE IF EXISTS `test_task`;
CREATE TABLE `test_task`  (
  `task_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '测试任务id',
  `task_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '测试任务名称',
  `unit_id` int(11) NULL DEFAULT NULL COMMENT '参试单位id',
  `station_id` int(11) NULL DEFAULT NULL COMMENT '关联控制站',
  `protocol_id` int(11) NULL DEFAULT NULL COMMENT '测试依据协议',
  `start_time` datetime NULL DEFAULT NULL COMMENT '任务开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '任务结束时间',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '任务状态（0-未开始，1-进行中，2-已完成，3-失败）',
  `create_user` int(11) NULL DEFAULT NULL COMMENT '创始人id',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `fk2_unit_id`(`unit_id`) USING BTREE,
  INDEX `fk1_station_id`(`station_id`) USING BTREE,
  INDEX `task_protocol_id`(`protocol_id`) USING BTREE,
  INDEX `task_create_user`(`create_user`) USING BTREE,
  CONSTRAINT `fk1_station_id` FOREIGN KEY (`station_id`) REFERENCES `control_station` (`station_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk2_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `participate_unit` (`unit_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `task_create_user` FOREIGN KEY (`create_user`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `task_protocol_id` FOREIGN KEY (`protocol_id`) REFERENCES `protocol` (`protocol_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test_task
-- ----------------------------
INSERT INTO `test_task` VALUES (1, '无人机通信测试任务', 1, 1001, 1, '2025-07-27 13:46:06', NULL, 0, 1, '2025-07-27 13:48:08', '2025-07-27 13:48:12');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `org_id` int(11) NULL DEFAULT NULL COMMENT '所属组织机构',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态（0-禁用，1-正常）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  INDEX `user_org_id`(`org_id`) USING BTREE,
  CONSTRAINT `user_org_id` FOREIGN KEY (`org_id`) REFERENCES `organization` (`org_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123456', '管理员', 1, '121000000', 1, '2025-07-27 13:47:37', '2025-07-27 13:47:40');

-- ----------------------------
-- Table structure for user_permission
-- ----------------------------
DROP TABLE IF EXISTS `user_permission`;
CREATE TABLE `user_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '关联id',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `permission_id` int(11) NULL DEFAULT NULL COMMENT '权限id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `permission_id`(`permission_id`) USING BTREE,
  CONSTRAINT `permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_permission
-- ----------------------------
INSERT INTO `user_permission` VALUES (1, 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
