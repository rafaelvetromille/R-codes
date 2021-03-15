# R CODES ----
# 👉 CODE 002: Baixar dados do site FGV DADOS c/ Rselenium ----

#-- Load packages
library(RSelenium)
library(tidyverse)
library(glue)

#-- Setting chromeOptions
eCaps <- list(chromeOptions = list(
  args = c('--headless', '--disable-gpu', '--window-size=1280,800')))

#-- Remote driver
rD <- rsDriver(port = 4442L, browser = "chrome",
               extraCapabilities = eCaps)

#-- Navigate to the website
remDr <- rD$client

remDr$navigate("http://www14.fgv.br/fgvdados20/default.aspx?Convidado=S")
  webElem <- NULL
while(is.null(webElem)){
  webElem <- tryCatch({remDr$findElement(using = 'id', value = "dlsCatalogoFixo_imbOpNivelUm_2")},
                      error = function(e){NULL})
  }

#-- Find and click elements
remDr$findElement("id", "dlsCatalogoFixo_imbOpNivelUm_2")$clickElement()
webElem <- NULL
while(is.null(webElem)){
  webElem <- tryCatch({remDr$findElement(using = 'id', value = "cphConsulta_rbtSerieHistorica")},
                      error = function(e){NULL})
}

remDr$findElement("id", "cphConsulta_rbtSerieHistorica")$clickElement()

remDr$findElement("id", "dlsCatalogoFixo_imbOpNivelDois_3")$clickElement()
webElem <- NULL
while(is.null(webElem)){
  webElem <- tryCatch({remDr$findElement(using = 'id', value = "dlsMovelCorrente_imbIncluiItem_0")},
                      error = function(e){NULL})
}


#-- Select series
for (i in 1:6) {
  remDr$findElement("id", glue("dlsMovelCorrente_imbIncluiItem_", {i-1}))$clickElement()
  remDr$findElement("id", glue("dlsMovelCorrente_imbIncluiItem_", {i-1}))$clickElement()
}

#-- Close Button
remDr$findElement("id", "butCatalogoMovelFecha")$clickElement()
webElem <- NULL
while(is.null(webElem)){
  webElem <- tryCatch({remDr$findElement(using = 'id', value = "cphConsulta_dlsSerie_chkSerieEscolhida_0")},
                      error = function(e){NULL})
}

#-- View results
remDr$findElement("id", "cphConsulta_butVisualizarResultado")$clickElement()
Sys.sleep(1)

#-- Open results in a new tab
remDr$navigate("http://www14.fgv.br/fgvdados20/VisualizaConsultaFrame.aspx")

buscarButton <- remDr$findElement(using = 'xpath', '//*[@id="xgdvConsulta_DXMainTable"]/tbody')

teste <- buscarButton$getElementText()

teste1 <- teste %>%
  map(~str_split(.x, "\n")) %>%
  extract2(1) %>%
  extract2(1) %>%
  as_tibble()

#-- Data wrangling
df <- remDr$getPageSource()[[1]] %>%

  xml2::read_html() %>%

  xml2::xml_find_all("//table") %>%

  rvest::html_table(fill = TRUE) %>%

  magrittr::extract2(3) %>%

  dplyr::slice(-1) %>%

  janitor::remove_empty(which = c("cols")) %>%

  magrittr::set_colnames(.[1:ncol(.), 1]) %>%

  tidyr::drop_na() %>%

  dplyr::rename_all(~str_remove_all(.," ?\\(.*\\)")) %>%

  tibble::as_tibble() %>%

  dplyr::mutate(

    across(.fns = ~dplyr::na_if(.x, "-")),

    across(.cols = 1, .fns = ~lubridate::my(.x)),

    across(.cols = -1, .fns = ~readr::parse_number(.x, locale = locale(decimal_mark = ',')))

    )


# close browser
remDr$close()


# stop the selenium server
rD[["server"]]$stop()

# and delete it
rm(rD)


#-- Close browser
remDr$close()

#-- Close server
remDr$closeServer()
rD$server$stop()

#-- Keeping only data.frame
rm(eCaps, i, rD, remDr, webElem)
