--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_ctrl_table'
declare @sql nvarchar(max) =
'drop table if exists Control_Table
create table Control_Table
(
	Table_name nvarchar(100) not null,
	Last_Execution_Date datetime,
	Last_Date_Loaded datetime
)

insert into Control_Table(Table_name)
	values
		(''Dim_GL''),
		(''Fact_Balances''),
		(''Dim_GL_Mapping''),
		(''Fact_Acct_Entries''),
		(''Dim_Account''),
		(''Dim_Company''),
		(''Dim_Customer''),
		(''Dim_Customer_Risk''),
		(''Dim_Bills''),
		(''Fact_Bills''),
		(''Dim_Product''),
		(''Fact_Transaction''),
		(''Dim_Currency''),
		(''Dim_Transaction''),
		(''Dim_Transaction_code''),
		(''Dim_Commission_Type''),
		(''Dim_CurrencyMarket''),
		(''Fact_Currency''),
		(''Fact_Balances_PL''),
		(''Fact_Account_Opening''),
		(''Fact_Cashflow''),
		(''Dim_User''),
		(''Fact_Acct_Inactive_Reset''),
		(''Fact_Collateral''),
		(''Dim_Collateral''),
		(''Fact_Limit''),
		(''Fact_Interest''),
		(''Fact_Commission_Type''),
		(''Fact_Teller_ID''),
		(''Fact_com_channel'')

update Control_Table
	set Last_Date_Loaded = ''1900-01-01'' where Last_Date_Loaded is null

update Control_Table
	set Last_Execution_Date = ''1900-01-01'' where Last_Execution_Date is null'

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


