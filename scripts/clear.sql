-- =====================================================
-- 高校公寓管理系统 数据删除脚本
-- 严格按外键依赖逆序删除，避免外键冲突
-- =====================================================

USE dormitory_management;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 删除访客登记表
DELETE FROM dorm_visitor;
-- 重置自增ID
ALTER TABLE dorm_visitor AUTO_INCREMENT = 1;

-- 2. 删除晚归记录表
DELETE FROM dorm_late_return;
ALTER TABLE dorm_late_return AUTO_INCREMENT = 1;

-- 3. 删除报修表
DELETE FROM dorm_repair;
ALTER TABLE dorm_repair AUTO_INCREMENT = 1;

-- 4. 删除调宿申请表
DELETE FROM dorm_move_apply;
ALTER TABLE dorm_move_apply AUTO_INCREMENT = 1;

-- 5. 删除入住记录表
DELETE FROM dorm_checkin_record;
ALTER TABLE dorm_checkin_record AUTO_INCREMENT = 1;

-- 6. 删除床位表
DELETE FROM dorm_bed;
ALTER TABLE dorm_bed AUTO_INCREMENT = 1;

-- 7. 删除房间表
DELETE FROM dorm_room;
ALTER TABLE dorm_room AUTO_INCREMENT = 1;

-- 8. 删除楼栋表
DELETE FROM dorm_building;
ALTER TABLE dorm_building AUTO_INCREMENT = 1;

-- 9. 删除操作日志表
DELETE FROM sys_oper_log;
ALTER TABLE sys_oper_log AUTO_INCREMENT = 1;

-- 10. 删除系统用户表
DELETE FROM sys_user;
ALTER TABLE sys_user AUTO_INCREMENT = 1;

-- 11. 删除通知表
DELETE FROM sys_notice;
ALTER TABLE sys_notice AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

-- 验证是否全部清空
SELECT 'dorm_visitor' AS table_name, COUNT(*) AS row_count FROM dorm_visitor
UNION ALL
SELECT 'dorm_late_return', COUNT(*) FROM dorm_late_return
UNION ALL
SELECT 'dorm_repair', COUNT(*) FROM dorm_repair
UNION ALL
SELECT 'dorm_move_apply', COUNT(*) FROM dorm_move_apply
UNION ALL
SELECT 'dorm_checkin_record', COUNT(*) FROM dorm_checkin_record
UNION ALL
SELECT 'dorm_bed', COUNT(*) FROM dorm_bed
UNION ALL
SELECT 'dorm_room', COUNT(*) FROM dorm_room
UNION ALL
SELECT 'dorm_building', COUNT(*) FROM dorm_building
UNION ALL
SELECT 'sys_oper_log', COUNT(*) FROM sys_oper_log
UNION ALL
SELECT 'sys_user', COUNT(*) FROM sys_user;