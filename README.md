# 📊 Campus Mental Health Insights Dashboard

> **Live Interactive App:** [👉 Click Here to Explore my Live Dashboard 👈](https://nngocminhchau0103.shinyapps.io/Jeni_Self_Project/)

## 🎯 Project Overview
I built this interactive dashboard to make sense of a campus mental health survey. Instead of just looking at raw case counts, I wanted to see how student mental health trends actually shift when you break things down by faculty groupings, academic performance (CGPA), and whether students are getting real support.

One of the biggest challenges of this project was data cleaning. The raw survey data had over 40 different, messy ways that students had typed in their major names. I wrote an R pipeline using regex string matching to standardize all of that chaos into 7 clean faculty buckets so I could build accurate visualizations.

## 🛠️ Tools & Skills I Used
* **Language:** R
* **Data Wrangling:** `tidyverse` (`dplyr`, `stringr` for regex cleaning)
* **Plots:** `ggplot2` (using stacked bar charts and custom palettes)
* **App Deployment:** `shiny` & `shinydashboard` hosted via ShinyApps.io
* **Data Fixes:** Handled text standardization and recognized small-sample size limitations (like filtering out misleading data from small senior-year samples).

---

## 💡 What the Data Actually Tells Us

When I loaded the cleaned data into my dashboard and started filtering through the graphs, three major trends jumped out at me:

### 1. The High-Performance Strain (Anxiety vs. CGPA)
* There is a steep, step-ladder trend where anxiety climbs significantly higher for students with top academic performance. The pressure to maintain a high CGPA seems to strongly correlate with self-reported anxiety.

### 2. Disproportionate Faculty Risks (Depression vs. Faculty)
* Law and Humanities & Social Sciences students experienced the highest proportional rates of depression. This was a really interesting finding, because technical majors like Computing & Tech actually had a higher overall *volume* of cases, but a smaller percentage overall when compared to the size of their program.

### 3. Volume and Help-Seeking Gaps
* Humanities & Social Sciences, Engineering, and Computing & Tech possessed the highest absolute counts of depressed students. Interestingly, the data shows that students in these specific faculties tend to seek treatment much more often, whereas faculties with lower counts of depressed students saw almost zero help-seeking behavior.

---

## 🏗️ How this Repository is Organized
* `data_cleaning.R`: The initial script I wrote to ingest the raw survey data, run string matching to fix the faculty names, and export the polished data.
* `student_mental_health_clean.csv`: The cleaned dataset I used to feed the Shiny app.
* `app.R`: The complete code for the user interface and back-end logic running the dashboard.