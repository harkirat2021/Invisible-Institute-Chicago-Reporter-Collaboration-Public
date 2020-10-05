/* Which category of complaints are most and least likely to have
   severe consequences for the accused officers (more than a reprimand)? */

WITH ct as (SELECT allegation_category_id,
            count(id) as num_complaints,
            count(case when (final_outcome like '%Suspen%' or final_outcome like '%Resigned%' or
                             final_outcome like '%Termina%' or final_outcome like '%Separat%') then 1 end) as num_severe_consequences
            FROM data_officerallegation
            GROUP BY allegation_category_id
            ORDER BY num_complaints DESC)
SELECT ct.allegation_category_id,
        ac.allegation_name,
       ct.num_complaints,
       ct.num_severe_consequences,
       ct.num_severe_consequences * 100.0 / ct.num_complaints as percent_severe
FROM ct LEFT JOIN data_allegationcategory as ac
ON ct.allegation_category_id = ac.id
ORDER BY percent_severe DESC;