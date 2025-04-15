
# code from https://www.r-causal.org/

library(ggplot2)
library(viridis); library(scales)

### Set ggplot defaults

options(
  ggplot2.discrete.color = viridis_pal(option = "C")(8),  # Discrete colors
  ggplot2.discrete.fill = viridis_pal(option = "D", alpha=0.6)(8),
  ggplot2.continuous.color = scale_color_viridis_c(),
  ggplot2.continuous.fill = scale_fill_viridis_c(),
  #ggplot2.discrete.colour = harrypotter::hp(10, option = "Always"),
  #ggplot2.discrete.fill = harrypotter::hp(10, option = "Always"),
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

## Set Base blotting defaults

base_plot_color = '#b0f4f0'
cex_lab = 1.8
cex_axis = 1.5

