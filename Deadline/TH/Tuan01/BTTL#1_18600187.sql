-- Viet proc xem danh sach cac de tai
-- Lay danh sach de tai: select * from DETAI
create proc sp_XemDSDT
as
begin
	select * from DETAI
end
go
exec sp_XemDSDT

-- Xem danh sach cac de tai thuoc chu de QLGD
-- Co tham so
go
create proc sp_XemDSCD
	@macd varchar(5)
as
begin
	select * from DETAI where MACD = @macd
end
go
exec sp_XemDSCD 'QLGD'

--1: Phan cong 1 giang vien tham gia 1 cong viec cua 1 de tai cu the
go
--drop proc dbo.sp_PhanCongGV
create proc sp_PhanCongGV
	@maGV varchar(3),
	@maDT varchar(4),
	@sott int,
	@dem int = null output
as
	select @dem = count(tg.MaGV) from THAMGIADT tg where @maGV = MAGV
	if @dem < 3
	begin
		insert into THAMGIADT(STT, MAGV, MADT) values(@sott, @maGV, @maDT)
		print('Success')
	end
	else
		print('Error')
go
Declare @Dem int
exec sp_PhanCongGV '006', '002' , '4', @Dem out
select * from THAMGIADT