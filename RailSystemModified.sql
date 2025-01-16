USE RailSystemModified;

CREATE TABLE Trains ( 
Train_ID INT IDENTITY PRIMARY KEY, 
Train_name NVARCHAR(50) NOT NULL, 
Number_of_wagons INT NOT NULL, 
Train_type NVARCHAR(50) NOT NULL
);

INSERT INTO Trains
VALUES 
    ('Krakus', 6, 'PKP Intercity'),
    ('Bryza', 3, 'Koleje śląskie'),
    ('Piast', 8, 'PKP Intercity'),
    ('Hetman', 3, 'PKP Intercity'),
    ('Regionalny', 3, 'Przewozy regionalne');

CREATE TABLE Technical_details_of_trains (
Train_ID INT PRIMARY KEY, 
Manufacturer NVARCHAR(100) NOT NULL,
Engine_power INT NOT NULL, -- Engine power in kW
Engine_type NVARCHAR(50) NOT NULL, -- Engine type (e.g. electric, diesel)
Year_of_production INT NOT NULL, 
FOREIGN KEY (Train_ID) REFERENCES Trains(Train_ID)
);

INSERT INTO Technical_details_of_trains (Train_ID, Manufacturer, Engine_power, Engine_type, Year_of_production)
VALUES
(1,'Bombardier', 4000, 'Electric', 2018),
(2,'Siemens', 3000, 'Electric', 2015),
(3,'Pesa', 3200, 'Diesel', 2020),
(4,'Alstom', 4200, 'Electric', 2018),
(5,'Stadler', 2800, 'Diesel', 2019);

CREATE TABLE Passengers (
    Passenger_id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Surname NVARCHAR(100) NOT NULL,
    Email_address NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(50) NOT NULL
);

INSERT INTO Passengers (Name, Surname, Email_address, Password)
VALUES 
    ('Michał','Wójcik', 'm.wojcik@wp.pl', 'haslo123'),
    ('Julia','Małysz', 'j.malysz@wp.pl', 'haslo098'),
    ('Tomasz','Nowak', 't.nowak123@o2.pl', 'haslo231'),
    ('Anna','Mucha', 'anna.mucha@onet.pl', 'haslo999'),
    ('Mateusz','Kowalski', 'm.kowalski@onet.pl', 'haslo111'),
    ('Paweł','Mickiewicz', 'p.mickiewicz@onet.pl', 'haslo122');


CREATE TABLE Schedule(
	Schedule_ID INT IDENTITY PRIMARY KEY,
	Train_ID INT NOT NULL,
	Travel_Day DATE NOT NULL,
	Departure_Time TIME(0) NOT NULL,
	Arrival_Time TIME(0) NOT NULL,
	Source_Station NVARCHAR(100) NOT NULL,
	Destination_Station NVARCHAR(100) NOT NULL,
	Route NVARCHAR(50),
	Platform_Number INT NOT NULL,
	Duration TIME(0),
	DistanceKm INT ,
	Total_Price DECIMAL(10,2), 
	FOREIGN KEY (Train_ID) REFERENCES Trains(Train_ID)
);

INSERT INTO Schedule (Train_ID,Travel_Day,Departure_Time,Arrival_Time,Source_Station,Destination_Station,Route,Platform_Number,Duration,DistanceKm,Total_Price)
VALUES 
    (1, '2024-11-27', '07:00:00', '10:47:00', 'Warszawa-Zachodnia', 'Kraków-Główny', 'Express', 2, '03:47:00',316,70),
    (2, '2024-11-28', '09:30:00', '11:32:00', 'Katowice', 'Żywiec', 'Regional', 3, '02:32:00',null,null),
    (3, '2024-11-29', '10:30:00', '14:30:00', 'Wrocław', 'Gdynia', 'Express', 2, '04:00:00',null,null),
    (4, '2024-11-30', '11:00:00', '17:35:00', 'Zamość', 'Wrocław', 'Express', 1, '06:45:00',545,100),
    (5, '2024-11-30', '15:22:00', '17:45:00', 'Kraków-Główny', 'Sędziszów', 'Regional', 3, '02:23:00',null,null),
    (1, '2024-11-28', '13:00:00', '16:47:00', 'Kraków-Główny', 'Warszawa-Zachodnia', 'Express', 4, '03:47:00',316,70),
    (4, '2024-12-02', '15:00:00', '22:45:00', 'Wrocław', 'Zamość', 'Express', 1, '06:45:00',545,100);

