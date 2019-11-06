drop table if exists SCD2_Dim_Currency
create table SCD2_Dim_Currency
(
	Currency_Key_old int not null,
	End_Date datetime not null
)
