
#### Extended abstract ####

# Set environment and load data
rm(list=ls())
library(tidyverse, warn.conflicts = F)
library(gt)
library(gtable)
library(gtsummary)

setwd('/Users/calenmendall/Desktop/UW_school_projects/Biost536/BIOST536_Extended_abstract/')
load(file = 'tbdata.RData')

## Add in household density measure
tbdata = tbdata %>% mutate(famSize = case_when(
  famSize == "<4" ~ 1,
  famSize == "4-6" ~ 2,
  famSize == ">6" ~ 3
))


tbdata = tbdata %>% mutate(roomNo = case_when(
  roomNo == "1" ~ 1,
  roomNo == "2" ~ 2,
  roomNo == "3+" ~ 3
))

tbdata = tbdata %>% mutate(householdDensity = round((famSize / roomNo),2))


## Select relevant subset of data to table
tbdata_sub = tbdata %>% select(
  'Case'= case,
  'Number of Windows in home' = windowNo,
  "Sex" = male,
  'Age'= age,
  "Income" = income,
  "Family Size" = famSize, 
  "Number of Rooms" = roomNo,
  'Household density' = householdDensity, 
  "BCG Scar" = BCGscar,
  "Household member with TB" = houseMemberTb
)

## Some transformations for the table
tbdata_sub$Sex = factor(tbdata_sub$Sex, labels = c('Female', 'Male'))
tbdata_sub$Case = factor(tbdata_sub$Case, labels = c('Control', 'Case'))
tbdata_sub$Income = factor(tbdata_sub$Income, labels= c('Low', 'Mid', 'High'), levels = c('low','mid','high'))
tbdata_sub$`Number of Rooms` = factor(tbdata_sub$`Number of Rooms`, labels= c('1', '2', '3+'), levels = c(1, 2, 3))
tbdata_sub$`Family Size` = factor(tbdata_sub$`Family Size`, labels= c('<4', '4-6', '>6'), levels = c(1, 2, 3))
tbdata_sub$`BCG Scar` = factor(tbdata_sub$`BCG Scar`, labels = c('No', 'Yes'))
tbdata_sub$`Household member with TB`= factor(tbdata_sub$`Household member with TB`, labels = c('No', 'Yes'))

## Generating the table and formatting
tab = tbl_summary(tbdata_sub, by = 'Case') %>% add_overall(last=T)%>% as_gt()

tab = tab %>% tab_spanner('Tuberculosis infection status', columns = c(6,7,8), gather = T, level = 1) %>%
  tab_header("Table 1. Descriptive statistics of study participants. Categorical variables are summarized by counts and percentages. Continuous and discrete variables are summarized by their median and interquartile range.") 

tab2 = tab %>% tab_options(table.font.size = 14, heading.title.font.size = 15,
                    row_group.font.weight = 'bold', 
                    column_labels.font.weight = 'bold', 
                    row_group.background.color = "gray95", 
                    column_labels.background.color = 'gray80', stub.border.width = 0, 
                    data_row.padding.horizontal = 0,
                    data_row.padding = 2)

tab2 = tab2 %>% cols_width(everything()~185)
tab2
## Saving the table

gtsave(tab2, filename = "table1.pdf", path = "./")
gtExtras::gtsave_extra(tab2, filename = "table1.2.png",path = "./")
