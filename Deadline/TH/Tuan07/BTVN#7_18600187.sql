-- BTVN07 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE Quan_Ly_Sinh_Vien
GO

-- 7.12. Sinh viên chỉ được thi tối đa 2 lần cho một môn học
alter table KetQua
add constraint Check_Lan_Thi check(LanThi <= 2)
go
-- Bảng tầm ảnh hưởng
--				T	X	S
--KetQua		+	-	+(MAMH,LANTHI)

create trigger c7_12_insert on KetQua
for insert,update
as
begin
		declare @lanthi int, @thutu int
		select @thutu = Lanthi
		from inserted
		select @lanthi = count(kq.LanThi)
		from inserted i join KetQua kq on i.MaSV = kq.MaSV and i.MaMH = kq.MaMH
		if @thutu != @lanthi
		begin
			raiserror('So lan thi them vao hoac update khong hop le',15,1)
			rollback
			return
		end
		if @lanthi > 2
		begin
			raiserror('So lan thi da la 2 lan',15,1)
			rollback
			return
		end
		else
			print('Cap Nhat thanh cong')
end
go
-- 7.13 Liên thuộc tính trên nhiều quan hệ
-- 7.14 Năm bắt đầu khóa học của một lớp không thể nhỏ hơn năm thành lập của khoa quản lý lớp đó
-- Bảng tầm ảnh hưởng
--				T	X	S
--KhoaHoc		+	-	+(NamBatDau)
--Lop			+	-	+(MaKhoa, MaKhoaHoc)
--Khoa			-	-	+(NamThanhLap)
create trigger Cau714_Lop
on Lop
for insert, update
as
begin
if(exists(
		select * from inserted join KhoaHoc kh on inserted.MaKhoaHoc = kh.MaKhoaHoc
							   join Khoa k on inserted.MaKhoa = k.MaKhoa
		where kh.NamBatDau < k.NamThanhLap))
		rollback
end
go

create trigger Cau714_KhoaHoc
on KhoaHoc
for insert, update
as
begin
if(exists(
		select * from inserted join Lop l on inserted.MaKhoaHoc = l.MaKhoaHoc
							   join Khoa k on l.MaKhoa = k.MaKhoa
		where inserted.NamBatDau < k.NamThanhLap))
		rollback
end
go

create trigger Cau714_Khoa
on Khoa
for insert, update
as
begin
if(exists(
		select * from inserted join Lop l on inserted.MaKhoa = l.MaKhoa
							   join KhoaHoc kh on l.MaKhoaHoc = kh.MaKhoaHoc
		where kh.NamBatDau < inserted.NamThanhLap))
		rollback
end
go

-- 7.15. Sinh viên chỉ có thể dự thi các môn học có trong chương trình và thuộc về khoa mà sinh viên đó đang theo học
-- Hàm lấy tất cả môn học theo chương trình mà sinh viên đang theo học
-- Bảng tầm ảnh hưởng
--				T	X	S
--KetQua		+	-	+
IF OBJECT_ID('KF_List_MH_By_CT','fn') IS NOT NULL
	DROP FUNCTION KF_List_MH_By_CT
go
create function KF_List_MH_By_CT(@masv varchar(10))
returns table
return
	select distinct gk.MaMH from GiangKhoa gk 
	join Khoa k on gk.MaKhoa = k.MaKhoa
	join Lop l on l.MaKhoa = k.MaKhoa
	join SinhVien sv on sv.MaLop = l.MaLop
	join KhoaHoc kh on kh.MaKhoaHoc = l.MaKhoaHoc
	join MonHoc mh on mh.MaMH = gk.MaMH
	join ChuongTrinhHoc ct on ct.MaCT = gk.MaCT
	where sv.MaSV = @masv
	and gk.NamHoc >= kh.NamBatDau
	and gk.NamHoc <= kh.NamKetThuc
go
select * from dbo.KF_List_MH_By_CT('0212001')
go
--Dùng trugger
create trigger Cau715_KetQua
on KetQua
for insert, update
as
begin
	if(exists(
		select * from KetQua kq where kq.MaMH not in
		(
			select * from dbo.KF_List_MH_By_CT(kq.MaSV)
		)
	))
	rollback
end
go

--Dùng truy vấn
-- 7.16. Hãy bổ sung vào quan hệ LOP thuộc tính SISO và kiểm tra sĩ số của một lớp phải bằng số lượng sinh viên đang theo học lớp đó
-- Bảng tầm ảnh hưởng
--				T		X	S
--Lop			+(SS)	-	+(MaLop, SS)
--SinhVien		+		+	+(MaLop)
alter table Lop add SiSo int
go

--Lop
create trigger Cau716_insertLop on Lop
for insert
as
begin
		declare @ss int
		select @ss = SiSo from inserted
		if @ss is not NULL and @ss != 0
		begin
			raiserror('SiSo lop moi phai = 0 hoac NULL',15,1)
			rollback
			return
		end
		else
		begin
			print('Them thanh cong')
		end
end
go

create trigger Cau716_updateLop on Lop
for update
as
begin
		declare @ss int
		select @ss = SiSo from inserted
		

		if @ss != (select COUNT(*)
					from SinhVien sv join inserted i on i.MaLop = sv.MaLop)
		begin
			update Lop set SiSo = (select COUNT(*)
									from SinhVien sv join inserted i on i.MaLop = sv.MaLop) 
					where MaLop = (select MaLop from inserted)
			raiserror('SiSo update khong hop le!!!',15,1)
			rollback
			return
		end
		else
		begin
			print('Cap nhat thanh cong')
		end
end
go

--SinhVien
create trigger Cau716_I_SV on SinhVien
for insert
as
begin
		declare @malop varchar(20)
		select @malop = MaLop from inserted

		update Lop set SiSo = (select COUNT(*)
									from SinhVien sv where sv.MaLop = @malop) 
					where MaLop = @malop
end
go

create trigger Cau716_D_SV on SinhVien
for delete
as
begin
		declare @malop varchar(20)
		select @malop = MaLop from deleted

		update Lop set SiSo = (select COUNT(*)
									from SinhVien sv where sv.MaLop = @malop) 
					where MaLop = @malop
end
go

create trigger Cau716_U_SV on SinhVien
for update
as
begin
		declare @malopOld varchar(20), @malopNew varchar(20)
		select @malopOld = MaLop from deleted
		select @malopNew = MaLop from inserted

		-- update sỉ số của lớp mới
		update Lop set SiSo = (select COUNT(*)
									from SinhVien sv where sv.MaLop = @malopNew) 
					where MaLop = @malopNew

		-- update sỉ số của lớp cũ
		update Lop set SiSo = (select COUNT(*)
									from SinhVien sv where sv.MaLop = @malopOld) 
					where MaLop = @malopOld
end
go