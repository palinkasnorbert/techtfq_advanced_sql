-- Query 6:


/* 

From the students table, write a SQL query to interchange the adjacent student names.

Note: If there are no adjacent student then the student name should stay the same.

Table Name: STUDENTS

Approach: 
Assuming id will be a sequential number always. 
If id is an odd number then fetch the student name from the following record. 
If id is an even number then fetch the student name from the preceding record. 
Try to figure out the window function which can be used to fetch the preceding the following record data. 

If the last record is an odd number then it wont have any adjacent even number hence figure out a way to not interchange the last record data. */

--Table Structure:

    drop table if exists students;
    create table students
    (
    id int primary key,
    student_name varchar(50) not null
    );
    insert into students values
    (1, 'James'),
    (2, 'Michael'),
    (3, 'George'),
    (4, 'Stewart'),
    (5, 'Robin');

    select * from students;

--MY SOLUTION

SELECT id,
       student_name,
       CASE WHEN
       id % 2 <> 0 THEN LEAD(student_name, 1, student_name) OVER (ORDER BY id) -- modulo check id = if id is not even then use lead(get next name, if next is null then default to student_name)
       WHEN id % 2 = 0 THEN LAG(student_name) OVER (ORDER BY id) -- modulo check if id is even, then get previous name. order by id renders data in correct order
       END AS switched_name
  FROM students;


--Solution:

    select id,student_name,
    case when id%2 <> 0 then lead(student_name,1,student_name) over(order by id)
    when id%2 = 0 then lag(student_name) over(order by id) end as new_student_name
    from students;