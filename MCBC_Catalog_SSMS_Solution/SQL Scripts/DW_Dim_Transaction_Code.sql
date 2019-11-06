Declare @BusinessDate Date = '2019-09-30';

with t as
(

--select 
--	 [MIS_DATE]
--	,[@ID]
--	,[DESCRIPTION] NARRATIVE

--from bnk_RE_TXN_CODE
--where MIS_DATE=@BusinessDate

--union

select 
	 [MIS_DATE]
	,[@ID]
	,[NARRATIVE]

from bnk_TRANSACTION
where MIS_DATE=@BusinessDate
)

select 
	t.*,
	[Hash_SCD2]=
			isnull(
				convert(char(66),HASHBYTES('SHA2_256',concat(t.[@ID],t.NARRATIVE)),1),
				0
			) 
	from t

