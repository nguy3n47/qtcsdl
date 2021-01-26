-- QTCSDL - BTTL Tuan 08 - 18600187
-- Trigger
USE QUANLYDETAI
GO

--Số lượng đề tài tham gia = tổng số các đề tài đã phân công cho giảng viên đó (không quan tâm hoàn thành hay chưa)
--Số đề tài đã nghiệm thu = số lượng đề tài giảng viên đã tham gia và đã hoàn thành (đã đạt)
--Số đề tài chưa nghiệm thu = số đề tài giảng viên đã tham gia mà chưa hoàn thành (chưa đạt)
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
			@slcnt != ((select count(*) from THAMGIADT tg where tg.MAGV = @magv) - (select count(*) from THAMGIADT tg where tg.MAGV = @magv and tg.KETQUA = N'ÐẠT'))
		begin
			Raiserror('Error', 15, 1)
			rollback transaction
		end
		
	end
go
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

go
--Kiểm tra số lượng giảng viên luôn bằng tổng số giảng viên thực sự làm việc tại bộ môn đó.
--TAH			T	X	S
--GiangVien		+	+	+(mabm)
--BoMon			+	-	+(Siso)
--c1
create trigger tg_SoLuongGVc1
on GiangVien
after insert, update, delete
as
	begin
		declare cur cursor for select mabm from inserted
		open cur
		declare @mabm varchar(50)
		fetch next from cur into @mabm
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
				update BOMON
				set BOMON.SLGV = (select COUNT(*) from GiangVien gv where gv.MABM = @mabm)
				where BOMON.MABM = @mabm

			  fetch next from cur into @mabm 
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 
	end
go
create trigger tg_SoLuongGVBM
on Bomon
after update
as
	begin
		declare cur cursor for select mabm from inserted
		open cur
		declare @mabm varchar(50)
		fetch next from cur into @mabm
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
				update BOMON
				set BOMON.SLGV = (select COUNT(*) from GiangVien gv where gv.MABM = @mabm)
				where BOMON.MABM = @mabm

			  fetch next from cur into @mabm 
		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor 
	end
go


--c2
create trigger tg_SoLuongGV
on GiangVien
after insert, update, delete
as
	begin
		update BOMON
		set BOMON.SLGV = (select COUNT(*) from GiangVien gv where gv.MABM = i.MABM)
		from (select distinct mabm from Inserted) i
		where BOMON.MABM = i.MABM


		update BOMON
		set BOMON.SLGV = (select COUNT(*) from GiangVien gv where gv.MABM = d.MABM)
		from (select distinct mabm from deleted) d
		where BOMON.MABM = d.MABM
	end


insert into GiangVien(MAGV, HOTEN, PHAI, MABM) values('014', 'h', 'Nam', 'HTTT'),('015', 'h', 'Nam', 'VS')
go
create trigger tg_SoLuongGVBM
on Bomon
after update
as
	begin
		update BOMON
		set BOMON.SLGV = (select COUNT(*) from GiangVien gv where gv.MABM = i.MABM)
		from (select distinct mabm from inserted) i
		where BOMON.MABM = i.MABM
	end
go