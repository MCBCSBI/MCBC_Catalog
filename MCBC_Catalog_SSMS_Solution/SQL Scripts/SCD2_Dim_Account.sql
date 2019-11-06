--use MCBC_DW_Sey

drop table if exists SCD2_Dim_Account
create table SCD2_Dim_Account
(
	Account_Key_old int not null,
	End_Date datetime not null
)
