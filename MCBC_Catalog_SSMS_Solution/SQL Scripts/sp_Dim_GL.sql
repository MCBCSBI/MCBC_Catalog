--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_dim_gl'
declare @sql nvarchar(max) =
'drop table if exists Dim_GL

			create table Dim_GL
			(
				GL_Key int identity (1,1) not null,
				T24_Line_No nvarchar(15) not null,
				Pastel_Code nvarchar(7) not null,
				GL_Description nvarchar(65) not null,
				Category0 nvarchar(100),
				Category1 nvarchar(100),
				Category2 nvarchar(100),
				Category3 nvarchar(100),
				Category4 nvarchar(100),
				[Type] nvarchar(2),
				Common_BS_Category_1 nvarchar(100),
				Common_BS_Category_2 nvarchar(100),
				Common_BS_Category_3 nvarchar(100),
				Common_PL_Category_0 nvarchar(100),
				Common_PL_Category_1 nvarchar(100),
				Common_PL_Category_1_1 nvarchar(100),
				scd2_start datetime not null,
				scd2_end datetime ,
				scd2_hash char(66) not null
			)

			alter table Dim_GL
				add constraint pk_Dim_GL primary key clustered (GL_Key)'

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


