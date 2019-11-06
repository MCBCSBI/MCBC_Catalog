Alter procedure sp_fact_Acct_Inactive_Reset
as
	begin

		drop table if exists Fact_Acct_Inactive_Reset;
		create table Fact_Acct_Inactive_Reset
		(
			 DateReset_Key int not null
			,DateLoaded_Key int not null
			,Account_Key int not null
			,Company_Key int not null
			,Inputter_Key int not null
			,Authoriser_Key int not null
		    ,DateAuthorised Date
		)

		alter table Fact_Acct_Inactive_Reset
			add 
				 constraint pk_Fact_Acct_Inactive_Reset primary key nonclustered (DateReset_Key, DateLoaded_Key, Account_Key)
				,constraint fk_DateReset foreign key(DateReset_Key) references Dim_Date(Date_Key)
				,constraint fk_DateLoaded foreign key(DateLoaded_Key) references Dim_Date(Date_Key)
				,constraint fk_IA_Company foreign key(Company_Key) references Dim_Company(Company_Key)
				,constraint fk_IA_Inputter foreign key(Inputter_Key) references dim_User(User_key)
				,constraint fk_IA_Authoriser foreign key(Authoriser_Key) references dim_User(User_key)

		alter table Fact_Acct_Inactive_Reset
			NOCHECK CONSTRAINT fk_DateReset,fk_DateLoaded, fk_IA_Company, fk_IA_Inputter, fk_IA_Authoriser;

	end

--exec sp_fact_Acct_Inactive_Reset
--truncate table fact_Acct_Inactive_Reset
