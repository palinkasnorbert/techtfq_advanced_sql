-- Query 3:

/*
3. Write a SQL query to display only the details of employees who either earn the highest salary or the lowest salary in each department from the employee table.

Table Name: EMPLOYEE

Approach: 
Write a sub query which will partition the data based on each department and then identify the record with maximum and minimum salary for each of the partitioned department.
Finally, from the main query fetch only the data which matches the maximum and minimum salary returned from the sub query.
 
*/
--Tables Structure:

drop table if exists employee;
    create table employee
    ( emp_ID int primary key
    , emp_NAME varchar(50) not null
    , DEPT_NAME varchar(50)
    , SALARY int);

    insert into employee values(101, 'Mohan', 'Admin', 4000);
    insert into employee values(102, 'Rajkumar', 'HR', 3000);
    insert into employee values(103, 'Akbar', 'IT', 4000);
    insert into employee values(104, 'Dorvin', 'Finance', 6500);
    insert into employee values(105, 'Rohit', 'HR', 3000);
    insert into employee values(106, 'Rajesh',  'Finance', 5000);
    insert into employee values(107, 'Preet', 'HR', 7000);
    insert into employee values(108, 'Maryam', 'Admin', 4000);
    insert into employee values(109, 'Sanjay', 'IT', 6500);
    insert into employee values(110, 'Vasudha', 'IT', 7000);
    insert into employee values(111, 'Melinda', 'IT', 8000);
    insert into employee values(112, 'Komal', 'IT', 10000);
    insert into employee values(113, 'Gautham', 'Admin', 2000);
    insert into employee values(114, 'Manisha', 'HR', 3000);
    insert into employee values(115, 'Chandni', 'IT', 4500);
    insert into employee values(116, 'Satya', 'Finance', 6500);
    insert into employee values(117, 'Adarsh', 'HR', 3500);
    insert into employee values(118, 'Tejaswi', 'Finance', 5500);
    insert into employee values(119, 'Cory', 'HR', 8000);
    insert into employee values(120, 'Monica', 'Admin', 5000);
    insert into employee values(121, 'Rosalin', 'IT', 6000);
    insert into employee values(122, 'Ibrahim', 'IT', 8000);
    insert into employee values(123, 'Vikram', 'IT', 8000);
    insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

-- MY SOLUTION

WITH dep_min_max_salaries AS (
    SELECT dept_name, MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employee GROUP BY dept_name
)

SELECT e.*
  FROM employee AS e
       INNER JOIN dep_min_max_salaries AS d
       ON e.dept_name = d.dept_name
 WHERE e.salary = d.min_salary 
       OR e.salary = d.max_salary

/* -- Original Solution:
    select x.*
    from employee e
    join (select *,
    max(salary) over (partition by dept_name) as max_salary,
    min(salary) over (partition by dept_name) as min_salary
    from employee) x
    on e.emp_id = x.emp_id
    and (e.salary = x.max_salary or e.salary = x.min_salary)
    order by x.dept_name, x.salary; */