/* 1. What is the most common offense/misconduct that leads to discipline? */
SELECT category
FROM data_allegationcategory AS t1
INNER JOIN
(SELECT allegation_category_id AS allegation_category_id_mode
FROM data_officerallegation
WHERE disciplined IS TRUE
GROUP BY allegation_category_id
ORDER BY (COUNT(allegation_category_id)) DESC
LIMIT 1) AS t2
ON t1.id = t2.allegation_category_id_mode;


/* 2. What is the most common offense/misconduct that leads to settlement? */
SELECT misconducts from lawsuit_lawsuit
WHERE total_settlement > 0
GROUP BY misconducts
ORDER BY COUNT(*) DESC
LIMIT 1;


/* 3. What is the average number of unit changes over a total career for disciplined vs. not disciplined cops?
*/

/* Disciplined cops */
SELECT avg(unit_changes)
FROM (select data_officerhistory.officer_id as officer_id, count(data_officerhistory.unit_id) as unit_changes
from data_officerhistory
group by officer_id
ORDER BY COUNT(data_officerhistory.unit_id) DESC) as t2
INNER JOIN
(select * from data_officer where discipline_count > 0) as t1
ON t1.id = officer_id;



/* Cops with no history of discipline */
SELECT avg(unit_changes)
FROM (select data_officerhistory.officer_id as officer_id, count(data_officerhistory.unit_id) as unit_changes
from data_officerhistory
group by officer_id
ORDER BY COUNT(data_officerhistory.unit_id) DESC) as t2
INNER JOIN
(select * from data_officer where discipline_count = 0) as t1
ON t1.id = officer_id;


/* 4. What is the type of discipline that officers receive the most? */
SELECT final_outcome FROM data_officerallegation
WHERE disciplined IS TRUE
GROUP BY final_outcome
ORDER BY COUNT(*) DESC
LIMIT 1;


