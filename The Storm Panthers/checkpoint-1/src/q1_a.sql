/* outputs three values: officers who have a 'Search Of Premise Without Warrant' allegation filed against them who are (1) active on the force (2) active, not active, or unknown and (3) the proportion who is active */
WITH illegal_searchers_active AS
    (SELECT DISTINCT count(officer_id) as count_active FROM data_allegationcategory
    INNER JOIN data_officerallegation d on data_allegationcategory.id = d.allegation_category_id
    INNER JOIN data_allegation on d.allegation_id = data_allegation.crid
    INNER JOIN data_officer o on d.officer_id = o.id
    WHERE allegation_name = 'Search Of Premise Without Warrant' AND active = 'Yes'),
illegal_searchers_all AS
    (SELECT DISTINCT count(officer_id) as count_all FROM data_allegationcategory
    INNER JOIN data_officerallegation d on data_allegationcategory.id = d.allegation_category_id
    INNER JOIN data_allegation on d.allegation_id = data_allegation.crid
    INNER JOIN data_officer o on d.officer_id = o.id
    WHERE allegation_name = 'Search Of Premise Without Warrant'),
count_active_all AS
    (SELECT * FROM illegal_searchers_active, illegal_searchers_all)
SELECT count_active, count_all, round(cast(count_active as decimal)/cast(count_all as decimal)*100, 2) as percent_active FROM count_active_all;


