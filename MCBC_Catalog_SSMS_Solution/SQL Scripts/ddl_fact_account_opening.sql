drop table if exists Fact_Account_Opening;
		create table Fact_Account_Opening
		(
			timestamp ,
			Date_Key int not null,
			Account_Key int not null,
			customer_key int not null,
		)

		alter table Fact_Account_Opening
			add --no primary keys added because you can have an account opened and closed on the same date
				constraint pk_fact_acc_op primary key nonclustered (timestamp,Date_Key, Account_Key, customer_Key) 

				--constraint fk_acc_opbranch foreign key (branch_key)references dim_company(company_key)
				--,constraint fk_acc_op_account foreign key(account_key) references dim_account(account_key)
				--,constraint fk_acc_op_date foreign key (date_key)references dim_date(date_key)


		--alter table Fact_Account_Opening
		--	NOCHECK CONSTRAINT fk_acc_opbranch, fk_acc_op_account, fk_acc_op_date;