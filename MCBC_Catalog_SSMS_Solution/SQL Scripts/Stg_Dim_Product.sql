use insightlanding_sey
go

Declare @BusinessDate Date = '2019-09-30';

with data as (
--select 
--		 s.MIS_DATE
--		,s.[@ID]
--		,s.DESCRIPTION
--from bs.SUB_ASSET_TYPE s
--where s.MIS_DATE=@BusinessDate
--union
select 
	c.MIS_DATE
	,c.[@ID]
	,c.DESCRIPTION
from bnk_CATEGORY c
where c.MIS_DATE = @BusinessDate

)

select 
		*
 from data
order by [@ID]

