USE [master]
GO
/****** Object:  Database [QLSinhVien]    Script Date: 12/15/2020 12:05:11 AM ******/
CREATE DATABASE [QLSinhVien]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLSinhVien', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QLSinhVien.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QLSinhVien_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QLSinhVien_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [QLSinhVien] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLSinhVien].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLSinhVien] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLSinhVien] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLSinhVien] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLSinhVien] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLSinhVien] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLSinhVien] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QLSinhVien] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLSinhVien] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLSinhVien] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLSinhVien] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLSinhVien] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLSinhVien] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLSinhVien] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLSinhVien] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLSinhVien] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QLSinhVien] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLSinhVien] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLSinhVien] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLSinhVien] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLSinhVien] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLSinhVien] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLSinhVien] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLSinhVien] SET RECOVERY FULL 
GO
ALTER DATABASE [QLSinhVien] SET  MULTI_USER 
GO
ALTER DATABASE [QLSinhVien] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLSinhVien] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLSinhVien] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLSinhVien] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QLSinhVien] SET DELAYED_DURABILITY = DISABLED  
GO
EXEC sys.sp_db_vardecimal_storage_format N'QLSinhVien', N'ON'
GO
USE [QLSinhVien]
GO
/****** Object:  UserDefinedFunction [dbo].[uf_GetAmountSV]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[uf_GetAmountSV]()
Returns INT
AS
	BEGIN 
	DECLARE @TongSV INT
	SELECT @TongSV = COUNT(*)
	FROM SINHVIEN
	Return @TongSV
	END
GO
/****** Object:  UserDefinedFunction [dbo].[uf_GetAveragePoint]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[uf_GetAveragePoint](@MaSV VARCHAR(15))
Returns FLOAT
AS
	BEGIN
	DECLARE @DTB FLOAT
	SELECT @DTB = SUM(DIEMTB.DIEM) / SUM(DIEMTB.SoTC) 
	FROM (SELECT SoTC, Diem*SoTC AS 'DIEM'
		  FROM DKHP
		  WHERE MaSV = @MaSV) AS DIEMTB
	RETURN @DTB
	END
GO
/****** Object:  UserDefinedFunction [dbo].[uf_SumOfTC]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[uf_SumOfTC](@MaSV nchar(10), @NamHoc char(5), @HocKi char(1))
Returns int
as
	begin 
		Declare @TongSoTC int
		set @TongSoTC = (select SUM(SoTC) from DKHP where NH = @NamHoc and HK = @HocKi and MaSV = @MaSV)
		return @TongSoTC
	end
GO
/****** Object:  UserDefinedFunction [dbo].[uf_TongSoChi]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[uf_TongSoChi](@NamHoc char(5), @HocKi char(1), @MaSV nchar(15))
returns int
as
begin
	return (select SUM(SoTC)
			from DKHP
			where NH = @NamHoc and HK = @HocKi and MaSV = @MaSV)
end
GO
/****** Object:  Table [dbo].[DKHP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DKHP](
	[NH] [char](5) NOT NULL,
	[HK] [char](1) NOT NULL,
	[MaSV] [varchar](15) NOT NULL,
	[MAMH] [varchar](15) NOT NULL,
	[SoTC] [int] NULL,
	[DiaDiem] [char](5) NULL,
	[Diem] [numeric](5, 1) NULL,
 CONSTRAINT [PK_DKHP] PRIMARY KEY CLUSTERED 
(
	[NH] ASC,
	[HK] ASC,
	[MaSV] ASC,
	[MAMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOP](
	[MaLop] [varchar](15) NOT NULL,
	[Khoa] [int] NULL,
	[Loai] [nvarchar](10) NULL,
	[LopTruong] [varchar](15) NULL,
 CONSTRAINT [PK_LOP] PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MaSV] [varchar](15) NOT NULL,
	[HoTen] [nvarchar](30) NULL,
	[NgaySinh] [datetime] NULL,
	[Phai] [nvarchar](10) NULL,
	[Lop] [varchar](15) NULL,
	[DTB] [numeric](5, 1) NULL,
 CONSTRAINT [PK_SINHVIEN] PRIMARY KEY CLUSTERED 
(
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'18120120', N'CSC10001 ', 4, N'NVC  ', CAST(8.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'18120120', N'MTH00086 ', 5, N'NVC  ', CAST(9.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'18120460', N'BAA00012 ', 3, N'LT   ', CAST(7.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'18120460', N'CSC00004 ', 4, N'NVC  ', CAST(8.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'18120460', N'MTH00041 ', 3, N'NVC  ', CAST(10.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110033', N'BAA00004', 3, N'LT   ', CAST(5.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110033', N'CSC00003', 4, N'NVC  ', CAST(9.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110066', N'BAA00004', 3, N'LT   ', CAST(7.5 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110066', N'MTH00030', 4, N'NVC  ', CAST(9.5 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110088', N'BAA00004', 3, N'LT   ', CAST(6.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110088', N'BAA00101', 3, N'NVC  ', CAST(7.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110088', N'CSC00003', 4, N'NVC  ', CAST(10.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110088', N'KTLT', 5, N'TPHCM', CAST(0.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'1', N'19110088', N'MTH00083 ', 2, N'NVC  ', CAST(9.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'19-20', N'2', N'18120120', N'BAA00012 ', 5, N'LT   ', CAST(10.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'20-21', N'1', N'19110066       ', N'BAA00004       ', 5, N'NVC  ', CAST(9.0 AS Numeric(5, 1)))
INSERT [dbo].[DKHP] ([NH], [HK], [MaSV], [MAMH], [SoTC], [DiaDiem], [Diem]) VALUES (N'20-21', N'2', N'18120120       ', N'BAA00012       ', 5, N'NVC  ', CAST(10.0 AS Numeric(5, 1)))
GO
INSERT [dbo].[LOP] ([MaLop], [Khoa], [Loai], [LopTruong]) VALUES (N'18CNTT1', 2018, N'CQ', N'18120460')
INSERT [dbo].[LOP] ([MaLop], [Khoa], [Loai], [LopTruong]) VALUES (N'19TTH1', 2019, N'CQ', N'19110033')
INSERT [dbo].[LOP] ([MaLop], [Khoa], [Loai], [LopTruong]) VALUES (N'19TTH2', 2019, N'TN', N'19110088')
GO
INSERT [dbo].[SINHVIEN] ([MaSV], [HoTen], [NgaySinh], [Phai], [Lop], [DTB]) VALUES (N'18120120', N'Phạm Hữu Hào', CAST(N'2000-08-06T00:00:00.000' AS DateTime), N'Nam', N'18CNTT1', CAST(9.0 AS Numeric(5, 1)))
INSERT [dbo].[SINHVIEN] ([MaSV], [HoTen], [NgaySinh], [Phai], [Lop], [DTB]) VALUES (N'18120460', N'Nguyễn Ngọc Lan', CAST(N'2000-02-14T00:00:00.000' AS DateTime), N'Nu', N'18CNTT1', CAST(0.0 AS Numeric(5, 1)))
INSERT [dbo].[SINHVIEN] ([MaSV], [HoTen], [NgaySinh], [Phai], [Lop], [DTB]) VALUES (N'19110033', N'Nguyễn Văn Thành', CAST(N'2001-12-22T00:00:00.000' AS DateTime), N'Nam', N'19TTH1', CAST(0.0 AS Numeric(5, 1)))
INSERT [dbo].[SINHVIEN] ([MaSV], [HoTen], [NgaySinh], [Phai], [Lop], [DTB]) VALUES (N'19110066', N'Đào Thị Hân', CAST(N'2001-04-15T00:00:00.000' AS DateTime), N'Nu', N'19TTH1', CAST(0.0 AS Numeric(5, 1)))
INSERT [dbo].[SINHVIEN] ([MaSV], [HoTen], [NgaySinh], [Phai], [Lop], [DTB]) VALUES (N'19110088', N'Vũ Đức Hải ', CAST(N'2001-05-03T00:00:00.000' AS DateTime), N'Nam', N'19TTH2', CAST(0.0 AS Numeric(5, 1)))
GO
ALTER TABLE [dbo].[DKHP]  WITH CHECK ADD  CONSTRAINT [FK_DKHP_SINHVIEN] FOREIGN KEY([MaSV])
REFERENCES [dbo].[SINHVIEN] ([MaSV])
GO
ALTER TABLE [dbo].[DKHP] CHECK CONSTRAINT [FK_DKHP_SINHVIEN]
GO
ALTER TABLE [dbo].[LOP]  WITH CHECK ADD  CONSTRAINT [FK_LOP_SINHVIEN] FOREIGN KEY([LopTruong])
REFERENCES [dbo].[SINHVIEN] ([MaSV])
GO
ALTER TABLE [dbo].[LOP] CHECK CONSTRAINT [FK_LOP_SINHVIEN]
GO
ALTER TABLE [dbo].[SINHVIEN]  WITH CHECK ADD  CONSTRAINT [FK_SINHVIEN_LOP] FOREIGN KEY([Lop])
REFERENCES [dbo].[LOP] ([MaLop])
GO
ALTER TABLE [dbo].[SINHVIEN] CHECK CONSTRAINT [FK_SINHVIEN_LOP]
GO
/****** Object:  StoredProcedure [dbo].[GetInfoLeader]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetInfoLeader]
AS
	BEGIN
		SELECT * FROM SinhVien sv INNER JOIN LOP l ON sv.MaSV = l.LopTruong
	END
GO
/****** Object:  StoredProcedure [dbo].[GetListClass]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListClass]
AS
	BEGIN
		SELECT MaLop,Khoa,Loai FROM LOP 
	END
GO
/****** Object:  StoredProcedure [dbo].[GetListStudentWithClass]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListStudentWithClass]
@MaLop VARCHAR(15)
AS
	BEGIN
		SELECT * FROM SINHVIEN WHERE Lop = @MaLop
	END
GO
/****** Object:  StoredProcedure [dbo].[GetResultDKHP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetResultDKHP]
@MaSV VARCHAR(15)
as
	begin
	select *
	from DKHP
	where  MaSV = @MaSV
	end
GO
/****** Object:  StoredProcedure [dbo].[usp_Delete_Class]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_Delete_Class]
@MaLop varchar(15)
as
begin
	Delete from LOP where MaLop = @MaLop
end
GO
/****** Object:  StoredProcedure [dbo].[usp_Delete_DKHP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Delete_DKHP]
@NH char(5),
@HK char(1),
@MaSV varchar(15),
@MaMH varchar(15),
@DiaDiem char(5)
as
begin
	delete from DKHP where NH = @NH and HK = @HK and MaSV = @MaSV and MAMH = @MaMH and DiaDiem = @DiaDiem
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetResultOfStudent]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_GetResultOfStudent]
@namhoc char(5),
@hocki char(1),
@masv nchar(10)
as 
	begin 
		select distinct dkhp.NH, dkhp.HK, dkhp.MAMH, sv.Lop, sv.MaSV, sv.HoTen, dkhp.Diem
		from DKHP dkhp join SINHVIEN sv on dkhp.MaSV = sv.MaSV
		where dkhp.NH = @namhoc and dkhp.HK = @hocki and sv.MaSV = @masv
	end
GO
/****** Object:  StoredProcedure [dbo].[usp_Insert_Class]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_Insert_Class]
@MaLop varchar(15),
@Khoa int,
@Loai nvarchar(10), 
@LopTruong varchar(15)
as
begin 
	insert into LOP values(@MaLop, @Khoa, @Loai, @LopTruong)
end
GO
/****** Object:  StoredProcedure [dbo].[usp_Insert_DKHP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_Insert_DKHP]
@NH char(5),
@HK char(1),
@MaSV varchar(15),
@MaMH varchar(15),
@SoTC int,
@DiaDiem char(5),
@Diem numeric(5, 1)
as
begin
	insert into DKHP values(@NH, @HK, @MaSV, @MaMH, @SoTC, @DiaDiem, @Diem)
end
GO
/****** Object:  StoredProcedure [dbo].[usp_KetQuaHocTap]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_KetQuaHocTap] 
@NamHoc char(5),
@HocKi char(1),
@MaSV nchar(15),
@MaMH nchar(10) output,
@Lop varchar(15) output,
@Hoten nvarchar(30) output,
@Diem float output
as
begin
	select @MaMH = MAMH, @Lop = sv.Lop, @Hoten = sv.HoTen, @Diem = dkhp.Diem
	from DKHP dkhp join SINHVIEN sv on dkhp.MaSV = sv.MaSV
	where dkhp.MaSV = @MaSV and dkhp.NH = @NamHoc and dkhp.HK = @HocKi 
end
GO
/****** Object:  StoredProcedure [dbo].[usp_RegisterDKHP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_RegisterDKHP]
@namhoc char(5),
@hocki char(1),
@masv char(15),
@mamh char(15),
@sotc int,
@diadiem char(5),
@diem numeric(5, 1)
as
	begin
		insert into DKHP values(@namhoc, @hocki, @masv, @mamh, @sotc, @diadiem, @diem)
	end
GO
/****** Object:  StoredProcedure [dbo].[usp_SuaSV]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_SuaSV]
@MaSV varchar(15),
@Hoten nvarchar(30),
@NgaySinh Datetime,
@Phai nvarchar(10),
@Lop varchar(15),
@DTB numeric(5, 1)
as 
begin
	UPDATE SINHVIEN SET MaSV = @MaSV, HoTen = @Hoten, NgaySinh = @NgaySinh, Phai = @Phai, Lop = @Lop, DTB = @DTB
	WHERE MaSV = @MaSV
end
GO
/****** Object:  StoredProcedure [dbo].[usp_ThemSV]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_ThemSV]
@MaSV varchar(15),
@Hoten nvarchar(30),
@NgaySinh Datetime,
@Phai nvarchar(10),
@Lop varchar(15),
@DTB numeric(5, 1)
as 
begin
	INSERT INTO SINHVIEN values(@MaSV, @Hoten, @NgaySinh, @Phai, @Lop, @DTB)
end
GO
/****** Object:  StoredProcedure [dbo].[usp_Update_Class]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_Update_Class]
@MaLop varchar(15),
@Khoa int,
@Loai nvarchar(10), 
@LopTruong varchar(15)
as
begin
	UPDATE LOP SET MaLop = @MaLop, Khoa = @Khoa, Loai = @Loai, LopTruong = @LopTruong
	where MaLop = @MaLop
end
GO
/****** Object:  StoredProcedure [dbo].[usp_Update_DKHP]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Update_DKHP] 
@NH char(5),
@HK char(1),
@MaSV varchar(15),
@MaMH varchar(15),
@SoTC int,
@DiaDiem char(5),
@Diem numeric(5, 1)
as
begin
	update DKHP set    SoTC = @SoTC, DiaDiem = @DiaDiem, Diem = @Diem
	where  MaSV = @MaSV and NH = @NH and HK = @HK and MAMH = @MaMH
end
GO
/****** Object:  StoredProcedure [dbo].[usp_XoaSV]    Script Date: 12/15/2020 12:05:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_XoaSV]
@MaSV varchar(15)
as 
begin
	DELETE FROM SINHVIEN WHERE MaSV = @MaSV
end
GO
USE [master]
GO
ALTER DATABASE [QLSinhVien] SET  READ_WRITE 
GO
