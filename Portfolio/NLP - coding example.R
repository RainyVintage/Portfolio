##### Install packages and load libraries #####

#install.packages("textreadr")
library(textreadr)
#install.packages("dplyr")
library(dplyr)
#install.packages("tidytext")
library(tidytext)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("magrittr")
library(magrittr)
#install.packages("magrittr")
library(stringr)
#install.packages("textshape")
library(textshape)
#install.packages("scales")
library(scales)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("textdata")
library(textdata)
#install.packages("wordcloud")
library(wordcloud)
#install.packages("reshape2")
library(reshape2)
#install.packages("tidyr")
library(tidyr)
#install.packages("igraph")
library(igraph)
#install.packages("ggraph")
library(ggraph)
#install.packages("widyr")
library(widyr)
#install.packages("quanteda")
library(quanteda)
#install.packages("quanteda.textmodels")
library(quanteda.textmodels)
#install.packages("RColorBrewer")
library(RColorBrewer)


#### Loading and transforming Data ####

# Importing all .doc files from one directory
setwd("C:/Users/Haolin/Documents/NLP_cleaned")
nm <- list.files(path="C:/Users/Haolin/Documents/NLP_cleaned")
my_doc_text <- do.call(rbind, lapply(nm, function(x) read_docx(file=x)))

#binding al text together
my_txt_text <- do.call(rbind, lapply(nm, function(x) paste(read_document(file=x), collapse = " ")))

#transforming consolidated data in a data Frame
mydf <- data.frame(line=1:30, text=my_txt_text)

#Adding binary outcome to df
mydf$binary <- c(0,0,0,0,1,1,0,1,1,0,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1)

mydf$binary[mydf$binary == 0] <- "fail"
mydf$binary[mydf$binary == 1] <- "success"

#### Tokenizing ####

#tokenise data Frame without no punctuation, no upper case letters
token_list <- mydf %>%
  unnest_tokens(word, text)

data(stop_words)
stop_words <- stop_words[-c(358),]
frequencies_tokens_nostop <- mydf%>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>% #here's where we remove tokens
  count(word, sort=TRUE)

#### Frequency and TF-idf #####

#plotting frequency of each tokens
freq_hist <- mydf %>%
  unnest_tokens(word,text) %>%
  anti_join(stop_words) %>%
  count(word, sort=TRUE) %>%
  mutate(word=reorder(word, n)) %>%
  filter(n>20)


#engineering data for ZIPF
myzipf <- mydf %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(line, word, sort=TRUE) %>%
  ungroup()

total_words <- myzipf %>%
  group_by(line) %>%
  summarize(total=sum(n))

myzipf <- left_join(myzipf, total_words)

freq_by_rank <- myzipf %>%
  group_by("line") %>%
  mutate(rank = row_number(),
         `term frequency` = n/sum(n))

#Engineering Tf-idf data

mytfidf <- myzipf %>%
  bind_tf_idf(word, line, n)

#plotting Tf-idf
mytfidf <- mytfidf %>%
  arrange(desc(tf_idf)) %>%
  mutate(word=factor(word, levels =rev(unique(word)))) %>%
  group_by(line) %>%
  top_n(10) %>%
  filter(n>2) %>%
  filter(n<5)

#### Sentiment Analysis ####

sentiment_plot <- frequencies_tokens_nostop %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=TRUE) %>%
  acast(word ~sentiment, value.var="n", fill=0)

#### Bigrams ####

team_bigrams <-mydf %>%
  unnest_tokens(bigram, text, token = "ngrams", n=2)

#to remove stop words from the bigram data, we need to use the separate function:
bigrams_separated <- team_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) 

#creating the new bigram, "no-stop-words":
bigram_counts <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)

bigram_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep=" ") #we need to unite what we split in the previous section

bigram_tf_idf <- bigram_united %>%
  count(line, bigram) %>%
  bind_tf_idf(bigram, line, n) %>%
  arrange(desc(tf_idf))

#plotting a bigram network
bigram_graph <- bigram_counts %>%
  filter(n>1) %>%
  graph_from_data_frame()

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link()+
  geom_node_point()+
  geom_node_text(aes(label=name), vjust =1, hjust=1)

