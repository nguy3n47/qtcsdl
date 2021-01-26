-- BTVN05 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE Quan_Ly_Sinh_Vien
GO

-- BTTL
-- 1: Viết thủ tục tổng kết kết quả thi trong HK1 năm học 2004 của từng lớp
-- Hàm đếm số lượng sinh viên đậu của 1 lớp theo môn học, học kỳ, năm
IF OBJECT_ID('DemSoLuongSVDau','fn') IS NOT NULL
	DROP FUNCTION DemSoLuongSVDau
GO
create function DemSoLuongSVDau(@malop varchar(10), @mamh varchar(10))
returns float
as
begin
		declare @sl float
		set @sl = (select COUNT(distinct sv.MaSV)
					from KetQua as kq join SinhVien sv on sv.MaSV=kq.MaSV
					where sv.MaLop = @malop and kq.MaMH=@mamh and
					kq.LanThi = (select MAX(LanThi) from KetQua kq1 where kq1.MaSV = kq.MaSV and kq1.MaMH = kq.MaMH)
					and ( kq.DiemThi IS NULL OR kq.DiemThi >= 5))
		return @sl
end
go

-- Hàm đếm số lượng sinh viên rớt của 1 lớp theo môn học, học kỳ, năm
IF OBJECT_ID('DemSoLuongSVRot','fn') IS NOT NULL
	DROP FUNCTION DemSoLuongSVRot
GO
create function DemSoLuongSVRot(@malop varchar(10), @mamh varchar(10))
returns float
as
begin
		declare @sl float
		set @sl = (select COUNT(distinct sv.MaSV)
					from KetQua as kq join SinhVien sv on sv.MaSV=kq.MaSV
					where sv.MaLop = @malop and kq.MaMH=@mamh and
					kq.LanThi = (select MAX(LanThi) from KetQua kq1 where kq1.MaSV = kq.MaSV and kq1.MaMH = kq.MaMH)
					and ( kq.DiemThi IS NULL OR kq.DiemThi < 5))
		return @sl
end
go

IF OBJECT_ID('usp_KQTHI','p') IS NOT NULL
	DROP PROC usp_KQTHI
GO
create proc usp_KQTHI
as
begin
		declare cur cursor for select distinct sv.MaLop, kq.MaMH
							from KetQua kq join SinhVien sv on sv.MaSV = kq.MaSV join GiangKhoa gk on kq.MaMH=gk.MaMH
							where gk.HocKy=1 and gk.NamHoc=2004
		open cur
		declare @malop varchar(20), @mamh varchar(10)
		declare @dau int, @rot int
		fetch next from cur into @malop, @mamh
		while @@FETCH_STATUS = 0
		begin
			set @dau = (select dbo.DemSoLuongSVDau(@malop,@mamh))
			set @rot = (select dbo.DemSoLuongSVRot(@malop,@mamh))
			
			print '   MaLop: ' + @malop  + N'  MAMH: '+ @mamh  + N'  SV đậu: ' + cast(@dau as varchar(10)) + + N'  SV rớt: ' + cast(@rot as varchar(10)) 
			
			fetch next from cur into @malop, @mamh
		end
		close cur
		deallocate cur
end
go
exec usp_KQTHI
go

-- 2: Viết function đếm số lần 1 sinh viên học 1 môn học cụ thể
IF OBJECT_ID('DemSoLan1SVHoc1MonCuThe','fn') IS NOT NULL
	DROP FUNCTION DemSoLan1SVHoc1MonCuThe
GO
create function DemSoLanSVHoc1MonCuThe(@mssv varchar(10), @mh varchar(10))
returns int as
begin
	return (select max(kq.LanThi) 
			from KetQua kq
			where kq.MaSV=@mssv and kq.MaMH=@mh)
end
go
select dbo.DemSoLanSVHoc1MonCuThe('0212001','THT01')
go

-- 3: Viết function kiểm tra môn học có thuộc khoa và chương trình mà sinh viên đang học không
IF OBJECT_ID('KiemTraMHThuocKhoaVaChuongTrinh','fn') IS NOT NULL
	DROP FUNCTION KiemTraMHThuocKhoaVaChuongTrinh
GO
create function KiemTraMHThuocKhoaVaChuongTrinh(@mssv varchar(10), @mh varchar(10))
returns int as
begin
	declare @t int
	if exists (select *
				from SinhVien sv join Lop l on sv.MaLop=l.MaLop join GiangKhoa gk on l.MaCT=gk.MaCT and l.MaKhoa=gk.MaKhoa
				where sv.MaSV=@mssv and gk.MaMH=@mh)
	begin
		set @t=1
	end
	else
		set @t=0
	return @t
