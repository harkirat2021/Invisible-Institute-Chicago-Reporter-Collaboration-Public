SELECT t.allegation_count,t.current_badge, t.last_unit_id, t.CTID
FROM public.data_officer t
GROUP BY t.last_unit_id, t.allegation_count, t.current_badge, t.CTID
order by COUNT(*) DESC;
