By: Pengyi Shi, Milan McGraw, and Justin Chae

Project Title: Network Graphs of Arresting Officers 

Date: 6 October 2020

THEME

As provided by class, police are known to work in “crews” which are defined as "tight-knit community of officers involved in high levels of egregious misconduct and criminal activity." Four categories help define the four characteristics of a crew to include frequency, exclusivity, severity, and cohesion. A common theme among the four crew characteristics is repeated misconduct. In other words, bad cops do bad things together frequently. 
The theme of this project is to improve how crew membership is defined by analyzing complaint data and performing network analysis. At a high-level, the tasks include (1) Relational Analytics: analyze which officers are co-accused in complaints, (2) Relational Analytics: implement network analysis to confirm clusters and represent network memberships in SQL, (3) Visualization: determine whether geospatial references in complaints and beats can help identify clusters.

Summary of Checkpoint 1

For Checkpoint 1, our team explores the dataset with SQL in three general areas. First, we craft a query that attempts to identify crew membership by combining data allegations and officers that are co-accused. Second, we learn technical aspects of how to create and represent network graphs in SQL tables and queries. Third, and lastly, we explore how to query and join tables with address or geospatial data to identify where crews operate.

1. From xxxx.sql, we craft complex queries to identify crew membership. 

2. From network_graphs.sql we explore how to create a network graph, in table format, on the cpdb dataset. When connected to the database, run the queries as prompted in the file's comments, in sequence, to see how we are thinking about tackling the technical challenge. At a high-leve, the premise is to take a list of officers that are known or suspected of being in the same crew, parse that list of officer_ids into a table of nodes, and then derive a table of edges that connect one node to another. If successful, we propose that this type of analysis may help identify how different crews are inter-related. 

3. From xxx.sql we add to our first set queries to add a geospatial component. 


Key References:
1. Storing graphs in the database: SQL meets social network: https://inviqa.com/blog/storing-graphs-database-sql-meets-social-network

