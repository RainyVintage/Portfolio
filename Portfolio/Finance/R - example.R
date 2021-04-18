# This code will import the data frame:
library(readxl)
german_credit_card <- read_excel("C:/Users/RainyVintage/Desktop/DS R/german credit card.xls")
View(german_credit_card)

# we sliced the dataframe into two vectors with purpose and duration
my_credit   <- german_credit_card$purpose
my_vect_num <- german_credit_card$duration

freq <- table(my_credit) #this is a frequency table

#subsetting vectors using indexes:
my_credit[3] #scalar
my_credit[c(1,3,4,6,10,80)] #multiple indicies
my_credit[seq(from = 1 , to = 10, by= 2)] #sequence
my_credit[rep(c(1,2,3), each =2)] #repeat

#subsetting dataframes using indexes:
german_credit_card[1:10, 1:3]#[row index , col index]
german_credit_card[1:10, c("checking","duration","history")]
german_credit_card[1:10, c("purpose")]

# Subset Using "which" function
which(german_credit_card$purpose == 'X')
purpose_subset <- german_credit_card[which(german_credit_card$purpose == 'X') , c('good_bad')]

which(german_credit_card$age > 40)
age_subset <- german_credit_card[which(german_credit_card$age > 40) , ]

# use of subset function
subset(german_credit_card, german_credit_card$purpose == 'X')
subset(german_credit_card, german_credit_card$age > 40)

# Use of gsub() to replace patterns
german_credit_card$purpose <- gsub("X","", german_credit_card$purpose)
table(german_credit_card$purpose)

#change the purpose datatype to numeric
german_credit_card$purpose <- as.numeric(german_credit_card$purpose)

#change the good/bad datatype to factor: (dummy vairable)
german_credit_card$binary <- as.numeric(as.factor(german_credit_card$good_bad))-1 # 0 -bad 1- good 

new_germ <- as.data.frame(german_credit_card) 

for(i in 1:5){
  print(min(new_germ[,i], na.rm = TRUE))
  print(mean(new_germ[,i], na.rm = TRUE))
  print(max(new_germ[,i], na.rm = TRUE))
}#closing the i loop 

output_df <- as.data.frame(matrix(nrow = 3, ncol = 5))

for(i in 1:5){
  output_df[ 1,i]<-  (min(new_germ[,i], na.rm = TRUE))
  output_df[ 1,i]<-  (mean(new_germ[,i], na.rm = TRUE))
  output_df[ 1,i]<-  (max(new_germ[,i], na.rm = TRUE))
}#closing the i loop 

rownames(output_df) <- c('min','mean','max')

new_germ$my_score <- c()

rowsingerman <- nrow(new_germ)

for(i in 1:rowsingerman){
  new_germ$my_score[i] <- 0.5 * new_germ$duration[i] +
    0.1 * new_germ$amount[i] +
    0.1 * new_germ$age[i] +
    0.3 * new_germ$installp[i] 
  
}#closing the i loop 

desc_stats <- function(x){
  my_min <- min(x, na.rm = TRUE)
  my_mean <- mean(x , na.rm = TRUE)
  my_max <- max(x , na.rm = TRUE)
  return(c(my_min,my_mean,my_max))
} # Closing the desc_stats function 
desc_stats(x = new_germ$checking)
desc_stats(x = new_germ$duration)
purpose_stats <- desc_stats(x = new_germ$purpose)

unique_score <- function(w1,w2,w3,w4,var1,var2,var3,var4){
  my_score <- w1*var1 + w2*var2 + w3*var3 + w4*var4
  min_score <- min(my_score, na.rm = TRUE)
  mean_score <- mean(my_score, na.rm = TRUE)
  max_score <- max(my_score, na.rm = TRUE)
  return(c(min_score,mean_score,max_score))
} ## closing the function 

unique_score(w1 = 0.3, w2 = 0.2,w3 = 0.4, w4= 0.1,
             var1 = new_germ$checking, var2 = new_germ$history,
             var3 = new_germ$employed, var4 = new_germ$binary)

for (i in 1:5) {
  my_min <- min(new_germ[,i], na.rm = T)
  my_max <- max(new_germ[,i], na.rm = T)
  my_mu <- mean(new_germ[,i], na.rm = T)
  my_sigma <- sd(new_germ[,i], na.rm = T)
  print(c(my_min,my_mu, my_sigma,my_max))
} # closing the loop

my_stats <- function(x){
  
  my_min <- min(x, na.rm = T)
  my_max <- max(x, na.rm = T)
  my_mu <- mean(x, na.rm = T)
  my_sigma <- sd(x, na.rm = T)
  return(c(my_min,my_mu, my_sigma,my_max))
  
} #closing the function
my_stats(x = new_germ$checking)
my_stats(x = new_germ$amount)

## what age corresponts to 97.5 percentile
quantile(new_germ$age, 0.975)

