# Checkpoint 1
The following lists the questions we want to answer and the SQL queries with which we attempt to do so.

## Questions
* Which officers have the worst record of offenses, as measured by number?
* On a per officer basis, how does the number of complaints change from year to year?
* How do allegations broken down by area change over time?
* Are allegations and number of transfers correlated?

---
## Executing queries ##
From the src directory, execute the following command or copypaste into an IDE to execute the command from question1.sql:

```bash
psql -f question1.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432
```
---

### Per officer, how does the number of complaints vary over time? ###
```
select officer_id, extract(year from start_date) as year, count(*)
from data_officerallegation
group by officer_id, year
having officer_id in (
    select officer_id 
    from data_officerallegation
    group by officer_id having count(*) > 1
    )
order by officer_id, year;
```

### Complaints broken down by region/year ###
```
select sub.num_alleg, sub.year, data_area.*
from data_area
join (
    select ar.id, extract(year from al.incident_date) as year, count(*) as num_alleg
    from data_allegation al
    join data_area ar
    on st_contains(ar.polygon, al.point)
    group by ar.id, year
    ) sub
on data_area.id = sub.id
order by id, year desc;
```

### Are allegation count and number of transfers correlated? ###
```
select o.id, o.allegation_count, oh1.num_trans, o.*
from data_officer o
join (
    select officer_id, count(*) as num_trans
    from data_officerhistory
    group by  officer_id
    ) oh1
on oh1.officer_id = o.id
order by num_trans desc;
```