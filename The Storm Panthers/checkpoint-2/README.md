# Checkpoint 2: Data Visualization

### Accessing our Tableau visualizations
Navigate to the source folder, click on `visualizations.twbx`. On the following screen, click on `download`. Once it finishing downloading, open the file to launch Tableau Desktop. If and when you are prompted for a password, enter **dataSci4lyf**. In the event that you are asked if you wish to import custom sql and/or connections, select **yes**.

Each of our visualizations lives on its own sheet in the workbook. The sheet names and corresponding visualizations are as follows:

## Viz #1: frequency wordcloud
This visualization presents the frequency of words within summaries of home invasion settlement cases (sourced from the Settling for Misconduct Dataset that is now available in cpdb). The bigger the word, the more often it appears in summaries. You can hover a word to view this frequency. In our custom SQL statement, we filtered for words that are greater than 3 characters long, transformed all words to lowercase, filtered to words that appeared 50 or more times, and finally, we removed the following words from the dataset: when, they, were, with, them, that, their, while. Below is the custom SQL query used to gather our data for this visualization:

    with lower_summaries AS (select LOWER(summary) as summary from lawsuit_lawsuit where 'Home invasion'=ANY(interactions)),
    words AS (select unnest(regexp_matches(summary, '(\w{4,})', 'g')) as summary_words from lower_summaries),
    word_counts as (select summary_words, count(summary_words) as count from words group by summary_words)
    select summary_words, count from word_counts where count >= 25
    AND summary_words not in ('when', 'they', 'were', 'with', 'them', 'that', 'their', 'while')

A preview of the visualization:
![viz1](/The Storm Panthers/checkpoint-2/images/wordcloud1screenshot.png)

## Viz #2: "What victims were doing when..." wordcloud
This visualization presents what victims who received a settlement for a CPD home invasion were doing at the onset of the invasion. The larger the size of the text, the larger the settlement amount was. You can hover over each entry to view the total settlement amount. When browsing the Settling for Misconduct interface, we noticed that many of the summaries were written in the format, "\[victim\] was \[doing something\] when \[the police entered their home\]". Thus, we exploited this observation to extract substrings of the summaries that did follow that structure. We also filtered down to summaries that were between 2 than 100 characters (not inclusive) to clean out some substrings that were mistakenly grabbed. Below is the custom SQL query used to gather our data for this visualization:

    with eligible_summaries as (SELECT summary, total_settlement from lawsuit_lawsuit where 'Home invasion'=ANY(interactions) AND summary ILIKE '%was%when%'),
    segments as (select distinct substring(summary from 'was (.*?) when') as was_doing, total_settlement from eligible_summaries)
    select was_doing, cast(total_settlement as int) as amount, CONCAT('$', cast(total_settlement as int)) as tooltip from segments where length(was_doing) < 100 AND length(was_doing) > 2

A preview of the visualization:
![viz2](/The Storm Panthers/checkpoint-2/images/wordcloud2screenshot.png)

