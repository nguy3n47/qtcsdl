-- QTCSDL - BTTL Tuan 07 - 18600187
-- Stored
USE QUANLYDETAI
GO

--Số lượng đề tài tham gia = tổng số các đề tài đã phân công cho giảng viên đó (không quan tâm hoàn thành hay chưa)
--Số đề tài đã nghiệm thu = số lượng đề tài giảng viên đã tham gia và đã hoàn thành (đã đạt)
--Số đề tài chưa nghiệm thu = số đề tài giảng viên đã tham gia mà chưa hoàn thành (chưa đạt)
-- bảng tầm ảnh hưởng a
--                 t      x     s
-- Giangvien       +(sl)  -     +(sl)
-- Thamgiadetai    +      +     +(MAGV, MADT)



-- bảng tầm ảnh hưởng b và c
--                 t      x     s
-- Giangvien       +(sl)  -     +(sl)
-- Thamgiadetai    +      +     +(MAGV, MADT, KETQUA)
create trigger tg_SoLuongDeTaiGV
on GIANGVIEN
for insert, update
as
	begin
		Declare @sldt int, @sldnt int, @slcnt int
		Declare @magv varchar(3)
		select @magv = MAGV from inserted

		select @sldt = DeTaiThamGia from inserted
		select @sldnt = DeTaiDaNghiemThu from inserted
		select @slcnt = DeTaiChuaNghiemThu from inserted

		select @sldt = count(*) from THAMGIADT tg where tg.MAGV = @magv
		select @sldnt = count(*) from THAMGIADT tg where tg.MAGV = @magv and tg.KETQUA = N'ÐẠT'
		select @slcnt = @sldt - @sldnt

		if @sldt != (select count(*) from THAMGIADT tg where tg.MAGV = @magv) or
			@sldnt != (select count(*) from THAMGIADT tg where tg.MAGV = @magv and tg.KETQUA = N'ÐẠT') or
			@slcnt != ((select count() from THAMGIADT tg where tg.MAGV = @magv) - (select count() from THAMGIADT tg where tg.MAGV = @magv and tg.KETQUA = N'ÐẠT'))
			Raiserror('Error', 15, 1)
			rollback transaction
	end

create trigger tg_SoLuongDeTai
on THAMGIADT
after insert, update, delete
as
	begin
		update GIANGVIEN
		set DeTaiThamGia = (select count(*) from THAMGIADT tg where tg.MAGV = GIANGVIEN.MAGV),
			DeTaiDaNghiemThu = (select count(*) from THAMGIADT tg where tg.MAGV = GIANGVIEN.MAGV and tg.KETQUA = N'ÐẠT'),
			DeTaiChuaNghiemThu = DeTaiThamGia - DeTaiDaNghiemThu
		from Inserted i, deleted d
		where GIANGVIEN.MAGV = i.MAGV or GIANGVIEN.MAGV = d.MAGV
	end


--Kiểm tra số lượng giảng viên luôn bằng tổng số giảng viên thực sự làm việc tại bộ môn đó.
-- bảng tầm ảnh hưởng
--                 t      x     s
-- Giangvien       +      -     +(mabm)
-- BOMON		   +(sl)  -     +(mabm)
create trigger tg_SoLuongGV
on GIANGVIEN
after insert, update, delete
as
	begin
		update bm
		set bm.SoLuongGV = (select COUNT(*) from GIANGVIEN gv where gv.MABM = bm.MABM)
		from BOMON bm, Inserted i, Deleted d
		where bm.MABM = i.MABM or bm.MABM = d.MABM
	end