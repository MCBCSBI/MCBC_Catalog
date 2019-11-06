Alter procedure sp_fact_transaction_audit
as
	begin
		drop table if exists Fact_Transaction_Audit

		create table Fact_Transaction_Audit
				(
					Date datetime
					,Transaction_ID nvarchar(200)
					,Debit_Customer nvarchar(200)
					,Credit_Customer nvarchar(200)
					,Transaction_Date Date
					,Issue_Date Date
					,Maturity_Date Date
					,Debit_Account nvarchar(200)
					,Credit_Account nvarchar(200)
					,[Debit_Amount_Lcy] [Decimal](19,2)
					,[Credit_Amount_Lcy] [Decimal](19,2)
					,[Debit_Amount_Fcy] [Decimal](19,2)
					,[Credit_Amount_Fcy] [Decimal](19,2)
				)
	end

	--exec sp_fact_transaction_audit