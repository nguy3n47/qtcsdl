-- BTVN08 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

USE Quan_Ly_Sinh_Vien
GO

-- Câu 1: Mỗi học kỳ chỉ mở tối đa 5 môn, nếu vi phạm, báo lỗi, huỷ.
-- Bảng tầm ảnh hưởng		T		X		S
-- GiangKhoa				+		-		+(NamHoc, HocKy)

-- Cách 1: Dùng cursor
create trigger Cau1_Cach1 on GiangKhoa
for insert, update
as
	begin
			declare cur cursor for select MaCT ,MaKhoa, NamHoc, HocKy from inserted
			open cur
			declare @mact varchar(20), @maKhoa varchar(50), @namhoc int, @hocky int
			fetch next from cur into @maKhoa, @namhoc, @hocky
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					if (select COUNT(*) from GiangKhoa gk 
						where gk.MaKhoa = @maKhoa and gk.NamHoc = @namhoc and gk.HocKy = @hocky and gk.MaCT = @mact) > 5
					begin
						raiserror('Mỗi học kỳ chỉ mở tối đa 5 môn',15,1)
						rollback
					end

					fetch next from cur into @mact , @maKhoa, @namhoc , @hocky 
			END 

			CLOSE cur  
			DEALLOCATE cur 
	end
go

-- Cách 2: Dùng truy vấn SQL
create trigger Cau1_Cach2 on GiangKhoa
for insert, update
as
	begin
			if exists (select  gk.MaCT, gk.MaKhoa, gk.NamHoc, gk.HocKy
			from GiangKhoa gk join inserted i on i.MaKhoa = gk.MaKhoa and i.NamHoc = gk.NamHoc and i.HocKy = gk.HocKy and i.MaCT = gk.MaCT
			group by gk.MaCT, gk.MaKhoa, gk.NamHoc, gk.HocKy
			having COUNT(*) > 5)
			begin
				raiserror('Mỗi học kỳ chỉ mở tối đa 5 môn',15,1)
				rollback
			end
	end
go

-- Câu 2: Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ. Nếu vi phạm, báo lỗi, huỷ
-- Bảng tầm ảnh hưởng		T		X		S
-- SinhVien					+		-		+(MaLop)
-- Lop						-		-		+(MaKhoa, MaCT)
-- GiangKhoa				+		-		+(MaKhoa, MaCT, NamHoc, HocKy)

-- Cách 1: Dùng cursor
-- Bảng SinhVien
create trigger Cau2_Cach1_SV on SinhVien
for insert, update
as
begin
			declare cur cursor for select l.MaKhoa, l.MaCT 
									from inserted i join Lop l on l.MaLop = i.MaLop
									group by l.MaKhoa, l.MaCT
			open cur
			declare @maKhoa varchar(5), @mact varchar(5)
			fetch next from cur into @maKhoa, @mact
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					if exists (select gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					from GiangKhoa gk
					where gk.MaKhoa = @maKhoa and gk.MaCT = @mact
					group by gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					having COUNT(*) > 4)
					begin
							raiserror('Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ',15,1)
							rollback
					end

					fetch next from cur into  @maKhoa, @mact
			END 
			CLOSE cur  
			DEALLOCATE cur 
		
end
go
-- Bảng Lop
create trigger Cau2_Cach1_Lop on Lop
for update
as
begin
			declare cur cursor for select MaKhoa, MaCT from inserted group by MaKhoa, MaCT
			open cur
			declare @maKhoa varchar(5), @mact varchar(5)
			fetch next from cur into @maKhoa, @mact
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					if exists (select gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					from GiangKhoa gk
					where gk.MaKhoa = @maKhoa and gk.MaCT = @mact
					group by gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					having COUNT(*) > 4)
					begin
							raiserror('Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ',15,1)
							rollback
					end

					fetch next from cur into  @maKhoa, @mact
			END 

			CLOSE cur  
			DEALLOCATE cur 
		
end
go
-- Bảng GiangKhoa
create trigger Cau2_Cach1_GiangKhoa on GiangKhoa
for insert, update
as
begin
			declare cur cursor for select MaKhoa, MaCT, NamHoc, HocKy from inserted group by MaKhoa, MaCT, NamHoc, HocKy
			open cur
			declare @maKhoa varchar(50), @mact varchar(5), @namhoc int, @hocky int
			fetch next from cur into @maKhoa, @mact, @namhoc, @hocky
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					if exists (select gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					from GiangKhoa gk
					where gk.MaKhoa = @maKhoa and gk.MaCT = @mact and gk.NamHoc = @namhoc and gk.HocKy = @hocky
					group by gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					having COUNT(*) > 4)
					begin
							raiserror('Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ',15,1)
							rollback
					end
				fetch next from cur into @maKhoa, @mact, @namhoc, @hocky
			END 

			CLOSE cur  
			DEALLOCATE cur 
		
end
go

-- Cách 2: Dùng truy vấn SQL
-- Bảng SinhVien
create trigger Cau2_Cach2_SV on SinhVien
for insert, update
as
begin
		
		if exists (select gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					from GiangKhoa gk, (select l.MaKhoa, l.MaCT from inserted i join Lop l on l.MaLop = i.MaLop
										group by l.MaKhoa, l.MaCT) temp
					where gk.MaKhoa = temp.MaKhoa and gk.MaCT = temp.MaCT
					group by gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					having COUNT(*) > 4)
		begin
				raiserror('Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ',15,1)
				rollback
		end
