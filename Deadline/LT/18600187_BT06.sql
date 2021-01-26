use QTCSDL_SV_TRIGGER
go
-- 1. Sinh viên chỉ được thi lại nếu điểm của lần thi sau cùng < 5 và số lần thi < 3.
Create trigger Cau1 on KetQua
for update
As
Begin
     if exists (select *from KetQua kq,SinhVien sv
	 where kq.MaSV=sv.MaSV and
	 (kq.Diem<5 and kq.LanThi<3))
	 Begin
	   Raiserror('Không hợp lệ!',0,1)
	   Rollback transaction
	End
End
go

--2. Năm bắt đầu học của sinh viên phải nhỏ hơn năm kết thúc và lớn hơn năm thành lập của khoa đó.
Create trigger Cau2 on SinhVien
for update
As
Begin
    if exists (select *from SinhVien sv,Khoa k,LopHoc lh
	where sv.MaLop=lh.MaLop and lh.MaKhoa=k.MaKhoa and
	(sv.NamBD <sv.NamKT and
	sv.NamBD>k.NamThanhLap))
	Begin 
	    Raiserror('Không hợp lệ!',0,1)
		Rollback transaction
    End
End
go

--3. Sinh viên chỉ được nhập học từ 18 đến 22 tuổi.
Create trigger Cau3 on SinhVien
for update
As 
Begin 
    if exists (select *from SinhVien sv
	where datediff(MM, sv.NamSinh,2020)>17 and 
	datediff(MM,sv.NamSinh,2020)<23)
	Begin
	    Raiserror('Không hợp lệ!',0,1)
		Rollback transaction
	End
End
--4 Sinh viên chỉ được học các môn của khoa mình mở.
go
Create trigger Cau4 on Khoa
For update
As
Begin
     if exists (select *from Khoa k,MonHoc mh
	 where k.MaKhoa=mh.MaKhoa)
	 Begin 
	 Raiserror('Không hợp lệ!',0,1)
	 Rollback transaction
	 End
End
go

--5. Số lượng sinh viên (nếu có) bằng số sinh viên của lớp đó.
Create trigger Cau5 on SinhVien
For update, insert, delete
As
Begin
     if exists (select *from inserted i ,deleted d,SinhVien sv,LopHoc lh
	 where i.MaSV=sv.MaSV and d.MaSV=sv.MaSV and sv.MaLop=lh.MaLop and count(sv.MaSV)=lh.SiSo)
	 Begin 
	 Raiserror('Không hợp lệ!',0,1)
	 Rollback transaction
	 End
End
go

--6. Xóa một sinh viên phải xóa tất cả các tham chiếu đến sinh viên đó.
Create trigger Cau6 on SinhVien
For delete
As
Begin
     if exists (select *from deleted d, SinhVien sv
	 where d.MaSV=sv.MaSV)
	 Begin 
	 Raiserror('Không hợp lệ!',0,1)
	 Rollback transaction
	 End
End
go

--7. Điểm trung bình (nếu có) phải bằng tổng điểm / tổng tín chỉ.
Create trigger Cau7 on SinhVien
For update, insert, delete
As
Begin
     if exists (select *from inserted i ,deleted d,SinhVien sv,KetQua kq, MonHoc mh
	 where i.MaSV=sv.MaSV and d.MaSV=sv.MaSV and sv.MaSV=kq.MaSV and mh.MaMH=kq.MaMH and sv.DiemTB=sum(kq.Diem)/sum(mh.SoChi))
	 Begin 
	 Raiserror('Khong Hop Le',0,1)
	 Rollback transaction
	 End
End
go

--8. Tình trạng của sinh viên là ‘Đã tốt nghiệp’ nếu
--điểm trung bình >=5.0 và năm kết thúc < năm hiện
--hành.
--Tình trạng là ‘Đang học’ nếu năm kết thúc >= năm
--hiện hành.
--Tình trạng là ‘Bị thôi học’ nếu điểm trung bình
--<5.0 và năm kết thúc > năm hiện hành.
Create trigger Cau8 on SinhVien
For update,insert
As
Begin
     if(EXISTS (Select sv.MaSV from SinhVien sv, inserted I where I.MaSV=sv.MaSV and .DiemTB>5 and YEAR(sv.NamKT)<YEAR(sv.NamBD)+4))
		begin
			raiserror(N'Đã tốt nghiệp',16,1)
		end
	else if(EXISTS (Select sv.MaSV from SinhVien sv , inserted I where I.MaSV=sv.MaSV and YEAR(sv.NamKT)>=YEAR(sv.NamBD)+4))
		begin
			raiserror(N'Đang học',16,1)
		end
	else if(EXISTS (Select sv.MaSV from SinhVien sv, inserted I where I.MaSV=sv.MaSV and  sv.DiemTB<5 and YEAR(sv.NamKT)>YEAR(sv.NamBD)+4))
		begin
			raiserror(N'Bị thôi học',16,1)
		end
	 Begin 
	 Raiserror('Không hợp lệ!',0,1)
	 Rollback transaction
	 End
End
go