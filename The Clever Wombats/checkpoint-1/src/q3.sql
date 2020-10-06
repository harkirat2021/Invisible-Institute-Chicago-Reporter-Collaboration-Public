-- number of allegations broken down by region
select count, sub.year, data_area.*
from data_area
join (
    select ar.id, extract(year from al.incident_date) as year, count(*)
    from data_allegation al
    join data_area ar
    on st_contains(ar.polygon, al.point)
    group by ar.id, year
    ) sub
on data_area.id = sub.id
order by id, year desc;