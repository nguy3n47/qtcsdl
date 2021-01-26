use QLSV
go
-- Bài 1
-- C1
create view uv_SinhVien
as
select sv.MaSV, sv.HoTen, mh.TenMonHoc, kq.Diem
from SinhVien sv , KetQua kq, MonHoc mh
where sv.MaSV = kq.MaSV and kq.MaMH = mh.MaMH
and kq.LanThi >= ALL(select MAX(kq1.LanThi)
						from KetQua kq1
						where kq1.MaMH = kq.MaMH
						group by kq1.LanThi)
go
select * from uv_SinhVien

-- C2
go
create view uv_c2
as
select kq.MaSV, kq.MaMH, kq.Diem
from KetQua kq
where kq.LanThi >= ALL(select MAX(kq1.LanThi)
						from KetQua kq1
						where kq1.MaMH = kq.MaMH
						group by kq1.LanThi)

go
update uv_c2 set Diem = 10 where MaSV = 'SV0002    ' and MaMH = 'MH0001    '


-- C3
go
create view uv_c1_3
as
select *
from SinhVien

go
create trigger trig_c1_3 on uv_c1_3
instead of delete
as
begin
		if not exists (select * from SinhVien sv, deleted i where i.MaSV = sv.MaSV)
		begin
				raiserror (N'Không tìm thấy sinh viên', 15, 1)
				rollback
				return
		end
		else
		begin	
				delete from SinhVien where MaSV = (select MaSV from deleted)
		end
end

select * from uv_c1_3
delete uv_c1_3 where MaSV = '0961233   '

-- Bài 2
-- C1
go
create view uv_c2_1
as
select sv.*, Year(GETDATE()) - sv.NamSinh N'Tuổi', (select count(distinct kq.MaMH)
													from KetQua kq
													where kq.MaSV = sv.MaSV) N'Số môn'
from SinhVien sv

go
select * from uv_c2_1


-- C2
go
create view uv_c2_2
as
select MaSV, MaLop, YEAR(getdate()) - NamSinh as tuoi
from SinhVien
go

create trigger trig_c2_2 on uv_c2_2
instead of update
as
begin
		if not exists (select * from SinhVien sv join inserted i on sv.MaSV = i.MaSV)
		begin
				raiserror (N'Không tìm thấy sinh viên', 15, 1)
				rollback
				return
		end
		else
		begin
				declare @masv varchar(20), @malop varchar(20), @tuoi int
				set @masv = (select MaSV from inserted)
				set @malop = (select malop from inserted)
				set @tuoi = (select tuoi from inserted)

				update SinhVien set MaLop = @malop where MaSV = @masv
				update SinhVien set NamSinh = YEAR(GETDATE()) - @tuoi where MaSV = @masv
		end
end

select * from uv_c2_2

update uv_c2_2 set tuoi = 20, MaLop = 'LH002     ' where MaSV = '0961236   '


-- C3
go
create view uv_c2_3
as
select *
from SinhVien
go
create trigger trig_c2_3 on uv_c2_3
instead of insert
as
begin
		if exists (select * from SinhVien sv join inserted i on sv.MaSV = i.MaSV)
		begin
				update SinhVien set HoTen = I.HoTen, MaLop = I.MaLop, DiemTB = I.DiemTB, NamSinh = i.NamSinh,
				NamBD = I.NamBD, NamKT = I.NamKT, TinhTrang = I.TinhTrang
				from SinhVien sv, inserted I where sv.MaSV = i.MaSV

				print 'ok'
		end
		else
		begin
				insert into SinhVien select Masv, HoTen,  DiemTB, MaLop , NamSinh, NamBD, NamKT, TinhTrang
				from inserted
		end
end

select * from uv_c2_3

insert into uv_c2_3 values('0961238   ', NULL, 9, NULL, NULL, NULL, NULL, NULL)




-- Bài 3
-- Tạo view cho biết thông tin của 3 sinh viên có điểm trung bình cao nhất của mỗi lớp. Xếp giảm theo điểm trung bình.
-- C1. Tạo view cho biết thông tin của 3 sinh viên có
--điểm trung bình cao nhất của mỗi lớp. Xếp giảm
--theo điểm trung bình.

