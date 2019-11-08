alter procedure sp_fact_balances_audit
as
	begin
		drop table if exists Fact_Balances_Audit

		create table Fact_Balances_Audit
				(
					Date datetime
					,Account nvarchar(200)
					--,GL_Key int not null
					,consol_key nvarchar(200)
					,asset_type nvarchar(200)
					,Balance_LCY decimal(19,2) not null
					,Balance_FCY decimal(19,2) not null
				)
	end