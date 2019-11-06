alter procedure sp_Fact_Account_Opening
as
	begin

		drop table if exists Fact_Account_Opening;
		create table Fact_Account_Opening
		(
			Branch_Key int not null,
			Account_Key int not null,
			Date_Key int not null,
			Action nvarchar(15)
		)

		alter table Fact_Account_Opening
			add --no primary keys added because you can have an account opened and closed on the same date
				constraint fk_acc_opbranch foreign key (branch_key)references dim_company(company_key)
				,constraint fk_acc_op_account foreign key(account_key) references dim_account(account_key)
				,constraint fk_acc_op_date foreign key (date_key)references dim_date(date_key)


		alter table Fact_Account_Opening
			NOCHECK CONSTRAINT fk_acc_opbranch, fk_acc_op_account, fk_acc_op_date;

	end

--exec sp_Fact_Account_Opening
--truncate table Fact_Account_Opening