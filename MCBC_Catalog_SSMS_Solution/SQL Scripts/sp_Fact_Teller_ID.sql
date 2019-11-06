Alter procedure sp_fact_Teller_ID 
as
begin
	drop table if exists Fact_Teller_ID
	create table Fact_Teller_ID
	(
		 Date_Key int not null
		,Teller_Key int not null
		,Currency nvarchar(3) not null
		,Till_Limit nvarchar(3)
		,Till_Balance decimal (19,2)
		,DEF_FCY_EQV_LIM decimal (19,2)
		,LOCAL_CCY_LIMIT decimal (19,2)
	)

	alter table Fact_Teller_ID
		add
			constraint pk_Fact_Teller_ID primary key nonclustered(Date_Key,Teller_Key,Currency)
end

--exec sp_fact_Teller_ID 