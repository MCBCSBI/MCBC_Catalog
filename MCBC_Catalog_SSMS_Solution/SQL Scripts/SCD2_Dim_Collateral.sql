drop table if exists SCD2_Dim_Collateral
create table SCD2_Dim_Collateral
(
	Collateral_Key_old int not null,
	End_Date datetime not null
)
