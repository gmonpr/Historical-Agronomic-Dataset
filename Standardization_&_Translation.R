rm(list = ls())
# invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE, unload=TRUE))

library(openxlsx)
library(stringr)
library(dplyr)
library(tidyr)

# setwd("/Nueva_Linea")

# logbooks <- read.xlsx('1.-Farmers, Plot, Logbook Features_february 2024 (1)_Clean.xlsx')

harvest <- openxlsx::read.xlsx('3.-Labor and harvest, activities. + testigo_february2024_copia.1_clean.xlsx',startRow = 3)

colnames(harvest) <- make.unique(colnames(harvest))

harvest_F <- harvest %>%
  mutate(State=str_to_upper(State)) %>% 
  # mutate(Cycle=ifelse(Cycle=='Otoño-Invierno','Autumn Winter',ifelse(Cycle=='Primavera-Verano','SPRING SUMMER',Cycle))) %>% 
  mutate(Hydric.Regime=ifelse(Hydric.Regime%in%c('PUNTA DE RIEGO','RIEGO'),'RIEGO',ifelse(Hydric.Regime=='TEMPORAL','RAINFED',Hydric.Regime))) %>% 
  mutate(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`=replace(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`,agrep('TRADICIONAL',`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`),'LABRANZA TRADICIONAL')) %>% 
  mutate(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`=replace(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`,agrep('MINIMA',`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`),'LABRANZA MINIMA REDUCIDA')) %>%
  mutate(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`=replace(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`,agrep('AGRICULTURA',`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`),'LABRANZA MINIMA REDUCIDA')) %>%
  mutate(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`=replace(`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`,agrep('CERO',`Tipo.de.labranza.(.de.la.actividad.de.preparacion.mecanica)`),'CERO LABRANZA')) %>% 
  mutate(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`=replace(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`,agrep('TRADICIONAL',`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`),'LABRANZA TRADICIONAL')) %>% 
  mutate(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`=replace(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`,agrep('MINIMA',`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`),'LABRANZA MINIMA REDUCIDA')) %>%
  mutate(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`=replace(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`,agrep('AGRICULTURA',`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`),'LABRANZA MINIMA REDUCIDA')) %>%
  mutate(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`=replace(`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`,agrep('CERO',`Tipo.de.labranza.(de.configuracion.de.bitacora,.BEM)`),'CERO LABRANZA')) %>% 
  mutate(Tipo.de.costo=trimws(Tipo.de.costo,'both')) %>% 
  mutate(`¿Que.tipo.de.animal.utiliza?`=ifelse(grepl('CABALLO',`¿Que.tipo.de.animal.utiliza?`),'CABALLO',`¿Que.tipo.de.animal.utiliza?`)) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('CINCEL',`Implemento.utilizado.(1)`),'ARADO DE CINCEL')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('EGIPCIO',`Implemento.utilizado.(1)`),'ARADO EGIPCIO')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('VERTEDERA',`Implemento.utilizado.(1)`),'ARADO VERTEDERA')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('DE DISCO',`Implemento.utilizado.(1)`),'ARADO DE DISCO')) %>%
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('VERTICAL',`Implemento.utilizado.(1)`),'SEMBRADORA DE TIRO ANIMAL (DISCO VERTICAL)')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('INCLINADO',`Implemento.utilizado.(1)`),'SEMBRADORA DE TIRO ANIMAL (DISCO INCLINADO)')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('HORIZONTAL',`Implemento.utilizado.(1)`),'SEMBRADORA DE TIRO ANIMAL (DISCO HORIZONTAL)')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('OTRO',`Implemento.utilizado.(1)`),'OTRO')) %>% 
  mutate(`Implemento.utilizado.(1)`=gsub("(TRADICIONAL).*","\\1",`Implemento.utilizado.(1)`)) %>% 
  mutate(`Implemento.utilizado.(1)`=str_replace_all(`Implemento.utilizado.(1)`,'ARADO TRADICIONAL','ARADO TRADICIONAL')) %>% 
  mutate(`Implemento.utilizado.(1)`=ifelse(`Implemento.utilizado.(1)`%in%c('ARADO','ARADO DE MADERA','ARADO DE PALO','ARADO ARTESANAL','ARADO DE PUNTA','YUGO'),'ARADO TRADICIONAL',`Implemento.utilizado.(1)`)) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('YUNTA',`Implemento.utilizado.(1)`),'ARADO TRADICIONAL')) %>% 
  mutate(`Implemento.utilizado.(1)`=replace(`Implemento.utilizado.(1)`,agrep('ATRACCION',`Implemento.utilizado.(1)`),'ARADO TRADICIONAL')) %>% 
  mutate(`Implemento.utilizado.(1)`=str_replace_all(`Implemento.utilizado.(1)`,'_',' ')) %>% 
  mutate(`Implemento.utilizado.(1)`=ifelse(grepl('MECANIZADO',`Implemento.utilizado.(1)`),NA,`Implemento.utilizado.(1)`)) %>% 
  mutate(`Implemento.utilizado.(1)`=ifelse(`Implemento.utilizado.(1)`%in%c('PERSONAS','MANO DE OBRA','JORNALEROS'),'JORNALEROS',`Implemento.utilizado.(1)`)) %>% 
  mutate(`Implemento.utilizado.(1)`=ifelse(`Implemento.utilizado.(1)`=='MANNUAL','MANUAL',`Implemento.utilizado.(1)`)) %>% 
  mutate(`Implemento.utilizado.(1)`=str_replace_all(`Implemento.utilizado.(1)`,'CULTIVADORA','SEMBRADORA')) %>% 
  mutate(`Implemento.utilizado.(1)`=ifelse(`Implemento.utilizado.(1)`%in%c('PATAS DE GALLO','SEMBRADORA DE TRES REJAS','ARADO DE DOS ALAS (PALOMA)','SEMBRADORA DE GARZA'),NA,`Implemento.utilizado.(1)`)) %>% 
  mutate(`¿Como.obtuvo.el.implemento?`=ifelse(grepl('TECNICO',`¿Como.obtuvo.el.implemento?`),'TECNICO',`¿Como.obtuvo.el.implemento?`)) %>% 
  mutate(`¿Como.obtuvo.el.implemento?.1`=gsub(".*_",'',`¿Como.obtuvo.el.implemento?.1`)) %>% 
  mutate(`¿Como.obtuvo.el.implemento?.1`=ifelse(grepl('MAQUINARIA|PUNTO',`¿Como.obtuvo.el.implemento?.1`),'PUNTO DE MAQUINARIA',ifelse(grepl('OTRO|OTRA',`¿Como.obtuvo.el.implemento?.1`),'OTRO',`¿Como.obtuvo.el.implemento?.1`))) %>% 
  mutate(Tipo.de.código.del.implemento=trimws(Tipo.de.código.del.implemento,'both')) %>% 
  mutate(Tipo.de.código.del.implemento=str_replace_all(Tipo.de.código.del.implemento,'_',' ')) %>% 
  mutate(Tipo.de.código.del.implemento=ifelse(grepl('TIENE',Tipo.de.código.del.implemento),'NO LO TIENE',Tipo.de.código.del.implemento)) %>%
  mutate(`Implemento.utilizado.(2)`=str_replace_all(`Implemento.utilizado.(2)`,'_',' ')) %>% 
  mutate(`Implemento.utilizado.(2)`=ifelse(grepl('MECANIZADO',`Implemento.utilizado.(2)`),NA,ifelse(grepl('OTRO',`Implemento.utilizado.(2)`),'OTRO',ifelse(grepl('ARADOVERTEDERA',`Implemento.utilizado.(2)`),'ARADO VERTEDERA',`Implemento.utilizado.(2)`)))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~str_replace_all(.,'_',' '))) %>% 
  mutate(`Implemento.utilizado.(1):`=ifelse(grepl('MOTOR',`Implemento.utilizado.(1):`),NA,`Implemento.utilizado.(1):`)) %>% 
  mutate(`Implemento.utilizado.(1):`=replace(`Implemento.utilizado.(1):`,agrep('PISCADOR',`Implemento.utilizado.(1):`),'PIZCADOR')) %>% 
  mutate(`Implemento.utilizado.(1):`=replace(`Implemento.utilizado.(1):`,agrep('ROSADERA',`Implemento.utilizado.(1):`),'ROZADERA')) %>% 
  mutate(`Implemento.utilizado.(1):`=replace(`Implemento.utilizado.(1):`,agrep('ASADON',`Implemento.utilizado.(1):`),'AZADON')) %>% 
  mutate(`Implemento.utilizado.(1):`=gsub('(COSTAL).*','\\1',`Implemento.utilizado.(1):`)) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~str_replace_all(.,'_','NULL'))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'MAIZ|NUK NAAL|NAAL XOY|MILPA|AMARILLO'),'MAIZ',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'FRIJOL MUNGO|MUNGO'),'FRIJOL MUNGO',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'QUINOA|QUINUA'),'QUINOA',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'AGAVE|MAGUEY'),'AGAVE MAGUEY',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'JITOMATE ROJO|TOMATE|JITOMATE ROJO'),'TOMATE',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'MILTOMATE|TOMATE DE CASCARA|CASCARA'),'TOMATE DE CASCARA',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'IBES|IB|PHASEOLUS LUNATUS'),'IBES',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'VIGNA|BIGNA|CAUPI'),'VIGNA',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'CILANDRO|CILANTRO'),'CILANTRO',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'CHILE'),'CHILE',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'GIRASOL'),'GIRASOL',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'AVENA+EBO|AVENA + EBO|AVENA + EBO'),'AVENA+EBO',.))) %>% 
  mutate(across(c(`Nombre.del.cultivo.(Siembra)`,`Cultivo.al.que.corresponde.la.actividad.de.cosecha.((siembra/cosecha))`),~ifelse(str_detect(.,'TITRICALE'),'TRITICALE',.))) %>% 
  mutate(across(c(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),~str_replace_all(.,'SEMBEADORA','SEMBRADORA'))) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('JOHN DEER',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA JOHN DEERE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('BAJIO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DEL BAJIO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('DOBLADENSE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DOBLADENSE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('MULTIUSO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA MULTIUSO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('ACOPLADA|ACOPLE|MODIFICADA PARA AC| AC|A AC|ADAPTADA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'TRADICIONAL ACOPLADA A AC',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('GASPARDO|GAZPARDO|GASSPARDO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'GASPARDO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('FAMAQ|FAMAO|FAMAC|FAMA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'FAMAQ',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('MONOSEM|MONOSEN|MONOCEN',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'MONOSEM',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('MASSEY FERGUNSON|MASSEY FERGUSON',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'MASSEY FERGUSON',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('MENONITA|MENONA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA MENONITA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('JUMILL|JUMIL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA JUMIL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('VAZQUEZ|VAZQUES|VASQUEZ|ASQUEZ',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA VAZQUEZ',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('BRAVO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA BRAVO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('APACHE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA APACHE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('SWISSMEX|SWISMEX|SWISEMEX|SWISSMEX|SWIMEX',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA SWISSMEX',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('HAPPY',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'HAPPY SEEDER',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('INTERNACIONAL|INTERNATIONAL|INTERNASIONAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'INTERNACIONAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('SEMEATO|BRASILENA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA SEMEATO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('SEMEATO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA SEMEATO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('REGION|LOCAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA HECHA EN LA REGION',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`%in%c('ZETA','SETA','SEMBRADORA Z','Z','Z TRADICIONAL','SISTEMA DE PLATO "Z"','TIPO Z'),'SEMBRADORA TIPO ZETA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`%in%c('SEMBRADORA TRADICIONAL','TRADICIONAL DE CATARINA','CATARINA','MECANICA DE CATARINA','TRADICIONAL DEL PRODUTOR','TRADIICIONAL','TRADISIONAL','TRADICIONAL DEL PRODUCTOR','LUCATERO TRADICIONAL','TRADICIONAL','TRADICIONAL MODIFICADA','TRADICIONAL DE 4 SURCOS','TRADICIONAL (PLATO CIEGO)','SEMBRADORA TRADICIONAL PARA CUATRO SURCOS','SEMBRADORA TRADICIONAL DE BOTES','SEMBRADORA TRADICIONAL DEL PRODUCTOR'),'SEMBRADORA TRADICIONAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('TRIGUERA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'TRIGUERA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('CONVENCIONAL|ANTIGUA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA TRADICIONAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl(' PRESICION| PRECISION|PREWSICION|MECANICA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA MECANICA DE PRECISION',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('CESENA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA CESENA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('CORDERO|CORDEERO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA CORDERO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('SIN MARCA|DESCONOCIDA|DESCONOCIDO|NO VISIBLE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA SIN MARCA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('DE 9|NUEVE',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE 9 LINEAS',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`))  %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('DE 3',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE 3 SURCOS',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`))  %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`%in%c('CASERA','PRODUCTOR','SEMBRADORA HECHA POR ELLOS','ECHIZA','HECHIZA','SEMBRADORA HECHIZA','TRADICIONAL ELABORADA POR EL PRODUCTOR'),'SEMBRADORA HECHA POR PRODUCTOR',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`))  %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('ANIMAL|TIMS',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE TIRO ANIMAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('MANUAL|SEMBRADORES',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SIEMBRA MANUAL',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('SEMIPRECISION|SEMBRADORA DE SEMIPRESICION',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE SEMIPRECISION',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('CUCHARA| CUCHARITA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE CUCHARA',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('PLATO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE PLATO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('CERO|CONSERVACION',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA LABRANZA CONSERVACION',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('HERMANOS',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DOS HERMANOS',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('CEREAL|MAIZ|SORGO',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'SEMBRADORA DE CEREALES',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`=ifelse(grepl('25',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`),'MP 25',`Tipo.de.sembradora.utilizada.para.la.siembra.(siembra)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('RESIDUOS|RASTROJO|PAJA|COBERTURA',`Tipo.de.manejo.(preparacion.del.suelo)`),'MANEJO_RESIDUOS',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('CANALES',`Tipo.de.manejo.(preparacion.del.suelo)`),'CANALES',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('TRADICIONAL|CONVENCIONAL',`Tipo.de.manejo.(preparacion.del.suelo)`),'TRADICIONAL',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('RASTRA|RASTREO',`Tipo.de.manejo.(preparacion.del.suelo)`),'RASTREO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('BARBECHO',`Tipo.de.manejo.(preparacion.del.suelo)`),'BARBECHO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('MALEZAS|DESBROZADORA',`Tipo.de.manejo.(preparacion.del.suelo)`),'CONTROL DE MALEZAS',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('SURCO|SURQUEO|SURCADO',`Tipo.de.manejo.(preparacion.del.suelo)`),'SURCADO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('NIVELACION|EMPAREJADO|EMPAREJE',`Tipo.de.manejo.(preparacion.del.suelo)`),'NIVELACION',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('CHAPEO|CHOPEO',`Tipo.de.manejo.(preparacion.del.suelo)`),'CHOPEO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=str_replace_all(`Tipo.de.manejo.(preparacion.del.suelo)`,'ROSA','ROZA')) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('BORDOS|BORDEO',`Tipo.de.manejo.(preparacion.del.suelo)`),'BORDEO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>%  
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('ROZA Y TUMBA|ROZA, TUMBA',`Tipo.de.manejo.(preparacion.del.suelo)`),'ROZA Y TUMBA',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('MALEZA',`Tipo.de.manejo.(preparacion.del.suelo)`),'CONTROL DE MALEZAS',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('TERRON|VIGA|ROTURA',`Tipo.de.manejo.(preparacion.del.suelo)`),'CORRECCION_COMPACTACION',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('VOLTEAR',`Tipo.de.manejo.(preparacion.del.suelo)`),'CORRECCION_COMPACTACION',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('CULTIVA',`Tipo.de.manejo.(preparacion.del.suelo)`),'CULTIVADORA',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('CUADREADA|TABLONEO',`Tipo.de.manejo.(preparacion.del.suelo)`),'DIVISION DEL TERRENO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(`Tipo.de.manejo.(preparacion.del.suelo)`%in%c('PREPARACION','PREPARACION DE SUELO','PREPARACION SUELO','ACONDICIONAMIENTO DE SUELO','AIREACION DEL SUELO'),'PREPARACION DEL SUELO',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('CAMA',`Tipo.de.manejo.(preparacion.del.suelo)`),'MANEJO_SUELOS_CAMAS',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=ifelse(grepl('RTQ',`Tipo.de.manejo.(preparacion.del.suelo)`),'ROZA TUMBA Y QUEMA',`Tipo.de.manejo.(preparacion.del.suelo)`)) %>% 
  mutate(`Tipo.de.manejo.(preparacion.del.suelo)`=str_replace_all(`Tipo.de.manejo.(preparacion.del.suelo)`,'_',' ')) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('CUBETAS|TRAMPA|BOTELLA|BOTE|GARRAFA|TRAMAPAS|TRAMPEO|TGRAMPAS|TAMPA|ANFORA|PLASTIC',Instrumento.de.aplicación.de.insumos),'TRAMPA CON FEROMONAS',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('TRICHOGRAM|AVISP|TRYCHOGRAMMAS',Instrumento.de.aplicación.de.insumos),'TRICHOGRAMMA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('DRON',Instrumento.de.aplicación.de.insumos),'DRON AGRICOLA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('GANDHI|GANDI|GANDY',Instrumento.de.aplicación.de.insumos),'GANDY MONTADA A SEMBRADORA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('SEMILLA|SEMILA',Instrumento.de.aplicación.de.insumos),'TRATAMIENTO A LA SEMILLA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('ESPOVOREADORA|ESPOLVORE',Instrumento.de.aplicación.de.insumos),'ESPOLVOREADO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('VASO|BASO',Instrumento.de.aplicación.de.insumos),'VASO DE UNICEL',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('SEMBRADORA |LA SEMBRADORA|DE SEMBRADORA|CON SEMBRADORA|SEMBADORA|TRACTOR SEMBRADORA|EN SEMBRADORA|APLICADOR SEMBRADORA|CON TRACTOR|SIEMBRA',Instrumento.de.aplicación.de.insumos),'SEMBRADORA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(Instrumento.de.aplicación.de.insumos=='TRACTOR','SEMBRADORA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('CUATRIMMOTO|CUATRIMOTO',Instrumento.de.aplicación.de.insumos),'ASPERSORA MONTADA EN CUATRIMOTO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(Instrumento.de.aplicación.de.insumos%in%c('CON MOCHILA DE FERTILIZANTE','FERTILIZADORA DE MOCHILA MANUAL','MOCHILA','MOCHILA FERTILIZADORA','MOCHILA FERTILIZADORA MANUAL','MOCHILA MANUAL','MOCHILA P/FERTILIZACION MANUAL','MOCHILA DE POLVO','MOCHILLA FERTILIZADORA MANUAL'),'ASPERSORA DE MOCHILA MANUAL',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(Instrumento.de.aplicación.de.insumos%in%c('POLVEADORA MOTORIZADA'),'ASPERSORA DE MOCHILA MOTORIZADA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('OTRO',Instrumento.de.aplicación.de.insumos),'OTRO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('FEROMONA |FEROMONAS |DE FEROMONA|PHEROCOM',Instrumento.de.aplicación.de.insumos),'FEROMONAS',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(Instrumento.de.aplicación.de.insumos%in%c('FEROMONA'),'FEROMONAS',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('MEZCLA|JUNTO|CON EL F|2DA FER',Instrumento.de.aplicación.de.insumos),'MEZCLADO CON EL FERTILIZANTE',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('ABONO|ABONADO',Instrumento.de.aplicación.de.insumos),'MEZCLADO CON EL ABONO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('BOLSA',Instrumento.de.aplicación.de.insumos),'BOLSA DE TELA',Instrumento.de.aplicación.de.insumos))  %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('SAL',Instrumento.de.aplicación.de.insumos),'SALERO',Instrumento.de.aplicación.de.insumos))  %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('RIEGO',Instrumento.de.aplicación.de.insumos),'EN EL RIEGO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('SUELO|ENTERRADO',Instrumento.de.aplicación.de.insumos),'EN EL SUELO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('INSECTICIDA|ASPID|NEEM',Instrumento.de.aplicación.de.insumos),'APLICADOR DE INSECTICIDA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(Instrumento.de.aplicación.de.insumos%in%c('MANO DE OBRA','A GOLPE MATEADO','MANUAL CON APLICADOR','MATEADO','EN BANDA MANUAL','ALBOLEO MANUAL','APLICACION CON GENTE','A MANO','JORNAL','JORNALES','APLICACION MANUAL','CHAPEO MANUAL','COLOCACION MANUAL','DE FORMA MANUAL AL COGOLLO','DESHIERBE MANUAL','ESPARCIDO MANUAL','FORMA MANUAL','GRANULADORA MANUAL','MANUAL (MANGUERA)','MANUAL (SOLIDO','MANUAL EN EL COGOLLO','MANUAL ESPARCIDO','MANUAL SOLIDO','MANUEL','NANUAL DIRECTA AL COGOLLO'),'MANUAL',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('PARI',Instrumento.de.aplicación.de.insumos),'PARIHUELA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(Instrumento.de.aplicación.de.insumos%in%c('NINGUNO','NINGUNA','NADA','N/A','NO SE APLICO'),'NO APLICO',Instrumento.de.aplicación.de.insumos))  %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('CONTROL|PARASITOIDE|INOCULACION',Instrumento.de.aplicación.de.insumos),'CONTROL BIOLOGICO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('FERTILIZADORA',Instrumento.de.aplicación.de.insumos),'FERTILIZADORA',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('MANEJO|MONITOREO|LAMIN|LIBERACION|PLACA',Instrumento.de.aplicación.de.insumos),'MANEJO AGROECOLOGICO DE PLAGAS',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('CEBO',Instrumento.de.aplicación.de.insumos),'CEBO',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(Instrumento.de.aplicación.de.insumos=ifelse(grepl('BOLEADORA|VOLEADORA',Instrumento.de.aplicación.de.insumos),'BOLEADORA DE FERTILIZANTE',Instrumento.de.aplicación.de.insumos)) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'MA MANUAL|MANO|FORMAMANUAL|MANUAL '),'MANUAL',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'DEGRANADORA|DESHGRANADORA|DESGRANADORA'),'DESGRANADORA',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'CARRE'),'CARRETA/CARRETILLA',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'DEBROZADORA|DESBROZADORA'),'DESBROZADORA',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'MOCHILA|FERTILIZADORA MANUAL'),'MOCHILA ASPERSORA',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'PISCON|PIZCON|PIZCADOR'),'PIZCADOR',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'TRANSPORTE|VEHICULO|CAMIONETA|CAMION'),'VEHICULO',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'OTRO'),'OTRO',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'CANASTO|TENATE'),'CANASTO/TENATE',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'PALO|VARAS|ESTACA|MADERA'),'PALO/VARAS',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'MOLINO|MOLIONO'),'MOLINO',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'REMOLQUE|TRAILA'),'REMOLQUE',.))) %>%  
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~str_replace_all(.,'NULL',NA_character_))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'BIDON|GARRAFA|GARRAFON|CUBETA|TAMBO|BOTE'),'CONTENEDORES/RECIPIENTES',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'BOMBA |FUMIGADORA|ASPERSORA MANUAL'),'BOMBA ASPERSORA MANUAL',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'CLAVO'),'CLAVO',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~ifelse(str_detect(.,'AGUJA'),'AGUJA',.))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~str_replace_all(.,'JABON LIQUIDO','JABON'))) %>% 
  mutate(across(c(`Implemento.utilizado.(1):`,`Implemento.utilizado.(2):`,`Implemento.utilizado.(3):`,`Implemento.utilizado.(4):`,`Implemento.utilizado.(5):`),~str_replace_all(.,'SEMBRADOR PORTA SEMILLA','SEMBRADOR'))) %>% 
  mutate(across(c(`¿El.costo.de.renta.incluye.el.traslado.a.la.parcela?`,`Otro.origen.del.implemento.(Especifique)`),trimws)) %>% 
  mutate(across(c(Nombre.del.técnico),~ifelse(str_detect(.,'CARMEN'),'J CARMEN MARTINEZ GARCIA',.))) %>% 
  mutate(across(c(Nombre.del.técnico),~ifelse(str_detect(.,'ERNESTO'),'ERNESTO ALONSO PAEZ CORRALES',.))) %>% 
  mutate(across(c(Nombre.del.técnico),~ifelse(str_detect(.,'FRANCISCO A'),'FRANCISCO ANTONIO LOPEZ OLGUIN',.))) %>% 
  mutate(across(c(Nombre.del.técnico),~ifelse(str_detect(.,'FRANCISCO H'),'FRANCISCO HIDALGO LOPEZ',.))) %>% 
  mutate(across(c(Nombre.del.técnico),~ifelse(str_detect(.,'RAUL'),'RAUL ALAM MARTINEZ GARCIA',.))) %>% 
  mutate(across(c(Nombre.del.técnico),~str_replace_all(.,'NULL',NA_character_))) %>% 
  mutate(across(c(`Modelo.ó.descripcion.corta.del.implemento.(opcional,.ejemplo:.fertilizadora.de.2.cuerpos.de.discos.de.cortes)`),~ifelse(str_detect(.,'NULL|NA|DESCONOCIDO|NO SE SABE|NO SABE|N/A|NO SE VE|DESCONOCE|SIN DATO|N/D|NO APLICA|S/IN|S/INF|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,|NO  SE TIENEN DATOS EXACTOS |NO SE TIENE EL DATO|PENDIENTE|SN|DESC0NOCIDO |DESCO|DESCONOOCIDO|DESONOCIDO|NA SE SABE|NINGUNO|NO HAY DATO|NO SE SAE|SIN ESPECIFICAR|SIN NOMBRE|S/M|DESC|S/N|SIN INFORMACION|SIN MARCA|SIN MODELO'),NA_character_,.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),trimws)) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'JON|JO|JH|JD'),'JOHN DEERE',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'MAS'),'MASSEY FERGUSON',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'PRO'),'MARCA PROPIA',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'MARCA|DESCONOCE|SN|NO RECUERDA|NO TIENE|NINGUNO|NO'),'SIN MARCA',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'SW'),'SWISSMEX',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'DOBLADENCE|DOBLADENSE|DOBALDENSE|DODLADENSE'),'DOBLADENSE',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'VAZQUEZ'),'VAZQUEZ',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'FAMAQ|FAMAC'),'FAMAQ',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'HOL'),'NEW HOLLAND',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'INTE'),'INTERNACIONAL',.))) %>% 
  mutate(across(c(`Marca.del.implemento.(opcional)`),~ifelse(str_detect(.,'BAJIO'),'SEMBRADORA DEL BAJIO',.)))

# write.xlsx(harvest_F,'3.-Labor and harvest, activities. + testigo_february2024_clean.xlsx')  

harves_F <- openxlsx::read.xlsx('3.-Labor and harvest, activities. + testigo_february2024_clean.xlsx')

output <- harves_F
colnames(output) <- c('Farmer.ID','Plot.ID','Log.Id','Plot.Type','State','Year','Cycle','Hydric.Regime','Id.Agronomic.Cycle.Type','Surface.type',
                      'Activity.ID','Group.Activity','Tillage.Land','Tillage.BEM','Performed.Activity','Performed.Activity_Date','Power.Source','X','Animal.employed',
                      'Total.cost.Activity.MXN.ha_Animal','Type.Cost','Hours.Activity.Lasted.hr.ha','No.Implements.used','Implement.used_Animal1','The.implement.is.1',
                      'How.was.the.implement.obtained?','Implement.code.type','Implement.code','Implement.used_Animal2','Other.Implement','The.implement.is.2','Total.cost_Motorized.MXN.ha',
                      'Implement.used_Motorized1','The.implement.is.M1','Tractor.type','Horsepower','Implement.Brand','Model.description','Years.of.Age.Implement','Hours.Activity.Lasted.hr.ha_Motor',
                      'Who.performs.operation?','Labor.Cost.MXN.ha','Labor.Cost.Type','Fuel.Consumption.L.ha_Motor1','Fuel.Cost.MXN.L_Motor1','Fuel.Cost.Type','Maintenance.Cost.or.Recovery.Fee.MXN.ha',
                      'How.was.the.implement.obtained?_Motor','Implement.code_Motor','Machinery.Point.Name','Technician.Name','Other.Origin.Implement','Implement.Rental.Cost.MXN',
                      'Rental.Cost.Includes.the.implement.operation?','Was.an.operator.hired?','Amount.paid.to.operator.MXN','Cost.per','Rental.Cost.includes.transport.of.implements.to.plot?',
                      'Was.paid.extra.for.transport?','Amount.paid.for.transport.MXN','Rental.Cost.include.fuel?','Was.paid.extra.for.fuel?','Fuel.Consumption.L.ha_Motor2','Fuel.Cost.MXN.L_Motor2',
                      'Were.implements.used?_Man','No.Implements.used_Man','Implement.used_Man1','Implement.used_Man2','Implement.used_Man3','Implement.used_Man4','Implement.used_Man5',
                      'No.people.who.participated.in.the.work','Daily.wage.cost.per.person.MXN','Worked.shifts','Duration.of.shift.work.day.hr','Hours.Activity.Lasted.hr.ha_Man1','Total.Cost.Labor.MXN.ha_Man',
                      'Type.Cost_Man','Total.Cost.Labor.MXN.ha','Input.application.tool','Application.time','Crop.No_Sowing','Crop.Name_Sowing','Mgmt.Type_Soil_Prep','Cat.of.work.carried.out_Conser_of_BioW&S',
                      'How.often.is.the.operation.performed?_Conser_of_BioW&S','Time.unit_Conser_of_BioW&S','Activity.desc_Conser_of_BioW&S','Performed.Activity_Conser_of_BioW&S','Crop.Residue.Destination_last_season',
                      'Field.grazing.perc_last_season','Burned.perc_last_season','Incorporated.perc_last_season','Chopped.and.left.for.coverage.perc_last_season','Detained.for.coverage.perc_last_season',
                      'Removed.from.plot.baled.in.nunches.perc_last_season','Type.of.weed.to.control','Reason.for.physical.weed.control','General.Harvest.ID','No.Harvest.activities.carried.out','Activity.Number',
                      'Was.this.harvesting.activity.carried.out.for.Crop.1?','Was.this.harvesting.activity.carried.out.for.Crop.2?','Was.this.harvesting.activity.carried.out.for.Crop.3?',
                      'Total.Cost.Seed.at.market.place.MXN.ha_Sowing','Transportation.Cost.MXN.ha_Sowing_inputs','Seeding.Machine.Type','No.Seeding.Machine.components_Sowing','Application.Type.Name_inputs',
                      'Log.ID_Sowing','Sowing.ID','Crop.related.to.harvest.activity','Days.spent.in.activity_Manual_Harvest','Factors.that.impacted.the.harvest','Enviromental.Factors','Mgmt.Factors',
                      'Field.grazing.perc_Harvest','Burned.perc_Harvest','Incorporated.perc_Harvest','Chopped.and.left.for.coverage.perc_Harvest','Detained.for.coverage.perc_Harvest',
                      'Removed.from.plot.baled.in.nunches.perc_Harvest')

output<-output %>% 
  mutate(Plot.Type=ifelse(Plot.Type=='AREA DE EXTENSION','EXTENSION AREA',ifelse(Plot.Type=='MODULO','MODULE',Plot.Type))) %>% 
  mutate(Cycle=ifelse(Cycle=='OTONO-INVIERNO','AUTUMN WINTER',ifelse(Cycle=='PRIMAVERA-VERANO','SPRING SUMMER',Cycle))) %>% 
  mutate(Hydric.Regime=ifelse(Hydric.Regime%in%c('RIEGO'),'IRRIGATION',ifelse(Hydric.Regime=='TEMPORAL','RAINFED',Hydric.Regime))) %>% 
  mutate(Surface.type=ifelse(Surface.type=='PARCELA INNOVACION','INNOVATION',ifelse(Surface.type=='PARCELA TESTIGO','CONTROL',Surface.type))) %>% 
  mutate(Group.Activity=ifelse(grepl('INSUMOS',Group.Activity),'INPUT APPLICATION',
                               ifelse(grepl('CONSERVACION',Group.Activity),'CONSERVATION OF BIODIVERSITY, WATER AND SOIL',
                                      ifelse(grepl('LABORES',Group.Activity),'CULTURAL PRACTICES AND PHYSICAL WEED CONTROL',
                                             ifelse(grepl('MANUAL',Group.Activity),'MANUAL HARVEST',
                                                    ifelse(grepl('MOTORIZADA',Group.Activity),'MOTORIZED HARVEST',
                                                           ifelse(grepl('CURVAS',Group.Activity),'SLOPE CURVES',
                                                                  ifelse(grepl('FISICO',Group.Activity),'PHYSICAL WEED CONTROL',
                                                                         ifelse(grepl('NIVELACION',Group.Activity),'SOIL LEVELING',
                                                                                ifelse(grepl('PREPARACION',Group.Activity),'MECHANICAL SOIL PREPARATION',
                                                                                       ifelse(grepl('SIEMBRA',Group.Activity),'SOWING',Group.Activity))))))))))) %>% 
  mutate(Tillage.Land=replace(Tillage.Land,agrep('TRADICIONAL',Tillage.Land),'TRADITIONAL TILLAGE')) %>% 
  mutate(Tillage.Land=replace(Tillage.Land,agrep('MINIMA',Tillage.Land),'MINIMUM-REDUCED TILLAGE')) %>%
  mutate(Tillage.Land=replace(Tillage.Land,agrep('AGRICULTURA',Tillage.Land),'MINIMUM-REDUCED TILLAGE')) %>%
  mutate(Tillage.Land=replace(Tillage.Land,agrep('CERO',Tillage.Land),'ZERO TILLAGE')) %>% 
  mutate(Tillage.BEM=replace(Tillage.BEM,agrep('TRADICIONAL',Tillage.BEM),'TRADITIONAL TILLAGE')) %>% 
  mutate(Tillage.BEM=replace(Tillage.BEM,agrep('MINIMA',Tillage.BEM),'MINIMUM-REDUCED TILLAGE')) %>%
  mutate(Tillage.BEM=replace(Tillage.BEM,agrep('AGRICULTURA',Tillage.BEM),'MINIMUM-REDUCED TILLAGE')) %>%
  mutate(Tillage.BEM=replace(Tillage.BEM,agrep('CERO',Tillage.BEM),'ZERO TILLAGE')) %>% 
  mutate(Power.Source=ifelse(Power.Source=='OTRO','OTHER',ifelse(grepl('MOTORIZADO',Power.Source),str_replace_all(Power.Source,'MOTORIZADO','MOTORIZED'),Power.Source))) %>% 
  mutate(X=ifelse(X=='BUEYES','OXEN',ifelse(X=='CABALLO','HORSE',ifelse(X=='MULA','MULE',X)))) %>% 
  mutate(Animal.employed=ifelse(grepl('CABALLO',Animal.employed),'HORSE',ifelse(Animal.employed=='BUEYES','OXEN',ifelse(Animal.employed=='BURRO','DONKEY',ifelse(Animal.employed=='MULA','MULE',Animal.employed))))) %>% 
  mutate(Type.Cost=ifelse(Type.Cost=='ESTIMADO','ESTIMATED',ifelse(Type.Cost=='PAGADO','PAID',Type.Cost))) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('CINCEL',Implement.used_Animal1),'CHISEL PLOW')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('EGIPCIO',Implement.used_Animal1),'EGYPTIAN PLOW')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('VERTEDERA',Implement.used_Animal1),'MOULDBOARD PLOW')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('DE DISCO',Implement.used_Animal1),'DISC PLOW')) %>%
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('VERTICAL',Implement.used_Animal1),'ANIMAL DRAWN SEEDER (VERTICAL DISC)')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('INCLINADO',Implement.used_Animal1),'ANIMAL DRAWN SEEDER (INCLINED DISC)')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('HORIZONTAL',Implement.used_Animal1),'ANIMAL DRAWN SEEDER (HORIZONTAL DISC)')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('OTRO',Implement.used_Animal1),'OTHER')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('NIVELADOR DE MADERA',Implement.used_Animal1),'WOOD LEVELER')) %>% 
  #mutate(Implement.used_Animal1=gsub("(TRADICIONAL).*","\\1",Implement.used_Animal1)) %>% 
  mutate(Implement.used_Animal1=str_replace_all(Implement.used_Animal1,'ARADO TRADICIONAL','TRADITIONAL PLOW')) %>% 
  mutate(Implement.used_Animal1=ifelse(Implement.used_Animal1%in%c('ARADO','ARADO DE MADERA','ARADO DE PALO','ARADO ARTESANAL','ARADO DE PUNTA','YUGO'),'TRADITIONAL PLOW',Implement.used_Animal1)) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('YUNTA',Implement.used_Animal1),'TRADITIONAL PLOW')) %>% 
  mutate(Implement.used_Animal1=replace(Implement.used_Animal1,agrep('ATRACCION',Implement.used_Animal1),'TRADITIONAL PLOW')) %>% 
  mutate(Implement.used_Animal1=ifelse(Implement.used_Animal1=='NIVELADORA','LEVELER',Implement.used_Animal1)) %>% 
  mutate(Implement.used_Animal1=ifelse(Implement.used_Animal1=='RASTRA','HARROW',Implement.used_Animal1)) %>% 
  mutate(Implement.used_Animal1=ifelse(Implement.used_Animal1=='CULTIVADORA TIRO ANIMAL','ANIMAL DRAFT SEEDER',Implement.used_Animal1))


# openxlsx::write.xlsx(output,'3.-Labor and harvest, activities. + testigo_february2024_clean_eng.xlsx')

irrigation <- read.xlsx('5.-Irrigacion_ + testigo_022024.xlsx',startRow = 2,detectDates = T)

colnames(irrigation) <- make.unique(colnames(irrigation))

irrigation_S <- irrigation %>% 
  mutate(Estado=str_to_upper(Estado)) %>% 
  mutate(Municipio=str_to_upper(Municipio)) %>% 
  mutate(Régimen.hídrico=ifelse(Régimen.hídrico=='PUNTA DE RIEGO','RIEGO',Régimen.hídrico)) %>% 
  mutate(Tipo.de.riego=replace(Tipo.de.riego,agrep('ASPERSION',Tipo.de.riego),'RIEGO POR ASPERSION')) %>% 
  mutate(Tipo.de.riego=replace(Tipo.de.riego,agrep('GRAVEDAD',Tipo.de.riego),'RIEGO POR GRAVEDAD')) %>% 
  mutate(Tipo.de.riego=replace(Tipo.de.riego,agrep('GOTEO',Tipo.de.riego),'RIEGO POR GOTEO')) %>% 
  mutate(Tipo.de.riego=ifelse(grepl('RODADO|INUNDACION|RIO|TUBO|BOMBA',Tipo.de.riego),'RIEGO POR GRAVEDAD',Tipo.de.riego)) %>% 
  mutate(Tipo.de.riego=replace(Tipo.de.riego,agrep('COMPUERTA',Tipo.de.riego),'RIEGO POR GRAVEDAD')) %>% #FALTA TERMINAR DE CATEGORIZAR ALGUNOS PERO PRIMERO PREGUNTAR
  mutate(Tipo.de.riego=ifelse(grepl('PIVOTE',Tipo.de.riego),'RIEGO POR ASPERSION',Tipo.de.riego)) %>% 
  mutate(Fuente.del.agua=replace(Fuente.del.agua,agrep('RESIDUAL',Fuente.del.agua),'AGUAS RESIDUALES ( EJ. INDUSTRIALES Y/O DE USO DOMESTICO)')) %>% 
  mutate(Fuente.del.agua=replace(Fuente.del.agua,agrep('INDUSTRIALES',Fuente.del.agua),'AGUAS RESIDUALES ( EJ. INDUSTRIALES Y/O DE USO DOMESTICO)')) %>% 
  mutate(Fuente.del.agua=ifelse(grepl('LLUVIA|REPRESA|CAPTACION|CANAL|CANALES|BORDO',Fuente.del.agua),'CAPTACION DE LLUVIA (EJ. PRESAS, JAGUEYES, OLLAS DE AGUA)',Fuente.del.agua)) %>% 
  mutate(Fuente.del.agua=ifelse(grepl('SUBTERRANEAS|POZO',Fuente.del.agua),'FUENTES SUBTERRANEAS (EJ. POZOS)',Fuente.del.agua)) %>% 
  mutate(Fuente.del.agua=ifelse(grepl('SUPERFICIALES|RIO|LAGO|AGUANAVAL|MANANTIAL|NAZAS|ARROYO|NACIMIENTO',Fuente.del.agua),'FUENTES SUPERFICIALES (EJ. RIOS, LAGOS, LAGUNAS)',Fuente.del.agua)) %>% 
  mutate(Fuente.del.agua=ifelse(grepl('TURBIAS|REUSADAS|TRATADA|ALBERCAS',Fuente.del.agua),'AGUAS RESIDUALES ( EJ. INDUSTRIALES Y/O DE USO DOMESTICO)',Fuente.del.agua)) %>% 
  mutate(Sistema.de.riego=ifelse(grepl('CANON',Sistema.de.riego),'CANON_DE_RIEGO',Sistema.de.riego)) %>% 
  mutate(Sistema.de.riego=ifelse(grepl('INUNDACION|RODADO',Sistema.de.riego),'RIEGO POR GRAVEDAD',Sistema.de.riego)) %>% 
  mutate(Sistema.de.riego=ifelse(grepl('SIFONES|TUBO',Sistema.de.riego),'CONDUCCION CON TUBO (PLASTICO)',Sistema.de.riego)) %>% 
  mutate(Sistema.de.riego=ifelse(grepl('MICROASPERSORES',Sistema.de.riego),'MICROASPERSORES_EN_MANGUERA',Sistema.de.riego)) %>% 
  mutate(Sistema.de.riego=str_replace_all(Sistema.de.riego,'_',' ')) %>% 
  mutate_at(c(13,20:21,23:31,36:40,42:47),as.numeric) %>% 
  mutate(`Tirada.del.riego.(m)`=ifelse(`Tirada.del.riego.(m)`>650,NA,`Tirada.del.riego.(m)`)) %>% 
  mutate(`¿Cuantos.dias.realizo.este.riego.durante.el.periodo.indicado.en.las.fechas.de.inicio.y.termino?`=ifelse(`¿Cuantos.dias.realizo.este.riego.durante.el.periodo.indicado.en.las.fechas.de.inicio.y.termino?`>100,NA,`¿Cuantos.dias.realizo.este.riego.durante.el.periodo.indicado.en.las.fechas.de.inicio.y.termino?`)) %>% 
  mutate(X22=str_replace_all(X22,'_',' ')) %>% 
  mutate(X24=ifelse(X24>20,NA,X24)) %>% 
  mutate(`Tiempo.de.riego.(hr/ha)`=ifelse(`Tiempo.de.riego.(hr/ha)`>48,NA,`Tiempo.de.riego.(hr/ha)`)) %>% 
  mutate(`Tiempo.de.promedio.de.riego.(hr/ha)`=ifelse(`Tiempo.de.promedio.de.riego.(hr/ha)`>48,NA,`Tiempo.de.promedio.de.riego.(hr/ha)`)) %>% 
  mutate(`Consumo.de.agua.(lt/hr)`=ifelse(Tipo.de.riego=='RIEGO POR ASPERSION' & (`Consumo.de.agua.(lt/hr)`<10000 | `Consumo.de.agua.(lt/hr)`>150000),NA,`Consumo.de.agua.(lt/hr)`)) %>% 
  mutate(`Consumo.de.agua.(lt/hr)`=ifelse(Tipo.de.riego=='RIEGO POR GOTEO' & (`Consumo.de.agua.(lt/hr)`<900 | `Consumo.de.agua.(lt/hr)`>150000),NA,`Consumo.de.agua.(lt/hr)`)) %>% 
  mutate(`Consumo.de.agua.(lt/hr)`=ifelse(Tipo.de.riego=='RIEGO POR GRAVEDAD' & (`Consumo.de.agua.(lt/hr)`<5000 | `Consumo.de.agua.(lt/hr)`>800000),NA,`Consumo.de.agua.(lt/hr)`)) %>% 
  mutate(`Consumo.total.de.agua.por.riego.(lt/ha)`=ifelse(Tipo.de.riego=='RIEGO POR ASPERSION' & (`Consumo.total.de.agua.por.riego.(lt/ha)`<1000|`Consumo.total.de.agua.por.riego.(lt/ha)`)>150000,NA,`Consumo.total.de.agua.por.riego.(lt/ha)`)) %>% 
  mutate(`Consumo.total.de.agua.por.riego.(lt/ha)`=ifelse(Tipo.de.riego=='RIEGO POR GOTEO' & (`Consumo.total.de.agua.por.riego.(lt/ha)`<900|`Consumo.total.de.agua.por.riego.(lt/ha)`)>150000,NA,`Consumo.total.de.agua.por.riego.(lt/ha)`)) %>% 
  mutate(`Consumo.total.de.agua.por.riego.(lt/ha)`=ifelse(Tipo.de.riego=='RIEGO POR GRAVEDAD' & (`Consumo.total.de.agua.por.riego.(lt/ha)`<5000|`Consumo.total.de.agua.por.riego.(lt/ha)`)>800000,NA,`Consumo.total.de.agua.por.riego.(lt/ha)`)) %>% 
  mutate(`Costo.total.del.agua.por.riego.($/ha)`=ifelse(`Costo.total.del.agua.por.riego.($/ha)`>2500,NA,`Costo.total.del.agua.por.riego.($/ha)`)) %>% 
  mutate(`Costo.por.consumo.electrico.de.las.bombas.($/hr)`=ifelse(`Costo.por.consumo.electrico.de.las.bombas.($/hr)`>=500,NA,`Costo.por.consumo.electrico.de.las.bombas.($/hr)`)) %>% 
  mutate(`Costo.total.por.consumo.electrico.de.las.bombas.($/ha)`=ifelse(`Costo.total.por.consumo.electrico.de.las.bombas.($/ha)`>500,NA,`Costo.total.por.consumo.electrico.de.las.bombas.($/ha)`)) %>% 
  mutate(Numero.de.personas.que.participaron.en.la.labor=ifelse(Numero.de.personas.que.participaron.en.la.labor>10,NA,Numero.de.personas.que.participaron.en.la.labor)) %>% 
  mutate(`Costo.del.jornal.por.dia.($)`=ifelse(`Costo.del.jornal.por.dia.($)`<50|`Costo.del.jornal.por.dia.($)`>1500,NA,`Costo.del.jornal.por.dia.($)`)) %>% 
  mutate(Jornadas.utilizadas=ifelse(Jornadas.utilizadas>15,NA,Jornadas.utilizadas)) %>% 
  mutate(`Duraci?n.del.jornal/dia.(hr/ha)`=ifelse(`Duraci?n.del.jornal/dia.(hr/ha)`>24,NA,`Duraci?n.del.jornal/dia.(hr/ha)`)) %>% 
  mutate(`Tiempo.en.que.se.completo.la.actividad.(hr/ha)`=ifelse(`Tiempo.en.que.se.completo.la.actividad.(hr/ha)`>12,NA,`Tiempo.en.que.se.completo.la.actividad.(hr/ha)`)) %>% 
  mutate(`Costo.total.de.la.labor.($/ha)`=ifelse(`Costo.total.de.la.labor.($/ha)`>2000,NA,`Costo.total.de.la.labor.($/ha)`))

# write.xlsx(irrigation_S,'5.-Irrigacion_ + testigo_022024_clean.xlsx')

costos <- read.xlsx('6.-Costs and revenues_+ testigo 022024_.xlsx',startRow = 2,detectDates = T)

colnames(costos) <- make.unique(colnames(costos))

costos_F <- costos %>% 
  mutate(State=str_to_upper(State)) %>% 
  mutate(Municipality=str_to_upper(Municipality)) %>% 
  mutate(Hydric.Regime=ifelse(Hydric.Regime=="PUNTA DE RIEGO","RIEGO",Hydric.Regime)) %>% 
  mutate(Mechanical.soil.preparation.=ifelse(Mechanical.soil.preparation.<100|Mechanical.soil.preparation.>8000,NA,Mechanical.soil.preparation.)) %>% 
  mutate(`Sowing.(activity.and.seed)`=ifelse(`Sowing.(activity.and.seed)`<15|`Sowing.(activity.and.seed)`>10000,NA,`Sowing.(activity.and.seed)`)) %>% 
  mutate(Soil.analysis=ifelse(Soil.analysis<100|Soil.analysis>2000,NA,Soil.analysis)) %>% 
  mutate(Cultural.work.and.physical.control.of.weeds.=ifelse(Cultural.work.and.physical.control.of.weeds.<25|Cultural.work.and.physical.control.of.weeds.>5000,NA,Cultural.work.and.physical.control.of.weeds.)) %>% 
  mutate(Application.of.inputs=ifelse(Application.of.inputs<3000|Application.of.inputs>30000,NA,Application.of.inputs)) %>% 
  mutate(Irrigation=ifelse(Irrigation<150|Irrigation>10000,NA,Irrigation)) %>% 
  mutate(Harvest.done.by.hand=ifelse(Harvest.done.by.hand<100|Harvest.done.by.hand>7000,NA,Harvest.done.by.hand)) %>% 
  mutate(Mechanical.harvest=ifelse(Mechanical.harvest<200|Mechanical.harvest>6000,NA,Mechanical.harvest)) %>% 
  mutate(Commercialization=ifelse(Commercialization<100|Commercialization>5000,NA,Commercialization)) %>% 
  mutate(Indirect.expenses=ifelse(Indirect.expenses<150|Indirect.expenses>15000,NA,Indirect.expenses)) %>% 
  mutate(Mechanical.soil.preparation..1=ifelse(Mechanical.soil.preparation..1<100|Mechanical.soil.preparation..1>8000,NA,Mechanical.soil.preparation..1)) %>% 
  mutate(`Sowing.(activity.and.seed).1`=ifelse(`Sowing.(activity.and.seed).1`<15|`Sowing.(activity.and.seed).1`>10000,NA,`Sowing.(activity.and.seed).1`)) %>% 
  mutate(Soil.analysis.1=ifelse(Soil.analysis.1<100|Soil.analysis.1>2000,NA,Soil.analysis.1)) %>% 
  mutate(Water.analysis.1=ifelse(Water.analysis.1>1800,NA,Water.analysis.1)) %>% 
  mutate(Cultural.work.and.physical.control.of.weeds..1=ifelse(Cultural.work.and.physical.control.of.weeds..1<25|Cultural.work.and.physical.control.of.weeds..1>5000,NA,Cultural.work.and.physical.control.of.weeds..1)) %>% 
  mutate(Application.of.inputs.1=ifelse(Application.of.inputs.1<3000|Application.of.inputs.1>30000,NA,Application.of.inputs.1)) %>% 
  mutate(Irrigation.1=ifelse(Irrigation.1<150|Irrigation.1>10000,NA,Irrigation.1)) %>% 
  mutate(Harvest.done.by.hand.1=ifelse(Harvest.done.by.hand.1<100|Harvest.done.by.hand.1>7000,NA,Harvest.done.by.hand.1)) %>% 
  mutate(Mechanical.harvest.1=ifelse(Mechanical.harvest.1<200|Mechanical.harvest.1>6000,NA,Mechanical.harvest.1)) %>% 
  mutate(Commercialization.1=ifelse(Commercialization.1<100|Commercialization.1>5000,NA,Commercialization.1)) %>% 
  mutate(Indirect.expenses.1=ifelse(Indirect.expenses.1<150|Indirect.expenses.1>15000,NA,Indirect.expenses.1)) %>% 
  mutate(`Income.($/ha)`=ifelse(`Income.($/ha)`<2000|`Income.($/ha)`>65000,NA,`Income.($/ha)`)) %>% 
  mutate(`Income.($/ha).1`=ifelse(`Income.($/ha).1`<2000|`Income.($/ha).1`>65000,NA,`Income.($/ha).1`)) %>% 
  rowwise() %>% 
  mutate(`Total.costs.($/ha)_Inn`=sum(c_across(Mechanical.soil.preparation.:Indirect.expenses),na.rm = T)) %>% 
  mutate(`Total.costs.($/ha).1_Tes`=sum(c_across(Mechanical.soil.preparation..1:Indirect.expenses.1),na.rm = T))

# drop duplicate words in the same chain
costos_F$Harvested.Crops<-sapply(strsplit(as.character(costos_F$Harvested.Crops), ", "), function(x) paste(unique(x), collapse=", "))
costos_F$Harvested.Crops.1<-sapply(strsplit(as.character(costos_F$Harvested.Crops.1), ", "), function(x) paste(unique(x), collapse=", "))

# write.xlsx(costos_F,'6.-Costs and revenues_+ testigo 022024_clean.xlsx')

#-------irrigation eng ver-----

Irrigation_E <- irrigation_S

Irrigation_E <- Irrigation_E %>% 
  mutate(Tipo.de.parcela=ifelse(Tipo.de.parcela=="AREA DE EXTENSION",'EXTENSION AREA',ifelse(Tipo.de.parcela=="MODULO",'MODULE',Tipo.de.parcela))) %>% 
  mutate(Ciclo=ifelse(Ciclo=='OTONO-INVIERNO','AUTUMN WINTER',ifelse(Ciclo=='PRIMAVERA-VERANO','SPRING SUMMER',Ciclo))) %>% 
  mutate(Régimen.hídrico=ifelse(Régimen.hídrico%in%c('RIEGO'),'IRRIGATION',ifelse(Régimen.hídrico=='TEMPORAL','RAINFED',Régimen.hídrico))) %>% 
  mutate(Tipo.de.superficie=ifelse(Tipo.de.superficie=='PARCELA INNOVACION','INNOVATION',ifelse(Tipo.de.superficie=='PARCELA TESTIGO','CONTROL',Tipo.de.superficie))) %>% 
  mutate(Tipo.de.riego=ifelse(Tipo.de.riego=='RIEGO POR GRAVEDAD','SURFACE IRRIGATION',ifelse(Tipo.de.riego=='RIEGO POR ASPERSION','SPRINKLER IRRIGATION',ifelse(Tipo.de.riego=='RIEGO POR GOTEO','DRIP IRRIGATION',Tipo.de.riego)))) %>% 
  mutate(Sistema.de.riego=ifelse(Sistema.de.riego=='ASPERSION','SPRINKLER IRRIGATION',
                                 ifelse(Sistema.de.riego=='AVANCE FRONTAL','LINEAR MOVE SPRINKLER IRRIGATION',
                                        ifelse(Sistema.de.riego=='BOMBEO','PUMPED IRRIGATION SYSTEM',
                                               ifelse(Sistema.de.riego=='CANAL DE RIEGO','IRRIGATION CANAL',
                                                      ifelse(Sistema.de.riego=='CANALETA','FURROW IRRIGATION SYSTEM',
                                                             ifelse(Sistema.de.riego=='GOTEO','DRIP',
                                                                    ifelse(Sistema.de.riego=='GOTEROS EN CINTILLA','TAPE DRIPPERS',
                                                                           ifelse(Sistema.de.riego=='GOTEROS EN MANGUERA','HOSE DRIPPERS',
                                                                                  ifelse(Sistema.de.riego=='MICROASPERSORES EN MANGUERA','HOSE MICRO SPRINKLERS',
                                                                                         ifelse(Sistema.de.riego=='PIVOTE CENTRAL','CENTER PIVOT',
                                                                                                ifelse(Sistema.de.riego=='POR COMPUERTAS','GATE IRRIGATION SYSTEM',
                                                                                                       ifelse(Sistema.de.riego=='RIEGO POR GRAVEDAD','SURFACE IRRIGATION',
                                                                                                              ifelse(Sistema.de.riego=='CANON DE RIEGO','BIG GUN IRRIGATION',
                                                                                                                     ifelse(Sistema.de.riego=='CONDUCCION CON TUBO (PLASTICO)','SUBSURFACE PIPE IRRIGATION',Sistema.de.riego))))))))))))))) %>% 
  mutate(Fuente.del.agua=ifelse(Fuente.del.agua=='AGUAS RESIDUALES ( EJ. INDUSTRIALES Y/O DE USO DOMESTICO)','WASTEWATER (E.G. INDUSTRIAL AND/OR DOMESTIC USE)',
                                ifelse(Fuente.del.agua=="CAPTACION DE LLUVIA (EJ. PRESAS, JAGUEYES, OLLAS DE AGUA)",'RAIN COLLECTION (E.G. DAMS, JAGUEYES, WATER POTS)',
                                       ifelse(Fuente.del.agua=="FUENTES SUBTERRANEAS (EJ. POZOS)",'SUBTERRANEAN SOURCES (E.G. WELLS)',
                                              ifelse(Fuente.del.agua=='FUENTES SUPERFICIALES (EJ. RIOS, LAGOS, LAGUNAS)','SURFACE SOURCES (E.G. RIVERS, LAKES, LAGOONS)',
                                                     ifelse(Fuente.del.agua=='OTRO (ESPECIFIQUE)','OTHER',
                                                            ifelse(Fuente.del.agua=='DISTRITO DE RIEGO','WATER DISTRICT',
                                                                   ifelse(Fuente.del.agua=='BORDO','RAIN COLLECTION (E.G. DAMS, JAGUEYES, WATER POTS)',Fuente.del.agua)))))))) %>% 
  mutate(X22=ifelse(X22=='AVANCE FRONTAL','LINEAR MOVE SPRINKLER IRRIGATION',ifelse(X22=='PIVOTE CENTRAL','CENTER PIVOT',ifelse(X22=='MICROASPERSORES EN CINTILLA','TAPE MICRO SPRINKLERS',ifelse(X22=='"MICROASPERSORES EN MANGUERA','HOSE MICRO SPRINKLERS',X22))))) %>%
  mutate_all(~case_when(grepl('ESTIMADO',.)~'ESTIMATED',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('PAGADO',.)~'PAID',TRUE~as.character(.))) %>% 
  mutate(`?Utilizo.bombas?`=ifelse(`?Utilizo.bombas?`=='SI','YES',`?Utilizo.bombas?`)) %>% 
  mutate(Fuente.de.energia.de.las.bombas=ifelse(Fuente.de.energia.de.las.bombas=='COMBUSTIBLE','FUEL',ifelse(Fuente.de.energia.de.las.bombas=='ELECTRICIDAD','ELECTRICITY',Fuente.de.energia.de.las.bombas))) %>% 
  mutate(`?El.costo.del.agua.incluyo.consumo.de.electricidad/combustible?`=ifelse(`?El.costo.del.agua.incluyo.consumo.de.electricidad/combustible?`=='SI','YES',`?El.costo.del.agua.incluyo.consumo.de.electricidad/combustible?`))

# write.xlsx(Irrigation_E,'5.-Irrigacion_ + testigo_022024_clean_eng.xlsx')

#-----costs eng ver----
costos_E <- costos_F

costos_E <- costos_E %>% 
  mutate(Plot.type=ifelse(Plot.type=='AREA DE EXTENSION','EXTENSION AREA',ifelse(Plot.type=='MODULO','MODULE',Plot.type))) %>% 
  mutate(Cycle=ifelse(Cycle=='OTONO-INVIERNO','AUTUMN WINTER',ifelse(Cycle=='PRIMAVERA-VERANO','SPRING SUMMER',Cycle))) %>% 
  mutate(Hydric.Regime=ifelse(Hydric.Regime=='RIEGO','IRRIGATION',ifelse(Hydric.Regime=='TEMPORAL','RAINFED',Hydric.Regime))) %>% 
  mutate_all(~case_when(grepl('INNOVATION',.)~'INNOVATION',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CONTROL',.)~'CONTROL',TRUE~as.character(.))) 

costos_EX <- as.data.frame(str_split_fixed(costos_E$Harvested.Crops,", ",n=Inf))
costos_EX1 <- as.data.frame(str_split_fixed(costos_E$Harvested.Crops.1,", ",n=Inf))

costos_EX <- costos_EX %>% 
  mutate(across(c(V1:V8),trimws))

costos_EX1 <- costos_EX1 %>% 
  mutate(across(c(V1:V5),trimws)) %>% 
  rename_with(~ sub("^V", "Crop", .x), starts_with("V"))

Crops <- cbind(costos_EX,costos_EX1)

Crops <- Crops %>%  
  mutate_all(~case_when(grepl('AVENA + EBO + TRITICALE',.)~'OATMEAL, VETCH (VICIA SATIVA), TRITICALE',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('AVENA+EBO|AVENA + EBO|AVENA-EBO',.)~'OATMEAL, VETCH (VICIA SATIVA)',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('MEZCLA 1 (CANOLA + TREBOL + EBO)',.)~'MIX 1 (CANOLA, CLOVER, VETCH (VICIA SATIVA))',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('MAIZ|NUK NAAL|NAAL XOY|MILPA|AMARILLO',.)~'MAIZE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('FRIJOL MUNGO|MUNGO',.)~'MUNG BEAN',TRUE~as.character(.))) %>%  
  mutate_all(~case_when(grepl('TRIGO',.)~'WHEAT',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('SORGO',.)~'SORGHUM',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CEBADA',.)~'BARLEY',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('AVENA',.)~'OATMEAL',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CALABAZA|CHILACAYOTE|CHIHUA|CALABACITA',.)~'PUMPKIN',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CANAVALIA|CANNAVALIA',.)~'CANAVALIA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('GIRASOL',.)~'SUNFLOWER',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('GARBANZO',.)~'CHICKPEA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('SOYA',.)~'SOY',TRUE~as.character(.))) %>% 
  # mutate_all(~case_when(grepl('CHILE',.)~'CHILI',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CHILE',.)~'CHILI PEPPER',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('ALGODON',.)~'COTTON',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('ALFALFA',.)~'ALFALFA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('AGUACATE|AGUACTA',.)~'AVOCADO',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('AJO',.)~'GARLIC',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('LIMON',.)~'LEMON',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('NOGAL',.)~'WALNUT',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('AJONJOLI',.)~'SESAME',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CARTAMO',.)~'SAFFLOWER',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('HABA',.)~'BROAD BEAN',TRUE~as.character(.))) %>% 
  # mutate_all(~case_when(grepl('HIGUERILLA',.)~'CASTOR OIL PLANT',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('HIGUERILLA',.)~'CASTOR BEAN',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('SABILA',.)~'ALOE VERA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('OLIVO',.)~'OLIVE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('BROCOLI',.)~'BROCCOLI',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CHICHARO|VETCH (VICIA SATIVA)',.)~'PEA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CACAHUATE',.)~'PEANUT',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CEBOLLA',.)~'ONION',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CROTALARIA',.)~'RATTLEBOX',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CHIA',.)~'CHIA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('MANZANA',.)~'APPLE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('MILTOMATE|TOMATE DE CASCARA|CASCARA',.)~'HUSK TOMATO',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('JICAMA',.)~'JICAMA (PACHYRHIZUS EROSUS)',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('LENTEJA',.)~'LENTIL',TRUE~as.character(.))) %>% 
  # mutate_all(~case_when(grepl('CEMPASUCHIL|CEMPOALXOCHITL',.)~'CEMPASUCHIL (TAGETES ERECTA)',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CEMPASUCHIL|CEMPOALXOCHITL',.)~'MARIGOLD',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('FRESA',.)~'STRAWBERRY',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('JAMAICA',.)~'ROSELLE (HIBISCUS SABDARIFFA)',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('PAPA',.)~'POTATO',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CANA',.)~'CANE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('ARROZ',.)~'RICE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('VIGNA|BIGNA|CAUPI',.)~'VIGNA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('CENTENO',.)~'RYE',TRUE~as.character(.))) %>% 
  # mutate_all(~case_when(grepl('CHAYOTE',.)~'CHRISTOPHENE',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('CHAYOTE',.)~'CHAYOTE',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('CILANDRO|CILANTRO',.)~'CORIANDER',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('COCO',.)~'COCONUT',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('ZARZAMORA',.)~'BLACKBERRY',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('QUINOA|QUINUA',.)~'QUINOA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('AMARANTO',.)~'AMARANTH',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('IBES|IB|PHASEOLUS LUNATUS',.)~'IBES (PHASEOLUS LUNATUS)',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('RABANO',.)~'',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('JITOMATE ROJO|TOMATE|JITOMATE ROJO',.)~'TOMATO',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('PLATANO',.)~'BANANA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('MOSTAZA',.)~'MUSTARD',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('GUAYABA',.)~'GUAVA',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('FORRAJE',.)~'FORAGE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('AGAVE|MAGUEY',.)~'AGAVE MAGUEY',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('NARANJA',.)~'ORANGE',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('TITRICALE',.)~'TRITICALE',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('OTRO',.)~'OTHER CROP',TRUE~as.character(.))) %>%
  mutate_all(~case_when(grepl('SANDIA',.)~'WATERMELON',TRUE~as.character(.))) %>% 
  mutate_all(~case_when(grepl('PINA',.)~'PINEAPPLE',TRUE~as.character(.))) %>% 
  replace(.=='EBO','VETCH (VICIA SATIVA)') %>% 
  replace(.=='',NA) %>% 
  replace(.=='NA',NA) %>% 
  replace(.=='0',NA) %>% 
  replace(.=='MEZCLA 1 (CANOLA + TREBOL + EBO)','MIX 1 (CANOLA, CLOVER, VETCH (VICIA SATIVA))') %>% 
  replace(.=='PIPIAN',NA)

Crops <- Crops %>% 
  unite(Crops_T,contains('Crop'),na.rm = T,sep=", ",remove = F) %>% 
  unite(Crop_I,contains('V'),na.rm = T,sep = ', ',remove = F)

costos_E <- cbind(costos_E,Crops)

costos_E <- costos_E %>% 
  select(-c(V1:V8),-c(Crop1:Crop5))

costos_E <- costos_E %>% 
  select(1:26,45,27:28,47,29:42,46,43:44,48) %>% 
  replace(.=='',NA)

# write.xlsx(costos_E,'6.-Costs and revenues_+ testigo 022024_clean_eng.xlsx')

# supplies, inputs----

supplies <- read.xlsx('4.-Agricultural supplies + testigo_022024.xlsx',startRow = 2,sheet = 1,detectDates = T)

colnames(supplies) <- make.unique(colnames(supplies)) #377314

supplies_F <- supplies %>% 
  mutate(across(c(15:17,40),~iconv(.,from="UTF-8",to="ASCII//TRANSLIT"))) %>% 
  mutate(across(c(5,15:17,40),toupper)) %>% 
  mutate(across(c(5,15:17,19,31,40),trimws)) %>% 
  mutate(Hydric.Regime=ifelse(Hydric.Regime%in%c('PUNTA DE RIEGO','RIEGO'),'RIEGO',ifelse(Hydric.Regime=='TEMPORAL','RAINFED',Hydric.Regime))) %>% 
  mutate(Actividad.realizada=gsub(', $','',Actividad.realizada)) %>% 
  # mutate(Actividad.realizada=trimws(Actividad.realizada,whitespace = ', '))
  mutate(across(c(`¿Utilizo.alguna.herramienta.para.ajustar.su.dosis.de.fertilizante?`),~str_replace_all(.,',UNDEFINED',''))) %>% 
  mutate(across(c(Tipo.de.maleza.que.se.quiere.controlar,Número.de.plagas.que.quiere.controlar,Enfermedad.presentada,Parte.de.la.planta.dañada,`Porcentaje.(%).de.daño.en.la.planta.por.la.plaga.o.enfermedad`,`Porcentaje.del.cultivo.dañado.(%)`,Nombre.del.producto.aplicado,`Nitrógeno.(N)`,`Fósforo.(P)`,`Potasio.(K)`,`Otros.nutrientes.(Opcional)`,Ingrediente.Activo,Lugar.de.aplicación),~str_replace_all(.,'_',' '))) %>% 
  mutate(across(c(Tipo.de.maleza.que.se.quiere.controlar,Número.de.plagas.que.quiere.controlar,Enfermedad.presentada,Parte.de.la.planta.dañada,`Porcentaje.(%).de.daño.en.la.planta.por.la.plaga.o.enfermedad`,`Porcentaje.del.cultivo.dañado.(%)`,Nombre.del.producto.aplicado,`Nitrógeno.(N)`,`Fósforo.(P)`,`Potasio.(K)`,`Otros.nutrientes.(Opcional)`,Ingrediente.Activo,Lugar.de.aplicación),trimws)) %>% 
  replace(.=="",NA) %>% 
  mutate(`Unidad/ha`=ifelse(grepl('PAQUETE',`Unidad/ha`),'PAQUETE_HA',`Unidad/ha`)) %>% 
  mutate(`Unidad/ha`=ifelse(`Unidad/ha`%in%c('L','L/HA'),'L_HA',`Unidad/ha`)) %>% 
  mutate(`Unidad/ha`=ifelse(`Unidad/ha`=='KG','KG_HA',`Unidad/ha`)) %>% 
  mutate(`Unidad/ha`=ifelse(`Unidad/ha`=='KG/HA','KG_HA',`Unidad/ha`)) %>% 
  mutate(`Costo.unitario.($/unidad)`=ifelse(`Costo.unitario.($/unidad)`<50|`Costo.unitario.($/unidad)`>3000,NA,`Costo.unitario.($/unidad)`)) %>% 
  mutate_at(c(23,35:37,43:45,48,50),as.numeric) %>% 
  mutate(`Potasio.(K)`=ifelse(`Potasio.(K)`>100,NA,`Potasio.(K)`)) %>% 
  mutate(Cantidad.de.producto.aplicado=ifelse((Cantidad.de.producto.aplicado<0.5|Cantidad.de.producto.aplicado>600) & `Unidad/ha`=='KG_HA',NA,Cantidad.de.producto.aplicado)) %>% 
  mutate(Cantidad.de.producto.aplicado=ifelse((Cantidad.de.producto.aplicado<0.5|Cantidad.de.producto.aplicado>1000) & `Unidad/ha`=='KG_PLANTA',NA,Cantidad.de.producto.aplicado)) %>% 
  mutate(Cantidad.de.producto.aplicado=ifelse((Cantidad.de.producto.aplicado<0.5|Cantidad.de.producto.aplicado>200) & `Unidad/ha`=='L_HA',NA,Cantidad.de.producto.aplicado)) %>% 
  mutate(Cantidad.de.producto.aplicado=ifelse((Cantidad.de.producto.aplicado<0.5|Cantidad.de.producto.aplicado>30) & `Unidad/ha`=='PAQUETE_HA',NA,Cantidad.de.producto.aplicado)) %>% 
  mutate(Cantidad.de.producto.aplicado=ifelse((Cantidad.de.producto.aplicado<0.5|Cantidad.de.producto.aplicado>30) & `Unidad/ha`=='PIEZAS',NA,Cantidad.de.producto.aplicado)) 

# write.xlsx(supplies_F,'4.-Agricultural supplies + testigo_022024_clean_sheet1.xlsx')

supplies_2 <- read.xlsx('4.-Agricultural supplies + testigo_022024.xlsx',sheet = 2,detectDates = T)

supplies_2_F <- supplies_2 %>% 
  mutate(Tipo.de.producto.aplicado=gsub('[.]$','',Tipo.de.producto.aplicado)) %>% 
  mutate(`Costo.del.producto.aplicado.($/ha)`=ifelse(`Costo.del.producto.aplicado.($/ha)`<50|`Costo.del.producto.aplicado.($/ha)`>5000,NA,`Costo.del.producto.aplicado.($/ha)`)) %>% 
  mutate(`Costo.por.la.aplicación.de.los.productos.($/ha)`=ifelse(`Costo.por.la.aplicación.de.los.productos.($/ha)`<20|`Costo.por.la.aplicación.de.los.productos.($/ha)`>1500,NA,`Costo.por.la.aplicación.de.los.productos.($/ha)`)) %>% 
  mutate(`Costo.por.el.transporte.de.los.productos.empleados.($/ha)`=ifelse(`Costo.por.el.transporte.de.los.productos.empleados.($/ha)`<10|`Costo.por.el.transporte.de.los.productos.empleados.($/ha)`>600,NA,`Costo.por.el.transporte.de.los.productos.empleados.($/ha)`))

# write.xlsx(supplies_2_F,'4.-Agricultural supplies + testigo_022024_clean_sheet2.xlsx')