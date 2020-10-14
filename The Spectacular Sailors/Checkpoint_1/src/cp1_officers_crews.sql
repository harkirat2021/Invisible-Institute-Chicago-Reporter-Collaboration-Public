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
           "doa".disciplined

    FROM data_officer "do"
             LEFT JOIN data_officerallegation "doa"
                       on "do".id = "doa".officer_id
             LEFT JOIN data_allegation "da"
                       on "doa".allegation_id = "da".crid
    WHERE "do".id in (
        SELECT officers_crews.id
        FROM officers_crews)
);

-- drop where col starts with a "C"
SELECT *
FROM officers_crews_data
WHERE crid like 'C%'