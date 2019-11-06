declare @businessdate date = '2019-05-31';
with d as 
(
	select
		'DC' as Tran_Group 
		,d.[@ID]
		,d.CUSTOMER_ID
		,d.CURRENCY
		,d.CURRENCY_MARKET
		,null as customer_2
		,null as currency_2
		,null as currency_market_2
		,convert(nvarchar(10),d.TRANSACTION_CODE) as TRANSACTION_CODE
		,d.AMOUNT_FCY
		,AMOUNT_LCY
	from [InsightLanding].[BS].[DATA_CAPTURE] D
	where MIS_DATE = @businessdate
)

,s as
(
	select
		'SC' as Tran_Group
		,s.[@ID]
		,s.CUSTOMER_NO
		,s.SECURITY_CURRENCY
		,null as currency_market
		,null as customer_2
		,null as currency_2
		,null as currency_market_2
		,s.CUST_TRANS_CODE
		,s.CU_NET_AM_TRD as amount_fcy
		,case when s.SECURITY_CURRENCY = 'SZL' then s.CU_NET_AM_TRD else null end as amount_lcy
	from bs.SEC_TRADE s 
	where MIS_DATE = @businessdate
)
,t as
(
	select
		'TT' as Tran_Group
		,t.[@ID]
		,t.CUSTOMER_1
		,t.CURRENCY_1
		,t.CURR_MARKET_1
		,t.CUSTOMER_2
		,t.CURRENCY_2
		,t.CURR_MARKET_2
		,convert(nvarchar(10),t.TRANSACTION_CODE) as TRANSACTION_CODE
		,t.AMOUNT_FCY_1
		,t.AMOUNT_LOCAL_1
	from bs.TELLER t
	where t.MIS_DATE = @businessdate
)

select *
from
(
	select * from d
union
	select * from s
union
	select * from t
) t