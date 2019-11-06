declare @bdate date  = '2019-04-09';

drop table if exists Tab1;
drop table if exists Tab2;
drop table if exists Tab3;

Create table  Tab1 
(MIS_DATE DATE,
CURRENCY nvarchar(50),
BRANCH_CO_MNE nvarchar(50),
[@ID] bigint,
cfdate_full nvarchar(max),
cftype_full nvarchar(max),
cfamt_full nvarchar(max),
CASH_FLOW_DATE DATE,
CASH_FLOW_DATE_seq int
);

Create table  Tab2 
([@ID] bigint,
CURRENCY nvarchar(50),
CASH_FLOW_TYPE nvarchar(50),
CASH_FLOW_type_seq int
);

Create table  Tab3 
([@ID] bigint,
CURRENCY nvarchar(50),
CASH_FLOW_AMT_CCY nvarchar(50),
CASH_FLOW_amt_seq int
);

Insert into Tab1
	select  distinct
		c.MIS_DATE
		,c.CURRENCY
		,c.BRANCH_CO_MNE
		,c.[@ID]
		,c.CASH_FLOW_DATE
		,c.CASH_FLOW_TYPE
		,c.CASH_FLOW_AMT
		,concat(substring(t01.value,1,4),'-',substring(t01.value,5,2),'-',substring(t01.value,7,2)) as CASH_FLOW_DATE
		,t01.rw as CASH_FLOW_DATE_seq
	from
		bs.EB_CASHFLOW c
	cross apply
	(
		select  
			ROW_NUMBER() over (order by c.CASH_FLOW_DATE) as rw
			,t.value
		from
			string_split(c.CASH_FLOW_DATE,nchar(63741)) t
	)t01 where c.MIS_DATE = @bdate

Insert into Tab2
	select  distinct
		c.[@ID]
		,c.CURRENCY
		,t02.value CASH_FLOW_TYPE
		,t02.rw as CASH_FLOW_type_seq
	from
		bs.EB_CASHFLOW c
	cross apply
	(
		select
			ROW_NUMBER() over (order by c.CASH_FLOW_TYPE) as rw
			,t.value
		from
			string_split(c.CASH_FLOW_TYPE,nchar(63741)) t
	)t02 where c.MIS_DATE = @bdate

Insert into Tab3
	select distinct
		c.[@ID]
		,c.CURRENCY
		,CAST(t03.value as NVARCHAR(50)) as CASH_FLOW_AMT_CCY
		,t03.rw as CASH_FLOW_amt_seq

	from
		bs.EB_CASHFLOW c
	cross apply
	(
		select
			ROW_NUMBER() over (order by c.CASH_FLOW_AMT) as rw
			,t.value
		from
			string_split(c.CASH_FLOW_AMT,nchar(63741)) t
	)t03 where c.MIS_DATE = @bdate


select 
	a.MIS_DATE,
	a.BRANCH_CO_MNE,
	a.[@ID],
	a.CURRENCY,
	a.CASH_FLOW_DATE,
	b.CASH_FLOW_TYPE,
	c.CASH_FLOW_AMT_CCY
from Tab1 a
	left join Tab2 b
		on a.[@ID] = b.[@ID] --join the same sequence over each unique identifier
			and a.CASH_FLOW_DATE_seq = b.CASH_FLOW_type_seq
	left join Tab3 c
		on a.[@ID] = c.[@ID]
			and a.CASH_FLOW_DATE_seq = c.CASH_FLOW_amt_seq
where a.[@id] = '77401100612'