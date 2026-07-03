-- =====================================================
-- 高校公寓管理系统 数据库初始化脚本
-- 适用版本：MySQL 8.0+
-- 存储引擎：InnoDB（支持事务）
-- 字符集：utf8mb4（支持完整中文与emoji）
-- 排序规则：utf8mb4_0900_ai_ci
-- =====================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS dormitory_management
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE dormitory_management;

-- 创建测试数据库
# CREATE DATABASE IF NOT EXISTS dormitory_management_test
#     DEFAULT CHARACTER SET utf8mb4
#     DEFAULT COLLATE utf8mb4_0900_ai_ci;
#
# USE dormitory_management_test;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 一、系统基础类表
-- =====================================================

-- ----------------------------
-- 1. 系统用户表 sys_user
-- 统一存储管理员、宿管、学生三类账号
-- ----------------------------
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
                          user_id     BIGINT      NOT NULL AUTO_INCREMENT COMMENT '用户主键ID',
                          username    VARCHAR(50) NOT NULL COMMENT '登录账号（学生用学号/宿管用工号）',
                          password    VARCHAR(100) NOT NULL COMMENT '登录密码（MD5加密存储）',
                          real_name   VARCHAR(20) NOT NULL COMMENT '真实姓名',
                          role_type   TINYINT     NOT NULL DEFAULT 3 COMMENT '角色类型：1-系统管理员 2-宿管 3-学生',
                          gender      TINYINT     NULL COMMENT '性别：1-男 2-女',
                          phone       VARCHAR(20) NULL COMMENT '联系电话',
                          grade       VARCHAR(20) NULL COMMENT '年级（学生专属字段）',
                          major       VARCHAR(50) NULL COMMENT '专业（学生专属字段）',
                          class_name  VARCHAR(50) NULL COMMENT '班级（学生专属字段）',
                          status      TINYINT     NOT NULL DEFAULT 1 COMMENT '账号状态：1-正常 0-禁用',
                          create_time DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          update_time DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          is_deleted  TINYINT     NOT NULL DEFAULT 0 COMMENT '逻辑删除标记：0-未删除 1-已删除',
                          PRIMARY KEY (user_id),
                          UNIQUE KEY uk_username (username) COMMENT '账号唯一索引',
                          KEY idx_role_type (role_type) COMMENT '角色类型查询索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表';

