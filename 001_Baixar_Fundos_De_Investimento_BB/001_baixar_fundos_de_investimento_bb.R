# R CODES ----
# 👉 CODE 001: Baixar Fundos de Investimento do Site do BB ----

# -- 1. Carregar pacotes
library(rvest)
library(tidyverse)
library(janitor)

# -- 2. Salvar a URL da página (usar encurtador de url)
url <- "https://bit.ly/3rrMoPP"

# -- 3. Ler a página do site
tabela <- read_html(url) %>%

  html_table()

# -- 4. Tratamento de Dados
df <- tabela %>%

  map_dfr(.f = ~ janitor::row_to_names(dat = .x, row_number = 1) %>%

        tibble::as_tibble() %>%

        dplyr::mutate(tipo = names(.) %>% magrittr::extract(1), .before = everything()) %>%

        janitor::clean_names(numerals = "left") %>%

        dplyr::rename(fundo = 2) %>%

        dplyr::rename_all(.funs = funs(str_remove_all(string = ., pattern = "\\_r"))) %>%

        dplyr::mutate(fundo = fundo %>% str_squish() %>% str_remove_all(pattern = " ?\\([0-9]\\)")) %>%

        dplyr::mutate(class = dia, .before = fundo) %>%

        dplyr::mutate(class = str_replace(class, "[[:digit:]]|\\-", NA_character_)) %>%

        tidyr::fill(class) %>%

        dplyr::mutate(class = replace(class, is.na(class), "Ações")) %>%

        dplyr::filter(class != fundo)) %>%

  dplyr::mutate(

    dplyr::across(

      .cols = c(dia:taxa_de_adm_aa, cota),

      .fns = parse_number, locale = locale(decimal_mark = ',')),

    dplyr::across(

      .cols = starts_with("data"),

      .fns = lubridate::dmy))

# -- 5. Solução de tratamento de dados oferecida por @clente

# Locale para datas e números em português
brasil <- locale(date_format = "%d/%m/%Y", decimal_mark = ",")

# Função para parsear uma tabela
parse_table <- . %>%

  html_table(FALSE) %>%

  as_tibble() %>%

  mutate(
    across(.fns = ~ifelse(row_number() == 2, paste(lag(.x), .x), .x)),
    categoria = ifelse(row_number() == 3, lag(X1), NA)
  ) %>%

  row_to_names(2) %>%

  rename(fundo = 1, categoria = 14) %>%

  set_names(str_remove, "\\(.*?\\)|R[$]") %>%

  clean_names(numerals = "middle") %>%

  mutate(tipo = ifelse(str_starts(cota, "[A-Z]"), cota, NA)) %>%

  fill(tipo, categoria) %>%

  replace_na(list(tipo = "Ações")) %>%

  mutate(across(.fns = str_squish)) %>%

  filter(tipo != cota) %>%

  relocate(categoria, tipo) %>%

  mutate(
    pl_medio_taxa_de_adm_aa = str_remove(pl_medio_taxa_de_adm_aa, "%"),

    categoria = ifelse(categoria == "Ações Fundo", "Ações", categoria)
  ) %>%

  type_convert(na = c("-", ""), locale = brasil) %>%

  mutate(pl_medio_taxa_de_adm_aa = pl_medio_taxa_de_adm_aa/100)

# Parsear as tabelas
"https://bit.ly/3rrMoPP" %>%
  read_html() %>%

  xml_find_all("//table") %>%

  map_dfr(parse_table) %>%

  glimpse(width = 70)


