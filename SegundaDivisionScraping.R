library(rvest)
library(tidyverse)
library(tibble)

## Scraping

## First at all, select an url from a Segunda División team in transfermakt
url <- "https://www.transfermarkt.es/fc-reus-deportiu/startseite/verein/13225/saison_id/2018"
webpage <- read_html(url)

players_html  <- html_nodes(webpage,"#yw1 span.hide-for-small a.spielprofil_tooltip") 
players <- html_text(players_html) 
players

valores_html <- html_nodes(webpage,'.rechts.hauptlink')
valores <- html_text(valores_html)
valores <- gsub(" miles €","000", valores)
valores <- gsub(" mill. €","0000", valores)
valores <- gsub("\\D","",valores)
valores <- as.numeric(valores)
valores

dates_html  <- html_nodes(webpage,".hide+ td") 
dates <- html_text(dates_html) 
dates <- gsub("\\s*\\([^\\)]+\\)","",dates)
dates <- as.Date(dates, "%d/%m/%Y")
dates

positions_html  <- html_nodes(webpage,"#yw1 .inline-table tr+ tr td") 
positions <- html_text(positions_html) 
positions

equipos <- rep("CF Reus Deportiu",20)
equipos

df <- data.frame(players,positions,valores,dates,equipos,stringsAsFactors = FALSE)

second_division <- rbind(second_division,df)
second_division

##Only first time
second_division <- data.frame(df, stringsAsFactors = FALSE)
#################

## Changing names of columns and putting as a tibble
names(second_division) <- c("Jugadores","Posiciones","Valores_Mercado","Nacimiento","Equipos")
second_division <- as_tibble(second_division)

## Writing the dataframe in a txt file
write.table(second_division,"DatosSegundaDivision.txt")

## Reading dataframe from a txt file

second_division <- read.table("DatosSegundaDivision.txt",stringsAsFactors = FALSE)
second_division$Nacimiento <- as.Date(second_division$Nacimiento)
second_division$Posiciones = ordered(second_division$Posiciones, levels = c("Portero","Defensa central","Lateral izquierdo","Lateral derecho","Pivote","Medio centro","Medio centro ofensivo","Interior derecho","Interior izquierdo","Extremo izquierdo","Extremo derecho","Media punta","Delantero centro"))
str(second_division)
second_division %>% View()

## Adding new player to the dataframe

second_division <- add_row(second_division,Jugadores = "Manu Barreiro",Posiciones="Delantero centro",Valores_Mercado=300000,Nacimiento="1986-07-08",Equipos = "CD Lugo")

## Removing player from a dataframe
ind <- which(str_detect(second_division$Jugadores,"Jeisson"))
second_division <- second_division[-ind,]

## Arranging dataframe by columns Equipos (Teams) and Posiciones (Positions) 

second_division <- second_division %>% arrange(second_division$Equipos,second_division$Posiciones) 

