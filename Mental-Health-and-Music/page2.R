library("dplyr")
library("plotly")
library("ggplot2")
library("tidyverse")
library("reshape2")
library("shiny")

# Dataframe
df <- read.csv("mxmh_survey_results_copy2.csv", stringsAsFactors = FALSE)

subset_df <- df %>% 
  filter(Music.effects == "Improve") %>% 
  select(12 : 27)
subset_df <- data.frame(sapply(X = subset_df, FUN = table))
colnames(subset_df) <- c("Classical", "Country", "EDM", "Folk", "Gospel", "HipHop", 
                         "Jazz", "Kpop", "Latin", "Lofi", "Metal",
                         "Pop", "Rap", "R&B", "Rock", "Video Game")
subset_df <- as.data.frame(t(subset_df))
subset_df <- subset_df %>%
  mutate(Music_Genre = c(
    "Classical", "Country", "EDM", "Folk", "Gospel", "HipHop", "Jazz", "Kpop", 
    "Latin", "Lofi", "Metal", "Pop", "Rap", "R&B", "Rock", "Video Game"
  ))
subset_df <- melt(subset_df, id.vars = "Music_Genre")

# UI code:
page3 <- tabPanel(
  title = "Music Genres",
  h1("Music Genres & Music Effect", align = "center"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        "checkbox",
        label = h3("Music Genres"),
        choices = c(
          "Classical", "Country", "EDM", "Folk", "Gospel", "HipHop", "Jazz", "Kpop", 
          "Latin", "Lofi", "Metal", "Pop", "Rap", "R&B", "Rock", "Video Game"
        ),
        selected = "Classical"
      ), 
    ),
    mainPanel(
      plotlyOutput("plot3"),
      p("The stacked bar chart represents the number of respondents who report 
         'Improve' in terms of music effects within each music genre 
         (16 music genres in total). Each bar is divided into 4 sub-bars stacked
         end to end, each sub-bar corresponding to levels of frequency of 
         listening to each music genre, marked by 'never, rarely, sometimes, 
         very frequently'. The reason why we choose this stacked bar chart is 
         that it can clearly show how each music genre has a impact on people's 
         mental health based on how often they listen to certain type of music. 
         The length of each sub-bar demonstrates which music genre influences 
         people's mental health the most. By evaluating this chart, we can see 
         that listening to rock music very frequently can have the most postive 
         impact on people's mental health.")
    )
  )
)


###################################
# Server code:
server <- function(input, output) {
  
  output$plot3 <- renderPlotly({
    
    validate(need(input$checkbox, "Please Choose a Music Genre"))
    
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
} 

