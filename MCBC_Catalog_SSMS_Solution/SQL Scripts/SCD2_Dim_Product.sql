drop table if exists SCD2_Dim_Product
create table SCD2_Dim_Product
(
	Product_Key_old int not null,
	End_Date datetime not null
)


--select * from SCD2_Dim_Product