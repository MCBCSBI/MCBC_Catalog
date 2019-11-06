Declare @businessDate Date ='2019-04-09'

select 
		 tt.[@ID]
		,tt.MIS_DATE
		,t01.value as CURRENCY
		,CAST(DEF_FCY_EQV_LIM as DECIMAL(19,2)) DEF_FCY_EQV_LIM
		,CAST(LOCAL_CCY_LIMIT as DECIMAL(19,2)) LOCAL_CCY_LIMIT
		,TILL_LIMIT 
		,CASE WHEN ISNUMERIC(t00.value)=1 THEN CAST(t00.value as DECIMAL(19,2)) else 0.00 END as TILL_BALANCE


from bs.TELLER_ID tt

cross apply
	(
		select
			ROW_NUMBER() over (order by tt.TILL_BALANCE asc) as rw
			,t.value
		from
			string_split(tt.TILL_BALANCE,nchar(63741)) t
	)t00

cross apply
	(
		select
			ROW_NUMBER() over (order by tt.CURRENCY asc) as rw
			,t.value
		from
			string_split(tt.CURRENCY,nchar(63741)) t
	)t01


where MIS_DATE=@BusinessDate
	and t00.rw = t01.rw