CREATE TABLE Ticket_reservations(
	Reservation_ID INT IDENTITY PRIMARY KEY,
	Passenger_ID INT NOT NULL,
	Schedule_ID INT NOT NULL,
	Price DECIMAL(10, 2) NOT NULL,
	Reservation_Date DATETIME NOT NULL,
	Travel_Day DATE NOT NULL, 
	Start_Station NVARCHAR(100) NOT NULL,
	Departure_Time TIME(0) NOT NULL, 
	End_Station NVARCHAR(100) NOT NULL,
	Arrival_Time TIME(0) NOT NULL, 
	Duration TIME(0),
	Distance INT NOT NULL,
	Carriage_Number INT,
	Seat_Number INT,
	Percentage_Discount INT,
	Discount_Type NVARCHAR(100),
	Reservation_status NVARCHAR(50),
	FOREIGN KEY (Schedule_ID) REFERENCES Schedule(Schedule_ID),
	FOREIGN KEY (Passenger_ID) REFERENCES Passengers(Passenger_ID)
);

INSERT INTO  Ticket_reservations (Passenger_ID,Schedule_ID,Price,Reservation_Date,Travel_Day,Start_Station,Departure_Time,End_Station,Arrival_Time,Duration,Distance,Carriage_Number,Seat_Number,Percentage_Discount,Discount_Type,Reservation_status )
VALUES
( 1, 2, 35.60, '2024-11-27 10:40:20', '2024-11-28','Katowice', '09:30:00', 'Tychy','10:38:00', '01:08:00',99, NULL, NULL, NULL, NULL, 'Cancelled'),
(2, 3, 29.90, '2024-11-27 13:25:41', '2024-11-29','Wrocław', '10:30:00', 'Poznań','13:44:00', '03:14:00', 120, 8, 35, 51, 'Student', 'Booked'), 
( 4, 6, 38.15, '2024-11-27 14:33:11', '2024-11-28', 'Kraków-Główny', '13:00:00','Warszawa-Zachodnia', '17:55:00', '04:55:00', 316, 12, 88, 51, 'Student', 'Booked'), 
( 3, 4, 40.00, '2024-11-28 11:15:11', '2024-11-30', 'Rzeszów-Główny','15:10:00', 'Katowice','16:22:00', '01:12:00',  145, 1, 22, NULL, NULL, 'Booked');



CREATE TABLE Payments (
Payment_ID INT IDENTITY PRIMARY KEY,
Reservation_ID INT NOT NULL,
Amount DECIMAL(10,2) NOT NULL,
Payment_Method NVARCHAR(50) NOT NULL, -- e.g. Card, Transfer, Blik
Payment_Date DATETIME NOT NULL,
FOREIGN KEY (Reservation_ID) REFERENCES Ticket_Reservations(Reservation_ID)
);

INSERT INTO Payments (Reservation_ID, Amount, Payment_Method,Payment_Date) 
VALUES 
(1, 35.60, 'Blik', '2024-11-27'), 
(2,29.90, 'Payment by transfer', '2024-11-27'), 
(3,38.15, 'Blik', '2024-11-27'),
(4, 40.00, 'Płatność przelewem', '2024-11-28');


CREATE TABLE Ticket_cancellation (
	Cancellation_ID INT IDENTITY PRIMARY KEY, 
	Reservation_ID INT NOT NULL,
	Cancellation_reason NVARCHAR(255), 
	Cancellation_date DATETIME NOT NULL,
	Refund_amount DECIMAL(10, 2) NOT NULL, -- Refunded amount value
	Refund_status NVARCHAR(50), 
	FOREIGN KEY (Reservation_ID) REFERENCES Ticket_reservations(Reservation_ID) 
);

INSERT INTO Ticket_cancellation (Reservation_ID,Cancellation_reason,Cancellation_date,Refund_amount,Refund_status)
VALUES 
    (1, 'Change of travel plans', '2024-11-28 08:00:00', 32.04, 'Accepted');


CREATE TABLE Connection_Zamosc_Wroclaw (
	Route_segment_ID INT IDENTITY PRIMARY KEY,  --odcinek trasy
	Train_ID INT NOT NULL, 
	Schedule_ID INT NOT NULL, 
	Stations NVARCHAR(100) NOT NULL, 
	Distance_between_stations INT, 
	Cost_between_stations DECIMAL(10, 2), 
	Duration TIME(0), 
	Arrival_Time TIME(0), 
	Departure_Time TIME(0), 
	FOREIGN KEY (Train_ID) REFERENCES Trains(Train_ID), 
	FOREIGN KEY (Schedule_ID) REFERENCES Schedule(Schedule_ID) 
);

