declare @businessdate date = '2019-05-14'
select * from
(	
	select 
		a.BRANCH_CO_MNE
		,a.[@ID]
		,concat(substring(a.OPENING_DATE,1,4),'-',substring(a.OPENING_DATE,5,2),'-',substring(a.OPENING_DATE,7,2)) as DATE
		,N'Opening' as Action
	from
		bs.ACCOUNT a
	where a.MIS_DATE = a.OPENING_DATE
union
	select
		c.BRANCH_CO_MNE
		,c.[@ID]
		,C.ACCT_CLOSE_DATE
		,N'Closure' as Action
	from
		bs.ACCOUNT_CLOSED c
	where c.MIS_DATE = c.ACCT_CLOSE_DATE
) a
where a.DATE = @businessdate