# Disclaimer: we are still actively working on finishing Viz 1, stay tuned!

## Viz 1: Map of Chicago Home Invasions
[See the current status of the visualization here](https://observablehq.com/d/e3f86aa0ce617ce1)

### Observations: 

## Viz 2: Breakdown of Home Invasion Victims by Race and Gender
[See visualization here](https://observablehq.com/@fobkid20/victim-gender-race-3)
This visualization used the results of query c3_q2. It depicts the race and gender of victims of home invasion based on complaints tagged “Search Of Premise Without Warrant” in residences or private property. The visualization is togglable by race and gender.

### Observations: 
One thing immediately clear from this data is that women are more likely to report being victim of this type of interaction, regardless of race. Another is that Black individuals are overrepresented in this population, while Asian/Pacific Islanders are underrepresented. 

### Drawbacks:
There are several things not captured by this visualization. For one, the races provided in the data are mutually exclusive. However, in reality, individuals may identify as multiple races, say White and Hispanic. This is a flaw in the underlying data. Another limitation is the lack of inclusion of the demographic breakdown of Chicago, which itself contains key information necessary for understanding which home invasion populations are over or underrepresented relative to their prevalence in the community at large. This would tell us, for instance, that though Hispanics and Whites appear to be equally targeted based on the visualization, the White population is 16% larger than the Hispanic population as of the 2010 census, so the minority Hispanic population is actually overrepresented in home invasions. It would tell us more clearly the degree to which the Black population is overrepresented (70% of home invasion complaints vs. 33% of Chicago population) or the Asian/Pacific Islander population is underrepresented (0.68% of home invasion complaints vs. 5.5% of Chicago population).


## Viz 3: Breakdown of Officers Implicated in Home Invasions Over Time by Race, Gender, and Age
[See visualization here](https://observablehq.com/@brendoneby/officers-involved-in-home-invasion-cases-per-1000-active-of)

This visualization shows the incident rates of allegations of “search of premises without warrant” based on the demographics of the officers involved.  As there is an unequal distribution of officer demographics within the police force (white males make up the largest group), we chose to show incident rates per 1000 officers that meet the user-specified parameters.  For this question, we chose to focus on all premises searches that are either private residences or of unknown location type, as there is not enough data for private residences alone.

This rate is found by dividing total incidents in each year (query c3_q3a.sql) by the total estimated officers on the force in the specified year (query c3_q3b.sql), then multiplied by 1000.  Before division, both lists are filtered as specified by the user.  We looked at gender, age group, and race as available filters.

### Observations: 
1. By changing the demographic parameters we can see the incident rates over time for each demographic group.  These demographics showed the following trends:
    1. Male officers are more than twice as likely to be involved in these incidents than female officers.
    2. Officers in their 20s and 30s are far more likely to be involved in these incidents than officers 40 and above, again more than double the rates of higher age groups.  These rates go down in every subsequent age group.
    3. White and Hispanic officers are more likely to be involved in these incidents than other ethnicities.
    4. Combining the above observations, we can see that young white and hispanic males are by far the most likely officers to be involved with illegal searches, even after controlling for overall demographics within the police force. 

2. All groups show a decrease in frequency of incidents over the last 20 years, especially after 2010. This may be due to increased public scrutiny of these kinds of practices, and easier access to documenting methods such as cell phones.

3. Incidents overall increased until they peaked in the year 2000, then have decreased since then.  This is not uniform across demographics however.  In fact, it appears that white males (the largest demographic and therefore the most influential for overall trends) is the only demographic that shows this trend.  All other demographics show a general downward trend from the 90s through now.  This is curious, and it would be interesting to see what caused this unusual pattern among white men.

4. Despite overall trends among non-white-male demographics being downward over time, most demographics had a spike in incidents in the year 2000 specifically, showing significantly higher rates than usual.  This would be interesting to look further into as well, perhaps there was a legal change that drove this trend.
