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
)

select s.category, cast(s.frequency as float)  / cast(a.frequency as float) as percentage
from sustained_by_category s
left join allegations_by_category a on s.category = a.category
order by percentage;
