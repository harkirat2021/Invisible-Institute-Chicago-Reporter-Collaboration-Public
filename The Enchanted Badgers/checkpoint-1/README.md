# Checkpoint 1: SQL Analytics

## How to Run the Queries

### Method 1: Use PSQL

From within the `/src` directory you can use PSQL in order to interface with the remote AWS database using the following command.

`psql -f <QUESTION_FILENAME>.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

and replacing <QUESTION_FILENAME> with the approriate query file name. For example, running the query for Question 1 would be as follows:

`psql -f Q1.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

When prompted for a password, simply enter the password found within the setup instructions for Checkpoint 1 on Canvas (this is omitted here for security reasons).

### Method 2: DataGrip

In order to run these queries with DataGrip, you'll first need to make sure you have an active connection to the `cpdb` database. With that in place, simply open the `.sql` files in the `/src` directory and hit run. Alternatively, you can copy and paste the queries from the file into the DataGrip console and run them there.



## Questions and Expected Output

### Question 1: What percentage of complaints are sustained for each category? For all categories?

Using the PSQL method for running the queries, execute the following command:

`psql -f Q1.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

This will return two tables. The first answers the first part of the question (what percent of complaints are sustained for each category?).

```
         category_name          | num_complaints | num_sustained_complaints |   percent_sustained    
--------------------------------+----------------+--------------------------+------------------------
 Drug / Alcohol Abuse           |           1358 |                      797 |    58.6892488954344624
 Medical                        |             30 |                       12 |    40.0000000000000000
 Excessive Force                |             31 |                       10 |    32.2580645161290323
 Unknown                        |             64 |                       20 |    31.2500000000000000
 Conduct Unbecoming (Off-Duty)  |           8381 |                     2297 |    27.4072306407349958
 Bribery / Official Corruption  |            885 |                      162 |    18.3050847457627119
 Criminal Misconduct            |           6665 |                     1023 |    15.3488372093023256
 Operation/Personnel Violations |          78356 |                    11525 |    14.7085098779927510
 Lockup Procedures              |          14396 |                     1769 |    12.2881355932203390
 Supervisory Responsibilities   |           4826 |                      467 |     9.6767509324492333
 Traffic                        |           8193 |                      743 |     9.0687171976077139
 Domestic                       |           6506 |                      451 |     6.9320627113433753
 Use Of Force                   |          57574 |                     2139 |     3.7152186750963977
 Verbal Abuse                   |          13795 |                      330 |     2.3921710764769844
 Racial Profiling               |             56 |                        1 |     1.7857142857142857
 First Amendment                |             77 |                        1 |     1.2987012987012987
 Illegal Search                 |          37611 |                      199 | 0.52910052910052910053
 False Arrest                   |           9160 |                       43 | 0.46943231441048034934
 Money / Property               |            357 |                        0 | 0.00000000000000000000
(19 rows)

```

The second table answers the second part of the question (what percent of complaints are sustained for all categories?)

```
 num_complaints | num_sustained_complaints | percent_sustained  
----------------+--------------------------+--------------------
         248321 |                    21989 | 8.8550706545157276
(1 row)

```

### Question 2: Which category of complaints are most and least likely to be sustained?

Using the PSQL method for running the queries, execute the following command:

`psql -f Q2.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

This should result in a table that looks like the following. 

```
            category            |     percentage     
--------------------------------+--------------------
 False Arrest                   | 0.4694323144104804
 Illegal Search                 | 0.5291005291005291
 First Amendment                | 1.2987012987012987
 Racial Profiling               | 1.7857142857142856
 Verbal Abuse                   |  2.392171076476984
 Use Of Force                   | 3.7152186750963976
 Domestic                       | 6.9320627113433755
 Traffic                        |  9.068717197607713
 Supervisory Responsibilities   |  9.676750932449234
 Lockup Procedures              | 12.288135593220339
 Operation/Personnel Violations | 14.708509877992752
 Criminal Misconduct            | 15.348837209302326
 Bribery / Official Corruption  | 18.305084745762713
 Conduct Unbecoming (Off-Duty)  | 27.407230640734998
 Unknown                        |              31.25
 Excessive Force                |  32.25806451612903
 Medical                        |                 40
 Drug / Alcohol Abuse           |  58.68924889543447
(18 rows)
```

