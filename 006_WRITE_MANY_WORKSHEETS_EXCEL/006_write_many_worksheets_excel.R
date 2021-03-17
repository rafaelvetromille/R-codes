#' R CODES ----
#' 👉 CODE 006: How to use dplyr to write as many Excel files or worksheets you want? ----

# load packages
library(dplyr)
library(openxlsx)

# write sheet function 
write_sheet <- function(wb, sheet, data1, data2) {
  openxlsx::addWorksheet(wb, sheetName = sheet)
  openxlsx::writeData(wb, sheet, data1, startRow = 1, startCol = 1)
  openxlsx::writeData(wb, sheet, data2, startRow = 3, startCol = 1)
}

test_df <- data.frame(
  country = as.character(c("UK", "Germany", "France")),
  revenue = c(1000000, 2000000, 3000000), 
  staff = c(230, 280, 320)
) %>% 
  as_tibble() %>% 
  dplyr::mutate(country = as.character(country))

# open a workbook 
wb <- openxlsx::createWorkbook()

# use rowwise and mutate to write all excel sheets in one command
test_df %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(write_sheet = write_sheet(wb, country, revenue, staff))

# save workbook
openxlsx::saveWorkbook(wb, "006_WRITE_MANY_WORKSHEETS_EXCEL/test.xlsx")

library(xts)


expinf = get_twelve_months_inflation_expectations('IPCA')

expinf_s <- expinf %>% 
  dplyr::filter(smoothed == "S") %>% 
  dplyr::select(date, mean, median) 

expinf12 = xts(expinf$mean[expinf$smoothed=='S'], order.by = expinf$date[expinf$smoothed=='S'])

dataex = cbind(swap, expinf12)
dataex = dataex[complete.cases(dataex),]
