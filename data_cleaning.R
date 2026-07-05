# 1. Load data
df <- read.csv("Student Mental health.csv", header = TRUE)
# 2. Do all cleaning:
# fix col names

library(tidyverse)
df_cleaned <- df %>%
  rename(
    timestamp = Timestamp,
    gender = Choose.your.gender,
    age = Age,
    course = What.is.your.course.,
    study_year = Your.current.year.of.Study,
    cgpa = What.is.your.CGPA.,
    marital.status = Marital.status,
    depression = Do.you.have.Depression.,
    anxiety = Do.you.have.Anxiety.,
    panic_attack = Do.you.have.Panic.attack.,
    treatment = Did.you.seek.any.specialist.for.a.treatment.
    )

# change categorical cols to factors

df_cleaned <- df_cleaned %>%
  mutate(
    gender         = as.factor(gender),
    study_year     = as.factor(study_year),
    cgpa           = as.factor(cgpa),
    marital.status = as.factor(marital.status),
    depression     = as.factor(depression),
    anxiety        = as.factor(anxiety),
    panic_attack   = as.factor(panic_attack),
    treatment      = as.factor(treatment)
  )
summary(df_cleaned)

# fix values in (study_year / cgpa) to make them all consistent

df_cleaned <- df_cleaned %>%
  mutate(
    # str_trim removes any accidental trailing spaces
    # str_to_title changes "year 1" -> "Year 1"
    study_year = str_to_title(str_trim(study_year)),
    cgpa       = str_trim(cgpa),
    # Now they match perfectly, convert it to factors
    study_year = as.factor(study_year),
    cgpa       = as.factor(cgpa)
  )

# Clean missing values

df_cleaned %>%
  summarise(across(everything(), ~ sum(is.na(.))))
df_cleaned <- df_cleaned %>% 
  group_by(study_year) %>% 
  mutate(age = ifelse(is.na(age), median(age, na.rm = TRUE), age)) %>% 
  ungroup() # Always ungroup after group_by

# Clean "course" col to make it more simple to turn to factors
# First categorise it into groups by checking the unique entries
unique(df_cleaned$course)

df_cleaned <- df_cleaned %>%
  mutate(
    course_cleaned  = str_to_lower(str_trim(course)),
    course_category = case_when(
      str_detect(course_cleaned, "comp|bcs|it|bit|cts|dat") ~ "Computing & Tech",
      str_detect(course_cleaned, "eng|koe") ~ "Engineering",
      str_detect(course_cleaned, "bus|econ|acc|fin|bank|kenms|human resources|enm") ~ "Business & Finance",
      str_detect(course_cleaned, "nurse|med|marine|bio|radiography|kop|mhsc|mathemathics|diploma nursing|nursing") ~ "Sciences & Health",
      str_detect(course_cleaned, "law") ~ "Law",
      str_detect(course_cleaned, "islam|pendidikan|fiqh|usuluddin|irkhs|kirkhs|taasl") ~ "Islamic Studies",
      str_detect(course_cleaned, "psych|human|comn|benl|malcom|ala|tesl|communication") ~ "Humanities & Social Sciences",
      TRUE ~ "Other / Unspecified"
      ),
    course_category = as.factor(course_category)
  )

# check if we got everything categorised 
table(df_cleaned$course_category)

# Defensive code to clean logic columns to build charts and filters
df_cleaned <- df_cleaned %>% 
  mutate(
    depression    = factor(str_to_title(str_trim(depression)), levels = c("No", "Yes")),
    anxiety       = factor(str_to_title(str_trim(anxiety)), levels = c("No", "Yes")),
    panic_attacks = factor(str_to_title(str_trim(panic_attack)), levels = c("No", "Yes")),
    treatment     = factor(str_to_title(str_trim(treatment)), levels = c("No", "Yes"))
  )
# 3. Freeze work into a physical file
write_csv(df_cleaned, "student_mental_health_clean.csv")

# 4. Plot
# --- PLOT 1: DEPRESSION BY FACULTY ---

ggplot(data = df_cleaned, aes(x = course_category, fill = depression)) +
  # position = "fill" automatically converts counts into percentages (0% to 100%)
  geom_bar(position = "fill", width = 0.7) + 
  
  # Flips the graph horizontally so long category names are easy to read
  coord_flip() + 
  
  # Professional color palettes (Green/Blue for No, Red/Orange for Yes)
  scale_fill_brewer(palette = "Set2") +
  
  # Format the x-axis numbers as clean percentages (e.g., 50%)
  scale_y_continuous(labels = scales::percent) +
  
  # Clean, minimal academic theme
  theme_minimal(base_size = 12) +
  
  # Titles and descriptive labels
  labs(
    title = "Prevalence of Depression Across University Faculties",
    subtitle = "Proportional distribution based on self-reported campus survey data",
    x = "Faculty / Course Category",
    y = "Percentage of Students surveyed",
    fill = "Diagnosed/Experiencing\nDepression?"
  ) +
  
  # Tweak theme for presentation layout
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )


# --- PLOT 2: ANXIETY BY CGPA RANGE ---

ggplot(data = df_cleaned, aes(x = cgpa, fill = anxiety)) +
  geom_bar(position = "fill", width = 0.6) + 
  scale_fill_brewer(palette = "Pastel1") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Anxiety Distribution Across CGPA Ranges",
    subtitle = "Analyzing the relationship between academic performance and anxiety",
    x = "Self-Reported CGPA Range",
    y = "Percentage of Students",
    fill = "Experiencing\nAnxiety?"
  ) +
  theme(plot.title = element_text(face = "bold"))


# --- PLOT 3: PANIC ATTACKS BY YEAR OF STUDY ---

ggplot(data = df_cleaned, aes(x = study_year, fill = panic_attacks)) +
  geom_bar(position = "fill", width = 0.6) + 
  scale_fill_brewer(palette = "Accent") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Panic Attack Prevalence by Year of Study",
    subtitle = "Tracking student mental health tracking across academic stages",
    x = "Year of Study",
    y = "Percentage of Students",
    fill = "Panic Attacks?"
  ) +
  theme(plot.title = element_text(face = "bold"))


# --- PLOT 4: TREATMENT SEEKING AMONG DEPRESSED STUDENTS ---

df_cleaned %>% 
  # Filter to only look at students who answered "Yes" to depression
  filter(depression == "Yes") %>% 
  
  ggplot(aes(x = course_category, fill = treatment)) +
  geom_bar(position = "stack", width = 0.6) + # "stack" shows the actual counts clearly
  scale_fill_manual(
    values = c("No" = "#E41A1C", "Yes" = "#377EB8"), 
    labels = c("Not Seeking Help", "Seeking Treatment")
  ) +
  coord_flip() +
  theme_minimal(base_size = 12) +
  labs(
    title = "Are Depressed Students Seeking Professional Help?",
    subtitle = "Analysis restricted strictly to students self-reporting depression",
    x = "Faculty / Course Category",
    y = "Number of Depressed Students (Count)",
    fill = "Treatment Status"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank()
  )
