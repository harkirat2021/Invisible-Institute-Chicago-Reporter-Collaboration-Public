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