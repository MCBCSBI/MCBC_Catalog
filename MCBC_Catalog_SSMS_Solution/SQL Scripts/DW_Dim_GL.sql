use MCBC_Staging_Sey

select distinct 
	l.MIS_DATE
	,l.[@ID]
	,l.PASTEl_GLCODE
	,l.PastelGL_Description
	,l.[Type]
	,l.Category0
	,l.Category1
	,l.Category2
	,l.Category3
	,l.Category4
	,l.[Common BS Category 1]
	,l.[Common BS Category 2]
	,l.[Common BS Category 3]
	,l.[Common PL category 0]
	,l.[Common PL Category 1]
	,l.[Common PL Category 1_1]
	,[Hash_SCD2]=
	isnull(
		convert(char(66),HASHBYTES('SHA2_256',concat(l.[@ID]
	,l.PASTEl_GLCODE
	,l.PastelGL_Description
	,l.[Type]
	,l.Category0
	,l.Category1
	,l.Category2
	,l.Category3
	,l.Category4
	,l.[Common BS Category 1]
	,l.[Common BS Category 2]
	,l.[Common BS Category 3]
	,l.[Common PL category 0]
	,l.[Common PL Category 1]
	,l.[Common PL Category 1_1])),1),
		0
	)
from
	staging_GL l
