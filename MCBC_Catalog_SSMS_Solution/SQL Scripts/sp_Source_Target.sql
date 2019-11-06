alter procedure sp_source_target @tablename nvarchar(50)
as
select
	t.name as Table_Name
	,c.name as Column_name
	,y.name as data_type
	,c.max_length
	,c.precision
	,c.is_nullable
from sys.columns c
	left join sys.tables t
		on c.object_id = t.object_id
	left join sys.types y
		on c.system_type_id = y.system_type_id	
	left join sys.key_constraints k
		on c.object_id = k.parent_object_id
where 
	t.name = 'Dim_Account'-- @tablename
	and y.name <> 'sysname'
order by c.column_id