
Alter procedure sp_Fact_Transaction
as
	begin

		drop table if exists Fact_Transaction

		CREATE TABLE [dbo].[Fact_Transaction]
		(
		   [Transaction_Key] Int not null,
		   --[Transaction_ID] [Nvarchar](19) Not Null,
		   [Company_Key] int not null,
		   --[Commission_Type_Key] int not null,
		   [Debit_Customer_Key] int not null,
		   [Credit_Customer_Key] int not null,
		   --[Transaction_Type] nvarchar(50) null,
		   --[Transaction_Code_Key] int not null,
		   [Transaction_Date_key] int not null,
		   --[Issue_Date_key] int not null,
		   --[Maturity_Date_key] int not null,
		   --[Transaction_Code_Key] int not null,
		   [Debit_Account_Key] int not null,
		   [Credit_Account_Key] int not null,
		   [Debit_Account_Ccy_Key] int not null,
		   [Credit_Account_Ccy_Key] int not null,
		   [Inputter_Key] int not null,
		   [Authoriser_Key] int not null,
		   --[Status] nvarchar(50) null,
		   [Debit_Amount_Lcy] [Decimal](19,2),
		   [Credit_Amount_Lcy] [Decimal](19,2),
		   [Debit_Amount_Fcy] [Decimal](19,2),
		   [Credit_Amount_Fcy] [Decimal](19,2),
		   [Mktg_Exch_Profit] [Decimal](19,2),
		)


		alter table Fact_Transaction
			add 
				 constraint fk_Transaction primary key clustered (Transaction_key,Transaction_Date_key)
				,constraint fk_Dim_Transaction foreign key (Transaction_Key) references Dim_Transaction(Transaction_key)
				,constraint fk_Dim_Company_Tran foreign key (Company_Key) references Dim_Company(Company_Key)
				--,constraint fk_Dim_Comm_Type foreign key (Commission_Type_Key) references Dim_Commission_Type (Commission_Type_Key)
				,constraint fk_Debit_customer foreign key (Debit_Customer_Key) references dim_customer(customer_key)
				,constraint fk_Credit_customer foreign key (Credit_Customer_Key) references dim_customer(customer_key)
				,constraint fk_Debit_Account foreign key (Debit_Account_Key) references dim_Account(Account_key)
				,constraint fk_Credit_Account foreign key (Credit_Account_key) references dim_Account(Account_key)
				,constraint fk_Debit_Account_Ccy foreign key (Debit_Account_Ccy_key) references dim_Currency(Currency_key)
				,constraint fk_Credit_Account_Ccy foreign key (Credit_Account_Ccy_key) references dim_Currency(Currency_key)
				,constraint fk_Authoriser foreign key (Authoriser_key) references dim_User(User_key)
				,constraint fk_Inputter foreign key (Inputter_key) references dim_User(User_key)

		alter table Fact_Transaction
			NOCHECK CONSTRAINT fk_Dim_Transaction, fk_Dim_Company_Tran, fk_Debit_customer, fk_Credit_customer,
			fk_Debit_Account, fk_Credit_Account, fk_Debit_Account_Ccy, fk_Credit_Account_Ccy, fk_Authoriser, fk_Inputter;

	end

GO

--exec sp_Fact_Transaction




