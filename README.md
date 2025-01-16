# Project-SQL-Server---railway-system-modified
The database contains a modified Schedule and added discount tables, ZamośćWrocław connection, train capacity.

The ZamośćWrocław connection table contains the names of direct stations, distances between them, costs and duration.
The Train_capacity table contains the carriage and seat number of a given train and timetable. Also information on whether a seat is free or occupied.
The discount table contains information about the discount names and the discount percentage.

Procedure for selecting a route and booking a ticket
The procedure allows the passenger to select the starting and ending station for themselves (only on the Zamosc-Wroclaw route), e.g. Zamosc to KrakowGlowny 
from the table connections_Zamosc_Wroclaw, (or Tarnow-Rzeszow Glowny or Katowice-Wroclaw). The passenger provides the passenger_ID, discount type, travel date. 
The procedure calculates the distance between stations, total cost, total travel time. It randomly selects a carriage and a seat for the passenger. 
This information will be inserted into the table tickets_reservations. If the conditions are not met, the system will display appropriate messages.

Trigger - automatic return of places if record is deleted

