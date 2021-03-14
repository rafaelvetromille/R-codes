#' R CODES ----
#' 👉 CODE 002: BAIXAR DADOS DO SITE FGVDADOS C/ RVEST E XML2 ----

#' 00. Carregar pacotes necessários ----
library(tidyverse)
library(xml2)
library(rvest)

#' 01. Acessa a página inicial ----
r0 <- httr::GET("http://www14.fgv.br/fgvdados20/default.aspx?Convidado=S")

#' 02. Armazena os parâmetros que irão dependem de cada sessão ----
vs <- r0 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATE']") %>%
  xml2::xml_attr("value")

vs_gen <- r0 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATEGENERATOR']") %>%
  xml2::xml_attr("value")

#' 03. Escreve os parâmetros
parametros <- list(
  "ctl00$smg" = "ctl00$updpCatalogo|ctl00$dlsCatalogoFixo$ctl02$imbOpNivelUm",
  "ctl00$drpFiltro" = "E",
  "ctl00$txtBuscarSeries" = "",
  "ctl00$cphConsulta$rblConsultaHierarquia" = "COMPARATIVA",
  "ctl00$cphConsulta$cpeLegenda_ClientState" = "false",
  "ctl00$cphConsulta$chkEscolhida" = "on",
  "ctl00$cphConsulta$gnResultado" = "rbtUltimo",
  "ctl00$cphConsulta$txtMes" = "__/__/____",
  "ctl00$cphConsulta$mkeMes_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoInicio" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoInicio_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoFim" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoFim_ClientState" = "",
  "ctl00$txtBAPalavraChave" = "",
  "ctl00$rblTipoTexto" = "E",
  "ctl00$txtBAColuna" = "",
  "ctl00$txtBAIncluida" = "",
  "ctl00$txtBAAtualizada" = "",
  "__EVENTTARGET" = "",
  "__EVENTARGUMENT" = "",
  "__LASTFOCUS" = "",
  "__VIEWSTATE" = vs,
  "__VIEWSTATEGENERATOR" = vs_gen,
  "__ASYNCPOST" = "true",
  "ctl00$dlsCatalogoFixo$ctl02$imbOpNivelUm.x" = "0",
  "ctl00$dlsCatalogoFixo$ctl02$imbOpNivelUm.y" = "0"
)

#' 04. Faz a requisição POST
u_post <- "http://www14.fgv.br/fgvdados20/default.aspx"
r <- httr::POST(u_post, body = parametros, encode = "form")

#' 05. Acessa o resultado da requisição
r1 <- httr::GET("http://www14.fgv.br/fgvdados20/consulta.aspx")

#' 06. Pega os parâmetros que dependem da nova sessão aberta anteriormente
vs <- r1 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATE']") %>%
  xml2::xml_attr("value")

vs_gen <- r1 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATEGENERATOR']") %>%
  xml2::xml_attr("value")

#' 07. Escreve os parâmetros (agora dessa nova sessão)
parametros <- list(
  "ctl00$smg" = "ctl00$cphConsulta$updpOpcoes|ctl00$cphConsulta$rbtSerieHistorica",
  "__EVENTTARGET" = "ctl00$cphConsulta$rbtSerieHistorica",
  "__EVENTARGUMENT" = "",
  "__LASTFOCUS" = "",
  "__VIEWSTATE" = vs,
  "__VIEWSTATEGENERATOR" = vs_gen,
  "ctl00$drpFiltro" = "E",
  "ctl00$txtBuscarSeries" = "",
  "ctl00$cphConsulta$rblConsultaHierarquia" = "COMPARATIVA",
  "ctl00$cphConsulta$cpeLegenda_ClientState" = "false",
  "ctl00$cphConsulta$chkEscolhida" = "on",
  "ctl00$cphConsulta$gnResultado" = "rbtSerieHistorica",
  "ctl00$cphConsulta$txtMes" = "__/__/____",
  "ctl00$cphConsulta$mkeMes_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoInicio" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoInicio_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoFim" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoFim_ClientState" = "",
  "ctl00$txtBAPalavraChave" = "",
  "ctl00$rblTipoTexto" = "E",
  "ctl00$txtBAColuna" = "",
  "ctl00$txtBAIncluida" = "",
  "ctl00$txtBAAtualizada" = "",
  "__ASYNCPOST" = "true")

#' 08. Faz a requisição POST
u_post <- "http://www14.fgv.br/fgvdados20/consulta.aspx"
r <- httr::POST(u_post, body = parametros, encode = "form")

#' 09. Acessa o resultado da requisição
r2 <- httr::GET("http://www14.fgv.br/fgvdados20/consulta.aspx")

