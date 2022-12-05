create schema world_populations;
use world_populations;

create table if not exists population(
    Country varchar(60),
    area int,
    birth_rate decimal(12,2),
    death_rate decimal(12,2),
    infant_mortality_rate decimal(12,2),
    internet_users int,
    life_exp_at_birth decimal(12,2),
    maternal_mortality_rate int,
    net_migration_rate decimal(12,2),
    population int,
    population_growth_rate decimal(12,2)
);

/*load the dataset*/ 

load data infile 'D:\\Shahequa Analytics\\cia_factbook.csv'
into table population
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

/*view the datasets*/

select * from population;


/*1. Which country has the highest population?*/

SELECT COUNTRY 
FROM POPULATION 
WHERE POPULATION  NOT IN ('NA')
ORDER BY POPULATION DESC 
LIMIT 1;

-- "China" country has the highest population.  

/*2. Which country has the least number of people?*/

SELECT COUNTRY 
FROM POPULATION 
WHERE POPULATION  NOT IN ('NA')
ORDER BY POPULATION LIMIT 1;

-- "Pitcairn Islands" has the least nubmer of people.

/*3. Which country is witnessing the highest population growth?*/

SELECT COUNTRY
FROM POPULATION 
ORDER BY population_growth_rate DESC
LIMIT 1;

-- "Lebanon" country has the highest population growth rate

/*4. Which country has an extraordinary number for the population?*/

SELECT COUNTRY, AVG(POPULATION)
FROM POPULATION
GROUP BY COUNTRY
ORDER BY 2 DESC LIMIT 5;

/*5. Which is the most densely populated country in the world?*/

SELECT COUNTRY 
FROM 
	(SELECT *, POPULATION/AREA AS POPULATION_DENSITY
	FROM POPULATION) AS POP_DENSITY_TABLE
ORDER BY POPULATION_DENSITY DESC 
LIMIT 1;