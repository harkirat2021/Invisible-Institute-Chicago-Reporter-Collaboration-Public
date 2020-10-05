/*
 Restrictive query - Which allegation_name categories have no severe
 or unknown consequences recorded in the data?
 */

select t1.allegation_name, t.final_outcome, t1.category, t1.citizen_dept, count(*) number_of_allegations
    from (
        select distinct t1.allegation_name, t.allegation_category_id, t1.category, t1.citizen_dept
            from public.data_allegationcategory t1
                     inner join
                 (select distinct t.allegation_category_id
                  from public.data_officerallegation t
                      except
                  select distinct t.allegation_category_id
                  from public.data_officerallegation t
                  where (t.final_outcome like '%Unknown%' or t.final_outcome like '%Suspen%' or t.final_outcome like '%Resigned%' or
                         t.final_outcome like '%Termina%' or t.final_outcome like '%Separat%')
                 ) t
                 on t1.id = t.allegation_category_id
                ) t1
    inner join public.data_officerallegation t on t1.allegation_category_id = t.allegation_category_id
    group by allegation_name, final_outcome, t1.category, t1.citizen_dept
    order by number_of_allegations desc;

/*
 Less restrictive query - Which allegation_name categories have no severe
 consequences recorded in the data?
 */

 select t1.allegation_name, t.final_outcome, t1.category, t1.citizen_dept, count(*) number_of_allegations
    from (
        select distinct t1.allegation_name, t.allegation_category_id, t1.category, t1.citizen_dept
            from public.data_allegationcategory t1
                     inner join
                 (select distinct t.allegation_category_id
                  from public.data_officerallegation t
                      except
                  select distinct t.allegation_category_id
                  from public.data_officerallegation t
                  where (t.final_outcome like '%Suspen%' or t.final_outcome like '%Resigned%' or
                         t.final_outcome like '%Termina%' or t.final_outcome like '%Separat%')
                 ) t
                 on t1.id = t.allegation_category_id
                ) t1
    inner join public.data_officerallegation t on t1.allegation_category_id = t.allegation_category_id
    group by allegation_name, final_outcome, t1.category, t1.citizen_dept
    order by number_of_allegations desc;