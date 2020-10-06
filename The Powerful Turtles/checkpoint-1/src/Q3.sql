-- Q3:What is the race distribution among the complainant?

SELECT race,count(race) as count, count(race) /(SELECT COUNT(race)*1.0 FROM data_officer) as race_dist
From data_officer
GROUP BY race, race
ORDER BY count(race)

SELECT race,count(race) as count, count(race)/(SELECT COUNT(race)*1.0 FROM data_complainant) as race_dist_comp
From data_complainant
GROUP BY race, race
ORDER BY count(race)