#### Word correlation ####

my_tidy_df <- mydf %>%
  mutate(section = row_number() ) %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)

my_tidy_df
#taking out the least common words
word_cors <- my_tidy_df %>%
  group_by(word) %>%
  filter(n() >=15) %>%
  pairwise_cor(word,section, sort=TRUE)

word_cors

word_cors %>%
  filter(correlation > 0.2) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr")+
  geom_edge_link(aes(edge_alpha = correlation), show.legend=F)+
  geom_node_point(color = "lightgreen", size=6)+
  geom_node_text(aes(label=name), repel=T)+
  theme_void()

#### Correlogram ####

frequency <- token_list %>% 
  group_by(binary) %>% 
  count(word, sort = TRUE) %>% 
  left_join(token_list %>% 
              group_by(binary) %>% 
              summarise(total = n())) %>%
  mutate(freq = n/total)

frequency.spread <- frequency %>% 
  select(binary, word, freq) %>% 
  spread(binary, freq) %>%
  arrange(desc(success), desc(fail))

#plotting the correlogram between success and failure
ggplot(frequency.spread, aes(x=fail, y=success, 
                             color = abs(success- fail)))+
  geom_abline(color="grey40", lty=2)+
  geom_jitter(alpha=.1, size=2.5, width=0.3, height=0.3)+
  geom_text(aes(label=word), check_overlap = TRUE, vjust=1.5) +
  scale_x_log10(labels = percent_format())+
  scale_y_log10(labels= percent_format())+
  scale_color_gradient(limits = c(0,0.001), low = "darkslategray4", high = "gray75")+
  theme_minimal()

#### Naive Bayes model ####


tokens_nowords <- mydf %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(line, word)


dtm <- tokens_nowords %>% 
  cast_dfm(line, word, n)

dtm_train <- dtm[1:24,]

dtm_test <- dtm[24:30,]

nb_classifier <- textmodel_nb(dtm_train, c(0,0,0,0,1,1,0,1,1,0,1,0,0,0,1,1,1,1,1,1,1,1,1,1),prior = c("docfreq"))
# label 0 is Business Failure, label 1 is Business Success
# labels should be changed
nb_classifier
nb_summary <- summary(nb_classifier)


summary <- nb_summary[["estimated.feature.scores"]] %>%
  filter(nb_summary$estimated.feature.scores > 0.005)



summary2 <- subset(summary, select = 2)
summary3 <- subset(summary, select = 1)

names(summary2)[names(summary2) == "1"] <- "Success"
summary2$word <- row.names(summary2)
summary2 <-arrange(summary2)

names(summary3)[names(summary3) == "0"] <- "Failure"
summary3$word <- row.names(summary3)
summary3 <-arrange(summary3)

pred <- predict(nb_classifier,dtm_test)
pred




#### Shiny App ####
library(shiny)
library(shinydashboard)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Pirate Survey"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "Introduction", icon = icon("Introduction")),
      menuItem("Analysis", tabName = "Analysis", icon = icon("Analysis")),
      menuItem("Insights", tabName = "Insights", icon = icon("Insights"))
    )),
  dashboardBody(
    
    tabItems(
      # First tab content
      tabItem(tabName = "Introduction",
              fluidRow(
                valueBoxOutput("value1",width = 4),
                valueBoxOutput("value2",width = 4)),
              
              fluidRow(
                box(
                  title = "Frequency"
                  ,status = "primary"
                  ,solidHeader = TRUE
                  ,width = 6
                  ,collapsible = TRUE 
                  ,plotOutput("plot1", height = "300px", width = "450px")),
                
                box(
                  title = "Tf-idf"
                  ,status = "primary"
                  ,solidHeader = TRUE 
                  ,collapsible = TRUE 
                  ,plotOutput("plot5", height = "300px", width = "450px")))
      ),
      
      # second tab content
      tabItem(tabName = "Analysis",
              fluidRow(
                box(
                  title = "Sentiment Cloud"
                  ,status = "primary"
                  ,solidHeader = TRUE
                  ,width = 12
                  ,collapsible = TRUE 
                  ,plotOutput("plot7", height = "600px", width = "950px"))),
              
              fluidRow(
                box(
                  title = "Correlogram"
                  ,status = "primary"
                  ,solidHeader = TRUE
                  ,width = 12
                  ,collapsible = TRUE 
                  ,plotOutput("plot6", height = "400px", width = "950px"))),
              
              fluidRow(
                box(
                  title = "Bi grams"
                  ,status = "primary"
                  ,solidHeader = TRUE
                  ,width = 12
                  ,collapsible = TRUE 
                  ,plotOutput("plot2", height = "400px", width = "950px"))),
              
              fluidRow(
                box(
                  title = "Correlations"
                  ,status = "primary"
                  ,solidHeader = TRUE
                  ,width = 12 
                  ,collapsible = TRUE 
                  ,plotOutput("plot3", height = "400px", width = "950px")))
      ),
      tabItem(tabName = "Insights",
              fluidRow(
                box(
                  title = "Naive Bayes - Success"
                  ,status = "primary"
                  ,solidHeader = TRUE 
                  ,collapsible = TRUE 
                  ,plotOutput("plot8", height = "300px", width = "450px")),
                
                box(
                  title = "Naive Bayes - Failure"
                  ,status = "primary"
                  ,solidHeader = TRUE 
                  ,collapsible = TRUE 
                  ,plotOutput("plot9", height = "300px", width = "450px")))
      )
      
      
    )
  )
)

