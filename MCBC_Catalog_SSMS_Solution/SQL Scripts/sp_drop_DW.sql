--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_drop_dw'
declare @sql nvarchar(max) =
'-----------FACTS--------------------------
	drop table if exists Fact_Balances;
	drop table if exists Fact_Balances_PL;
	drop table if exists Fact_Acct_Entries;
	drop table if exists Fact_Bills;
	drop table if exists Fact_Transaction;
	drop table if exists Fact_Currency;
	drop table if exists Fact_Account_Opening;
	drop table if exists Fact_Cashflow;
	drop table if exists Fact_Acct_Inactive_Reset;
	drop table if exists Fact_Collateral
	drop table if exists Fact_Limit
	drop table if exists Fact_Interest
	drop table if exists Fact_Commission_Type
	drop table if exists Fact_Teller_ID
	drop table if exists Fact_com_channel
	
-----------SNOWFLAKE DIMENSIONS----------------------
	drop table if exists Dim_GL_Mapping;
	drop table if exists Dim_Customer;
	--drop table if exists Dim_Company;

-----------DIMENSIONS------------------------------
	drop table if exists Dim_Account;
	drop table if exists Dim_GL;
	drop table if exists Dim_Customer_Risk;
	drop table if exists Dim_Bills;
	drop table if exists Dim_Product;
	drop table if exists Dim_Currency;
	drop table if exists Dim_Transaction;
	drop table if exists Dim_CurrencyMarket;
	drop table if exists Dim_User;
	drop table if exists Dim_Transaction;
	drop table if exists Dim_Transaction_Code;
	drop table if exists Dim_Commission_Type;
	drop table if exists Dim_Collateral;
-------------AUDIT TABLES--------------------------
	drop table if exists Fact_Balances_Audit
	drop table if exists Fact_Bills_Audit
	drop table if exists Fact_Acct_Entries_Audit
	drop table if exists Fact_Transaction_Audit;
	drop table if exists Fact_Currency_Audit;
	drop table if exists Fact_Acct_Inactive_Reset_Audit;
	drop table if exists Fact_Limit_Audit;
--------------CONTROL TABLE------------------------
	drop table if exists Control_Table;'

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


