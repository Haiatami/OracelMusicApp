CREATE USER C##hoanghai IDENTIFIED BY "Abc123456789@";
SHOW PARAMETER COMMON_USER_PREFIX;

--C## nghĩa là "common user", những người có thể kết nối vào tất cả các Pluggable DB
--Tạo một role mới (nhóm người dùng):
CREATE ROLE C##db_admins;

/*
Lưu ý: Tên người dùng/role sau khi tạo bị chuyển sang chữ HOA
user/role trong Oracle có phân biệt hoa/thường 
*/
GRANT CREATE SESSION, CREATE PROCEDURE TO C##hoanghai;

GRANT
	CREATE TABLE,
	SELECT ANY TABLE,
	INSERT ANY TABLE,
	UPDATE ANY TABLE,
	DELETE ANY TABLE
TO C##db_admins;

GRANT C##db_admins TO C##hoanghai;

--Xem các quyền TABLE đã cấp cho user(Database Administrator Table Privileges)
SELECT * FROM dba_tab_privs WHERE grantee='C##DB_ADMINS';

/*
Xem các quyền hệ thống đã cấp cho user "HOANGHAI"
(Database Administrator System Privileges)
*/
SELECT * FROM dba_sys_privs WHERE grantee='C##HOANGHAI';

--Xem các quyền hệ thống trong role:
SELECT * FROM role_sys_privs WHERE role='C##DB_ADMINS';

--Xem các quyền Table trong role:
SELECT * FROM role_tab_privs WHERE role='C##DB_ADMINS';

/*
Bạn có thể xem danh sách các user trong Oracle bằng cách
truy vấn từ view dựng sẵn DBA_USERS,
*/
SELECT COUNT(*) FROM dba_users;

--Bạn có thể thay đổi mật khẩu của một user trong Oracle bằng cách sử dụng lệnh:
ALTER USER C##HOANGHAI IDENTIFIED BY "Abc123456789!";

--Khóa tài khoản(bạn phải có quyền sys):
ALTER USER C##HOANGHAI ACCOUNT LOCK;

--Mở khóa một tài khoản user:
ALTER USER C##HOANGHAI ACCOUNT UNLOCK;

--Bạn có thể xóa một user trong Oracle bằng cách sử dụng lệnh:
DROP USER C##HOANGHAI CASCADE;

--Có thể xóa một role trong Oracle:
DROP ROLE C##DB_ADMINS;