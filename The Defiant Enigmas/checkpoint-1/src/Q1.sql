drop table if exists complaint_type_count_matrix;
create temp table complaint_type_count_matrix as (
	select is_officer_complaint, case when final_finding = 'SU' then true else false end as sustained, count(*)
	from data_allegation da
	join data_officerallegation doa on da.crid = doa.allegation_id
	group by is_officer_complaint, sustained);

select (
	select "count"
	from complaint_type_count_matrix
	where is_officer_complaint = true and sustained = true
	)::decimal / (
	select sum("count")
	from complaint_type_count_matrix
	where is_officer_complaint = true)
	"Percentage Officer Allegations Sustained",
	(
	select "count" from complaint_type_count_matrix
	where is_officer_complaint = false and sustained = true
	)::decimal / (
	select sum("count") from complaint_type_count_matrix
	where is_officer_complaint = false)
	"Percentage Citizen Allegations Sustained";