# Mental Health & Music
## INFO 201 "Foundational Skills for Data Science" - Winter 2022

Authors: Alice Chen, Aaliyah Viloria, Siyi Xu, Michelle Zhang

Link: https://aviloria.shinyapps.io/Mental-Health-and-Music/


# Introduction
### Overview
Our main question is how do music-listening habits relate to the listener’s mental health? This question is important because music is a powerful tool that can affect people’s lives on varying levels. To address the question, we will analyze a dataset containing information on respondent’s age, number of hours respondents listen to music per day, self-reported mental health disorders, and the overall effect of music on respondent’s mental health.


### Introduction
For our project, we wanted to explore the relationship between mental health and music-listening habits. We decided on this topic due to the significance of music in our daily lives, and the effect it has on us. We plan to examine a dataset of over 700 survey results containing information on respondent’s age, the number of hours respondents listen to music per day, self-reported mental health disorders (anxiety, depression, insomnia, OCD), and the overall effect of music on respondent’s mental health conditions, to answer our research questions. Three main questions we want to answer are:
* How often do respondents listen to music per day?
* Do respondents generally listen to music while performing other tasks (studying, working, etc)? If so, does it allow them to work on tasks more efficiently?
* Does music improve or worsen a respondent’s mental health conditions overall?
* Is there a correlation between listening hours, and the respondents’ age and preferred genre?

These questions are important for our research as it allows us to find correlations between music and mental health, and answer other related questions such as “does an increase in the number of hours the respondent listens to music per day correspond to a better mental health state?”, and if certain habits like multitasking can be of benefit for one’s mental health.


### Related Work
Music is a crucial element of everyday life for most people. It plays a big role in people’s cultures and backgrounds and is often played or listened for all ages. It can be a crucial part of developmental stages in early life and create healthy bonds with one another. Music is a versatile instrument that can be used not only for entertainment but for mental health purposes as well.

