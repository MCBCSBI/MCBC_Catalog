Declare @dt date = ?;
--Declare @dt Date =  '2019-09-30';

with a as(
/*ACCOUNTS*/
select 
	t.MIS_DATE
	,t.[@ID] as account_no
	,t.ARRANGEMENT_ID as ACCOUNT_CONTRACT_ID
	,t.ACCOUNT_TITLE_1
	,t.CATEGORY
	,c.description as CATEGORY_DESC
	,t.CURRENCY as Currency_Denomination
	,t.CUSTOMER
	,t.JOINT_HOLDER
	,cast(t.OPENING_DATE as date) as OPENING_DATE
	,d.MATURITY_DATE
	,cl.ACCT_CLOSE_DATE as CLOSE_DATE
	,t.INACTIV_MARKER
	--,null as INTEREST
	--,null as PENALTY_INTEREST
	--,CASE WHEN Overdrawn_Account.ACCOUNT_ID is not null THEN N'Y' ELSE N'N' END as Overdrawn_Flag
	,t.CO_CODE as BRANCH_CODE
	,co.COMPANY_NAME as BRANCH_NAME
from
	dbo.BNK_ACCOUNT t
	left join bnk_category c
		on c.[@id] = t.category
		and c.mis_date = t.mis_date
	left join bnk_company co
		on co.[@id] = t.co_code
		and co.mis_date = t.mis_date
	left join BNK_AA_ACCOUNT_DETAILS d
		on d.MIS_DATE = t.MIS_DATE
		and d.[@ID] = t.ARRANGEMENT_ID
	left join BNK_ACCOUNT_CLOSED cl
		on cl.MIS_DATE = t.MIS_DATE
		and cl.[@ID] = t.[@ID]
where 
	t.MIS_DATE = @dt

),

l as (
/*LETTER OF CREDIT*/
	select
	t.MIS_DATE
	,t.[@ID] as account_no
	,t.[@ID] as account_contract_id
	,null as account_title
	,t.CATEGORY_CODE as CATEGORY
	,c.description as CATEGORY_DESC
	,t.LC_CURRENCY as Currency_Denomination
	,t.CON_CUS_LINK as CUSTOMER
	,null as JOINT_HOLDER
	,t.ISSUE_DATE as opening_date
	,null as MATURITY_DATE
	,null as CLOSE_DATE
	,null as INACTIV_MARKER
	,t.CO_CODE as BRANCH_CODE
	,co.COMPANY_NAME as BRANCH_NAME
	--,*
	from
		BNK_LETTER_OF_CREDIT t
		left join bnk_category c
			on c.[@id] = t.CATEGORY_CODE
			and c.mis_date = t.mis_date
		left join bnk_company co
			on co.[@id] = t.co_code
			and co.mis_date = t.mis_date
	where 
		t.MIS_DATE = @dt
),

m as (
/*MONEY MARKET*/
	select 
		t.MIS_DATE,
		t.[@id] as account_no
		,t.[@ID] as account_contract_id
		,null as ACCOUNT_TITLE_1
		,t.CATEGORY
		,c.description as CATEGORY_DESC
		,t.CURRENCY as Currency_Denomination
		,t.CUSTOMER_ID as CUSTOMER
		,null as JOINT_HOLDER
		,t.DEAL_DATE
		,isnull(t.ROLLOVER_DATE,t.MATURITY_DATE) as MATURITY_DATE
		,null as CLOSE_DATE
		,null as INACTIV_MARKER
		,t.CO_CODE as BRANCH_CODE
		,co.COMPANY_NAME as BRANCH_NAME

	from
		BNK_MM_MONEY_MARKET t
		left join bnk_category c
			on c.[@id] = t.category
			and c.mis_date = t.mis_date
		left join bnk_company co
			on co.[@id] = t.co_code
			and co.mis_date = t.mis_date
	where t.MIS_DATE = @dt
),

f as (
/*FOREX*/
	select 
		t.MIS_DATE,
		t.[@id] as account_no
		,t.[@ID] as account_contract_id
		,null as ACCOUNT_TITLE_1
		,t.CATEGORY_CODE
		,c.description as CATEGORY_DESC
		,null as Currency_Denomination
		,t.COUNTERPARTY as CUSTOMER
		,null as JOINT_HOLDER
		,t.DEAL_DATE
		,case 
			when t.VALUE_DATE_BUY > t.VALUE_DATE_SELL
			then t.VALUE_DATE_BUY
			else t.VALUE_DATE_SELL
		end as MATURITY_DATE
		,null as CLOSE_DATE
		,null as INACTIV_MARKER
		,t.CO_CODE as BRANCH_CODE
		,co.COMPANY_NAME as BRANCH_NAME

	from
		BNK_FOREX t
		left join bnk_category c
			on c.[@id] = t.CATEGORY_CODE
			and c.mis_date = t.mis_date
		left join bnk_company co
			on co.[@id] = t.co_code
			and co.mis_date = t.mis_date
	where t.MIS_DATE = @dt

),

u as (
	select * from a
	union
	select * from l
	union
	select * from m
	union
	select * from f
)


select
	u.mis_date,
	u.account_no
	,u.account_contract_id
	,u.account_title_1
	,u.CATEGORY
	,u.CATEGORY_DESC
	,u.Currency_Denomination
	,u.OPENING_DATE
	,u.MATURITY_DATE
	,u.CLOSE_DATE
	,u.branch_code
	,u.BRANCH_NAME
	,isnull(convert(char(66),HASHBYTES('SHA2_256',concat(
	u.account_no
	,u.account_contract_id
	,u.account_title_1
	,u.CATEGORY
	,u.CATEGORY_DESC
	,u.Currency_Denomination
	,u.OPENING_DATE
	,u.MATURITY_DATE
	,u.CLOSE_DATE
	,u.branch_code
	,u.BRANCH_NAME
				)),1),0) as Hash_SCD2
from u

--where 
	--a.MIS_DATE = @dt
	--and CATEGORY like '1%'
	--and [@id] = '104078'
	--and len(ac.JOINT_HOLDER) >8
	--and (ac.CUSTOMER = '7488486' or ac.JOINT_HOLDER LIKE '%7488486%')