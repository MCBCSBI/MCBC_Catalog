--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'v_dim_gl_mapping'
declare @sql nvarchar(max) =
'select * from dim_gl_mapping'

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
	