/* get count of ones that occurred at the above locations */
WITH officer_allegations AS (SELECT * FROM data_allegationcategory
    INNER JOIN data_officerallegation d on data_allegationcategory.id = d.allegation_category_id
    INNER JOIN data_allegation on d.allegation_id = data_allegation.crid
    INNER JOIN data_officer o on d.officer_id = o.id
    WHERE allegation_name = 'Search Of Premise Without Warrant'),
allegations_home_distinct AS (SELECT DISTINCT allegation_id FROM officer_allegations
    WHERE location = 'Residence' OR location = 'Apartment' OR location = 'Private Residence'
    OR location = 'Other Private Premise')
SELECT count(*) as home_invasion_allegation_count FROM allegations_home_distinct;

/* data relevant to these distinct home invasions */
WITH officer_allegations AS (SELECT * FROM data_allegationcategory
    INNER JOIN data_officerallegation d on data_allegationcategory.id = d.allegation_category_id
    INNER JOIN data_allegation on d.allegation_id = data_allegation.crid
    INNER JOIN data_officer o on d.officer_id = o.id
    WHERE allegation_name = 'Search Of Premise Without Warrant'),
allegations_home_distinct AS (SELECT DISTINCT allegation_id FROM officer_allegations
    WHERE location = 'Residence' OR location = 'Apartment' OR location = 'Private Residence'
    OR location = 'Other Private Premise')
SELECT allegations_home_distinct.allegation_id AS allegation_id, add1, add2, city, incident_date, location 
FROM allegations_home_distinct INNER JOIN officer_allegations ON
           allegations_home_distinct.allegation_id = officer_allegations.allegation_id;