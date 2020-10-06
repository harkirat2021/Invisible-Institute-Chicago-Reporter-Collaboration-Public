By: Pengyi Shi, Milan McGraw, and Justin Chae

Project Title: Network Graphs of Arresting Officers 

Date: 6 October 2020

THEME

As provided by class, police are known to work in “crews” which are defined as "tight-knit community of officers involved in high levels of egregious misconduct and criminal activity." Four categories help define the four characteristics of a crew to include frequency, exclusivity, severity, and cohesion. A common theme among the four crew characteristics is repeated misconduct. In other words, bad cops do bad things together frequently. 
The theme of this project is to improve how crew membership is defined by analyzing complaint data and performing network analysis. At a high-level, the tasks include (1) Relational Analytics: analyze which officers are co-accused in complaints, (2) Relational Analytics: implement network analysis to confirm clusters and represent network memberships in SQL, (3) Visualization: determine whether geospatial references in complaints and beats can help identify clusters.

Summary of Checkpoint 1

For Checkpoint 1, our team explores the dataset with SQL in three general areas. First, we craft a query that attempts to identify crew membership by combining data allegations and officers that are co-accused. Second, we learn technical aspects of how to create and represent network graphs in SQL tables and queries. Third, and lastly, we explore how to query and join tables with address or geospatial data to identify where crews operate.

1. From crew_membership_teams.sql, we craft complex queries to identify crew membership.   What officers, by officer_id, are disciplined for the same complaint, where “same complaint” is defined as having the same beat, on the same incident date, and same CRID? Within similar criteria, what officers are not disciplined?

2. From network_graphs.sql we explore how to create a network graph, in table format, on the cpdb dataset. When connected to the database, run the queries as prompted in the file's comments, in sequence, to see how we are thinking about tackling the technical challenge. At a high-leve, the premise is to take a list of officers that are known or suspected of being in the same crew, parse that list of officer_ids into a table of nodes, and then derive a table of edges that connect one node to another. If successful, we propose that this type of analysis may help identify how different crews are inter-related. 

3. From geolocationAndBeatIds.sql we add to our first set queries to add a geospatial component. The table from the query is ordered by beat_id and incident_date. In beat_id, we find a policing term which identifies the patrol area, and incident_date is the date when the incident happened. We can see from the table that although we cannot have the direct geographical location of the corresponding beat_id, we do have the street address for the later analysis for a geospatial representation. With the street address, we can even cluster our data of complaints to different zip codes. We may be able to use the incident_date, to quantify and group the number of complaints in each beat area per time period. However, as you may notice, there are some addresses with not NULL and no empty values, so it raises a future question about data cleaning, i.e. whether to drop the data or derive other data to fill.



Key References:
1. Storing graphs in the database: SQL meets social network: https://inviqa.com/blog/storing-graphs-database-sql-meets-social-network

