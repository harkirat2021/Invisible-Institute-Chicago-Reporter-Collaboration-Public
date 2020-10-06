

with

officer_alleg_area as
    (select officer_id, data_officerallegation.allegation_id as allegation_id, area_id
    from data_officerallegation
    join data_allegation_areas daa on data_officerallegation.allegation_id = daa.allegation_id
),
repeaters as (
    select officer_id, count(*) as number_of_allegations
    from data_officerallegation
    group by officer_id
    order by number_of_allegations desc
    limit 4000
),

repeaters_alleg_areas as (select repeaters.officer_id, allegation_id, area_id, name, description
    from officer_alleg_area
    join data_area on officer_alleg_area.area_id = data_area.id
    right join repeaters on repeaters.officer_id = officer_alleg_area.officer_id
)
select * from data_area
where id =
    (select area_id from repeaters_alleg_areas
    group by area_id
    order by count(*) desc
    limit 1)


