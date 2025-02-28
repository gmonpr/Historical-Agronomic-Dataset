rm(list=ls()) #Clear workspace
# invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE, unload=TRUE))

#load libraries
library(dplyr)
library(tidyr)
library(lubridate)
library(openxlsx)

# getwd() #get work enviroment
# setwd("Nueva_Linea/Finale_Dataverse") #set work enviroment

Farmer_Plot_Log1 <- read.xlsx('1.-Farmer_Plot_Logbook_2012-2022_01.xlsx')

# Convert Farmer/Plot/Log data to Long format
Farmer_Plot_Log1_L <- Farmer_Plot_Log1 %>%
  mutate(across(c(where(is.character),-c(1,10,30,45,46)),~iconv(.,from="UTF-8",to="ASCII//TRANSLIT"))) %>% 
  mutate(across(c(where(is.character),-c(1,10,30,45,46)),trimws)) %>% 
  pivot_longer(cols = c(INNOVATION.PRACTICES_ID, CONVENTIONAL.PRACTICES_ID),names_to = "PRACTICES_TYPE",values_to = "PRACTICES_ID") %>%
  filter(!is.na(PRACTICES_ID)) #69351

Sow_Hv_Yields2 <- read.xlsx('2.-Sowing_harvest_yields_2012-2022_01.xlsx')

# Convert harvest and Yield data to Wide format
Sow_Hv_Yields2_wide <- Sow_Hv_Yields2 %>%
  group_by(`INNOVATION/CONVENTIONAL_PRACTICES_ID`) %>%
  mutate(crop_num = row_number()) %>%  
  pivot_wider(
    names_from = crop_num,
    values_from = -c(`INNOVATION/CONVENTIONAL_PRACTICES_ID`,YEAR,STATE,`WINTER/SUMER. SEASON`,PLOT.TYPE,STATE,HYDRIC.REGIME,PRACTICES_TYPE,CROP.NUMBER.SOWING),
    names_glue = "{.value}_{crop_num}"
  ) %>%
  ungroup() #69010

# Join Harvest and Yield data with Farmer/Plot Log data
Farmer_Yield <- Sow_Hv_Yields2_wide %>% 
  left_join(Farmer_Plot_Log1_L %>% select(-c(PLOT.TYPE,STATE,YEAR,HYDRIC.REGIME,PRACTICES_TYPE)),by=c('INNOVATION/CONVENTIONAL_PRACTICES_ID'='PRACTICES_ID'))

Labor_Hv_act3 <- read.xlsx('3._Labor_harvest_activities_2012-2022_01.xlsx',startRow = 2)

# Convert Labor Harvest Activities data to Wide format
Labor_Hv_act3_wide <- Labor_Hv_act3 %>% 
  group_by(`INNOVATION/CONVENTIONAL_PRACTICES_ID`) %>% 
  mutate(crop_num = row_number()) %>% 
  pivot_wider(
    names_from = crop_num,
    values_from = -c(`INNOVATION/CONVENTIONAL_PRACTICES_ID`,FARMER.ID,PLOT.ID,LOGBOOK.ID,PLOT.TYPE,STATE,YEAR,`WINTER/SUMMER. SEASON`,HYDRIC.REGIME,PRACTICES_TYPE),
    names_glue = "{.value}_{crop_num}"
  ) #68968

Cost_and_revenue6 <- read.xlsx('6.-Costs and revenues_2012-2022_01.xlsx',startRow = 2)
colnames(Cost_and_revenue6) <- make.unique(colnames(Cost_and_revenue6))
