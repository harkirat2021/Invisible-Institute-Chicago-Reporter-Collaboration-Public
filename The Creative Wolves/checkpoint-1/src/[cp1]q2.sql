--Q2

--The following block generates the average salary of top 4000 of officers with most allegations
WITH top_repeat_officers AS (
    SELECT count(distinct allegation_id) AS allegation_count,
           officer_id
    FROM data_officerallegation
    GROUP BY officer_id
    order by allegation_count desc
    limit 4000),
     salary_top_repeat_officers AS (
         select top_repeat_officers.officer_id, max(data_salary.salary) as salary
         from top_repeat_officers
                  left join
              data_salary
              on data_salary.officer_id = top_repeat_officers.officer_id
         where data_salary.salary is not null
         group by top_repeat_officers.officer_id)
select avg(salary_top_repeat_officers.salary) as average_salary_top_5_percent
from salary_top_repeat_officers;

--Answer: 94392.63

--The following code calculates the average salary of officers who received at least one allegation
WITH overall_officers AS (
    SELECT count(distinct allegation_id) AS allegation_count,
           officer_id
    FROM data_officerallegation
    GROUP BY officer_id),
     salary_overall_officers AS (
         select overall_officers.officer_id, max(data_salary.salary) as salary
         from overall_officers
                  left join
              data_salary
              on data_salary.officer_id = overall_officers.officer_id
         where data_salary.salary is not null
         group by overall_officers.officer_id)
select avg(salary_overall_officers.salary) as average_salary_top_5_percent
from salary_overall_officers;

--Answer: 89619.11