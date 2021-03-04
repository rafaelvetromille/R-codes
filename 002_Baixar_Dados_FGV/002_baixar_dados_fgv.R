# R CODES ----
# 👉 CODE 002: Baixar dados do site FGV Dados c/ Rselenium ----

#-- Load packages
library(RSelenium)
library(tidyverse)
library(glue)

#-- Set the directory to download the file inside the correct folder
setwd('002_Baixar_Dados_FGV/')

#-- Setting chromeOptions
file_path <- getwd() %>% str_replace_all("/", "\\\\\\")
eCaps <- list(
  chromeOptions = list(
    args = c('--disable-gpu', '--window-size=1280,800'),
    prefs = list(
      "profile.default_content_settings.popups" = 0L,
      "download.prompt_for_download" = FALSE,
      "download.default_directory" = file_path
    )
  )
)

#-- Remote driver
rD <- rsDriver(port = 4420L, browser = "chrome",
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

#-- Download .csv file
remDr$findElement("id", "lbtSalvarCSV")$clickElement()

#-- Close server
remDr$closeServer()

#-- Close browser
remDr$close()

#-- Verify the download file
list.files(getwd())
