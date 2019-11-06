--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'v_dim_company'
declare @sql nvarchar(max) =
'select * from dim_company'

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