## creating a standardisation function [Zscore]
my_standard <- function(x){
  my_mu <- mean(x , na.rm = T)
  my_sigma <- sd(x , na.rm = T)
  zscore <- (x-my_mu)/my_sigma
  return(zscore)
  
}#closing the function
##WE USE STANDARDISATION WHEN THE DATA IS NORMALLY DISTRIBUTED

new_germ$checking_standard <- my_standard(x = new_germ$checking)

desc_stats(new_germ$checking_standard)

new_germ$amount_standard <- my_standard(x = new_germ$amount)

desc_stats(new_germ$amount_standard)

# Create T-score function
my_tscore <- function(x){
  tscore <- my_standard(x = x)*10 + 50
  return(tscore)
}#closing the function
new_germ$checking_tscore <- my_tscore(x = new_germ$checking)
desc_stats(x = new_germ$checking_tscore)

#creating a new function [Normalization]
my_normalize <- function(x){
  my_min <- min(x, na.rm = T)
  my_max <- max(x, na.rm = T)
  min_max <- (x - my_min)/(my_max- my_min)
  return(min_max)
  
}#closing the function
new_germ$checking_normal <- my_normalize(x = new_germ$checking)
new_germ$amount_normal <-  my_normalize(x = new_germ$amount)

desc_stats(x = new_germ$checking_normal)


hist(new_germ$checking)
hist(my_normalize(x = new_germ$checking))

######## RANDOM SAMPLING
training_indexes <- sample(1:1000, 0.8*1000)

training_data <- new_germ[training_indexes,]

testing_data <- new_germ[-training_indexes,]

####### STRATIFIED SAMPLING
#install.packages("splitstackshape")
library(splitstackshape)

training_testing <- stratified(as.data.frame(new_germ),
                               group = 21,size = 0.8,
                               bothSets = TRUE
)
my_training <- training_testing$SAMP1  
my_testing <- training_testing$SAMP2  
table(my_training$good_bad)
table(my_testing$good_bad)

#basic scatterplots that are basic and not that insightful 
plot(x = new_germ$purpose, y= new_germ$duration, type = "p") # p = points 
plot(x = new_germ$amount, y= new_germ$age, type = "p")

######Coding with mauricio ####  
#### Bar plots 
library(ggplot2)
ggplot() + 
  geom_bar(data = new_germ, aes(x = age))

new_germ$age_standard <- my_standard(x = new_germ$age)
my_stats(new_germ$age_standard)

ggplot() + 
  geom_bar(data = new_germ, aes(x = age_standard))

new_germ$age_normal <- my_normalize(x = new_germ$age)
my_stats(new_germ$age_normal)

ggplot() + 
  geom_bar(data = new_germ, aes(x = age_normal)) + 
  geom_vline(xintercept = my_stats(new_germ$age_normal)[2],color = "blue") +
  geom_vline(xintercept = my_stats(new_germ$age_normal)[2] - my_stats(new_germ$age_normal)[3],color = "red") +
  geom_vline(xintercept = my_stats(new_germ$age_normal)[2]  + my_stats(new_germ$age_normal)[3],color = "red")

my_bar<- ggplot() + 
  geom_bar(data = new_germ, aes(x = age_normal)) + 
  geom_vline(xintercept = my_stats(new_germ$age_normal)[2],color = "blue") +
  geom_vline(xintercept = my_stats(new_germ$age_normal)[2] - my_stats(new_germ$age_normal)[3],color = "red") +
  geom_vline(xintercept = my_stats(new_germ$age_normal)[2] + my_stats(new_germ$age_normal)[3],color = "red")

my_bar + theme_bw()
my_bar + theme_dark()

my_bar +theme_light() +
  labs(title = "Data P, RRRR...", x = "Normalized age", y= "")

my_bar_age <- my_bar +theme_light() +
  labs(title = "Data P, RRRR...", x = "Normalized age", y= "")

my_bar_age + facet_wrap(vars(marital))
my_bar_age + facet_wrap(vars(housing))

#####Scatter plots 
ggplot(data = new_germ) +
  geom_point(aes(x=age,y = amount))

ggplot(data = new_germ) +
  geom_point(aes(x=age,y = amount, alpha = 0.2),color = "blue")

####ggplot(data = new_germ, aes(x = age, y= amount ),color = marital) + 
###geom_point()

ggplot(data = new_germ, aes(x = age, y = amount, color = marital)) +
  geom_point(aes(alpha = 0.5),shape = 4)

#how age impacts marital  vs how age impacts property 
ggplot() +
  geom_point(data = new_germ, aes(x = age , y = marital), color = "blue", alpha = 0.3) +
  geom_point(data = new_germ, aes(x = age , y = property), color = "red", alpha = 0.3)

my_scatter <- ggplot() +
  geom_point(data = new_germ, aes(x = age , y = marital), color = "blue", alpha = 0.3) +
  geom_point(data = new_germ, aes(x = age , y = property), color = "red", alpha = 0.3)

###plotly 
#install.packages("plotly")
library(plotly)
ggplotly(my_scatter)

