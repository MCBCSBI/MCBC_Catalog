use insightlanding_sey
go

--INSERT TABLES TO BE LOADED IN TEMPTABLE
drop table if exists temptable1
--select * from temptable1
create table temptable1
(
	ID int not null identity (1,1)
	,schema_name nvarchar(20)
	,table_name nvarchar(max)
)
go

with t as
(
	select
		cast(left(s.name,6)as int) as year_month
		,s.name as schema_name
		,t.name as table_name 
	from
		insightbi.insightlanding.sys.tables t 
			left join insightbi.insightlanding.sys.schemas s
				on t.schema_id = s.schema_id
	where 
		left(s.name,1) = '2'
		and cast(left(s.name,8)as int)  = 20180928
		and left(t.name,3) = 'BNK'
		--and t.name = 'BNK_CATEGORY'
		and t.name not in ( 'BNK_EB_CONTRACT_BALANCES')
		and t.name not like 'BNK_AA_ARR_PAYMENT_SCHEDULE%'
)

insert into temptable1
select
	t.schema_name
	,t.table_name
from t
go


--COPY TABLES IN NEW DATABASE
declare @counter int
declare @rowcount int

set @rowcount = (select count(*) from temptable1)
set @counter = 1

while @counter <= @rowcount
	begin
		declare
		@schema nvarchar(20), 
		@table nvarchar(max),
		@schematable nvarchar(max),
		@Sqlselectinto nvarchar(1000),
		@Sqlinsertinto nvarchar(1000),
		@Sqlcounttable nvarchar(1000)
		
		set @schema = (select schema_name from temptable1 where ID = @counter)
		set @table = (select table_name from temptable1 where ID = @counter)
		set @schematable =  '['+ @schema + ']' + '.' + @table

		--QUERIES TO COPY ALL SCHEMAS INTO 1 TABLE ONLY
		set @Sqlselectinto = 'select * into insightlanding_sey.dbo.' + @table + ' from insightbi.insightlanding.' + @schematable 
		set @Sqlinsertinto = 'insert into insightlanding_sey.dbo.' + @table + ' select * from insightbi.insightlanding.' + @schematable
		--set @Sqlcounttable = 'select count(*) from landingtemp.sys.tables where name='''+@table+''''

		begin try
			exec(@Sqlselectinto) -- if table not present, select into else insert into
		end try

		begin catch
			exec(@Sqlinsertinto)
		end catch

		set @counter = @counter + 1
	end

drop table if exists temptable1