### Question 3: Which category of complaints are most and least likely to have severe consequences for the accused officers (more than a reprimand)?

Using the PSQL method for running the queries, execute the following command:

`psql -f Q3.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

This should result in a table that looks like the following. 

```
         category_name          | num_complaints | num_severe_consequences |     percent_severe     
--------------------------------+----------------+-------------------------+------------------------
 Drug / Alcohol Abuse           |           1358 |                     717 |    52.7982326951399116
 Medical                        |             30 |                      11 |    36.6666666666666667
 Unknown                        |             64 |                      21 |    32.8125000000000000
 Conduct Unbecoming (Off-Duty)  |           8381 |                    1695 |    20.2243169072902995
 Bribery / Official Corruption  |            885 |                     149 |    16.8361581920903955
 Excessive Force                |             31 |                       5 |    16.1290322580645161
 Criminal Misconduct            |           6665 |                     610 |     9.1522880720180045
 Operation/Personnel Violations |          78356 |                    6537 |     8.3426923273265608
 Lockup Procedures              |          14396 |                     957 |     6.6476799110864129
 Domestic                       |           6506 |                     354 |     5.4411312634491239
 Traffic                        |           8193 |                     403 |     4.9188331502502136
 Supervisory Responsibilities   |           4826 |                     200 |     4.1442188147534190
 Use Of Force                   |          57574 |                    1641 |     2.8502449022128044
 Verbal Abuse                   |          13795 |                     200 |     1.4498006524102936
 First Amendment                |             77 |                       1 |     1.2987012987012987
 Illegal Search                 |          37611 |                      98 | 0.26056206960729573795
 False Arrest                   |           9160 |                      15 | 0.16375545851528384279
 Money / Property               |            357 |                       0 | 0.00000000000000000000
 Racial Profiling               |             56 |                       0 | 0.00000000000000000000
(19 rows)
```

The most likely complaint category to have severe consequences is the top entry with the highest `percent_severe`, and the least likely are the last two entries of the table which have had no severe consequences (according to the data).

### Question 4: What categories had no severe consequences?

Using the PSQL method for running the queries, execute the following command:

`psql -f Q4.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

This should result in two tables that looks like the following.

```
       category       | number_of_allegations 
----------------------+-----------------------
 Criminal Misconduct  |                    15
 First Amendment      |                    15
 Drug / Alcohol Abuse |                     1
(3 rows)
```

```
            category            | number_of_allegations 
--------------------------------+-----------------------
 Money / Property               |                   357
 Use Of Force                   |                   184
 Illegal Search                 |                   178
 False Arrest                   |                   160
 Operation/Personnel Violations |                    93
 Racial Profiling               |                    56
 Unknown                        |                    33
 Criminal Misconduct            |                    27
 First Amendment                |                    15
 Drug / Alcohol Abuse           |                    11
 Bribery / Official Corruption  |                    10
 Medical                        |                     7
 Conduct Unbecoming (Off-Duty)  |                     3
(13 rows)
```

### Question 5: What percentage of complaints are categorized as other, or not categorized at all (year over year)?

Using the PSQL method for running the queries, execute the following command:

`psql -f Q5.sql -h cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com -U cpdb-student -d cpdb -p 5432`

This should result in a table that looks like the following. 

```
 year |     percentage      
------+---------------------
 2018 |  1.1029411764705883
 2017 |   1.085883514313919
 2016 |  12.940275650842267
 2015 |   8.124280782508631
 2014 |   4.208654416123296
 2013 |  1.7169811320754718
 2012 |   0.897021887334051
 2011 |  0.8166533226581264
 2010 |  0.5057408419901586
 2009 | 0.35285815102328866
 2008 | 0.24088093599449414
 2007 |   0.297303036738161
 2006 |  0.5994405221792993
 2005 |  0.9466708740927736
 2004 |  0.3922034704064654
 2003 | 0.33438038301752965
 2002 | 0.24187975120939878
 2001 | 0.18585858585858586
 2000 |  0.3485928128364177
 ```
 
 * Years prior to 2000 all have a percentage of zero and are truncated here for brevity.
