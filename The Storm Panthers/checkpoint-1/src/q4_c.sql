/* This query gets all the lawsuit summaries for officers involved with allegations with the category Wrong Address and lawsuits.*/
SELECT summary from lawsuit_lawsuit
inner join (
    select distinct lawsuit_id from lawsuit_lawsuit
    inner join lawsuit_lawsuit_officers on lawsuit_lawsuit_officers.lawsuit_id = lawsuit_lawsuit.id
    inner join data_officerallegation on data_officerallegation.officer_id = lawsuit_lawsuit_officers.officer_id
    inner join data_allegationcategory cat on cat.id = data_officerallegation.allegation_category_id
    where cat.allegation_name = 'Wrong Address'
) unique_summaries on unique_summaries.lawsuit_id = lawsuit_lawsuit.id;