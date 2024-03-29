--declare @dt date = '2019-09-30';
declare @dt date = ?;

/*PRIMARY CUSTOMERS FOR ACCOUNTS*/
with c as (
	select 
		a.MIS_DATE,
		a.[@ID] as account_id
		,a.CUSTOMER
		,1 as IsPrimary -- 1 = true
	from BNK_ACCOUNT a
	where 
		a.MIS_DATE = @dt
),

/*JOINT CUSTOMERS FOR ACCOUNTS*/
j as (
	select 
		a.MIS_DATE,
		a.[@ID] as account_id
		--,a.CUSTOMER
		--,a.JOINT_HOLDER
		,t01.value as joint_customer_split
		,0 as IsPrimary
		--,t01.rw as seq_no
	from BNK_ACCOUNT a
	cross apply(
		select
			ROW_NUMBER() over (order by a.JOINT_HOLDER) as rw,
			t.value
		from string_split(a.JOINT_HOLDER,nchar(63741)) t
	)t01
	where 
		MIS_DATE = @dt
		--and len(a.joint_holder) >10
		--and a.[@ID] = '137154'
),


u as (
	select u.*
	from (
		select 
			c.MIS_DATE,
			c.[account_id]
			,c.CUSTOMER
			,c.IsPrimary
		from c

		union -- the union works because the same customer cannot be joint and primary at the same time on the same account id

		select
			j.MIS_DATE,
			j.account_id
			,j.joint_customer_split as Customer
			,j.IsPrimary
		from j
	)u
)

select 
	g.MIS_DATE
	,isnull(u.customer,g.CUSTOMER) as customer_all --for non-account contracts such as MM TF etc, use the customer number that is in RE CRF GL
	,isnull(u.IsPrimary,1) as IsPrimary --for non account contracts, default primary to 1
	,cast(g.[LINE/CONTRACT] as nvarchar(25)) as [LINE/CONTRACT]
	,cast(g.ASSET_TYPE as nvarchar(20)) as ASSET_TYPE
	,cast(g.CURRENCY as nvarchar(3)) as CURRENCY
	,g.CURRENCY_AMT
	,g.LOCAL_CCY_AMT 
from 
	BNK_RE_CRF_GL g
	left join u
		on g.[LINE/CONTRACT] = u.account_id
		and g.MIS_DATE = u.MIS_DATE
where 
	g.MIS_DATE = @dt 
	and g.CONSOL_KEY not like 'PL%' -- remove PL consol keys
	




