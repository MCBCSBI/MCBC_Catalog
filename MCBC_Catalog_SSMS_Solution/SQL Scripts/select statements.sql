use Swazi_DW_mock
go

select * from Control_Table order by Table_name

select * from Dim_Account

select * from dim_transaction where Discount_Rate IS NOT NULL

select * from Dim_Currency

select * from Dim_CurrencyMarket

select * from Dim_Customer

select *  from Dim_User where user_name like ('%USER%')

select * from Dim_GL

Select * from Dim_Product

select * from Dim_Customer where Customer_Num = '100119'

select * from Dim_Bills where Aging_Status = 'GRC'

select * from dim_date --truncate table dim_date

select * from Dim_GL_Mapping where Asset_Type = 'DUEPRINCIPALINT'

select * from Dim_Company where Company_ID = 'SZ0010003'

select * from Dim_Collateral

select * from Fact_Balances
select * from Fact_Balances_Audit

select * from Fact_balances_pl

select * from Fact_Acct_Entries -- truncate table Fact_Acct_Entries
select * from Fact_Acct_Entries_audit -- truncate table Fact_Acct_Entries_audit

select * from Fact_Bills
select * from Fact_Bills_Audit

select * from fact_account_opening

select * from fact_transaction

select * from fact_cashflow

select * from Fact_Collateral

select * from Fact_Limit

select * from fact_interest

select * from Fact_Acct_Inactive_Reset

/*
Exec sp_drop_DW
exec sp_create_DW
*/


select * from Dim_Product where Product_Description like ('%Bill%')

select * from Fact_Commission_Type

select * from Fact_Teller_Id

select * from Dim_Customer_Risk


select * from Dim_Commission_Type where SCD2_End is null