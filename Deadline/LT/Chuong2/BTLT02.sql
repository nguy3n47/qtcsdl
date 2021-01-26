USE master
GO
IF DB_ID('BTLT_Chuong2') IS NOT NULL
	DROP DATABASE BTLT_Chuong2
GO
CREATE DATABASE BTLT_Chuong2
GO
USE BTLT_Chuong2

create table SinhVien
(
	MaSV varchar(10),
	HoTen nvarchar(50),
	NgaySinh date,
	CMND varchar(12),
	DiemTB float not null default 0

	constraint PK_SV primary key(MaSV)
)

create table CanBo
(
	MaCB varchar(10),
	HoTen nvarchar(50),
	NgaySinh date,
	DienThoai varchar(10),
	MaBM int

	constraint PK_CB primary key(MaCB)
)

create table DangKy
(
	MaSV varchar(10),
	MaMH varchar(6),
	NgayDangKy date  not null default Getdate()

	constraint PK_DK primary key (MaSV,MaMH)
)

create table MonHoc
(
	TenMH nvarchar(50),
	MaMH varchar(6),
	MaCBPhuTrach varchar(10),

	constraint PK_MH primary key(MaMH)
)

create table BoMon
(
	MaBM int not null identity(1,1),
	MaCBQuanLy  varchar(10),

	constraint PK_BM primary key(MaBM)
)

alter table CanBo add constraint FK_CB_BM foreign key(MaBM) references BoMon

alter table BoMon add constraint FK_BM_CB foreign key(MaCBQuanLy) references CanBo

alter table MonHoc add constraint FK_MH_CB foreign key(MaCBPhuTrach) references CanBo

alter table DangKy add constraint FK_DK_MH foreign key(MaMH) references MonHoc

alter table DangKy add constraint FK_DK_SV foreign key(MaSV) references SinhVien

go
EXEC sp_columns CanBo
EXEC sp_columns DangKy
EXEC sp_columns SinhVien
go

insert into SINHVIEN.SinhVien(MaSV,HoTen,NgaySinh,CMND,DiemTB)
values('18600187','Vũ Cao Nguyên','07/10/2000','241878225',8.1),
('18123647','Trần Đức Huy','10/03/2000','231874168',7.0),
('18128731','Nguyễn Nhật Minh','06/02/2000','2154789444',6.5)

insert into MonHoc (MaMH,TenMH)
values ('CTT001','NMLT'),
('CTT751','OOP'),
('CTT255','WEB')

create table LopHoc
(
	MaLH varchar(10),
	TenLop nvarchar(30)
	constraint pk_LH primary key(MaLH)
)

alter table SinhVien add Lop varchar(10)

alter table SinhVien add constraint fk_SV_LH foreign key(Lop) references LopHoc

update SinhVien
set Lop ='18CK1'
where MASV = '18600187';

update SinhVien
set Lop = '18CTT4'
where MASV='18124578';

update SinhVien
set Lop = '18CTT2'
where MASV='18122547';

select * from SinhVien
alter schema SINHVIEN
transfer dbo.SinhVien
alter schema GIAOVIEN
transfer dbo.CanBo

ALTER TABLE SinhVien
ADD Nam int ;

UPDATE SinhVien
SET Nam = 3
WHERE MaSV = '18600187'
UPDATE SinhVien
SET Nam = 1
WHERE MaSV = '18124578'
UPDATE SinhVien
SET Nam = 2
WHERE MaSV = '18122547'

ALTER TABLE SinhVien
ADD CONSTRAINT Check_Nam CHECK (Nam BETWEEN 1 AND 4)

alter table SinhVien
add constraint cl_Lop
default 'ML00' for Lop;
go
alter table SinhVien
add constraint fk_SV_LH
foreign key(Lop)
references LopHoc
on delete
set default;