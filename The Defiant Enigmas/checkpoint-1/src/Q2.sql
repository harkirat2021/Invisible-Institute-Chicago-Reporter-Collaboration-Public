drop table if exists aapy;
create temp table aapy as (
	select avg(allegations_per_year) average_allegations_per_year, officer_id from (
		select count(id) allegations_per_year, officer_id, extract(year from start_date) "year"
		from data_officerallegation group by officer_id, "year") apy
	group by officer_id having (case when :compare_type = 'gt' then avg(allegations_per_year) > :threshold when :compare_type = 'lt' then avg(allegations_per_year) < :threshold else avg(allegations_per_year) > 0 end));

select count(*) from aapy;

select officer.first_name, officer.middle_initial, officer.last_name, pap.average_allegations_per_year, pap.primary_allegation_precinct, officer."rank", officer.appointed_date, officer.resignation_date
from data_officer officer
right join (-- the "avg" aggregation below is arbitrary (could also be "min" or "max") since every value is the same within a group
	select aapy.officer_id, avg(aapy.average_allegations_per_year) average_allegations_per_year, mode() within group (order by data_area."name") as primary_allegation_precinct from aapy
	left join data_officerallegation doa on aapy.officer_id = doa.officer_id
	left join data_allegation_areas daa on doa.allegation_id = daa.allegation_id
	left join data_area on daa.area_id = data_area.id where data_area.area_type = 'police-districts' group by aapy.officer_id) pap
on officer.id = pap.officer_id order by pap.primary_allegation_precinct, pap.average_allegations_per_year desc;