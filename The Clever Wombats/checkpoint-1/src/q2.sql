-- Select the number of allegations over time, aggregated by year
select officer_id, extract(year from start_date) as year, count(*)
from data_officerallegation
group by officer_id, year
having officer_id in (
    select officer_id 
    from data_officerallegation
    group by officer_id having count(*) > 1
    )
order by officer_id, year;