#' 10. Pega os parâmetros que dependem da sessão
vs <- r2 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATE']") %>%
  xml2::xml_attr("value")

vs_gen <- r2 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATEGENERATOR']") %>%
  xml2::xml_attr("value")

#' 11. Escreve os parâmetros da nova sessão
parametros <- list(
  "ctl00$smg" = "ctl00$updpCatalogo|ctl00$dlsCatalogoFixo$ctl03$imbOpNivelDois",
  "ctl00$drpFiltro" = "E",
  "ctl00$txtBuscarSeries" = "",
  "ctl00$cphConsulta$rblConsultaHierarquia" = "COMPARATIVA",
  "ctl00$cphConsulta$cpeLegenda_ClientState" = "false",
  "ctl00$cphConsulta$chkEscolhida" = "on",
  "ctl00$cphConsulta$gnResultado" = "rbtSerieHistorica",
  "ctl00$cphConsulta$txtMes" = "__/__/____",
  "ctl00$cphConsulta$mkeMes_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoInicio" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoInicio_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoFim" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoFim_ClientState" = "",
  "ctl00$txtBAPalavraChave" = "",
  "ctl00$rblTipoTexto" = "E",
  "ctl00$txtBAColuna" = "",
  "ctl00$txtBAIncluida" = "",
  "ctl00$txtBAAtualizada" = "",
  "__EVENTTARGET" = "",
  "__EVENTARGUMENT" = "",
  "__LASTFOCUS" = "",
  "__VIEWSTATE" = vs,
  "__VIEWSTATEGENERATOR" = vs_gen,
  "__ASYNCPOST" = "true",
  "ctl00$dlsCatalogoFixo$ctl03$imbOpNivelDois.x" = "7",
  "ctl00$dlsCatalogoFixo$ctl03$imbOpNivelDois.y" = "4")

#' 12. Faz a requisição POST
u_post <- "http://www14.fgv.br/fgvdados20/consulta.aspx"
r <- httr::POST(u_post, body = parametros, encode = "form")

#' 13. Acessa o resultado da requisição dessa nova sessão
r3 <- httr::GET("http://www14.fgv.br/fgvdados20/consulta.aspx")

#' 14. Novamente pega os parâmetros que dependem da sessão
vs <- r3 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATE']") %>%
  xml2::xml_attr("value")

vs_gen <- r3 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATEGENERATOR']") %>%
  xml2::xml_attr("value")

#' 15. Escreve os parâmetros (em loop para clicar me cada um dos quadrados)
for (i in 1:6) {

  #' 15.1.
  ctl00smg <- paste0("ctl00$updpCatalogo|ctl00$dlsMovelCorrente$ctl0", i-1, "$imbIncluiItem")
  ctl00smg <- glue("ctl00$updpCatalogo|ctl00$dlsMovelCorrente$ctl0{i-1}$imbIncluiItem")
  dlsMovelCorrente.x <- glue("ctl00$dlsMovelCorrente$ctl0{i-1}$imbIncluiItem.x")
  dlsMovelCorrente.y <- glue("ctl00$dlsMovelCorrente$ctl0{i-1}$imbIncluiItem.y")

  #' 15.2.
  parametros <- list(
    "ctl00$smg" = ctl00smg,
    "ctl00$drpFiltro" = "E",
    "ctl00$txtBuscarSeries" = "",
    "ctl00$cphConsulta$rblConsultaHierarquia" = "COMPARATIVA",
    "ctl00$cphConsulta$cpeLegenda_ClientState" = "false",
    "ctl00$cphConsulta$chkEscolhida" = "on",
    "ctl00$cphConsulta$dlsSerie$ctl00$chkSerieEscolhida" = "on",
    "ctl00$cphConsulta$dlsSerie$ctl01$chkSerieEscolhida" = "on",
    "ctl00$cphConsulta$dlsSerie$ctl02$chkSerieEscolhida" = "on",
    "ctl00$cphConsulta$dlsSerie$ctl03$chkSerieEscolhida" = "on",
    "ctl00$cphConsulta$dlsSerie$ctl04$chkSerieEscolhida" = "on",
    "ctl00$cphConsulta$dlsSerie$ctl05$chkSerieEscolhida" = "on",
    "ctl00$cphConsulta$gnResultado" = "rbtUltimo",
    "ctl00$cphConsulta$txtMes" = "__/__/____",
    "ctl00$cphConsulta$mkeMes_ClientState" = "",
    "ctl00$cphConsulta$txtPeriodoInicio" = "__/__/____",
    "ctl00$cphConsulta$mkePeriodoInicio_ClientState" = "",
    "ctl00$cphConsulta$txtPeriodoFim" = "__/__/____",
    "ctl00$cphConsulta$mkePeriodoFim_ClientState" = "",
    "ctl00$txtBAPalavraChave" = "",
    "ctl00$rblTipoTexto" = "E",
    "ctl00$txtBAColuna" = "",
    "ctl00$txtBAIncluida" = "",
    "ctl00$txtBAAtualizada" = "",
    "__EVENTTARGET" = "",
    "__EVENTARGUMENT" = "",
    "__LASTFOCUS" = "",
    "__VIEWSTATE" = vs,
    "__VIEWSTATEGENERATOR" = vs_gen,
    "__ASYNCPOST" = "true",
    dlsMovelCorrente.x = "5",
    dlsMovelCorrente.y = "7")

  #' 15.3.
  names(parametros)[length(names(parametros))-1] <- dlsMovelCorrente.x
  names(parametros)[length(names(parametros))] <- dlsMovelCorrente.y

  #' 15.4. Faz a requisição POST
  u_post <- "http://www14.fgv.br/fgvdados20/consulta.aspx"
  r <- httr::POST(u_post, body = parametros, encode = "form")
}

