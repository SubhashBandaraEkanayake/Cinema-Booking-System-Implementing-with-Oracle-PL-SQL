
-- PACKEGE HEADER

CREATE OR REPLACE PACKAGE pkg_cinema_booking IS
	
	PROCEDURE proc_book_ticket(
		p_user_id IN cinema_user.user_id%TYPE,
		p_cinema_id IN cinema.cinema_id%TYPE,
		p_movie_id IN movie.movie_id%TYPE,
		p_show_time_id IN show_time.show_time_id%TYPE,
		p_booking_date IN DATE
	);

	FUNCTION func_record_payment(p_user_id IN cinema_user.user_id%TYPE) RETURN NUMBER;

END pkg_cinema_booking;
/

--PACKAGE BODY

CREATE OR REPLACE PACKAGE BODY pkg_cinema_booking IS

	-- Creating composite data type Record named 'rec_booking_log'
	TYPE rec_booking_log IS RECORD(
		r_user_id cinema_user.user_id%TYPE,
		r_seat_id seat.seat_id%TYPE,
		r_log_date DATE
	);

	-- Creating a collection of records named 'booking_log_table'
	TYPE booking_log_table IS TABLE OF rec_booking_log INDEX BY PLS_INTEGER;
	booking_logs booking_log_table;

	--Declaring Exceptions
	ex_invalid_user EXCEPTION;
	ex_no_seats_available EXCEPTION;

	--Private Function to user validation
	FUNCTION func_validate_user(p_user_id cinema_user.user_id%TYPE) 
	RETURN BOOLEAN is
		v_count NUMBER;
	BEGIN
		SELECT COUNT(*) INTO v_count
		FROM cinema_user
		WHERE user_id = p_user_id;

		IF v_count = 0 THEN
			RAISE ex_invalid_user;
		END IF;

		RETURN TRUE;

	END func_validate_user;

	--Private Procedure to log booking activity named 'proc_log_booking_activity'
	PROCEDURE proc_log_booking_activity(
		p_user_id  cinema_user.user_id%TYPE,
		p_seat_id  seat.seat_id%TYPE,
		p_movie_id  movie.movie_id%TYPE,
		p_cinema_id  cinema.cinema_id%TYPE,
		p_show_time_id  show_time.show_time_id%TYPE,
		p_log_date DATE
	) is
		v_index PLS_INTEGER := booking_logs.COUNT +1 ;
	BEGIN	
		DBMS_OUTPUT.PUT_LINE('Booking logged for User : ' || p_user_id || 
		' Seat ' || p_seat_id || 
		' Movie ' || p_movie_id || 
		' Cinema ' || p_cinema_id || 
		' Show Time ' || p_show_time_id
		);

		booking_logs(v_index).r_user_id := p_user_id;
		booking_logs(v_index).r_seat_id := p_seat_id;
		booking_logs(v_index).r_log_date := p_log_date;
	
	END proc_log_booking_activity;

	----------Public Procedure for Ticket Booking named
	PROCEDURE proc_book_ticket(
		p_user_id IN cinema_user.user_id%TYPE,
		p_cinema_id IN cinema.cinema_id%TYPE,
		p_movie_id IN movie.movie_id%TYPE,
		p_show_time_id IN show_time.show_time_id%TYPE,
		p_booking_date IN DATE
	)IS
		--Creating a Cursor to Get Available Seats

			CURSOR cur_available_seats IS
			SELECT seat_id FROM seat
			WHERE seat_id NOT IN (SELECT seat_id FROM ticket);

		v_seat_id seat.seat_id%TYPE;
		v_ticket_id ticket.ticket_id%TYPE;
		v_price movie.price%TYPE;
	BEGIN

		-- Validating the User using above created private function 'func_validate_user'
		IF func_validate_user(p_user_id) THEN

			--Open the above created cursor 'cur_available_seats' and fetching to check available seats
			OPEN cur_available_seats;
			FETCH cur_available_seats INTO v_seat_id;
			IF cur_available_seats%NOTFOUND THEN
				CLOSE cur_available_seats;
				RAISE ex_no_seats_available;
			END IF;
			CLOSE cur_available_seats;

			--Getting the relavent movie Price
			SELECT price INTO v_price FROM movie WHERE movie_id = p_movie_id;

			--Genereating new ticket ID
			SELECT 'T' || LPAD(SUBSTR(NVL(MAX(ticket_id), 'T0000'), 2) + 1, 4, '0')
            INTO v_ticket_id
            FROM ticket;

			--Inserting new ticket data to ticket Table
			INSERT INTO ticket VALUES(v_ticket_id,p_user_id,p_cinema_id,p_show_time_id,v_seat_id,p_movie_id,p_booking_date,v_price);

			--logging the ticket booking activity
			proc_log_booking_activity(p_user_id,v_seat_id,p_movie_id,p_cinema_id,p_show_time_id,p_booking_date);
		
		END IF;

		EXCEPTION
			WHEN ex_invalid_user THEN
				DBMS_OUTPUT.PUT_LINE('Invalid User ID!');
			WHEN ex_no_seats_available THEN
				DBMS_OUTPUT.PUT_LINE('No Seats Available!');
			WHEN OTHERS THEN	
				DBMS_OUTPUT.PUT_LINE(SQLERRM);

	END proc_book_ticket;

	-- Public Function to record the Payment by the ticket
	FUNCTION func_record_payment(p_user_id IN cinema_user.user_id%TYPE)
	RETURN NUMBER IS

		CURSOR cur_user_tickets IS
			SELECT ticket_id,price
			FROM ticket
			WHERE user_id = p_user_id;

		v_total_payment NUMBER := 0;
		v_payment_id payment.payment_id%TYPE;

	BEGIN
		<<cal_total_payment>>
		FOR rec IN cur_user_tickets LOOP

			--Generating Payment ID
			SELECT 'P' || LPAD(SUBSTR(NVL(MAX(payment_id), 'P0000'), 2) + 1, 4, '0')
        	INTO v_payment_id
        	FROM payment;

			--Inserting data to payment table
			INSERT INTO payment VALUES (v_payment_id,rec.ticket_id,rec.price);

			v_total_payment := v_total_payment + rec.price;
		
		END LOOP cal_total_payment;

		DBMS_OUTPUT.PUT_LINE('Total Payment of User ' || p_user_id || ' is ' || v_total_payment);

		RETURN v_total_payment;
	
	END func_record_payment;


END pkg_cinema_booking;
/