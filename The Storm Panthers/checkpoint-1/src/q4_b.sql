/* This query gets all the lawsuits for officers involved with allegations with the category Wrong Address and lawsuits
   whose incident dates match the allegation incident dates. */
SELECT * from lawsuit_lawsuit
inner join (
    select distinct lawsuit_id from lawsuit_lawsuit
    inner join lawsuit_lawsuit_officers on lawsuit_lawsuit_officers.lawsuit_id = lawsuit_lawsuit.id
    inner join data_officerallegation on data_officerallegation.officer_id = lawsuit_lawsuit_officers.officer_id
    inner join data_allegation on data_allegation.crid = data_officerallegation.allegation_id
    inner join data_allegationcategory cat on cat.id = data_officerallegation.allegation_category_id
    where cat.allegation_name = 'Wrong Address'
    AND data_allegation.incident_date = lawsuit_lawsuit.incident_date
) unique_summaries on unique_summaries.lawsuit_id = lawsuit_lawsuit.id;