--use insightlanding_sey
--go

select
	c.MIS_DATE
	,c.[@ID]
	,c.COMPANY_NAME
	,c.NAME_ADDRESS
	,c.MNEMONIC
	,HASH_SCD2 = isnull(convert(char(66),HASHBYTES('SHA2_256',CONCAT(c.[@ID],c.COMPANY_NAME,c.NAME_ADDRESS,c.MNEMONIC)),1),0)
from
	bnk_COMPANY c

--where c.MIS_DATE = ?