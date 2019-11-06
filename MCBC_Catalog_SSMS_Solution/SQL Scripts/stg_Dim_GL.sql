use insightlanding_sey
go

declare @businessdate date = '2019-09-30'

select distinct 
	l.MIS_DATE
	,l.[@ID]
	--,l.[k_DESC]
	--,CHARINDEX(' ',[desc])
	,SUBSTRING([k_DESC],CHARINDEX(' ',[k_desc])+1,7) as  Pastel_GL
	,SUBSTRING([k_DESC],CHARINDEX(' ',[k_desc])+1,50) as  Pastel_GL_Desc
from
	bnk_RE_STAT_REP_LINE l

where 
	TYPE = 'DETAIL' -- detail lines only as those contain balances
	and MIS_DATE = @businessdate
