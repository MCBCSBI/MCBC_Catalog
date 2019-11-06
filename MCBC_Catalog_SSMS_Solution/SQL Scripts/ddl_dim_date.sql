Drop table if exists dim_date
		CREATE TABLE [dbo].[Dim_Date](
			Date_Key [int] NOT NULL,
			Date [Date] NOT NULL,
			Year [int] NOT NULL,
			Month [int] NOT NULL,
			Month_Name  [nvarchar](10) NOT NULL,
			Quarter [int] NOT NULL,
			Week_Of_Month [int] NOT NULL,
			Day [int] NOT NULL,
			Day_Name [nvarchar](10) NOT NULL,
			Financial_Year [int] NOT NULL,
			Financial_Quarter [int] NOT NULL,
			Date_Current_Week [Bit] NOT NULL,
			Date_Prior_Week [Bit] NOT NULL,
			Has_Data bit null
			)

		Alter Table Dim_Date
		Add constraint pk_DateKey primary key clustered (Date_Key)