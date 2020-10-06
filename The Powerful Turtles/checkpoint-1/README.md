# **Checkpoint 1**

*Team member: Jiangnan Fu, Yunan Wu, Ziyin Huang*

**Theme**

To see if the officers are representative of the people they serve in each community and if the complaint makeup changes based on officer-demographic-community pairings

**Relational Analytics Questions:**

1. What is the race distribution among the officers? 

2. What is the majority race in the community of which the officer with most complaints? 

3. What is the race distribution among the complainant? 

4. What percentage of officers have the same race with the majority race of their responsible community? 

5. What percentage of officers have the same race with the filer of their complaints? 

6. What percentage of filers of complaints have the same race with the majority race of their community? 


**1. What is the race distribution among the officers?**

Please use folder src/Q1.sql or paste the codes below


```
-- Q1
DROP TABLE IF EXISTS race_distribution;
CREATE TEMP TABLE race_distribution
AS (
SELECT race,count(race) as count
From data_officer
GROUP BY race
ORDER BY count(race)
)
```


**3. What is the race distribution among the complainant?**

Please use folder src/Q3.sql or paste the codes below



```
-- Q2
SELECT race,count(race) as count, count(race) /(SELECT COUNT(race)*1.0 FROM data_officer) as race_dist
From data_officer
GROUP BY race, race
ORDER BY count(race)

SELECT race,count(race) as count, count(race)/(SELECT COUNT(race)*1.0 FROM data_complainant) as race_dist_comp
From data_complainant
GROUP BY race, race
ORDER BY count(race)
```


**5.What percentage of officers have the same race with the filer of their complaints?**

Please use folder src/Q5.sql or paste the codes below



```
-- Q5
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
```



