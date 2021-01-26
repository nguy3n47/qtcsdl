-- BTVN#9-10 - TH QTCSDL T5 (7-9)
-- 18600187 - Vũ Cao Nguyên

use QLDETAI
go

--Trưởng bộ môn phải là người thuộc bộ môn, nếu vi phạm báo lỗi và huỷ thao tác
--Bảng tầm ảnh hưởng		T			X			S
-- GiaoVien					-			-			+(mabm)
-- Bomon					+(tbm)		-			+(mabm, tbm)

-- Dùng sql
create trigger Cau1_GV on GiaoVien
for update
as
begin
		if exists (select *
					from BOMON bm,inserted i 
					where bm.TRUONGBM = i.MAGV and bm.MABM != i.MABM)
		begin
				raiserror('Trưởng bộ môn phải là người thuộc bộ môn',15,1)
				rollback
		end
end


UPDATE GIAOVIEN
SET MABM = CASE 
    WHEN MAGV = '001' THEN 'CNTT'
    WHEN MAGV = '003' THEN 'HPT '
	WHEN MAGV = '004' THEN 'VS  '
ELSE ''
END
WHERE MAGV IN ('001','003','004')


-- bomon
go
create trigger Cau1_BoMon on Bomon
for insert, update
as
begin
		if exists (select *
					from GIAOVIEN gv,inserted i 
					where gv.MAGV = i.TRUONGBM and gv.MABM != i.MABM)
		begin
				raiserror('Trưởng bộ môn phải là người thuộc bộ môn',15,1)
				rollback
		end
end

insert into BOMON(MABM, TRUONGBM) 
values ('K', NULL),
		('KT', NULL),
		('KC', NULL)

UPDATE BOMON
SET TRUONGBM = CASE 
    WHEN MABM = 'CNTT' THEN '001'
    WHEN MABM = 'HPT ' THEN '007'
	WHEN MABM = 'VS  ' THEN '004'
ELSE ''
END
WHERE MABM IN ('CNTT','HPT ','VS  ')


-- Trưởng khoa phải là người thuộc khoa , nếu vi phạm, báo lỗi và huỷ thao tác
--Bảng tầm ảnh hưởng		T			X			S
-- GiaoVien					-			-			+(mabm)
-- Bomon					+(makhoa)	-			+(mabm, makhoa)
-- Khoa						+(trKhoa)	-			+(makhoa, trkhoa)


-- dùng sql
-- GiaoVien					-			-			+(mabm)
 go
 create trigger Cau2_GV on GiaoVien
 for update
 as
 begin
		if exists (select *
					from BOMON bm, (select k.MAKHOA, i.MABM from KHOA k join inserted i on i.MAGV = k.TRUONGKHOA) temp
					where bm.MABM = temp.MABM and bm.MAKHOA <> temp.MAKHOA)
		begin
				raiserror('Trưởng khoa phải là người thuộc khoa',15,1)
				rollback
		end
 end


 -- Bomon					-			-			+(mabm, makhoa)
 go
 create trigger Cau2_BoMon on BOMON
 for update
 as
 begin
		if exists (select *
					from KHOA k join GIAOVIEN gv on gv.MAGV = k.TRUONGKHOA, (select MABM, MAKHOA from inserted group by MABM, MAKHOA) temp
					where gv.MABM = temp.MABM and temp.MAKHOA <> k.MAKHOA)
		begin
				raiserror('Trưởng khoa phải là người thuộc khoa',15,1)
				rollback
		end
 end

 -- Khoa						+(trKhoa)	-			+(makhoa, trkhoa)
 go
create trigger Cau2_Khoa on Khoa
for insert, update
as
begin
	if exists (select *
				from BOMON bm, (select i.MAKHOA, gv.MABM from GIAOVIEN gv join inserted i on gv.MAGV = i.TRUONGKHOA) temp
				where bm.MABM = temp.MABM and bm.MAKHOA <> temp.MAKHOA)
	begin
			raiserror('Trưởng khoa phải là người thuộc khoa',15,1)
			rollback
	end
end



-- Mỗi giáo viên chỉ lưu giữ tối đa 3 số điện thoại
 --Bảng tầm ảnh hưởng		T				X			S
-- GV_DT					+				-			+(magv)
go
create trigger Cau3_GVDT on GV_DT
for insert,update
as
begin
		if exists (select *
					from GV_DT gvdt, inserted i
					where gvdt.MAGV = i.MAGV
					group by gvdt.MAGV
					having COUNT(*) > 3)
		begin
			raiserror('Mỗi giáo viên chỉ lưu giữ tối đa 3 số điện thoại',15,1)
			rollback
	end
