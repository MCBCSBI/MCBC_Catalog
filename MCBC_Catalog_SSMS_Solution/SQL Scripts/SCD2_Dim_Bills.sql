drop table if exists SCD2_Dim_Bills
create table SCD2_Dim_Bills
(
	Bill_Key_old int not null,
	End_Date datetime not null
)

