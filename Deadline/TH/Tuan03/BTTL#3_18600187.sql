-- QTCSDL - BTTL Tuan 03 - 18600187
-- Stored
USE QUANLYDETAI
GO
-- 1: Viết stored đếm số lượng công việc có kết quả “Đạt” của mỗi đề tài
IF OBJECT_ID('usp_exercise31', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise31
GO 
CREATE PROC usp_exercise31
AS
BEGIN
	SELECT TGDT.MADT, COUNT(*) SL
				FROM THAMGIADT TGDT
				WHERE TGDT.KETQUA= N'ÐẠT'
				GROUP BY TGDT.MADT
END
GO
EXEC usp_exercise31

-- 2: Viết stored đếm số lượng công việc có kết quả: “Không đạt” của mỗi đề tài
IF OBJECT_ID('usp_exercise32', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise32
GO 
CREATE PROC usp_exercise32
	
AS
BEGIN
	SELECT TGDT.MADT, COUNT(*) SL
				FROM THAMGIADT TGDT
				WHERE TGDT.KETQUA = N'KHÔNG ĐẠT'
				GROUP BY TGDT.MADT
END
GO
EXEC usp_exercise32

-- 3: Viết stored đếm số lượng công việc chưa có kết quả: “NULL” của mỗi đề tài
IF OBJECT_ID('usp_exercise33', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise33
GO 
CREATE PROC usp_exercise33
AS
BEGIN
	SELECT TGDT.MADT, COUNT(*) SL
				FROM THAMGIADT TGDT
				WHERE TGDT.KETQUA is null
				GROUP BY TGDT.MADT
END
GO
EXEC usp_exercise33

-- 4: Với mỗi đề tài đã kết thúc, xuất kết quả nghiệm thu đề tài:
-- Mã đề tài:
-- Tỷ lệ đạt:
-- Tỷ lệ không đạt:
-- Tỷ lệ chưa hoàn thành (NULL):
-- XẾP LOẠI ĐỀ TÀI: (GIỎI: 100% đạt; KHÁ: 80% đạt và không có công việc nào chưa hoàn thành; TRUNG BÌNH: 70% đạt, 30% không đạt, không có công việc chưa hoàn thành; FAILED: <=50% đạt và còn công việc chưa hoàn thành)
IF OBJECT_ID('usp_exercise34', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise34
GO 
CREATE PROC usp_exercise34
AS
BEGIN
	SELECT * FROM DETAI
END
GO
EXEC usp_exercise34

-- 5: Viết store phân công 1 giáo viên chủ nhiệm 1 đề tài cụ thể với điều kiện: Tại thời điểm phân công, giáo viên chỉ được chủ nhiệm tối đa 3 đề tài (kể cả đề tài chưa kết thúc).
IF OBJECT_ID('usp_exercise35', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise35
GO 
CREATE PROC usp_exercise35
	@madt varchar(5),
	@tendt nvarchar(50),
	@capql varchar(10),
	@kinhphu int,
	@ngaydb date,
	@ngaykt date,
	@macd varchar(10),
	@gvcndt varchar(5)
AS
BEGIN
	--kiểm tra magv có tồn tại không
	if not exists (SELECT MAGV FROM GIANGVIEN WHERE MAGV=@gvcndt)
	begin
		raiserror('MAGV KHÔNG TỒN TẠI', 15,1)
		return
	end
	declare @socv int
	set @socv = (SELECT COUNT(*) FROM DETAI WHERE  GVCNDT=@gvcndt)
	if @socv<3
	begin
		insert into DETAI(MADT, TENDT, CAPQL, KINHPHI,NGAYBD,NGAYKT,MACD,GVCNDT) values (@madt, @tendt, @capql, @kinhphu, @ngaydb, @ngaykt, @macd, @gvcndt)
		print N'Thêm thành công'
		return
	end
	else
	begin
		raiserror('GV không được chủ nhiệm quá 3 DETAI',15,1)
		return
	end
END
GO
EXEC usp_exercise35 '005', N'ỨNG DỤNG HÓA HỌC XANH', N'TRƯỜNG', 150, '10/10/2003', '12/10/2004', N'UDCN', '007'

--6: Viết stored đếm số lượng giảng viên nam, nữ của mỗi đề tài
IF OBJECT_ID('usp_exercise36', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise36
GO 
CREATE PROC usp_exercise36
AS
BEGIN
	SELECT  TGDT.MADT, GV.PHAI, COUNT(*) AS 'SỐ LƯỢNG'
	FROM GIANGVIEN GV JOIN THAMGIADT TGDT
	ON GV.MAGV = TGDT.MAGV
	GROUP BY TGDT.MADT, GV.PHAI
END
GO
EXEC usp_exercise36

--SELECT * FROM CONGVIEC
--SELECT * FROM THAMGIADT
--SELECT * FROM DETAI
--SELECT * FROM GIANGVIEN