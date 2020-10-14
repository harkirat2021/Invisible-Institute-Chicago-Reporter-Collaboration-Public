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

-- view initial table
SELECT * FROM officers_crews_data;

-- remove leading C in CRID with update and trim
UPDATE officers_crews_data
SET
    crid = TRIM(LEADING 'C' FROM crid)

-- Find duplicate records
-- FIXME: Delete the duplicate row in Python
SELECT id, crid, COUNT(*)
FROM officers_crews_data
GROUP BY id, crid
HAVING COUNT(*) > 1;

-- Find disciplined officers records
CREATE  TEMP TABLE officer_displined_true AS(
    SELECT id, COUNT(*)
    FROM officers_crews_data
    WHERE disciplined = 'True'
    GROUP BY id
);


SELECT *
FROM officer_complaints_count
LEFT JOIN officer_displined_true odt
    on officer_complaints_count.id = odt.id;

