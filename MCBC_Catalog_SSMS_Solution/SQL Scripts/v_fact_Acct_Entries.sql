--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'v_fact_acct_entries'
declare @sql nvarchar(max) =
'select * from fact_acct_entries'

begin try
exec(
'create view ' + @procname + 
' as '+ @sql
)
end try

begin catch
exec(
'alter view ' + @procname + 
' as '+ @sql
)
end catch
	