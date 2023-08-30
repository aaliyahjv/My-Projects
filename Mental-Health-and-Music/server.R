library("shiny")
library(bslib)
library("dplyr")
library("ggplot2")
library("plotly")
library("tidyverse")
library("reshape2")

df <- read.csv("mxmh_survey_results_copy2.csv", stringsAsFactors = FALSE)

#### Work for page 1 ####
subset2_df <- df %>% 
  select(While.working, Music.effects)
num_row_df <- nrow(subset2_df)

#filter listen to music while working
while_w <- subset2_df %>% 
  filter(While.working == "Yes")

#filter have positive effects on listening to music while working
working_improve <- while_w %>% 
  filter(Music.effects == "Improve")

#find how many rows with YES and Improve
yes_improved <- nrow(working_improve)

#find the percentage with YES and Improve
percent_working_improve <- (yes_improved / num_row_df) * 100

#filter have negative effects on listening to music while working
working_no_improve <- while_w %>% 
  filter(Music.effects == "No effect")

#find rows with YES and no effect
yes_noeffects <- nrow(working_no_improve)

#find percent
percent_working_no_improve <- (yes_noeffects/ num_row_df) * 100

#filter no music while working
no_while_w <- subset2_df %>% 
  filter(While.working == "No")

#filter no music while working has positive effect
no_working_improve <- no_while_w %>% 
  filter(Music.effects == "Improve")

#find rows with NO and 'improved'
no_improved <- nrow(no_working_improve)

#find percent
percent_no_working_improve <-(no_improved / num_row_df) * 100

#filter no music has negative effect
no_working_no_improve <- no_while_w %>% 
  filter(Music.effects == "No effect")

#find rows with NO and 'no effects'
no_noeffects <- nrow(no_working_no_improve)

#percent
percent_no_working_no_improve <- (no_noeffects/ num_row_df) * 100

# find else
rest_else <- nrow(subset2_df) - yes_improved - yes_noeffects - no_improved - 
  no_noeffects 
percent_rest_else <- 100 - percent_working_improve - percent_working_no_improve 
- percent_no_working_improve - percent_no_working_no_improve 


Group = c("While work and effective", "While work and not effective", "Not while
          working and effective", "Not while working and not effective", "else")
value = c(yes_improved, yes_noeffects, no_improved, no_noeffects, rest_else)
percentage = c(percent_working_improve, percent_working_no_improve, 
               percent_no_working_improve, percent_no_working_no_improve, 
               percent_rest_else)

chart_df <- data.frame(Group, value, percentage)

round_percent <- round(percentage, 2)


#### Work for page 2 ####
subset_df <- df %>% 
  filter(Music.effects == "Improve") %>% 
  select(12 : 27)
subset_df <- data.frame(sapply(X = subset_df, FUN = table))
colnames(subset_df) <- c("Classical", "Country", "EDM", "Folk", "Gospel", 
                         "HipHop", "Jazz", "Kpop", "Latin", "Lofi", "Metal",
                         "Pop", "Rap", "R&B", "Rock", "Video Game")
subset_df <- as.data.frame(t(subset_df))
subset_df <- subset_df %>%
  mutate(Music_Genre = c(
    "Classical", "Country", "EDM", "Folk", "Gospel", "HipHop", "Jazz", "Kpop", 
    "Latin", "Lofi", "Metal", "Pop", "Rap", "R&B", "Rock", "Video Game"
  ))
subset_df <- melt(subset_df, id.vars = "Music_Genre")


#### Work for page 3 ####
#total responses for every listening hours per day
total_responses <- df %>% 
  group_by(Hours.per.day) %>% count(Hours.per.day)
colnames(total_responses) <- c("Hours_per_day", "num_responses")

# responses for "improved" music effect
improved <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Music.effects == "Improve")
colnames(improved) <- c("Hours_per_day", "true_false", "num_improved")
improved <- improved %>% 
  filter(true_false == "TRUE")
improved <- improved %>% 
  distinct(Hours_per_day, num_improved)
improved <- left_join(total_responses, improved, by = "Hours_per_day")
improved[is.na(improved)] <- 0
improved <- improved %>% 
  mutate(percentage_improved = (num_improved/num_responses) * 100)

# responses for "worsen" music effect
worsen <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Music.effects == "Worsen")
colnames(worsen) <- c("Hours_per_day", "true_false", "num_worsened")
worsen <- worsen %>% 
  filter(true_false == "TRUE")
