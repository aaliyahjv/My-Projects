library(ggplot2)
library(dplyr)
library(plotly)
library(bslib)
library(tidyverse)
library(shiny)


#dataframe
df <- read.csv("mxmh_survey_results_copy2.csv", stringsAsFactors = FALSE)

subset_df <- df %>% select(While.working, Music.effects)
num_row_df <- nrow(subset_df)

#filter listen to music while working
while_w <- subset_df %>% filter(While.working == "Yes")

#filter have positive effects on listening to music while working
working_improve <- while_w %>% filter(Music.effects == "Improve")

#find how many rows with YES and Improve
yes_improved <- nrow(working_improve)

#find the percentage with YES and Improve
percent_working_improve <- (yes_improved / num_row_df) * 100

#filter have negative effects on listening to music while working
working_no_improve <- while_w %>% filter(Music.effects == "No effect")

#find rows with YES and no effect
yes_noeffects <- nrow(working_no_improve)

#find percent
percent_working_no_improve <- (yes_noeffects/ num_row_df) * 100

#filter no music while working
no_while_w <- subset_df %>% filter(While.working == "No")

#filter no music while working has positive effect
no_working_improve <- no_while_w %>% filter(Music.effects == "Improve")

#find rows with NO and 'improved'
no_improved <- nrow(no_working_improve)

#find percent
percent_no_working_improve <-(no_improved / num_row_df) * 100

#filter no music has negative effect
no_working_no_improve <- no_while_w %>% filter(Music.effects == "No effect")

#find rows with NO and 'no effects'
no_noeffects <- nrow(no_working_no_improve)

#percent
percent_no_working_no_improve <- (no_noeffects/ num_row_df) * 100

# find else
rest_else <- nrow(subset_df) - yes_improved - yes_noeffects - no_improved - no_noeffects 
percent_rest_else <- 100 - percent_working_improve - percent_working_no_improve - percent_no_working_improve - percent_no_working_no_improve 


Group = c("While work and effective", "While work and not effective", "Not while working and effective", "Not while working and not effective", "else")
value = c(yes_improved, yes_noeffects, no_improved, no_noeffects, rest_else)
percentage = c(percent_working_improve, percent_working_no_improve, percent_no_working_improve, percent_no_working_no_improve, percent_rest_else)

chart_df <- data.frame(Group, value, percentage)

round_percent <- round(percentage, 2)


# UI code:
my_theme <- bs_theme(
  bg = "#0b3d91", # background color
  fg = "white", # foreground color
  primary = "#FCC780", # primary color
)
# Update BootSwatch Theme
my_theme <- bs_theme_update(my_theme, bootswatch = "cerulean")



page2 <- tabPanel("When Listening",
                  h1("Multitasking & Music Effect", align="center"),
)

select_widget <-
  selectInput(
    inputId = "Group_selection",
    label = "Group",
    choices = chart_df$Group,
    selectize = TRUE,
    multiple = TRUE,
    selected = "While work and effective"
  )

main_panel_plot <- mainPanel(plotlyOutput(outputId = "plot2"),
                             
                             p("The bar chart represents the percentage of effects on how music can impact people when they are doing their tasks or not.The plot is the interactive visualization plot to allow people to choose which group's data they want to look at. It is obvious to see the different groups and their percentage bars to illustrate numerical proportion.There are 5 groups/bars in this dataset. The group of 'while work and effective' refers to the group of people who are listening to music while working and also have positive effects. The group of 'while work and not effective' refers to the group of people who are listening to music while working and do not have effects. Also, the group of 'not while working and effective' means the group of people who not listen to music while working and have positive effects. The group of 'not while working and not effective' refers to the group of people who not listen to music while working and have no effects. The fifth group 'else' is the group of people with missing information and have worsen effects. Therefore, it obviously demonstrates that people in this dataset largely show music has positive effect on mental health and work emotion when listening to music while working.")
)



viz_tab <- tabPanel(
  "Interactive visualization 2",
  sidebarLayout(
    sidebarPanel(
      select_widget,
    ),
    main_panel_plot
    
  )
)

ui <- navbarPage(
  "Multitasking & Music Effect",
  viz_tab
)

###################################
# Server code:

df <- read.csv("mxmh_survey_results_copy2.csv", stringsAsFactors = FALSE)

subset_df <- df %>% select(While.working, Music.effects)
chart_df <- data.frame(Group, value, percentage)

server <- function(input, output) {
  
  output$plot2 <- renderPlotly({
    
    filtered_df <- chart_df %>%
      filter(Group %in% input$Group_selection) %>%
      filter()
    
    plot2 <- ggplot(data = filtered_df) +
      geom_col(mapping = aes(
        x = Group, 
        y = percentage, 
        fill = Group)) +
      labs(title = "Multitasking & Music Effect", x = "Group", y = "Percentage %", color = Group) +
      scale_fill_brewer(palette = "Pastel1")
    return(plot2)
  })
} 

