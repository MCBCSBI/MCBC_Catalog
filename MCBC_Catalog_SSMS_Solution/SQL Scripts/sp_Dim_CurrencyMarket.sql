Alter procedure sp_dim_currencyMarket
as

begin
	drop table if exists dim_currencyMarket
	create table Dim_CurrencyMarket
	(
		 CurrencyMarket_Key int not null identity (1,1)
		,CurrencyMarket nvarchar(10) not null
		,CurrencyDescription nvarchar(50)
		,scd2_start datetime 
		,scd2_end datetime 
		,scd2_hash char(66) not null
	)

	alter table dim_currencyMarket
		add
			 constraint pk_dim_currencyMarket primary key clustered(CurrencyMarket_Key)

			 set identity_insert dim_currencyMarket on

		insert into Dim_CurrencyMarket(CurrencyMarket_Key,CurrencyMarket,Scd2_Hash)
			values
				(-1,'-1','-1')

end

--exec sp_dim_currencyMarket

