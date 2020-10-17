
-- Temporary table for civilian allegations useful for all questions
drop table if exists temp_data_officerallegation_civilian;

create temp table temp_data_officerallegation_civilian as
select data_officerallegation.id, data_officerallegation.officer_id, incident_date from data_officerallegation left join data_allegation on data_officerallegation.allegation_id = data_allegation.crid where not data_allegation.is_officer_complaint;

/* QUESTION 1 */

-- Temporary table for unit and num officers in the unit
drop table if exists temp_unitcount;

create temp table temp_unitcount as
select unit_id, count(unit_id) as unit_count
from data_officerhistory
group by unit_id
order by unit_id;

-- Temporary table for allegation count per unit
drop table if exists temp_unitallegationcount;

create temp table temp_unitallegationcount as
select data_officerhistory.unit_id, count(temp_data_officerallegation_civilian.id) as allegation_count, max(date_part('year',data_officerhistory.end_date)) as max_year, min(date_part('year',data_officerhistory.effective_date)) as min_year, unit_count
from temp_data_officerallegation_civilian left join data_officerhistory
on temp_data_officerallegation_civilian.officer_id = data_officerhistory.officer_id
left join temp_unitcount on temp_unitcount.unit_id = data_officerhistory.unit_id
group by data_officerhistory.unit_id, unit_count;

-- Temporary table of average allegations per year for a unit
drop table if exists temp_unitallegationperyear;

create temp table temp_unitallegationperyear as
select unit_id, allegation_count / ((max_year - min_year) * unit_count) as avg_allegation_per_year
from temp_unitallegationcount
where max_year - min_year > 0;

-- Mean and sd of allegations per unit per year
drop table if exists avg_allegations_per_unit;
drop table if exists sd_allegations_per_unit;
create temp table avg_allegations_per_unit as select avg(avg_allegation_per_year) from temp_unitallegationperyear;
create temp table sd_allegations_per_unit as select |/ variance(avg_allegation_per_year) from temp_unitallegationperyear;

-- Answers to Question 1
select avg(avg_allegation_per_year) from temp_unitallegationperyear;
select |/ variance(avg_allegation_per_year) from temp_unitallegationperyear;

/* QUESTION 3 and 4 */
/* (Question 2 is at the end since 3 and 4 help answer it) */

-- Table for average num of allegations per year of an officer
drop table if exists temp_officerallegationsperyear;

create temp table temp_officerallegationsperyear as select data_officer.id, (cast(count(temp_data_officerallegation_civilian.id) as float) / cast((date_part('year',(resignation_date)) - date_part('year',(appointed_date))) as float)) as allegations_per_year
from temp_data_officerallegation_civilian right join data_officer
on temp_data_officerallegation_civilian.officer_id = data_officer.id
where appointed_date is not null and resignation_date is not null and (date_part('year',(resignation_date)) - date_part('year',(appointed_date))) > 0
group by data_officer.id;


-- Mean and sd of officer allegations per year
drop table if exists avg_officer_allegations_per_year;
drop table if exists sd_officer_allegations_per_year;
create temp table avg_officer_allegations_per_year as select avg(allegations_per_year) from temp_officerallegationsperyear;
create temp table sd_officer_allegations_per_year as select |/ avg((allegations_per_year - (select avg(allegations_per_year) from temp_officerallegationsperyear)) ^ 2) from temp_officerallegationsperyear;

-- Table for allegations for officer in specific unit
drop table if exists temp_unitofficerallegationsperyear;

create temp table temp_unitofficerallegationsperyear as select data_officerhistory.officer_id, data_officerhistory.unit_id, (count(temp_data_officerallegation_civilian.id) / cast((date_part('year',(data_officerhistory.end_date)) - date_part('year',(data_officerhistory.effective_date))) as float)) as allegations_per_unit_year
from data_officerhistory inner join temp_data_officerallegation_civilian on data_officerhistory.officer_id = temp_data_officerallegation_civilian.officer_id and temp_data_officerallegation_civilian.incident_date between data_officerhistory.effective_date and data_officerhistory.end_date
where data_officerhistory.effective_date is not null and data_officerhistory.end_date is not null and (date_part('year',(data_officerhistory.end_date)) - date_part('year',(data_officerhistory.effective_date))) > 0
group by data_officerhistory.officer_id, data_officerhistory.unit_id, data_officerhistory.end_date, data_officerhistory.effective_date
order by data_officerhistory.officer_id;


-- Temp Table to compare officer allegations for the units they were in
drop table if exists temp_unitofficerallegations_zscores;

create temp table temp_unitofficerallegations_zscores as
select temp_unitofficerallegationsperyear.officer_id, temp_unitofficerallegationsperyear.unit_id, (allegations_per_unit_year - (select * from avg_officer_allegations_per_year)) / (select * from sd_officer_allegations_per_year) as officer_allegations_per_year_z_score, (temp_unitallegationperyear.avg_allegation_per_year - (select * from avg_allegations_per_unit)) / (select * from sd_allegations_per_unit) as unit_allegations_per_year_z_score
from (temp_unitofficerallegationsperyear join temp_unitallegationperyear on temp_unitallegationperyear.unit_id = temp_unitofficerallegationsperyear.unit_id) join temp_officerallegationsperyear on temp_officerallegationsperyear.id = temp_unitofficerallegationsperyear.officer_id
group by temp_unitofficerallegationsperyear.officer_id, temp_unitofficerallegationsperyear.unit_id, temp_unitofficerallegationsperyear.allegations_per_unit_year, temp_unitallegationperyear.avg_allegation_per_year;

-- View z-scores results for question 3 and 4
select * from temp_unitofficerallegations_zscores;

/* QUESTION 2 */

-- Temporary table for change in officer allegation count
drop table if exists temp_unitofficerallegations_change;

create temp table temp_unitofficerallegations_change as
select officer_id, unit_id, officer_allegations_per_year_z_score - lag(officer_allegations_per_year_z_score) over (partition by officer_id order by officer_id) as officer_allegations_rate_change
from temp_unitofficerallegations_zscores;

-- Mean and sd of change in officer allegations when they change a unit
select avg(officer_allegations_rate_change) from temp_unitofficerallegations_change;
