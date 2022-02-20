### Setting up
library(rvest)
library(ggplot2)
library(lubridate)
library(janitor)
library(stringr)
library(hrbrthemes)
## Pegando dados site e construindo dataframe
url<-"https://br.investing.com/equities/brazil"
ibovespa_html<-read_html(url)
Nome<-ibovespa_html %>% html_nodes("#cross_rate_markets_stocks_1 a") %>% html_text()
Ultimo<-ibovespa_html %>% html_nodes(".plusIconTd+ td") %>% html_text() %>% str_replace( ',', '.') %>% as.numeric()
Maxima<-ibovespa_html %>% html_nodes("#cross_rate_markets_stocks_1 td:nth-child(4)") %>% html_text() %>% str_replace( ',', '.') %>% as.numeric()
Minima <-ibovespa_html %>% html_nodes("#cross_rate_markets_stocks_1 td:nth-child(5)") %>% html_text() %>% str_replace( ',', '.') %>% as.numeric()
Variacao <-ibovespa_html %>% html_nodes(".bold:nth-child(6)") %>% html_text() %>% str_replace( ',', '.') %>% as.numeric()
Var_pct <-ibovespa_html %>% html_nodes(".bold:nth-child(7)") %>% html_text() %>% str_replace( ',', '.') %>% str_replace( '%', '') %>%as.numeric()
Volume_MM <-ibovespa_html %>% html_nodes("td:nth-child(8)") %>% html_text() %>% str_replace( 'M', '') %>% str_replace( ',', '.')%>% as.numeric()
tabela<- data.frame(Nome,Ultimo,Maxima,Minima,Variacao,Var_pct,Volume_MM)
tabela = tabela[order(tabela$Var_pct, decreasing=TRUE),]
print(tabela)
write.csv(tabela, "C:\\Users\\caiog\\tarefa_dados_3\\dados.csv", row.names = TRUE)
## Visualizações
png("Grafico1.png")
tabela %>%
  ggplot(aes(x=Var_pct)) +
    geom_histogram(binwidth = 0.5, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
    ggtitle("Variação Cotação Ações (%) - Pregão de 18/02") +
    theme(plot.title = element_text(size = 15))
    theme_ipsum()
dev.off()
png("Grafico2.png")
tabela %>%
  ggplot(aes(x=Var_pct, y=Volume_MM)) +
  geom_point(color="darkblue") +
  ggtitle("Volume Negociado X Variação Cotação(%) - Pregão de 18/02")
  theme_ipsum()
dev.off()