my_normalize <- function(x){
  my_min <- min(x, na.rm = T)
  my_max <- max(x, na.rm = T)
  min_max <- (x - my_min)/(my_max- my_min)
  return(min_max)
}
new_germ$checking_norm <- my_normalize(x=new_germ$checking)
new_germ$duration_norm <- my_normalize(x=new_germ$duration)
new_germ$history_norm <- my_normalize(x=new_germ$history)
new_germ$purpose_norm <- my_normalize(x=new_germ$purpose)
new_germ$amount_norm <- my_normalize(x=new_germ$amount)
new_germ$savings_norm <- my_normalize(x=new_germ$savings)
new_germ$employed_norm <- my_normalize(x=new_germ$employed)
new_germ$installp_norm <- my_normalize(x=new_germ$installp)
new_germ$marital_norm <- my_normalize(x=new_germ$marital)
new_germ$coapp_norm <- my_normalize(x=new_germ$coapp)
new_germ$resident_norm <- my_normalize(x=new_germ$resident)
new_germ$property_norm <- my_normalize(x=new_germ$property)
new_germ$age_norm <- my_normalize(x=new_germ$age)
new_germ$other_norm <- my_normalize(x=new_germ$other)
new_germ$housing_norm <- my_normalize(x=new_germ$housing)
new_germ$existcr_norm <- my_normalize(x=new_germ$existcr)
new_germ$job_norm <- my_normalize(x=new_germ$job)
new_germ$depends_norm <- my_normalize(x=new_germ$depends)
new_germ$telephon_norm <- my_normalize(x=new_germ$telephon)
new_germ$foreign_norm <- my_normalize(x=new_germ$foreign)

random_sample <- function(df, n){
  training_indexes <- sample(1:nrow(df), n*nrow(df))
  
  training_data <- df[training_indexes,]
  
  testing_data <- df[-training_indexes,]
  return(list(training_data,testing_data))
} #closing the function

my_random_output <- random_sample(df = new_germ, n = 0.8)

#install.packages("class")
library(class)
training_data <- my_random_output[[1]]
testing_data <- my_random_output[[2]]

knn_train <- training_data[ ,c("age_norm","amount_norm") ] 
knn_test <- testing_data[, c("age_norm","amount_norm")]

cl <- as.factor(training_data$good_bad)

my_knn <- knn(knn_train, knn_test, cl, k=4, prob = TRUE)
print(my_knn)

##estimating coeff
exp(0.6267)-1
exp(-0.02448)-1
exp(0.9)-1

#####CREATING LOGISTIC REGRESSION

training_data <- my_random_output[[1]]
testing_data <- my_random_output[[2]]

my_logit <- glm(binary ~ checking+duration+age+telephon+amount+savings+installp+coapp,
                data = training_data, family = "binomial")
summary(my_logit)
exp(0.688)-1
exp(-0.0257)-1

my_logit <- glm(binary ~ checking+duration+amount+savings+installp,
                data = training_data, family = "binomial")

summary(my_logit)


my_logit_norm <- glm(binary ~ checking_norm+duration_norm+amount_norm+savings_norm+installp_norm,
                     data = training_data, family = "binomial")

summary(my_logit_norm)

###designing confusion matrix
#install.packages("caret")
library(caret)

my_prediction <- predict(my_logit, training_data,type = "response")
confusionMatrix(data = as.factor(as.numeric(my_prediction>0.5)),
                reference = as.factor(as.numeric(training_data$binary)))
#install.packages("e1071",dependencies = T)

##confusion matrix for testing data

my_prediction_testing <- predict(my_logit, testing_data,type = "response")
confusionMatrix(data = as.factor(as.numeric(my_prediction_testing>0.5)),
                reference = as.factor(as.numeric(testing_data$binary)))

##Third matrix for testing normalized data
my_prediction_testing_norm <- predict(my_logit_norm, testing_data,type = "response")
confusionMatrix(data = as.factor(as.numeric(my_prediction_testing_norm>0.5)),
                reference = as.factor(as.numeric(testing_data$binary)))

#install.packages("ROCR")
library(ROCR)

my_prediction <- predict(my_logit, training_data, type = "response")

pred_val_logit <- prediction(my_prediction, training_data$binary)
  
perf_logit <-performance(pred_val_logit,"tpr","fpr")
  
plot(perf_logit,col="blue")

training_data <- training_testing$SAMP1
testing_data <- training_testing$SAMP2

my_logit_start <- glm(binary ~ checking+duration+amount+savings+installp,
                      data = training_data, family = "binomial")

summary(my_logit_start)

my_prediction_start <- predict(my_logit, training_data,type = "response")
confusionMatrix(data = as.factor(as.numeric(my_prediction_start>0.5)),
                reference = as.factor(as.numeric(training_data$binary)))

## GINI
install.packages("rpart.plot")
library(rpart)
library(rpart.plot)
## install.packages("titanic")

library(titanic)
summary(titanic_train)

my_tree_titan <- rpart(Survived ~ Pclass + Age + Sex + SibSp + Fare, data=titanic_train, method="class",cp=0.02)

rpart.plot(my_tree_titan, extra=1, type=1)
