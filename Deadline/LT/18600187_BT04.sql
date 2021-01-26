/*-------------------------------------------
* Name:			Vũ Cao Nguyên
* SID:			18600187
* BTLT04:		3(8)
-------------------------------------------*/

USE master
GO
IF DB_ID('Test38') IS NOT NULL
	DROP DATABASE Test38
GO
CREATE DATABASE Test38
GO
USE Test38

-- Tạo bảng, Khóa chính, Khóa ngoại
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

-- Dữ liệu
Insert Lop
Values('18CK1'),
      ('18CTT1'),
	  ('18TT'),
	  ('18VLH')

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

-- Bài tập 8
-- 8/1
if object_id('uf_DiemTrungBinh', 'tf') is not null
drop function uf_DiemTrungBinh
go
create function uf_DiemTrungBinh ()
Returns table
As
return
(
	Select  SV.HoTen, KQ.MaSV, SUM(KQ.Diem)/COUNT(KQ.MaSV) As DiemTrungBinh
	From Sinhvien SV JOIN KetQua KQ ON SV.MaSV = KQ.MaSV
	Group by SV.HoTen, KQ.MaSV
)
go
select * from dbo.uf_DiemTrungBinh();
go

-- 8/2
if object_id('uf_MaSVCaoNhat', 'tf') is not null
drop function uf_MaSVCaoNhat
go
create function uf_MaSVCaoNhat ()
Returns table
as
return
(
	Select a.MaSV
	From dbo.uf_DiemTrungBinh() a
	Where a.DiemTrungBinh = (Select MAX(b.DiemTrungBinh) from dbo.uf_DiemTrungBinh() b)
)
go
select * from dbo.uf_MaSVCaoNhat();
go

-- 8/3
if object_id('uf_DanhSachSinhVienCoDiemTBDuoi5', 'tf') is not null
drop function uf_DanhSachSinhVienCoDiemTBDuoi5
go
create function uf_DanhSachSinhVienCoDiemTBDuoi5()
Returns table
as 
return
(
	Select *
	From dbo.uf_DiemTrungBinh() a
	Where a.DiemTrungBinh < 5
)
go
select * from dbo.uf_DanhSachSinhVienCoDiemTBDuoi5()
go

-- 8/4
if object_id('uf_XepLoai', 'tf') is not null
drop function uf_XepLoai
go
create function uf_XepLoai()
Returns table
as
return
(
	Select *, 'XepLoai' = Case 
	When a.DiemTrungBinh >= 8.0 then N'Giỏi'
	When a.DiemTrungBinh >= 7.0 then N'Khá'
	When a.DiemTrungBinh >= 5.0 then N'Trung Bình'
	When a.DiemTrungBinh < 5.0 then N'Yếu'
	End From dbo.uf_DiemTrungBinh() a					
)
go
select * from dbo.uf_XepLoai()
go
drop function uf_Xeploai
drop function uf_DanhSachSinhVienCoDiemTBDuoi5
drop function uf_MaSVCaoNhat
drop function uf_DiemTrungBinh
drop table KetQua
drop table Sinhvien
drop table Lop
go