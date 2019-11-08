drop table if exists Dim_Account

	CREATE TABLE [dbo].[Dim_Account]
	(
		Account_Key Int not null Identity(1,1),
		Account_No [Nvarchar](19) Null
		,Account_Contract_No [Nvarchar](100) Null
		,Account_Title [Nvarchar](65) Null
		,Product_Code int
		,Product_Description nvarchar(55)
		,Opening_Date date
		,Maturity_Rollover_Date date
		,Close_date date
		,Account_Branch_Code nvarchar(11) null	
		,Account_Branch_Name nvarchar(55) null 
		--Purpose_Code nvarchar(75),
		--Sub_Purpose_Code nvarchar(75),
		--LC_Type nvarchar(10) null,
		
		--Limit_Reference nvarchar(50),
		--Parent_Limit_Reference nvarchar(50),
		--Limit_Expiry_Date Date,
		--Limit_Review_Date Date,
		--Start_Date date,
		--Maturity_Date date,
		--Renewal_Date date,
		--Maturity_Bucket nvarchar(25),
		--Close_Date date,
		--Status nvarchar(7),
		--Interest_Rate nvarchar(10),
		--Penalty_Rate nvarchar(10),
		--Effective_Rate nvarchar(10),
		--Inactve_Marker nvarchar(10),
		--Overdrawn_Flag nvarchar(1),
		,[Scd2_Start] Date Null
		,[Scd2_End] Date Null
		,[Scd2_Hash] [Char](66) Not Null
	)

	set identity_insert Dim_Account on

	alter table Dim_Account
	add 
		constraint pk_Dim_Account primary key clustered (Account_key)

	/*insert into Dim_Account(Account_Key,Customer_key,Joint_Customer_Key,Product_Key,Currency_Buy_Key,Currency_Sell_Key,
	Account_Contract_Number, Scd2_Hash)
		values(-1,-1,-1,-1,-1,-1,-1,-1);*/

	/*alter table Dim_Account
	NOCHECK CONSTRAINT 
		pk_Dim_Account*/
	