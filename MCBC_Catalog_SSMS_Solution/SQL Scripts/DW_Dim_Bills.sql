--use InsightLanding
--go
select
	 b.MIS_DATE
	,b.[@ID]
	--,b.ARRANGEMENT_ID
	--,b.PAYMENT_DATE
	--,b.ACTUAL_PAY_DATE
	--,b.CURRENCY
	,t01.value as BILL_STATUS
	,SUBSTRING(t02.value,1,4) + '-' +
 SUBSTRING(t02.value,5,2) + '-' + SUBSTRING(t02.value,7,2) as BILL_ST_CHG_DT
	,t03.value as SETTLE_STATUS
	,t04.value as SET_ST_CHG_DT
	,t05.value as AGING_STATUS
	,t06.value as AGING_ST_CHG_DT
	,[Hash_SCD2]=
			isnull(
				convert(char(66),HASHBYTES('SHA2_256',concat(b.[@ID],t01.value,t02.value,t03.value,t04.value,t05.value,t06.value)),1),
				0
			)

from 
	bs.AA_BILL_DETAILS b 
	cross apply
	(
		select
			ROW_NUMBER() over (order by b.BILL_STATUS asc) as rw
			,t.value
		from
			string_split(b.BILL_STATUS,nchar(63741)) t
	)t01
	cross apply
	(
		select
			ROW_NUMBER() over (order by b.BILL_ST_CHG_DT asc) as rw
			,t.value
		from
			string_split(b.BILL_ST_CHG_DT,nchar(63741)) t
	)t02
	cross apply
	(
		select
			ROW_NUMBER() over (order by b.SETTLE_STATUS asc) as rw
			,t.value
		from
			string_split(b.SETTLE_STATUS,nchar(63741)) t
	)t03
	cross apply
	(
		select
			ROW_NUMBER() over (order by b.SET_ST_CHG_DT asc) as rw
			,t.value
		from
			string_split(b.SET_ST_CHG_DT,nchar(63741)) t
	)t04
	cross apply
	(
		select
			ROW_NUMBER() over (order by b.AGING_STATUS asc) as rw
			,t.value
		from
			string_split(b.AGING_STATUS,nchar(63741)) t
	)t05
	cross apply
	(
		select
			ROW_NUMBER() over (order by b.AGING_ST_CHG_DT asc) as rw
			,t.value
		from
			string_split(b.AGING_ST_CHG_DT,nchar(63741)) t
	)t06
where 
	--[@ID] = 'AABILL19025LRZ9R' and
	b.MIS_DATE = '2019-05-20'
	and t01.rw = 1
	and t02.rw = 1
	and t03.rw = 1
	and t04.rw = 1
	and t05.rw = 1
	and t06.rw = 1	