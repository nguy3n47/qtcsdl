USE master
go
IF DB_ID('QLSV_Backup_Restore') IS NOT NULL
	DROP DATABASE QLSV_Backup_Restore
GO
CREATE DATABASE QLSV_Backup_Restore
GO
USE QLSV_Backup_Restore
go
create table Lop 
(
	MaLop 	varchar(10),
	NamBD 	datetime,
	NamKT	datetime,
	SiSo	int
	primary key (MaLop)
)
go
create table SinhVien 
(
	MaSV 	varchar(15),
	HoTen 	nvarchar(50),
	NamSinh datetime,
	GioiTinh nvarchar(10),
	DiemTB	float,
	MaLop	varchar(10)
	primary key (MaSV)
	foreign key(MaLop) references Lop(MaLop)
)
go
create table GiaoVien 
(
	MaGV 	varchar(15),
	HoTen 	nvarchar(50),
	NgaySinh datetime,
	LoaiGV	nvarchar(15)
	primary key (MaGV)
)
go
create table MonHoc 
(
	MaMH 	varchar(10),
	TenMH 	nvarchar(50),
	SoChi	int
	primary key (MaMH)
)
go
create table KetQua 
(
	MaSV 	varchar(15),
	MaMH 	varchar(10),
	LanThi	int,
	Diem	float
	primary key (MaSV, MaMH, LanThi)
	foreign key(MaSV) references SinhVien(MaSV),
	foreign key(MaMH) references MonHoc(MaMH)
)
go
create table GV_Lop 
(
	MaLop 	varchar(10),
	MaMH 	varchar(10),
	MaGV 	varchar(15)
	primary key (MaLop, MaMH)
	foreign key(MaLop) references Lop(MaLop),
	foreign key(MaGV) references GiaoVien(MaGV),
	foreign key(MaMH) references MonHoc(MaMH),
)