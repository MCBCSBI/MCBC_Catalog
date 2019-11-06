--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_dim_company'
declare @sql nvarchar(max) =
'drop table if exists Dim_Company

		create table Dim_Company
		(
			Company_Key int not null identity (1,1)
			,Company_ID nvarchar(11) not null
			,Company_name nvarchar(22) not null
			,Company_Address nvarchar(35)
			,Company_Mnemonic nvarchar(3) not null
			,scd2_start datetime not null
			,scd2_end datetime
			,scd2_hash char(66) not null
		)

		alter table Dim_Company
			add constraint pk_Dim_Company primary key clustered (Company_key)'

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

