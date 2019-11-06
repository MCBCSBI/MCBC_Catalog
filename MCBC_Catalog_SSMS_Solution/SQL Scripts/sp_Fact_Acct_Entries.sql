--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_fact_acct_entries'
declare @sql nvarchar(max) =
'begin
	drop table if exists Fact_Acct_Entries
	create table Fact_Acct_Entries
	(
		Booking_Date_Key int not null
		,Branch_Key int not null
		,Account_Key int not null
		,Gl_Mapping_Key int not null
		,Product_Category_Key int not null
		,PL_Category_Key int not null
		,Transaction_Key int not null
		,Transaction_Code_Key int not null
		,Entry_Type nvarchar(15)
		,Entry_ID nvarchar(50) not null
		,Reversal_marker nvarchar(1) null
		,Amount_LCY decimal(19,2)
		,Amount_FCY decimal(19,2)
	)

	alter table fact_acct_entries
		add 
			constraint pk_acct_entries primary key nonclustered(entry_id)
			,constraint fk_date_key_acct_entries foreign key(booking_date_key) references dim_date(date_key)
			,constraint fk_branch_key_acct_entries foreign key (branch_key) references dim_company(company_key)
			,constraint fk_gl_mapping_key_acct_entries foreign key(gl_mapping_key) references dim_gl_mapping(gl_mapping_key)
			,constraint fk_account foreign key(account_key) references dim_account(account_key)
			,constraint fk_prodcat foreign key (Product_Category_key) references dim_product(Product_Key)
			,constraint fk_plcat foreign key (PL_Category_key) references dim_product(Product_Key)
			,constraint fk_transaction_acct_entries foreign key (transaction_key) references dim_transaction(transaction_Key)
			,constraint fk_transaction_code_acct_entries foreign key (transaction_code_key) references dim_transaction_code(transaction_code_Key)


		alter table fact_acct_entries
			NOCHECK CONSTRAINT fk_date_key_acct_entries,fk_branch_key_acct_entries,fk_gl_mapping_key_acct_entries,
			fk_account, fk_prodcat, fk_plcat, fk_transaction_acct_entries, fk_transaction_code_acct_entries;
end
'

begin try
exec(
'create procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end try

begin catch
exec(
'alter procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end catch


--exec sp_fact_acct_entries