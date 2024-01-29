/* 
9. Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

Note: Prefer the account id with the least value in case of same number of unique patients

Table Name: PATIENT_LOGS

Approach: 
First convert the date to month format since we need the output specific to each month. 
Then group together all data based on each month and account id so you get the total no of patients belonging to each account per month basis. 

Then rank this data as per no of patients in descending order and account id in ascending order so in case there are same no of patients present under multiple account if then the ranking will prefer the account if with lower value. Finally, choose upto 2 records only per month to arrive at the final output.
 */

--Table Structure:

    drop table if exists patient_logs;  -- added if exists
    create table patient_logs
    (
    account_id int,
    date date,
    patient_id int
    );

    insert into patient_logs values (1, CONVERT(DATE, '02-01-2020', 105), 100);  -- using CONVERT instead to to_date. 105 is the string format
    insert into patient_logs values (1, CONVERT(DATE, '27-01-2020', 105), 200);
    insert into patient_logs values (2, CONVERT(DATE, '01-01-2020', 105), 300);
    insert into patient_logs values (2, CONVERT(DATE, '21-01-2020', 105), 400);
    insert into patient_logs values (2, CONVERT(DATE, '21-01-2020', 105), 300);
    insert into patient_logs values (2, CONVERT(DATE, '01-01-2020', 105), 500);
    insert into patient_logs values (3, CONVERT(DATE, '20-01-2020', 105), 400);
    insert into patient_logs values (1, CONVERT(DATE, '04-03-2020', 105), 500);
    insert into patient_logs values (3, CONVERT(DATE, '20-01-2020', 105), 450);

    select * from patient_logs;

-- MY SOLUTION with CTE's for readability and fewer steps

-- Step 1. structure data, get month names, accounts, distinct count of patient_ids
WITH unique_patient_counts AS (
    SELECT DATENAME(MONTH, date) AS month_name,
           account_id,
           COUNT(DISTINCT patient_id) AS unique_patient_count
      FROM patient_logs
     GROUP BY DATENAME(MONTH, date), account_id
),
-- Step 2. build rankings
rankings AS (
    SELECT *,
           -- RANK and DENSE RANK wouldn't work here because when there are ties, they will give the same value to the tied values
           ROW_NUMBER() OVER (PARTITION BY month_name ORDER BY unique_patient_count DESC) AS rnk 
      FROM unique_patient_counts
)
-- Step 3. filter TOP 2 ranks per month
SELECT month_name,
       account_id,
       unique_patient_count 
  FROM rankings 
 WHERE rnk < 3;

/* -- Original Solution:
    select a.month, a.account_id, a.no_of_unique_patients
    from (
            select x.month, x.account_id, no_of_unique_patients,
                row_number() over (partition by x.month order by x.no_of_unique_patients desc) as rn
            from (
                    select pl.month, pl.account_id, count(1) as no_of_unique_patients
                    from (select distinct DATENAME(MONTH, date) as month, account_id, patient_id
                            from patient_logs) pl
                    group by pl.month, pl.account_id) x
        ) a
    where a.rn < 3; */