end


 -- Mỗi giao viên chỉ tham gia tối đa 2 đề tài
 --Bảng tầm ảnh hưởng		T				X			S
-- Thamgia					+(magv, madt)	-			+(magv, madt)
go
create trigger Cau4_TGDT on THAMGIADT
for insert, update
as
begin
		if exists(select count(distinct tgdt.MADT)
					from THAMGIADT tgdt,(select MAGV from inserted group by magv) i
					where tgdt.MAGV = i.MAGV
					having count(distinct tgdt.MADT) > 2)
		begin
				raiserror('Mỗi giao viên chỉ tham gia tối đa 2 đề tài',15,1)
				rollback
		end

end


-- Ngày bắt đầu công việc của đề tài phải từ sau ngày bắt đầu đề tài trở đi
 --Bảng tầm ảnh hưởng		T			X			S
-- Detai					-			-			+(madt, ngaybd)
-- Congviec					+(ngaybd)	-			+(madt, ngaybd)

-- dùng sql
go
create trigger Cau5_DeTai on Detai
for update
as
begin
		if exists (select *
					from CONGVIEC cv, (select MADT, NGAYBD from inserted group by MADT, NGAYBD) temp
					where cv.MADT = temp.MADT and cv.NGAYBD > temp.NGAYBD)
		begin
				raiserror('Ngày bắt đầu công việc >= ngày bắt đầu đề',15,1)
				rollback
		end
end


-- Congviec					+(ngaybd)	-			+(madt, ngaybd)
go
create trigger Cau5_CV on CongViec
for insert, update
as
begin
		if exists (select *
					from DETAI dt, (select MADT, NGAYBD from inserted group by MADT, NGAYBD) temp
					where dt.MADT = temp.MADT and dt.NGAYBD > temp.NGAYBD)
		begin
				raiserror('Ngày bắt đầu công việc >= ngày bắt đầu đề',15,1)
				rollback
		end
end

UPDATE DETAI
SET NGAYBD = CASE 
    WHEN MADT = '001' THEN GETDATE()
    WHEN MADT = '002' THEN GETDATE()
	WHEN MADT = '001' THEN GETDATE()
ELSE ''
END
WHERE MADT IN ('001','002')




-- 6 Mỗi đề tài chỉ phân rã tối đa 8 công việc
 --Bảng tầm ảnh hưởng		T			X			S
-- Congviec					+			-			+(madt)


-- dùng sql
go
create trigger Cau6_CV on CongViec
for insert, update
as
begin
		if exists (select cv.MADT
		from CONGVIEC cv, (select madt from inserted group by MADT) temp
		where cv.MADT = temp.MADT
		group by cv.MADT
		having COUNT(*) > 8)
		begin
				raiserror('Mỗi đề tài chỉ phân rã tối đa 8 công việc',15,1)
				rollback
		end
end


insert into CONGVIEC (MADT, SOTT)
values ('001', 7),
		('001', 8),
		('001', 9),
		('002', 6),
		('002', 7),
		('002', 8)



-- c7 Trong 1 năm, mỗi khoa chỉ được thực hiện tối đa 4 đề tài do giới hạn ngân sách.
--Bảng tầm ảnh hưởng		T			X			S
-- Giaovien					-			-			+(mabm)
-- Bomon					-			-			+(mabm, makhoa)
-- khoa						-			-			+(makhoa)
-- detai					-			-			+(gvcndt)
-- congviec					+			-			+(madt, ngaybd)


select cv.MADT, YEAR(NGAYBD), t.MAKHOA
from CONGVIEC cv, (select dt.MADT, bm.MAKHOA -- đề tài thuộc khoa của nó
				from DETAI dt 
				join GIAOVIEN gv on gv.MAGV = dt.GVCNDT
				join BOMON bm on bm.MABM = gv.MABM) t
where cv.MADT = t.MADT
group by cv.MADT, YEAR(NGAYBD), t.MAKHOA



-- C8: Giảng viên chỉ được tham gia đề tài thuộc khoa của mình.
--Bảng tầm ảnh hưởng		T			X			S
-- Giaovien					-			-			+(mabm)
-- Bomon					-			-			+(mabm, makhoa)
-- khoa						-			-			+(makhoa)
-- detai					-			-			+(gvcndt)
-- thamgia					+			-			+(magv, madt)

