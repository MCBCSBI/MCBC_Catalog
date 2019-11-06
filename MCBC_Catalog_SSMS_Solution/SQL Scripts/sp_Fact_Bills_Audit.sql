alter procedure sp_fact_bills_audit
as
begin	
	drop table if exists Fact_Bills_Audit
	create table Fact_Bills_Audit
	(
		 Date date not null
		,Bill_ID nvarchar(50) not null
		,Arrangement_ID nvarchar(50) not null
		,Original_Total_Amount decimal (19,2)
		,Original_Total_Amount_LCY decimal (19,2)
		,Outstanding_Total_Amount decimal (19,2)
		,Outstanding_Total_Amount_LCY decimal (19,2)
		,Outstanding_Delinquent_Amount decimal (19,2)
		,Outstanding_Delinquent_Amount_LCY decimal (19,2)
	)
end