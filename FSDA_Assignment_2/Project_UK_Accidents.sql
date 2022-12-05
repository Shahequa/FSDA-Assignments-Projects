CREATE SCHEMA accidents;

USE accidents;

/* -------------------------------- */
/* Create Tables */

CREATE TABLE accident(
    accident_index VARCHAR(13),
    accident_severity INT
);

CREATE TABLE vehicles(
    accident_index VARCHAR(13),
    vehicle_type VARCHAR(50)
);

CREATE TABLE vehicle_types(
    vehicle_code INT,
    vehicle_type VARCHAR(100)
);

/* -------------------------------- */
/* Load Data */

LOAD DATA INFILE 'D:\\Shahequa Analytics\\Accidents_2015.csv'
INTO TABLE accident
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2;


LOAD DATA INFILE 'D:\\Shahequa Analytics\\Vehicles_2015.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;


LOAD DATA INFILE 'D:\\Shahequa Analytics\\vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* -------------------------------- */

/*check the loaded tables*/

select * from accident;
select * from vehicle_types;
select * from vehicles;

/*Task 1.
Evaluate the median severity value of accidents caused by various Motorcycles.*/

CREATE TABLE accidents_median(
vehicle_type VARCHAR(100),
severity INT
);

select * from accidents_median;  

SET @rowindex := -1;
SELECT
   AVG(NEW_TABLE.Accident_Severity) AS MEDIAN
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           LABEL, Accident_Severity
    FROM ACCIDENTS_2015 A LEFT JOIN VEHICLES_2015 V ON A.Accident_Index = V.Accident_Index
	LEFT JOIN VEHICLE_TYPE VT ON V.Vehicle_Type = VT.`CODE`
    ORDER BY Accident_Severity) AS NEW_TABLE
WHERE
NEW_TABLE.rowindex IN (FLOOR(@rowindex / 2) , CEIL(@rowindex / 2));

/*Task 2. 
Evaluate Accident Severity and Total Accidents per Vehicle Type*/

SELECT vt.vehicle_type AS 'Vehicle Type', a.accident_severity AS 'Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;

/*Task 3. 
Calculate the Average Severity by vehicle type.*/

SELECT vt.vehicle_type AS 'Vehicle Type', AVG(a.accident_severity) AS 'Average Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;

/*Task 4. 
Calculate the Average Severity and Total Accidents by Motorcycle.*/

SELECT vt.vehicle_type AS 'Vehicle Type', AVG(a.accident_severity) AS 'Average Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_type LIKE '%otorcycle%'
GROUP BY 1
ORDER BY 2,3;