-- ----------------------------
-- 2. 操作日志表 sys_oper_log
-- Spring AOP 自动记录的审计日志
-- ----------------------------
DROP TABLE IF EXISTS sys_oper_log;
CREATE TABLE sys_oper_log (
                              log_id        BIGINT      NOT NULL AUTO_INCREMENT COMMENT '日志主键ID',
                              operator_id   BIGINT      NOT NULL COMMENT '操作人用户ID',
                              module_name   VARCHAR(50) NOT NULL COMMENT '操作模块（如：楼栋管理、报修处理）',
                              oper_type     VARCHAR(20) NOT NULL COMMENT '操作类型（新增/修改/删除/审批/查询）',
                              oper_desc     VARCHAR(255) NOT NULL COMMENT '操作描述',
                              oper_ip       VARCHAR(50) NULL COMMENT '操作IP地址',
                              request_param TEXT        NULL COMMENT '请求参数（JSON格式）',
                              oper_time     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
                              PRIMARY KEY (log_id),
                              KEY idx_operator_id (operator_id) COMMENT '操作人查询索引',
                              KEY idx_oper_time (oper_time) COMMENT '操作时间范围索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作审计日志表';

-- =====================================================
-- 二、宿舍基础信息类表
-- =====================================================

-- ----------------------------
-- 3. 楼栋表 dorm_building
-- ----------------------------
DROP TABLE IF EXISTS dorm_building;
CREATE TABLE dorm_building (
                               building_id   BIGINT      NOT NULL AUTO_INCREMENT COMMENT '楼栋主键ID',
                               building_no   VARCHAR(20) NOT NULL COMMENT '楼栋编号（如：1号楼）',
                               building_name VARCHAR(50) NOT NULL COMMENT '楼栋名称',
                               floor_count   INT         NOT NULL COMMENT '楼层总数',
                               area          VARCHAR(50) NULL COMMENT '所属区域（东区/西区/南区）',
                               manager_id    BIGINT      NULL COMMENT '负责宿管用户ID',
                               remark        VARCHAR(255) NULL COMMENT '备注',
                               create_time   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               update_time   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                               is_deleted    TINYINT     NOT NULL DEFAULT 0 COMMENT '逻辑删除标记：0-未删除 1-已删除',
                               PRIMARY KEY (building_id),
                               UNIQUE KEY uk_building_no (building_no) COMMENT '楼栋编号唯一索引',
                               KEY idx_manager_id (manager_id) COMMENT '宿管关联查询索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '公寓楼栋表';

-- ----------------------------
-- 4. 房间表 dorm_room
-- ----------------------------
DROP TABLE IF EXISTS dorm_room;
CREATE TABLE dorm_room (
                           room_id     BIGINT      NOT NULL AUTO_INCREMENT COMMENT '房间主键ID',
                           room_no     VARCHAR(20) NOT NULL COMMENT '房间编号（如：301）',
                           building_id BIGINT      NOT NULL COMMENT '所属楼栋ID',
                           floor_num   INT         NOT NULL COMMENT '所在楼层',
                           bed_total   INT         NOT NULL COMMENT '额定床位数',
                           room_type   TINYINT     NOT NULL DEFAULT 1 COMMENT '房间类型：1-四人间 2-六人间 3-八人间',
                           remark      VARCHAR(255) NULL COMMENT '备注',
                           create_time DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           update_time DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           is_deleted  TINYINT     NOT NULL DEFAULT 0 COMMENT '逻辑删除标记：0-未删除 1-已删除',
                           PRIMARY KEY (room_id),
                           UNIQUE KEY uk_building_room (building_id, room_no) COMMENT '楼栋+房间号联合唯一索引',
                           KEY idx_building_id (building_id) COMMENT '楼栋关联查询索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '公寓房间表';

-- ----------------------------
-- 5. 床位表 dorm_bed
-- ----------------------------
DROP TABLE IF EXISTS dorm_bed;
CREATE TABLE dorm_bed (
                          bed_id     BIGINT      NOT NULL AUTO_INCREMENT COMMENT '床位主键ID',
                          bed_no     VARCHAR(20) NOT NULL COMMENT '床位编号（如：1号床）',
                          room_id    BIGINT      NOT NULL COMMENT '所属房间ID',
                          bed_status TINYINT     NOT NULL DEFAULT 0 COMMENT '床位状态：0-空闲 1-已入住 2-维修禁用',
                          remark     VARCHAR(255) NULL COMMENT '备注',
                          create_time DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          update_time DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          is_deleted TINYINT     NOT NULL DEFAULT 0 COMMENT '逻辑删除标记：0-未删除 1-已删除',
                          PRIMARY KEY (bed_id),
                          UNIQUE KEY uk_room_bed (room_id, bed_no) COMMENT '房间+床位号联合唯一索引',
                          KEY idx_room_id (room_id) COMMENT '房间关联查询索引',
                          KEY idx_bed_status (bed_status) COMMENT '床位状态筛选索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '公寓床位表';

-- =====================================================
-- 三、核心业务类表
-- =====================================================

-- ----------------------------
-- 6. 入住记录表 dorm_checkin_record
-- 学生入住-退宿全生命周期记录
-- ----------------------------
DROP TABLE IF EXISTS dorm_checkin_record;
CREATE TABLE dorm_checkin_record (
                                     checkin_id     BIGINT   NOT NULL AUTO_INCREMENT COMMENT '入住记录ID',
                                     student_id     BIGINT   NOT NULL COMMENT '学生用户ID',
                                     bed_id         BIGINT   NOT NULL COMMENT '入住床位ID',
                                     checkin_time   DATETIME NOT NULL COMMENT '入住时间',
                                     checkout_time  DATETIME NULL COMMENT '退宿时间（在住状态为空）',
                                     checkin_status TINYINT  NOT NULL DEFAULT 1 COMMENT '入住状态：1-在住 2-已退宿',
                                     operator_id    BIGINT   NOT NULL COMMENT '办理人用户ID',
                                     remark         VARCHAR(255) NULL COMMENT '备注',
                                     create_time    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                     update_time    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                     PRIMARY KEY (checkin_id),
                                     KEY idx_student_id (student_id) COMMENT '学生关联查询索引',
                                     KEY idx_bed_id (bed_id) COMMENT '床位关联查询索引',
                                     KEY idx_checkin_status (checkin_status) COMMENT '入住状态筛选索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '入住记录表';

-- ----------------------------
-- 7. 调宿申请表 dorm_move_apply
-- ----------------------------
DROP TABLE IF EXISTS dorm_move_apply;
CREATE TABLE dorm_move_apply (
                                 apply_id        BIGINT       NOT NULL AUTO_INCREMENT COMMENT '申请主键ID',
                                 student_id      BIGINT       NOT NULL COMMENT '申请人学生ID',
                                 original_bed_id BIGINT       NOT NULL COMMENT '原床位ID',
                                 target_bed_id   BIGINT       NOT NULL COMMENT '目标床位ID',
                                 apply_reason    VARCHAR(255) NOT NULL COMMENT '申请原因',
                                 apply_time      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请提交时间',
                                 audit_status    TINYINT      NOT NULL DEFAULT 0 COMMENT '审批状态：0-待审批 1-已通过 2-已驳回',
                                 auditor_id      BIGINT       NULL COMMENT '审批人用户ID',
                                 audit_time      DATETIME     NULL COMMENT '审批时间',
                                 audit_opinion   VARCHAR(255) NULL COMMENT '审批意见（驳回必填）',
                                 remark          VARCHAR(255) NULL COMMENT '备注',
                                 create_time     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 update_time     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 PRIMARY KEY (apply_id),
                                 KEY idx_student_id (student_id) COMMENT '申请人查询索引',
                                 KEY idx_audit_status (audit_status) COMMENT '审批状态筛选索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '调宿申请表';

-- ----------------------------
-- 8. 报修表 dorm_repair
-- ----------------------------
DROP TABLE IF EXISTS dorm_repair;
CREATE TABLE dorm_repair (
                             repair_id     BIGINT   NOT NULL AUTO_INCREMENT COMMENT '报修单ID',
                             student_id    BIGINT   NOT NULL COMMENT '报修学生ID',
                             room_id       BIGINT   NOT NULL COMMENT '报修房间ID',
                             repair_type   TINYINT  NOT NULL COMMENT '报修类型：1-水电故障 2-家具损坏 3-门窗故障 4-其他',
                             repair_content TEXT    NOT NULL COMMENT '报修详情描述',
                             contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
                             submit_time   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
                             repair_status TINYINT  NOT NULL DEFAULT 0 COMMENT '处理状态：0-待处理 1-处理中 2-已完成',
                             handler_id    BIGINT   NULL COMMENT '处理人用户ID',
                             handle_result TEXT     NULL COMMENT '处理结果',
                             finish_time   DATETIME NULL COMMENT '处理完成时间',
                             remark        VARCHAR(255) NULL COMMENT '备注',
                             create_time   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                             update_time   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                             PRIMARY KEY (repair_id),
                             KEY idx_student_id (student_id) COMMENT '报修学生查询索引',
                             KEY idx_room_id (room_id) COMMENT '报修房间查询索引',
                             KEY idx_repair_status (repair_status) COMMENT '处理状态筛选索引',
                             KEY idx_submit_time (submit_time) COMMENT '提交时间范围索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '报修记录表';

-- ----------------------------
-- 9. 晚归记录表 dorm_late_return
-- ----------------------------
DROP TABLE IF EXISTS dorm_late_return;
CREATE TABLE dorm_late_return (
                                  record_id    BIGINT       NOT NULL AUTO_INCREMENT COMMENT '记录ID',
                                  student_id   BIGINT       NOT NULL COMMENT '晚归学生ID',
                                  building_id  BIGINT       NOT NULL COMMENT '所属楼栋ID',
                                  late_time    DATETIME     NOT NULL COMMENT '晚归时间',
                                  late_reason  VARCHAR(255) NULL COMMENT '晚归原因',
                                  registrar_id BIGINT       NOT NULL COMMENT '登记人用户ID',
                                  record_time  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登记时间',
                                  remark       VARCHAR(255) NULL COMMENT '备注',
                                  create_time  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  update_time  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                  PRIMARY KEY (record_id),
                                  KEY idx_student_id (student_id) COMMENT '学生查询索引',
                                  KEY idx_building_id (building_id) COMMENT '楼栋查询索引',
                                  KEY idx_late_time (late_time) COMMENT '晚归时间范围索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '晚归记录表';

-- ----------------------------
-- 10. 访客登记表 dorm_visitor
-- ----------------------------
DROP TABLE IF EXISTS dorm_visitor;
CREATE TABLE dorm_visitor (
                              visitor_id   BIGINT       NOT NULL AUTO_INCREMENT COMMENT '访客记录ID',
                              visitor_name VARCHAR(20)  NOT NULL COMMENT '访客姓名',
                              id_card      VARCHAR(18)  NOT NULL COMMENT '访客身份证号',
                              student_id   BIGINT       NOT NULL COMMENT '被访学生ID',
                              building_id  BIGINT       NOT NULL COMMENT '被访楼栋ID',
                              visit_time   DATETIME     NOT NULL COMMENT '来访时间',
                              leave_time   DATETIME     NULL COMMENT '离开时间（未离开为空）',
                              visit_reason VARCHAR(255) NULL COMMENT '来访事由',
                              registrar_id BIGINT       NOT NULL COMMENT '登记人用户ID',
                              remark       VARCHAR(255) NULL COMMENT '备注',
                              create_time  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              update_time  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              PRIMARY KEY (visitor_id),
                              KEY idx_student_id (student_id) COMMENT '被访学生查询索引',
                              KEY idx_building_id (building_id) COMMENT '被访楼栋查询索引',
                              KEY idx_visit_time (visit_time) COMMENT '来访时间范围索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '访客登记表';

-- ----------------------------
-- 11. 公告通知表 sys_notice
-- ----------------------------
DROP TABLE IF EXISTS sys_notice;
CREATE TABLE sys_notice (
    notice_id     BIGINT       NOT NULL AUTO_INCREMENT COMMENT '公告ID',
    title         VARCHAR(100) NOT NULL              COMMENT '标题',
    content       TEXT         NOT NULL              COMMENT '内容（Markdown）',
    notice_type   TINYINT      NOT NULL DEFAULT 1    COMMENT '分类：1-通知 2-维修 3-活动 4-紧急',
    visible_scope TINYINT      NOT NULL DEFAULT 1    COMMENT '可见范围：1-全部 2-按楼栋',
    building_id   BIGINT       DEFAULT NULL          COMMENT '楼栋ID（scope=2时必填）',
    status        TINYINT      NOT NULL DEFAULT 1    COMMENT '状态：1-发布 0-下架',
    is_top        TINYINT      NOT NULL DEFAULT 0    COMMENT '是否置顶：0-否 1-是',
    is_banner     TINYINT      NOT NULL DEFAULT 0    COMMENT '是否上轮播：0-否 1-是',
    banner_image  VARCHAR(255) DEFAULT NULL          COMMENT '轮播图片路径（服务器本地）',
    banner_expire DATETIME     DEFAULT NULL          COMMENT '轮播过期时间',
    publisher_id  BIGINT       NOT NULL              COMMENT '发布人ID',
    publish_time  DATETIME     DEFAULT NULL          COMMENT '发布时间',
    create_time   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (notice_id),
    KEY idx_status (status) COMMENT '状态查询索引',
    KEY idx_publish_time (publish_time) COMMENT '发布时间排序索引',
    KEY idx_banner_expire (banner_expire) COMMENT '轮播过期时间索引'
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告通知表';

SET FOREIGN_KEY_CHECKS = 1;
