-- Q5:What percentage of officers have the same race with the filer of their complaints?

DROP TABLE IF EXISTS join_tbl;
CREATE TEMP TABLE join_tbl
AS (
    SELECT a.allegation_id,
           a.officer_id,
           data_complainant.race as com_race
    FROM data_officerallegation as a
             FULL OUTER JOIN data_complainant
                             ON a.allegation_id = data_complainant.allegation_id
)

DROP TABLE IF EXISTS join_tbl2;
CREATE TEMP TABLE join_tbl2
AS (
    SELECT c.allegation_id,
           c.officer_id,
           c.com_race,
           b.race as off_race
    FROM join_tbl as c
             FULL OUTER JOIN data_officer as b
                             ON c.officer_id = b.id
)

DROP TABLE IF EXISTS join_tbl3;
CREATE TEMP TABLE join_tbl3
AS (
    SELECT com_race, off_race, COUNT(*)
    FROM join_tbl2
    GROUP BY com_race, off_race
)

DROP TABLE IF EXISTS join_tbl4;
CREATE TEMP TABLE join_tbl4
AS (
    SELECT com_race, off_race, count
    FROM join_tbl3
    WHERE NULLIF(com_race, '') is not null
)

DROP TABLE IF EXISTS join_tbl5;
CREATE TEMP TABLE join_tbl5
AS (
    SELECT com_race, off_race, count
    FROM join_tbl4
-- ORDER BY count
    WHERE com_race IS NOT NULL
      AND off_race IS NOT NULL
-- ORDER BY count(count)
)

DROP TABLE IF EXISTS join_tbl6;
CREATE TEMP TABLE join_tbl6
AS (
    SELECT com_race, off_race, count
    FROM join_tbl5
    WHERE off_race = com_race
)

SELECT (
    (SELECT SUM(count)
    FROM join_tbl6)
    /
    (SELECT SUM(count)
    FROM join_tbl5)
           ) as result