worsen <- worsen %>% 
  distinct(Hours_per_day, num_worsened)
worsen <- left_join(total_responses, worsen, by = "Hours_per_day")
worsen[is.na(worsen)] <- 0
worsen <- worsen %>% 
  mutate(percentage_worsened = (num_worsened/num_responses) * 100)

# responses for no music effect
no_effect <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Music.effects == "No effect")
colnames(no_effect) <- c("Hours_per_day", "true_false", "num_no_effect")
no_effect <- no_effect %>% 
  filter(true_false == "TRUE")
no_effect <- no_effect %>% 
  distinct(Hours_per_day, num_no_effect)
no_effect <- left_join(total_responses, no_effect, by = "Hours_per_day")
no_effect[is.na(no_effect)] <- 0
no_effect <- no_effect %>% 
  mutate(percentage_no_effect = (num_no_effect/num_responses) * 100)

#graph
music_effects <- left_join(total_responses, improved, by = "Hours_per_day")
music_effects <- left_join(music_effects, worsen, by = "Hours_per_day")
music_effects <- left_join(music_effects, no_effect, by = "Hours_per_day")


#### Work for aggregate table ####
## Part 1: Number of responses
aggregate <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Hours.per.day)

## Part 2: Majority age
# Function to find mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Data frame to get majority age for every listening hours per day
age <- df %>% 
  group_by(Hours.per.day) %>% 
  mutate(getmode(Age))
colnames(age)[34] <- "Majority_Age"
age <- age %>% 
  distinct(Hours.per.day, Majority_Age)

## Part 3: Percentages of worsened, improved, and no music effect 
# Total responses for every listening hours per day
agg_total_responses <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Hours.per.day)
colnames(agg_total_responses) <- c("Hours_per_day", "num_responses")

# Responses for "improved" music effect
agg_improved <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Music.effects == "Improve")
colnames(agg_improved) <- c("Hours_per_day", "true_false", "num_improved")
agg_improved <- agg_improved %>% 
  filter(true_false == "TRUE")
agg_improved <- agg_improved %>% 
  distinct(Hours_per_day, num_improved)
agg_improved <- left_join(agg_total_responses, agg_improved, 
                          by = "Hours_per_day")
agg_improved[is.na(agg_improved)] <- 0
agg_improved <- agg_improved %>% 
  mutate(percentage_improved = (num_improved/num_responses) * 100)
agg_improved <- agg_improved %>% 
  distinct(Hours_per_day, percentage_improved)

# Responses for "worsen" music effect
agg_worsen <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Music.effects == "Worsen")
colnames(agg_worsen) <- c("Hours_per_day", "true_false", "num_worsened")
agg_worsen <- agg_worsen %>% 
  filter(true_false == "TRUE")
agg_worsen <- agg_worsen %>% 
  distinct(Hours_per_day, num_worsened)
agg_worsen <- left_join(agg_total_responses, agg_worsen, by = "Hours_per_day")
agg_worsen[is.na(agg_worsen)] <- 0
agg_worsen <- agg_worsen %>% 
  mutate(percentage_worsened = (num_worsened/num_responses) * 100)
agg_worsen <- agg_worsen %>% 
  distinct(Hours_per_day, percentage_worsened)

# Responses for no music effect
agg_no_effect <- df %>% 
  group_by(Hours.per.day) %>% 
  count(Music.effects == "No effect")
colnames(agg_no_effect) <- c("Hours_per_day", "true_false", "num_no_effect")
agg_no_effect <- agg_no_effect %>% 
  filter(true_false == "TRUE")
agg_no_effect <- agg_no_effect %>% 
  distinct(Hours_per_day, num_no_effect)
agg_no_effect <- left_join(agg_total_responses, agg_no_effect, 
                           by = "Hours_per_day")
agg_no_effect[is.na(agg_no_effect)] <- 0
agg_no_effect <- agg_no_effect %>% 
  mutate(percentage_no_effect = (num_no_effect/num_responses) * 100)
agg_no_effect <- agg_no_effect %>% 
  distinct(Hours_per_day, percentage_no_effect)

# Join all music effects
all_music_effects <- left_join(agg_improved, agg_worsen, by = "Hours_per_day")
all_music_effects <- left_join(all_music_effects, agg_no_effect, 
                               by = "Hours_per_day")

## Part 4: Majority genre
# Function to find mode
getmajority <- function(u) {
  names(which.max(table(u)))
}

