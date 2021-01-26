-- BTVN04 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE Quan_Ly_Sinh_Vien
GO

-- Hàm tính điểm thi sau cùng của một sinh viên trong một môn học cụ thể
IF OBJECT_ID('KF_Last_Score_Of_Student', 'p') IS NOT NULL
	DROP FUNCTION dbo.KF_Last_Score_Of_Student
GO
create function KF_Last_Score_Of_Student
(
	@maSV varchar(10),
	@maMH varchar(10)
)
returns float
as
begin
	declare @diem float;
	set @diem = 0;

	select top 1 @diem = KetQua.DiemThi from KetQua
	where MaSV = @maSV and MaMH = @maMH 
	order by KetQua.LanThi desc
	
	return @diem;
end
go

-- Viết function tính điểm TB của 1 MASV (điểm trung bình được tính dựa trên lần thi sau cùng)
IF OBJECT_ID('KF_Last_AVG_Score_Of_Student', 'p') IS NOT NULL
	DROP FUNCTION dbo.KF_Last_AVG_Score_Of_Student
GO
create function KF_Last_AVG_Score_Of_Student
(
	@maSV varchar(10)
)
returns float
as
begin
	declare @maMH varchar(10)
	declare @ketqua float

	select @ketqua = avg(dbo.KF_Last_Score_Of_Student(@maSV, KetQua.MaMH)) from KetQua
	where KetQua.MaSV = @maSV

	return @ketqua
end
go

-- Function đếm số lượng các môn của SV dưới 4 điểm
IF OBJECT_ID('Amount_Subjects_Of_Student_Under_4_points', 'p') IS NOT NULL
	DROP FUNCTION dbo.Amount_Subjects_Of_Student_Under_4_Points
GO
create function Amount_Subjects_Of_Student_Under_4_Points(@masv varchar(10))
returns int
as
begin
		declare @sl float
		set @sl = (select COUNT(*)
					from KetQua as kq
					where kq.MaSV = @masv and
					kq.LanThi >= (select MAX(LanThi) from KetQua kq1 where kq1.MaSV = kq.MaSV and kq1.MaMH = kq.MaMH)
					and ( kq.DiemThi IS NULL OR kq.DiemThi < 4))
		return @sl
end
go

-- Viết store in danh sách sv có điểm trung bình >=8 của từng lớp
IF OBJECT_ID('usp_avgClassSV', 'p') IS NOT NULL
	DROP PROC dbo.usp_avgClassSV
GO
CREATE PROC usp_avgClassSV
AS
BEGIN
		declare cur cursor for select lp.malop, sv.MaSV, sv.HoTen, sv.NamSinh, sv.DanToc
							from Lop lp join SinhVien sv on sv.MaLop = lp.MaLop
		open cur
		declare @malop varchar(20), @masv varchar(10),@hoten nvarchar(50), @namsinh varchar(10), @dantoc varchar(10)
		declare @temp varchar(20), @dtb float
		set @temp = ''
		fetch next from cur into @malop, @masv, @hoten, @namsinh, @dantoc
		while @@FETCH_STATUS = 0
		begin
			set @dtb = (select dbo.KF_Last_AVG_Score_Of_Student(@masv))
			if @dtb >= 8
			begin
				if @malop != @temp
				begin
						set @temp = @malop
						print N'Lớp: ' + @malop
				end
				print '   MSSV: ' + @masv + N'  Họ Tên: ' + @hoten + N'  Năm Sinh: ' + @namsinh + N'  Dân Tộc: ' + @dantoc + N'  Mã Lớp: ' + @malop
			end
			fetch next from cur into @malop, @masv, @hoten, @namsinh, @dantoc
		end
		close cur
		deallocate cur
END
GO
EXEC usp_avgClassSV
go

-- 6.9
-- Đưa dữ liệu vào bảng xếp loại. Sử dụng function 5.3 đã viết ở trên
-- Qui định : ketQua của sinh viên là ”Đạt‘ nếu diemTrungBinh (chỉ tính các môn đã
-- có điểm) của sinh viên đó lớn hơn hoặc bằng 5 và không quá 2 môn dưới 4 điểm,
-- ngược lại thì kết quả là không đạt
-- Đối với những sinh viên có ketQua là ”Đạt‘ thì hocLuc được xếp loại như sau:
-- diemTrungBinh >= 8 thì hocLuc là ”Giỏi”
-- 7 < = diemTrungBinh < 8 thì hocLuc là ”Khá”
-- Còn lại là ”Trung bình”


IF OBJECT_ID('usp_exercise469', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise469
GO
CREATE PROC usp_exercise469
AS
BEGIN
		declare cur cursor for select kq.MaSV, COUNT(*)
									from KetQua as kq
									where kq.LanThi >= (select MAX(LanThi) 
														from KetQua kq1 
														where kq1.MaSV = kq.MaSV and kq1.MaMH = kq.MaMH)
									group by kq.MaSV

		open cur
		declare @mssv varchar(10), @tongmon int, @dtb float, @sl_duoi4 int
		declare @xepLoai table (MaSV varchar(10), DiemTB float, KetQua nvarchar(30), XepLoai nvarchar(30))
		fetch next from cur into @mssv, @tongmon
		while @@FETCH_STATUS = 0
		begin
				set @dtb = (select dbo.KF_Last_AVG_Score_Of_Student(@mssv))
				set @sl_duoi4 = (select dbo.Amount_Subjects_Of_Student_Under_4_points(@mssv))
				if @dtb >= 5 and @sl_duoi4 <= 2
				begin
					print N'Đạt'
					insert into @xepLoai(masv, diemtb, ketqua) values (@mssv, @dtb, N'Đạt')
					if @dtb >= 8
					begin
							update @xepLoai set xeploai = N'Giỏi' where masv = @mssv
					end
					else if @dtb >= 7 and @dtb < 8
					begin
							update @xepLoai set xeploai = N'Khá' where masv = @mssv
					end
					else
					begin
							update @xepLoai set xeploai = N'Trung bình' where masv = @mssv
					end
				end
				else
				begin
					insert into @xepLoai values (@mssv, @dtb, N'Không đạt', NULL)
				end
				fetch next from cur into @mssv, @tongmon
		end

		close cur
		deallocate cur
		select * from @xepLoai
END
GO
EXEC usp_exercise469

-- 6.10: Với các sinh viên có tham gia đầy đủ các môn học của khoa, chương trình mà sinh viên đang theo học, hãy in ra điểm trung bình cho các sinh viên này.
-- (Chú ý: Điểm trung bình được tính dựa trên điểm thi lần sau cùng). Sử dụng function 5.3 đã viết ở trên
IF OBJECT_ID('usp_exercise4610', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise4610
GO
CREATE PROC usp_exercise4610
AS
BEGIN
	select sv.MaSV, dbo.KF_Last_AVG_Score_Of_Student(sv.MaSV) DTB
	from SinhVien sv join Lop l on sv.MaLop = l.MaLop
	where not exists (
	select distinct MaMH from GiangKhoa where makhoa = l.MaKhoa and MaCT=l.MaCT
	except
	select distinct MaMH from KetQua where MaSV = sv.MaSV)
END
GO
EXEC usp_exercise4610