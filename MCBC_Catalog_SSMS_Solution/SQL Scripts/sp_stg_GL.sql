--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_stg_gl'
declare @sql nvarchar(max) =
'drop table if exists staging_GL
		create table staging_GL
		(
			MIS_DATE datetime,
			[@ID] nvarchar(max),
			--[DESC] nvarchar(max),
			PASTEl_GLCODE nvarchar(max),
			Category0 nvarchar(max),
			Category1 nvarchar(max),
			Category2 nvarchar(max),
			Category3 nvarchar(max),
			Category4 nvarchar(max),
			[PastelGL_Description] nvarchar(max)
			,[Type] nvarchar(max)
			,[Common BS Category 1] nvarchar(max)
			,[Common BS Category 2] nvarchar(max)
			,[Common BS Category 3] nvarchar(max)
			,[Common PL category 0] nvarchar(max)
			,[Common PL Category 1] nvarchar(max)
			,[Common PL Category 1_1] nvarchar(max)

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


