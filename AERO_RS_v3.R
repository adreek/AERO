library(shiny)
library(shinythemes)
library(readr)
library(markdown)
library(rsconnect)
library(dplyr)
library(shinydashboard)
library(shinyWidgets)
library(ggplot2)
library(tidyr)
library(reticulate)


py_install("joblib", pip=FALSE)
py_install("numpy", pip=FALSE)
py_install("pandas", pip=FALSE)
py_install("scikit-learn==1.1.3", pip=FALSE)

ui <- fluidPage(
  theme = shinytheme("flatly"),
  navbarPage(
    "AERO",
    tabPanel(
      "Model",
      sidebarLayout(
        sidebarPanel(
          HTML("<h4><b>Patient Information</b></h4>"),
          selectInput("sex",
                      label = "Patient sex",
                      c("Male" = 0, "Female" = "1")
          ),
          numericInput(inputId = "age", "Age (months)", value = 12),
          HTML("<h4><b>Ultrasound findings</b></h4>"),
          selectInput("lat",
                      label = "Kidney Laterality",
                      c("Left" = 0, "Right" = "1")
          ),
          numericInput(inputId = "APD", "Anteroposterior diameter (mm)", value = 10),
          numericInput(inputId = "length", "Kidney Length (mm)", value = 75),
          sliderInput(inputId = "sfu", "SFU Grade (0-4)", value = 3, min = 0, max = 4),
          actionButton("submitbutton",
                       "Determine",
                       class = "btn btn-primary"
          ),
        ),
        mainPanel(
          plotOutput("showtrees"),
          htmlOutput("diagnosis"),
          htmlOutput("disc")
        ),
      )
    ),
    tabPanel("About", div(includeMarkdown("about.md"), align = "justify"))
  )
)

server <- function(input, output) {
  output$showtrees <- renderPlot(
    if (input$submitbutton > 0) {
      joblib <- import("joblib")
      np <- import("numpy")
      
      model <- joblib$load("AERO.pkl")
      input_values <- data.frame("Age (months)" <- input$age, "Sex" <- input$sex, "Kidney Laterality" <- input$lat, "Kidney Length" <- input$length, "APD" <- input$APD, "SFU Grade" <- input$sfu)
      df <- c(model$predict_proba(input_values))
      
      barplot(df,
              col = c("darkblue", "pink", "darkred"), xlim = c(0.2, 3.4), ylim = c(0, 1),
              xlab = "Risk of Obstruction", ylab = "% of Trees", main = "Predicted T 1/2 Washout",
              names.arg = c("< 20 min", "20 min - 60 min ", "> 60 min"),
              cex.lab = 1.2, cex.axis = 1.2, cex.main = 1.2, cex.names = 1.2
      )
    }
  )
  output$diagnosis <- renderText(if (input$submitbutton > 0) {
    joblib <- import("joblib")
    np <- import("numpy")
    
    model <- joblib$load("AERO.pkl")
    input_values <- data.frame("Age (months)" <- input$age, "Sex" <- input$sex, "Kidney Laterality" <- input$lat, "Kidney Length" <- input$length, "APD" <- input$APD, "SFU Grade" <- input$sfu)
    prediction <- model$predict(input_values)
    
    if (prediction == 0) {
      paste0("There is a <b>low risk</b> of obstruction. (T 1/2 < 20 min).<br>")
    } else if (prediction == 1) {
      paste0("There is an <b>elevated risk</b> of obstruction. (20 < T 1/2 < 60 min).<br>")
    } else if (prediction == 2) {
      paste0("There is a <b>high risk</b> of obstruction. (T 1/2 > 60 min).<br>")
    }
  })
  
  output$disc <- renderText(
    if (input$submitbutton > 0) {{ " <br> More information can be found under <b> About </b>.
    <br> <br <br>
    <br> <b> Disclaimer </b> <br> This web application does not provide medical advice.
    Access to general information is provided for educational purposes only. Content is not recommended or endorsed
    by any doctor or healthcare provider. The application provided is not a substitute for medical or professional
    care, virtual care, consultation or the advice of your healthcare provider. You are liable or responsible for any advice,
    course of treatment, diagnosis or any other information, services or product obtained through this web application.
    </h5>" }}
  )
}

shinyApp(ui, server)
