drop table if exists SCD2_Dim_Company
create table SCD2_Dim_Company
(
	Company_Key_old int not null,
	End_Date datetime not null
)