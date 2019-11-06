--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_stg_product'
declare @sql nvarchar(max) =
'drop table if exists staging_Product
		create table staging_Product
		(
			MIS_DATE datetime,
			[@ID] nvarchar(25),
			[DESCRIPTION] nvarchar(max),
			Category_Group_1 nvarchar(max),


		)'

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


