/*

7. From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

Note: Weather is considered to be extremely cold when its temperature is less than zero.

Table Name: WEATHER

Approach (from blog): 
First using a sub query identify all the records where the temperature was very cold and then use a main query to fetch only the records returned as very cold from the sub query. 
You will not only need to compare the records following the current row but also need to compare the records preceding the current row. 
And may also need to compare rows preceding and following the current row. Identify a window function which can do this comparison pretty easily.

*/

USE techfq;
GO

DROP TABLE IF EXISTS weather;
GO

BEGIN
    CREATE TABLE Weather
    (
        id INT,
        city VARCHAR(50),
        temperature INT,
        day DATE
    );

    DELETE FROM weather;

    INSERT INTO weather 
    VALUES
        (1, 'London', -1, CAST(N'2021-01-01' AS date)),
        (2, 'London', -2, CAST(N'2021-01-02' AS date)),
        (3, 'London', 4, CAST(N'2021-01-03' AS date)),
        (4, 'London', 1, CAST(N'2021-01-04' AS date)),
        (5, 'London', -2, CAST(N'2021-01-05' AS date)),
        (6, 'London', -5, CAST(N'2021-01-06' AS date)),
        (7, 'London', -7, CAST(N'2021-01-07' AS date)),
        (8, 'London', 5, CAST(N'2021-01-08' AS date));
END
GO

SELECT * FROM weather;

/* 
My approach:
Using CTE for readability, check the prior and following days with LAG and LEAD combinations.
*/

WITH extreme_cold AS (
    SELECT * FROM weather WHERE temperature < 0 -- filter values for temps below 0.
),
consec_colds AS (
    SELECT *,
        CASE WHEN -- if +1 and +2 days are consecutively coming after current row, then flag as valid with 'Y'.
        DATEADD(day, 1, day) = LEAD(day, 1, NULL) OVER (ORDER BY day) AND
        DATEADD(day, 2, day) = LEAD(day, 2, NULL) OVER (ORDER BY day) 
        THEN 'Y'
        WHEN -- if -1 and +1 days are consecutively coming before & after current row, then flag as valid with 'Y'.
        DATEADD(day, -1, day) = LAG(day, 1, NULL) OVER (ORDER BY day) AND
        DATEADD(day, 1, day) = LEAD(day, 1, NULL) OVER (ORDER BY day) 
        THEN 'Y'
        WHEN -- if -1 and -2 days are consecutively coming before current row, then flag as valid with 'Y'.
        DATEADD(day, -1, day) = LAG(day, 1, NULL) OVER (ORDER BY day) AND
        DATEADD(day, -2, day) = LAG(day, 2, NULL) OVER (ORDER BY day) 
        THEN 'Y'
        ELSE NULL -- else flag is NULL
        END AS flag
    FROM extreme_cold
)

SELECT id, city, temperature, day
FROM consec_colds
WHERE flag = 'Y' -- select flagged, order by day
ORDER BY day;