end
go
select dbo.KiemTraMHThuocKhoaVaChuongTrinh('0212001','THT01')
go

-- 4: Viết thủ tục thêm 1 kết quả thi cho 1 sinh viên với điều kiện: sinh viên chỉ được thi tối đa 2 lần cho 1 môn học (sử dụng câu 2) và sinh viên phải học môn học thuộc khoa và chương trình mình theo học có mở (sử dụng câu 3)
IF OBJECT_ID('usp_ThemKetQuaThi','p') IS NOT NULL
	DROP PROC usp_ThemKetQuaThi
GO
create proc usp_ThemKetQuaThi
	@mssv varchar(10), @mh varchar(10), @lanthi int, @diem float
as
declare @sl int, @kt int
begin
	set @sl=dbo.DemSoLanSVHoc1MonCuThe(@mssv, @mh)
	set @kt=dbo.KiemTraMHThuocKhoaVaChuongTrinh(@mssv,@mh)
	if not exists (select MaSV from SinhVien where MaSV=@mssv)
	begin
		print N'MSSV không tồn tại'
		return
	end
	else
	begin
		if @sl<=2
		begin
			if @kt=1
			begin
				insert into KetQua(MaSV, MaMH, LanThi, DiemThi)
				values(@mssv,@mh,@lanthi,@diem)
				print N'Thêm thành công'
			end
			else
				print N'Mã môn học' + Cast(@mh as nvarchar(10)) + N'không tồn tại trong chương trình'
		end
		else
			print N'Kết quả thi đã quá 2 lần'
		end
	end
go
exec usp_ThemKetQuaThi '0212007','THT01', 2, 9
go

-- BTVN
-- 1: Viết function đếm số môn mở của 1 khoa, chương trình trong 1 học kỳ
IF OBJECT_ID('DemSoMonMo','fn') IS NOT NULL
	DROP FUNCTION DemSoMonMo
GO
CREATE FUNCTION DemSoMonMo(@maKhoa varchar(10), @maChuongtrinh varchar(10), @namHoc int, @hk int)
RETURNS int
AS
BEGIN
	DECLARE @dem int
	SELECT @dem = COUNT(*) FROM GiangKhoa 
	WHERE MaCT = @maChuongtrinh AND MaKhoa = @maKhoa AND NamHoc = @namHoc AND HocKy = @hk
	RETURN @dem
END
GO

-- 2: Viết thủ tục thêm một môn học mở (giangKhoa) với điều kiện, mỗi học kỳ của năm học, 1 khoa thuộc chương trình chỉ mở tối đa 5 môn và không mở trùng
IF OBJECT_ID('usp_ThemMotMonHocMo','p') IS NOT NULL
	DROP PROC usp_ThemMotMonHocMo
GO
CREATE PROC usp_ThemMotMonHocMo
	@mact VARCHAR(10),
	@makhoa VARCHAR(10),
	@mamh VARCHAR(10),
	@nh INT,
	@hk INT,
	@stlt INT, 
	@stth INT, 
	@stc INT
AS
BEGIN
	IF NOT EXISTS (SELECT MaKhoa FROM Khoa WHERE MaKhoa = @makhoa)
	BEGIN
		RAISERROR('MAKHOA KHÔNG TỒN TẠI', 15,1)
		RETURN
	END

	IF EXISTS (SELECT * FROM GiangKhoa WHERE MaKhoa = @makhoa AND MaMH = @mamh AND NamHoc = @nh AND HocKy = @hk)
	BEGIN
		RAISERROR('MÔN HỌC ĐÃ ĐƯỢC MỞ', 15,1)
		RETURN
	END

	DECLARE @soMon INT
	SET @soMon = (SELECT COUNT(*) 
				  FROM GiangKhoa 
				  WHERE MaKhoa = @makhoa AND NamHoc = @nh AND HocKy = @hk)
	IF @soMon < 5
		BEGIN
			INSERT INTO MonHoc(MaMH, MaKhoa)
			VALUES (@mamh, @makhoa)

			INSERT INTO GiangKhoa (MaCT, MaKhoa, MaMH, NamHoc, HocKy, STLT, STTH, SoTinChi)
			VALUES (@mact, @makhoa, @mamh, @nh, @hk, @stlt, @stth, @stc)
			PRINT N'THÊM THÀNH CÔNG'
			RETURN
		END
	ELSE
		BEGIN
			RAISERROR('ĐÃ MỞ ĐỦ 5 MÔN HỌC TRONG 1 HỌC KỲ',15,1)
			RETURN
		END
END
GO
EXEC usp_ThemMotMonHocMo 'CQ', 'CNTT', 'CS100', 2003, 1, 45, 30, 4
GO
select * from MonHoc
select * from GiangKhoa