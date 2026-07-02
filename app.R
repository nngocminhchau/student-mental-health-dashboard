options(shiny.useragg = FALSE)
library(shiny)
library(shinydashboard)
library(tidyverse)

# ==============================================================================
# 1. DATA INITIALIZATION
# ==============================================================================
df_clean <- read_csv("student_mental_health_clean.csv") %>% 
  mutate(
    across(c(course_category, depression, anxiety, panic_attack, treatment), as.factor)
  )

# ==============================================================================
# 2. USER INTERFACE (Front-End)
# ==============================================================================
ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(title = "Campus Mental Health"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Analytics Dashboard", tabName = "dashboard", icon = icon("dashboard"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              
              # ROW 1: INTERACTIVE CONTROL PANEL
              fluidRow(
                box(
                  title = "🎯 Global Filters", width = 12, status = "primary", solidHeader = TRUE,
                  column(width = 6,
                         selectInput("faculty_filter", "Filter by Faculty / Course Category:",
                                     choices = c("All Faculties", levels(df_clean$course_category)),
                                     selected = "All Faculties")
                  ),
                  column(width = 6,
                         selectInput("deep_dive_metric", "Select Deep Dive Graph:",
                                     choices = c("Anxiety Distribution by CGPA" = "cgpa", 
                                                 "Treatment Seeking Status" = "treatment"),
                                     selected = "cgpa")
                  )
                )
              ),
              
              # ROW 2: THE HIGH-IMPACT VISUALIZATIONS
              fluidRow(
                # Left Side: The main baseline chart (Faculty breakdown)
                box(
                  title = "Faculty Overview", width = 6, status = "info", solidHeader = TRUE,
                  plotOutput("facultyPlot", height = "400px")
                ),
                
                # Right Side: The Dynamic Deep Dive chart changes based on the dropdown choice
                box(
                  title = "Interactive Deep Dive", width = 6, status = "success", solidHeader = TRUE,
                  plotOutput("deepDivePlot", height = "400px")
                )
              )
      )
    )
  )
)

# ==============================================================================
# 3. SERVER LOGIC (Back-End)
# ==============================================================================
server <- function(input, output) {
  
  # Reactive data: Filters rows automatically based on the user's faculty selection
  filtered_data <- reactive({
    data <- df_clean
    if (input$faculty_filter != "All Faculties") {
      data <- data %>% filter(course_category == input$faculty_filter)
    }
    return(data)
  })
  
  # --- CHART 1: FACULTY OVERVIEW PLOT ---
  output$facultyPlot <- renderPlot({
    ggplot(data = df_clean, aes(x = course_category, fill = depression)) +
      geom_bar(position = "fill", width = 0.7) + 
      coord_flip() + 
      scale_fill_brewer(palette = "Set2") +
      scale_y_continuous(labels = scales::percent) +
      theme_minimal(base_size = 13) +
      labs(x = "Faculty Group", y = "Proportion", fill = "Depression?") +
      theme(legend.position = "top", plot.title = element_text(face = "bold"))
  })
  
  # --- CHART 2: DYNAMIC DEEP DIVE PLOT ---
  output$deepDivePlot <- renderPlot({
    # Fetch the dynamically filtered data
    current_data <- filtered_data()
    
    if (input$deep_dive_metric == "cgpa") {
      # Render the CGPA Ladder chart
      ggplot(data = current_data, aes(x = cgpa, fill = anxiety)) +
        geom_bar(position = "fill", width = 0.6) + 
        scale_fill_brewer(palette = "Pastel1") +
        scale_y_continuous(labels = scales::percent) +
        theme_minimal(base_size = 13) +
        labs(x = "Self-Reported CGPA Range", y = "Proportion", fill = "Anxiety?") +
        theme(legend.position = "top")
      
    } else if (input$deep_dive_metric == "treatment") {
      # Render the Treatment Help-Seeking Gap chart
      current_data %>% 
        filter(depression == "Yes") %>% 
        ggplot(aes(x = course_category, fill = treatment)) +
        geom_bar(position = "stack", width = 0.6) + 
        scale_fill_manual(values = c("No" = "#E41A1C", "Yes" = "#377EB8"), 
                          labels = c("Not Seeking Help", "Seeking Treatment")) +
        coord_flip() +
        theme_minimal(base_size = 13) +
        labs(x = "Faculty Group", y = "Count of Depressed Students", fill = "Status") +
        theme(legend.position = "top")
    }
  })
}

# ==============================================================================
# 4. EXECUTION
# ==============================================================================
shinyApp(ui, server)