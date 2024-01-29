-- Query 1:

/* Write a SQL query to fetch all the duplicate records from a table. 

Table Name: USERS

Note: 
Record is considered duplicate if a user name is present more than once.

Approach: 
Partition the data based on user name and then give a row number to each of the partitioned user name. 
If a user name exists more than once then it would have multiple row numbers.
Using the row number which is other than 1, we can identify the duplicate records.*/

--Tables Structure:

drop table if exists users;  -- added if exists to be able to rerun code indefinitely
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users;

-- My solution:

WITH duplicate_users AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY user_name ORDER BY user_name) AS rn
      FROM users
)

SELECT user_id,
       user_name,
       email
  FROM duplicate_users
 WHERE rn <> 1

/* Original solutions:

-- Solution 1:

-- Replace ctid with rowid for Oracle, MySQL and Microsoft SQLServer
select *
from users u
where u.rowid not in (
select min(rowid) as rowid
from users
group by user_name
order by rowid);


-- Solution 2: Using window function.

select user_id, user_name, email
from (
select *,
row_number() over (partition by user_name order by user_id) as rn
from users u
order by user_id) x
where x.rn <> 1; */