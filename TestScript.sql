/*
01. Cheking the functionality of the procedure 'proc_book_ticket' & the procedure 'proc_log_booking_activity'. 
here new tickets are added to the ticket table.
output is showed as 'Booking logged for the User'
And also It checkes the functionality whether seats availble, ticket is booked to the  avaialble seat.
*/

BEGIN
    pkg_cinema_booking.proc_book_ticket('U0006', 'C0002','M0002','ST0002',SYSDATE);

    DBMS_OUTPUT.PUT_LINE('---- Ticket Table ----');

    FOR rec IN (
        SELECT ticket_id, user_id, cinema_id, show_time_id, seat_id, movie_id, booking_date, price
        FROM ticket
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
        'Ticket ID: ' || rec.ticket_id ||
        ', User ID: ' || rec.user_id ||
        ', Cinema ID: ' || rec.cinema_id ||
        ', Show Time ID: ' || rec.show_time_id ||
        ', Seat ID: ' || rec.seat_id ||
        ', Movie ID: ' || rec.movie_id ||
        ', Booking Date: ' || TO_CHAR(rec.booking_date, 'YYYY-MM-DD') ||
        ', Price: Rs.' || rec.price
    );
    END LOOP;
END;
/


/*
02. Checking the functionality of the private function 'func_validate_user' and exception 'ex_invalid_user'
I inserted a user ID not in Cinema_user table and tested..
It shows 'Invalid User ID!'
*/

BEGIN
  pkg_cinema_booking.proc_book_ticket('U0006', 'C0001','M0002','ST0001',SYSDATE);
END;
/



/*
03. Checking the functionality of the public Function 'func_record_payment'
It outputs the total payment of the user 'U0001'
And also all the ticket numbers from the User 'U0001' are added to the payment table.
*/
DECLARE
  v_total NUMBER;
BEGIN
    v_total := pkg_cinema_booking.func_record_payment('U0006');
    DBMS_OUTPUT.PUT_LINE('----Payment Table -----');

  FOR rec IN (
    SELECT payment_id, ticket_id, amount
    FROM payment
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Payment ID: ' || rec.payment_id ||
      ', Ticket ID: ' || rec.ticket_id ||
      ', Amount: Rs.' || rec.amount
    );
  END LOOP;
END;
/



/*
04. Checking the functionality of the cursor 'cur_available_seats' and the exception ex_no_seats_available.
Now all the seats in the seat table are booked. I again run the following anonumous block to book a ticket. 
It should show 'No Seats Available!'
*/
BEGIN
  pkg_cinema_booking.proc_book_ticket('U0004', 'C0001','M0001','ST0001',SYSDATE);
END;
/
