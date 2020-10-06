## Checkpoint 1
The following list the questions answered in this checkpoint and how to run the
code to return responses to those questions. For each question, if prompted for
a password, enter the one provided on the checkpoint 1 assignment page.

### Are allegations more likely to be sustained if they come from officers than from citizens, and if so, by how much? ###
Using psql from the src folder, execute the following command:
```bash
psql -f Q1.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432
```
This should return something similar to the following:
```
 Percentage Officer Allegations Sustained | Percentage Citizen Allegations Sustained
------------------------------------------+------------------------------------------
                   0.42891566265060240964 |                   0.06698885927663933555
(1 row)
```

### How many police officers have more/less than X number of average allegations per year? For each officer, what is the primary precinct in which allegations were made? ###
Using psql, execute the following command:
```bash
psql -f Q2.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432 -v compare_type="[ 'gt' | 'lt' ]" -v threshold="[integer]"
```
Here, values enclosed in [] are variables. For compare\_type, enter 'gt'
(greater than) or 'lt' (less than). For threshold, enter an integer value.
For example entering
```bash
psql.exe -f Q2.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432 -v compare_type="'gt'" -v threshold="6"
```
should return something similar to the following:
```
 count
-------
    23
(1 row)


 first_name | middle_initial |  last_name  | average_allegations_per_year | primary_allegation_precinct |            rank             | appointed_date | resignation_date
------------+----------------+-------------+------------------------------+-----------------------------+-----------------------------+----------------+------------------
 Patrick    | M              | Thelen      |           6.2500000000000000 | 11th                        | Police Officer as Detective | 1996-12-02     |
 Edward     | J              | May         |           6.1818181818181818 | 11th                        | Police Officer              | 1976-04-26     | 2012-04-15
 Edward     | L              | Jackson     |           6.1250000000000000 | 15th                        | Police Officer              | 1991-12-16     | 1997-01-06
 Charles    | J              | Toussas     |           8.2000000000000000 | 18th                        | Police Officer              | 1981-01-19     | 2005-02-15
 Steven     | J              | Gawlik      |           8.2000000000000000 | 25th                        | Police Officer              | 1995-07-10     | 2001-10-08
 James      | P              | Comito      |           7.0000000000000000 | 25th                        | Police Officer              | 1994-09-06     | 1998-03-12
 James      | N              | Doby        |           8.2857142857142857 | 2nd                         | Police Officer              | 1986-09-08     | 1997-11-27
 Joe        | D              | Parker      |           6.8500000000000000 | 2nd                         | Police Officer              | 1985-11-18     | 2009-06-30
 Benjamin   | H              | White       |           6.3333333333333333 | 2nd                         | Police Officer              | 1988-11-07     | 1993-12-01
 Barbara    | A              | Pillows     |           6.2500000000000000 | 2nd                         | Police Officer              | 1986-07-14     | 2000-08-15
 Maurice    | A              | Clayton     |           6.0555555555555556 | 3rd                         | Police Officer              | 1973-10-22     | 2006-01-15
 Robert     | R              | Valleyfield |           6.3000000000000000 | 4th                         | Police Officer              | 1991-12-16     | 2003-06-05
 Gregory    | M              | Jackson     |           7.5384615384615385 | 5th                         | Sergeant of Police          | 1991-02-27     |
 Stacy      | E              | Williams    |           7.0000000000000000 | 5th                         | Police Officer              | 1986-08-11     | 1990-06-21
 Michael    | J              | Connolly    |           6.5000000000000000 | 5th                         | Police Officer              | 1997-09-02     |
 Earnest    |                | Marsalis    |           7.0000000000000000 | 6th                         | Police Officer              | 1995-01-03     | 1998-04-13
 Broderick  | C              | Jones       |          10.7000000000000000 | 7th                         | Police Officer              | 1997-05-05     | 2005-05-19
 Corey      | A              | Flagg       |           8.6363636363636364 | 7th                         | Police Officer              | 1996-11-04     | 2005-01-26
 Michael    | J              | O Donnell   |           6.3750000000000000 | 7th                         | Police Officer              | 1996-12-02     |
 Keith      | A              | Herrera     |          10.0000000000000000 | 8th                         | Police Officer              | 2000-06-19     | 2011-04-12
 Jerome     | A              | Finnigan    |           7.9545454545454545 | 8th                         | Police Officer              | 1988-12-05     | 2008-08-05
 Raymond    | R              | Piwnicki    |           6.8000000000000000 | 8th                         | Detective                   | 1998-06-08     |
 John       | R              | Hurley      |           6.1250000000000000 | 8th                         | Police Officer              | 2000-02-28     | 2005-09-11
 (23 rows)
```
The first table returns the answer to the first part of the question (how many?)
and the `primary_allegation_precinct` column of the second table answers the
second part of the question (what is the primary precinct?).

### What’s the probability of a police officer having more than X number of allegations in a year if there exists a frequently misbehaving police officer working in the same unit in that year? ###
execute
```
psql -f Q3.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432
```
returns
```
 year | count 
------+-------
 2000 |  1168
(1 row)
```
change number marked after `/*allegation threshold*/` to see results for each X

### Identify the common properties, including investigator name, district name, victim info (number, age and race) of sustained complaints and unfounded complaints. ###
Suggested method is execute the script block by block in [DataGrip](https://www.jetbrains.com/datagrip/) without using `drop` lines