go
create trigger Cau8_GV on GiaoVien
for update
as
begin
		if exists (select dt.MADT, bm.MAKHOA -- đề tài thuộc khoa của nó
					from DETAI dt 
					join GIAOVIEN gv on gv.MAGV = dt.GVCNDT
					join BOMON bm on bm.MABM = gv.MABM, (select tgdt.MADT,k.MAKHOA  -- các giaovien thêm vào thuộc ở khoa nào
														from  inserted i
														join BOMON bm on bm.MABM = i.MABM
														join KHOA k on bm.MAKHOA = k.MAKHOA
														join THAMGIADT tgdt on tgdt.MAGV = i.MAGV
														group by i.MAGV,tgdt.MADT,k.MAKHOA) temp
					where dt.MADT = temp.MADT and bm.MAKHOA <> temp.MAKHOA)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài thuộc khoa của mình',15,1)
				rollback
		end
end

-- Bomon					-			-			+(mabm, makhoa)
go
create trigger Cau8_BoMon on Bomon
for update
as
begin
		if exists (select dt.MADT, bm.MAKHOA -- đề tài thuộc khoa của nó
					from DETAI dt 
					join GIAOVIEN gv on gv.MAGV = dt.GVCNDT
					join BOMON bm on bm.MABM = gv.MABM, (select tgdt.MADT,k.MAKHOA  -- các giaovien thêm vào thuộc ở khoa nào
														from  inserted i
														join GIAOVIEN gv on gv.MABM = i.MABM
														join KHOA k on i.MAKHOA = k.MAKHOA
														join THAMGIADT tgdt on tgdt.MAGV = gv.MAGV
														group by gv.MAGV,tgdt.MADT,k.MAKHOA) temp
					where dt.MADT = temp.MADT and bm.MAKHOA <> temp.MAKHOA)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài thuộc khoa của mình',15,1)
				rollback
		end
end

-- khoa						-			-			+(makhoa)
go
create trigger Cau8_Khoa on Khoa
for update
as
begin
		if exists (select dt.MADT, bm.MAKHOA -- đề tài thuộc khoa của nó
					from DETAI dt 
					join GIAOVIEN gv on gv.MAGV = dt.GVCNDT
					join BOMON bm on bm.MABM = gv.MABM, (select tgdt.MADT,i.MAKHOA  -- các giaovien thêm vào thuộc ở khoa nào
														from  inserted i
														join BOMON bm on bm.MAKHOA = i.MAKHOA
														join GIAOVIEN gv on gv.MABM = bm.MABM
														join THAMGIADT tgdt on tgdt.MAGV = gv.MAGV
														group by gv.MAGV,tgdt.MADT,i.MAKHOA) temp
					where dt.MADT = temp.MADT and bm.MAKHOA <> temp.MAKHOA)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài thuộc khoa của mình',15,1)
				rollback
		end
end

-- detai					-			-			+(gvcndt)
go
create trigger Cau8_DeTai on DeTai
for update
as
begin
		if exists (select dt.MADT, bm.MAKHOA -- đề tài thuộc khoa của nó
					from DETAI dt 
					join GIAOVIEN gv on gv.MAGV = dt.GVCNDT
					join BOMON bm on bm.MABM = gv.MABM, (select tg.MADT, temp.MAKHOA
														from THAMGIADT tg, (select tgdt.MAGV, bm.MAKHOA
																			from inserted d
																			join THAMGIADT tgdt on tgdt.MADT = d.MADT
																			join GIAOVIEN gv on tgdt.MAGV = gv.MAGV
																			join BOMON bm on gv.MABM = bm.MABM
																			join KHOA k on k.MAKHOA = bm.MAKHOA
																			group by tgdt.MADT,tgdt.MAGV, bm.MAKHOA) temp
														where tg.MAGV = temp.MAGV
														group by tg.MAGV, tg.MADT, temp.MAKHOA) temp1
					where dt.MADT = temp1.MADT and bm.MAKHOA <> temp1.MAKHOA)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài thuộc khoa của mình',15,1)
				rollback
		end
end

-- test
UPDATE DETAI
SET GVCNDT = CASE 
    WHEN MADT = '001' THEN '003'
    WHEN MADT = '008' THEN '002'
ELSE ''
END
WHERE MADT IN ('001','008')

-- backup
UPDATE DETAI
SET GVCNDT = CASE 
    WHEN MADT = '001' THEN '002'
    WHEN MADT = '008' THEN '012'
ELSE ''
END
WHERE MADT IN ('001','008')



-- thamgia					+			-			+(magv, madt)
go
create trigger Cau8_TGDT on ThamGiaDT
for insert,update
as
begin
		if exists (select temp.MADT,bm.MAKHOA
					from GIAOVIEN gv 
					join BOMON bm on bm.MABM = gv.MABM,(select i.MADT, dt.GVCNDT
																		from inserted i
																		join DETAI dt on i.MADT = dt.MADT
																		group by i.MADT, dt.GVCNDT) temp
					where gv.MAGV = temp.GVCNDT
					except
					select i.MADT,bm.MAKHOA  -- các giaovien thêm vào thuộc ở khoa nào
					from  inserted i
					join GIAOVIEN gv on gv.MAGV = i.MAGV
					join BOMON bm on gv.MABM = bm.MABM
					group by gv.MAGV,i.MADT,bm.MAKHOA)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài thuộc khoa của mình',15,1)
				rollback
		end
