drop table if exists SCD2_Dim_COMMISSION_TYPE
create table SCD2_Dim_COMMISSION_TYPE
(
	COMMISSION_TYPE_Key_old int not null,
	End_Date datetime not null
)