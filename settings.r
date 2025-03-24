
# code from https://www.r-causal.org/


options(
  # set default colors in ggplot2 to colorblind-friendly
  # Okabe-Ito and Viridis palettes
  install.packages("ggokabeito"),
  #ggplot2.discrete.colour = ggokabeito::palette_okabe_ito(aesthetics = "colour", order = 1:9),
  #ggplot2.discrete.fill = ggokabeito::palette_okabe_ito(aesthetics = "colour", order = 1:9),
  ggplot2.discrete.colour = harrypotter::hp(10, option = "Always"),
  ggplot2.discrete.fill = harrypotter::hp(10, option = "Always"),
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis",
  # set theme font and size
  book.base_family = "sans",
  book.base_size = 14
)

library(ggplot2)

# set default theme
theme_set(
  theme_minimal(
    base_size = getOption("book.base_size"),
    base_family = getOption("book.base_family")
  ) %+replace%
    theme(
      panel.grid.minor = element_blank(),
      legend.position = "bottom"
    )
)