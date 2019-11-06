use MCBC_DW_Sey
go

declare @procname nvarchar(100) = 'sp_fact_balances_audit'
declare @sql nvarchar(max) =
'drop table if exists Fact_Balances_Audit

		create table Fact_Balances_Audit
				(
					Date datetime
					,Account nvarchar(200)
					--,GL_Key int not null
					,consol_key nvarchar(200)
					,asset_type nvarchar(200)
					,Balance_LCY decimal(19,2) null
					,Balance_FCY decimal(19,2) null
				)
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

--exec sp_Dim_Currency

