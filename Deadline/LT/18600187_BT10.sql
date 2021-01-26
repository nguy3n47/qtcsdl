--Bài 01
-- không lỗi
begin tran

select * from SACH

waitfor delay '00:00:05'

declare @MaSach varchar(10)
set @MaSach = (select top 1 MaSach
				from SACH
				order by MaSach desc)

print @MaSach
commit

-- Bài 02
-- Phantom
begin tran

set tran isolation level Serializable

select * from SACH

waitfor delay '00:00:05'

declare @MaSach varchar(10)
set @MaSach = (select top 1 MaSach
				from SACH
				order by MaSach desc)

print @MaSach
commit

--Bài 03
--Unrepeatable read
begin tran
set tran isolation level Repeatable Read

select * from SACH

waitfor delay '00:00:05'

select * from SACH

commit

--Bài 04
-- Phantom
begin tran
set tran isolation level Serializable

select * from PHIEUDATHANG

waitfor delay '00:00:05'

UPDATE PHIEUDATHANG
SET MaKH = 'KH002'
WHERE MaPD = 'PD004'

Commit



--Bài 05
--Phantom

Begin tran
set tran isolation level Serializable

SELECT * FROM PHIEUDATHANG
WHERE MaKH = 'KH002'

waitfor delay '00:00:05'

SELECT * FROM PHIEUDATHANG

INSERT PHIEUDATHANG (MaPD,
MaKH)
VALUES ('PD005','KH002')

commit

--Bài 06
--Unrepeatable read

begin tran
set tran isolation level Repeatable Read

INSERT PHIEUDATHANG (MaPD,
MaKH)
VALUES ('PD005','KH002')

SELECT * FROM PHIEUDATHANG
WHERE MaKH = 'KH002'

waitfor delay '00:00:05'

SELECT * FROM PHIEUDATHANG
WHERE MaKH = 'KH002'

commit