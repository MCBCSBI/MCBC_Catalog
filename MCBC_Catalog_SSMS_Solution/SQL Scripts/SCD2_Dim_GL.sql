drop table if exists SCD2_Dim_GL
create table SCD2_Dim_GL
(
	GL_Key_old int not null,
	End_Date datetime not null
)


--select * from SCD2_Dim_GL