# Data frame to get majority genre for every listening hours per day
genre <- df %>% 
  group_by(Hours.per.day) %>% 
  mutate(getmajority(Fav.genre))
colnames(genre)[34] <- "Majority_Genre"
genre <- genre %>% 
  distinct(Hours.per.day, Majority_Genre)
colnames(genre)[1] <- "Hours_per_day"

## Part 5: Percentage listening while working/studying
when_listening <- df %>% 
  group_by(Hours.per.day) %>% 
  count(While.working == "Yes")
colnames(when_listening) <- c("Hours_per_day", "true_false", "num_yes")
when_listening <- when_listening %>% 
  filter(true_false == "TRUE")
when_listening <- when_listening %>% 
  distinct(Hours_per_day, num_yes)
when_listening <- left_join(agg_total_responses, when_listening, 
                            by = "Hours_per_day")
when_listening[is.na(when_listening)] <- 0
when_listening <- when_listening %>% 
  mutate(percentage_yes = (num_yes/num_responses) * 100)
when_listening <- when_listening %>% 
  distinct(Hours_per_day, percentage_yes)

# Aggregate table
aggregate <- left_join(aggregate, age, by = "Hours.per.day")
colnames(aggregate) <- c("Hours_per_day", "num_responses", "majority_age")
aggregate <- left_join(aggregate, all_music_effects, by = "Hours_per_day")
aggregate <- left_join(aggregate, genre, by = "Hours_per_day")
aggregate <- left_join(aggregate, when_listening, by = "Hours_per_day")
colnames(aggregate) <- c("Hours per Day", "Number of Reponses", "Majority Age", 
                         "Percentage of Improved Health", 
                         "Percentage of Worsened Health", 
                         "Percentage of No Health Effect", "Majority Genre", 
                         "Percentage of Listening While Working/Studying")
aggregate <- aggregate %>% 
  mutate_if(is.numeric, round, digits = 2)


