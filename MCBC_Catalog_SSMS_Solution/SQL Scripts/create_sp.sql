declare @path nvarchar(1000) = 'C:\Users\yohram\Desktop\Y\Workbenches\MCBC_Catalog_workbench\trunk\MCBC_Catalog_SSMS_Solution\SQL Scripts\'
declare @filename nvarchar(100) = ?
declare @sql nvarchar(500) = 
'select * from openrowset(bulk' 
+''''
+ @path + @filename + '.sql'
+ ''''
+' ,single_clob) x'
exec(@sql)
