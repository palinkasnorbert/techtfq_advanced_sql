-- Query 8:

/*
From the following 3 tables (event_category, physician_speciality, patient_treatment),
write a SQL query to get the histogram of specialities of the unique physicians
who have done the procedures but never did prescribe anything.


Table Name: EVENT_CATEGORY, PHYSICIAN_SPECIALITY, PATIENT_TREATMENT

Approach: 
Using the patient treatment and event category table, identify all the physicians who have done “Prescription”. 
Have this recorded in a sub query. 
Then in the main query join the patient treatment, event category and physician speciality table to identify all the physician who have done “Procedure”. 
From these physicians, remove those physicians you got from sub query to return the physicians who have done Procedure but never did Prescription.

*/

--Table Structure:

drop table if exists event_category;
create table event_category
(
  event_name varchar(50),
  category varchar(100)
);

drop table physician_speciality;
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

drop table patient_treatment;
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);


insert into event_category values ('Chemotherapy','Procedure');
insert into event_category values ('Radiation','Procedure');
insert into event_category values ('Immunosuppressants','Prescription');
insert into event_category values ('BTKI','Prescription');
insert into event_category values ('Biopsy','Test');


insert into physician_speciality values (1000,'Radiologist');
insert into physician_speciality values (2000,'Oncologist');
insert into physician_speciality values (3000,'Hermatologist');
insert into physician_speciality values (4000,'Oncologist');
insert into physician_speciality values (5000,'Pathologist');
insert into physician_speciality values (6000,'Oncologist');


insert into patient_treatment values (1,'Radiation', 1000);
insert into patient_treatment values (2,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 1000);
insert into patient_treatment values (3,'Immunosuppressants', 2000);
insert into patient_treatment values (4,'BTKI', 3000);
insert into patient_treatment values (5,'Radiation', 4000);
insert into patient_treatment values (4,'Chemotherapy', 2000);
insert into patient_treatment values (1,'Biopsy', 5000);
insert into patient_treatment values (6,'Chemotherapy', 6000);


select * from patient_treatment;
select * from event_category;
select * from physician_speciality;

/* My soltion

Approach: 
    * Avoiding subqueries (as always), using CTE with prescriptor physician_id's. 
    * Join the tables together and using LEFT ANTI JOIN pattern** to filter out all the physician_id's who were doing prescriptions
        **  SELECT a.i
            FROM a
            LEFT JOIN b ON (a.i = b.i)
            WHERE b.i IS NULL;
        **  more info: https://www.crunchydata.com/blog/rise-of-the-anti-join
 */

WITH prescriptors AS (
    SELECT pt.physician_id
    FROM patient_treatment AS pt
    INNER JOIN event_category AS ec ON pt.event_name = ec.event_name
    WHERE ec.category = 'Prescription'
)

SELECT ps.speciality, COUNT(*) AS speciality_count -- count the specialties
FROM patient_treatment AS pt
INNER JOIN event_category ec ON ec.event_name = pt.event_name
INNER JOIN physician_speciality ps ON ps.physician_id = pt.physician_id
LEFT JOIN prescriptors AS pct ON pct.physician_id = pt.physician_id -- LEFT ANTI JOIN pt 1/2
WHERE ec.category = 'Procedure' AND pct.physician_id IS NULL -- who did procedures only AND no prescriptions (LEFT ANTI JOIN pt 2/2)
GROUP BY ps.speciality

/* Original solution

select ps.speciality, count(1) as speciality_count
from patient_treatment pt
join event_category ec on ec.event_name = pt.event_name
join physician_speciality ps on ps.physician_id = pt.physician_id
where ec.category = 'Procedure'
and pt.physician_id not in (select pt2.physician_id
 							from patient_treatment pt2
 							join event_category ec on ec.event_name = pt2.event_name
							where ec.category in ('Prescription'))
group by ps.speciality;

 */