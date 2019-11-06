alter procedure sp_dim_bills
as

begin
	drop table if exists dim_bills
	create table Dim_Bills
	(
		 Bill_Key int not null identity (1,1)
		,Bill_ID nvarchar(80) not null
		,Bill_Status nvarchar(15)
		,Bill_Status_Change_Date date
		,Settle_Status nvarchar(15)
		,Settle_Status_Change_Date nvarchar(8)
		,Aging_Status nvarchar(15)
		,Aging_Status_Change_Date nvarchar(8)
		,scd2_start datetime not null
		,scd2_end datetime 
		,scd2_hash char(66) not null
	)

	alter table dim_bills
		add
			 constraint pk_dim_bills primary key clustered(Bill_Key)
end