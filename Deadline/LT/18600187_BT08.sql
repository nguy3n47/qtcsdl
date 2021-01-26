/*Hệ thống quản lí sinh viên gồm:
SinhVien (MaSV, HoTen, NamSinh, GioiTinh, DiemTB,
MaLop)
GiaoVien (MaGV, HoTen, NgaySinh, LoaiGV)
MonHoc (MaMH, TenMH, SoChi)
KetQua (MaSV, MaMH, LanThi, Diem)
Lop (MaLop, NamBD, NamKT, SiSo)
GV_Lop (MaLop, MaMH, MaGV)*/

-- 1. Tạo login cho GV01, GV02, GV03, SV01, SV02, SV03.
exec sp_addlogin 'GV01'
exec sp_addlogin 'GV02'
exec sp_addlogin 'GV03'
exec sp_addlogin 'SV01'
exec sp_addlogin 'SV02'
exec sp_addlogin 'SV03'
go


--2. Sinh viên chỉ được được cấp quyền xem, cập nhật thông tin
--cá nhân của mình (tạo view).
create view uv_SV01
as
select *
from SinhVien
where MaSV = 'SV01'
go

create view uv_SV02
as
select *
from SinhVien
where MaSV = 'SV02'
go

create view uv_SV03
as
select *
from SinhVien
where MaSV = 'SV03'
go

--3. Tạo 2 nhóm vai trò GiaoVien, QuanLi.
exec sp_addrole GiaoVien
exec sp_addrole QuanLi

--4. GV01 thuộc nhóm quản lí, GV02, GV03 thuộc nhóm giáo viên.
exec sp_adduser GV01, GV01
exec sp_adduser GV02, GV02
exec sp_adduser GV03, GV03

exec sp_addrolemember [QuanLi], 'GV01'
exec sp_addrolemember [GiaoVien], 'GV02'
exec sp_addrolemember [GiaoVien], 'GV03'

--5. Giáo viên được xem thông tin tất cả môn học.
grant select
on MonHoc
to GiaoVien

--6. Giáo viên được thêm một kết quả và cập nhật điểm của
--	môn học do mình phụ trách.
grant insert
on KetQua
to GiaoVien

grant update
on KetQua(Diem)
to GiaoVien

--7. Quản lí được xem, cập nhật, thêm thông tin môn học, sinh
--viên và được phép cấp các quyền cho user
grant select, insert, update
on MonHoc
to QuaLi
with grant option

grant select, insert, update
on SinhVien
to QuaLi
with grant option

--8. Tất cả các sinh viên đều được phép xem thông tin các môn
--	học hiện có ở trường.

exec sp_adduser SV01, SV01
exec sp_adduser SV02, SV02
exec sp_adduser SV03, SV03

grant select
on MonHoc
to SV01

grant select
on MonHoc
to SV02

grant select
on MonHoc
to SV03

--9. Giáo viên GV03 không còn giản dạy ở trường. Hãy hủy các
--	quyền đã cấp cho GV03.
revoke select
on MonHoc
from GV03

revoke insert
on KetQua
from GV03

revoke update
on KetQua(Diem)
from GV03

-- 10. Cấm quyền truy cập thông tin của SV03.
Deny select 
on MonHoc
to SV03

-- 11. Thêm GV01 vào nhóm sysadmin.
exec sp_addsrvrolemember GV01, 'sysadmin'

/*12. Có thể cập nhật lại mật khẩu của login GV03 thành
	‘111111’ được không? Ai được phép thực hiện?

	có thể cập nhật mật khẩu cho GV03
	người thực hiện là GV01 hoặc những login có quyền tương đương(sysadmin) 
*/
EXEC sp_password 'hhhh', '111111' ,[GV03]
--Ai được phép thực hiện? -> Những người được cấp quyền (grant login)


-- 13. Cấp toàn quyền thao tác trên CSDL cho GV01.
exec sp_addsrvrolemember GV01, 'Dbcreatetor'

-- 14. Cấp quyền thực thi các thủ tục usp_TinhDiem cho GV02.
grant execute to GV02