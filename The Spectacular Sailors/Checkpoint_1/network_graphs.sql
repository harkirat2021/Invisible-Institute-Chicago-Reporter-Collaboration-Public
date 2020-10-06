-- For Query 2: Try to represent "crews" as network graphs of officers in SQL tables
-- Start a sample query from Query 1

DROP TABLE IF EXISTS officers_grouped_allegations
CREATE TEMP TABLE officers_grouped_allegations
AS (
SELECT a.id, b.disciplined, b.allegation_category_id, c.crid, c.beat_id, d.name, c.incident_date
FROM data_officer a
LEFT JOIN data_officerallegation b
ON a.id = b.officer_id
LEFT JOIN data_allegation c
ON b.allegation_id = c.crid
LEFT JOIN data_area d
ON d.id = c.beat_id
WHERE disciplined = 'true');

-- View the officers_grouped_allegations table
SELECT * FROM officers_grouped_allegations;

-- Filter officers_grouped_allegations from Query 1 to identify a sample group of officers
-- Backlog: Filter and group by officers having the same CRID
DROP TABLE IF EXISTS officer_samples;
CREATE TEMP TABLE officer_samples
AS (
    SELECT id, crid, allegation_category_id
    FROM officers_grouped_allegations
    WHERE crid = 'C260174');

-- View officer_samples
SELECT * FROM officer_samples

-- temp table structure to capture officer associations as graphs
-- Reference 1: https://inviqa.com/blog/storing-graphs-database-sql-meets-social-network

-- create an empty nodes_temp table
DROP TABLE IF EXISTS nodes_temp CASCADE
CREATE TEMP TABLE nodes_temp (
    id INTEGER PRIMARY KEY,
    crid_id VARCHAR(10) NOT NULL,
    allegation_category_id VARCHAR(10));

-- create an empty edges_temp table
DROP TABLE IF EXISTS edges_temp;
CREATE TEMP TABLE edges_temp
(
    a INTEGER NOT NULL REFERENCES nodes_temp (id) ON UPDATE CASCADE ON DELETE CASCADE,
    b INTEGER NOT NULL REFERENCES nodes_temp (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (a, b)
);

DROP INDEX IF EXISTS a_idx;
DROP INDEX IF EXISTS b_idx;
-- create indexes for edges
CREATE INDEX a_idx ON edges_temp (a);
CREATE INDEX b_idx ON edges_temp (b);

-- view an empty edges_temp table
SELECT * FROM edges_temp;

-- view an empty nodes_temp table
SELECT * FROM nodes_temp;

-- populate graph table
INSERT INTO nodes_temp (id, crid_id, allegation_category_id)
SELECT id, crid, allegation_category_id
FROM officer_samples;

-- view a populated nodes_temp table
SELECT * FROM nodes_temp;

-- Initial attempt to create pairs of officers as edges
-- Reference 2: https://stackoverflow.com/questions/36694641/sql-server-select-pairs-of-values-from-one-column/36696098
INSERT INTO edges_temp (a, b)
WITH cte AS(
SELECT
    id as a,
    LEAD(id, 1, NULL) OVER (ORDER BY id) AS b
FROM officer_samples)
SELECT a, b
FROM cte
WHERE b IS NOT NULL
ORDER BY a;

-- view the populated edges_temp table
SELECT * FROM nodes_temp;

-- Traverse and view graph
-- Reference 1
-- Backlog: address the null pair
SELECT *
FROM nodes_temp n
LEFT JOIN edges_temp e ON n.id = e.b;

-- TODO
-- Create a reliable query to create nodes and edges from a list of officer_ids suspected to be in the same 'crew'
-- Adjust the node identity columns to contain relevant data
-- Integrate a visualization of the table graphs