
library(readxl)
library(dplyr); library(tidyr)

salary <- read_excel("C:/Users/jpiaskowski/Downloads/AnnualEmployeeSalary.xlsx") |> 
  janitor::clean_names()

colSums(is.na(salary))

# agencies = unique(salary$agy_title)

unis <- grepl("University|College", salary$agy_title, perl = TRUE, ignore.case = TRUE)
# table(unis)

#check <- salary[unis,] |> count(agy_title, name) |> filter(n > 1) 

salary_long <- salary[unis,] |> 
  group_by(agy_title, name) |> 
  summarise(across(where(is.numeric), sum)) |> 
  mutate(id = paste("person", 1:n())) |> 
  ungroup() |> 
  mutate(across(where(is.numeric), ~na_if(., 0))) |> 
  pivot_longer(sal2019:sal2023, names_to = "year", values_to = "salary") |> drop_na() |> 
  filter(salary > 25e3) |> 
  mutate(year = as.numeric(substr(year, 4, 7))) |> 
  group_by(agy_title, name) |> mutate(n = n()) |> ungroup() |> 
  filter(n > 3)

# table(salary_long$n)
# sort(table(salary_long$agy_title))

salary_final <- select(salary_long, -name, -n) |> rename(agency = agy_title) |> 
  mutate(year0 = year - 2019)

# write.csv(salary_final, "WA_higher_ed_salary.csv", row.names = FALSE)


library(lme4)

# hist(salary_final$salary)
# hist(log(salary_final$salary))

m1 <- lmer(log(salary) ~ factor(year) + (1|agency/id), 
           data = salary_final, REML = FALSE)
# plot(m1, main = "random int")
# fits! 

m2 <- lmer(log(salary) ~ factor(year) + (year0|agency/id), 
           data = salary_final, REML = FALSE)
# fits!
# anova(m1, m2) # m2 fits better

m3 <- lmer(log(salary) ~ factor(year) + (year0|agency/id), 
           data = salary_final, REML = TRUE)
# did not fit

m4 <- update(m3) # still does not fully converge
# plot(m2, main = "random slopes")

save(m1, salary_final, file = "data/salary_models.RData")
