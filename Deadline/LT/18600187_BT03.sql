/*-------------------------------------------
* Name:			Vũ Cao Nguyên
* SID:			18600187
* BTLT03:		Truy vấn nâng cao
-------------------------------------------*/

USE master
GO
IF DB_ID('TestSV') IS NOT NULL
	DROP DATABASE TestSV
GO
CREATE DATABASE TestSV
GO
USE TestSV

--Bài tập 1
Declare @a float, @b float, @c float, @tmp float
Set @a = 2
Set @b = 2.4
Set @c = 2.5
print 'a = '+cast(@a as varchar(4))
print 'b = '+cast(@b as varchar(4))
print 'c = '+cast(@c as varchar(4))
If @a>@b
set @tmp = @b
if @b>@c
set @tmp = @c
if @c>@a
set @tmp = @a
print 'So nho nhat la: '+cast(@tmp as varchar(4))
go

--Bài tập 2
Declare @SinhVien TABLE(MaSV int, HoTen nvarchar(50), DiemTB float);
Insert into @SinhVien(MASV, HoTen, DiemTB)
Values(1,N'Kim Tuệ',9.0),
	  (2,N'Thuần Vũ',8.0),
	  (3,N'Cát Định',7.5),
	  (4,N'Đái Nga',6.5),
	  (5,N'Giả Thông',6.0),
	  (6,N'Hiểu Thêu',7.0),
	  (7,N'Bàng Hương',5.0),
	  (8,N'Khuyến Đạo',5.5),
	  (9,N'Hữu Công',4.0),
	  (10,N'Chử Kỷ',2.0),
	  (11,N'Khôi Canh',10.0)
Declare @Max float, @MS int
set @Max = (SELECT Max(DiemTB) FROM @SinhVien)
set @MS = (SELECT MASV FROM @SINHVIEN WHERE DiemTB=@Max)
if @Max >= 8.0
begin
	print cast(@MS as varchar(4)) + N' - Điểm trung bình: '+ cast(@Max as varchar(4)) +N' - Xếp loại: Giỏi'
end
else if @Max >= 6.5
begin
	print cast(@MS as varchar(4)) + N' - Điểm trung bình: '+ cast(@Max as varchar(4)) +N' - Xếp loại: Khá'
end
else if @Max >= 5.0
begin
	print cast(@MS as varchar(4)) + N' - Điểm trung bình: '+ cast(@Max as varchar(4)) +N' - Xếp loại: Trung bình'
end
else print cast(@MS as varchar(4)) + N' - Điểm trung bình: '+ cast(@Max as varchar(4)) +N' - Xếp loại: Yếu'
go

--Bài tập 3
Declare @SinhVien TABLE(MaSV char(7), HoTen nvarchar(50), NgaySinh varchar(12));
Insert into @SinhVien(MASV, HoTen, NgaySinh)
Values('0912031', N'Trần Đức Huy', '3/7/1999'),
	  ('0912032', N'Vũ Cao Nguyên', '7/10/2000'),
	  ('0912033', N'Nguyễn Văn Minh', '20/9/1990')
Declare @MASV char(7), @HOTEN nvarchar(50), @NGAYSINH varchar(12)
Set @MASV = (SELECT MaSV FROM @SinhVien WHERE MaSV = '0912033')
Set @HOTEN = (SELECT HoTen FROM @SinhVien WHERE MaSV = '0912033')
Set @NGAYSINH = (SELECT NgaySinh FROM @SinhVien WHERE MaSV = '0912033')
print '--------------------------------------------'
print N'Họ và tên: '+ @HOTEN 
print N'MSSV: '+ @MASV
print N'Ngày sinh: '+ @NGAYSINH
print '--------------------------------------------'
go

--Bài tập 4
Declare @SinhVien TABLE(MaSV char(7), HoTen nvarchar(50), NgaySinh varchar(12));
Insert into @SinhVien(MASV, HoTen, NgaySinh)
Values('0912031', N'Trần Đức Huy', '3/7/1999'),
	  ('0912032', N'Vũ Cao Nguyên', '7/10/2000'),
	  ('0912033', N'Nguyễn Văn Minh', '20/9/1990')

