library(shiny)
library(shinydashboard)
#Create the title
titledata <- tags$label(tags$img(src = "dummylogo.jpg", height = '60', width = '65'),
                        tags$b("Company Name"))


ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
                    @import url('my-font.url');
                    .col-sm-6 {
                    width:100%;
                    }
                    #run{
                    background-color:green;
                    color:white;
                    }
                    
                    "
                    
))),
  
  fluidRow(style="color:white; background-color:black;",
    
    column(6,offset = 4,
           titlePanel(titledata)),
    column(6)
  ),
  fluidRow(
    column(4),
    column(4, offset = 5,
           h3(tags$b("MY TESTING APP"))),
    column(4)
  ),
  
  fluidRow(
    br()
  ),
  
  fluidRow(
  column(12,
  tabBox(
    
    # The id lets us use input$tabset1 on the server to find the current tab
    id = "tabset1",
    tabPanel("Mode 1", fluidRow(
      
      column(4, fileInput("folder", h3("Select Folder")), submitButton("Set Working Directory")
             
      ),
      
      column(4, radioButtons("runpar", h3("Run Parameters"), 
                             choices = list("True" = 1, "False" = 2), selected = 1)
             
      ),
      
      column(4, fileInput("file1", h3("Select Input CSV File"),
                          accept = c("text/csv","text/comma-separated-values,text/plain",
                                     ".csv"))
             
      )
      
    ),
    
    fluidRow(
      
      column(4, dateRangeInput("dates", h3("Select Date Range"))
             
      ),
      
      column(4,  textInput('vec1', h3("x Data File"), "0,1,2")
             
      ),
      
      column(4,  textInput("symbol", h3("Symbol"))
             
      )
      
    ),
    
    fluidRow(
      
      column(4, textInput("trainwin", h3("Train Window"))
             
      ),
      
      column(4,textInput("retrainwin", h3("Retrain Window"))
             
      ),
      
      column(4, textInput("target", h3("Target"))
             
      )
      
    ),
    br(),
    
    fluidRow(
      column(6),
      column(6, offset = 5,  downloadButton("run","Run Analysis"))
    )
    
    
    ),
    tabPanel("Mode 2", "Tab content 2"),
    tabPanel("Instructions", "List of Instructions"))
  ))
  
  
)

server <- function(input, output) {
  
  fileInput <- reactive(
    {
      infile <- input$file1
      if (is.null(infile)) {
        # User has not uploaded a file yet
        return()
      }
      read.csv(infile$datapath)
    }
    
  )
  
  output$run <- downloadHandler(
    filename = function() {
      paste("outputdata", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(fileInput(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)