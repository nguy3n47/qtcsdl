-- QTCSDL - BTTL Tuan 02 - 18600187
-- Stored
-- a: Cho biết danh sách các đề tài chưa có giáo viên chủ nhiệm
USE QUANLYDETAI
GO
IF OBJECT_ID('usp_exercise2a', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise2a
GO 
CREATE PROC usp_exercise2a
AS
BEGIN
	SELECT * FROM DETAI DT
	EXCEPT
	SELECT DT.*
	FROM GIANGVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
END
GO
EXEC usp_exercise2a

-- b: Tính tuổi của 1 mã giảng viên cho trước
IF OBJECT_ID('usp_exercise2b', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise2b
GO 
CREATE PROC usp_exercise2b
@maGV varchar(3)
AS
BEGIN
	SELECT GV.MAGV, GV.HOTEN, YEAR(GETDATE())- YEAR(GV.NGSINH) TUOI
	FROM GIANGVIEN GV
	WHERE GV.MAGV = @maGV
END
GO
EXEC usp_exercise2b '007'

-- c: Đếm số đề tài chủ nhiệm của 1 mã giảng viên
IF OBJECT_ID('usp_exercise2c', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise2c
GO 
CREATE PROC usp_exercise2c
@maGV varchar(3)
AS
BEGIN
	SELECT GV.HOTEN, GV.MAGV,COUNT(DISTINCT DT.MADT) SODTCHUNHIEM
	FROM GIANGVIEN GV LEFT JOIN DETAI DT ON @maGV = DT.GVCNDT
	WHERE GV.MAGV = @maGV
	GROUP BY GV.HOTEN, GV.MAGV
END
GO
EXEC usp_exercise2c '007'

-- d: Xuất danh sách (mã gv, họ tên, bộ môn, số đề tài chủ nhiệm) của mỗi giảng viên (truy vấn/ cursor)
IF OBJECT_ID('usp_exercise2d', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise2d
GO 
CREATE PROC usp_exercise2d
AS
BEGIN
	SELECT GV.MAGV, GV.HOTEN, BM.TENBM, (SELECT COUNT(DT.MADT) FROM DETAI DT WHERE DT.GVCNDT = GV.MAGV) SODTCN
	FROM GIANGVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
END
GO
EXEC usp_exercise2d

-- e: Cập nhật trưởng bộ môn cho 1 mã bộ môn cụ thể. Biết rằng, trưởng bộ môn phải là giảng viên trong bộ môn đó.
IF OBJECT_ID('usp_exercise2e', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise2e
GO 
CREATE PROC usp_exercise2e
@maGV varchar(3), @maBM nvarchar(5)
AS
BEGIN
	--Kiểm tra
	IF not exists (SELECT MAGV FROM GIANGVIEN WHERE MAGV=@maGV)
	BEGIN
		raiserror('MAGV không tồn tại', 15,1)
		return
	END
	IF not exists (SELECT MABM FROM BOMON WHERE MABM=@maBM)
	BEGIN
		raiserror('MABM không tồn tại', 15,1)
		return
	END
	IF not exists (SELECT * FROM GIANGVIEN GV JOIN BOMON BM ON BM.MABM = GV.MABM WHERE GV.MAGV= @maGV AND BM.MABM = @maBM)
	BEGIN
		raiserror('GIẢNG VIÊN không thuộc BỘ MÔN giảng dạy', 15,1)
		return
	END
	if exists (SELECT * FROM GIANGVIEN GV JOIN BOMON BM ON BM.MABM = GV.MABM 
				where GV.MAGV= @maGV AND BM.MABM = @maBM AND BM.TRUONGBM = @maGV)
	begin
		raiserror('GIẢNG VIÊN đã làm TRƯỞNG BỘ MÔN', 15,1)
		return
	end
	ELSE
	BEGIN
		UPDATE BOMON
		SET TRUONGBM=@maGV
		WHERE MABM=@maBM
		PRINT N'Update thành công'
		RETURN
	END
END
GO
EXEC usp_exercise2e '003', 'HTTT'