INSERT INTO Connection_Zamosc_Wroclaw (Train_ID,Schedule_ID,Stations,Distance_between_stations,Cost_between_stations,Duration,Arrival_Time,Departure_Time)
VALUES 
     (4, 4, 'Zamość', NULL, NULL, NULL,NULL,'11:00:00'),     
    (4, 4, 'Stalowa Wola', 120, 25.00, '01:20:00','12:20:00','12:20:00'),     
    (4, 4, 'Rzeszów Główny', 60, 15.00, '00:50:00','13:10:00','13:10:00'),     
    (4, 4, 'Tarnów', 40, 10.00, '00:45:00','13:55:00','13:55:00'),
    (4, 4, 'Bochnia', 35, 8.00, '00:41:00','14:36:00','14:36:00'),   
    (4, 4, 'Kraków-Główny', 30, 8.00, '00:38:00','15:14:00','15:14:00'),    
    (4, 4, 'Katowice', 40, 9.00, '00:40:00', '15:54:00','15:54:00'),    
    (4, 4, 'Opole-Główne', 80, 17.00, '01:00:00','16:54:00','16:54:00'),
    (4, 4, 'Wrocław', 40, 8.00, '00:41:00','16:35:00',NULL);

CREATE TABLE Discounts (
	Discount_ID INT IDENTITY PRIMARY KEY,
	Discount_Name NVARCHAR(50) NOT NULL,
	Discount_Percent INT NOT NULL -- e.g. 20.00 for 20% discount
);


INSERT INTO Discounts (Discount_Name, Discount_Percent) VALUES 
('Normal', 0),
('Student', 51),
('Senior', 30),
('Children/Youth', 37),
('Soldiers', 78);


CREATE TABLE Train_capacity (
	Train_ID INT, -- Train ID (in accordance with the schedule)
	Schedule_ID INT, 
	Carriage_Number INT, 
	Seat_Number INT, 
	Is_Occupied BIT DEFAULT 0,           -- 0 = free, 1 = occupied
	PRIMARY KEY (Schedule_ID, Carriage_Number, Seat_Number), 
	FOREIGN KEY (Schedule_ID) REFERENCES Schedule(Schedule_ID) 
);


INSERT INTO Train_capacity (Train_ID, Schedule_ID, Carriage_Number,Seat_Number, Is_Occupied)
VALUES
(4, 4, 1, 1, 1), (4, 4, 1, 2, 0), (4, 4, 1, 3, 1), (4, 4, 1, 4, 1), (4, 4, 1, 5, 0),
(4, 4, 1, 6, 0), (4, 4, 1, 7, 0), (4, 4, 1, 8, 0), (4, 4, 1, 9, 1), (4, 4, 1, 10, 1),
(4, 4, 2, 1, 1), (4, 4, 2, 2, 1), (4, 4, 2, 3, 0), (4, 4, 2, 4, 0), (4, 4, 2, 5, 0),
(4, 4, 2, 6, 0), (4, 4, 2, 7, 0), (4, 4, 2, 8, 0), (4, 4, 2, 9, 0), (4, 4, 2, 10, 1),
(4, 4, 3, 1, 1), (4, 4, 3, 2, 1), (4, 4, 3, 3, 1), (4, 4, 3, 4, 1), (4, 4, 3, 5, 1),
(4, 4, 3, 6, 1), (4, 4, 3, 7, 1), (4, 4, 3, 8, 1), (4, 4, 3, 9, 1), (4, 4, 3, 10, 1);

--The procedure allows the passenger to select the starting and ending station for themselves (only on the Zamosc-Wroclaw route), e.g. Zamosc to KrakowGlowny 
--from the table connections_Zamosc_Wroclaw, (or Tarnow-Rzeszow Glowny or Katowice-Wroclaw). The passenger provides the passenger_ID, discount type, travel date. 
--The procedure calculates the distance between stations, total cost, total travel time. It randomly selects a carriage and a seat for the passenger. 
--This information will be inserted into the table tickets_reservations. If the conditions are not met, the system will display appropriate messages.

alter PROCEDURE Reservation_Route
    @Passenger_ID INT,                   
    @Start_Station NVARCHAR(100),        -- Starting station (Zamość, Rzeszów)
    @End_Station NVARCHAR(100),          -- Ending station (Wrocław)
    @Travel_Date DATE,
    @Discount_Name NVARCHAR(50) = NULL   -- Discount type (e.g. Student, Senior, Normal)
