alter procedure sp_fact_collateral
as
begin
	drop table if exists fact_collateral;
	create table Fact_Collateral
	(
		DateKey int not null,
		Collateral_Key int not null,
		Branch_Key int not null,
		Provider_Customer_Key int not null,
		Beneficiary_Customer_Key int not null,
		Account_Key int not null,
		Nominal_Value decimal(19,2),
		Maximum_Value decimal(19,2),
		Execution_Value decimal(19,2),
	);
	
	alter table fact_collateral
	add
		constraint pk_fact_coll primary key nonclustered(DateKey,Collateral_Key,Branch_Key,Provider_Customer_Key,Beneficiary_Customer_Key,Account_Key)
		,constraint fk_coll_key foreign key(Collateral_Key) references dim_collateral(Collateral_Key)
		,constraint fk_c_branch_key foreign key(branch_key) references dim_company(Company_Key)
		,constraint fk_p_cust_key foreign key(Provider_Customer_Key) references dim_customer(Customer_Key)
		,constraint fk_b_cust_key foreign key(Beneficiary_Customer_Key) references dim_customer(Customer_Key)
		,constraint fk_coll_acct_key foreign key(Account_Key) references dim_Account(Account_Key)

		alter table fact_collateral
			NOCHECK CONSTRAINT fk_coll_key, fk_c_branch_key, fk_p_cust_key, fk_b_cust_key, fk_coll_acct_key;


end