server <- function(input, output) {
  
  total.respondants <- sum(mydf$line - mydf$line +1)
  
  output$value1 <- renderValueBox({ 
    valueBox(
      formatC(total.respondants, format="d", big.mark=',')
      ,'Total Respondants'
      ,icon = icon("stats",lib='glyphicon')
      ,color = "green")  
  })
  perc.respondants <- round(19/sum(mydf$line -mydf$line +1),2)*100
  
  output$value2 <- renderValueBox({ 
    valueBox(
      formatC(perc.respondants, format="d", big.mark=',')
      ,'% of Business success'
      ,icon = icon("stats",lib='glyphicon')
      ,color = "red")  
  })
  output$plot1 <- renderPlot({
    ggplot(freq_hist,aes(word, n))+
      geom_col()+
      xlab(NULL)+
      coord_flip()
  })
  output$plot2<-renderPlot({
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link()+
      geom_node_point()+
      geom_node_text(aes(label=name), vjust =1, hjust=1)
  })
  output$plot3<-renderPlot({
    word_cors %>%
      filter(correlation > 0.2) %>%
      graph_from_data_frame() %>%
      ggraph(layout = "fr")+
      geom_edge_link(aes(edge_alpha = correlation), show.legend=F)+
      geom_node_point(color = "lightgreen", size=6)+
      geom_node_text(aes(label=name), repel=T)+
      theme_void()
  })
  output$plot5<-renderPlot({
    ggplot(mytfidf, aes(word, tf_idf))+
      geom_col(show.legend=FALSE)+
      labs(x=NULL, y="tf-idf")+
      coord_flip()
  })
  output$plot6<-renderPlot({
    ggplot(frequency.spread, aes(x=fail, y=success, 
                                 color = abs(success- fail)))+
      geom_abline(color="grey40", lty=2)+
      geom_jitter(alpha=.1, size=2.5, width=0.3, height=0.3)+
      geom_text(aes(label=word), check_overlap = TRUE, vjust=1.5) +
      scale_x_log10(labels = percent_format())+
      scale_y_log10(labels= percent_format())+
      scale_color_gradient(limits = c(0,0.001), low = "darkslategray4", high = "gray75")
  })
  output$plot7<-renderPlot({
    comparison.cloud(sentiment_plot, colors = c("grey20", "grey50"),
                     max.words=400, scale = c(1, 1),fixed.asp=TRUE, title.size=1.5)
  },height = 600, width = 800)
  
  output$plot8 <- renderPlot({
    ggplot(summary2,aes(reorder(word,-Success), Success))+
      geom_col()+
      xlab(NULL)+
      coord_flip()
  } )
  output$plot9 <- renderPlot({
    ggplot(summary3,aes(reorder(word,-Failure), Failure))+
      geom_col()+
      xlab(NULL)+
      coord_flip()
  } )

}

# Run the application 
shinyApp(ui, server)
