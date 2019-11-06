--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_dim_currency'
declare @sql nvarchar(max) =
'drop table if exists dim_currency
	create table Dim_Currency
	(
		 Currency_Key int not null identity (1,1)
		,Currency_ID nvarchar(3) not null
		,Currency_Code nvarchar(3)
		,Currency_Name nvarchar(35)
		,Currency_Market nvarchar(3)
		,Interest_Day_Basis nvarchar(12)
		,Country_Code nvarchar(2)
		,scd2_start datetime 
		,scd2_end datetime 
		,scd2_hash char(66) not null
	)

	alter table dim_currency
		add
			 constraint pk_dim_currency primary key clustered(Currency_Key)

			 set identity_insert dim_currency on

		insert into Dim_Currency(Currency_Key,Currency_ID,Scd2_Hash)
			values
				(-1,-1,-1)'

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

--exec sp_Dim_Currency

