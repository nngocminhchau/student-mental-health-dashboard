# Campus Mental Health Dashboard

An interactive R Shiny web application designed to analyze student mental health survey data, mapping out institutional, academic, and support trends.

Live Application Link: https://nngocminhchau0103.shinyapps.io/Jeni_Self_Project/

## Project Overview
I built this interactive dashboard to look past basic case counts and find the deeper stories in campus mental health survey data. The application explores how student anxiety and depression move across different faculties, maps how academic performance (CGPA) correlates with stress, and identifies major gaps in help-seeking behavior.

One of the main challenges of this project was data cleaning. The raw survey data had over 40 distinct, unformatted variations of student major names. I built an R processing script using regex string matching to standardize all of that input into 7 clean faculty categories so I could visualize the data accurately.

## Key Insights From the Data

* **The High-Performance Strain:** There is a distinct step-ladder trend where anxiety systematically climbs for students with higher academic performance. Anxiety rates peak heavily within the top CGPA tier (3.50 - 4.00).
* **Disproportionate Faculty Risks:** Law and Humanities & Social Sciences students experienced the highest proportional rates of depression. Technical majors like Computing & Tech had a much higher volume of cases, but a lower percentage of depression rate overall.
* **Help-Seeking Behavior:** Humanities & Social Sciences, Engineering, and Computing & Tech possessed both the highest counts of depressed students and the highest rates of students actively seeking treatment. Conversely, faculties with smaller volumes of depressed students showed zero seeking-for-help behavior.

## Installation & Setup

To run this dashboard locally, clone the repository and run the application in your R environment:

```R
# 1. Clone the repository files into your working directory
# 2. Install the required R packages:
install.packages(c("shiny", "shinydashboard", "tidyverse"))

# 3. Open app.R and click 'Run App' or run:
shiny::runApp()