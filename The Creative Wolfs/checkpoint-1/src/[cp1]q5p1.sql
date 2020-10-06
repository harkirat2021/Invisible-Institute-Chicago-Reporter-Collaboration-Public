--Top 4000 officers with most complaints
DROP TABLE IF EXISTS top_complaint_officers;
CREATE TEMP TABLE top_complaint_officers
AS (SELECT DISTINCT id, first_name, last_name, allegation_count
FROM data_officer
group by id
ORDER BY allegation_count DESC
LIMIT 4000);

-- gives all complaints against repeaters for each beat
DROP TABLE IF EXISTS repeater_complaints;
CREATE TEMP TABLE repeater_complaints
AS(select o.id, a.allegation_id from top_officer_complaints o
    LEFT JOIN data_officerallegation a on o.id=a.officer_id);
SELECT c.beat_id, count(r.allegation_id) from repeater_complaints r
    LEFT JOIN data_allegation c on c.crid = r.allegation_id
    WHERE c.beat_id > 0
    GROUP BY beat_id
    order by count(allegation_id);