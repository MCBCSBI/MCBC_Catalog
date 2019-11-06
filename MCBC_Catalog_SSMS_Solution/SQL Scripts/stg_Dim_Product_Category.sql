select 
	c.MIS_DATE
	,c.[@ID]
	,c.DESCRIPTION
	,c.SYSTEM_IND
	,c.POSITION_TYPE
from
	bs.CATEGORY c
where c.MIS_DATE = '2019-05-14'
order by convert(int,c.[@ID])