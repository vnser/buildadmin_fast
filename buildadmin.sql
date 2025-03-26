/*
 Navicat Premium Data Transfer

 Source Server         : 127.0.0.1
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : buildadmin

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 10/01/2025 09:54:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ch__admin
-- ----------------------------
DROP TABLE IF EXISTS `ch__admin`;
CREATE TABLE `ch__admin`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '手机',
  `login_failure` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '登录失败次数',
  `last_login_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '上次登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上次登录IP',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码盐',
  `motto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '签名',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__admin
-- ----------------------------
INSERT INTO `ch__admin` VALUES (1, 'admin', 'Admin', '', 'admin@buildadmin.com', '18888888888', 0, 1736473317, '127.0.0.1', '1954a33ef4fb516b11ba706ccd96f325', 'pRdtnlFsYZKr6M8A', '', '1', 1736473317, 1736414913);

-- ----------------------------
-- Table structure for ch__admin_group
-- ----------------------------
DROP TABLE IF EXISTS `ch__admin_group`;
CREATE TABLE `ch__admin_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级分组',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '权限规则ID',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理分组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__admin_group
-- ----------------------------
INSERT INTO `ch__admin_group` VALUES (1, 0, '超级管理组', '*', '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_group` VALUES (2, 1, '一级管理员', '1,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,77,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,89', '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_group` VALUES (3, 2, '二级管理员', '21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43', '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_group` VALUES (4, 3, '三级管理员', '55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75', '1', 1736414913, 1736414913);

-- ----------------------------
-- Table structure for ch__admin_group_access
-- ----------------------------
DROP TABLE IF EXISTS `ch__admin_group_access`;
CREATE TABLE `ch__admin_group_access`  (
  `uid` int(11) UNSIGNED NOT NULL COMMENT '管理员ID',
  `group_id` int(11) UNSIGNED NOT NULL COMMENT '分组ID',
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理分组映射表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__admin_group_access
-- ----------------------------
INSERT INTO `ch__admin_group_access` VALUES (1, 1);

-- ----------------------------
-- Table structure for ch__admin_log
-- ----------------------------
DROP TABLE IF EXISTS `ch__admin_log`;
CREATE TABLE `ch__admin_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '管理员用户名',
  `url` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作Url',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '日志标题',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求数据',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__admin_log
-- ----------------------------
INSERT INTO `ch__admin_log` VALUES (1, 0, 'admin', '/admini.php/Index/login', '登录', '{\"username\":\"admin\",\"password\":\"***\",\"keep\":\"\",\"captchaId\":\"7454f9e8-6e9f-4589-a9c5-83ed5292edfe\",\"captchaInfo\":\"285,146-41,117;350;200\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415141);
INSERT INTO `ch__admin_log` VALUES (2, 0, 'admin', '/admini.php/Index/login', '登录', '{\"username\":\"admin\",\"password\":\"***\",\"keep\":\"\",\"captchaId\":\"7454f9e8-6e9f-4589-a9c5-83ed5292edfe\",\"captchaInfo\":\"101,170-87,100;350;200\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415156);
INSERT INTO `ch__admin_log` VALUES (3, 1, 'admin', '/admini.php/Index/login', '登录', '{\"username\":\"admin\",\"password\":\"***\",\"keep\":\"\",\"captchaId\":\"7454f9e8-6e9f-4589-a9c5-83ed5292edfe\",\"captchaInfo\":\"228,54-289,41;350;200\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415193);
INSERT INTO `ch__admin_log` VALUES (4, 1, 'admin', '/admini.php/routine.Config/edit', '系统配置-编辑', '{\"site_name\":\"builldadmin\",\"backend_entrance\":\"\\/admin\",\"record_number\":\"\\u6e1dICP\\u59078888888\\u53f7-1\",\"version\":\"v1.0.0\",\"time_zone\":\"Asia\\/Shanghai\",\"no_access_ip\":\"\",\"config_group\":[{\"key\":\"basics\",\"value\":\"Basics\"},{\"key\":\"mail\",\"value\":\"Mail\"},{\"key\":\"config_quick_entrance\",\"value\":\"Config Quick entrance\"}]}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415219);
INSERT INTO `ch__admin_log` VALUES (5, 1, 'admin', '/admini.php/Index/login', '登录', '{\"username\":\"admin\",\"password\":\"***\",\"keep\":\"\",\"captchaId\":\"79d55066-eb7d-425e-9abd-0545f185c809\",\"captchaInfo\":\"185,156-246,63;350;200\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415259);
INSERT INTO `ch__admin_log` VALUES (6, 1, 'admin', '/admini.php/crud.Crud/generateCheck', 'CRUD代码生成-生成前预检', '{\"table\":\"appconfig\",\"connection\":\"\",\"controllerFile\":\"app\\\\admin\\\\controller\\\\AppConfig.php\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415706);
INSERT INTO `ch__admin_log` VALUES (7, 1, 'admin', '/admini.php/crud.Crud/generate', 'CRUD代码生成-生成', '{\"type\":\"create\",\"table\":{\"name\":\"appconfig\",\"comment\":\"\\u57fa\\u672c\\u914d\\u7f6e\",\"quickSearchField\":[\"id\"],\"defaultSortField\":\"id\",\"formFields\":[\"clinic_introduction_content\"],\"columnFields\":[\"id\"],\"defaultSortType\":\"desc\",\"generateRelativePath\":\"appConfig\",\"isCommonModel\":\"0\",\"modelFile\":\"app\\\\admin\\\\model\\\\AppConfig.php\",\"controllerFile\":\"app\\\\admin\\\\controller\\\\AppConfig.php\",\"validateFile\":\"app\\\\admin\\\\validate\\\\AppConfig.php\",\"webViewsDir\":\"web\\\\src\\\\views\\\\backend\\\\appConfig\",\"databaseConnection\":\"\",\"designChange\":[],\"rebuild\":\"No\"},\"fields\":[{\"title\":\"\\u4e3b\\u952e\",\"name\":\"id\",\"comment\":\"ID\",\"designType\":\"pk\",\"formBuildExclude\":\"1\",\"table\":{\"width\":\"70\",\"operator\":\"RANGE\",\"sortable\":\"custom\"},\"form\":[],\"type\":\"int\",\"length\":\"10\",\"precision\":\"0\",\"default\":\"0\",\"defaultType\":\"NONE\",\"null\":\"\",\"primaryKey\":\"1\",\"unsigned\":\"1\",\"autoIncrement\":\"1\"},{\"title\":\"\\u5bcc\\u6587\\u672c\",\"name\":\"clinic_introduction_content\",\"comment\":\"\\u95e8\\u8bca\\u4ecb\\u7ecd\",\"designType\":\"editor\",\"tableBuildExclude\":\"1\",\"table\":{\"operator\":\"false\"},\"form\":{\"validator\":[\"editorRequired\"],\"validatorMsg\":\"\"},\"type\":\"text\",\"length\":\"0\",\"precision\":\"0\",\"defaultType\":\"NULL\",\"null\":\"1\",\"primaryKey\":\"\",\"unsigned\":\"\",\"autoIncrement\":\"\"}]}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736415708);
INSERT INTO `ch__admin_log` VALUES (8, 1, 'admin', '/admini.php/crud.Crud/logStart', 'CRUD代码生成-从历史记录开始', '{\"id\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736416298);
INSERT INTO `ch__admin_log` VALUES (9, 1, 'admin', '/admini.php/crud.Crud/generateCheck', 'CRUD代码生成-生成前预检', '{\"table\":\"appconfig\",\"connection\":\"\",\"controllerFile\":\"app\\\\admin\\\\controller\\\\AppConfig.php\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736473302);
INSERT INTO `ch__admin_log` VALUES (10, 1, 'admin', '/admini.php/crud.Crud/generate', 'CRUD代码生成-生成', '{\"type\":\"log\",\"table\":{\"name\":\"appconfig\",\"comment\":\"\\u57fa\\u672c\\u914d\\u7f6e\",\"quickSearchField\":[\"id\"],\"defaultSortField\":\"\",\"formFields\":[\"clinic_introduction\",\"instructions_registration\"],\"columnFields\":[\"id\"],\"defaultSortType\":\"desc\",\"generateRelativePath\":\"appConfig\",\"isCommonModel\":\"0\",\"modelFile\":\"app\\\\admin\\\\model\\\\AppConfig.php\",\"controllerFile\":\"app\\\\admin\\\\controller\\\\AppConfig.php\",\"validateFile\":\"app\\\\admin\\\\validate\\\\AppConfig.php\",\"webViewsDir\":\"web\\\\src\\\\views\\\\backend\\\\appConfig\",\"databaseConnection\":\"\",\"designChange\":[{\"type\":\"change-field-name\",\"index\":\"1\",\"oldName\":\"clinic_introduction_content\",\"newName\":\"clinic_introduction\",\"sync\":\"1\"},{\"type\":\"del-field\",\"oldName\":\"update_time\",\"newName\":\"\",\"sync\":\"1\"},{\"type\":\"del-field\",\"oldName\":\"create_time\",\"newName\":\"\",\"sync\":\"1\"},{\"type\":\"del-field\",\"oldName\":\"weigh\",\"newName\":\"\",\"sync\":\"1\"},{\"type\":\"add-field\",\"index\":\"2\",\"newName\":\"instructions_registration\",\"oldName\":\"\",\"after\":\"clinic_introduction\",\"sync\":\"1\"}],\"rebuild\":\"Yes\",\"empty\":\"1\"},\"fields\":[{\"title\":\"\\u4e3b\\u952e\",\"name\":\"id\",\"comment\":\"ID\",\"designType\":\"pk\",\"formBuildExclude\":\"1\",\"table\":{\"width\":\"70\",\"operator\":\"RANGE\",\"sortable\":\"custom\"},\"form\":[],\"type\":\"int\",\"length\":\"10\",\"precision\":\"0\",\"default\":\"0\",\"defaultType\":\"NONE\",\"null\":\"\",\"primaryKey\":\"1\",\"unsigned\":\"1\",\"autoIncrement\":\"1\"},{\"title\":\"\\u5bcc\\u6587\\u672c\",\"name\":\"clinic_introduction\",\"comment\":\"\\u95e8\\u8bca\\u4ecb\\u7ecd\",\"designType\":\"editor\",\"tableBuildExclude\":\"1\",\"table\":{\"operator\":\"false\"},\"form\":{\"validator\":[\"editorRequired\"],\"validatorMsg\":\"\"},\"type\":\"text\",\"length\":\"0\",\"precision\":\"0\",\"defaultType\":\"NULL\",\"null\":\"1\",\"primaryKey\":\"\",\"unsigned\":\"\",\"autoIncrement\":\"\"},{\"title\":\"\\u5bcc\\u6587\\u672c\",\"name\":\"instructions_registration\",\"comment\":\"\\u6302\\u53f7\\u987b\\u77e5\",\"designType\":\"editor\",\"tableBuildExclude\":\"1\",\"table\":{\"operator\":\"false\"},\"form\":{\"validator\":[\"editorRequired\"],\"validatorMsg\":\"\"},\"type\":\"text\",\"length\":\"0\",\"precision\":\"0\",\"defaultType\":\"NULL\",\"null\":\"1\",\"primaryKey\":\"\",\"unsigned\":\"\",\"autoIncrement\":\"\"}]}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1736473304);

-- ----------------------------
-- Table structure for ch__admin_rule
-- ----------------------------
DROP TABLE IF EXISTS `ch__admin_rule`;
CREATE TABLE `ch__admin_rule`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级菜单',
  `type` enum('menu_dir','menu','button') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'menu' COMMENT '类型:menu_dir=菜单目录,menu=菜单项,button=页面按钮',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '路由路径',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图标',
  `menu_type` enum('tab','link','iframe') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '菜单类型:tab=选项卡,link=链接,iframe=Iframe',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Url',
  `component` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '组件路径',
  `keepalive` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '缓存:0=关闭,1=开启',
  `extend` enum('none','add_rules_only','add_menu_only') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none' COMMENT '扩展属性:none=无,add_rules_only=只添加为路由,add_menu_only=只添加为菜单',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `weigh` int(11) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 96 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单和权限规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__admin_rule
-- ----------------------------
INSERT INTO `ch__admin_rule` VALUES (1, 0, 'menu', '控制台', 'dashboard', 'dashboard', 'fa fa-dashboard', 'tab', '', '/src/views/backend/dashboard.vue', 1, 'none', 'Remark lang', 999, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (2, 0, 'menu_dir', '权限管理', 'auth', 'auth', 'fa fa-group', NULL, '', '', 0, 'none', '', 100, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (3, 2, 'menu', '角色组管理', 'auth/group', 'auth/group', 'fa fa-group', 'tab', '', '/src/views/backend/auth/group/index.vue', 1, 'none', 'Remark lang', 99, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (4, 3, 'button', '查看', 'auth/group/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (5, 3, 'button', '添加', 'auth/group/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (6, 3, 'button', '编辑', 'auth/group/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (7, 3, 'button', '删除', 'auth/group/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (8, 2, 'menu', '管理员管理', 'auth/admin', 'auth/admin', 'el-icon-UserFilled', 'tab', '', '/src/views/backend/auth/admin/index.vue', 1, 'none', '', 98, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (9, 8, 'button', '查看', 'auth/admin/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (10, 8, 'button', '添加', 'auth/admin/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (11, 8, 'button', '编辑', 'auth/admin/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (12, 8, 'button', '删除', 'auth/admin/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (13, 2, 'menu', '菜单规则管理', 'auth/rule', 'auth/rule', 'el-icon-Grid', 'tab', '', '/src/views/backend/auth/rule/index.vue', 1, 'none', '', 97, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (14, 13, 'button', '查看', 'auth/rule/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (15, 13, 'button', '添加', 'auth/rule/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (16, 13, 'button', '编辑', 'auth/rule/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (17, 13, 'button', '删除', 'auth/rule/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (18, 13, 'button', '快速排序', 'auth/rule/sortable', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (19, 2, 'menu', '管理员日志管理', 'auth/adminLog', 'auth/adminLog', 'el-icon-List', 'tab', '', '/src/views/backend/auth/adminLog/index.vue', 1, 'none', '', 96, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (20, 19, 'button', '查看', 'auth/adminLog/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (21, 0, 'menu_dir', '会员管理', 'user', 'user', 'fa fa-drivers-license', NULL, '', '', 0, 'none', '', 95, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (22, 21, 'menu', '会员管理', 'user/user', 'user/user', 'fa fa-user', 'tab', '', '/src/views/backend/user/user/index.vue', 1, 'none', '', 94, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (23, 22, 'button', '查看', 'user/user/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (24, 22, 'button', '添加', 'user/user/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (25, 22, 'button', '编辑', 'user/user/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (26, 22, 'button', '删除', 'user/user/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (27, 21, 'menu', '会员分组管理', 'user/group', 'user/group', 'fa fa-group', 'tab', '', '/src/views/backend/user/group/index.vue', 1, 'none', '', 93, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (28, 27, 'button', '查看', 'user/group/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (29, 27, 'button', '添加', 'user/group/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (30, 27, 'button', '编辑', 'user/group/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (31, 27, 'button', '删除', 'user/group/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (32, 21, 'menu', '会员规则管理', 'user/rule', 'user/rule', 'fa fa-th-list', 'tab', '', '/src/views/backend/user/rule/index.vue', 1, 'none', '', 92, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (33, 32, 'button', '查看', 'user/rule/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (34, 32, 'button', '添加', 'user/rule/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (35, 32, 'button', '编辑', 'user/rule/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (36, 32, 'button', '删除', 'user/rule/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (37, 32, 'button', '快速排序', 'user/rule/sortable', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (38, 21, 'menu', '会员余额管理', 'user/moneyLog', 'user/moneyLog', 'el-icon-Money', 'tab', '', '/src/views/backend/user/moneyLog/index.vue', 1, 'none', '', 91, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (39, 38, 'button', '查看', 'user/moneyLog/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (40, 38, 'button', '添加', 'user/moneyLog/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (41, 21, 'menu', '会员积分管理', 'user/scoreLog', 'user/scoreLog', 'el-icon-Discount', 'tab', '', '/src/views/backend/user/scoreLog/index.vue', 1, 'none', '', 90, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (42, 41, 'button', '查看', 'user/scoreLog/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (43, 41, 'button', '添加', 'user/scoreLog/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (44, 0, 'menu_dir', '常规管理', 'routine', 'routine', 'fa fa-cogs', NULL, '', '', 0, 'none', '', 89, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (45, 44, 'menu', '系统配置', 'routine/config', 'routine/config', 'el-icon-Tools', 'tab', '', '/src/views/backend/routine/config/index.vue', 1, 'none', '', 88, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (46, 45, 'button', '查看', 'routine/config/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (47, 45, 'button', '编辑', 'routine/config/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (48, 44, 'menu', '附件管理', 'routine/attachment', 'routine/attachment', 'fa fa-folder', 'tab', '', '/src/views/backend/routine/attachment/index.vue', 1, 'none', 'Remark lang', 87, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (49, 48, 'button', '查看', 'routine/attachment/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (50, 48, 'button', '编辑', 'routine/attachment/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (51, 48, 'button', '删除', 'routine/attachment/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (52, 44, 'menu', '个人资料', 'routine/adminInfo', 'routine/adminInfo', 'fa fa-user', 'tab', '', '/src/views/backend/routine/adminInfo.vue', 1, 'none', '', 86, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (53, 52, 'button', '查看', 'routine/adminInfo/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (54, 52, 'button', '编辑', 'routine/adminInfo/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (55, 0, 'menu_dir', '数据安全管理', 'security', 'security', 'fa fa-shield', NULL, '', '', 0, 'none', '', 85, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (56, 55, 'menu', '数据回收站', 'security/dataRecycleLog', 'security/dataRecycleLog', 'fa fa-database', 'tab', '', '/src/views/backend/security/dataRecycleLog/index.vue', 1, 'none', '', 84, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (57, 56, 'button', '查看', 'security/dataRecycleLog/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (58, 56, 'button', '删除', 'security/dataRecycleLog/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (59, 56, 'button', '还原', 'security/dataRecycleLog/restore', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (60, 56, 'button', '查看详情', 'security/dataRecycleLog/info', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (61, 55, 'menu', '敏感数据修改记录', 'security/sensitiveDataLog', 'security/sensitiveDataLog', 'fa fa-expeditedssl', 'tab', '', '/src/views/backend/security/sensitiveDataLog/index.vue', 1, 'none', '', 83, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (62, 61, 'button', '查看', 'security/sensitiveDataLog/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (63, 61, 'button', '删除', 'security/sensitiveDataLog/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (64, 61, 'button', '回滚', 'security/sensitiveDataLog/rollback', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (65, 61, 'button', '查看详情', 'security/sensitiveDataLog/info', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (66, 55, 'menu', '数据回收规则管理', 'security/dataRecycle', 'security/dataRecycle', 'fa fa-database', 'tab', '', '/src/views/backend/security/dataRecycle/index.vue', 1, 'none', 'Remark lang', 82, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (67, 66, 'button', '查看', 'security/dataRecycle/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (68, 66, 'button', '添加', 'security/dataRecycle/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (69, 66, 'button', '编辑', 'security/dataRecycle/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (70, 66, 'button', '删除', 'security/dataRecycle/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (71, 55, 'menu', '敏感字段规则管理', 'security/sensitiveData', 'security/sensitiveData', 'fa fa-expeditedssl', 'tab', '', '/src/views/backend/security/sensitiveData/index.vue', 1, 'none', 'Remark lang', 81, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (72, 71, 'button', '查看', 'security/sensitiveData/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (73, 71, 'button', '添加', 'security/sensitiveData/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (74, 71, 'button', '编辑', 'security/sensitiveData/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (75, 71, 'button', '删除', 'security/sensitiveData/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (76, 0, 'menu', 'BuildAdmin', 'buildadmin', 'buildadmin', 'local-logo', 'link', 'https://doc.buildadmin.com', '', 0, 'none', '', 0, '0', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (77, 45, 'button', '添加', 'routine/config/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (78, 0, 'menu', '模块市场', 'moduleStore/moduleStore', 'moduleStore', 'el-icon-GoodsFilled', 'tab', '', '/src/views/backend/module/index.vue', 1, 'none', '', 86, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (79, 78, 'button', '查看', 'moduleStore/moduleStore/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (80, 78, 'button', '安装', 'moduleStore/moduleStore/install', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (81, 78, 'button', '调整状态', 'moduleStore/moduleStore/changeState', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (82, 78, 'button', '卸载', 'moduleStore/moduleStore/uninstall', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (83, 78, 'button', '更新', 'moduleStore/moduleStore/update', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (84, 0, 'menu', 'CRUD代码生成', 'crud/crud', 'crud/crud', 'fa fa-code', 'tab', '', '/src/views/backend/crud/index.vue', 1, 'none', '', 80, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (85, 84, 'button', '查看', 'crud/crud/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (86, 84, 'button', '生成', 'crud/crud/generate', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (87, 84, 'button', '删除', 'crud/crud/delete', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (88, 45, 'button', '删除', 'routine/config/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414913, 1736414913);
INSERT INTO `ch__admin_rule` VALUES (89, 1, 'button', '查看', 'dashboard/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736414915, 1736414915);
INSERT INTO `ch__admin_rule` VALUES (90, 0, 'menu', '基本配置', 'appConfig', 'appConfig', '', 'tab', '', '/src/views/backend/appConfig/index.vue', 1, 'none', '', 0, '1', 1736415707, 1736415707);
INSERT INTO `ch__admin_rule` VALUES (91, 90, 'button', '查看', 'appConfig/index', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736415707, 1736415707);
INSERT INTO `ch__admin_rule` VALUES (92, 90, 'button', '添加', 'appConfig/add', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736415708, 1736415708);
INSERT INTO `ch__admin_rule` VALUES (93, 90, 'button', '编辑', 'appConfig/edit', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736415708, 1736415708);
INSERT INTO `ch__admin_rule` VALUES (94, 90, 'button', '删除', 'appConfig/del', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736415708, 1736415708);
INSERT INTO `ch__admin_rule` VALUES (95, 90, 'button', '快速排序', 'appConfig/sortable', '', '', NULL, '', '', 0, 'none', '', 0, '1', 1736415708, 1736415708);

-- ----------------------------
-- Table structure for ch__appconfig
-- ----------------------------
DROP TABLE IF EXISTS `ch__appconfig`;
CREATE TABLE `ch__appconfig`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `clinic_introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '门诊介绍',
  `instructions_registration` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '挂号须知',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '基本配置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__appconfig
-- ----------------------------

-- ----------------------------
-- Table structure for ch__area
-- ----------------------------
DROP TABLE IF EXISTS `ch__area`;
CREATE TABLE `ch__area`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '父id',
  `shortname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '简称',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `mergename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '全称',
  `level` tinyint(4) UNSIGNED NULL DEFAULT NULL COMMENT '层级:1=省,2=市,3=区/县',
  `pinyin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拼音',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '长途区号',
  `zip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮编',
  `first` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '首字母',
  `lng` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '纬度',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '省份地区表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__area
-- ----------------------------

-- ----------------------------
-- Table structure for ch__attachment
-- ----------------------------
DROP TABLE IF EXISTS `ch__attachment`;
CREATE TABLE `ch__attachment`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `topic` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '细目',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上传管理员ID',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上传用户ID',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '物理路径',
  `width` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '宽度',
  `height` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '高度',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '原始名称',
  `size` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '大小',
  `mimetype` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'mime类型',
  `quote` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上传(引用)次数',
  `storage` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '存储方式',
  `sha1` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'sha1编码',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  `last_upload_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '最后上传时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '附件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__attachment
-- ----------------------------

-- ----------------------------
-- Table structure for ch__captcha
-- ----------------------------
DROP TABLE IF EXISTS `ch__captcha`;
CREATE TABLE `ch__captcha`  (
  `key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '验证码Key',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '验证码(加密后)',
  `captcha` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '验证码数据',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  `expire_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '验证码表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__captcha
-- ----------------------------

-- ----------------------------
-- Table structure for ch__config
-- ----------------------------
DROP TABLE IF EXISTS `ch__config`;
CREATE TABLE `ch__config`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '变量名',
  `group` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分组',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '变量输入组件类型',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '变量值',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '字典数据',
  `rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '扩展属性',
  `allow_del` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '允许删除:0=否,1=是',
  `weigh` int(11) NOT NULL DEFAULT 0 COMMENT '权重',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__config
-- ----------------------------
INSERT INTO `ch__config` VALUES (1, 'config_group', 'basics', 'Config group', '', 'array', '[{\"key\":\"basics\",\"value\":\"Basics\"},{\"key\":\"mail\",\"value\":\"Mail\"},{\"key\":\"config_quick_entrance\",\"value\":\"Config Quick entrance\"}]', NULL, 'required', '', 0, -1);
INSERT INTO `ch__config` VALUES (2, 'site_name', 'basics', 'Site Name', '', 'string', 'builldadmin', NULL, 'required', '', 0, 99);
INSERT INTO `ch__config` VALUES (3, 'record_number', 'basics', 'Record number', '域名备案号', 'string', '渝ICP备8888888号-1', NULL, '', '', 0, 0);
INSERT INTO `ch__config` VALUES (4, 'version', 'basics', 'Version number', '系统版本号', 'string', 'v1.0.0', NULL, 'required', '', 0, 0);
INSERT INTO `ch__config` VALUES (5, 'time_zone', 'basics', 'time zone', '', 'string', 'Asia/Shanghai', NULL, 'required', '', 0, 0);
INSERT INTO `ch__config` VALUES (6, 'no_access_ip', 'basics', 'No access ip', '禁止访问站点的ip列表,一行一个', 'textarea', '', NULL, '', '', 0, 0);
INSERT INTO `ch__config` VALUES (7, 'smtp_server', 'mail', 'smtp server', '', 'string', 'smtp.qq.com', NULL, '', '', 0, 9);
INSERT INTO `ch__config` VALUES (8, 'smtp_port', 'mail', 'smtp port', '', 'string', '465', NULL, '', '', 0, 8);
INSERT INTO `ch__config` VALUES (9, 'smtp_user', 'mail', 'smtp user', '', 'string', NULL, NULL, '', '', 0, 7);
INSERT INTO `ch__config` VALUES (10, 'smtp_pass', 'mail', 'smtp pass', '', 'string', NULL, NULL, '', '', 0, 6);
INSERT INTO `ch__config` VALUES (11, 'smtp_verification', 'mail', 'smtp verification', '', 'select', 'SSL', '{\"SSL\":\"SSL\",\"TLS\":\"TLS\"}', '', '', 0, 5);
INSERT INTO `ch__config` VALUES (12, 'smtp_sender_mail', 'mail', 'smtp sender mail', '', 'string', NULL, NULL, 'email', '', 0, 4);
INSERT INTO `ch__config` VALUES (13, 'config_quick_entrance', 'config_quick_entrance', 'Config Quick entrance', '', 'array', '[{\"key\":\"\\u6570\\u636e\\u56de\\u6536\\u89c4\\u5219\\u914d\\u7f6e\",\"value\":\"security\\/dataRecycle\"},{\"key\":\"\\u654f\\u611f\\u6570\\u636e\\u89c4\\u5219\\u914d\\u7f6e\",\"value\":\"security\\/sensitiveData\"}]', NULL, '', '', 0, 0);
INSERT INTO `ch__config` VALUES (14, 'backend_entrance', 'basics', 'Backend entrance', '', 'string', '/admin', NULL, 'required', '', 0, 1);

-- ----------------------------
-- Table structure for ch__crud_log
-- ----------------------------
DROP TABLE IF EXISTS `ch__crud_log`;
CREATE TABLE `ch__crud_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表名',
  `table` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '数据表数据',
  `fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '字段数据',
  `status` enum('delete','success','error','start') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'start' COMMENT '状态:delete=已删除,success=成功,error=失败,start=生成中',
  `connection` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据库连接配置标识',
  `create_time` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'CRUD记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__crud_log
-- ----------------------------
INSERT INTO `ch__crud_log` VALUES (1, 'appconfig', '{\"name\":\"appconfig\",\"comment\":\"基本配置\",\"quickSearchField\":[\"id\"],\"defaultSortField\":\"id\",\"formFields\":[\"clinic_introduction_content\"],\"columnFields\":[\"id\"],\"defaultSortType\":\"desc\",\"generateRelativePath\":\"appConfig\",\"isCommonModel\":\"0\",\"modelFile\":\"app\\\\admin\\\\model\\\\AppConfig.php\",\"controllerFile\":\"app\\\\admin\\\\controller\\\\AppConfig.php\",\"validateFile\":\"app\\\\admin\\\\validate\\\\AppConfig.php\",\"webViewsDir\":\"web\\\\src\\\\views\\\\backend\\\\appConfig\",\"databaseConnection\":\"\",\"designChange\":[],\"rebuild\":\"No\"}', '[{\"title\":\"主键\",\"name\":\"id\",\"comment\":\"ID\",\"designType\":\"pk\",\"formBuildExclude\":\"1\",\"table\":{\"width\":\"70\",\"operator\":\"RANGE\",\"sortable\":\"custom\"},\"form\":[],\"type\":\"int\",\"length\":\"10\",\"precision\":\"0\",\"default\":\"0\",\"defaultType\":\"NONE\",\"null\":\"\",\"primaryKey\":\"1\",\"unsigned\":\"1\",\"autoIncrement\":\"1\"},{\"title\":\"富文本\",\"name\":\"clinic_introduction_content\",\"comment\":\"门诊介绍\",\"designType\":\"editor\",\"tableBuildExclude\":\"1\",\"table\":{\"operator\":\"false\"},\"form\":{\"validator\":[\"editorRequired\"],\"validatorMsg\":\"\"},\"type\":\"text\",\"length\":\"0\",\"precision\":\"0\",\"defaultType\":\"NULL\",\"null\":\"1\",\"primaryKey\":\"\",\"unsigned\":\"\",\"autoIncrement\":\"\"}]', 'success', 'mysql', 1736415707);
INSERT INTO `ch__crud_log` VALUES (2, 'appconfig', '{\"name\":\"appconfig\",\"comment\":\"基本配置\",\"quickSearchField\":[\"id\"],\"defaultSortField\":\"\",\"formFields\":[\"clinic_introduction\",\"instructions_registration\"],\"columnFields\":[\"id\"],\"defaultSortType\":\"desc\",\"generateRelativePath\":\"appConfig\",\"isCommonModel\":\"0\",\"modelFile\":\"app\\\\admin\\\\model\\\\AppConfig.php\",\"controllerFile\":\"app\\\\admin\\\\controller\\\\AppConfig.php\",\"validateFile\":\"app\\\\admin\\\\validate\\\\AppConfig.php\",\"webViewsDir\":\"web\\\\src\\\\views\\\\backend\\\\appConfig\",\"databaseConnection\":\"\",\"designChange\":[{\"type\":\"change-field-name\",\"index\":\"1\",\"oldName\":\"clinic_introduction_content\",\"newName\":\"clinic_introduction\",\"sync\":\"1\"},{\"type\":\"del-field\",\"oldName\":\"update_time\",\"newName\":\"\",\"sync\":\"1\"},{\"type\":\"del-field\",\"oldName\":\"create_time\",\"newName\":\"\",\"sync\":\"1\"},{\"type\":\"del-field\",\"oldName\":\"weigh\",\"newName\":\"\",\"sync\":\"1\"},{\"type\":\"add-field\",\"index\":\"2\",\"newName\":\"instructions_registration\",\"oldName\":\"\",\"after\":\"clinic_introduction\",\"sync\":\"1\"}],\"rebuild\":\"Yes\",\"empty\":\"1\"}', '[{\"title\":\"主键\",\"name\":\"id\",\"comment\":\"ID\",\"designType\":\"pk\",\"formBuildExclude\":\"1\",\"table\":{\"width\":\"70\",\"operator\":\"RANGE\",\"sortable\":\"custom\"},\"form\":[],\"type\":\"int\",\"length\":\"10\",\"precision\":\"0\",\"default\":\"0\",\"defaultType\":\"NONE\",\"null\":\"\",\"primaryKey\":\"1\",\"unsigned\":\"1\",\"autoIncrement\":\"1\"},{\"title\":\"富文本\",\"name\":\"clinic_introduction\",\"comment\":\"门诊介绍\",\"designType\":\"editor\",\"tableBuildExclude\":\"1\",\"table\":{\"operator\":\"false\"},\"form\":{\"validator\":[\"editorRequired\"],\"validatorMsg\":\"\"},\"type\":\"text\",\"length\":\"0\",\"precision\":\"0\",\"defaultType\":\"NULL\",\"null\":\"1\",\"primaryKey\":\"\",\"unsigned\":\"\",\"autoIncrement\":\"\"},{\"title\":\"富文本\",\"name\":\"instructions_registration\",\"comment\":\"挂号须知\",\"designType\":\"editor\",\"tableBuildExclude\":\"1\",\"table\":{\"operator\":\"false\"},\"form\":{\"validator\":[\"editorRequired\"],\"validatorMsg\":\"\"},\"type\":\"text\",\"length\":\"0\",\"precision\":\"0\",\"defaultType\":\"NULL\",\"null\":\"1\",\"primaryKey\":\"\",\"unsigned\":\"\",\"autoIncrement\":\"\"}]', 'success', 'mysql', 1736473304);

-- ----------------------------
-- Table structure for ch__migrations
-- ----------------------------
DROP TABLE IF EXISTS `ch__migrations`;
CREATE TABLE `ch__migrations`  (
  `version` bigint(20) NOT NULL,
  `migration_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `breakpoint` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`version`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ch__migrations
-- ----------------------------
INSERT INTO `ch__migrations` VALUES (20230620180908, 'Install', '2025-01-09 17:28:31', '2025-01-09 17:28:33', 0);
INSERT INTO `ch__migrations` VALUES (20230620180916, 'InstallData', '2025-01-09 17:28:33', '2025-01-09 17:28:34', 0);
INSERT INTO `ch__migrations` VALUES (20230622221507, 'Version200', '2025-01-09 17:28:34', '2025-01-09 17:28:35', 0);
INSERT INTO `ch__migrations` VALUES (20230719211338, 'Version201', '2025-01-09 17:28:35', '2025-01-09 17:28:35', 0);
INSERT INTO `ch__migrations` VALUES (20230905060702, 'Version202', '2025-01-09 17:28:35', '2025-01-09 17:28:35', 0);
INSERT INTO `ch__migrations` VALUES (20231112093414, 'Version205', '2025-01-09 17:28:35', '2025-01-09 17:28:35', 0);
INSERT INTO `ch__migrations` VALUES (20231229043002, 'Version206', '2025-01-09 17:28:35', '2025-01-09 17:28:36', 0);

-- ----------------------------
-- Table structure for ch__security_data_recycle
-- ----------------------------
DROP TABLE IF EXISTS `ch__security_data_recycle`;
CREATE TABLE `ch__security_data_recycle`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `controller` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '控制器',
  `controller_as` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '控制器别名',
  `data_table` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对应数据表',
  `connection` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据库连接配置标识',
  `primary_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表主键',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '回收规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__security_data_recycle
-- ----------------------------
INSERT INTO `ch__security_data_recycle` VALUES (1, '管理员', 'auth/Admin.php', 'auth/admin', 'admin', '', 'id', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_data_recycle` VALUES (2, '管理员日志', 'auth/AdminLog.php', 'auth/adminlog', 'admin_log', '', 'id', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_data_recycle` VALUES (3, '菜单规则', 'auth/Menu.php', 'auth/menu', 'menu_rule', '', 'id', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_data_recycle` VALUES (4, '系统配置项', 'routine/Config.php', 'routine/config', 'config', '', 'id', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_data_recycle` VALUES (5, '会员', 'user/User.php', 'user/user', 'user', '', 'id', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_data_recycle` VALUES (6, '数据回收规则', 'security/DataRecycle.php', 'security/datarecycle', 'security_data_recycle', '', 'id', '1', 1736414913, 1736414913);

-- ----------------------------
-- Table structure for ch__security_data_recycle_log
-- ----------------------------
DROP TABLE IF EXISTS `ch__security_data_recycle_log`;
CREATE TABLE `ch__security_data_recycle_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作管理员',
  `recycle_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '回收规则ID',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '回收的数据',
  `data_table` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表',
  `connection` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据库连接配置标识',
  `primary_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表主键',
  `is_restore` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已还原:0=否,1=是',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作者IP',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '数据回收记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__security_data_recycle_log
-- ----------------------------

-- ----------------------------
-- Table structure for ch__security_sensitive_data
-- ----------------------------
DROP TABLE IF EXISTS `ch__security_sensitive_data`;
CREATE TABLE `ch__security_sensitive_data`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `controller` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '控制器',
  `controller_as` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '控制器别名',
  `data_table` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '对应数据表',
  `connection` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据库连接配置标识',
  `primary_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表主键',
  `data_fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '敏感数据字段',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '敏感数据规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__security_sensitive_data
-- ----------------------------
INSERT INTO `ch__security_sensitive_data` VALUES (1, '管理员数据', 'auth/Admin.php', 'auth/admin', 'admin', '', 'id', '{\"username\":\"用户名\",\"mobile\":\"手机\",\"password\":\"密码\",\"status\":\"状态\"}', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_sensitive_data` VALUES (2, '会员数据', 'user/User.php', 'user/user', 'user', '', 'id', '{\"username\":\"用户名\",\"mobile\":\"手机号\",\"password\":\"密码\",\"status\":\"状态\",\"email\":\"邮箱地址\"}', '1', 1736414913, 1736414913);
INSERT INTO `ch__security_sensitive_data` VALUES (3, '管理员权限', 'auth/Group.php', 'auth/group', 'admin_group', '', 'id', '{\"rules\":\"权限规则ID\"}', '1', 1736414913, 1736414913);

-- ----------------------------
-- Table structure for ch__security_sensitive_data_log
-- ----------------------------
DROP TABLE IF EXISTS `ch__security_sensitive_data_log`;
CREATE TABLE `ch__security_sensitive_data_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作管理员',
  `sensitive_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '敏感数据规则ID',
  `data_table` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表',
  `connection` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据库连接配置标识',
  `primary_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据表主键',
  `data_field` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '被修改字段',
  `data_comment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '被修改项',
  `id_value` int(11) NOT NULL DEFAULT 0 COMMENT '被修改项主键值',
  `before` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '修改前',
  `after` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '修改后',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作者IP',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `is_rollback` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已回滚:0=否,1=是',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '敏感数据修改记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__security_sensitive_data_log
-- ----------------------------

-- ----------------------------
-- Table structure for ch__test_build
-- ----------------------------
DROP TABLE IF EXISTS `ch__test_build`;
CREATE TABLE `ch__test_build`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `keyword_rows` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `views` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `likes` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '有帮助数',
  `dislikes` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '无帮助数',
  `note_textarea` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=隐藏,1=正常',
  `weigh` int(11) NOT NULL DEFAULT 0 COMMENT '权重',
  `update_time` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识库表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__test_build
-- ----------------------------

-- ----------------------------
-- Table structure for ch__token
-- ----------------------------
DROP TABLE IF EXISTS `ch__token`;
CREATE TABLE `ch__token`  (
  `token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Token',
  `type` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '类型',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  `expire_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`token`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户Token表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__token
-- ----------------------------
INSERT INTO `ch__token` VALUES ('40755133282486d768561cc5c705a779a0052f2f', 'admin', 1, 1736415193, 1736674393);
INSERT INTO `ch__token` VALUES ('93b3c92183d14661ad52468886115969fb7e731f', 'admin', 1, 1736415259, 1736674459);

-- ----------------------------
-- Table structure for ch__user
-- ----------------------------
DROP TABLE IF EXISTS `ch__user`;
CREATE TABLE `ch__user`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分组ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '手机',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `gender` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别:0=未知,1=男,2=女',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `money` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '余额',
  `score` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '积分',
  `last_login_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '上次登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上次登录IP',
  `login_failure` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '登录失败次数',
  `join_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '加入IP',
  `join_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '加入时间',
  `motto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '签名',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码盐',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '状态',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__user
-- ----------------------------
INSERT INTO `ch__user` VALUES (1, 1, 'user', 'User', '18888888888@qq.com', '18888888888', '', 2, '2025-01-09', 0, 0, NULL, '', 0, '', NULL, '', '', '', 'enable', 1736414913, 1736414913);

-- ----------------------------
-- Table structure for ch__user_group
-- ----------------------------
DROP TABLE IF EXISTS `ch__user_group`;
CREATE TABLE `ch__user_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '权限节点',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__user_group
-- ----------------------------
INSERT INTO `ch__user_group` VALUES (1, '默认分组', '*', '1', 1736414913, 1736414913);

-- ----------------------------
-- Table structure for ch__user_money_log
-- ----------------------------
DROP TABLE IF EXISTS `ch__user_money_log`;
CREATE TABLE `ch__user_money_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `money` int(11) NOT NULL DEFAULT 0 COMMENT '变更余额',
  `before` int(11) NOT NULL DEFAULT 0 COMMENT '变更前余额',
  `after` int(11) NOT NULL DEFAULT 0 COMMENT '变更后余额',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员余额变动表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__user_money_log
-- ----------------------------

-- ----------------------------
-- Table structure for ch__user_rule
-- ----------------------------
DROP TABLE IF EXISTS `ch__user_rule`;
CREATE TABLE `ch__user_rule`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级菜单',
  `type` enum('route','menu_dir','menu','nav_user_menu','nav','button') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'menu' COMMENT '类型:route=路由,menu_dir=菜单目录,menu=菜单项,nav_user_menu=顶栏会员菜单下拉项,nav=顶栏菜单项,button=页面按钮',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '路由路径',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图标',
  `menu_type` enum('tab','link','iframe') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'tab' COMMENT '菜单类型:tab=选项卡,link=链接,iframe=Iframe',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Url',
  `component` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '组件路径',
  `no_login_valid` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '未登录有效:0=否,1=是',
  `extend` enum('none','add_rules_only','add_menu_only') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none' COMMENT '扩展属性:none=无,add_rules_only=只添加为路由,add_menu_only=只添加为菜单',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `weigh` int(11) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `update_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员菜单权限规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__user_rule
-- ----------------------------
INSERT INTO `ch__user_rule` VALUES (1, 0, 'menu_dir', '我的账户', 'account', 'account', 'fa fa-user-circle', 'tab', '', '', 0, 'none', '', 98, '1', 1736414913, 1736414913);
INSERT INTO `ch__user_rule` VALUES (2, 1, 'menu', '账户概览', 'account/overview', 'account/overview', 'fa fa-home', 'tab', '', '/src/views/frontend/user/account/overview.vue', 0, 'none', '', 99, '1', 1736414913, 1736414913);
INSERT INTO `ch__user_rule` VALUES (3, 1, 'menu', '个人资料', 'account/profile', 'account/profile', 'fa fa-user-circle-o', 'tab', '', '/src/views/frontend/user/account/profile.vue', 0, 'none', '', 98, '1', 1736414913, 1736414913);
INSERT INTO `ch__user_rule` VALUES (4, 1, 'menu', '修改密码', 'account/changePassword', 'account/changePassword', 'fa fa-shield', 'tab', '', '/src/views/frontend/user/account/changePassword.vue', 0, 'none', '', 97, '1', 1736414913, 1736414913);
INSERT INTO `ch__user_rule` VALUES (5, 1, 'menu', '积分记录', 'account/integral', 'account/integral', 'fa fa-tag', 'tab', '', '/src/views/frontend/user/account/integral.vue', 0, 'none', '', 96, '1', 1736414913, 1736414913);
INSERT INTO `ch__user_rule` VALUES (6, 1, 'menu', '余额记录', 'account/balance', 'account/balance', 'fa fa-money', 'tab', '', '/src/views/frontend/user/account/balance.vue', 0, 'none', '', 95, '1', 1736414913, 1736414913);

-- ----------------------------
-- Table structure for ch__user_score_log
-- ----------------------------
DROP TABLE IF EXISTS `ch__user_score_log`;
CREATE TABLE `ch__user_score_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `score` int(11) NOT NULL DEFAULT 0 COMMENT '变更积分',
  `before` int(11) NOT NULL DEFAULT 0 COMMENT '变更前积分',
  `after` int(11) NOT NULL DEFAULT 0 COMMENT '变更后积分',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` bigint(16) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员积分变动表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ch__user_score_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
