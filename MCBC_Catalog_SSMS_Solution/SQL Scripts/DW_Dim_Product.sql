use MCBC_Staging_Sey
go

select
	p.MIS_DATE
	,p.[@ID]
	,p.DESCRIPTION
	,p.Category_Group_1,
	[Hash_SCD2]=
	isnull(
		convert(char(66),HASHBYTES('SHA2_256',concat(p.[@ID],p.DESCRIPTION,p.Category_Group_1)),1),
		0
	)
from staging_Product p
order by p.[@ID]