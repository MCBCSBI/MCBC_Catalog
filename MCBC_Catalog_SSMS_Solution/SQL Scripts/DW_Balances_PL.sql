select 
	--b.LEAD_CO_MNE
	b.BRANCH_CO_MNE
	,b.MIS_DATE
	,convert(int,b.[LINE/CONTRACT]) as PL_CATEGORY
	,convert(int,b.Consol_Key03) as PRODUCT_CATEGORY
	,b.LINE_ID
	,b.CONSOL_KEY
	,b.ASSET_TYPE as CURRENCY
	,sum(CAST(b.LOCAL_CCY_AMT AS decimal(19,2))) as LOCAL_CCY_AMT
	,sum(CAST(b.CURRENCY_AMT as decimal(19,2))) as CURRENCY_AMT
from bs.RE_CRF_PL b
--where b.MIS_DATE = '2019-05-14'
group by
	b.BRANCH_CO_MNE
	,b.MIS_DATE
	,b.CONSOL_KEY
	,b.ASSET_TYPE
	,b.[LINE/CONTRACT]
	,b.Consol_Key03
	,b.LINE_ID