#### Main server code ####
server <- function(input, output) {
  
  output$list_link1 <- renderUI({
    
    p1 <- paste0("In the study titled, ", 
                 tags$a(href = 
                 "https://link.springer.com/article/10.1007/s10597-019-00380-1", 
                 "Comparing Educational Music Therapy Interventions via Stages 
                 of Recovery with Adults in an Acute Care Mental Health Setting"
                 ), ", researchers performed studies that compared 69 adult 
                 patients in an acute mental health unit. They made three 
                 groups, the controlled, educational lyrical analysis group 
                 (ELA), and the educational songwriting (ESW) which contributed 
                 to the question of wheater music helped these patients in these 
                 units during their time of recovery. Although there wasn’t a 
                 significant difference between the groups, it still showed a 
                 better overall score of recovery compared to the control group.
                 ")
    
    HTML(p1)
  })
  
  output$list_link2 <- renderUI({
    
    p1 <- paste("On the other hand, a review article called,", 
                tags$a(href = 
                "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8566759/",
                "Music, mental health, and immunity"), "talks about the 
                importance of music therapy. It involves a therapeutic process 
                developed between the patient and their therapist through the 
                use of personalized music experiences. Utilizing music to treat 
                mental illnesses such as anxiety, depression, and schizophrenia 
                has improved symptoms, This is because music therapy allows 
                patients to express emotions while at a stage of relaxation and 
                feelings of safety. In addition, there have been studies showing 
                that listening to pleasurable music increases the release of 
                dopamine and network connectivity.")
    
    HTML(p1)
  })
  
  output$list_link3 <- renderUI({
    
    p1 <- paste("An article published by AARP called", 
                tags$a(href = 
                "https://www.aarp.org/health/brain-health/info-2020/music-mental-health.html", 
                "Music Can Be a Great Mood Booster"), "asks the questions of how music can 
                impact your life. It describes music therapy as an established 
                healthcare profession. In a study of 3,185 participants, they 
                found that using music came to approach goals of decreasing 
                pain, finding motivation, and helping with depression. Also, 
                decrease the levels of cortisol during times of stress or 
                prolonged stress.")
    
    HTML(p1)
  })
  
  output$ref_link1 <- renderUI({
    
    p1 <- paste("Adler, S. E. (2022, August 10). Positive effects of music for 
                Mental Health. AARP. Retrieved February 1, 2023, from", 
                tags$a(href = 
                "https://www.aarp.org/health/brain-health/info-2020/music-mental-health.html", 
                "https://www.aarp.org/health/brain-health/info-2020/music-mental-health.html"))
    
    HTML(p1)
  })
  
  output$ref_link2 <- renderUI({
    
    p1 <- paste("Silverman, M.J. Comparing Educational Music Therapy 
                Interventions via Stages of Recovery with Adults in an Acute 
                Care Mental Health Setting: A Cluster-Randomized Pilot 
                Effectiveness Study. Community Ment Health J 55, 624–630 (2019).
                From", 
                tags$a(href = 
                "https://link.springer.com/article/10.1007/s10597-019-00380-1", 
                "https://doi.org/10.1007/s10597-019-00380-1"))
    
    HTML(p1)
  })
  
  output$dataset_link1 <- renderUI({
    
    p1 <- paste("We found the data on", 
                tags$a(href = 
                "https://www.kaggle.com/datasets/catherinerasgaitis/mxmh-survey-results?resource=download", 
                "Kaggle."))
    
    HTML(p1)
  })
  
  output$plot2 <- renderPlotly({
    
    filtered_df <- chart_df %>%
      filter(Group %in% input$Group_selection) %>%
      filter()
    
    plot2 <- ggplot(data = filtered_df) +
      geom_col(mapping = aes(
        x = Group, 
        y = percentage, 
        fill = Group)) +
      labs(title = "Multitasking & Music Effect", 
           x = "Group", 
           y = "Percentage %", 
           color = Group) +
      scale_fill_brewer(palette = "Pastel1")
    
    return(plot2)
  })
  
  output$plot3 <- renderPlotly({
    
    validate(need(input$checkbox, "Please Choose Your Music Genre"))
    
    genre_effect <- subset_df %>% 
      filter(Music_Genre %in% input$checkbox)
    
    plot3 <- ggplot(genre_effect, 
                    aes(x = Music_Genre, 
                        y = value, 
                        fill = variable, 
                        label = value,
                        text = paste0("Music Genre: ", Music_Genre, "<br>",
                                      "Frequency: ", variable, "<br>",
                                      "Number: ", value))) +
      geom_bar(stat = "identity") +
      geom_text(size = 3, position = position_stack(vjust = 0.5)) +
      scale_fill_brewer(palette = "Pastel2") +
      labs(title = "Music Genre vs Music Effects",
           x = "Music Genre",
           y = "Number of People Who Report 'Improve'",
           fill = "Frequency")
    
    return(ggplotly(plot3, tooltip = "text"))
  })
  
  output$des <- renderUI({
    p1 <- paste("A line graph is used because it shows the changes over time as 
                a series of data points connected by a line in order to 
                determine the relationship between two sets of values. 
                Which in this case are the hours and the percentage. It shows 
                the Music effects of being Improved, No effect, and Worsened 
                over the period of time people listen to music in color coded 
                lines.")
    p2 <- paste("The graph shows the difference that music made a difference in 
                how people felt and improvement on their mood and well-beingas 
                much of the results is highly favorable to music and its 
                improvements. And less people felt that music actually worsen 
                their well-being and mood. By looking at this graph, we see that
                listening to music have some positive effects on people's mental
                health and overall well-being.")
    
    HTML(paste(p1, p2, sep = '<br/>'))
  })
  
  output$music_plot <- renderPlotly({
    
    filtered_music <- music_effects %>% 
      filter(Hours_per_day >= input$hours_selection[1] & 
               Hours_per_day <= input$hours_selection[2]) 
    
    music_plot <- ggplot(filtered_music) +
      geom_point(mapping = aes(x = Hours_per_day, 
                               y = percentage_improved, 
                               color = "improved")) + 
      geom_line(mapping = aes(x = Hours_per_day, 
                              y = percentage_improved, 
                              color = "improved")) +
      geom_point(mapping = aes(x = Hours_per_day, 
                               y = percentage_worsened, 
                               color = "worsen")) + 
      geom_line(mapping = aes(x = Hours_per_day, 
                              y = percentage_worsened, 
                              color = "worsen")) +
      geom_point(mapping = aes(x = Hours_per_day, 
                               y = percentage_no_effect, 
                               color = "no effect")) + 
      geom_line(mapping = aes(x = Hours_per_day, 
                              y = percentage_no_effect, 
                              color = "no effect")) +
      labs(title = "Hours of music and its effects", 
           x = "Hours", 
           y = "Percentage", 
           color = "Music Effects")
    
    return(ggplotly(music_plot))
  })
  
  output$agg_table <- renderTable(
    aggregate,
    bordered = TRUE,
    align = "c"
  )
}