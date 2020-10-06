# **Checkpoint 1**

*Team member: Jiangnan Fu, Yunan Wu, Ziyin Huang*

**Theme**

In this project, we would like to study how the demographics comparison between the complainants and the respective police officers reported correlating to the number of complaints. In this checkpoint, we extracted and analyzed the demographic data of officers, complainants, and their corresponding community. Then, we performed some inter-group demographic analyses to observe some correlation within these data. The data and findings from this checkpoint will be the foundation of the succeeding checkpoints.

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

**2. What is the majority race in the community of which the officer with most complaints?**

Please use folder src/Q2.sql or paste the codes below


```
-- Officers with top allegations
DROP TABLE IF EXISTS top_officers;
CREATE TEMP TABLE top_officers
AS (
    SELECT *
    FROM data_officer
    WHERE complaint_percentile IS NOT NULL
    ORDER BY complaint_percentile DESC
    LIMIT 1000
);

-- The allegations for the officers with top allegations
DROP TABLE IF EXISTS officer_allegations;
CREATE TEMP TABLE officer_allegations
AS(
    SELECT a.id AS officer_id, b.allegation_id
    FROM top_officers as a
    LEFT OUTER JOIN (
        SELECT * FROM data_officerallegation
        ) b ON a.id = b.officer_id
);

-- Area id for allegations from prev step
DROP TABLE IF EXISTS allegations_areas;
CREATE TEMP TABLE allegations_areas
AS(
    SELECT a.officer_id, a.allegation_id, b.area_id
    FROM officer_allegations as a
    LEFT OUTER JOIN (
        SELECT * FROM data_allegation_areas
        ) b ON a.allegation_id = b.allegation_id
);

-- Representative race for each community
DROP TABLE IF EXISTS community_race;
CREATE TEMP TABLE community_race
AS (
    SELECT a.area_id, a.race, CAST(a.count AS float) / CAST(b.total_count AS float) AS percentage, a.count, b.total_count
    FROM data_racepopulation a
             INNER JOIN (
        SELECT area_id, MAX(count) count, SUM(count) total_count
        FROM data_racepopulation
        GROUP BY area_id
    ) b ON a.area_id = b.area_id AND a.count = b.count
);

-- Join allegation areas with community races
DROP TABLE IF EXISTS top_areas_race;
CREATE TEMP TABLE top_areas_race
AS(
    SELECT a.officer_id, a.allegation_id, a.area_id, b.race
    FROM allegations_areas as a
    LEFT OUTER JOIN (
        SELECT * FROM community_race
        ) b ON a.area_id = b.area_id
);

-- Group by race count then choose max to determine officer's primary location
DROP TABLE IF EXISTS top_areas_race_count;
CREATE TEMP TABLE top_areas_race_count
AS (
    SELECT officer_id, race, COUNT(race) AS race_count
    FROM top_areas_race
    GROUP BY officer_id, race
);
DROP TABLE IF EXISTS officer_location_race;
CREATE TEMP TABLE officer_location_race
AS (
    SELECT a.officer_id, a.race, a.race_count
    FROM top_areas_race_count a
             INNER JOIN (
        SELECT officer_id, MAX(race_count) race_count
        FROM top_areas_race_count
        GROUP BY officer_id
    ) b ON a.officer_id = b.officer_id AND a.race_count = b.race_count
);

SELECT race, count(race) FROM officer_location_race GROUP BY race;
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

**4. What percentage of officers have the same race with the majority race of their responsible community?**

Please use folder src/Q4.sql or paste the codes below


```
-- The allegations all officers
DROP TABLE IF EXISTS officer_allegations;
CREATE TEMP TABLE officer_allegations
AS(
    SELECT a.id AS officer_id, b.allegation_id
    FROM data_officer as a
    LEFT OUTER JOIN (
        SELECT * FROM data_officerallegation
        ) b ON a.id = b.officer_id
);

-- Area id for allegations from prev step
DROP TABLE IF EXISTS allegations_areas;
CREATE TEMP TABLE allegations_areas
AS(
    SELECT a.officer_id, a.allegation_id, b.area_id
    FROM officer_allegations as a
    LEFT OUTER JOIN (
        SELECT * FROM data_allegation_areas
        ) b ON a.allegation_id = b.allegation_id
);

-- Representative race for each community
DROP TABLE IF EXISTS community_race;
CREATE TEMP TABLE community_race
AS (
    SELECT a.area_id, a.race, CAST(a.count AS float) / CAST(b.total_count AS float) AS percentage, a.count, b.total_count
    FROM data_racepopulation a
             INNER JOIN (
        SELECT area_id, MAX(count) count, SUM(count) total_count
        FROM data_racepopulation
        GROUP BY area_id
    ) b ON a.area_id = b.area_id AND a.count = b.count
);

