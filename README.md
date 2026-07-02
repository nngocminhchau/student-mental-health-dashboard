# 📊 Campus Mental Health Insights Dashboard
> **Live Interactive Web Application:** [👉 Click Here to Explore the Live Dashboard 👈](https://nngocminhchau0103.shinyapps.io/Jeni_Self_Project/)

## 🎯 Project Overview
This project transforms raw, unformatted campus survey data into an interactive Business Intelligence (BI) dashboard using **R** and **R Shiny**. The goal of this application is to move beyond simple case counts and analyze the institutional, academic, and clinical support dimensions of student mental health.

By restructuring messy academic text data into standardized faculty categories, this dashboard exposes critical gaps in campus support systems and evaluates how performance pressures correlate with anxiety.

## 🛠️ Tech Stack & Skills Demonstrated
* **Language:** R
* **Data Manipulation:** `tidyverse` (`dplyr`, `stringr`, `purrr`)
* **Data Visualization:** `ggplot2` (Proportional filled bar charts, custom palettes)
* **Web Deployment:** `shiny`, `shinydashboard`, Posit ShinyApps.io cloud hosting
* **Data Cleaning Techniques:** Regex string matching (`str_detect`), text standardization, handling small-sample data traps, and factor ordering.

---

## 💡 Key Analytical Insights

### 1. The High-Performance Strain (Anxiety vs. CGPA)
* **Finding:** The data exhibits a distinct step-ladder trend where anxiety prevalence systematically rises alongside academic achievement. 
* **Insight:** Anxiety peaks among students in the highest CGPA tier (3.50 - 4.00), suggesting that institutional performance pressures heavily correlate with mental health strain.

### 2. Disproportionate Faculty Risks (Depression vs. Faculty)
* **Finding:** While technical majors (Computing & Tech) represent the highest *absolute volume* of students surveyed, fields like **Law** and **Humanities & Social Sciences** show significantly higher *proportional* rates of depression.
* **Insight:** Looking only at total counts masks the underlying vulnerability of smaller, reading-heavy, or high-stress specialized faculties.

### 3. The Clinical Help-Seeking Chasm (The Treatment Gap)
* **Finding:** Across all faculties, over 70% of students actively experiencing severe depressive symptoms report that they are **not** currently receiving professional treatment.
* **Insight:** This uncovers a profound institutional support gap, showing that early identification is only half the battle—connecting struggling students to campus clinical resources remains the primary hurdle.

---

## 🏗️ Data Pipeline & Repository Structure
1. `data_cleaning.R`: The foundational pipeline that ingests raw data, uses regex to map over 40 distinct text strings into 7 clean Faculty groups, and exports a factor-mapped database.
2. `student_mental_health_clean.csv`: The polished, lightweight dataset optimized for quick server rendering.
3. `app.R`: The reactive UI and back-end engine powering the dynamic dashboard.