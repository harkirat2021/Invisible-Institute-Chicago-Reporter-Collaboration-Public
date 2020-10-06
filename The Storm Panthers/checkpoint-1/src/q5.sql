-- Get known outcomes for officers from allegations, grouped
select
    CASE
        WHEN final_outcome ilike '%suspension%' THEN 'Temporary Suspension'
        WHEN final_outcome ilike '%resigned%' or final_outcome ilike '%suspended indefinitely%' THEN 'Resigned or Removed'
        WHEN final_outcome ilike '%reinstated%'
                 or final_outcome ilike '%no penalty%'
                 or final_outcome ilike '%no action%'
                 or final_outcome ilike '%not served%' THEN 'No Penalty'
        ELSE final_outcome
    END officer_outcome, count(*) number_of_occurences,
    round(count(*)::numeric*100 / sum(count(*)) over (),2) as percent_of_total
from data_allegation
inner join data_officerallegation on data_allegation.crid = data_officerallegation.allegation_id
inner join data_allegationcategory on data_officerallegation.allegation_category_id = data_allegationcategory.id
where
    data_allegationcategory.allegation_name = 'Search Of Premise Without Warrant'
    and final_outcome != 'Unknown'
group by officer_outcome, allegation_name
order by number_of_occurences DESC