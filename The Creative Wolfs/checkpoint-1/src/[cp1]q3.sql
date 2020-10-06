
/* calculate the average number of awards received by all repeaters */
select avg(number_of_awards) as average_num_awards_of_repeaters
from
     /* join award on repeaters to find out the number of awards received by every repeater*/
(select data_award.officer_id, count(*) as number_of_awards
from data_award join
    /* select all the repeaters*/
(select officer_id, count(*) as number_of_allegations
from data_officerallegation
group by officer_id
order by number_of_allegations desc
limit 4000) as repeaters on repeaters.officer_id = data_award.officer_id
group by data_award.officer_id) as joined
