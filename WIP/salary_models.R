


library(lme4)
library(merTools)

hist(salary_final$salary)
hist(log(salary_final$salary))

m1 <- lmer(log(salary) ~ factor(year) + (1|agency/id), 
           data = salary_final, REML = FALSE)
plot(m1, main = "random int")

m2 <- lmer(log(salary) ~ factor(year) + (year0|agency/id), 
           data = salary_final, REML = FALSE)
plot(m2, main = "random slopes")

save(m1, m2, file = "data/salary_models.RData")

anova(m1, m2)

performance::check_model(m2) # takes forever


VarCorr(m2)

# this runs out of memory
#complex_random_effects <- tidy(m2, effects = "ran_vals")