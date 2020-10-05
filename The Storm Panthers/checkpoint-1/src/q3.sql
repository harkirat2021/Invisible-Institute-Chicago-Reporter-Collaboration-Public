-- Outcomes for victims of "Home Invasion" settlements, grouped
select
    CASE
        WHEN outcome_type ilike '%charges%' THEN 'Charged'
        WHEN outcome_type ilike '%detention%' THEN 'Detained'
        WHEN outcome_type ilike '%hospitalized%' THEN 'Hospitalized'
        WHEN outcome_type ilike '%killed%' or outcome_type ilike '%died%' THEN 'Killed'
        WHEN outcome_type is null THEN 'No Outcome Recorded'
        ELSE outcome_type
    END outcome,
    count(distinct lawsuits.id) number_of_occurences,
    round(count(distinct lawsuits.id)::numeric*100
            / (select count(*) from lawsuit_lawsuit where 'Home invasion' = any(lawsuit_lawsuit.interactions))
        ,2) as percent_of_total
from lawsuit_lawsuit lawsuits, UNNEST(
        CASE WHEN "outcomes" != '{}' THEN "outcomes"
        ELSE '{null}' END) outcome_type
where 'Home invasion' = any(lawsuits.interactions)
group by outcome
order by Number_of_occurences DESC;