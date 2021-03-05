# R CODES ----
# 👉 CODE 002: Baixar dados do site FGV DADOS c/ Rselenium ----

#-- Load packages
library(RSelenium)
library(tidyverse)
library(glue)

#-- Setting chromeOptions
eCaps <- list(chromeOptions = list(
  args = c('--disable-gpu', '--window-size=1280,800')))

#-- Remote driver
rD <- rsDriver(port = 4445L, browser = "chrome",
               chromever = "88.0.4324.27",
               extraCapabilities = eCaps,
               verbose = FALSE)

#-- Navigate to the website
remDr <- rD$client
remDr$navigate("http://www14.fgv.br/fgvdados20/default.aspx?Convidado=S")


#-- Find and click elements
remDr$findElement("id", "dlsCatalogoFixo_imbOpNivelUm_2")$clickElement()
remDr$findElement("id", "cphConsulta_rbtSerieHistorica")$clickElement()
remDr$findElement("id", "dlsCatalogoFixo_imbOpNivelDois_3")$clickElement()

#-- Select series
for (i in 1:6) {
  remDr$findElement("id", glue("dlsMovelCorrente_imbIncluiItem_", {i-1}))$clickElement()
  remDr$findElement("id", glue("dlsMovelCorrente_imbIncluiItem_", {i-1}))$clickElement()
}

#-- Close Button
remDr$findElement("id", "butCatalogoMovelFecha")$clickElement()

#-- View results
remDr$findElement("id", "cphConsulta_butVisualizarResultado")$clickElement()

#-- Open results in a new tab
remDr$navigate("http://www14.fgv.br/fgvdados20/VisualizaConsultaFrame.aspx")

#-- Data wrangling
df <- remDr$getPageSource()[[1]] %>%

  xml2::read_html(encoding = 'UTF-8') %>%

  rvest::html_table(fill = TRUE) %>%

  magrittr::extract2(3) %>%

  dplyr::slice(-1) %>%

  janitor::remove_empty(which = c("cols")) %>%

  magrittr::set_colnames(.[1:ncol(.), 1]) %>%

  tidyr::drop_na()

#-- Close server
remDr$closeServer()

#-- Close browser
remDr$close()
