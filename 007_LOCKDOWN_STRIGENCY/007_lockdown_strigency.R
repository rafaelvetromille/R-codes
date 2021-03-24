## packages
library(tidyverse)
library(magrittr)
library(vroom)
library(ggsci)
library(showtext)
library(ggplot2)


## load fonts
font_add_google("Poppins", "Poppins")
font_add_google("Roboto Mono", "Roboto Mono")
showtext_auto()

stringency <- vroom::vroom(file = 'data/covid-stringency-index.csv') %>%
  janitor::clean_names() %>%
  dplyr::mutate(quarter = lubridate::quarter(day, with_year = TRUE), .keep = "unused") %>%
  dplyr::group_by(code, quarter) %>%
  dplyr::summarise(avg_stringency = mean(stringency_index, na.rm = TRUE)) %>%
  dplyr::ungroup() %>%
  dplyr::group_by(code) %>%
  dplyr::mutate(change_stringency = coalesce(avg_stringency - lag(avg_stringency), avg_stringency))

stringency

gdp <- vroom::vroom(file = "data/DP_LIVE_23032021233504108.csv") %>%
  janitor::clean_names() %>%
  dplyr::filter(frequency == "Q" & measure == "PC_CHGPP") %>%
  dplyr::mutate(time = zoo::as.yearqtr(time, format = "%Y-Q%q")) %>%
  dplyr::filter(time >= "2020 Q1") %>%
  dplyr::select(code = location, quarter = time, gdp_growth = value) %>%
  dplyr::mutate(quarter = lubridate::quarter(quarter, with_year = TRUE))

gdp

base <- stringency %>%
  dplyr::inner_join(gdp, by = c("code", "quarter")) %>%
  dplyr::mutate(quarter = as.character(quarter))

base

ggplot(data = base, aes(x = change_stringency, y = gdp_growth, color = quarter)) +
  geom_point(shape = "diamond", size = 3) +
  geom_smooth(se = FALSE, method = lm, fullrange = TRUE) +
  theme_bw() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  theme_light(base_size = 18, base_family = "Poppins") +
  theme(
    axis.title = element_text(size = 12),
    axis.text.x = element_text(family = "Roboto Mono", size = 12),
    axis.text.y = element_text(family = "Roboto Mono", size = 12),
    plot.caption = element_text(size = 9, color = "gray50"),
    panel.grid = element_blank()
  ) +
  labs(x = "Change in avg. lockdown stringency (q/q)",
       y = "GDP Growth (%q/q)") +
  ggpubr::stat_regline_equation(label.x = c(60,26,3,25),
                                label.y = c(-5,-18,12,5),
                                aes(x = change_stringency,
                                    y = gdp_growth,
                                    color = quarter,
                                    label = ..eq.label..)) +
  scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07", "#ff00ff"))



df <- mtcars %>%
  as_tibble() %>%
  dplyr::mutate(cyl = as.character(cyl))

df
b <- ggplot(df, aes(x = wt, y = mpg))

b + geom_point(aes(color = cyl, shape = cyl)) +
  geom_smooth(aes(color = cyl), method = lm,
              se = FALSE, fullrange = TRUE)+
  scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))
