library(caret)
#library(xgboost)
#library(randomForest)
#library(nnet)
#library(neuralnet)
train<- read.csv(file.choose(), header=T)
str(train)
train$Buy<- as.factor(train$Buy)
test<-read.csv(file.choose(), header = T)
# Random Forest(50%)
# set.seed(682)
# rf <- randomForest(Buy~., data=train,
#                    ntree = 200,
#                    mtry = 2,
#                    importance = TRUE,
#                    proximity = TRUE)

#t <- tuneRF(train[,-87], train[,87],
            #stepFactor = 0.50,
            #plot = TRUE,
            #ntreeTry = 300,
            #trace = TRUE,
            #improve = 0.05)
#rfp1 <- predict(rf, train)

# multiple logistic regression

#mymodel <- multinom(Buy ~ V5+V45+V48+V56+V60+V77+V83,data = train)
#summary(mymodel)$coef
#coef(mymodel)


# Extreme gradient boosting model 
#modelLookup("xgbTree")
# set.seed(682)
# cv<-trainControl(method='repeatedcv',
#                  number=5,
#                  repeats=2,
#                  allowParallel=TRUE)
# boo <- train(Buy ~ ., 
#              data=train,
#              method="xgbTree",
#              trControl=cv,
#              tuneGrid = expand.grid(nrounds = 10,
#                                     max_depth = 2,
#                                     eta = 0.3,
#                                     gamma = 0.4,
#                                     colsample_bytree = 1,
#                                     min_child_weight = 1,
#                                    subsample = 1))
# 
#submission$Predicted<- predict(boo, newdata = test, type = "raw")

# Logistic Regression (73%)
LR1 <- glm(Buy~., data=train, family='binomial')
summary(LR2)

#Prediction
Predicted <- predict(LR1, test, type="response")

# logistic regression with 
#statistically significant variables(65%)
LR2 <- glm(Buy~V5+V45+V56+V60+V77+V83, data=train, family='binomial')
Predicted <- predict(LR2, test, type="response")
#74.6%
LR3<- glm(Buy~V2+V5+V19+V22+V44+V45+V48+V56+V60+V83+V6+V11, data=train, family='binomial')
Predicted <- predict(LR3, test, type="response")
#75.163%
LR4<- glm(Buy~V2+V5+V19+V22+V44+V45+V48+V56+V60+V83+V6+V11+V42+V29+V7, data=train, family='binomial') 
Predicted <- predict(LR4, test, type="response")
summary(LR4)

# with V86 AND V77(74.8%) without V86 (75.05%)
LR5<- glm(Buy~V2+V5+V19+V22+V44+V45+V48+V56+V60+V83+V6+V11+V42+V29+V7+V77, data=train, family='binomial') 
Predicted <- predict(LR5, test, type="response")

 
#Train data
LR5<- glm(Buy~V2+V5+V19+V22+V44+V45+V48+V56+V60+V83+V6+V11+V42+V29+V7, data=train, family='binomial') 
Predictedt <- predict(LR5, train, type="response")
confusionMatrix(pred5,train$Buy)
# if removed V7 accuracy reduced
# Submission File
submission <- test$Id 
submission <- data.frame(submission)
Id <- test$Id
submission <- cbind(Id,Predicted)
View(submission)
df = data.frame(submission)
print(df)
write.csv(df,"submission.csv")