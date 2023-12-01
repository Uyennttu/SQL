#1. Show film which dont have any screening
SELECT * FROM film f
LEFT JOIN screening s ON f.id = s.film_id
WHERE s.id IS NULL;

#2. Who book more than 1 seat in 1 booking
with seatcount_in_booking as(
	select r.booking_id, count(r.seat_id) as seat_count 
	from reserved_seat r	
	group by r.booking_id
	having seat_count > 1)
select c.first_name, c.last_name
from seatcount_in_booking s
join booking b on b.id = s.booking_id
join customer c on c.id = b.customer_id;

select first_name, last_name
from(
	SELECT c.first_name, c.last_name, COUNT(r.seat_id) AS seat_count 
    FROM customer c
	JOIN booking b ON c.id = b.customer_id
	JOIN reserved_seat r ON b.id = r.booking_id
	GROUP BY b.id
	HAVING seat_count > 1
    ) as temp;

#3. Show room show more than 2 film in one day
SELECT DISTINCT room_id, name
FROM (
	SELECT s.room_id, r.name, DATE(s.start_time), COUNT(DISTINCT s.film_id) AS film_count FROM screening s
	JOIN room r ON r.id = s.room_id
	GROUP BY s.room_id, DATE(s.start_time)
	HAVING film_count > 2
	) AS temp;

#4. which room show the least film ?
with num_film_in_room as(
	select room_id, count(distinct film_id) as film_count
	from screening s
	group by room_id),
min_num_film as(
	select min(film_count) as min_film_count
    from num_film_in_room)
select n.room_id
from num_film_in_room n
join min_num_film m on n.film_count = m.min_film_count;

#5. what film don't have booking
select f.name
from booking b
join screening s on b.screening_id = s.id
right join film f on f.id = s.film_id
where b.id is null;

#6. WHAT film have show the biggest number of room?
with num_room_each_film as(
	select film_id, count(distinct room_id) as room_count
	from screening s
    join film f on f.id = s.film_id
	group by film_id),
max_room as(
	select max(room_count) as max_room_count
	from num_room_each_film)
select f.name
from num_room_each_film n
join film f on f.id = n.film_id
join max_room m on m. max_room_count = n.room_count;

#7. Show number of film  that show in every day of week and order descending
SELECT DAYNAME(start_time), COUNT(DISTINCT film_id) AS film_count 
FROM screening
GROUP BY DAYNAME(start_time)
ORDER BY film_count DESC;

#8. show total length of each film that showed in 28/5/2022
SELECT f.name, SUM(f.length_min) AS total_length FROM screening s
JOIN film f ON s.film_id = f.id
WHERE DATE(s.start_time) = '2022-05-28' 
GROUP BY f.id;

#9. What film has showing time above and below average show time of all film
with show_time_all_film as(
	select sum(length_min) as sum_length_min
	from screening s
	join film f on f.id = s.film_id),

avg_show_time_all_film as(
	select sum_length_min/ (select count(*) from film f) as avg_show_time
    from show_time_all_film)
        
select f.id, f.name, sum(if(s.id is null, 0, length_min)) as length_each_film,
	if(sum(if(s.id is null, 0,length_min)) < 
	(select avg_show_time from avg_show_time_all_film), 
			"BELOW", "ABOVE") AS showing_status
from screening s
right join film f on f.id = s.film_id
group by f.id;

#10. what room have least number of seat?
with num_of_seat as(
	select room_id, count(id) as seat_count
	from seat
	group by room_id),
min_seat as(
	select min(seat_count) as min_seat_count from num_of_seat)
select r.name
from num_of_seat n
join min_seat m on m.min_seat_count = n.seat_count
join room r on r.id = n.room_id;

#11. what room have number of seat bigger than average number of seat of all rooms
with avg_num_seat_all_room as(
	select count(id)/count(distinct room_id) as avg_num_seat
	from seat)

select r.name, count(*) as num_of_seat
from seat s
join room r on r.id = s.room_id
group by room_id
having num_of_seat > (select * from avg_num_seat_all_room);

#12 Ngoai nhung seat mà Ong Dung booking duoc o booking id = 1 thi ong CÓ THỂ (CAN) booking duoc nhung seat nao khac khong?
with seat_booked as(
select seat_id
from reserved_seat r
#join booking b on b.id = r.booking_id
#join customer c on c.id = b.customer_id
where booking_id = 1),

all_seats as(
select seat.id as seat_id
from booking b
join screening s on s.id = b.screening_id
join room r on r.id = s.room_id
join seat on r.id = seat.room_id
where b.id = 1)

select a.seat_id
from all_seats a
left join seat_booked s on a.seat_id = s.seat_id
where s.seat_id is null;

#13.Show Film with total screening and order by total screening. BUT ONLY SHOW DATA OF FILM WITH TOTAL SCREENING > 10
select f.name, count(film_id) as total_screening
from screening s
join film f on f.id = s.film_id
group by s.film_id
having total_screening > 10
order by total_screening;

#14.TOP 3 DAY OF WEEK based on total booking
with total_booking_table as(
select DAYNAME(s.start_time) AS day_of_week, COUNT(b.id) AS total_booking,
	rank() over (order by COUNT(b.id) desc) as ranking
from booking b
join screening s ON s.id = b.screening_id
group by DAYNAME(s.start_time))

select day_of_week
from total_booking_table 
where ranking <= 3;

#15.CALCULATE BOOKING rate over screening of each film ORDER BY RATES.
with total_screening as(
	select s.film_id, count(s.film_id) as screening_count
	from screening s
	group by s.film_id),
    
total_booking as(
	select s.film_id, count(if(b.screening_id is not null, screening_id, null)) as booking_count
	from booking b
	right join screening s on s.id =b.screening_id
	group by s.film_id),

rating as(
	select f.name, (b.booking_count/s.screening_count)*100 as rating
	from total_screening s
	join total_booking b on b.film_id = s.film_id
	join film f on f.id = s.film_id
	order by rating desc)
select *
from rating;

#16.CONTINUE Q15 -> WHICH film has rate over average ?.
with total_screening as(
	select s.film_id, count(s.film_id) as screening_count
	from screening s
	group by s.film_id),
    
total_booking as(
	select s.film_id, count(if(b.screening_id is not null, screening_id, null)) as booking_count
	from booking b
	right join screening s on s.id =b.screening_id
	group by s.film_id),

rating as(
	select f.name, (b.booking_count/s.screening_count)*100 as rating
	from total_screening s
	join total_booking b on b.film_id = s.film_id
	join film f on f.id = s.film_id
	order by rating desc),

avg_rating_table as(
	select sum(rating) / count(name) as avg_rating
	from rating)

select name
from rating
where rating > (select avg_rating from avg_rating_table);

#17.TOP 2 people who enjoy the least TIME (in minutes) in the cinema based on booking info - only count who has booking info (example : Dũng book film tom&jerry 4 times -> Dũng enjoy 90 mins x 4)
with ranking as(
	select c.first_name, sum(f.length_min) as total_time,
		dense_rank() over(order by sum(f.length_min)) as ranking
	from booking b
	join screening s on s.id = b.screening_id
	join film f on f.id = s.film_id
	join customer c on c.id = b.customer_id
	group by c.id)

select first_name
from ranking 
where ranking <= 2





















































