-- BTVN03 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE Quan_Ly_Sinh_Vien
GO

-- Bổ sung câu 4 - BTTL#03: Với mỗi đề tài đã kết thúc, xuất kết quả nghiệm thu đề tài:
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
	DECLARE cur CURSOR FOR SELECT DT.MADT FROM DETAI DT JOIN THAMGIADT TGDT ON TGDT.MADT = DT.MADT
									WHERE DT.NGAYKT < GETDATE()
									GROUP BY DT.MADT
	OPEN cur
	DECLARE @maDT varchar(3), @tong float, @Dau float, @ChuaDau float, @ChuaHoanThanh float, @KQ float
	FETCH NEXT FROM cur INTO @maDT
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @tong = COUNT(*) FROM THAMGIADT WHERE MADT = @maDT
		SELECT @Dau = COUNT(*) FROM THAMGIADT WHERE MADT = @maDT AND KETQUA = N'ĐẠT'
		SELECT @ChuaDau = COUNT(*) FROM THAMGIADT WHERE MADT = @maDT AND KETQUA = N'KHÔNG ĐẠT'
		SELECT @ChuaHoanThanh = COUNT(*) FROM THAMGIADT WHERE MADT = @maDT AND KETQUA IS NULL
		IF(@Dau = @tong)
		BEGIN
			print @maDT + ' ' + N'Tỷ lệ đậu: 100%' + N' Tỷ lệ không đạt: 0%' 
					+ N' Tỷ lệ chưa hoàn thành (NULL): 0%' + N' XẾP LOẠI ĐỀ TÀI: Giỏi'
		END
		ELSE IF(@Dau >= 0.8 AND @ChuaHoanThanh = 0)
		BEGIN
			print @maDT + ' ' + N'Tỷ lệ đậu: 80%' + N' Tỷ lệ không đạt: ' +  str(@ChuaDau/@tong*100, 4, 3)
					+ N'% Tỷ lệ chưa hoàn thành (NULL): ' + str(@ChuaHoanThanh/@tong*100, 4, 3) + N'% XẾP LOẠI ĐỀ TÀI: KHÁ'
		END
		ELSE IF(@Dau >= 0.7 AND @ChuaDau >= 0.3 AND @ChuaHoanThanh = 0)
		BEGIN
			print @maDT + ' ' + N'Tỷ lệ đậu: 70%' + N' Tỷ lệ không đạt: ' + str(@ChuaDau/@tong*100, 4, 3)
					+ N'% Tỷ lệ chưa hoàn thành (NULL): ' + str(@ChuaHoanThanh/@tong*100, 4, 3) + N'% XẾP LOẠI ĐỀ TÀI: TRUNG BÌNH'
		END
		ELSE IF(@Dau <= 0.5 AND @ChuaHoanThanh > 0)
		BEGIN
			print @maDT + ' ' + N'Tỷ lệ đậu: ' + str(@Dau/@tong*100, 4, 3) + N'% Tỷ lệ không đạt: ' +  str(@ChuaDau/@tong*100, 4, 3)
					+ N'% Tỷ lệ chưa hoàn thành (NULL): ' + str(@ChuaHoanThanh/@tong*100, 4, 3) + N'% XẾP LOẠI ĐỀ TÀI: FAILED'
		END
		ELSE
		BEGIN
			print @maDT + ' ' + N'Tỷ lệ đậu: ' + str(@Dau/@tong * 100, 4, 3) + N'% Tỷ lệ không đạt: ' + str(@ChuaDau/@tong*100, 4, 3)
						+ N'% Tỷ lệ chưa hoàn thành (NULL): ' + str(@ChuaHoanThanh/@tong*100, 4, 3) + '%'
		END
		FETCH NEXT FROM cur INTO @maDT
	END
	CLOSE cur              -- Đóng Cursor
	DEALLOCATE cur         -- Giải phóng tài nguyên
END
GO
EXEC usp_exercise34

-- 6.6: Nhập vào 1 sinh viên, in ra các môn học mà sinh viên này phải học.
IF OBJECT_ID('usp_exercise66', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise66
GO 
CREATE PROC usp_exercise66
	@maSV VARCHAR(10)
AS
BEGIN
	SELECT MONHoc.* FROM MONHoc
	JOIN Khoa ON MONHoc.MaKhoa = Khoa.MaKhoa 
	JOIN Lop ON Lop.MaKhoa = Khoa.MaKhoa
	JOIN SinhVien ON SinhVien.MaLop = Lop.MaLop
	WHERE SinhVien.MaSV = @maSV
END
GO
EXEC usp_exercise66 '0212001'
GO

-- 6.7: Nhập vào 1 môn học, in danh sách các sinh viên đậu môn này trONg lần thi đầu tiên.
IF OBJECT_ID('usp_exercise67', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise67
GO 
CREATE PROC usp_exercise67
	@maMH VARCHAR(10)
AS
BEGIN
	SELECT * 
	FROM KetQua 
	WHERE MaMH = @maMH 
	AND LanThi = 1 
	AND DiemThi >= 5
END
GO
EXEC usp_exercise67 'THT01'
GO

-- 6.8: In điểm các môn học của sinh viên có mã số là maSinhVien được nhập vào.
-- (Chú ý: điểm của môn học là điểm thi của lần thi sau cùng)
-- Chỉ in các môn đã có điểm
-- Các môn chưa có điểm thì ghi điểm là null
-- Các môn chưa có điểm thì ghi điểm là <chưa có điểm>
IF OBJECT_ID('usp_exercise68', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise68
GO 
CREATE PROC usp_exercise68
	@maSV VARCHAR(10)
AS
BEGIN
	 DECLARE @TEST TABLE(MaSV varchar(10), MaMH varchar(10), LanThi int, DiemThi nvarchar(50))
	 INSERT INTO @TEST SELECT *
     FROM KetQua KQ
     WHERE KQ.MaSV = @maSV
     AND KQ.LanThi = (SELECT MAX(KQ2.LanThi)
                      FROM KetQua KQ2
                      WHERE KQ2.MaSV = KQ.MaSV
                      AND KQ2.MaMH = KQ.MaMH)

	DECLARE @diem nvarchar(50)
	DECLARE cur CURSOR FOR
	SELECT DiemThi FROM @TEST
	OPEN cur
	FETCH NEXT FROM cur
    INTO @diem
	WHILE @@FETCH_STATUS = 0       
	BEGIN                                               
		IF(@diem IS NULL)
		BEGIN
			UPDATE @TEST
			SET DiemThi = N'<CHƯA CÓ ĐIỂM>'
			WHERE CURRENT OF cur
		END
		FETCH NEXT FROM cur -- Đọc dòng tiếp
        INTO @diem
	END
	CLOSE cur              -- Đóng Cursor
	DEALLOCATE cur         -- Giải phóng tài nguyên
	SELECT * FROM @TEST
END
GO
EXEC usp_exercise68 '0212003'
GO