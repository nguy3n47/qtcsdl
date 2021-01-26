--1. Sinh viên chỉ được học các môn của khoa mình mở.

--				Insert		Delete		Update
--	SinhVien	  +			  -			+(MaLop)
--	LopHoc		  +			  +			+(MaKhoa)
--	Khoa		  -			  +			+(MaKhoa)
--	MonHoc		  +			  -			+(MaKhoa)

--2. Sinh viên chỉ được thi lại nếu điểm của lần thi sau cùng < 5 và số lần thi < 3.

--				Insert		Delete		Update
--	KetQua		  +			  -			+(LanThi, Diem)

--3. Số lượng sinh viên (nếu có) bằng số sinh viên của lớp đó.

--				Insert		Delete		Update
--	SinhVien	  +			  +			+(MaLop)
--	LopHoc		  +			  -			+(MaLop, SiSO)

--4. Xóa một sinh viên phải xóa tất cả các tham chiếu đến sinh viên đó.

--				Insert		Delete		Update
--	SinhVien	  -			  +			+(MaSV)
--	KetQua		  +			  -			+(MaSV)

--5. Điểm trung bình (nếu có) phải bằng tổng điểm / tổng tín chỉ.

--				Insert		Delete		Update
--	MonHoc		  -			  +			+(MaMH)
--	KetQua		  +			  -			+(MaMH)
--	SinhVien	  +			  -			+(MaSV, DiemTB)

--6. Sinh viên chỉ được nhập học từ 18 đến 22 tuổi.

--				Insert		Delete		Update
--	SinhVien	  +			  -			+(NamSinh, NamBD)

--7. Năm bắt đầu học của sinh viên phải nhỏ hơn năm kết thúc và lớn hơn năm thành lập của khoa đó.

--				Insert		Delete		Update
--	SinhVien	  +			  -			+(NamBD, NamKT)
--	Khoa		  -			  -			+(NamThanhLap)

--8. Tình trạng của sinh viên là ‘Đã tốt nghiệp’ nếu điểm trung bình >=5.0 và năm kết thúc < năm hiện hành.
--		Tình trạng là ‘Đang học’ nếu năm kết thúc >= năm hiện hành.
--		Tình trạng là ‘Bị thôi học’ nếu điểm trung bình <5.0 và năm kết thúc > năm hiện hành.

--				Insert		Delete		Update
--	SinhVien	  +			  -			+(DiemTB, NamKT, TinhTrang)