--Declare @dt date = ?;
Declare @dt Date =  '2019-09-30';

with a as(
/*ACCOUNTS*/
select 
	ac.MIS_DATE
	,ac.[@ID] as account_no
	,ac.ARRANGEMENT_ID as ACCOUNT_CONTRACT_ID
	,ac.ACCOUNT_TITLE_1
	,ac.CATEGORY
	,c.description as CATEGORY_DESC
	,ac.CURRENCY
	,ac.CUSTOMER
	,ac.JOINT_HOLDER
	,cast(ac.OPENING_DATE as date) as OPENING_DATE
	,ac.INACTIV_MARKER
	--,null as MATURITY_DATE
	--,null as INTEREST
	--,null as PENALTY_INTEREST
	--,CASE WHEN Overdrawn_Account.ACCOUNT_ID is not null THEN N'Y' ELSE N'N' END as Overdrawn_Flag
	,ac.CO_CODE as BRANCH_CODE
	,co.COMPANY_NAME as BRANCH_NAME
from
	dbo.BNK_ACCOUNT ac
	left join bnk_category c
		on c.[@id] = ac.category
		and c.mis_date = ac.mis_date
	left join bnk_company co
		on co.[@id] = ac.co_code
		and co.mis_date = ac.mis_date
where 
	ac.MIS_DATE = @dt

),

l as (
	select
	lc.MIS_DATE
	,null as account_no
	,lc.[@ID] as account_contract_id
	,null as account_title
	,lc.CATEGORY_CODE as CATEGORY
	,c.description as CATEGORY_DESC
	,lc.LC_CURRENCY as CURRENCY
	,lc.CON_CUS_LINK as CUSTOMER
	,null as JOINT_HOLDER
	,lc.ISSUE_DATE as opening_date
	,null as INACTIV_MARKER
	,lc.CO_CODE as BRANCH_CODE
	,co.COMPANY_NAME as BRANCH_NAME
	--,*
	from
		BNK_LETTER_OF_CREDIT lc
		left join bnk_category c
			on c.[@id] = lc.CATEGORY_CODE
			and c.mis_date = lc.mis_date
		left join bnk_company co
			on co.[@id] = lc.co_code
			and co.mis_date = lc.mis_date
	where 
		lc.MIS_DATE = @dt
),

u as (
	select * from a
	union
	select * from l
)


select
	u.mis_date,
	u.account_no
	,u.account_contract_id
	,u.account_title_1
	,u.CATEGORY
	,u.CATEGORY_DESC
	,u.branch_code
	,u.BRANCH_NAME
	,isnull(convert(char(66),HASHBYTES('SHA2_256',concat(
	u.account_no
	,u.account_contract_id
	,u.account_title_1
	,u.CATEGORY
	,u.CATEGORY_DESC
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