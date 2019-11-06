--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_dim_account'
declare @sql nvarchar(max) =
'drop table if exists Dim_Account

	CREATE TABLE [dbo].[Dim_Account]
	(
		[Account_Key] Int not null Identity(1,1),
		Customer_Key int not null,
		Joint_Customer_Key int not null,
		Product_Key int not null,
		Currency_Buy_Key int not null,
		Currency_Sell_Key int not null,
		[Account_Contract_Number] [Nvarchar](100) Not Null,
		--Purpose_Code nvarchar(75),
		--Sub_Purpose_Code nvarchar(75),
		LC_Type nvarchar(10) null,
		[Account_Title_1] [Nvarchar](35) Null,
		[Linked_Account_No] [Nvarchar](19) Null,
		Limit_Reference nvarchar(50),
		Parent_Limit_Reference nvarchar(50),
		Limit_Expiry_Date Date,
		Limit_Review_Date Date,
		Start_Date date,
		Maturity_Date date,
		Renewal_Date date,
		Maturity_Bucket nvarchar(25),
		Close_Date date,
		Status nvarchar(7),
		Interest_Rate nvarchar(10),
		--Penalty_Rate nvarchar(10),
		--Effective_Rate nvarchar(10),
		Inactve_Marker nvarchar(10),
		Overdrawn_Flag nvarchar(1),
		[Scd2_Start] Date Null,
		[Scd2_End] Date Null,
		[Scd2_Hash] [Char](66) Not Null
	)

	set identity_insert Dim_Account on

	alter table Dim_Account
		add 
			constraint pk_Dim_Account primary key clustered (Account_key)
			,constraint fk_customer foreign key (Customer_key) references dim_customer(customer_key)
			,constraint fk_joint_customer foreign key (Joint_Customer_key) references dim_customer(customer_key)
			,constraint fk_prdct foreign key (Product_Key) references dim_product(product_key)
			,constraint fk_Currency_Buy foreign key (Currency_Buy_Key) references dim_currency(currency_key)
			,constraint fk_Currency_Sell foreign key (Currency_Sell_Key) references dim_currency(currency_key)

	insert into Dim_Account(Account_Key,Customer_key,Joint_Customer_Key,Product_Key,Currency_Buy_Key,Currency_Sell_Key,
	Account_Contract_Number, Scd2_Hash)
		values(-1,-1,-1,-1,-1,-1,-1,-1);

	alter table Dim_Account
	NOCHECK CONSTRAINT fk_customer,fk_joint_customer,fk_prdct,fk_Currency_Buy,fk_Currency_Sell;
	'

begin try
exec(
'create procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end try

begin catch
exec(
'alter procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end catch

--exec sp_Dim_Currency

