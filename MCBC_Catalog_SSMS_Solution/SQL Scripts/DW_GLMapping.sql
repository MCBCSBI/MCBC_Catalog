use insightlanding_sey

declare @businessdate date  = '2019-09-30';
with b as 
(
	select --distinct
		 g.MIS_DATE
		,g.LINE_ID
		,r.K_DESC as full_line
		,right(r.k_desc,len(r.k_desc)-12) as line_desc
		,SUBSTRING(r.K_DESC,5,8) as Pastel_GL
		,g.[LINE/CONTRACT]
		,g.CONSOL_KEY
		,g.ASSET_TYPE
		--,g.CURRENCY
		--,g.CURRENCY_AMT
		--,g.LOCAL_CCY_AMT
	from
		dbo.BNK_RE_CRF_GL g
		left join dbo.BNK_RE_STAT_REP_LINE r
		on g.MIS_DATE = r.MIS_DATE
		and g.LINE_ID = r.[@ID]
	where g.MIS_DATE = @businessdate
	--union all
	--select --distinct
	--	 p.MIS_DATE
	--	,p.LINE_ID
	--	,p.[LINE/CONTRACT]
	--	,p.CONSOL_KEY
	--	,p.ASSET_TYPE
	--	,p.CURRENCY
	--	,p.CURRENCY_AMT
	--	,p.LOCAL_CCY_AMT
	--from
	--	dbo.BNK_RE_CRF_PL p
	--where p.MIS_DATE = @businessdate
)

select distinct
	 b.MIS_DATE
	,cast(b.CONSOL_KEY as nvarchar(150)) as CONSOL_KEY
	,cast(b.ASSET_TYPE as nvarchar(150)) as ASSET_TYPE
	,b.LINE_ID
	,b.line_desc
	,b.Pastel_GL
	,[Hash_SCD2]=
	isnull(
		convert(char(66),HASHBYTES('SHA2_256',concat(
		b.CONSOL_KEY,
		b.ASSET_TYPE,
		b.LINE_ID,
		b.LINE_DESC,
		b.Pastel_GL
		)),1),
		0
	)
from
	b
where left(b.CONSOL_KEY,2) <> 'PL'--excluding PL consol keys
