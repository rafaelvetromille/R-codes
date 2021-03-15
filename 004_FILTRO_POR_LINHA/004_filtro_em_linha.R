# R CODES ----
# 👉 CODE 004: Realizar filtro em linha de um data.frame ----

# -- 1. Carregar pacotes
library(magrittr)

# -- 2. Dados de exemplo
lista <- list(
  tibble::tribble(
    ~colA, ~colB,
    "a", "a",
    "b", "1",
    "c", "c",
    "d", "2",
    "e", "3",
    "f", "f",
    "g", "4",
    "h", "5",
    "i", "i"
  ),
  tibble::tribble(
    ~colA, ~colB,
    "a", "a",
    "b", "1",
    "c", "c",
    "d", "2",
    "e", "3",
    "f", "f"
  )
)

# -- 3. Remover linhas iguais
purrr::map(lista, ~dplyr::filter(.x, colA != colB))

# -- 4. Função que faz o filtro para uma tabela
filter_everything <- . %>%

  purrr::transpose() %>%

  purrr::keep(~length(unique(.x)) > 1) %>%

  purrr::transpose() %>%

  tibble::as_tibble() %>%

  tidyr::unnest(dplyr::everything())

# -- 5. Filtrar linhas iguais de todas as colunas
purrr::map(lista, ~filter_everything(.x))