AS
BEGIN
    DECLARE @Total_Distance INT = 0;
    DECLARE @Total_Cost DECIMAL(10, 2) = 0.00;
    DECLARE @Total_Time INT = 0;         
    DECLARE @Start_ID INT;
    DECLARE @Offset_ID INT;
    DECLARE @Discount DECIMAL(10, 2) = 0.00;
    DECLARE @Schedule_ID INT;
    DECLARE @Departure_Time TIME(0);
    DECLARE @Arrival_Time TIME(0);
    DECLARE @Travel_Day DATE;
    DECLARE @Carriage_Number INT;
    DECLARE @Seat_Number INT;


    -- Check if there is a schedule for the given travel date
    IF NOT EXISTS (
        SELECT 1 
        FROM Schedule AS S
        INNER JOIN Connection_Zamosc_Wroclaw AS C
            ON S.Schedule_ID = C.Schedule_ID
        WHERE S.Travel_Day = @Travel_Date
          AND C.Stations = @Start_Station
          AND EXISTS (
              SELECT 1 
              FROM Connection_Zamosc_Wroclaw
              WHERE Stations = @End_Station
          )
    )
    BEGIN
        PRINT 'No available connections on the selected travel date.';
        RETURN;
    END
	
	-- Find the segment ID for the starting station
    SELECT @Start_ID = Route_segment_ID
    FROM Connection_Zamosc_Wroclaw
    WHERE Stations = @Start_Station;


    -- Determine from which segment to start calculations
    IF @Start_Station = 'Zamość'
        SET @Offset_ID = @Start_ID;      -- If Zamość, start from Route_segment_ID = 1
    ELSE
        SET @Offset_ID = @Start_ID + 1;  -- Otherwise, start from the next Route_segment_ID


    -- Retrieve schedule data
    SELECT 
        @Schedule_ID = Schedule_ID,
        @Departure_Time = Departure_Time,
        @Arrival_Time = (
            SELECT Arrival_Time
            FROM Connection_Zamosc_Wroclaw
            WHERE Stations = @End_Station
        )
    FROM Connection_Zamosc_Wroclaw
    WHERE Stations = @Start_Station;


    -- Retrieve travel day from the schedule table
    SELECT @Travel_Day = Travel_Day
    FROM Schedule
    WHERE Schedule_ID = @Schedule_ID;


    -- Randomly assign a seat and carriage
    SELECT TOP 1 @Carriage_Number = Carriage_Number, @Seat_Number = Seat_Number
    FROM Train_Capacity
    WHERE Schedule_ID = @Schedule_ID
      AND Is_Occupied = 0
    ORDER BY NEWID();  -- Random seat selection


    -- If no seats are available
    IF @Carriage_Number IS NULL OR @Seat_Number IS NULL
    BEGIN
        PRINT 'No available seats on the train for the selected date.';
        RETURN;
    END


    -- Mark the seat as occupied in the capacity table
    UPDATE Train_Capacity
    SET Is_Occupied = 1
    WHERE Schedule_ID = @Schedule_ID
      AND Carriage_Number = @Carriage_Number
      AND Seat_Number = @Seat_Number;


    -- Further part of the procedure, e.g. cost calculations and saving the reservation
    PRINT 'Reservation of seat in carriage: ' + CAST(@Carriage_Number AS NVARCHAR) + ', seat: ' + CAST(@Seat_Number AS NVARCHAR);


    -- Sum distances, costs, and time from the appropriate segment
    SELECT 
        @Total_Distance = SUM(Distance_Between_Stations),
        @Total_Cost = SUM(Cost_Between_Stations),
        @Total_Time = SUM(DATEDIFF(SECOND, '00:00:00', Duration))
    FROM 
        Connection_Zamosc_Wroclaw
    WHERE 
		Route_segment_ID >= @Offset_ID   -- Start from the appropriate segment
        AND Route_segment_ID <= (SELECT Route_segment_ID FROM Connection_Zamosc_Wroclaw WHERE Stations = @End_Station); -- Include the ending station


    -- Retrieve discount percentage from the Discounts table
    SELECT @Discount = Discount_Percent
    FROM Discounts
    WHERE Discount_Name = @Discount_Name;


    -- If no discount is found, set the default to 0%
    IF @Discount IS NULL
        SET @Discount = 0.00;


    PRINT 'Total cost before discount (zł): ' + CAST(@Total_Cost AS NVARCHAR);


    -- Apply the discount to calculate the final cost
    IF @Discount > 0 AND @Discount <= 100
        SET @Total_Cost = @Total_Cost * (1 - (@Discount / 100));


    -- Retrieve departure and arrival times from the schedule
    SELECT 
        @Schedule_ID = Schedule_ID,
        @Departure_Time = Departure_Time,
        @Arrival_Time = Arrival_Time
    FROM 
        Schedule
    WHERE 
		Source_Station = @Start_Station
        AND Destination_Station = @End_Station;


    -- If the sum was calculated correctly, display the result
    IF @Total_Distance > 0 AND @Total_Cost >= 0 AND @Total_Time > 0
    BEGIN
        -- Convert total time from seconds to HH:MM:SS format
        DECLARE @Hours INT = @Total_Time / 3600;
        DECLARE @Minutes INT = (@Total_Time % 3600) / 60;
        DECLARE @Seconds INT = @Total_Time % 60;


        PRINT 'Total distance (km): ' + CAST(@Total_Distance AS NVARCHAR);
        PRINT 'Total cost (zł): ' + CAST(@Total_Cost AS NVARCHAR);
        PRINT 'Total time: ' + RIGHT('00' + CAST(@Hours AS NVARCHAR), 2) + ':' + 
                                         RIGHT('00' + CAST(@Minutes AS NVARCHAR), 2) + ':' + 
                                         RIGHT('00' + CAST(@Seconds AS NVARCHAR), 2);


		 -- Add the reservation to the Reservations table
        INSERT INTO Ticket_Reservations (
            Passenger_ID, 
            Schedule_ID, 
            Price, 
            Reservation_Date, 
            Travel_Day,
            Departure_Time, 
            Arrival_Time, 
            Duration, 
            Start_Station, 
            End_Station, 
            Distance, 
            Carriage_Number, 
            Seat_Number, 
            Percentage_Discount, 
            Discount_Type, 
            Reservation_Status
        ) VALUES (
            @Passenger_ID, 
            @Schedule_ID, 
            @Total_Cost, 
            GETDATE(), 
			@Travel_Day,
            @Departure_Time, 
            @Arrival_Time, 
            DATEADD(SECOND, @Total_Time, '00:00:00'), 
            @Start_Station, 
            @End_Station, 
            @Total_Distance, 
            @Carriage_Number,
			@Seat_Number,
            @Discount, 
            @Discount_Name, 
            'Awaiting Payment'
        );


	    PRINT 'Reservation has been successfully added.';
        PRINT 'Reservation has been successfully added for the day ' + CONVERT(NVARCHAR, @Travel_Day, 23);
    END
    ELSE
    BEGIN
        PRINT 'No available connections for this route.';
    END
