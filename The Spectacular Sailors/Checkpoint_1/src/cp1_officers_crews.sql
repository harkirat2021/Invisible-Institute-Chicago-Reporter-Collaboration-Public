-- Checkpoint 1: Relational Analytics - Spectacular Sailors

-- Question 1: Identify and count the officers that are in and not in crews
-- Return a count of officers that are identified as crews
SELECT COUNT (DISTINCT id)
FROM data_officercrew
WHERE crew_id in (
    SELECT community_id
    FROM data_crew
    WHERE detected_crew = 'Yes'
    );

-- Return a count of officers that are NOT identified as crews
SELECT COUNT (DISTINCT id)
FROM data_officercrew
WHERE crew_id in (
    SELECT community_id
    FROM data_crew
    WHERE detected_crew = 'No'
    );

-- Working table to set up analysis for officers, accusations, and crews
-- Return a table of officers with crew_id and whether they are a detected crew
DROP TABLE IF EXISTS officers_crews;
CREATE TEMP TABLE officers_crews AS (
    SELECT "doc".officer_id, "doc".crew_id, "doc".officer_name, "dc".detected_crew
    FROM data_officercrew "doc"
    LEFT JOIN data_crew "dc"
        on "doc".crew_id = "dc".community_id
    WHERE "doc".crew_id in (
        SELECT dc.community_id
        FROM data_crew
        )
);

-- View officers_crews
SELECT * FROM officers_crews;

-- Return allegation and officer data for those identified as crew members
DROP TABLE IF EXISTS officers_crews_data
CREATE TEMP TABLE officers_crews_data AS (
    SELECT "oc".officer_id,
           "oc".crew_id,
           "oc".detected_crew,
           "do".gender,
           "do".race,
           "do".appointed_date,
           "do".active,
           "do".complaint_percentile,
           "do".civilian_allegation_percentile,
           "do".last_unit_id,
           "da".crid,
           "da".incident_date,
           "da".point,
           "da".beat_id,
           "da".location,
           "doa".allegation_category_id,
           "doa".disciplined,
           sum ("da".coaccused_count) as Coaccused_Count

    FROM data_officer "do"
             LEFT JOIN data_officerallegation "doa"
                       on "do".id = "doa".officer_id
             LEFT JOIN data_allegation "da"
                       on "doa".allegation_id = "da".crid
             RIGHT JOIN officers_crews "oc"
                       on "doa".officer_id = "oc".officer_id
    WHERE "do".id in (
        SELECT officers_crews.officer_id
        FROM officers_crews)
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
);

-- view officers_crews_data table
SELECT * FROM officers_crews_data WHERE crew_id = '108';

DROP TABLE IF EXISTS officers_summary
CREATE TEMP TABLE officers_summary AS (
SELECT officer_id, detected_crew, crid
     , sum(case when disciplined = 'false' then 0
                else  1 end) as displine_count
     , sum(case when disciplined = 'false' or disciplined is null then 1
                else 0 end) as none_displine_count
     , sum(case when disciplined = 'false' then 0 when disciplined = 'true' then 1 end)
     + sum(case when disciplined = 'false' or disciplined is null then 1 else 0 end) as Total_Allegations_Discipline
     , sum(case when disciplined = 'false' or disciplined is null then Coaccused_Count end) as Total_CoAccusals_Non_Discipline
     , sum(case when disciplined = 'true' then Coaccused_Count end) as Total_CoAccusals_disciplined
     , sum(Coaccused_Count) as Total_CoAccusals
FROM officers_crews_data
WHERE officer_id in ('18719')
group by 1,2,3);

select * from officers_crews_data

select*
, none_displine_count/Total_Allegations_Discipline as rt_disciplined
, Total_CoAccusals_Non_Discipline/Total_CoAccusals
from officers_summary



-- remove leading C in CRID with update and trim
UPDATE officers_crews_data
SET
    crid = TRIM(LEADING 'C' FROM crid);

-- Find duplicate records
-- TODO: Delete duplicate rows in data cleaning stage
SELECT officer_id, crid, COUNT(*)
FROM officers_crews_data
GROUP BY officer_id, crid
HAVING COUNT(*) > 1;

-- Return a count of disciplinary actions for each officer
DROP TABLE IF EXISTS officer_disciplined_count;
CREATE TEMP TABLE officer_disciplined_count AS(
    SELECT officer_id, crew_id, detected_crew, coaccused_count, COUNT(*) AS num_disciplinary_actions
    FROM officers_crews_data
    WHERE disciplined = 'true'
    GROUP BY officer_id, crew_id, detected_crew, coaccused_count
);

-- View counts where officers were disciplined for an allegation
SELECT * FROM officer_disciplined_count;

-- Return a count of complaints for each officer
DROP TABLE IF EXISTS officer_complaints_count;
CREATE TEMP TABLE officer_complaints_count AS(
    SELECT officer_id, crew_id, detected_crew,coaccused_count, COUNT(*) AS num_officer_complaints
    FROM officers_crews_data
    GROUP BY officer_id, crew_id, detected_crew, coaccused_count);

-- View counts of officer complaints
SELECT * FROM officer_complaints_count WHERE crew_id = 108;

-- Return a combined count of complaints and disciplinary for each officer
DROP TABLE IF EXISTS complaints_discipline;
CREATE TEMP TABLE complaints_discipline AS(
SELECT occ.officer_id,
       occ.crew_id,
       occ.detected_crew,
       occ.num_officer_complaints,
       COALESCE(odc.num_disciplinary_actions, 0) AS num_disciplinary_actions,
       COALESCE(CAST(occ.num_officer_complaints AS FLOAT) / CAST(odc.num_disciplinary_actions AS FLOAT), 0) AS discipline_ratio
FROM officer_complaints_count occ
LEFT JOIN officer_disciplined_count odc
    on odc.officer_id = occ.officer_id);
LEFT JOIN officer_discipline_coutn

SELECT * FROM complaints_discipline

-- Return negative value counts for officers with zero disciplinary actions
UPDATE complaints_discipline
SET discipline_ratio = -1 * num_officer_complaints
WHERE num_disciplinary_actions = 0;

-- Question 2 and 3: How often accused v disciplined and what is the ratio of action?
-- Example: Officer was disciplined once every 16.75 accusations or,
-- where negative, never disciplined in 98 recorded accusations
SELECT * FROM complaints_discipline
ORDER BY discipline_ratio ASC;

-- Question 4: Provide descriptive statistics about officer discipline ratios
SELECT AVG(CAST(discipline_ratio AS FLOAT)) AS average_ratio,
       MIN(discipline_ratio) AS min_ratio,
       MAX(discipline_ratio) AS max_ratio,
       stddev(CAST(discipline_ratio AS FLOAT)) AS stddev_ratio
FROM complaints_discipline
WHERE detected_crew = 'Yes';

SELECT AVG(CAST(discipline_ratio AS FLOAT)) AS average_ratio,
       MIN(discipline_ratio) AS min_ratio,
       MAX(discipline_ratio) AS max_ratio,
       stddev(CAST(discipline_ratio AS FLOAT)) AS stddev_ratio
FROM complaints_discipline
WHERE detected_crew = 'No';
