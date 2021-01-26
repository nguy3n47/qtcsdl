-- BTVN01 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE master
GO
IF DB_ID('Quan_Ly_Sinh_Vien') IS NOT NULL
	DROP DATABASE Quan_Ly_Sinh_Vien
GO
CREATE DATABASE Quan_Ly_Sinh_Vien
GO
USE Quan_Ly_Sinh_Vien

create table Khoa
(
	MaKhoa varchar(10) primary key,
	TenKhoa nvarchar(100),
	NamThanhLap int
)
go

create table KhoaHoc
(
	MaKhoaHoc varchar(10) primary key, 
	NamBatDau int,
	NamKetThuc int
)

create table ChuongTrinhHoc
(
	MaCT varchar(10) primary key,
	TenCT nvarchar(100)
)
go

create table Lop
(
	MaLop varchar(10) primary key,
	MaKhoa varchar(10) not null,
	MaKhoaHoc varchar(10) not null,
	MaCT varchar(10) not null,
	STT int

	foreign key(MaKhoa) references Khoa(MaKhoa),
	foreign key(MaKhoaHoc) references KhoaHoc(MaKhoaHoc),
	foreign key(MaCT) references ChuongTrinhHoc(MaCT)
)
go

create table SinhVien
(
	MaSV varchar(10) primary key,
	HoTen nvarchar(100),
	NamSinh int,
	DanToc nvarchar(20),
	MaLop varchar(10) not null

	foreign key(MaLop) references Lop(MaLop)
)
go

create table MonHoc
(
	MaMH varchar(10) primary key,
	MaKhoa varchar(10) not null,
	TenMH nvarchar(100)

	foreign key(MaKhoa) references Khoa(MaKhoa)
)
go

create table KetQua
(
	MaSV varchar(10) not null,
	MaMH varchar(10) not null,	
	LanThi int not null,
	DiemThi float

	primary key(MaSV, MaMH, LanThi),

	foreign key(MaSV) references SinhVien(MaSV),
	foreign key(MaMH) references MonHoc(MaMH)
)
go

create table GiangKhoa
(
	MaCT varchar(10) not null,
	MaKhoa varchar(10) not null,	
	MaMH varchar(10) not null,
	NamHoc int not null,
	HocKy int,
	STLT int,
	STTH int,
	SoTinChi int

	primary key(MaCT, MaKhoa, MaMH, NamHoc),

	foreign key(MaCT) references ChuongTrinhHoc(MaCT),
	foreign key(MaKhoa) references Khoa(MaKhoa),
	foreign key(MaMH) references MonHoc(MaMH)
)
go

-- Insert Table Khoa
Insert into Khoa(MaKhoa, TenKhoa, NamThanhLap) values( 'CNTT', N'Công nghệ thông tin',1995)
go
Insert into Khoa values('VL', N'Vật Lý' , 1970)
go


-- Insert Table Khóa Học
Insert into KhoaHoc(NamBatDau, MaKhoaHoc, NamKetThuc) values( 2002, 'K2002',2006)
go
Insert into KhoaHoc values('K2003', 2003, 2007)
go
Insert into KhoaHoc values('K2004', 2004, 2008)
go


-- Insert Table Chương trình học
Insert into ChuongTrinhHoc values('CQ', N'Chính Quy')
go

-- Insert Table Lớp
Insert into Lop values('TH2002/01', 'CNTT','K2002', 'CQ', 1)
go
Insert into Lop values('TH2002/02', 'CNTT','K2002', 'CQ', 2)
go
Insert into Lop values('TH2003/01', 'VL','K2003', 'CQ', 1)
go

-- Insert Table Sinh Viên
Insert into SinhVien values('0212001', N'Nguyễn Vĩnh An', 1984, N'Kinh', 'TH2002/01')
go
Insert into SinhVien values('0212002', N'Nguyễn Thanh Bình', 1985, N'Kinh', 'TH2002/01')
go
Insert into SinhVien values('0212003', N'Nguyễn Thanh Cường', 1984, N'Kinh', 'TH2002/02')
go
Insert into SinhVien values('0212004', N'Nguyễn Quốc Duy', 1983, N'Kinh', 'TH2002/02')
go
Insert into SinhVien values('0311001', N'Phan Tuấn Anh', 1985, N'Kinh', 'TH2003/01')
go
Insert into SinhVien values('0311002', N'Huỳnh Thanh Sang', 1984, N'Kinh', 'TH2003/01')
go

-- Insert Table Môn Học
Insert into MonHoc values('THT01', 'CNTT', N'Toán cao cấp A1')
go
Insert into MonHoc values('VLT01', 'VL', N'Toán cao cấp A1')
go
Insert into MonHoc values('THT02', 'CNTT', N'Toán rời rạc')
go
Insert into MonHoc values('THCS01', 'CNTT', N'Cấu trúc dữ liệu 1')
go
Insert into MonHoc values('THCS02', 'CNTT', N'Hệ điều hành')
go

-- Insert Table Kết Quả
Insert into KetQua values('0212001', 'THT01', 1,4)
go
Insert into KetQua values('0212001', 'THT01', 2,7)
go
Insert into KetQua values('0212002', 'THT01', 1,8)
go
Insert into KetQua values('0212003', 'THT01', 1,6)
go
Insert into KetQua values('0212004', 'THT01', 1,9)
go
Insert into KetQua values('0212001', 'THT02', 1,8)
go
Insert into KetQua values('0212002', 'THT02', 1,5.5)
go
Insert into KetQua values('0212003', 'THT02', 1,4)
go
Insert into KetQua values('0212003', 'THT02', 2,6)
go
Insert into KetQua values('0212001', 'THCS01', 1,6.5)
go
Insert into KetQua values('0212002', 'THCS01', 1,4)
go
Insert into KetQua values('0212003', 'THCS01', 1,7)
go

