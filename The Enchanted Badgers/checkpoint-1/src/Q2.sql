/* Which category of complaints are most and least likely to be sustained? */
with
categories(category, finding) as
(
    select c.category, o.final_finding
    from data_officerallegation o
    left join data_allegationcategory c on o.allegation_category_id = c.id
),
allegations_by_category(category, frequency) as
(
    select category, count(*)
    from categories
    group by category
),
sustained_by_category(category, frequency) as
(
    select category, count(*)
    from categories
    where finding = 'SU'
    group by category
),
percentages_by_categories(category, percentage) as
(
    select a.category, (cast(coalesce(s.frequency, 0) as float)  / cast(a.frequency as float)) * 100
    from allegations_by_category a
    left join sustained_by_category s on a.category = s.category
    where a.category is not null
)

select *
from percentages_by_categories
where percentage = (select min(percentage) from percentages_by_categories) or
      percentage = (select max(percentage) from percentages_by_categories);
