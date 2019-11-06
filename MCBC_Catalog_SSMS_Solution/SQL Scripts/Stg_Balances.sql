with b as 
(
	select --distinct
		 g.MIS_DATE
		,g.LINE_ID
		,g.[LINE/CONTRACT]
		,g.CONSOL_KEY
		,g.ASSET_TYPE
		,g.CURRENCY
		,g.CURRENCY_AMT
		,g.LOCAL_CCY_AMT
	from
		bs.RE_CRF_GL g
	union all
	select --distinct
		 p.MIS_DATE
		,p.LINE_ID
		,p.[LINE/CONTRACT]
		,p.CONSOL_KEY
		,p.ASSET_TYPE
		,p.CURRENCY
		,p.CURRENCY_AMT
		,p.LOCAL_CCY_AMT
	from
		bs.RE_CRF_PL p
)

select 
	b.MIS_DATE,
	b.CONSOL_KEY,
	b.ASSET_TYPE,
	sum(b.LOCAL_CCY_AMT) as LOCAL_CCY_AMT,
	sum(b.CURRENCY_AMT) as CURRENCY_AMT
from b
--where b.LINE_ID ='SWBGL.0512' and b.MIS_DATE = '2019-05-14'
group by
	b.MIS_DATE,
	b.CONSOL_KEY,
	b.ASSET_TYPE
