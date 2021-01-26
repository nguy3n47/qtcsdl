-- QTCSDL - BTTL Tuan 09
-- Trigger
USE QUANLYDETAI
GO

-- Câu 1. Trưởng bộ môn phải là người thuộc bộ môn, nếu vi phạm báo lỗi và huỷ thao tác
-- Bảng tầm ảnh hưởng		T				X			S
-- BoMon					+(TruongBM)		-			+(MaBM, TruongBM)
-- GiangVien				-				-			+(MaGV, MaBM)
create trigger tg_ThemBM
on BOMON
for insert, update
as
begin
	-- Lay danh sach BOMON vua them (MaBM, TruongBM, MaBMTruongBM)
	-- Neu ton tai MaBM <> MaBMTruongBM bao loi, rollback
	if exists( select i.MABM, TRUONGBM, gv.MABM from inserted i join GIANGVIEN gv on i.TRUONGBM = gv.MAGV where i.TRUONGBM != gv.MABM)
	begin
		raiserror ('TrongBM phai la nguoi thuoc BOMON', 15, 1)
		rollback
		return
	end
end
go

create trigger tg_ThemBM_GV
on GIANGVIEN
for update
as
begin
	if exists( select gv.MAGV, gv.MABM from BOMON bm join GIANGVIEN gv on bm.TRUONGBM = gv.MAGV, (select MABM from inserted group by MABM) i
	where bm.TRUONGBM = gv.MAGV and i.MABM = gv.MABM
	group by gv.MAGV, gv.MABM)
	begin
		raiserror ('TrongBM phai la nguoi thuoc BOMON', 15, 1)
		rollback
		return
	end
end
go

-- Câu 2. Trưởng khoa phải là người thuộc khoa , nếu vi phạm, báo lỗi và huỷ thao tác
-- Bảng tầm ảnh hưởng		T					X			S
-- Khoa						+(TruongKhoa)		-			+(TruongKhoa)	
-- GiangVien				-					-			+(MaGV)



-- Câu 3. Mỗi giáo viên chỉ lưu giữ tối đa 3 số điện thoại
-- Bảng tầm ảnh hưởng		T		X		S
-- GV_DT					+		-		+(MaGV)




-- Câu 4. Mỗi giao viên chỉ tham gia tối đa 2 đề tài
-- Bảng tầm ảnh hưởng		T		X		S
-- ThamGiaDT				+		-		+




-- Câu 5. Ngày bắt đầu công việc của đề tài phải từ sau ngày bắt đầu đề tài trở đi
-- Câu 6. Mỗi đề tài chỉ phân rã tối đa 8 công việc