-- MSSV: 18600187
-- Họ và tên: VŨ CAO NGUYÊN
-- Lớp: 18CK1
-- Cuoi Ky

use QLBaoChi
go
--select * from CT_DONHANG
--select * from CT_DONNHAP
--select * from DON_NHAP
--select * from CT_PHIEUGIAO
--select * from BAO
--select * from DON_HANG
--select * from THE_LOAI
--select * from KHACH_HANG
--select * from DAI_LY
--select * from LOAI_NGUOI_DUNG
--select * from PHIEU_GIAO_BAO
go

-- Cau 1: Thêm thuộc tính “tiền cọc”,”trị giá đơn nhập”, “Công nợ đơn nhập” vào bảng
-- DON_NHAP. Cài ràng buộc kiểm tra:
-- Trị giá đơn nhập = sum(số lượng*đơn giá nhập) của đơn nhập
-- Công nợ đơn nhập = trị giá đơn nhập – tiền cọc
ALTER TABLE DON_NHAP
ADD TiecCoc int

ALTER TABLE DON_NHAP
ADD TriGiaDonNhap int

ALTER TABLE DON_NHAP
ADD CongNoDonNhap int

-- Bảng tầm ảnh hưởng		T			X			S
-- DON_NHAP					+			-			+(MaDN, TiecCoc, TriGiaDonNhap, CongNoDonNhap)
-- CT_DONNHAP				+			+			+(SoLuong, DonGia)
go
create trigger Cau1_DON_NHAP on DON_NHAP
for insert, update
as
begin
	declare cur cursor for select MaDN, TriGiaDonNhap, CongNoDonNhap, TiecCoc from inserted
	open cur
	declare @madn varchar(15),@trigia int, @congno int , @tiencoc int
	fetch next from cur into @madn, @trigia ,@congno, @tiencoc
	while @@FETCH_STATUS = 0
	begin
		if @trigia != (select sum(SoLuong*DonGia) from CT_DONNHAP ctdn where ctdn.MaDN = @madn)
		begin
			Raiserror('Trị giá đơn nhập phải = sum(số lượng*đơn giá nhập) của đơn nhập!', 15, 1)
			rollback
			return
		end
		if @congno != ((select sum(SoLuong*DonGia) from CT_DONNHAP ctdn where ctdn.MaDN = @madn) - @tiencoc)
		begin
			Raiserror('Công nợ đơn nhập phải = trị giá đơn nhập – tiền cọc!', 15, 1)
			rollback
			return
		end
	fetch next from cur into @madn, @trigia,@congno, @tiencoc
	end
	close cur
	deallocate cur
end
go
update DON_NHAP
set TRIGIADONNHAP = case 
    when MaDN = 'DN01' then 10
    when MaDN = 'DN02' then 20
else''
end
where MaDN IN ('DN01','DN02')
go

-- Cau 2: Vẽ bảng tầm ảnh hưởng và cài đặt RBTV sau:
-- TienNoKhachHang[MaLoaiKH] <= TienNoToiDaLoai_Nguoi_Dung[MaLoaiKH]
-- (mỗi lần mua hàng, khách hàng được nợ thêm một số tiền, nhưng ứng với MaLoaiKH
-- mà khách hàng đó thuộc về thì tổng tiền nợ của khách hàng không được vượt quá
-- TienNoToiDa theo quy định.)
-- Vẽ bảng tầm ảnh hưởng
-- Cài đặt trigger đảm bảo RBTV trên
-- Tên trigger: utg_CapNhatNoKH

-- Cau 2
-- Bảng tầm ảnh hưởng		T			X			S
-- KHACHHANG				+			-			+(TienNo, MaLoaiKH)
-- LOAI_NGUOI_DUNG			-			-			+(TienNoToiDa)

create trigger utg_CapNhatNoKH on KHACH_HANG
for insert, update
as
BEGIN
	declare cur cursor for select MaLoaiKH  from inserted
	declare @MALOAIKH varchar(15)
	open cur
	fetch next from cur into @MALOAIKH
	while @@FETCH_STATUS=0
	begin
		if exists (select * from
		(select MaLoaiKH, TienNo
		from KHACH_HANG
		where MaLoaiKH = @MALOAIKH) as KHTemp
		join
		(select MaLoai, TienNoToiDa
		from LOAI_NGUOI_DUNG
		where MaLoai = @MALOAIKH) as LOAIKHTemp on KHTemp.MaLoaiKH = LOAIKHTemp.MaLoai and KHTemp.TienNo > LOAIKHTemp.TienNoToiDa
		)
		begin
			raiserror('TienNoKhachHang[MaLoaiKH] <= TienNoToiDaLoai_Nguoi_Dung[MaLoaiKH]',15,1)
			rollback
		end
		fetch next from cur into @MALOAIKH
	end	
	close cur
	deallocate cur
END
go
update KHACH_HANG
set TienNo = case 
    when TienNo = 50000.00 then 4000000.00
    when TienNo = 30000.00 then 8000000.00
else''
end
where MaKH IN ('KH01','KH04')
go