drop table if exists SCD2_Dim_CurrencyMarket
create table SCD2_Dim_CurrencyMarket
(
	CurrencyMarket_Key_old int not null,
	End_Date datetime not null
)
