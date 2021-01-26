-- QTCSDL - BTTL Tuan 04 - 18600187
-- Stored
USE QUANLYDETAI
GO

-- 1: Viết store phân công 1 giáo viên chủ nhiệm 1 đề tài cụ thể với điều kiện: Tại thời điểm phân công, giáo viên chỉ được chủ nhiệm tối đa 3 đề tài (kể cả đề tài chưa kết thúc).
IF OBJECT_ID('usp_exercise41', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise41
GO 
CREATE PROC usp_exercise41
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
EXEC usp_exercise41 '005', N'ỨNG DỤNG HÓA HỌC XANH', N'TRƯỜNG', 150, '10/10/2003', '12/10/2004', N'UDCN', '007'

-- 2: Viết stored đếm số lượng giảng viên nam, nữ của mỗi đề tài
IF OBJECT_ID('usp_exercise42', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise42
GO 
CREATE PROC usp_exercise42
AS
BEGIN
	SELECT  TGDT.MADT, GV.PHAI, COUNT(*) AS 'SỐ LƯỢNG'
	FROM GIANGVIEN GV JOIN THAMGIADT TGDT
	ON GV.MAGV = TGDT.MAGV
	GROUP BY TGDT.MADT, GV.PHAI
END
GO
EXEC usp_exercise42

-- 3: Viết stored xuất danh sách các bộ môn có nhiều đề tài loại giỏi nhất
IF OBJECT_ID('usp_exercise43', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise43
GO 
CREATE PROC usp_exercise43
AS
BEGIN
	DECLARE cur CURSOR FOR SELECT DT.MADT, BM.MABM FROM DETAI DT JOIN THAMGIADT TGDT ON TGDT.MADT = DT.MADT JOIN GIAOVIEN GV ON GV.MAGV = TGDT.MAGV JOIN BOMON BM ON BM.MABM = GV.MABM
									WHERE DT.NGAYKT < GETDATE()
									GROUP BY DT.MADT, BM.MABM
	OPEN cur
	DECLARE @maDT varchar(3), @maBM varchar(10), @tong float, @Dau float
	FETCH NEXT FROM cur INTO @maDT, @maBM
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @tong = COUNT(*) FROM THAMGIADT WHERE MADT = @maDT
		SELECT @Dau = COUNT(*) FROM THAMGIADT WHERE MADT = @maDT AND KETQUA = N'ĐẠT'
		IF(@Dau = @tong)
		BEGIN
			print @maDT + @maBM + ' ' + N'Tỷ lệ đậu: 100%' + N' Tỷ lệ không đạt: 0%' 
					+ N' Tỷ lệ chưa hoàn thành (NULL): 0%' + N' XẾP LOẠI ĐỀ TÀI: Giỏi'
		END
		FETCH NEXT FROM cur INTO @maDT, @maBM
	END
	CLOSE cur              -- Đóng Cursor
	DEALLOCATE cur         -- Giải phóng tài nguyên
END
GO
EXEC usp_exercise43

-- 4: Viết stored phân công công việc cho 1 giáo viên, với điều kiện giáo viên chỉ được phụ trách tối đa 3 công việc (kể cả công việc chưa hoàn thành). Tức là nếu thời điểm phân công, giảng viên đã được phân công 2 công việc và chưa hoàn thành thì chỉ được nhận thêm 1 công việc. Nếu các công việc phân công trước đó đã hoàn thành (kết quả đạt) thì được phép phân công thêm 3 công việc khác. 
IF OBJECT_ID('usp_exercise44', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise44
GO 
CREATE PROC usp_exercise44 
	@magv VARCHAR(3),
	@madt VARCHAR(4),
	@STT INT
AS
BEGIN
	IF NOT EXISTS (SELECT MAGV FROM GIANGVIEN WHERE MAGV = @magv)
	BEGIN
		RAISERROR('Mã GV không tồn tại', 15,1)
		RETURN
	END
	IF NOT EXISTS (SELECT * FROM DETAI WHERE MADT = @madt)
	BEGIN
		RAISERROR('Mã ĐỀ TÀI không tồn tại', 15,1)
		RETURN
	END
	IF EXISTS (SELECT * FROM THAMGIADT WHERE MADT = @madt AND MAGV = @magv)
	BEGIN
		RAISERROR('GV đã được phân công chủ nhiệm đề tài này', 15, 1)
		RETURN
	END
	DECLARE @SLCV INT
	SET @SLCV = 
		(SELECT COUNT(*) 
		FROM THAMGIADT 
		WHERE MADT = @MADT
			AND MAGV = @MAGV
			AND KETQUA != N'ÐẠT')
	IF @SLCV >= 3
	BEGIN
		RAISERROR('ĐÃ ĐẠT TỐI ĐA SỐ LƯỢNG CÔNG VIỆC', 15, 1)
		RETURN
	END
	ELSE
	BEGIN
	INSERT INTO THAMGIADT(MAGV, MADT, STT) VALUES (@MAGV, @MADT, @STT)
	END
END
GO
EXEC usp_exercise44 '002', '006', 2

--SELECT * FROM CONGVIEC
--SELECT * FROM THAMGIADT
--SELECT * FROM DETAI
--SELECT * FROM GIANGVIEN
--SELECT * FROM BOMON