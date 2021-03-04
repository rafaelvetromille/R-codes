# R CODES ----
# 👉 CODE 001: Baixar Fundos de Investimento do Site do BB ----

# -- 1. Carregar pacotes
library(rvest)
library(tidyverse)

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