end
go
-- Bảng Lop
create trigger Cau2_Cach2_Lop on Lop
for update
as
begin
		
		if exists (select gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					from GiangKhoa gk, (select MaKhoa, MaCT from inserted group by MaKhoa, MaCT) temp
					where gk.MaKhoa = temp.MaKhoa and gk.MaCT = temp.MaCT
					group by gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					having COUNT(*) > 4)
		begin
				raiserror('Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ',15,1)
				rollback
		end
end
go
-- Bảng GiangKhoa
create trigger Cau2_Cach2_GiangKhoa on GiangKhoa
for insert, update
as
begin
		if exists (select gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					from GiangKhoa gk, (select MaKhoa, MaCT, NamHoc, HocKy from inserted group by MaKhoa, MaCT, NamHoc, HocKy) temp
					where gk.MaKhoa = temp.MaKhoa and gk.MaCT = temp.MaCT and gk.NamHoc = temp.NamHoc and gk.HocKy = temp.HocKy
					group by gk.MaKhoa, gk.MaCT, gk.NamHoc, gk.HocKy
					having COUNT(*) > 4)
		begin
				raiserror('Mỗi sinh viên chỉ được học tối đa 4 môn trong 1 học kỳ',15,1)
				rollback
		end
end
go

-- Câu 3: Mỗi năm, khoa CNTT chỉ tuyển sinh 4 khoá. Nếu vi phạm, báo lỗi, huỷ
-- Bảng tầm ảnh hưởng		T		X		S
-- KhoaHoc					-		-		+(NamBatDau)
-- Lop						+		-		+(MaKhoa, MaKhoaHoc)

-- Cách 1: Dùng cursor
-- Bảng KhoaHoc
create trigger Cau3_Cach1_KhoaHoc on KhoaHoc
for update
as
	begin
			declare cur cursor for select NamBatDau from inserted  group by NamBatDau
			open cur
			declare @nambatdau int
			fetch next from cur into @nambatdau
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					if exists (select kh.NamBatDau
					from KhoaHoc kh join Lop l on l.MaKhoaHoc = kh.MaKhoaHoc
					where l.MaKhoa = 'CNTT' and kh.NamBatDau = @nambatdau
					group by kh.NamBatDau
					having COUNT(*) > 4)
					begin
							raiserror('Khoa CNTT chỉ tuyển sinh 4 khoá',15,1)
							rollback
					end

					fetch next from cur into @nambatdau
			END 

			CLOSE cur  
			DEALLOCATE cur 
	end
go

-- Bảng Lop
create trigger Cau3_Cach1_Lop on Lop
for insert,update
as
	begin
			declare cur cursor for select kh.NamBatDau
									from KhoaHoc kh , (select MaKhoaHoc
									                   from inserted
									                   where MaKhoa = 'CNTT'
									                   group by MaKhoaHoc) i
									where kh.MaKhoaHoc = i.MaKhoaHoc
									group by kh.NamBatDau
			open cur
			open cur
			declare @nambatdau int
			fetch next from cur into @nambatdau
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					if exists(select kh.NamBatDau
					from KhoaHoc kh join Lop l on l.MaKhoaHoc = kh.MaKhoaHoc
					where l.MaKhoa = 'CNTT' and kh.NamBatDau = @nambatdau
					group by kh.NamBatDau
					having COUNT(*) > 4)
					begin
							raiserror('Khoa CNTT chỉ tuyển sinh 4 khoá',15,1)
							rollback
					end

					fetch next from cur into @nambatdau
			END 

			CLOSE cur  
			DEALLOCATE cur 
	end
go

-- Cách 2: Dùng truy vấn SQL
-- Bảng KhoaHoc
create trigger Cau3_Cach2_KhoaHoc on KhoaHoc
for update
as
	begin
			if exists (select kh.NamBatDau
			from KhoaHoc kh join Lop l on l.MaKhoaHoc = kh.MaKhoaHoc , (select NamBatDau from inserted group by NamBatDau) i
			where l.MaKhoa = 'CNTT' and i.NamBatDau = kh.NamBatDau
			group by kh.NamBatDau
			having COUNT(*) > 4)
			begin
					raiserror('Khoa CNTT chỉ tuyển sinh 4 khoá',15,1)
					rollback
			end
	end
go

-- Bảng Lop
create trigger Cau3_Cach2_Lop on Lop
for insert,update
as
	begin
			if exists(select kh.NamBatDau
			from KhoaHoc kh join Lop l on l.MaKhoaHoc = kh.MaKhoaHoc, (select kh.NamBatDau
																	   from KhoaHoc kh , (select MaKhoaHoc
																		                   from inserted
																		                   where MaKhoa = 'CNTT'
																		                   group by MaKhoaHoc) i
																	   where kh.MaKhoaHoc = i.MaKhoaHoc
																	   group by kh.NamBatDau) temp
			where l.MaKhoa = 'CNTT' and temp.NamBatDau = kh.NamBatDau
			group by kh.NamBatDau
			having COUNT(*) > 4)
			begin
					raiserror('Khoa CNTT chỉ tuyển sinh 4 khoá',15,1)
					rollback
			end
	end
go