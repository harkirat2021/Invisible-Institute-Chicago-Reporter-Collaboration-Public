/* First run to retrieve officer crews were were disciplined together and their team size */

SELECT distinct a.id, c.crid, count(c.crid) over (partition by crid) as team_count, c.beat_id, d.name as location_area, c.incident_date, a.allegation_count,c.coaccused_count
FROM data_officer a
LEFT JOIN data_officerallegation b
ON a.id = b.officer_id
LEFT JOIN data_allegation c
ON b.allegation_id = c.crid
LEFT JOIN data_area d
ON d.id = c.beat_id
WHERE b.disciplined ='true'
group by a.id, c.crid, d.name, a.allegation_count
order by crid asc

DROP TABLE IF EXISTS officers_grouped_allegations
CREATE TEMP TABLE officers_grouped_allegations
AS (

SELECT distinct a.id, c.crid, count(c.crid) over (partition by crid) as team_count, c.beat_id, d.name as location_area, c.incident_date, a.allegation_count,c.coaccused_count
FROM data_officer a
LEFT JOIN data_officerallegation b
ON a.id = b.officer_id
LEFT JOIN data_allegation c
ON b.allegation_id = c.crid
LEFT JOIN data_area d
ON d.id = c.beat_id
WHERE b.disciplined = 'true'
group by a.id, c.crid, d.name, a.allegation_count
order by crid asc);



/* Second ~ run to retrieve officer crews/team size were were not-disciplined, but were identified in the same complaints  */

SELECT distinct a.id, c.crid, count(c.crid) over (partition by crid) as team_count, c.beat_id, d.name as location_area, c.incident_date, a.allegation_count,c.coaccused_count
FROM data_officer a
LEFT JOIN data_officerallegation b
ON a.id = b.officer_id
LEFT JOIN data_allegation c
ON b.allegation_id = c.crid
LEFT JOIN data_area d
ON d.id = c.beat_id
WHERE b.disciplined <> 'true'
group by a.id, c.crid, d.name, a.allegation_count
order by crid asc

DROP TABLE IF EXISTS officers_grouped_allegations
CREATE TEMP TABLE officers_grouped_allegations
AS (

SELECT distinct a.id, c.crid, count(c.crid) over (partition by crid) as team_count, c.beat_id, d.name as location_area, c.incident_date, a.allegation_count,c.coaccused_count
FROM data_officer a
LEFT JOIN data_officerallegation b
ON a.id = b.officer_id
LEFT JOIN data_allegation c
ON b.allegation_id = c.crid
LEFT JOIN data_area d
ON d.id = c.beat_id
WHERE b.disciplined <> 'true'
group by a.id, c.crid, d.name, a.allegation_count
order by crid asc);
