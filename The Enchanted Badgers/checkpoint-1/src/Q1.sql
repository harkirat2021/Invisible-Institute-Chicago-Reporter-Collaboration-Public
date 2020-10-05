/* What percentage of complaints are sustained for each category? */

WITH ct as (SELECT allegation_category_id,
            count(id) as num_complaints,
            count(case when final_finding = 'SU' then 1 end) as num_sustained_complaints
            FROM data_officerallegation
            GROUP BY allegation_category_id
            ORDER BY num_complaints DESC)
SELECT ct.allegation_category_id,
        ac.allegation_name,
       ct.num_complaints,
       ct.num_sustained_complaints,
       ct.num_sustained_complaints * 100.0 / ct.num_complaints as percent_sustained
FROM ct LEFT JOIN data_allegationcategory as ac
ON ct.allegation_category_id = ac.id
ORDER BY percent_sustained DESC;

/* What percentage of complaints are sustained for all categories? */

WITH ct as (SELECT count(id) as num_complaints,
            count(case when final_finding = 'SU' then 1 end) as num_sustained_complaints
            FROM data_officerallegation
            ORDER BY num_complaints DESC)
SELECT ct.num_complaints,
       ct.num_sustained_complaints,
       ct.num_sustained_complaints * 100.0 / ct.num_complaints as percent_sustained
FROM ct
ORDER BY percent_sustained DESC;
