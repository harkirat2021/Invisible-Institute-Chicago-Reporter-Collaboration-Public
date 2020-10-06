
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