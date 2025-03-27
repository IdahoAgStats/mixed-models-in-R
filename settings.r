
# code from https://www.r-causal.org/


# options(
  # set default colors in ggplot2 to colorblind-friendly
  # Okabe-Ito and Viridis palettes
  # ggplot2.discrete.colour = ggokabeito::palette_okabe_ito(aesthetics = "colour", order = 1:9),
  # ggplot2.discrete.fill = ggokabeito::palette_okabe_ito(aesthetics = "colour", order = 1:9),
  # ggplot2.discrete.colour = harrypotter::hp(10, option = "Always"),
  # ggplot2.discrete.fill = harrypotter::hp(10, option = "Always"),
  # ggplot2.continuous.colour = "viridis",
  # ggplot2.continuous.fill = "viridis",
  # set theme font and size
  # book.base_family = "sans",
  # book.base_size = 14
# )

library(ggplot2)
library(viridis)
library(ggsci)
library(RColorBrewer)
library(scales)

options(
  ggplot2.discrete.color = viridis_pal(option = "D")(5),  # Discrete colors
  ggplot2.discrete.fill = viridis_pal(option = "D")(5),
  ggplot2.continuous.color = scale_color_viridis_c(),
  ggplot2.continuous.fill = scale_fill_viridis_c(),
  # set theme font and size
  book.base_family = "sans",
  book.base_size = 14
)

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