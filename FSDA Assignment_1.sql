--Task 1
--Q. Write an SQL query that, for each "product", returns the total amount of money spent on it.
--Rows should be ordered in descendind alphabetical order by "product".

create database shopping;
use shopping;

create table shopping_history(
product varchar(20) not null,
quantity integer not null,
unit_price integer not null
);

insert into shopping_history values('milk',3,10),('bread',7,3),('bread',5,2),('butter',8,4),
('chocolate',5,10),('milk',6,4),('maggi',5,5),('chocos',9,4),('cheese',7,20),('maggi',6,8);

select * from shopping_history;

select product, sum(total_amount) as total_amount 
from (select *, quantity * unit_price as total_amount from shopping_history) as t 
group by product 
order by product desc;


--Task 2 
--Q. Write an sql query to find all clients who talked for atleast 10 mins in total.
--The table of results should contain one column: thr name of the client(name).
--Rows should be sorted alphabetically.

--Part 1

create database telecommunications;

use "TELECOMMUNICATIONS";

create table phones(
name varchar (20) not null unique,
phone_number int not null unique) 

insert into phones values ('Jack' , 1234 ),('Leena' , 3333),('Mark',9999),('Anna',7582)

select * from "TELECOMMUNICATIONS"."PUBLIC"."PHONES"

create table calls(
id int not null,
caller int not null,
callee int not null,
duration int not null,
unique(id))

insert into calls values (25,1234,7582,8),(7,9999,7582,1),(18,9999,3333,4),(2,7582,3333,3),
(3,3333,1234,1),(21,3333,1234,1);

select * from "TELECOMMUNICATIONS"."PUBLIC"."CALLS"

with call_details as(
select caller as phone_no, sum(duration) as call_duration from calls group by caller
union
select callee as phone_no, sum(duration) as call_duration from calls group by callee)
select p.name from phones p join call_details cd on p.phone_number = cd.phone_no 
group by name 
having sum(call_duration)>=10 
order by name

--Part 2

create table phones1(
name varchar (20) not null unique,
phone_number int not null unique) 

insert into phones1 values ('John',6356),('Addison',4315),('Kate',8003),('Ginny',9831)

select * from "TELECOMMUNICATIONS"."PUBLIC"."PHONES1"

create table calls1(
id int not null unique,
caller int not null,
callee int not null,
duration int not null)

insert into calls1 values (65,8003,9831,7),(100,9831,8003,3),(145,4315,8003,18)

select * from "TELECOMMUNICATIONS"."PUBLIC"."CALLS1"

with call_details1 as(
select caller as phone_no, sum(duration) as call_duration from calls1 group by caller
union
select callee as phone_no, sum(duration) as call_duration from calls1 group by callee)
select p1.name from phones1 p1 join call_details1 cd1 on p1.phone_number = cd1.phone_no 
group by name 
having sum(call_duration)>=10 
order by name


--Task 3
--Q. Write an SQL query that returns a table containing one column, balance.
--The table should contain one row with the total balance of your account at the end of year, including fee for holding a credit card.

--Part 1

create database transactions

use "TRANSACTIONS"

create table transactions (
amount int not null,
date date not null)

insert into transactions values (1000, '2020-01-06'),(-10, '2020-01-14'),
(-75, '2020-01-20'),(-5, '2020-01-25'),(-4, '2020-01-29'),(2000, '2020-03-10'),(-75, '2020-03-12'),
(-20, '2020-03-15'),(40, '2020-03-15'),(-50, '2020-03-17'),(200, '2020-10-10'),(-200, '2020-10-10')

select * from transactions

select sum(t1.balance) - sum(t2.balance) as total_balance 
from (select 1 as id, sum(amount) as balance from transactions) as t1
join (select 1 as id, count(date)*11 as balance from transactions where month (date) = 03)
as t2 on t1.id = t2.id


--Part 2

create table transactions1(
amount int not null,
date date not null)

insert into transactions1 values (1, '2020-06-29'), (35, '2020-02-20'), (-50, '2020-02-03'), (-1, '2020-02-26'), (-200, '2020-08-01'),
(-44, '2020-02-07'),(-5, '2020-02-25'),(1, '2020-06-29'),(1, '2020-06-29'),(-100, '2020-12-29'),(-100, '2020-12-30'),(-100, '2020-12-31')

select * from transactions1

with credit_card as (select sum(amount) as total_balance, count(amount) as transaction_no
from transactions1
where amount<0
group by year(date), month(date)
having total_balance <=-100 and transaction_no >=3)
select sum(amount)-(5*(12-(select count(*) from credit_card))) as balance from transactions1;


--Part 3

create table transactions2(
amount int not null, 
date date not null)

insert into transactions2 values (6000, '2020-04-03'),(5000, '2020-04-02'),(4000, '2020-04-01'),
(3000, '2020-03-01'),(2000, '2020-02-01'),(1000, '2020-01-01')

with card_payments as (select sum(amount) as total_balance, count(amount) as transaction_no
from transactions2
where amount<0
group by year(date), month(date)
having total_balance <=-100 and transaction_no >=3)
select sum(amount)-(5*(12-(select count(*) from card_payments))) as balance from transactions2;