Declare @DiemThi TABLE(MaSV char(7), MaMH varchar(10), Diem float);
Insert into @DiemThi(MASV, MaMH, Diem)
Values('0912031',N'Toán',9.5),
      ('0912031',N'Lý',8.5),
      ('0912031',N'Hóa',8.0),
	  ('0912031',N'Văn',6.0),
      ('0912031',N'Tiếng Anh',8.0),

	  ('0912032',N'Toán',10),
      ('0912032',N'Lý',9.5),
      ('0912032',N'Hóa',7.0),
	  ('0912032',N'Văn',5.5),
      ('0912032',N'Tiếng Anh',9.0),

	  ('0912033',N'Toán',6.5),
      ('0912033',N'Lý',7.5),
      ('0912033',N'Hóa',6.0),
	  ('0912033',N'Văn',4.5),
      ('0912033',N'Tiếng Anh',7.0)

SELECT A.MaSV, B.HoTen, SUM(A.Diem)/COUNT(A.MaSV) AS DTB ,'XepLoai' = CASE
When SUM(A.Diem)/COUNT(A.MaSV) > 5.0 Then N'Đậu'
else N'Rớt' End
FROM @DiemThi A JOIN @SinhVien B ON B.MaSV=A.MaSV
GROUP BY A.MaSV,B.HoTen
go

--Bài tập 5
Declare @SinhVien TABLE(MaSV char(7), HoTen nvarchar(50), NgaySinh varchar(12));
Insert into @SinhVien(MASV, HoTen, NgaySinh)
Values('0912031', N'Trần Đức Huy', '3/7/1999'),
	  ('0912032', N'Vũ Cao Nguyên', '7/10/2000'),
	  ('0912033', N'Nguyễn Văn Minh', '20/9/1990')
Declare @MASV char(7)
Set @MASV = '0912003'
if exists(select * from @SinhVien SV where SV.MaSV=@MASV)
begin
print @MASV + N' sinh viên đã tồn tại'
end
else
print @MASV + N' chưa tồn tại'
go

--Bài tập 6
Declare @MonHoc TABLE(MaMH varchar(7), TenMH nvarchar(50), SoChi int);
Insert into @MonHoc(MaMH, TenMH, SoChi)
Values('CH002', N'Đường lối cách mạng của ĐCSVN', 3),
	  ('CT702', N'Quản trị cơ sở dữ liệu', 4),
	  ('CT703', N'Lập trình Web1', 4),
	  ('CT705', N'Lập trình ứng dụng quản lý 1', 4),
	  ('CT721', N'Phát triển ứng dụng cơ sở dữ liệu 1', 4),
	  ('CT727', N'Các thuật toán thông minh nhân tạo và ứng dụng', 4)

Declare @MAMH char(7)
Set @MAMH='CT871'
if exists(select * from @MonHoc MH where MH.MaMH=@MAMH) 
begin
print @MAMH + N' đã tồn tại'
end
else
print N'Mã MH mới là: ' + @MAMH
go

--Bài tập 7
create table SinhVien
(
	MaSV varchar(9),
	HoTen nvarchar(50),
	MaLop varchar(7),
	constraint PK_SV primary key (MaSV)
)

create table Lop
(
	MaLop varchar(7),
	TenLop nvarchar(50),
	constraint PK_L primary key (MaLop)
)

create table KetQua
(
	MaSV varchar(9),
	MaMH varchar(10),
	Diem float,
	constraint PK_KQ primary key (MaSV, MaMH)
)

alter table SinhVien add constraint FK_SV_L foreign key (MaLop) references  Lop
alter table KetQua add constraint FK_KQ_SV foreign key (MaSV) references  SinhVien

Insert Lop
Values('18CK1',N'CĐ CNTT'),
      ('18CTT1',N'CNTT'),
	  ('18TT',N'Toán Tin'),
	  ('18VLH',N'Vật Lý')

