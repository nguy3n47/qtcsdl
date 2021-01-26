-- Tạo login với username là Joe và pass là 1
-- Tạo username = Joeee cho db CSDLlt với login là Joe
CREATE LOGIN [Joe] WITH PASSWORD = '1', CHECK_POLICY = OFF
GO
 
USE QLSV
GO
CREATE USER [Joeee] FOR LOGIN [Joe]
WITH DEFAULT_SCHEMA = [dbo]
GO
 
-- Cấp quyền đọc trong bảng product cho Joe
-- và không có quyền cấp cho user khác vì ko có từ khóa(with grant option)
GRANT SELECT ON OBJECT::Production.Product TO [Joe]
GO


-- Tạo role 
CREATE ROLE [NewRole]
GO
-- Cấp quyền đọc trong bảng product cho role mới 
-- và không có quyền cấp cho role khác vì ko có từ khóa(with grant option)
GRANT SELECT ON [Production].[Product] TO [NewRole]
GO
-- Thêm Joe vào NewRole
EXEC sp_addrolemember N'NewRole', N'Joe'
GO
 
-- Kiểm tra Joe có bị từ chối xem bảng product
EXECUTE AS USER = 'Joe'
SELECT * FROM Production.Product
REVERT
 
-- Khôi phục lại lệnh trước đó của Joe
-- ví dụ cấp quyền xem bảng product cho Joe
--		revoke => joe sẽ ko xem được bảng product
REVOKE SELECT ON OBJECT::Production.Product FROM [Joe]
 
-- Kiểm tra xem Joe có xem được bảng Product hay không
EXECUTE AS USER = 'Joe'
SELECT * FROM Production.Product
REVERT
 
-- Từ chối quyền truy cập bảng product của Joe 
-- mà các thành viên khác vẫn có thể truy cập vì ko có cascade
DENY SELECT ON OBJECT::Production.Product TO [Joe]
