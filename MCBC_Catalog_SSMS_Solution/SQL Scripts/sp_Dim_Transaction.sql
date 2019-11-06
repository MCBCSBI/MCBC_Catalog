alter procedure sp_dim_transaction
as

begin
	drop table if exists Dim_Transaction
	create table Dim_Transaction
	(
		Transaction_Key int not null identity (1,1)
		,Transaction_Group nvarchar(15) not null
		,Transaction_ID nvarchar(35) not null
		,Transaction_Type nvarchar(25) null
		,Transaction_Desc nvarchar(100)
		,[Transaction_Reference] nvarchar(50)
		,[Transaction_Reference_Number] nvarchar(50)
		,Rate decimal(19,2)
		,Interest_Applied decimal(19,2)
		,Value_Date Date
		,Maturity_Date Date
		,Issue_Date Date
		,Discount_Rate decimal(19,2)
		,Reversal_Marker nvarchar(10)
		,Inw_Send_Bic nvarchar(150)
		,User_Type nvarchar(15)
		,Teller_ID int
		,scd2_start datetime not null
		,scd2_end datetime
		,scd2_hash char(66) not null 
	)

	alter table Dim_Transaction
		add
			 constraint pk_Dim_Transaction primary key clustered(transaction_key)

		set identity_insert dim_Transaction on

		insert into Dim_Transaction (Transaction_Key,Transaction_Group,Transaction_ID,Teller_ID,scd2_start,scd2_hash)
			values
				(-1,-1,-1,-1,-1,-1)
end