END;

EXEC Reservation_Route
	@Passenger_ID = 1,
	@Start_Station = 'Zamość',
	@End_Station = 'Wrocław',
	@Travel_Date = '2024-11-30',
	@Discount_Name = 'Student';

select *from Ticket_reservations

--Trigger → automatic return of places if record is deleted

CREATE TABLE Freed_Seats_History (
Event_ID INT IDENTITY PRIMARY KEY,
Reservation_ID INT NOT NULL,
Schedule_ID INT NOT NULL,
Carriage_Number INT NOT NULL,
Seat_Number INT NOT NULL,
Removal_Date DATETIME NOT NULL
);

create or alter TRIGGER ReturnSeatAfterDeletion
ON Ticket_Reservations
AFTER DELETE
AS
BEGIN
    -- Update the train capacity table
    UPDATE Train_Capacity
    SET Is_Occupied = 0
    FROM Train_Capacity T
    INNER JOIN deleted D ON  T.Schedule_ID = D.Schedule_ID
                       AND T.Carriage_Number = D.Carriage_Number
                       AND T.Seat_Number = D.Seat_Number;

    -- Add a record to the history of freed seats
    INSERT INTO Freed_Seats_History  (Reservation_ID, Schedule_ID, Carriage_Number, Seat_Number, Removal_Date)
    SELECT 
        D.Reservation_ID,
        D.Schedule_ID,
        D.Carriage_Number,
        D.Seat_Number,
        GETDATE()
    FROM deleted D;

    PRINT 'The seat has been returned and recorded in the history of freed seats.';
END;

delete from Ticket_reservations where Reservation_ID=5;

select *from Freed_Seats_History
select *from Ticket_Reservations
select *from train_capacity