-- Join allegation areas with community races
DROP TABLE IF EXISTS top_areas_race;
CREATE TEMP TABLE top_areas_race
AS(
    SELECT a.officer_id, a.allegation_id, a.area_id, b.race
    FROM allegations_areas as a
    LEFT OUTER JOIN (
        SELECT * FROM community_race
        ) b ON a.area_id = b.area_id
);

-- Group by race count then choose max to determine officer's primary location
DROP TABLE IF EXISTS top_areas_race_count;
CREATE TEMP TABLE top_areas_race_count
AS (
    SELECT officer_id, race, COUNT(race) AS race_count
    FROM top_areas_race
    GROUP BY officer_id, race
);
DROP TABLE IF EXISTS officer_location_race;
CREATE TEMP TABLE officer_location_race
AS (
    SELECT a.officer_id, a.race, a.race_count
    FROM top_areas_race_count a
             INNER JOIN (
        SELECT officer_id, MAX(race_count) race_count
        FROM top_areas_race_count
        GROUP BY officer_id
    ) b ON a.officer_id = b.officer_id AND a.race_count = b.race_count
);

-- Get all officer's races
DROP TABLE IF EXISTS officer_races;
CREATE TEMP TABLE officer_races
AS (
    SELECT id, race
    From data_officer
);

-- Get all officers that have the same race with their community
DROP TABLE IF EXISTS officer_represent;
CREATE TEMP TABLE officer_represent
AS(
    SELECT a.id, a.race AS officer_race, b.race AS community_race
    FROM officer_races as a
    INNER JOIN (
        SELECT * FROM officer_location_race
        ) b ON a.id = b.officer_id AND a.race = b.race
);

-- Calculate percentage
SELECT(
    CAST((SELECT count(*) from officer_represent) AS float)
    /
    CAST((SELECT count(*) from officer_races) AS float)
    ) as result;

-- SELECT officer_race, count(officer_race) from officer_represent group by officer_race
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

**6. What percentage of filers of complaints have the same race with the majority race of their community?**

Please use folder src/Q6.sql or paste the codes below

```
-- Representative race for each community
DROP TABLE IF EXISTS community_race;
CREATE TEMP TABLE community_race
AS (
    SELECT a.area_id, a.race, CAST(a.count AS float) / CAST(b.total_count AS float) AS percentage, a.count, b.total_count
    FROM data_racepopulation a
             INNER JOIN (
        SELECT area_id, MAX(count) count, SUM(count) total_count
        FROM data_racepopulation
        GROUP BY area_id
    ) b ON a.area_id = b.area_id AND a.count = b.count
);

-- Step by step so I don't mess up:
-- Get complainant race by allegation id
DROP TABLE IF EXISTS complainant_race;
CREATE TEMP TABLE complainant_race
AS (
    SELECT a.allegation_id,
           data_complainant.race as complainant_race
    FROM data_officerallegation as a
             INNER JOIN data_complainant
                             ON a.allegation_id = data_complainant.allegation_id
);

-- Add area id to the table
DROP TABLE IF EXISTS table_with_area;
CREATE TEMP TABLE table_with_area
AS (
    SELECT a.allegation_id, a.complainant_race, b.area_id
    FROM complainant_race a
    INNER JOIN (
        SELECT *
        FROM data_allegation_areas
    ) b ON a.allegation_id = b.allegation_id
);

-- Add area race to the table
DROP TABLE IF EXISTS table_with_area_race;
CREATE TEMP TABLE table_with_area_race
AS (
    SELECT DISTINCT a.allegation_id, a.complainant_race, a.area_id, b.race AS area_race
    FROM table_with_area a
    INNER JOIN (
        SELECT area_id, race
        FROM community_race
    ) b ON a.area_id = b.area_id
);

-- Make a table where complainant_race equals area_race
DROP TABLE IF EXISTS same_race;
CREATE TEMP TABLE same_race
AS (
    SELECT DISTINCT a.allegation_id, a.complainant_race, a.area_id, b.area_race
    FROM table_with_area_race a
    INNER JOIN (
        SELECT allegation_id, area_id, area_race
        FROM table_with_area_race
    ) b ON a.allegation_id = b.allegation_id AND a.area_id = b.area_id AND a.complainant_race = b.area_race
);

-- Divide to get percentage
SELECT(
    CAST((SELECT count(*) from same_race) AS float)
    /
    CAST((SELECT count(*) from table_with_area_race) AS float)
    ) as result;
```


