# Libraries
library(shiny)
library(shinyalert)
library(shinyStorePlus) #package used to s

# Define UI
ui <- fluidPage(
  initStore(),
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
  
  # Initialize reactive list
  reactiveList <- reactiveVal(list())
  
  # Observe dropdown change
  observeEvent(input$dropdown, {
    # Append value to the list
    currentList <- reactiveList()
    currentList <- c(currentList, input$dropdown)
    reactiveList(currentList)
    
    # Show popup notification
    shinyalert(title = "Notification", 
               text = paste0("Value '", input$dropdown, "' appended to the list!"), 
               type = "info")
  })
  
  # Display the reactive list
  output$displayList <- renderPrint({
    reactiveList()
  })
  
  appid = "application31" #random number selected, just needs an appId to work
  setupStorage(appId = appid,inputs = TRUE, outputs = FALSE)
    #setting output=TRUE results in reactive object that cannot be amended
}

# Run the app
shinyApp(ui, server)