1. In the study titled, [Comparing Educational Music Therapy Interventions via Stages of Recovery with Adults in an Acute Care Mental Health Setting](https://doi.org/10.1007/s10597-019-00380-1), researchers performed studies that compared 69 adult patients in an acute mental health unit. They made three groups, the controlled, educational lyrical analysis group (ELA), and the educational songwriting (ESW) which contributed to the question of wheater music helped these patients in these units during their time of recovery. Although there wasn’t a significant difference between the groups, it still showed a better overall score of recovery compared to the control group.
2. On the other hand, a review article called, [Music, mental health, and immunity](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8566759/) talks about the importance of music therapy. It involves a therapeutic process developed between the patient and their therapist through the use of personalized music experiences. Utilizing music to treat mental illnesses such as anxiety, depression, and schizophrenia has improved symptoms, This is because music therapy allows patients to express emotions while at a stage of relaxation and feelings of safety. In addition, there have been studies showing that listening to pleasurable music increases the release of dopamine and network connectivity.
3. An article published by AARP called [Music Can Be a Great Mood Booster](https://www.aarp.org/health/brain-health/info-2020/music-mental-health.html) asks the questions of how music can impact your life. It describes music therapy as an established healthcare profession. In a study of 3,185 participants, they found that using music came to approach goals of decreasing pain, finding motivation, and helping with depression. Also, decrease the levels of cortisol during times of stress or prolonged stress.

References

Adler, S. E. (2022, August 10). Positive effects of music for Mental Health. AARP. Retrieved February 1, 2023, from https://www.aarp.org/health/brain-health/info-2020/music-mental-health.html

Rebecchini L. Music, mental health, and immunity. Brain Behav Immun Health. 2021 Oct 21;18:100374. doi: 10.1016/j.bbih.2021.100374. PMID: 34761245; PMCID: PMC8566759.

Silverman, M.J. Comparing Educational Music Therapy Interventions via Stages of Recovery with Adults in an Acute Care Mental Health Setting: A Cluster-Randomized Pilot Effectiveness Study. Community Ment Health J 55, 624–630 (2019). From https://doi.org/10.1007/s10597-019-00380-1


### The Dataset
Where did you find the data? Please include a link to the data source.
* We found the data on [Kaggle](https://www.kaggle.com/datasets/catherinerasgaitis/mxmh-survey-results?resource=download).

Who collected the data?
* It was collected by Catherine Rasgaitis, an undergraduate from the University of Washington.

How was the data collected or generated?
* The data was collected via a Google form which was posted on several social media platforms such as Reddit or Discord.
* Rasgaitis also propagandized the form in public locations such as libraries as posters or business cards. In this form with only brief questions, respondents ranked how frequently they listened to each of 16 musical genres, and ranked Anxiety, Depression, Insomnia, and OCD on a scale of 0 to 10.

Why was the data collected?
* The data was collected because Rasgaitis aimed to find out any correlations between a person’s musical preferences and their self-reported mental health, which wished to provide insights into how music therapy could be used as a treatment of mental health problems.

How many observations (rows) are in your data?
* There are 737 rows that each represents an individual respondent.

How many features (columns) are in the data?
* There are 33 features in the data

What, if any, ethical questions or questions of power do you need to consider when working with this data?
* One ethical question that we need to consider is to respect respondents’ privacy. The last column (feature) of the data records whether the respondent permits to publicize the data which contains his/her personal information.

What are possible limitations or problems with this data?
* A possible limitation with this data is that it is mainly collected through certain online platforms. Although the respondents are not limited by age or location, the process of data collection itself might exclude those who do not use these online platforms, which leads to a limited sample size.
* Another limitation is that the data does not include additional questions about demographics (country, sex, etc.) which could add more interesting insights. Similarly, there are other unrepresented music genres which may also help identify the relationship between music taste and mental health.


### Implications
Exploring the correlations between an individual’s music taste and their mental health can help us to get an ideal understanding on how music therapy improves an individual’s stress, mood, and overall mental health. The finding that music therapy is an effective way to improve an individual’s mood can help people who are suffering from the mental health issues to know the way to promote mental health by using music therapy.

Assuming answers to the research questions, the time respondents spend on music services can help us to know the best time duration for improving mood. For example, finding out the best time duration can prevent people from listening too long to cause the tiring mood and noisy feeling. The dataset can also help us to know how music impacts our ability when performing the tasks, finding out the most suitable music genre for healing and working.

The possible implication for technologists could be implementing the function in a music platform to be able to organize the types of music and utilities of music by personal preference. For example, the music platform can have a category about music therapy with music that the therapist recommended and the music people personally like. Therefore, studying the relationship between an individual’s music taste and mental health allows people to know that different music genres have different impacts on people’s mood, so people can use music therapy to listen to specific music genres to heal their emotion.


### Limitations & Challenges
One of the limitations that our group project faces is that respondents assess their mental health only by self-report. The self-report exists a problem that respondents may not assess themselves accurately on self-report, and they may feel too embarrassed to reveal the truth by choosing a more acceptable choice. Also, the method of measuring mental health based on asking questions on whether they experience the disorders is not detailed and precise. People who do not have any psychological knowledge are unaware of the symptoms of these mental illnesses, so they may choose a low score on rating scale even if they do experience them. Therefore, the limitation of self-report may cause the probability of providing invalid information.

Another limitation is that there is a low externality validity on generalization. The dataset has missing information on demographics and some genres that are not common, and the information of gender and race and other small music genres might provide interesting information to help find the relationship. In addition, the primary streaming service is Spotify, so the lack of music platforms might also impact generalization.

Some challenges that our group might face are the large size of the dataset and complex category of music genres. The size of our dataset is large with 737 respondents and 16 types of music genres, so they are more complex than what we usually work with.

Another issue we will face is that some information on effect is missing, so we have to find out whether it impacts or not manually. It is important to acknowledge these limitations and challenges to the dataset in order to have a better understanding on the relationship between music and mental health and how it improves mental health.


# Conclusion / Summary Takeaways

The table shows aggregate information on listening behavior and the effects of such behavior on mental health, for varying listening hours per day. Looking at a table with 736 rows can be very complicated, especially when you’re comparing values that are grouped by a certain attribute (e.g. compare data values between respondents of the age 18 vs. age 42), because the attribute may be spread out throughout a column. We created this aggregate table to make it easier to do such comparison, and we specifically grouped the data by the number of listening hours, because we wanted to see how the data varies with an increase in listening hours, especially how it has affected respondents’ mental health.

Through calculation, we found that this dataset about mental health and music includes 736 responses, and 33 features. We have compared listening habits and effects between each number of listening hours in the aggregate table and the three pages with charts. There are 27 groups of listening hours. Out of all the respondents, 78.67% listen to music while working/studying, Rock is the most common genre listened to, 73.64% reported improved health, 2.31% reported worsened health, 22.96% reported no effect of music on their mental health, and the remaining 1.09% did not respond to the question.

When evaluating the percentage of people who listen to music while working and/or studying for each listening hour group, we found that for all but 5 of the listening hour groups, at least 50% of the respondents listen to music while working on tasks. As for analyzing the percentage of people who listen to music while working and/or studying for each of the five music effectiveness groups (multitasking and music is effective (61.01%), multitasking and music is not effective (15.35%), not multitasking and music is effective (12.50%), not multitasking and music is not effective (7.47%), and no response (3.67%)), is is clear that a large majority of respondents thought that music was effective while they worked/studied. Although we did not compare the music effectiveness of listening to music while working (vs. not working) for each listening hour group, we can make a connection between the percentage of people who listen while working, and the largest percentage out of the five music effectiveness groups, and say that the majority of our respondents listen to music while working/studying, and find that doing such multitasking is effective in improving their mental health.

As for the analysis of music genres and music effects, we have found that when comparing the genre most listened to for each listening hour group, rock dominated, with 15 out of the 27 (55.56%) groups having this genre as the majority. When looking at the bar chart on page “Music Genres”, it is seen that those who listened to rock had the largest number of reports of improvement (241), with pop following (213), and metal after (105). In comparison to genres of softer sounds, those who listened to classical music very frequently had 80 reports of improvement, jazz had 41 reports, and lofi had 66 reports. These numbers may suggest that softer-sounding music has less effectiveness in improving one’s mental health.

For all but 5 of the listening hour groups, at least 50% of the respondents reported improved health (with “no effect” being the majority response for the 5 groups). The first third of the groups (0 to 2.5 listening hours) had an average of 63.21% improved health, the second third (3 to 10 hours) had an average of 73.22%, and the last third (11 to 24 hours) had an average of 64.82%. While it is difficult to compare these three percentage values between each other, because the number of responses for each group vary greatly (e.g. 1 response could result in 100% improved health), the averages being greater than 50% can show that music brings improvement to mental health overall.

Although some patterns are present in the data and calculations we have collected, it is important to note that correlation does NOT mean causation. While finding ways to improve one’s mental health is very powerful, we want to iterate that everyone is unique, and each individual can find improvement in different ways, whether it be through listening to music or not. We chose this topic with the interest of finding connections between music listening and mental health, but also acknowledge that a lot of the patterns we see may simply be relative and relevant to the respondents within this dataset, and give the freedom to let viewers decide on what they would like to do with this information.