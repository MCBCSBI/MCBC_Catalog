--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_create_dw'
declare @sql nvarchar(max) =
'-----------CONTROL TABLE------------------
		exec sp_ctrl_table
----------SNOWFLAKE DIM------------
		exec sp_dim_gl
		exec sp_dim_Customer
		exec sp_Dim_Customer_Risk
		exec sp_dim_product
		exec sp_dim_transaction
		exec sp_Dim_Currency
		exec sp_Dim_CurrencyMarket
		exec sp_Dim_transaction_code
		exec sp_Dim_commission_type
--------------DIM-------------------
		exec sp_dim_gl_mapping
		exec sp_Dim_Bills
		exec sp_Dim_Account
		exec sp_Dim_User
		exec sp_dim_collateral
------------FACT--------------------
		exec sp_fact_com_channel;
		exec sp_fact_balances;
		exec sp_fact_balances_pl;
		exec sp_fact_acct_entries;
		exec sp_fact_bills;
		exec sp_Fact_Transaction
		exec sp_fact_Currency;
		exec sp_fact_account_opening;
		exec sp_Fact_Cashflow;
		exec sp_fact_Acct_Inactive_Reset;
		exec sp_fact_Collateral;
		exec sp_fact_Limit;
		exec sp_fact_interest
		exec sp_Fact_Comm_Type
		exec sp_fact_Teller_ID
		
----------------AUDIT----------------
		exec sp_fact_balances_audit
		exec sp_fact_bills_audit
		exec sp_fact_acct_entries_audit
		exec sp_fact_transaction_audit
		exec sp_fact_currency_audit
		exec sp_fact_Acct_Inactive_Reset_Audit
		exec sp_fact_Limit_audit
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


