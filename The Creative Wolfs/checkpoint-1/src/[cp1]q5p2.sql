--Top 4000 officers with most complaints
DROP  TABLE IF EXISTS top_officer_complaints;
CREATE TEMP TABLE top_officer_complaints
AS (SELECT DISTINCT id, first_name, last_name, allegation_count
FROM data_officer
group by id
ORDER BY allegation_count DESC
LIMIT 4000);

--Gives number of coaccusals among repeaters for each complaint
DROP TABLE IF EXISTS repeater_complaints;
CREATE TEMP TABLE repeater_complaints
AS(select o.id, a.allegation_id from top_officer_complaints o
    LEFT JOIN data_officerallegation a on o.id=a.officer_id); --here we have all complaints from repeaters
select allegation_id, count(id)
from repeater_complaints
group by allegation_id
having count(id) > 1
order by count(id) DESC;