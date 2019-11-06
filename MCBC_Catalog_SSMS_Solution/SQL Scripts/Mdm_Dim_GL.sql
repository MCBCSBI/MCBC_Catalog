select
	CONVERT(date,g.EnterDateTime) as Date
	,g.*
from
	mdm.finance_gl g
where 
	--g.Code = 'SWBGL.0030'
	g.LastChgUserName is null