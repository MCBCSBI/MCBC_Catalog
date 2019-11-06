create procedure sp_dim_transaction_code
as

begin
	drop table if exists Dim_Transaction_code
	create table Dim_Transaction_code
	(
		Transaction_code_Key int not null identity (1,1)
		,Transaction_code nvarchar(25) null
		,Transaction_code_Desc nvarchar(100)
		,scd2_start datetime not null
		,scd2_end datetime
		,scd2_hash char(66) not null 
	)

	alter table Dim_Transaction_code
		add
			 constraint pk_Dim_Transaction_code primary key clustered(transaction_code_key)

		set identity_insert dim_Transaction_code on

		insert into Dim_Transaction_code (Transaction_code_Key,scd2_start,scd2_hash)
			values
				(-1,-1,-1)
end