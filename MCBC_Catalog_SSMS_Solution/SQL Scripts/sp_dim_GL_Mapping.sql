--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_dim_gl_mapping'
declare @sql nvarchar(max) =
'Drop table if exists Dim_GL_Mapping

		create table Dim_GL_Mapping
		(
			GL_Mapping_Key int identity (1,1) not null,
			--GL_Key int not null,
			Consol_Key nvarchar(150) not null,
			Asset_Type nvarchar(50) not null,
			T24_Line_ID nvarchar(10),
			T24_Line_Desc nvarchar(75),
			COA_Mapping nvarchar(7),
			scd2_start datetime not null,
			scd2_end datetime ,
			scd2_hash char(66) not null
		)

		alter table dim_gl_mapping
			add constraint pk_gl_mapping primary key clustered (gl_mapping_key),
				constraint fk_dim_gl foreign key(gl_key) references dim_gl(gl_key)

		alter table dim_gl_mapping
			NOCHECK CONSTRAINT fk_dim_gl;'

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