-- Insert Table Giảng Khoa
Insert into GiangKhoa values('CQ', 'CNTT', 'THT01',2003, 1, 60, 30, 5)
go
Insert into GiangKhoa values('CQ', 'CNTT', 'THT02',2003, 2, 45, 30, 4)
go
Insert into GiangKhoa values('CQ', 'CNTT', 'THCS01',2004, 1, 45, 30, 4)
go

-- Stored
-- 4/1: Danh sách các sinh viên khoa “Công nghệ Thông tin” khoá 2002-2006
IF OBJECT_ID('usp_exercise41', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise41
GO 
CREATE PROC usp_exercise41
AS
BEGIN
	SELECT SV.*
	FROM SinhVien SV JOIN Lop L ON SV.MaLop = L.MaLop JOIN Khoa K ON L.MaKhoa = K.MaKhoa
	WHERE K.TenKhoa = N'Công nghệ thông tin' AND L.MaKhoaHoc = 'K2002'
END
GO
EXEC usp_exercise41

-- 4/2: Cho biết các sinh viên (MSSV, họ tên ,năm sinh) của các sinh viên học sớm hơn tuổi qui định (theo tuổi qui định thi sinh viên đủ 18 tuổi khi bắt đầu khóa học)
IF OBJECT_ID('usp_exercise42', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise42
GO 
CREATE PROC usp_exercise42
AS
BEGIN
	SELECT SV.MaSV, SV.HoTen, SV.NamSinh
	FROM SinhVien SV JOIN Lop L ON SV.MaLop = L.MaLop JOIN KhoaHoc KH ON L.MaKhoaHoc = KH.MaKhoaHoc
	WHERE (KH.NamBatDau - SV.NamSinh) < 18
END
GO
EXEC usp_exercise42

-- 4/3: Cho biết sinh viên khoa CNTT, khoá 2002-2006 chưa học môn cấu trúc dữ liệu 1
IF OBJECT_ID('usp_exercise43', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise43
GO 
CREATE PROC usp_exercise43
AS
BEGIN
	SELECT SV.*
	FROM SinhVien SV JOIN Lop L ON SV.MaLop = L.MaLop JOIN KetQua KQ ON SV.MaSV = KQ.MaSV
	WHERE L.MaKhoa = 'CNTT' AND L.maKhoaHoc = 'K2002'
							AND NOT EXISTS (SELECT A.*
											FROM SinhVien A JOIN KetQua B ON A.MaSV = B.MaSV JOIN MonHoc C ON B.MaMH = C.MaMH
											WHERE C.TenMH = N'Cấu trúc dữ liệu 1' AND SV.MaSV = A.MaSV)
END
GO
EXEC usp_exercise43

-- 4/4: Cho biết sinh viên thi không đậu (Diem <5) môn cấu trúc dữ liệu 1 nhưng chưa thi lại.
IF OBJECT_ID('usp_exercise44', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise44
GO 
CREATE PROC usp_exercise44
AS
BEGIN
	SELECT SV.*
	FROM SinhVien SV JOIN KetQua KQ ON SV.MaSV = KQ.MaSV JOIN MonHoc MH ON KQ.MaMH = MH.MaMH
	WHERE MH.TenMH = N'Cấu trúc dữ liệu 1' AND KQ.DiemThi < 5
										   AND NOT EXISTS (SELECT SV1.*
													       FROM SinhVien SV1 JOIN KetQua KQ1 ON SV1.MaSV = KQ1.MaSV
														   WHERE KQ1.MaMH = KQ.MaMH AND KQ1.lanThi > 1 AND SV.MaSV = SV1.MaSV)
END
GO
EXEC usp_exercise44

-- 4/5: Với mỗi lớp thuộc khoa CNTT, cho biết mã lớp, mã khóa học, tên chương trình và số sinh viên thuộc lớp đó
IF OBJECT_ID('usp_exercise45', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise45
GO 
CREATE PROC usp_exercise45
AS
BEGIN
	SELECT L.MaLop, L.MaKhoaHoc, CTH.TenCT, (SELECT COUNT(A.MaSV)
										     FROM SinhVien A JOIN Lop B ON A.MaLop = B.MaLop
										     WHERE L.MaLop = B.MaLop) SoSV
	FROM LOP L JOIN ChuongTrinhHoc CTH ON L.MaCT = CTH.MaCT
	WHERE L.MaKhoa = 'CNTT'
END
GO
EXEC usp_exercise45

-- 4/6: Cho biết điểm trung bình của sinh viên có mã số 0212003 (điểm trung bình chỉ tính trên lần thi sau cùng của sinh viên)
IF OBJECT_ID('usp_exercise46', 'p') IS NOT NULL
	DROP PROC dbo.usp_exercise46
GO 
CREATE PROC usp_exercise46
AS
BEGIN
	SELECT  KQ.MaSV, AVG(KQ.DiemThi) AS DTB
	FROM    KetQua KQ
	WHERE   KQ.MaSV = '0212003'
			AND KQ.LanThi = ( SELECT MAX(KQ2.LanThi)
							  FROM KetQua KQ2
							  WHERE KQ2.MaMH = KQ.MaMH AND KQ2.MaSV = KQ.MaSV )
	GROUP BY KQ.MaSV
END
GO
EXEC usp_exercise46