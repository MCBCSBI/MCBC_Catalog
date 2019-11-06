alter procedure sp_fact_balances_pl
as
	begin

		drop table if exists fact_balances_pl;
		create table Fact_Balances_PL
		(
			Date_Key int not null
			,Branch_Key int not null
			,PL_Category_Key int not null
			,Product_Category_Key int not null
			,GL_Mapping_Key int not null
			,Balance_LCY decimal(19,2) not null
			,Balance_FCY decimal(19,2) not null
		)

		alter table fact_balances_pl
			add 
				 constraint pk_fact_balances_pl primary key nonclustered (date_key,gl_mapping_key,branch_key,pl_category_key,product_category_key)
				,constraint fk_Date_Key_pl foreign key(Date_Key) references Dim_Date(Date_Key)
				,constraint fk_branch_Key_pl foreign key(branch_Key) references Dim_Company(Company_Key)
				,constraint fk_GL_Mapping_pl foreign key(gl_mapping_Key) references dim_gl_mapping(gl_mapping_key)
				,constraint fk_pl_cat foreign key(pl_category_key) references dim_product(product_key)
				,constraint fk_prod_cat foreign key(pl_category_key) references dim_product(product_key)

		alter table fact_balances_pl
			NOCHECK CONSTRAINT fk_Date_Key_pl, fk_branch_Key_pl, fk_GL_Mapping_pl, fk_pl_cat, fk_prod_cat;

	end

--exec sp_fact_balances_pl
--truncate table fact_balances_pl