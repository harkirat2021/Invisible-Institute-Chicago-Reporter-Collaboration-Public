/* Which category of complaints are most and least likely to have
   severe consequences for the accused officers (more than a reprimand)? */

WITH ct as (SELECT ac.category as category_name,
            count(oa.id) as num_complaints,
            count(case when (oa.final_outcome like '%Suspen%' or oa.final_outcome like '%Resigned%' or
                             oa.final_outcome like '%Termina%' or oa.final_outcome like '%Separat%') then 1 end) as num_severe_consequences
            FROM data_officerallegation as oa
            INNER JOIN data_allegationcategory as ac
            ON oa.allegation_category_id = ac.id
            GROUP BY ac.category
            ORDER BY num_complaints DESC)
SELECT ct.category_name,
       ct.num_complaints,
       ct.num_severe_consequences,
       ct.num_severe_consequences * 100.0 / ct.num_complaints as percent_severe
FROM ct
ORDER BY percent_severe DESC;
