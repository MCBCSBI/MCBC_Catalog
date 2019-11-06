drop table if exists SCD2_Dim_GL_Mapping
create table SCD2_Dim_GL_Mapping
(
	GL_Mapping_Key_old int not null,
	End_Date datetime not null
)

