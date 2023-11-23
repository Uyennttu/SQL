#Show film name ONLY which has screening.
SELECT DISTINCT film.name
FROM film
RIGHT JOIN screening ON film.id = screening.film_id;

#Show Room name with all seat row and seat column of "Room 2"
SELECT room.name, seat.row, seat.number
FROM seat 
JOIN room ON seat.room_id = room.id
WHERE room.name = 'Room 2';

#Show all Screening Infomation including film name, room name, time of film "Tom&Jerry"
SELECT film.name, room.name, screening.start_time
FROM screening
JOIN film ON screening.film_id = film.id 
JOIN room ON screening.room_id = room.id
WHERE film.name = 'Tom&Jerry';

#Show what seat that customer "Dung Nguyen" booked
SELECT customer.first_name, customer.last_name, seat.row, seat.number
FROM reserved_seat
JOIN booking ON reserved_seat.booking_id = booking.id
JOIN seat ON reserved_seat.seat_id = seat.id
JOIN customer ON booking.customer_id = customer.id
WHERE customer.first_name = 'Dung' AND customer.last_name = 'Nguyen';

#How many film that showed in 24/5/2022
SELECT COUNT(DISTINCT film.name) AS total_film
FROM screening
JOIN film ON screening.film_id = film.id
WHERE DATE(screening.start_time) = '2022-05-24';

#What is the maximum length and minumum length of all film
SELECT 
    (SELECT name FROM film WHERE length_min = (SELECT MAX(length_min) FROM film)) AS longest_film,
    (SELECT MAX(length_min)) AS max_length,
	(SELECT name FROM film WHERE length_min = (SELECT MIN(length_min) FROM film)) AS shortest_film,
    (SELECT MIN(length_min)) AS min_length
FROM film
LIMIT 1;

#How many seat of Room 7
SELECT COUNT(seat.id) AS total_seat
FROM room
JOIN seat ON room.id = seat.room_id
WHERE room.name = 'Room 7';

#Total seat are booked of film "Tom&Jerry"
SELECT COUNT(reserved_seat.seat_id) AS total_reserved_seats
FROM reserved_seat
JOIN booking ON reserved_seat.booking_id = booking.id
JOIN screening ON booking.screening_id = screening.id
JOIN film ON screening.film_id = film.id
WHERE film.name = 'Tom&Jerry';