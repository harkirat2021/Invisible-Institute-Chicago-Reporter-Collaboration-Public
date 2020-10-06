/* number of officers who have multiple 'Search Of Premise Without Warrant' allegations filed against them */
SELECT count(officer_id) as number_of_repeaters FROM
(SELECT DISTINCT officer_id, count(officer_id) as count FROM data_allegationcategory
INNER JOIN data_officerallegation d on data_allegationcategory.id = d.allegation_category_id
INNER JOIN data_allegation on d.allegation_id = data_allegation.crid
INNER JOIN data_officer o on d.officer_id = o.id
WHERE allegation_name = 'Search Of Premise Without Warrant' AND active = 'Yes'
GROUP BY officer_id) as officer_count
WHERE count > 1;

/* lists the officers who have multiple 'Search Of Premise Without Warrant' allegations filed against them and the number of those allegations */
SELECT officer_id, count FROM
(SELECT DISTINCT officer_id, count(officer_id) as count FROM data_allegationcategory
INNER JOIN data_officerallegation d on data_allegationcategory.id = d.allegation_category_id
INNER JOIN data_allegation on d.allegation_id = data_allegation.crid
INNER JOIN data_officer o on d.officer_id = o.id
WHERE allegation_name = 'Search Of Premise Without Warrant' AND active = 'Yes'
GROUP BY officer_id) as officer_count
WHERE count > 1
ORDER BY count DESC;