Insert SinhVien
Values('18600187',N'Vũ Cao Nguyên','18CK1'),
	  ('18600183',N'Nguyễn Hữu Nghĩa','18CK1'),
	  ('18600190',N'Mai Thanh Nhân','18CK1'),
	  ('18600053',N'Vũ Xuân Đức','18CK1'),
	  ('18600057',N'Bùi Bảo Duy','18CK1'),
      ('18121547',N'Trần Minh Triết','18CTT1'),
      ('18115478',N'Nguyễn Văn Lâm','18TT'),
      ('18137849',N'Phan Thanh Tùng','18VLH')

Insert KetQua
Values('18600187','CT006',9.0),
      ('18600187','CT102',8.5),
      ('18600187','CT501',10),
	  ('18600187','CT730',9.5),
	  ('18600187','CT008',8.0),

	  ('18121547','CNTT006',7.0),
      ('18121547','CNTT102',7.5),
      ('18121547','CNTT501',9.5),
	  ('18121547','CNTT730',10),
	  ('18121547','CNTT008',8.5),

	  ('18115478','TT006',7.5),
      ('18115478','TT102',6.5),
      ('18115478','TT501',8.5),
	  ('18115478','TT730',9.0),
	  ('18115478','TT008',8.0),

	  ('18137849','VL006',9.5),
      ('18137849','VL102',7.5),
      ('18137849','VL501',9.5),
	  ('18137849','VL730',7.0),
	  ('18137849','VL008',8.5)
go

--7-1/7-2
IF object_id('usp_LopHoc', 'p') is not null
	DROP PROC usp_LopHoc
go
Create proc usp_LopHoc
@MaLop varchar(7) output,
@SiSo int output
As
Begin
	set @SiSo=(SELECT COUNT(SV.MaSV) FROM SinhVien SV where @MaLop=SV.MaLop Group by SV.MaLop )
End
go
Declare @MaLop varchar(7)
Set @MaLop='18CK1'
Declare @SiSo int
exec usp_LopHoc @MaLop,@SiSo output
print 'BT 7-1/7-2: Lop: '+@MaLop+' - Si So: '+cast(@SiSo as char(4))
go

--7/3
IF object_id('usp_DiemMH', 'p') is not null
	DROP PROC usp_DiemMH
go
Create proc usp_DiemMH
@MaSV varchar(9),
@MaMH varchar(10),
@Diem float out
As
Begin 
	set @Diem=(Select KQ.Diem from KetQua KQ where @MaSV=KQ.MaSV AND @MaMH = KQ.MaMH)
End
go
Declare @DIEM_MH float
Declare @MSSV varchar(9)
Declare @MA_MH varchar(10)
set @MSSV='18600187'
set @MA_MH='CT501'
exec usp_DiemMH @MSSV, @MA_MH, @DIEM_MH output
print 'BT 7/3: MSSV: '+@MSSV+' - Mon: '+@MA_MH+' - Diem: '+cast(@DIEM_MH as varchar(4))
go

--7/4
print'BT 7/4:'
Declare @SiSo int
Declare @MaLop varchar(7)
Declare cure CURSOR FOR SELECT SV.MaLop,Count(SV.MaSV) AS SiSo FROM SinhVien SV Group by SV.MaLop 
open cure
fetch next from cure into @MaLop, @SiSo
while @@FETCH_STATUS = 0
begin
print @MaLop + ' - Si So: ' + cast(@SiSo as varchar(4))
fetch next from cure into @MaLop, @SiSo
end
close cure
deallocate cure
go

--7/5
IF object_id('usp_TenLop', 'p') is not null
	DROP PROC usp_TenLop
go
Create proc usp_TenLop
@MaSV varchar(9),
@TenLop nvarchar(50) output
As
Begin
	set @TenLop = (select l.TenLop from Lop l join SinhVien sv on l.MaLop=sv.MaLop where @MaSV=sv.MaSV)
End
go
declare @Ketqua nvarchar(50)
declare @MaSV varchar(9)
set @MaSV ='18600187'
exec usp_TenLop @MaSV, @Ketqua output
print 'BT 7/5: MSSV: '+@MaSV+' - TenLop: '+ @Ketqua
go
--drop table KetQua
--drop table SinhVien
--drop table Lop