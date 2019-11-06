/*ACCOUNTS*/
select 
		ac.MIS_DATE
		,ac.[@ID]
		,ac.ARRANGEMENT_ID
		,ac.ACCOUNT_TITLE_1
		,ac.CATEGORY
		,ac.CURRENCY
		,ac.CUSTOMER
		,ac.JOINT_HOLDER
		,cast(ac.OPENING_DATE as date) as OPENING_DATE
		,ac.INACTIV_MARKER
		--,null as MATURITY_DATE
		--,null as INTEREST
		--,null as PENALTY_INTEREST
		--,CASE WHEN Overdrawn_Account.ACCOUNT_ID is not null THEN N'Y' ELSE N'N' END as Overdrawn_Flag
		,CO_CODE
	from
		dbo.BNK_ACCOUNT ac
where 
	MIS_DATE = '2019-09-30'
	--and CATEGORY like '1%'
	--and [@id] = '104078'
	--and len(ac.JOINT_HOLDER) >8
	and (ac.CUSTOMER = '7488486' or ac.JOINT_HOLDER LIKE '%7488486%')