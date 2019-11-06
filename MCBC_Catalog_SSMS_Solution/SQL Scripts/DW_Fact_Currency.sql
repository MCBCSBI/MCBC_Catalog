use insightlanding_sey
go

Declare @BusinessDate Date = '2019-09-30'

select 
	  [@ID] 
	 ,MIS_DATE
	 ,t00.value as CURRENCY_MARKET
	 ,CASE WHEN ISNUMERIC(t01.value)=1 THEN t01.value END as MID_REVAL_RATE
	 ,CASE WHEN ISNUMERIC(t02.value)=1 THEN t02.value END as BUY_RATE
	 ,CASE WHEN ISNUMERIC(t03.value)=1 THEN t03.value END as SELL_RATE
	 ,CASE WHEN ISNUMERIC(t04.value)=1 THEN t04.value END as NEGOTIABLE_AMT
	 

from bnk_CURRENCY c
cross apply
	(
		select
			ROW_NUMBER() over (order by c.Currency_Market asc) as rw
			,t.value
		from
			string_split(c.Currency_Market,nchar(63741)) t
	)t00
cross apply
	(
		select
			ROW_NUMBER() over (order by c.MID_REVAL_RATE asc) as rw
			,t.value
		from
			string_split(c.MID_REVAL_RATE,nchar(63741)) t
	)t01
	cross apply
	(
		select
			ROW_NUMBER() over (order by c.BUY_RATE asc) as rw
			,t.value
		from
			string_split(c.BUY_RATE,nchar(63741)) t
	)t02
	cross apply
	(
		select
			ROW_NUMBER() over (order by c.SELL_RATE asc) as rw
			,t.value
		from
			string_split(c.SELL_RATE,nchar(63741)) t
	)t03
	cross apply
	(
		select
			ROW_NUMBER() over (order by c.NEGOTIABLE_AMT asc) as rw
			,t.value
		from
			string_split(c.NEGOTIABLE_AMT,nchar(63741)) t
	)t04

where MIS_DATE=@BusinessDate
	and t00.rw = t01.rw
	and t01.rw = t02.rw
	and t02.rw = t03.rw
	and t03.rw = t04.rw

