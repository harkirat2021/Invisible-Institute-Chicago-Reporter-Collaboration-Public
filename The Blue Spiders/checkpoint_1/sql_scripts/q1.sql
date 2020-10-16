drop table if exists temp_unitallegationcount;

create temp table temp_unitallegationcount as
select unit_id, count(allegation_id), max(date_part('year',data_officerhistory.end_date)), min(date_part('year',data_officerhistory.effective_date))
from data_officerallegation left join data_officerhistory
on data_officerallegation.officer_id = data_officerhistory.officer_id
group by data_officerhistory.unit_id;
