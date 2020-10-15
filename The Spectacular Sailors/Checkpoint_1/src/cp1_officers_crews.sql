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

-- Create working tables to set up analysis for officers, accusations, and crews
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
DROP TABLE IF EXISTS officers_crews_data;
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

-- View officers_crews_data table
SELECT * FROM officers_crews_data;

-- Generate summary statistics for Question 2
-- Accused/Co-Accused - Disciplined Rates for Officers in/not in crews
DROP TABLE IF EXISTS officers_summary;
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
GROUP BY 1,2,3);

-- View results of query from officers_summary
SELECT * FROM officers_summary;

-- Return a table of counts that we can produce summary statistics from
SELECT *
, CAST(none_displine_count AS FLOAT)/ CAST(Total_Allegations_Discipline AS FLOAT) as rt_disciplined
, CAST(Total_CoAccusals_Non_Discipline AS FLOAT)/CAST(Total_CoAccusals AS FLOAT) as coaccusals_vstotalaccusals
FROM officers_summary

-- TODO: Complete data for Question 3 and Question 4
