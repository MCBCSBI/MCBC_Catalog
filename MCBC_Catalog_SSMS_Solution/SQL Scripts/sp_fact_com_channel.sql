--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_fact_com_channel'
declare @sql nvarchar(max) =
'drop table if exists Fact_com_channel;
		create table Fact_com_channel
		(
			timestamp
			,Date_Key int not null
			,Customer_Key int not null
			,pref_com_channel nvarchar(50)
		)

		alter table Fact_com_channel
			add 
				 constraint pk_fact_com_channel primary key nonclustered (timestamp,date_key,customer_key)
				 ,constraint fk_date_key foreign key(date_key) references dim_date(date_key)
				 ,constraint fk_Customer_key foreign key(customer_key) references dim_customer(customer_key)

		alter table Fact_com_channel
			NOCHECK CONSTRAINT 
				fk_date_key
				,fk_customer_key
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

--exec sp_fact_com_channel