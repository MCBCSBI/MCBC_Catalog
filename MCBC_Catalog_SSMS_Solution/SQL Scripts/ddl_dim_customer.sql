drop table if exists Dim_Customer

		CREATE TABLE [dbo].[Dim_Customer]
		(         
			[Customer_key] Int Identity,
			[Customer_No] nvarchar(10) Not Null,
			Customer_Name	NVARCHAR(150)	Null,
			Sector	NVARCHAR(35)	Null,
			Target nvarchar(35) null,
			Industry	NVARCHAR(35)	Null,
			--Gender	NVARCHAR(10)	Null,
			--Account_Officer	NVARCHAR(100)	Null,
			--Nationality	NVARCHAR(2)	Null,
			--Residence	NVARCHAR(4)	Null,
			--Residence_Type nvarchar(12) null,
			--Customer_Type	NVARCHAR(35)	Null,
			--Date_Of_Birth	DATE	Null,
			--Address	NVARCHAR(100)	Null,
			--Legal_Id	NVARCHAR(100)	Null,

			--Pref_com_Channel	NVARCHAR(35)	Null,
			--Contact_Date	DATE	Null,
			--Introducer	NVARCHAR(100)	Null,
			--Kyc_Relationship	NVARCHAR(100)	Null,
			--Last_Kyc_Review_Date	DATE	Null,
			--Auto_Next_Kyc_Review_Date	DATE	Null,
			--Last_Suit_Review_Date	DATE	Null,
			--Auto_Next_Suit_Review_Date	DATE	Null,
			--Manual_Next_Kyc_Review_Date	DATE	Null,
			--Manual_Next_Suit_Review_Date	DATE	Null,
			--Aml_Check	NVARCHAR(4)	Null,
			--Aml_Result	NVARCHAR(14)	Null,
			--Last_Aml_Result_Date	DATE	Null,
			--Calc_Risk_Class	NVARCHAR(10)	Null,
			--Manual_Risk_Class	NVARCHAR(10)	Null,
			--Override_Reason	NVARCHAR(300)	Null,
			--Kyc_Complete	NVARCHAR(4)	Null,
			Customer_Branch_Code nvarchar(11),
			Customer_Branch_Name nvarchar(75),
			Customer_Since	NVARCHAR(35)	Null,
			[Scd2_Start] Date Null,
			[Scd2_End] Date Null,
			[Scd2_Hash] [Char](66) Not Null

		)

		alter table Dim_Customer
			add constraint pk_Dim_Customer primary key clustered (Customer_key)

		--set identity_insert dim_customer on

		--insert into Dim_Customer(customer_key,customer_no,Scd2_Hash)
		--	values
		--		(-1,''-1'',''-1'')