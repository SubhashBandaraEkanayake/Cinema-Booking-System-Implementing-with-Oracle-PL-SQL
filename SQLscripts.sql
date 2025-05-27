
--Creating tables

CREATE TABLE cinema_User(
	user_id VARCHAR2(10) PRIMARY KEY,
      	name VARCHAR2(50),
     	email VARCHAR2(25)	NOT NULL,
    	contact_no VARCHAR2(25) NOT NULL
);

create table cinema(
	cinema_id VARCHAR2(10) PRIMARY KEY,
       	name VARCHAR2(50) NOT NULL,
      	location VARCHAR2(50) NOT NULL
);

create table movie(
	movie_id VARCHAR2(10) PRIMARY KEY,
       	title VARCHAR2(20)  NOT NULL,
       	Genre VARCHAR2(10) NOT NULL,
       	duration_in_minutes NUMBER(3) NOT NULL,
		price NUMBER(6, 2)
);

create table seat(
	seat_id VARCHAR2(10) PRIMARY KEY,
	row_no	NUMBER NOT NULL,
	seat_no	NUMBER NOT NULL
);

create table show_time(
	show_time_id VARCHAR(10) PRIMARY KEY,
	cinema_id  VARCHAR2(10)  NOT NULL,
	movie_id VARCHAR2(10)  NOT NULL,
	start_time VARCHAR2(10)  NOT NULL,
	end_time VARCHAR2(10),
	FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
	FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id)
);

 create table ticket(
	ticket_id VARCHAR2(10) PRIMARY KEY,
       	user_id VARCHAR2(10)  NOT NULL,
       	cinema_id VARCHAR2(10)  NOT NULL,
       	show_time_id VARCHAR(10)  NOT NULL,
       	seat_id VARCHAR2(10)  NOT NULL,
       	movie_id VARCHAR2(10)  NOT NULL,
       	booking_date DATE  NOT NULL,
      	price NUMBER(6, 2) NOT NULL,
      	FOREIGN KEY (user_id) REFERENCES cinema_User(user_id),
      	FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id),
      	FOREIGN KEY (show_time_id) REFERENCES show_time(show_time_id),
    	FOREIGN KEY (seat_id) REFERENCES seat(seat_id),
      	FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
);


create table payment(
	payment_id VARCHAR2(10) PRIMARY KEY,
	ticket_id VARCHAR2(10)  NOT NULL,
	amount NUMBER(6, 2) NOT NULL,
	FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
);

--Populate data to tables

INSERT INTO cinema_User VALUES ('U0001','David','david@gmail.com','0715689745');
INSERT INTO cinema_User VALUES ('U0002','Andrew','andrew@gmail.com','0751236428');
INSERT INTO cinema_User VALUES ('U0003','Emma','emma@gmail.com','0781259874');
INSERT INTO cinema_User VALUES ('U0004','Bella','bella@gmail.com','0751236428');
INSERT INTO cinema_User VALUES ('U0005','Anne','anne@gmail.com','0751236428');


INSERT INTO cinema VALUES ('C0001','SCOPE','Kiribathgoda');
INSERT INTO cinema VALUES ('C0002','PVR','Colombo');
INSERT INTO cinema VALUES ('C0003','REGAL','Dematagoda');
INSERT INTO cinema VALUES ('C0004','CINEMEX','Ja-ela');
INSERT INTO cinema VALUES ('C0005','CINECITY','Maradana');


INSERT INTO movie VALUES ('M0001','Thunderbolts','Action',120,1200.00);
INSERT INTO movie VALUES ('M0002','Final Destination Bloodlines','Horror',110,1100.00);
INSERT INTO movie VALUES ('M0003','Raid 2','Thriller',160,750.00);
INSERT INTO movie VALUES ('M0004','Maaman','Drama',150,800.00);
INSERT INTO movie VALUES ('M0005','Mufasa','Animation',120,900.00);


INSERT INTO seat VALUES ('S0001',1,1);
INSERT INTO seat VALUES ('S0002',1,2);
INSERT INTO seat VALUES ('S0003',1,3);
INSERT INTO seat VALUES ('S0004',2,1);
INSERT INTO seat VALUES ('S0005',2,2);
INSERT INTO seat VALUES ('S0006',1,4);
INSERT INTO seat VALUES ('S0007',1,5);
INSERT INTO seat VALUES ('S0008',1,6);
INSERT INTO seat VALUES ('S0009',1,7);


INSERT INTO show_time VALUES ('ST0001','C0001','M0001', '10:30','12:30');
INSERT INTO show_time VALUES ('ST0002','C0002','M0002','13:00', '14:50');
INSERT INTO show_time VALUES ('ST0003','C0003','M0003','08:30','11:10');
INSERT INTO show_time VALUES ('ST0004','C0004','M0004','15:00', '17:30');
INSERT INTO show_time VALUES ('ST0005','C0005','M0005','18:00','20:00');


INSERT INTO ticket VALUES ('T0001','U0001','C0001','ST0001','S0001','M0001',TO_DATE('2025-05-16', 'YYYY-MM-DD'),1200.00);
INSERT INTO ticket VALUES ('T0002','U0002','C0002','ST0002','S0002','M0002',TO_DATE('2025-05-17', 'YYYY-MM-DD'),1100.00);
INSERT INTO ticket VALUES ('T0003','U0003','C0003','ST0003','S0003','M0003',TO_DATE('2025-05-18', 'YYYY-MM-DD'),750.00);
INSERT INTO ticket VALUES ('T0004','U0004','C0004','ST0004','S0004','M0004',TO_DATE('2025-05-19', 'YYYY-MM-DD'),800.00);
INSERT INTO ticket VALUES ('T0005','U0005','C0005','ST0005','S0005','M0005',TO_DATE('2025-05-12', 'YYYY-MM-DD'),900.00);


INSERT INTO payment VALUES ('P0001','T0001',1200.00);
INSERT INTO payment VALUES ('P0002','T0002',1100.00);
INSERT INTO payment VALUES ('P0003','T0003',750.00);
INSERT INTO payment VALUES ('P0004','T0004',800.00);
INSERT INTO payment VALUES ('P0005','T0005',900.00);
















