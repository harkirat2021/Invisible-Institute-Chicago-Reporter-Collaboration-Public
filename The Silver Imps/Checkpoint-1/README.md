Data Science Seminar - The Silver Imps

Song Luo, Jing Jiang, Yuxin Chen

# Checkpoint 1: Relational Analysis
## Questions

Question 1: Using our definition of “repeaters” above, what percentage of total complaints are they responsible for?

Question 2: What is the demographic information (race, age and sex) of the “repeaters” using our definition above?

Question 3: What is the distribution of the categories of the misconducts (illegal search, use of force, etc.) for those “repeaters” we defined above?

Question 4: Among the allegations against the “repeaters”, what percentage of these cases lead to the “repeaters” being disciplined in 2006-2010, 2010-2014, 2014-2018 respectively?

## How to run the code
We use PostgreSQL and DataGrip as our setup to run and test the code.

You can run our code using the following steps:
1. In terminal, setup PostgreSQL database and load the CPDP data.
2. Use DataGrip to connect to localhost:5432 and used PostgreSQL driver.
3. Make sure the schema is set to cpdp.
4. Paste the code into the console and run the queries. (Make sure you select the whole block between the commented line indicating different timespans.)
5. The result will show in tabs in Datagrip.


## Code Results Format
For all the questions, the code can be broken down to four parts:

The first part contains a single-line query: when you run it gives you the latest date for incident (2018-07-14). Thus we have the three timespans defined more specifically: 2006/07/15-2010/07/15, 2010/7/15-2014/07/15, 2014/07/15-2018/07/15 to make sure the statistics are more fair for the last interval

The next three parts contain information for the three timespans respectively and can be run in similar fashion. The part is seperated by a commented line: '--timespanx: 20xx/07/15 - 20xx/07-15'. Make sure you select the whole block between the commented line. For the output of each time span, the results look like the following:

### for Q1: the outcome should look like

| total | case_of_repeater | percentage |
| ---- | ---- | ---- |
| xxx | xxx | xx |

Then you can see the number and percentage of repeater cases among all cases.

### for Q2: the outcome should look like


| race | ct|
| ---- | ---- |
| xxx | xxx |

and, 

| gender | ct|
| ---- | ---- |
| xxx | xxx |

and, 

| age_range | ct|
| ---- | ---- |
| xxx | xxx |

Then you can see the demographic information of the repeaters.

### for Q3: the outcome should look like

| category | totalct|
| ---- | ---- |
| xxx | xxx |

Then you can see the composition of misconduct categories with totalct sorted in descending order.

### for Q4: the outcome should look like 

| count | disciplined|
| ---- | ---- |
| xxx | true |
| xxx | false |

Then you can derive the percentage of repeaters that get disciplined in each timespan with the formula: count of true / (count of true + count of false). The numerical value is displayed as commented line at the end of each block.



