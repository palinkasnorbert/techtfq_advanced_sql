-- Query 5:
/* 
5. From the login_details table, fetch the users who logged in consecutively 3 or more times.

Table Name: LOGIN_DETAILS

Approach: 
We need to fetch users who have appeared 3 or more times consecutively in login details table. 
There is a window function which can be used to fetch data from the following record. 
Use that window function to compare the user name in current row with user name in the next row and in the row following the next row. If it matches then fetch those records.
 */

--Table Structure:

    drop table if exists login_details; -- add if exists
    create table login_details(
    login_id int primary key,
    user_name varchar(50) not null,
    login_date date);

    delete from login_details;
    insert into login_details values
    (101, 'Michael', GETDATE()),  -- sql server needs GETDATE() instead of current_date
    (102, 'James', GETDATE()),
    (103, 'Stewart', GETDATE()+1),
    (104, 'Stewart', GETDATE()+1),
    (105, 'Stewart', GETDATE()+1),
    (106, 'Michael', GETDATE()+2),
    (107, 'Michael', GETDATE()+2),
    (108, 'Stewart', GETDATE()+3),
    (109, 'Stewart', GETDATE()+3),
    (110, 'James', GETDATE()+4),
    (111, 'James', GETDATE()+4),
    (112, 'James', GETDATE()+5),
    (113, 'James', GETDATE()+6);

    select * from login_details;

-- MY SOLUTION
WITH consec_check AS (
    SELECT *,
           CASE WHEN
           user_name = LEAD(user_name, 1, NULL) OVER (ORDER BY login_id) AND
           user_name = LEAD(user_name, 2, NULL) OVER (ORDER BY login_id)
           THEN 'Y'
           ELSE NULL
           END AS consecutive
      FROM login_details
)

SELECT DISTINCT user_name FROM consec_check WHERE consecutive = 'Y'

-- ORIGINAL Solution:

    select distinct repeated_names
    from (
    select *,
    case when user_name = lead(user_name) over(order by login_id)
    and  user_name = lead(user_name,2) over(order by login_id)
    then user_name else null end as repeated_names
    from login_details) x
    where x.repeated_names is not null;