SELECT a.id, c.crid, c.beat_id, d.name, c.incident_date, c.add1, c.add2, c.old_complaint_address
FROM data_officer a
LEFT JOIN data_officerallegation b
ON a.id = b.officer_id
LEFT JOIN data_allegation c
ON b.allegation_id = c.crid
LEFT JOIN data_area d
ON d.id = c.beat_id
WHERE c.add2 IS NOT NULL or c.old_complaint_address IS NOT NULL and c.beat_id is not NULL
ORDER BY c.beat_id, c.incident_date
