USE [master]
GO
/****** Object:  Database [QLSV_Backup_Restore]    Script Date: 11/24/2020 8:57:17 PM ******/
CREATE DATABASE [QLSV_Backup_Restore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLSV_Backup_Restore', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QLSV_Backup_Restore.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QLSV_Backup_Restore_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\QLSV_Backup_Restore_log.ldf' , SIZE = 816KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QLSV_Backup_Restore] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLSV_Backup_Restore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLSV_Backup_Restore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET RECOVERY FULL 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET  MULTI_USER 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLSV_Backup_Restore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QLSV_Backup_Restore] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'QLSV_Backup_Restore', N'ON'
GO
USE [QLSV_Backup_Restore]
GO
/****** Object:  Table [dbo].[GiaoVien]    Script Date: 11/24/2020 8:57:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GiaoVien](
	[MaGV] [varchar](15) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[NgaySinh] [datetime] NULL,
	[LoaiGV] [nvarchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GV_Lop]    Script Date: 11/24/2020 8:57:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GV_Lop](
	[MaLop] [varchar](10) NOT NULL,
	[MaMH] [varchar](10) NOT NULL,
	[MaGV] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC,
	[MaMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KetQua]    Script Date: 11/24/2020 8:57:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KetQua](
	[MaSV] [varchar](15) NOT NULL,
	[MaMH] [varchar](10) NOT NULL,
	[LanThi] [int] NOT NULL,
	[Diem] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSV] ASC,
	[MaMH] ASC,
	[LanThi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lop]    Script Date: 11/24/2020 8:57:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lop](
	[MaLop] [varchar](10) NOT NULL,
	[NamBD] [datetime] NULL,
	[NamKT] [datetime] NULL,
	[SiSo] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MonHoc]    Script Date: 11/24/2020 8:57:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MonHoc](
	[MaMH] [varchar](10) NOT NULL,
	[TenMH] [nvarchar](50) NULL,
	[SoChi] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SinhVien]    Script Date: 11/24/2020 8:57:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SinhVien](
	[MaSV] [varchar](15) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[NamSinh] [datetime] NULL,
	[GioiTinh] [nvarchar](10) NULL,
	[DiemTB] [float] NULL,
	[MaLop] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV001', N'Đinh Bá Tiến', NULL, N'GV, TS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV002', N'Đỗ Nguyên Kha', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV003', N'Hồ Tuấn Thanh', NULL, N'GV, ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV004', N'Lâm Quang Vũ', NULL, N'GV, TS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV005', N'Mai Anh Tuấn', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV006', N'Ngô Chánh Đức', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV007', N'Nguyễn Đức Huy', NULL, N'TG')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV008', N'Nguyễn Lê Hoàng Dũng', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV009', N'Phạm Nguyễn Sơn Tùng', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV010', N'Trần Duy Quang', NULL, N'GV, ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV011', N'Trần Minh Triết', NULL, N'PGS, TS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV012', N'Trương Toàn Thịnh', NULL, N'GV, TS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV013', N'Hồ Thị Hoàng Vy', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV014', N'Lê Nguyễn Hoài Nam', NULL, N'GV, TS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV015', N'Nguyễn Thị Như Anh', NULL, N'GV, ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV016', N'Tiết Gia Hồng', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV017', N'Huỳnh Thụy Bảo Trân', NULL, N'GVC, ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV018', N'Lê Quốc Hòa', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV019', N'Lê Viết Long', NULL, N'ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV020', N'Cao Xuân Nam', NULL, N'GV, ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV021', N'Văn Chí Nam', NULL, N'GV, ThS')
INSERT [dbo].[GiaoVien] ([MaGV], [HoTen], [NgaySinh], [LoaiGV]) VALUES (N'GV022', N'Võ Hoàng Quân', NULL, N'GV, ThS')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT003', N'GV012')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT006', N'GV009')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT008', N'GV008')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT101', N'GV020')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT102', N'GV016')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT103', N'GV019')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT104', N'GV019')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT105', N'GV017')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT501', N'GV010')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT702', N'GV015')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT703', N'GV002')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT705', N'GV010')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT721', N'GV014')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT727', N'GV022')
INSERT [dbo].[GV_Lop] ([MaLop], [MaMH], [MaGV]) VALUES (N'18CK1', N'CT730', N'GV003')
INSERT [dbo].[Lop] ([MaLop], [NamBD], [NamKT], [SiSo]) VALUES (N'18CK1', CAST(N'2018-08-25 00:00:00.000' AS DateTime), CAST(N'2021-10-25 00:00:00.000' AS DateTime), 65)
INSERT [dbo].[Lop] ([MaLop], [NamBD], [NamKT], [SiSo]) VALUES (N'18CK2', CAST(N'2018-08-25 00:00:00.000' AS DateTime), CAST(N'2021-10-25 00:00:00.000' AS DateTime), 0)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CH001', N'Những nguyên lý cơ bản của chủ nghĩa Mác – Lênin', 5)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CH002', N'Đường lối cách mạng của ĐCSVN', 3)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT002', N'Tin học cơ sở', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT003', N'Nhập môn lập trình', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT006', N'Phương pháp lập trình hướng đối tượng', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT008', N'Kỹ thuật lập trình', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT101', N'Cấu trúc dữ liệu và Giải thuật', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT102', N'Cơ sở dữ liệu', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT103', N'Hệ điều hành', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT104', N'Kiến trúc máy tính và hợp ngữ', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT105', N'Mạng máy tính', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT501', N'Lập trình Windows', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT702', N'Quản trị cơ sở dữ liệu', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT703', N'Lập trình Web1', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT705', N'Lập trình ứng dụng quản lý 1', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT721', N'Phát triển ứng dụng cơ sở dữ liệu 1', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT727', N'Các thuật toán thông minh nhân tạo và ứng dụng', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'CT730', N'Công cụ kiểm chứng phần mềm', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'DT001', N'Điện tử căn bản', 3)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'PL001', N'Pháp luật đại cương', 3)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'TT003', N'Đại số B1', 3)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'TT026', N'Giải Tích B1', 3)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'TT027', N'Giải tích B2', 3)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'TT063', N'Toán rời rạc', 4)
INSERT [dbo].[MonHoc] ([MaMH], [TenMH], [SoChi]) VALUES (N'VH023', N'Điện từ, Quang - Lượng tử - Nguyên tử', 4)
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600004', N'Huỳnh Ngọc Ninh Bình', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600005', N'Huỳnh Long Hải', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600010', N'Nguyễn Thành Nam', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600011', N'Nguyễn Trọng Quyết', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600014', N'Ngô Tất Tố', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600015', N'Phạm Minh Toàn', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600022', N'Trần Trung Anh', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600024', N'Đỗ Thái Bảo', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600026', N'Phạm Chí Bảo', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600031', N'Phạm Minh Châu', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600033', N'Lê Hoàng Chương', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600035', N'Võ Mộng Chuyền', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600036', N'Lê Tấn Cường', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600037', N'Nguyễn Mạnh Cường', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600038', N'Phạm Phong Phú Cường', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600043', N'Hoàng Dương Đạt', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600050', N'Nguyễn Ngọc Đức', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600053', N'Vũ Xuân Đức', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600054', N'Võ Thị Phương Dung', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600055', N'Nguyễn Quốc Dũng', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600057', N'Bùi Bảo Duy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600059', N'Đoàn Lê Hữu Duy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600060', N'Hoàng Phúc Duy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600061', N'Nguyễn Hoàng Duy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600063', N'Nguyễn Tấn Duy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600068', N'Võ Cao Thùy Duyên', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600071', N'Huỳnh Huỳnh Giao', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600082', N'Lưu Phước Hậu', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600085', N'Đỗ Tiến Hiệp', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600087', N'Nguyễn Minh Hiếu', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600090', N'Trương Đình Hiếu', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600091', N'Võ Thị Kim Hiếu', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600092', N'Nguyễn Đức Hoà', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600093', N'Khúc Khải Hoàn', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600097', N'Dương Tấn Huân', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600098', N'Tôn Đức Huân', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600106', N'Nguyễn Thị Hương', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600107', N'Nguyễn Xuân Hương', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600108', N'Lê Gia Huy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600109', N'Lê Quang Huy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600111', N'Lưu Minh Huy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600113', N'Thái Trần Anh Huy', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600120', N'Nguyễn Thị Minh Huyền', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600124', N'Nguyễn Duy Khang', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600127', N'Nguyễn Huỳnh Phương Khanh', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600128', N'Đoàn Quốc Khánh', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600132', N'Dương Nhật Khoa', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600133', N'Lê Tiến Khoa', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600137', N'Nguyễn An Khương', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600138', N'Đinh Trung Kiên', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600140', N'Cao Tuấn Kiệt', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600141', N'Giang Anh Kiệt', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600143', N'Đặng Thị Kim Kiều', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600152', N'Hà Nhựt Linh', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600155', N'Lê Tấn Lộc', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600158', N'Vũ Đại Lộc', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600161', N'Mai Văn Long', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600165', N'Nguyễn Xuân Lý', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600166', N'Nguyễn Thị Trúc Mai', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600169', N'Võ Công Minh', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600174', N'Nguyễn Duy Nam', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600181', N'Nguyễn Thị Thủy Ngân', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nữ', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600183', N'Nguyễn Hữu Nghĩa', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600187', N'Vũ Cao Nguyên', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
INSERT [dbo].[SinhVien] ([MaSV], [HoTen], [NamSinh], [GioiTinh], [DiemTB], [MaLop]) VALUES (N'18600190', N'Mai Thanh Nhân', CAST(N'2000-01-01 00:00:00.000' AS DateTime), N'Nam', NULL, N'18CK1')
ALTER TABLE [dbo].[GV_Lop]  WITH CHECK ADD FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop] ([MaLop])
GO
ALTER TABLE [dbo].[GV_Lop]  WITH CHECK ADD FOREIGN KEY([MaGV])
REFERENCES [dbo].[GiaoVien] ([MaGV])
GO
ALTER TABLE [dbo].[GV_Lop]  WITH CHECK ADD FOREIGN KEY([MaMH])
REFERENCES [dbo].[MonHoc] ([MaMH])
GO
ALTER TABLE [dbo].[KetQua]  WITH CHECK ADD FOREIGN KEY([MaSV])
REFERENCES [dbo].[SinhVien] ([MaSV])
GO
ALTER TABLE [dbo].[KetQua]  WITH CHECK ADD FOREIGN KEY([MaMH])
REFERENCES [dbo].[MonHoc] ([MaMH])
GO
ALTER TABLE [dbo].[SinhVien]  WITH CHECK ADD FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop] ([MaLop])
GO
USE [master]
GO
ALTER DATABASE [QLSV_Backup_Restore] SET  READ_WRITE 
GO
