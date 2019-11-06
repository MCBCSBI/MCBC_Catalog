use insightlanding_sey

select 
	--b.LEAD_CO_MNE
	b.BRANCH_CO_MNE
	,b.MIS_DATE
	,cast(b.[LINE/CONTRACT] as nvarchar(150)) as [LINE/CONTRACT]
	,cast(b.CONSOL_KEY as nvarchar(150)) as CONSOL_KEY
	,cast(b.ASSET_TYPE as nvarchar(150)) as ASSET_TYPE
	,sum(CAST(b.LOCAL_CCY_AMT AS decimal(19,2))) as LOCAL_CCY_AMT
	,sum(CAST(b.CURRENCY_AMT as decimal(19,2))) as CURRENCY_AMT
from bnk_RE_CRF_GL b
where b.MIS_DATE = '2019-09-30'
group by
	b.LEAD_CO_MNE
	,b.BRANCH_CO_MNE
	,b.MIS_DATE
	,b.CONSOL_KEY
	,b.ASSET_TYPE
	,b.[LINE/CONTRACT]
