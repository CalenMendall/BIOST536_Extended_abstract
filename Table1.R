
#### Extended abstract ####
setwd('/Users/calenmendall/Desktop/UW_school_projects/Biost536/Extended_abstract/')
load(file = 'tbdata.RData')


tbdata_sub = tbdata %>% select(
  'Case'= case,
  "Sex" = male,
  'Age'= age,
  "Income" = income,
  "Family Size" = famSize, 
  "Number of Rooms" = roomNo,
  'Number of Windows' = windowNo
)


tbdata_sub$Sex = factor(tbdata_sub$Sex, labels = c('Female', 'Male'))
tbdata_sub$Case = factor(tbdata_sub$Case, labels = c('Control', 'Case'))
tbdata_sub$Income = factor(tbdata_sub$Income, labels= c('High', 'Mid', 'Low'), levels = c('high','mid','low'))
tbdata_sub$`Family Size` = factor(tbdata_sub$`Family Size`, labels= c('>6', '4-6', '<4'), levels = c('>6', '4-6', '<4'))




tab = tbl_summary(tbdata_sub, by = 'Case') %>% add_overall(last=T)%>% as_gt()


tab = tab %>% tab_spanner('Tuberculosis infection status', columns = c(6,7,8), gather = T, level = 1) %>%
  tab_header("Table 1. Descriptive statistics of study participants. Categorical variables are summarized by counts and percentages. Continuous and discrete variables are summarized by their median and interquartile range.") 

tab %>% tab_options(table.font.size = 10, heading.title.font.size = 11,
                    row_group.font.weight = 'bold', 
                    column_labels.font.weight = 'bold', 
                    row_group.background.color = "gray95", 
                    column_labels.background.color = 'gray80', stub.border.width = 0, 
                    data_row.padding.horizontal = 0)

