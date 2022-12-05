create schema if not exists accidents;

use accidents;

-- creating tables 

-- accident table 
create table if not exists accident(
	accident_index varchar(13),
    accident_severity int   -- condition of being severe.
    );

-- vehicles table 
create table if not exists vehicles(
	accident_index varchar(13),
    vehicle_type varchar(50)
    );
    
-- vehicle types 
create table if not exists vehicle_types(
	vehicle_code int,
    vehicle_type varchar(40)
    );
   
  -- load data in the above three tables
  
  load data infile 'G:\Accidents_2015.csv'
  into table accident
  fields terminated by ','
  enclosed by '"'
  lines terminated by '\n'
  ignore 1 lines 
  (@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2,@dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
  set accident_index = @col1, accident_severity=@col2;
  
  load data infile 'G:\Vehicles_2015.csv'
  into table vehicles
  fields terminated by ','
  enclosed by '"'
  lines terminated by '\n'
  ignore 1 lines 
  (@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;

load data infile 'G:\Vehicle_types.csv'
into table vehicle_types
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;


-- check the tables 

select * from accident;
select * from vehicle_types;
select * from vehicles;

-- Task 1
-- Median severity value of accidents caused by various Motorcycles.

create table if not exists accidents_median(
	vehicle_type varchar(100),
    severity int
    );
    
select * from accidents_median;    

select vt.vehicle_type, a.accident_severity 
from accident a
join vehicles v on a.accident_index = v.accident_index
join vehicle_types vt on v.vehicle_type = vt.vehicle_code
group by 1
order by 2;

-- Task 2 
-- Accident Severity and Total Accidents per Vehicle Type
select vt.vehicle_type as 'Vehicle Type', a.accident_severity as 'Severity', count(vt.vehicle_type)  as 'Number of accidents'
from accident a
join vehicles v on a.accident_index = v.accident_index
join vehicle_types vt on v.vehicle_type = vt.vehicle_code
group by 1
order by 2,3;

-- Task 3
-- Average Severity by vehicle type.

select vt.vehicle_type as 'Vehicle_types', avg(a.accident_index) as 'Average Severity', count(vt.vehicle_type) as 'Number of Accidents'
from accident a 
join vehicles v on a.accident_index = v.accident_index
join vehicle_types vt on v.vehicle_type = vt.vehicle_code
group by 1
order by 2,3;

-- Task 4 
-- Average Severity and Total Accidents by Motorcycle.
select vt.vehicle_type as 'Vehicle_type',  avg(a.accident_severity) as 'Accident_Severity', count(vt.vehicle_type) as 'Number of Accident'
from accident a 
join vehicles v on a.accident_index = v.accident_index 
join vehicle_types vt on v.vehicle_type = vt.vehicle_code
group by 1
order by 2,3;

select vt.vehicle_type as 'Vehicle_types', avg(accident_severity) as ' Accident Severity', count(vt.vehicle_type) as 'Number of Accidents'
from accident a 
join vehicles v on a.accident_index = v.accident_index
join vehicle_types vt on v.vehicle_type = vt.vehicle_code
where vt.vehicle_type like '%otorcycle%' 
group by 1
order by 2,3;