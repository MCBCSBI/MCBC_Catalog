use Swazi_DW_Mock
go
alter procedure sp_Fact_Cashflow
as
	begin

		drop table if exists Fact_Cashflow;
		create table Fact_Cashflow
		(
			Record_Key int not null identity(1,1)
			,Date_Key int not null
			,Account_Key int not null
			--,Currency_Key int not null
			,Company_Key int not null
			,Cash_Flow_Type nvarchar(50) not null
			,Cash_Flow_Amt_CCY decimal (19,2)
		)

		alter table Fact_Cashflow
			add 
				 constraint pk_Fact_Cashflow primary key clustered (record_key)
				,constraint fk_Date_Key_cf foreign key(Date_Key) references Dim_Date(Date_Key)
				,constraint fk_account_key_cf foreign key(account_key) references Dim_account(account_key)
				--,constraint fk_currency_key_cf foreign key(currency_key) references dim_currency(Currency_key)
				,constraint fk_company_key_cf foreign key(company_key) references dim_company(company_key)

		alter table Fact_Cashflow
			NOCHECK CONSTRAINT fk_Date_Key_cf, fk_account_key_cf, fk_company_key_cf;

	end

--exec sp_Fact_Cashflow
--truncate table Fact_Cashflow


