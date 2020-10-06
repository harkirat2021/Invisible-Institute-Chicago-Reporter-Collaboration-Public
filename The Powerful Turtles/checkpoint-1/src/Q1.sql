-- Q1: What is the race distribution among

DROP TABLE IF EXISTS race_distribution;
CREATE TEMP TABLE race_distribution
AS (
    SELECT race, count(race) as count
    From data_officer
    GROUP BY race
    ORDER BY count(race)
)