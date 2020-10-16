-- Question 1: Who are the police officers according to their membership across three distinct cohorts
-- (“the Cohorts”): (1) in a crew, (2) in a community, (3) not in a crew and not in a community?
-- For instance, along the following data points:
--              Individual Police Officer Demographics
--              Counts of accusals, co-accusals, and disciplinary actions
--              Award payouts

-- Step A: Count Cohort populations (1) Crews Only, (2) Communities Only, (3) All others

-- Create a base table of officers in crews and in communities
DROP TABLE IF EXISTS working_cohort_0;
CREATE TEMP TABLE working_cohort_0 AS (
    SELECT doc.officer_id, doc.crew_id, doc.officer_name, dc.detected_crew
    FROM data_officercrew doc
    LEFT JOIN data_crew dc
        on doc.crew_id = dc.community_id
    WHERE doc.crew_id in (
        SELECT dc.community_id
        FROM data_crew
        )
);

SELECT * FROM working_cohort_0;

-- Cohort 1 Crews: ~1,156
SELECT COUNT(DISTINCT officer_id)
FROM working_cohort_0
WHERE detected_crew = 'true';

-- Cohort 2 Community and not Crew: ~10,071
SELECT COUNT(DISTINCT officer_id)
FROM working_cohort_0
WHERE detected_crew = 'false';

-- Find all officers who are not in crews or communities (Cohort 3)
SELECT "do".id, "do".first_name, "do".last_name
FROM data_officer "do"
LEFT JOIN working_cohort_0 oc ON
    "do".id = oc.officer_id
WHERE oc.officer_id is NULL;

-- Cohort 3 count: All Other Officers ~ 23,780
SELECT COUNT(DISTINCT "do".id)
FROM data_officer "do"
LEFT JOIN working_cohort_0 oc ON
    "do".id = oc.officer_id
WHERE oc.officer_id is NULL;

-- Total Officer Population: 35,007
SELECT COUNT(DISTINCT id)
FROM data_officer;

--  TODO:   Update officers_cohorts with cohorts col, where
--      when detected_crew = true, cohorts is 1 (crew),
--      when detected_crew = false, cohorts is 2 (community),
--      when condition is all other officers, cohorts is 3 (community),
--  TODO:  Reshape cols from data_officer into officers_cohorts to match

SELECT * FROM working_cohort_0;
SELECT * FROM data_officer LIMIT 10;

DROP TABLE IF EXISTS working_cohort_3;
CREATE TEMP TABLE working_cohort_3 AS (
    SELECT "do".id as officer_id,
           CONCAT("do".first_name, "do".last_name) AS officer_name
    FROM data_officer "do"
    LEFT JOIN working_cohort_0 oc ON
        "do".id = oc.officer_id
    WHERE oc.officer_id is NULL
    );

DROP TABLE IF EXISTS officers_cohorts;
CREATE TEMP TABLE officers_cohorts AS (
    SELECT officer_id, NULL as crew_id, officer_name, NULL as detected_crew, 3 as cohort
    FROM working_cohort_3
    UNION
    SELECT officer_id, crew_id, officer_name, detected_crew, NULL as cohort
    FROM working_cohort_0
);

UPDATE officers_cohorts
    SET cohort = (CASE WHEN cohort IS NULL THEN (CASE WHEN detected_crew = 'true' THEN 1 ELSE 2 END) ELSE cohort END);

ALTER TABLE officers_cohorts
    ADD community_id int;

UPDATE officers_cohorts
    SET community_id = (CASE WHEN detected_crew = 'false' THEN crew_id ELSE 0 END);

UPDATE officers_cohorts
    SET crew_id = (CASE WHEN detected_crew = 'true' THEN crew_id ELSE 0 END);

ALTER TABLE officers_cohorts
    DROP detected_crew;

-- Return a table of officers by cohort
-- When crew_id is 0, then not in a crew
-- When community_id is 0, then not in a community
-- When cohort = 1, then crew, when cohort = 2, then community, when cohort = 3, then all others

SELECT * FROM officers_cohorts;

-- Verify Counts
SELECT COUNT(DISTINCT officer_id) FROM officers_cohorts WHERE cohort = 3





-- Question 2: Within each Cohort, what is the average number of co-accusals per individual complaint?
-- Where the average is given by the sum of co-accusals in a Cohort divided by the total number of
-- complaints (where a complaint is a unique CRID).



-- Question 3: Within each Cohort, what percentage of allegations results in disciplinary action?
-- Where the percentage is calculated by total allegations in cohort / total times disciplined in cohort.


-- Question 4: For each Cohort, describe the average police officer in terms of demographics, accusals, and payout data.
-- By percentage:
--              Sex
--              Race
--              Age: 21-24; 25-34; 35-44; 45-54; 55-64; 65+
--              Years on the Force: 0-9; 10-14; 15-19; 20-24; 25-29; 30+
-- By Average:
--              Payout data in thousands of dollars
--              Accusations, Disciplinary actions, or percentage from Question 3


