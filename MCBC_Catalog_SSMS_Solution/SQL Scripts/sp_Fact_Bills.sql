alter procedure sp_fact_bills 
as
begin
	drop table if exists Fact_Bills
	create table Fact_Bills
	(
		 Date_Key int not null
		,Bill_Key int not null
		,Account_Key int not null
		,Company_Key int not null
		,Original_Total_Amount decimal (19,2)
		,Original_Total_Amount_LCY decimal (19,2)
		,Outstanding_Total_Amount decimal (19,2)
		,Outstanding_Total_Amount_LCY decimal (19,2)
		,Outstanding_Delinquent_Amount decimal (19,2)
		,Outstanding_Delinquent_Amount_LCY decimal (19,2)
	)

	alter table fact_bills
		add
			constraint pk_fact_bills primary key nonclustered(Date_Key,Bill_Key,Account_Key)
			,constraint fk_bills foreign key(Bill_Key) references dim_bills(bill_key)
			,constraint fk_account_bills foreign key (account_key) references dim_account(account_key)
			,constraint fk_company_bills foreign key (Company_key) references dim_company(Company_key)

		alter table fact_bills
			NOCHECK CONSTRAINT fk_bills, fk_account_bills, fk_company_bills;
end

--exec sp_fact_bills 