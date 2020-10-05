/* What percentage of complaints are sustained for each category? */

WITH ct as (SELECT ac.category as category_name,
            count(oa.id) as num_complaints,
            count(case when oa.final_finding = 'SU' then 1 end) as num_sustained_complaints
            FROM data_officerallegation as oa
            INNER JOIN data_allegationcategory as ac
            ON oa.allegation_category_id = ac.id
            GROUP BY ac.category
            ORDER BY num_complaints DESC)
SELECT ct.category_name,
       ct.num_complaints,
       ct.num_sustained_complaints,
       ct.num_sustained_complaints * 100.0 / ct.num_complaints as percent_sustained
FROM ct
ORDER BY percent_sustained DESC;

/* What percentage of complaints are sustained for all categories? */

WITH ct as (SELECT count(oa.id) as num_complaints,
            count(case when oa.final_finding = 'SU' then 1 end) as num_sustained_complaints
            FROM data_officerallegation as oa
            INNER JOIN data_allegationcategory as ac
            ON oa.allegation_category_id = ac.id
            ORDER BY num_complaints DESC)
SELECT ct.num_complaints,
       ct.num_sustained_complaints,
       ct.num_sustained_complaints * 100.0 / ct.num_complaints as percent_sustained
FROM ct
ORDER BY percent_sustained DESC;





SELECT ac.category as category_name,
            count(oa.id) as num_complaints,
            count(case when oa.final_finding = 'SU' then 1 end) as num_sustained_complaints
            FROM data_officerallegation as oa
            INNER JOIN data_allegationcategory as ac
            ON oa.allegation_category_id = ac.id
            GROUP BY ac.category
            ORDER BY num_complaints DESC;