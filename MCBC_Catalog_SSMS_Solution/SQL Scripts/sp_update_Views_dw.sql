--use MCBC_DW_Sey
--go

declare @procname nvarchar(100) = 'sp_update_views_DW'
declare @sql nvarchar(max) =
'drop table if exists #views_update;

create table #views_update
(
	ID int identity(1,1)
	,View_Name nvarchar(100)
);

insert into #views_update(view_name)
	select name from sys.views;

declare 
	@no_of_rows int
	,@current_view nvarchar(100)
	,@counter int
set @no_of_rows = (select count(*) from #views_update)
set @counter = 1

while @counter <= @no_of_rows
begin
	set @current_view =(select View_Name from #views_update where ID = @counter);
	exec sp_refreshview @current_view
	set @counter = @counter + 1;
end
'

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

