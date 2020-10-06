-- what proportion of officers get promotions each year
with create_promotions_table as (
    with officer_min_years as (
        select distinct officer_id as oid, min(year) as first_year
        from data_salary
        group by oid
    )
    select officer_id, salary, pay_grade, rank_changed, rank, year
    from data_salary
    join officer_min_years
    on officer_min_years.oid = officer_id
    where year > officer_min_years.first_year
), counts as (
    select count(*)                                                   as officer_count,
           count(case when rank_changed = true then 1 else null end)  as promotions,
           count(case when rank_changed = false then 1 else null end) as not_promotions,
--         count(case when rank_changed = true then 1 else null end)/count(*) * 100 as proportion_of_promotions,
--         count(case when rank_changed = false then 1 else null end)/count(*) * 100 as proportion_of_not_promotions,
           year
    from create_promotions_table
    group by year
) select counts.promotions,
         counts.not_promotions,
         counts.officer_count,
         cast(counts.promotions as float) / cast(counts.officer_count as float) * 100.0 as proportion_promoted,
         cast(counts.not_promotions as float) / cast(counts.officer_count as float) * 100.0 as proportion_not_promoted,
         year from counts
