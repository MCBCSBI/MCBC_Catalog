--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_fact_balances'
declare @sql nvarchar(max) =
'drop table if exists Fact_Balances;
		create table Fact_Balances
		(
			timestamp
			--,Date_Key int not null
			--,Branch_Key int not null
			--,Account_Key int not null
			--,GL_Key int not null
			--,GL_Mapping_Key int not null
			,Balance_LCY decimal(19,2) 
			,Balance_FCY decimal(19,2) 
		)

		/*alter table Fact_Balances
			add 
				 constraint pk_Fact_Balances primary key nonclustered (timestamp,date_key,gl_mapping_key,Account_Key,branch_key)
				,constraint fk_Date_Key foreign key(Date_Key) references Dim_Date(Date_Key)
				,constraint fk_branch_Key foreign key(branch_Key) references Dim_Company(Company_Key)
				,constraint fk_GL_Mapping foreign key(gl_mapping_Key) references dim_gl_mapping(gl_mapping_key)
				,constraint fk_Bal_Account foreign key(Account_Key) references dim_Account(Account_key)

		alter table Fact_Balances
			NOCHECK CONSTRAINT fk_Date_Key, fk_branch_Key, fk_GL_Mapping, fk_Bal_Account;*/
			'

begin try
exec(
'create procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end try

begin catch
exec(
'alter procedure ' + @procname + 
' as begin '+ @sql + ' end'
)
end catch

--exec sp_fact_balances