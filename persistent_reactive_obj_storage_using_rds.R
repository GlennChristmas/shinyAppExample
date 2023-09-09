# Libraries
library(shiny)
library(shinyalert)

# Define UI
ui <- fluidPage(
  useShinyalert(),
  titlePanel("Dropdown Appending App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dropdown", 
                  "Choose a value:", 
                  choices = c("A", "B", "C", "D"))
    ),
    mainPanel(
      verbatimTextOutput("displayList")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Check if data.RDS exists to initialize the reactive list
  if (file.exists("data.RDS")) {
    data_list <- readRDS("data.RDS")
  } else {
    data_list <- list()
  }
  
  reactiveList <- reactiveVal(data_list)
  
  # Observe dropdown change
  observeEvent(input$dropdown, {
    # Append value to the list
    currentList <- reactiveList()
    currentList <- c(currentList, input$dropdown)
    reactiveList(currentList)
    
    # Save the list to a file
    saveRDS(currentList, "data.RDS")
    
    # Show popup notification
    shinyalert(title = "Notification", 
               text = paste0("Value '", input$dropdown, "' appended to the list!"), 
               type = "info")
  })
  
  # Display the reactive list
  output$displayList <- renderPrint({
    reactiveList()
  })
}

# Run the app
shinyApp(ui, server)
