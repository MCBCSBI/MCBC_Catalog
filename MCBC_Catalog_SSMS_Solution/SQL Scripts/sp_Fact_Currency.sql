Alter procedure sp_fact_Currency
as
	begin

		drop table if exists Fact_Currency;
		create table Fact_Currency
		(
			 Date_Key int not null
			,Currency_Key int not null
			,CurrencyMarket_Key int not null
		    ,MID_REVAL_RATE decimal(19,2) not null
			,BUY_RATE decimal(19,2) not null
		    ,SELL_RATE decimal(19,2) not null
			,NEGOTIABLE_AMT decimal(19,2) not null
		)

		alter table Fact_Currency
			add 
				 constraint pk_Fact_Currency primary key nonclustered (date_key,Currency_Key,CurrencyMarket_Key)
				,constraint fk_Date foreign key(Date_Key) references Dim_Date(Date_Key)
				,constraint fk_Currency foreign key(Currency_Key) references Dim_Currency(Currency_Key)
				,constraint fk_CurrencyMarket foreign key(CurrencyMarket_Key) references dim_CurrencyMarket(CurrencyMarket_key)

		alter table Fact_Currency
			NOCHECK CONSTRAINT fk_Date, fk_Currency, fk_CurrencyMarket;

	end

--exec sp_fact_Currency
--truncate table fact_Currency