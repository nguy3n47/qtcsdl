-- BTVN02 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE Quan_Ly_Sinh_Vien
GO

-- 6.1: In danh sách các sinh viên của 1 lớp học
IF OBJECT_ID('usp_exercise61', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise61
GO 
CREATE PROC usp_exercise61
	@maLop varchar(10)
AS
BEGIN
	SELECT DISTINCT SV.* FROM SinhVien SV WHERE SV.MaLop = @maLop
END
GO
EXEC usp_exercise61 'TH2002/01'
GO

-- 6.2: Nhập vào 2 sinh viên, 1 môn học, tìm xem sinh viên nào có điểm thi môn học đó lần đầu tiên là cao hơn.
CREATE FUNCTION CHECKMAX
(
	@maSV varchar(10),
	@maMH varchar(10)
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @ketQua float;
	SET @ketQua = 0;
	SELECT @ketqua = DiemThi FROM KetQua
	WHERE KetQua.MaMH = @maMH
	AND KetQua.MaSV = @maSV
	AND KetQua.LanThi = 1
	return @ketQua
END
GO

IF OBJECT_ID('usp_exercise62', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise62
GO 
CREATE PROC usp_exercise62
	@maSV1 varchar(10),
	@maSV2 varchar(10),
	@maMH varchar(10)
AS
BEGIN
	DECLARE @ketqua1 float
	DECLARE @ketqua2 float
	SELECT @ketqua1 = dbo.CHECKMAX(@maSV1, @maMH)
	SELECT @ketqua2 = dbo.CHECKMAX(@maSV2, @maMH)
	IF (@ketqua1 > @ketqua2)
		print 'Sinh vien co MSSV: ' + cast(@maSV1 as char(7)) + ' co diem thi cao hon Sinh Vien co MSSV: ' + cast(@maSV2 as char(7))
	ELSE
		print 'Sinh vien co MSSV: ' + cast(@maSV2 as char(7)) + ' co diem thi cao hon Sinh Vien co MSSV: ' + cast(@maSV1 as char(7))
END
GO
EXEC usp_exercise62 '0212001', '0212002', 'THT01'
GO

-- 6.3: Nhập vào 1 môn học và 1 mã sv, kiểm tra xem sinh viên có đậu môn này trong lần thi đầu tiên không, nếu đậu thì xuất ra là “Đậu”, không thì xuất ra “Không đậu”
IF OBJECT_ID('usp_exercise63', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise63
GO 
CREATE PROC usp_exercise63
	@maSV varchar(10),
	@maMH varchar(10)
AS
BEGIN
	IF (EXISTS (SELECT * FROM KetQua 
	WHERE KetQua.MaSV = @maSV
	AND KetQua.MaMH = @maMH
	AND KetQua.LanThi = 1
	AND KetQua.DiemThi >= 5))
		print N'Đậu'
	ELSE
		print N'Không Đậu'
END
GO
EXEC usp_exercise63 '0212004','THT01'
GO

-- 6.4: Nhập vào 1 khoa, in danh sách các sinh viên (mã sinh viên, họ tên, ngày sinh) thuộc khoa này.
IF OBJECT_ID('usp_exercise64', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise64
GO 
CREATE PROC usp_exercise64
	@maKhoa varchar(10)
AS
BEGIN
	SELECT SinhVien.* FROM SinhVien
	LEFT JOIN Lop ON SinhVien.MaLop = Lop.MaLop
	LEFT JOIN Khoa ON Lop.MaKhoa = Khoa.MaKhoa
	WHERE Khoa.MaKhoa = @maKhoa
END
GO
EXEC usp_exercise64 'CNTT'
GO

-- 6.5: Nhập vào 1 sinh viên và 1 môn học, in điểm thi của sinh viên này của các lần thi môn học đó.
IF OBJECT_ID('usp_exercise65', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise65
GO 
CREATE PROC usp_exercise65
	@maSV varchar(10),
	@maMH varchar(10)
AS
BEGIN
	SELECT KetQua.LanThi, KetQua.DiemThi FROM KetQua 
	where KetQua.MaSV = @maSV
	AND KetQua.MaMH = @maMH
END
GO
EXEC usp_exercise65 '0212001', 'THT01'
GO