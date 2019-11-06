alter procedure sp_Dim_Commission_Type
as

begin
	drop table if exists Dim_commission_type
	create table Dim_commission_type
	(
		 Commission_type_Key int not null identity (1,1)
		,Commission_type nvarchar(20) not null
		,Commission_type_Desc nvarchar(35) null
		--,Category_Account nvarchar(16) null
		--,Txn_Code_Cr nvarchar(3) null
		--,Txn_Code_Dr nvarchar(3) null
		--,Currency nvarchar(3) not null
		--,Flat_Amt Decimal(27,2) null
		,scd2_start datetime not null
		,scd2_end datetime
		,scd2_hash char(66) not null 
	)

	alter table Dim_commission_type
		add
			 constraint pk_Dim_commission_type primary key clustered(commission_type_key)

		set identity_insert Dim_commission_type on

		insert into Dim_commission_type (Commission_type_Key,Commission_type,scd2_start,scd2_hash)
			values
				(-1,-1,-1,-1)
end