end



-- test
insert THAMGIADT(MAGV, MADT, STT)
values ('013','002',1),
		('009','001',1)


delete THAMGIADT where MAGV ='009' and MADT ='001' and STT = 1
delete THAMGIADT where MAGV ='009' and MADT ='003' and STT = 1

-- Giảng viên chỉ được tham gia đề tài do giảng viên bộ môn mình chủ nhiệm (không tham gia đề tài của bộ môn khác)
--Bảng tầm ảnh hưởng		T			X			S
-- Giaovien					-			-			+(magv, mabm)
-- detai					-			-			+(gvcndt)
-- thamgia					+			-			+(magv, madt)

go
create trigger Cau9_GV on GiaoVien
for update
as
begin
		if exists (select dt.MADT, gv.MABM, temp.* -- đề tài thuộc khoa của nó
					from DETAI dt 
					join GIAOVIEN gv on gv.MAGV = dt.GVCNDT, (select tgdt.MADT ,i.MABM
															from inserted i
															join THAMGIADT tgdt on tgdt.MAGV = i.MAGV
															group by i.MAGV,tgdt.MADT ,i.MABM) temp
					where temp.MADT = dt.MADT and temp.MABM <> gv.MABM)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài do giảng viên bộ môn mình chủ nhiệm',15,1)
				rollback
		end
end

-- test
UPDATE GIAOVIEN
SET MABM = CASE 
    WHEN MAGV = '001' THEN 'KTTT'
    WHEN MAGV = '013' THEN 'MMT'
ELSE ''
END
WHERE MAGV IN ('001','013')

-- backup
UPDATE GIAOVIEN
SET MABM = CASE 
    WHEN MAGV = '001' THEN 'MMT'
    WHEN MAGV = '013' THEN 'KTTT'
ELSE ''
END
WHERE MAGV IN ('001','013')


-- detai
go
create trigger Cau9_DeTai on DeTai
for update
as
begin
		select dt.MADT, gv.MABM -- đề tài thuộc khoa của nó
		from DETAI dt 
		join GIAOVIEN gv on gv.MAGV = dt.GVCNDT,(select tg.MADT, temp.MABM
												from THAMGIADT tg, (select tgdt.MAGV, gv.MABM
																from inserted d
																join THAMGIADT tgdt on tgdt.MADT = d.MADT
																join GIAOVIEN gv on tgdt.MAGV = gv.MAGV
																group by tgdt.MAGV, tgdt.MADT, gv.MABM) temp
											where tg.MAGV = temp.MAGV
											group by tg.MADT, temp.MABM) temp
		where temp.MADT = dt.MADT and temp.MABM <> gv.MABM
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài do giảng viên bộ môn mình chủ nhiệm',15,1)
				rollback
		end
end


-- test
UPDATE DETAI
SET GVCNDT = CASE 
    WHEN MADT = '001' THEN '003'
    WHEN MADT = '008' THEN '002'
ELSE ''
END
WHERE MADT IN ('001','008')

-- backup
UPDATE DETAI
SET GVCNDT = CASE 
    WHEN MADT = '001' THEN '002'
    WHEN MADT = '008' THEN '003'
ELSE ''
END
WHERE MADT IN ('001','008')


-- thamgia					+			-			+(magv, madt)
go
create trigger Cau9_TGDT on ThamGiaDT
for insert,update
as
begin
		if exists (select dt.MADT, gv.MABM
					from inserted i
					join DETAI dt on i.MADT = dt.MADT
					join GIAOVIEN gv on dt.GVCNDT = gv.MAGV
					except
					select i.MADT,gv.MABM -- các giaovien thêm vào thuộc ở khoa nào
					from  inserted i
					join GIAOVIEN gv on gv.MAGV = i.MAGV
					group by i.MADT,gv.MABM)
		begin
				raiserror('Giảng viên chỉ được tham gia đề tài do giảng viên bộ môn mình chủ nhiệm',15,1)
				rollback
		end

end

insert THAMGIADT(MAGV, MADT, STT)
values ('013','002',1),
		('009','001',1)


delete THAMGIADT where MAGV ='009' and MADT ='001' and STT = 1
delete THAMGIADT where MAGV ='013' and MADT ='002' and STT = 1