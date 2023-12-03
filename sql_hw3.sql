#1. SqlSensorsMostRecent
select p.id, p.title, count(r.number_of_tickets) as reserved_tickets
from plays p
    left join reservations r on p.id = r.play_id
group by p.id
order by reserved_tickets desc, p.id asc;

#2. SqlTransfers
select name, 
        sum(if(money >= 0, money, 0)) as sum_of_deposits
        sum(if(money < 0, money, 0)) as sum_of_withdrawals
from transfers 
group by name
order by name

#3. SqlBuses
select
from buses b
    join passengers p on b.origin = p.origin
