--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'v_dim_date'
declare @sql nvarchar(max) =
'select * from dim_date'

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

