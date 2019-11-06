alter procedure sp_fact_acct_entries_audit
as

begin
	drop table if exists Fact_Acct_Entries_audit
	create table Fact_Acct_Entries_audit
	(
		MIS_DATE date
		,BOOKING_DATE date not null
		,ID nvarchar(60) not null
		,BRANCH nvarchar(3) not null
		,ACCOUNT_NO nvarchar(19)
		,CONSOL_KEY nvarchar(150)
		,ASSET_TYPE nvarchar(50)
		,Product_Category int
		,PL_category int
		,Amount_LCY decimal(19,2)
		,Amount_FCY decimal(19,2)
	)
end
