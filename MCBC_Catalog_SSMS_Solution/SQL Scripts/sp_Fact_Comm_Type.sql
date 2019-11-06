
alter procedure sp_Fact_Comm_Type
as
	begin

		drop table if exists Fact_Commission_Type

		CREATE TABLE [dbo].Fact_Commission_Type
		(
		   [Commission_Type_Key] Int not null,
		   [Transaction_Key] Int Not Null,
		   [DateKey] int not null,
		   [Commission_Currency] nvarchar(3) not null,
		   [Flat_Amt]  [Decimal](19,2)	  
		)


		alter table Fact_Commission_Type
			add 
				  constraint fk_comm_type primary key clustered ([Commission_Type_Key],[Transaction_Key],[Commission_Currency],[DateKey])
				 ,constraint fk_Dim_Comm_Type foreign key (Commission_Type_Key) references Dim_Commission_Type (Commission_Type_Key)
				 ,constraint fk_Dim_Comm_Transaction foreign key (Transaction_Key) references Dim_Transaction(Transaction_key)

		alter table Fact_Commission_Type
			NOCHECK CONSTRAINT fk_Dim_Comm_Type, fk_Dim_Comm_Transaction;


	end

GO

--exec sp_Fact_Comm_Type




