Declare @BusinessDate Date = '2019-05-31';

with com as
(

select distinct
	 [MIS_DATE]
	,[@ID]
	,[DESCRIPTION]
	--,CATEGORY_ACCOUNT
	--,TXN_CODE_CR
	--,TXN_CODE_DR
	--,t01.value as CURRENCY
	--,CASE WHEN t02.value='' THEN 0.00 else cast(t02.value as DECIMAL(27,2)) END as FLAT_AMT

from BS.FT_COMMISSION_TYPE c
/*		cross apply
	(
		select
			ROW_NUMBER() over (order by c.CURRENCY asc) as rw
			,t.value
		from
			string_split(c.CURRENCY,nchar(63741)) t
	)t01
		cross apply
	(
		select
			ROW_NUMBER() over (order by c.FLAT_AMT asc) as rw
			,t.value
		from
			string_split(c.FLAT_AMT,nchar(63741)) t
	)t02
where MIS_DATE=@BusinessDate
and t01.rw=t02.rw
--Dimension will hold only descriptions
*/ 
)


select 
	com.*,
	[Hash_SCD2]=
			isnull(
				convert(char(66),HASHBYTES('SHA2_256',concat(com.[@ID],com.[DESCRIPTION]--, com.CURRENCY, com.FLAT_AMT
				)),1),
				0
			) 
	from com
	