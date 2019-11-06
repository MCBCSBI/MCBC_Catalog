use MCBC_DW_Sey
go
create table Control_Table
(
	Table_name nvarchar(100) not null,
	Last_Execution_Date datetime,
	Last_Date_Loaded datetime
)

insert into Control_Table(Table_name)
	values
		--('Dim_GL'),
		--('Fact_Balances'),
		('Dim_Customer')
		--('Dim_GL_Mapping')

update Control_Table
	set Last_Date_Loaded = '1900-01-01' where Last_Date_Loaded is null

update Control_Table
	set Last_Execution_Date = '1900-01-01' where Last_Execution_Date is null

--select * from Control_Table


