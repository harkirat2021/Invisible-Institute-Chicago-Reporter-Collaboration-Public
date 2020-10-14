-- Checkpoint 1: Relational Analytics - Spectacular Sailors

-- Return a count of communities that are identified as crews
SELECT COUNT (DISTINCT id)
FROM data_officercrew
WHERE crew_id in (
    SELECT community_id
    FROM data_crew
    WHERE detected_crew = 'Yes'
    );

-- Return a table of officers where the community is detected to be a crew
DROP TABLE IF EXISTS officers_crews
CREATE TEMP TABLE officers_crews AS (
    SELECT *
    FROM data_officercrew
    WHERE crew_id in (
        SELECT community_id
        FROM data_crew
        WHERE detected_crew = 'Yes')
);

-- View officers_crews
SELECT * FROM officers_crews

-- Return allegation and officer data for those identified as crew members
DROP TABLE IF EXISTS officers_crews_data
CREATE TEMP TABLE officers_crews_data AS (
    SELECT "do".id,
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
            "oc".crew_id

    FROM data_officer "do"
             LEFT JOIN data_officerallegation "doa"
                       on "do".id = "doa".officer_id
             LEFT JOIN data_allegation "da"
                       on "doa".allegation_id = "da".crid
             RIGHT JOIN officers_crews "oc"
                       on "doa".officer_id = "oc".officer_id
    WHERE "do".id in (
        SELECT officers_crews.id
        FROM officers_crews)
);

-- view officers_crews_data table
SELECT * FROM officers_crews_data;

-- remove leading C in CRID with update and trim
UPDATE officers_crews_data
SET
    crid = TRIM(LEADING 'C' FROM crid)

-- Find duplicate records
-- TODO: Delete duplicate rows in data cleaning stage
SELECT id, crid, COUNT(*)
FROM officers_crews_data
GROUP BY id, crid
HAVING COUNT(*) > 1;

-- Return a count of disciplinary actions for each officer
DROP TABLE IF EXISTS officer_disciplined_true;
CREATE TEMP TABLE officer_disciplined_true AS(
    SELECT id, COUNT(*) AS num_disciplinary_actions
    FROM officers_crews_data
    WHERE disciplined = 'True'
    GROUP BY id
);

-- View counts where officers were disciplined for an allegation
SELECT * FROM officer_disciplined_true

-- Return a count of complaints for each officer
DROP TABLE IF EXISTS officer_complaints_count;
CREATE TEMP TABLE officer_complaints_count AS(
    SELECT id, COUNT(*) AS num_officer_complaints
    FROM officers_crews_data
    GROUP BY id);

-- View counts of officer complaints
SELECT * FROM officer_complaints_count;

-- Return a combined count of complaints and disciplinary for each officer
DROP TABLE IF EXISTS complaints_discipline;
CREATE TEMP TABLE complaints_discipline AS(
SELECT "oct".id, "oct".num_officer_complaints,
       COALESCE("odt".num_disciplinary_actions, 0) AS num_disciplinary_actions,
       COALESCE(CAST("oct".num_officer_complaints AS FLOAT) / CAST("odt".num_disciplinary_actions AS FLOAT), 0) AS discipline_ratio
FROM officer_complaints_count "oct"
LEFT JOIN officer_disciplined_true odt
    on "oct".id = odt.id);

-- Return negative value counts for officers with zero disciplinary actions
UPDATE complaints_discipline
SET discipline_ratio = -1 * num_officer_complaints
WHERE num_disciplinary_actions = 0;

-- View discipline_ratio
SELECT * FROM complaints_discipline