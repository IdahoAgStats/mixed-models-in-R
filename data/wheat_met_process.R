
library(dplyr); library(tidyr)

mydata <- read.csv("data/MET_wheat.csv") |> 
  select(site, year, siteyear, plot, bloc, Ptrt, Inoc, Cv, PT1, PT2, PT3) |> 
  filter(siteyear == "Colfax2010") |> 
  select(-site, -year, -siteyear) |> 
  pivot_longer(cols = PT1:PT3, names_to = "time", values_to = "P_leaf") 

write.csv(mydata, "data/split_split_repeated.csv", row.names = FALSE)

# main plot: Ptrt (phosphorus treatment)
# split-plot: Inoc (inoculation)
# split-split plot: Cv (cultivar)