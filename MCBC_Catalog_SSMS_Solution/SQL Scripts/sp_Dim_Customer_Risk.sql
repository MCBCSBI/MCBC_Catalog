alter procedure sp_Dim_Customer_Risk
as
	begin
		drop table if exists Dim_Customer_Risk

		CREATE TABLE [dbo].[Dim_Customer_Risk]
		(         
			[Customer_Risk_Key] Int Identity,
			[Customer_key] Int not null,
			[Customer_Risk_ID] NVARCHAR(100) not null,
			[Risk_Asset_Type]	NVARCHAR(7)	Null,
			[Risk_Asset_Type_Desc] NVARCHAR(100)	Null,
			[Risk_Level]	INTEGER	Null,
			[Risk_Tolerance]	INTEGER	,
			[Risk_From_Date]	DATE	Null,
			[Scd2_Start] Date Null,
			[Scd2_End] Date Null,
			[Scd2_Hash] [Char](66) Not Null

)

		alter table Dim_Customer_Risk
			 add 
				 constraint pk_Dim_Customer_Risk primary key clustered (Customer_Risk_key)
				,constraint fk_Dim_Customer_Risk foreign key (Customer_key) references dim_customer(customer_key)

		set identity_insert dim_customer_Risk on

		insert into Dim_Customer_Risk(Customer_Risk_Key,customer_key,[Customer_Risk_ID],Scd2_Hash)
			values
				(-1,-1,'-1','-1');

		alter table Dim_Customer_Risk
			NOCHECK CONSTRAINT fk_Dim_Customer_Risk;
				
	end

GO

--exec sp_dim_customer_Risk
--select * from dim_customer_Risk