#' 16. Acessa o resultado da requisição
r4 <- httr::GET("http://www14.fgv.br/fgvdados20/consulta.aspx")

#' 17. Pega parâmetros que dependem da sessão
vs <- r4 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATE']") %>%
  xml2::xml_attr("value")

vs_gen <- r4 %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//*[@id='__VIEWSTATEGENERATOR']") %>%
  xml2::xml_attr("value")

#' 18. Gravar os parâmetros a serem utilizados
parametros <- list(
  "ctl00$smg" = "ctl00$updpCatalogo|ctl00$dlsMovelPassada$ctl00$imbOpPassada",
  "ctl00$drpFiltro" = "E",
  "ctl00$txtBuscarSeries" = "",
  "ctl00$cphConsulta$rblConsultaHierarquia" = "COMPARATIVA",
  "ctl00$cphConsulta$cpeLegenda_ClientState" = "false",
  "ctl00$cphConsulta$chkEscolhida" = "on",
  "ctl00$cphConsulta$dlsSerie$ctl00$chkSerieEscolhida" = "on",
  "ctl00$cphConsulta$dlsSerie$ctl01$chkSerieEscolhida" = "on",
  "ctl00$cphConsulta$dlsSerie$ctl02$chkSerieEscolhida" = "on",
  "ctl00$cphConsulta$dlsSerie$ctl03$chkSerieEscolhida" = "on",
  "ctl00$cphConsulta$dlsSerie$ctl04$chkSerieEscolhida" = "on",
  "ctl00$cphConsulta$dlsSerie$ctl05$chkSerieEscolhida" = "on",
  "ctl00$cphConsulta$gnResultado" = "rbtUltimo",
  "ctl00$cphConsulta$txtMes" = "__/__/____",
  "ctl00$cphConsulta$mkeMes_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoInicio" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoInicio_ClientState" = "",
  "ctl00$cphConsulta$txtPeriodoFim" = "__/__/____",
  "ctl00$cphConsulta$mkePeriodoFim_ClientState" = "",
  "ctl00$txtBAPalavraChave" = "",
  "ctl00$rblTipoTexto" = "E",
  "ctl00$txtBAColuna" = "",
  "ctl00$txtBAIncluida" = "",
  "ctl00$txtBAAtualizada" = "",
  "__EVENTTARGET" = "",
  "__EVENTARGUMENT" = "",
  "__LASTFOCUS" = "",
  "__VIEWSTATE" = vs,
  "__VIEWSTATEGENERATOR" = vs_gen,
  "__ASYNCPOST" = "true",
  "ctl00$dlsMovelPassada$ctl00$imbOpPassada.x" = "6",
  "ctl00$dlsMovelPassada$ctl00$imbOpPassada.y" = "7")

#' 19. Faz a requisição POST
u_post <- "http://www14.fgv.br/fgvdados20/consulta.aspx"
r <- httr::POST(u_post, body = parametros, encode = "form")

#' 20. Acessa o resultado da requisição
r5 <- httr::GET("http://www14.fgv.br/fgvdados20/consulta.aspx")

#' 20. Acessa o resultado da requisição
r6 <- httr::GET("http://www14.fgv.br/fgvdados20/visualizaconsulta.aspx")

#' 21. Salva o data.frame e arruma os dados
IGP <- httr::GET("http://www14.fgv.br/fgvdados20/VisualizaConsultaFrame.aspx") %>%

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

#' 22. Limpa os registros e só deixa o data.frame
rm(list=setdiff(ls(), "IGP"))