Create view uv_SinhVienDiemTBCaoNhatMoiLop
As
Select *
From SinhVien as sv 
Where sv.DiemTB = (Select Max(sv2.DiemTB) As DiemTBCaoNhat
					From SinhVien as sv2
					Where sv2.MaLop = sv.MaLop
					group by sv2.MaLop)

Select * from uv_SinhVienDiemTBCaoNhatMoiLop
Go

-- C2. Viết trigger cập nhật cho phép tăng 0.5 trên điểm
--trung bình cho sinh viên có điểm trung bình > 9.0.

Create trigger trg_TangDiemChoSinhvien On uv_SinhVienDiemTBCaoNhatMoiLop
Instead of Update
As
Begin
	Update SinhVien
	Set DiemTB = i.DiemTB + 0.5	
	From SinhVien as sv, inserted as i
	Where sv.MaSV = i.MaSV And i.DiemTB > 9.0
End
GO

Update uv_SinhVienDiemTBCaoNhatMoiLop set DiemTB = 9.01 Where MaSV = '0212003'
Go

-- C3. Viết trigger cho phép thêm một sinh viên vào
--CSDL (DiemTB được tính).

Create trigger trg_ThemSinhVienCoDiemTBDuocTinh on uv_SinhVienDiemTBCaoNhatMoiLop
Instead of Insert
As
Begin
	If not exists(Select * From inserted as i Join SinhVien as sv On sv.MaSV = i.MaSV)
	Begin
		Insert into SinhVien
		Select MaSV, HoTen, 
			(Select SUM(kq.Diem) / Count(*)
			From KetQua as kq WHere LanThi = (Select Max(lanThi) from KetQua where MaSV = kq.masv and MaMH = kq.mamh)
			And kq.MaSV = i.MaSV) as DiemTB,
			MaLop, NamSinh, NamBD, NamKT, TinhTrang
		From  inserted as i
	End
	Else	
	Begin
		Raiserror(N'Đã tồn tại sinh viên',15,1)
		Rollback transaction
	End
End
Go

Insert into uv_SinhVienDiemTBCaoNhatMoiLop(MaSV)
Values('0212003')

-- Bài 4
-- C1
go
create view uv_c4_1
as
select l.MaLop, l.SiSo, (select count(*)
						from SinhVien sv
						where sv.MaLop = l.MaLop
						and (sv.TinhTrang <> N'Đã tốt nghiệp' 
						or sv.TinhTrang is NULL)) N'Số sinh viên còn nợ' , (select count(*)
																			from SinhVien sv
																			where sv.MaLop = l.MaLop
																			and sv.TinhTrang = N'Đã tốt nghiệp') N'Số sinh viên đậu' 
from LopHoc l


-- C2
go
create view uv_c4_2
as
select *
from LopHoc
go
create trigger trig_c4_2 on uv_c4_2
instead of insert
as
begin
		if exists (select * from LopHoc sv join inserted i on sv.MaLop = i.MaLop)
		begin
				update LopHoc set MaKhoa = i.MaKhoa, SiSo = i.SiSo
				from LopHoc l, inserted i where l.MaLop = i.MaLop
		end
		else
		begin
				insert into LopHoc select MaLop, MaKhoa, SiSo
				from inserted
		end
end


-- C3
go
create view uv_c4_3
as
select MaLop
from LopHoc
go

create trigger trig_c4_3 on uv_c4_3
instead of delete
as
begin
		if not exists (select * from LopHoc sv join deleted i on sv.MaLop = i.MaLop)
		begin
				raiserror (N'Không tìm thấy lớp', 15, 1)
				rollback
				return
		end
		else
		begin
				update SinhVien set MaLop = NULL from SinhVien sv, deleted d where sv.MaLop = d.MaLop
				delete LopHoc from LopHoc l, deleted d where l.MaLop = d.MaLop
		end
end


delete uv_c4_3 where MaLop = 'LH005'