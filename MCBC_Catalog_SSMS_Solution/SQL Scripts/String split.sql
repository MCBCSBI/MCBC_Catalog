drop table if exists dbo.Orders;

create table dbo.Orders (
ID int
, Customers varchar(100)
, Amount varchar(100)
, Amount2 varchar(100)
);

insert into dbo.Orders (ID, Customers, Amount,Amount2)
values (1,'Briant~Luck', '23~2122','100~200')
, (2, 'Mike~Lee~David', '10~200~37','300~350~400')
, (3, 'Stak', '100','500');

select 
	*
from 
	Orders o


-------------------------------------------------------------------
select
o.ID,
o.Customers,
o.amount,
t01.value as Customers_split,
t02.value as amount_split,
case when t03.value = '' then null else t03.value end as Amount2_split,
t01.Rbr,t02.Rbr as rbr2
from dbo.Orders o
cross apply (
    select
        ROW_NUMBER () over (order by o.Customers ASC) as Rbr
        , t.value
    from string_split (o.Customers, '~') t
) t01
cross apply (
    select
        ROW_NUMBER () over (order by o.Amount ASC) as Rbr
        , t.value
    from string_split (o.Amount, '~') t
) t02
cross apply (
    select
        ROW_NUMBER () over (order by o.Amount2 ASC) as Rbr
        , t.value
    from string_split (o.Amount2, '~') t
) t03
where t01.Rbr = t02.Rbr and t01.Rbr = t03.Rbr