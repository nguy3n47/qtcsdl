-- MSSV: 18600187
-- Họ và tên: VŨ CAO NGUYÊN
-- Lớp: 18CK1
-- Đề: 1

use QLBaoChi
go
select * from CT_DONHANG
select * from CT_DONNHAP
select * from CT_PHIEUGIAO
select * from BAO
select * from DON_HANG
select * from THE_LOAI
select * from KHACH_HANG
select * from DON_NHAP
select * from DAI_LY
select * from LOAI_NGUOI_DUNG
select * from PHIEU_GIAO_BAO
go
-- ALTER TABLE ten_bang
   --ADD ten_cot dinh_nghia_cot;
-- Câu 1: Thêm một thuộc tính tổng tiền vào bảng hoá đơn. Viết stored procedure thực hiện cập nhật tổng tiền cho toàn bộ hoá đơn.
ALTER TABLE CT_DONHANG
ADD TongTien float
IF OBJECT_ID('Cau1','p') IS NOT NULL
	DROP PROC Cau1
GO
create proc Cau1
as
begin
	declare cur cursor for select SoLuong, DonGia from CT_DONHANG
	open cur
		declare @soluong int, @dongia float
		fetch next from cur into @soluong, @dongia
		while @@FETCH_STATUS = 0
		begin
			update CT_DONHANG
			set TongTien = @soluong * @dongia
			WHERE CURRENT OF cur 
			fetch next from cur into @soluong, @dongia
		end
	close cur
	deallocate cur
	declare @HoaDon table(TongTienToanBoHoaDon float)
	insert into @HoaDon
	select sum((SoLuong*DonGia)) from CT_DONHANG
	select * from CT_DONHANG
	select * from @HoaDon
end
go
exec Cau1
go

-- Câu 2: Viết stored thưc hiện thêm mới một sản phẩm vào chi tiết hoá đơn
-- input: mã hoá đơn, mã sản phẩm, số lượng mua, đơn giá bán.
-- xử lý:
-- Kiểm tra tính hợp lệ của dữ liệu đầu vào
-- Kiểm tra đơn giá bán = DonGiaGoc + 10%VAT
-- Thêm một dòng thông tin vào chi tiết hoá đơn
-- Cập nhật số lượng tồn sản phẩm = số lượng tồn hiện tại - số lượng mua
IF OBJECT_ID('Cau2','p') IS NOT NULL
	DROP PROC Cau2
GO
create proc Cau2
	@mahoadon varchar(10),
	@masanpham varchar(10),
	@soluongmua int,
	@dongiaban float
as
begin
	IF NOT EXISTS (SELECT MaBao FROM BAO WHERE MaBao = @masanpham)
	BEGIN
		RAISERROR('MA SAN PHAM KHÔNG TỒN TẠI', 15,1)
		RETURN
	END
	IF EXISTS (SELECT MaDH FROM CT_DONHANG WHERE MaDH = @mahoadon)
	BEGIN
		RAISERROR('MA DON HANG DA TỒN TẠI', 15,1)
		RETURN
	END
	select @dongiaban = DonGia*1.1 FROM BAO WHERE MaBao = @masanpham
	insert into CT_DONHANG(MaDH, MaBao, SoLuong, DonGia) values (@mahoadon,@masanpham,@soluongmua,@dongiaban)
	update BAO
	set SoLuong = SoLuong - @soluongmua
	where MaBao = @masanpham
end
go
exec Cau2 'DH007', 'B17', 7, 7000