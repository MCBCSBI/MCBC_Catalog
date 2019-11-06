Alter procedure sp_fact_Currency_audit
as
begin	
	drop table if exists Fact_Currency_Audit
	create table Fact_Currency_Audit
	(
		 Date date not null
		,Currency nvarchar(50) not null
		,CurrencyMarket nvarchar(50) not null
		,Mid_Reval_Rate decimal (19,2)
		,Buy_Rate decimal (19,2)
		,Sell_Rate decimal (19,2)
		,Negotiable_Amount_LCY decimal (19,2)
	)
end

--exec sp_fact_Currency_audit