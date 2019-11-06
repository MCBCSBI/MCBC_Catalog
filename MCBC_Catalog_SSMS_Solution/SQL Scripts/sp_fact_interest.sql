alter procedure sp_Fact_Interest
as
	begin

		drop table if exists Fact_Interest;
		create table Fact_Interest
		(
			Date_Key int not null,
			Branch_Key int not null,
			Account_Key int not null,
			Interest_Rate decimal(5,2),
			Penalty_Rate decimal(5,2),
			Effective_Rate decimal(5,2)
		)

		alter table Fact_Interest
			add --no primary keys added because you can have an account opened and closed on the same date
				constraint fk_int_branch foreign key (branch_key)references dim_company(company_key)
				,constraint fk_int_account foreign key(account_key) references dim_account(account_key)
				,constraint fk_int_date foreign key (date_key)references dim_date(date_key)
				,constraint pk_int primary key nonclustered (date_key,branch_key,account_key) 

		alter table Fact_Interest
			NOCHECK CONSTRAINT fk_int_branch, fk_int_account, fk_int_date;

	end