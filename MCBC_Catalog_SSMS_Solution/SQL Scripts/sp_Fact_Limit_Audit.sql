alter procedure sp_fact_Limit_audit
as

begin
	drop table if exists Fact_Limit_audit
	create table Fact_Limit_audit
	(
			 MIS_DATE date
			,ACCOUNT nvarchar(60) not null
		    ,INTERNAL_AMT decimal(19,2) 
			,INTERNAL_AMT_LCY decimal(19,2) 
		    ,UTILISED_AMT decimal(19,2) 
			,UTILISED_AMT_LCY decimal(19,2)
		    ,ADVISED_AMOUNT decimal(19,2) 
			,ADVISED_AMOUNT_LCY decimal(19,2) 
		    ,ONLINE_LIMIT decimal(19,2) 
			,ONLINE_LIMIT_LCY decimal(19,2)
		    ,MAXIMUM_TOTAL decimal(19,2) 
			,MAXIMUM_TOTAL_LCY decimal(19,2) 
		    ,AVAIL_AMT decimal(19,2) 
			,ORIGINAL_LIMIT decimal(19,2)
	)
end
