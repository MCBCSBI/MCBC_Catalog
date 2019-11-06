alter procedure sp_fact_Limit
as
	begin

		drop table if exists Fact_Limit;
		create table Fact_Limit
		(
			 Limit_ID nvarchar(50) not null
			,Date_Key int not null
			,Account_Key int not null
			,Company_Key int not null
		    ,INTERNAL_AMT decimal(19,2) 
			,INTERNAL_AMT_LCY decimal(19,2) 
		    ,UTILISED_AMT decimal(19,2) 
			,UTILISED_AMT_LCY decimal(19,2)
		    ,ADVISED_AMOUNT decimal(19,2) 
			,ADVISED_AMOUNT_LCY decimal(19,2) 
		    ,ONLINE_LIMIT decimal(19,2) 
			,ONLINE_LIMIT_LCY decimal(19,2)
		    ,MAXIMUM_TOTAL decimal(19,2) 
			,MAXIMUM_TOTAL_LCY decimal(19,2) 
		    ,AVAIL_AMT decimal(19,2) 
			,ORIGINAL_LIMIT decimal(19,2)

		)

		alter table Fact_Limit
			add 
				 constraint pk_Fact_Limit primary key clustered (Limit_ID,Date_Key)
				,constraint fk_Limit_Date foreign key(Date_Key) references Dim_Date(Date_Key)
				,constraint fk_Limit_Acc foreign key(Account_Key) references Dim_Account(Account_Key)

		alter table Fact_Limit
			NOCHECK CONSTRAINT fk_Limit_Date, fk_Limit_Acc;


	end

--exec sp_fact_Currency
--truncate table fact_Currency