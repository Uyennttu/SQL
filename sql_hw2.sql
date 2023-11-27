#1. Show film which dont have any screening
SELECT * FROM film f
LEFT JOIN screening s ON f.id = s.film_id
WHERE s.id IS NULL;

#2. Who book more than 1 seat in 1 booking
SELECT c.first_name, c.last_name, COUNT(r.seat_id) AS seat_count FROM customer c
JOIN booking b ON c.id = b.customer_id
JOIN reserved_seat r ON b.id = r.booking_id
GROUP BY b.id
HAVING COUNT(r.seat_id) > 1
ORDER BY seat_count ASC;

#3. Show room show more than 2 film in one day
SELECT r.name, DATE(s.start_time), COUNT(DISTINCT f.id) AS film_count FROM screening s
JOIN room r ON r.id = s.room_id
JOIN film f ON f.id = s.film_id
GROUP BY r.name, DATE(s.start_time)
HAVING COUNT(DISTINCT f.id) > 2
ORDER BY film_count ASC;

#4. which room show the least film ?
SELECT r.name, COUNT(DISTINCT f.id) AS film_count FROM room r
JOIN screening s ON r.id = s.room_id
JOIN film f ON f.id = s.film_id
GROUP BY r.id
HAVING COUNT(DISTINCT f.id) = (
	SELECT MIN(film_count)
	FROM (
		SELECT COUNT(DISTINCT f.id) AS film_count FROM room r
		JOIN screening s ON r.id = s.room_id
		JOIN film f ON f.id = s.film_id
		GROUP BY r.id
		) AS sub
	);

#5. what film don't have booking
SELECT DISTINCT f.name, b.id FROM film f
JOIN screening s ON f.id = s.film_id
LEFT JOIN booking b ON s.id = b.screening_id
WHERE b.id IS NULL;

#6. WHAT film have show the biggest number of room?
SELECT f.name, COUNT(DISTINCT r.id) AS room_count FROM film f
JOIN screening s ON f.id = s.film_id
JOIN room r ON s.room_id = r.id
GROUP BY f.id
HAVING COUNT(DISTINCT r.id) = (
	SELECT MAX(room_count)
    FROM(
		SELECT f.name, COUNT(DISTINCT r.id) AS room_count FROM film f
		JOIN screening s ON f.id = s.film_id
		JOIN room r ON s.room_id = r.id
		GROUP BY f.id
		) AS sub
    );
    
#7. Show number of film  that show in every day of week and order descending
SELECT DAYNAME(s.start_time), COUNT(DISTINCT f.id) AS film_count FROM film f
JOIN screening s ON f.id = s.film_id
GROUP BY DAYNAME(s.start_time)
HAVING COUNT(DISTINCT f.id)
ORDER BY film_count DESC;

#8. show total length of each film that showed in 28/5/2022
SELECT f.name, SUM(f.length_min) AS total_length FROM screening s
JOIN film f ON s.film_id = f.id
WHERE DATE(s.start_time) = '2022-05-28' 
GROUP BY f.id;

#9. What film has showing time above and below average show time of all film
SELECT f.name, SUM(f.length_min) AS total_length	
FROM screening s
JOIN film f ON s.film_id = f.id
GROUP BY f.id
HAVING SUM(f.length_min) != (
	SELECT AVG(total_length) FROM (
		SELECT SUM(f.length_min) AS total_length
		FROM screening s
		JOIN film f ON s.film_id = f.id
		GROUP BY f.id
		) AS sub
	) ;

#10. what room have least number of seat?
SELECT r.name, COUNT(s.id) AS seat_count FROM room r
JOIN seat s ON r.id = s.room_id
GROUP BY r.id
HAVING COUNT(s.id) = (
	SELECT MIN(seat_count) 
    FROM(
		SELECT r.name, COUNT(s.id) AS seat_count FROM room r
		JOIN seat s ON r.id = s.room_id
		GROUP BY r.id 
        ) AS sub
	);
        
#11. what room have number of seat bigger than average number of seat of all rooms
SELECT r.name, COUNT(s.id) AS seat_count FROM room r	
JOIN seat s ON r.id = s.room_id
GROUP BY r.id
HAVING COUNT(s.id) > (
SELECT AVG(seat_count) 
	FROM (
		SELECT COUNT(s.id) AS seat_count 
        FROM room r
        JOIN seat s ON r.id = s.room_id
		GROUP BY r.id
        ) AS sub
	);
    
#12 Ngoai nhung seat mà Ong Dung booking duoc o booking id = 1 thi ong CÓ THỂ (CAN) booking duoc nhung seat nao khac khong?
SELECT b.id, c.first_name, s.row, s.number
FROM reserved_seat r
JOIN booking b ON r.booking_id = b.id
JOIN customer c ON b.customer_id = c.id
JOIN seat s ON s.id = r.seat_id
WHERE booking_id = 1;

SELECT s.row, s.number FROM seat s
JOIN room r ON r.id = s.room_id
JOIN screening scr ON scr.room_id = r.id
JOIN booking b ON b.screening_id = scr.id
WHERE b.id = 1;

#13.Show Film with total screening and order by total screening. BUT ONLY SHOW DATA OF FILM WITH TOTAL SCREENING > 10
SELECT f.name, COUNT(f.id) AS total_screening FROM film f
JOIN screening s ON s.film_id = f.id
GROUP BY f.id
HAVING COUNT(f.id) > 10
ORDER BY total_screening DESC;

#14.TOP 3 DAY OF WEEK based on total booking
SELECT DAYNAME(s.start_time) AS day_of_week, COUNT(b.id) AS total_booking FROM booking b
JOIN screening s ON s.id = b.screening_id
GROUP BY DAYNAME(s.start_time)
ORDER BY total_booking DESC
LIMIT 3;

#15.CALCULATE BOOKING rate over screening of each film ORDER BY RATES.
SELECT f.name, (COUNT(b.id)/(SELECT COUNT(id) FROM booking)*100) AS rate FROM booking b
JOIN screening s ON s.id = b.screening_id
JOIN film f ON f.id = s.film_id
GROUP BY f.id
ORDER BY rate DESC;

#16.CONTINUE Q15 -> WHICH film has rate over average ?.
SELECT f.name, (COUNT(b.id)/(SELECT COUNT(id) FROM booking)*100) AS rate FROM booking b
JOIN screening s ON s.id = b.screening_id
JOIN film f ON f.id = s.film_id
GROUP BY f.id
HAVING (COUNT(b.id)/(SELECT COUNT(id) FROM booking)*100) > 
	(SELECT AVG(rate) FROM(
		SELECT (COUNT(b.id)/(SELECT COUNT(id) FROM booking)*100) AS rate FROM booking b
		JOIN screening s ON s.id = b.screening_id
		JOIN film f ON f.id = s.film_id
		GROUP BY f.id
        ) AS sub
	);
    
#17.TOP 2 people who enjoy the least TIME (in minutes) in the cinema based on booking info - only count who has booking info (example : Dũng book film tom&jerry 4 times -> Dũng enjoy 90 mins x 4)
SELECT c.first_name, c.last_name, SUM(f.length_min) AS time_spent_in_cinema FROM booking b
JOIN screening s ON s.id = b.screening_id
JOIN film f ON f.id = s.film_id
JOIN customer c ON c.id = b.customer_id
GROUP BY c.id
ORDER BY time_spent_in_cinema ASC


















































