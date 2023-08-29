library(ggplot2)
library(plotly)
library(dplyr)
library(shiny)
music_df <- read.csv("mxmh_survey_results_copy2.csv", stringsAsFactors = F)
# CODE from last time:
#total responses for every listening hours per day
total_responses <- music_df %>% group_by(Hours.per.day) %>% count(Hours.per.day)
colnames(total_responses) <- c("Hours_per_day", "num_responses")

# responses for "improved" music effect
improved <- music_df %>% group_by(Hours.per.day) %>% count(Music.effects == "Improve")
colnames(improved) <- c("Hours_per_day", "true_false", "num_improved")
improved <- improved %>% filter(true_false == "TRUE")
improved <- improved %>% distinct(Hours_per_day, num_improved)
improved <- left_join(total_responses, improved, by = "Hours_per_day")
improved[is.na(improved)] <- 0
improved <- improved %>% mutate(percentage_improved = (num_improved/num_responses) * 100)

# responses for "worsen" music effect
worsen <- music_df %>% group_by(Hours.per.day) %>% count(Music.effects == "Worsen")
colnames(worsen) <- c("Hours_per_day", "true_false", "num_worsened")
worsen <- worsen %>% filter(true_false == "TRUE")
worsen <- worsen %>% distinct(Hours_per_day, num_worsened)
worsen <- left_join(total_responses, worsen, by = "Hours_per_day")
worsen[is.na(worsen)] <- 0
worsen <- worsen %>% mutate(percentage_worsened = (num_worsened/num_responses) * 100)

# responses for no music effect
no_effect <- music_df %>% group_by(Hours.per.day) %>% count(Music.effects == "No effect")
colnames(no_effect) <- c("Hours_per_day", "true_false", "num_no_effect")
no_effect <- no_effect %>% filter(true_false == "TRUE")
no_effect <- no_effect %>% distinct(Hours_per_day, num_no_effect)
no_effect <- left_join(total_responses, no_effect, by = "Hours_per_day")
no_effect[is.na(no_effect)] <- 0
no_effect <- no_effect %>% mutate(percentage_no_effect = (num_no_effect/num_responses) * 100)

#graph
music_effects <- left_join(total_responses, improved, by = "Hours_per_day")
music_effects <- left_join(music_effects, worsen, by = "Hours_per_day")
music_effects <- left_join(music_effects, no_effect, by = "Hours_per_day")

ggplot(music_effects) + 
  geom_point(mapping = aes(x = Hours_per_day, y = percentage_improved, color = "improved")) + 
  geom_line(mapping = aes(x = Hours_per_day, y = percentage_improved, color = "improved")) +
  geom_point(mapping = aes(x = Hours_per_day, y = percentage_worsened, color = "wrosen")) + 
  geom_line(mapping = aes(x = Hours_per_day, y = percentage_worsened, color = "wrosen")) +
  geom_point(mapping = aes(x = Hours_per_day, y = percentage_no_effect, color = "no effect")) + 
  geom_line(mapping = aes(x = Hours_per_day, y = percentage_no_effect, color = "no effect")) +
  labs(title = "Hours of music and its effects", x = "Hours", y = "Percentage", color = "Music Effects")


# UI code:
page1 <- tabPanel("Listening Hours",
                  h1("Listening Hours & Music Effect", align="center"),
                  h2("Description"),
                  htmlOutput("des")
)

slider_widget <- sliderInput(
  inputId = "hours_selection",
  label = "Hours",
  min = 0,
  max = max(music_effects$Hours_per_day),
  value = c(5, 15),
  sep = "")

main_plot <- mainPanel(plotlyOutput(outputId = "music_plot"))

full_tab <- tabPanel("Chart1",
                     sidebarLayout(
                       sidebarPanel(
                         slider_widget
                       ),
                       main_plot
                     ),
                     h2("Description"),
                     htmlOutput("des")
)

ui <- navbarPage("Music effects", full_tab)


###################################
# Server code:
server <- function(input, output) {
  output$des <- renderUI({
    p1 <- paste("A line graph because it shows the changes over time as a series of data points connected by a line in order to determine the relationship between two sets of values. Which in this case are the hours and the percentage. It shows the Music effects of being Improved, No effect, and Worsened over the period of time people listen to music in color coded lines.")
    p2 <- paste("The graph shows the difference that music made a difference in how people felt and improvement on their mood and well-beingas much of the results is highly favorable to music and its improvements. And less people felt that music actually worsen their well-being and mood. By looking at this graph, we see that listening to music have some positive effects on people's mental health and overall well-being.")
    HTML(paste(p1, p2, sep = '<br/>'))
  })
  
  output$music_plot <- renderPlotly({
    filtered_music <- music_effects %>% 
      filter(Hours_per_day %in% input$hours_selection) 
    
    # Plot
    music_plot <- ggplot(filtered_music) +
      geom_point(mapping = aes(x = Hours_per_day, y = percentage_improved, color = "improved")) + 
      geom_line(mapping = aes(x = Hours_per_day, y = percentage_improved, color = "improved")) +
      geom_point(mapping = aes(x = Hours_per_day, y = percentage_worsened, color = "wrosen")) + 
      geom_line(mapping = aes(x = Hours_per_day, y = percentage_worsened, color = "wrosen")) +
      geom_point(mapping = aes(x = Hours_per_day, y = percentage_no_effect, color = "no effect")) + 
      geom_line(mapping = aes(x = Hours_per_day, y = percentage_no_effect, color = "no effect")) +
      labs(title = "Hours of music and its effects", x = "Hours", y = "Percentage", color = "Music Effects")
    
    return(ggplotly(music_plot))
  })
}
