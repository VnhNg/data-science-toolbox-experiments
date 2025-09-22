-- Create Database
DROP DATABASE IF EXISTS `Parks_and_Recreation`;
CREATE DATABASE `Parks_and_Recreation`;
USE `Parks_and_Recreation`;






CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');

select * 
from employee_demographics;
-- 1
-- Select Statements
select * 
from parks_and_recreation.employee_demographics;

select first_name
from parks_and_recreation.employee_demographics;

select distinct first_name, gender
from parks_and_recreation.employee_demographics;

-- 2
-- Where Clauses
select * 
from employee_demographics
where gender != 'Female';

-- logical operators
select * 
from employee_demographics
where not gender = 'Female';

select *
from employee_demographics
where (birth_date >= '1987-03-04' and gender = 'male') or age < 40;

-- like statement
select * 
from employee_demographics
where first_name like '%jer%';

select * 
from employee_demographics
where first_name like 'jer__';

select * 
from employee_demographics
where first_name like 'jer_';

-- 3
-- Group by
select gender, avg(age), count(age)
from employee_demographics
group by gender;

-- Order by
select *
from employee_demographics
order by gender desc, age desc;

-- 4
-- Having
select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 60000;

-- 5
-- Limit
select * 
from employee_salary
limit 3; 

select * 
from employee_salary
limit 1, 1; 

-- Aliasing
select gender, avg(age) as avg_age
from employee_demographics
group by gender
having avg(age) > 40;

-- 6
-- (Inner) Joins
select dem.first_name, age, salary
from employee_demographics as dem join employee_salary as sal on dem.employee_id = sal.employee_id;

-- Outer Joins
select dem.employee_id, dem.first_name, age, salary
from employee_demographics as dem left outer join employee_salary as sal on dem.employee_id = sal.employee_id;

select dem.employee_id, sal.employee_id, age, salary
from employee_demographics as dem right outer join employee_salary as sal on dem.employee_id = sal.employee_id;

-- Multiple Tables Joins
select * 
from employee_demographics as dem 
join employee_salary as sal on dem.employee_id = sal.employee_id
join parks_departments as pd on sal.dept_id = pd.department_id;

-- 7
-- Unions
select employee_id, first_name, last_name, 'old' as label 
from employee_demographics
where age > 50
union
select employee_id, first_name, last_name, 'high_paid'  
from employee_salary
where salary > 70000
order by employee_id;

-- 8
-- String Functions
select employee_id, concat(first_name, ' ', last_name) as full_name 
from employee_salary;

-- 9
-- Case Statements
select first_name, last_name, salary, occupation,
case
when salary < 50000 then salary * 1.1
else salary * 1.05
end as new_salary,
case
when occupation like '%manager%' then salary * 0.1
else 0
end as bonus
from employee_salary;

-- 10
-- Subqueries
select *
from employee_demographics
where employee_id in 
(select employee_id 
from employee_salary
where dept_id = 1);

select *, 
(select avg(salary)
from employee_salary) as avg_salary
from employee_salary;

select avg(avg_age), avg(max_age), avg(min_age), avg(count)
from
(select gender, avg(age) as avg_age, min(age) as min_age, max(age) as max_age, count(age) as count
from employee_demographics
group by gender) as summary;

-- 11
-- Window Functions
select dem.first_name, dem.last_name, gender, salary,
avg(salary) over(partition by gender) as avg_by_gender
from employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(order by dem.employee_id) as rolling
from employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id;

select dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary) as row_num,
rank() over(partition by gender order by salary) as rank_num,
dense_rank() over(partition by gender order by salary) as rank_num
from employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id;

-- 12
-- CTEs
with CTE as
(select gender, avg(salary) avg_salary, min(salary) min_salary, max(salary) max_salary
from employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
group by gender)
select *
from CTE;

with CTE_dem as
(select *
from employee_demographics 
where age < 50),
CTE_sal as
(select * 
from employee_salary
where salary > 50000)
select CTE_dem.employee_id, CTE_dem.first_name, CTE_dem.last_name, age, salary
from CTE_dem join CTE_sal on CTE_dem.employee_id = CTE_sal.employee_id;

-- 13
-- Temporary Tables
create temporary table young_employee
select *
from employee_demographics
where age < 30;

select * 
from young_employee;

-- 14
-- Stored Procedures
DELIMITER $$
drop procedure if exists employee_tables;
create procedure employee_tables()
begin
    select * 
    from employee_demographics;
    select * 
    from employee_salary;
end $$
DELIMITER ;

call employee_tables();

DELIMITER $$
drop procedure if exists young_employee_salary;
create procedure young_employee_salary(oldest int)
begin
    select dem.employee_id, dem.first_name, dem.last_name, age, salary
    from employee_demographics dem join employee_salary sal on dem.employee_id = sal.employee_id
    where age <= oldest ; 
end $$
DELIMITER ;

call young_employee_salary(50);

call young_employee_salary(40);

-- 15
-- Triggers 
delimiter $$
drop trigger if exists employee_insert;
create trigger employee_insert
after insert on employee_salary
for each row
begin
	insert into employee_demographics (employee_id, first_name, last_name)
	values (new.employee_id, new.first_name, new.last_name);
end$$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values (13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 100000, null);

select *
from employee_demographics;

-- Events
delimiter $$
drop event if exists delete_retirees;
create event delete_retirees
on schedule every 1 minute
do 
begin 
	delete
	from employee_demographics
	where age >= 60;
end$$
delimiter ;

select *
from employee_demographics;

show variables like 'event%';











