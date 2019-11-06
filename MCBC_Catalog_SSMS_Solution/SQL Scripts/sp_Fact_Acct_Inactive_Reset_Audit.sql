Alter procedure sp_fact_Acct_Inactive_Reset_Audit
as
	begin

		drop table if exists Fact_Acct_Inactive_Reset_Audit;
		create table Fact_Acct_Inactive_Reset_Audit
		(
			 MIS_DATE Date
			,BRANCH_CO_MNE nvarchar(5)
			,ACCOUNT_NUMBER nvarchar(30)
			,RESET_DATE DATE
			,INPUTTER nvarchar(30)
			,AUTHORISER nvarchar(30)
		    ,DateAuthorized Date
		)

		
	end

--exec sp_fact_Acct_Inactive_Reset_Audit
--truncate table fact_Acct_Inactive_Reset_Audit
