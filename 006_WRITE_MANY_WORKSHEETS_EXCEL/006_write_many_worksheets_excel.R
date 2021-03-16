library(dplyr)
library(openxlsx)

# write sheet function 
write_sheet <- function(wb, sheet, data1, data2) {
  openxlsx::addWorksheet(wb, sheetName = sheet)
  openxlsx::writeData(wb, sheet, data1, startRow = 1, startCol = 1)
  openxlsx::writeData(wb, sheet, data2, startRow = 3, startCol = 1)
}

teste_df <- data.frame(
  country = c("UK", "Germany", "France"),
  revenue = c(1000000, 2000000, 3000000), 
  staff = c(230, 280, 320)
)

# open a workbook 
wb <- openxlsx::createWorkbook()

# use rowwise and mutate to write all excel sheets in one command
teste_df %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(write_sheet = write_sheet(wb, country, revenue, staff))

# save workbook
openxlsx::saveWorkbook(wb, "test.xlsx")