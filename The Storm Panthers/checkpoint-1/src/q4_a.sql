/* This query gets all the allegations with the name Wrong Address. */
SELECT * from data_allegation
inner join data_allegationcategory cat on cat.id = data_allegation.most_common_category_id
where cat.allegation_name = 'Wrong Address';