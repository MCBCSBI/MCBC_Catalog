--use insightlanding_sey
--go

with c as (
	select
		c.MIS_DATE
		,c.[@ID]
		--,c.LOCAL_REF
		,t01.value, t01.rw
	from bnk_customer c
	--inner join BNK_ACCOUNT a
	--	on c.MIS_DATE = a.MIS_DATE
	--	and c.[@ID] = a.CUSTOMER
	cross apply
	(
		select 
			t.value
			,ROW_NUMBER() over (order by c.LOCAL_REF) as rw
		from string_split(c.LOCAL_REF,nchar(63741)) t
	)t01
	where t01.rw in (23)
)

select 
	c.MIS_DATE
	,c.[@ID]
	,c.value as PREF_COM_CHAN
from  c 

where c.MIS_DATE = '2019-09-30'