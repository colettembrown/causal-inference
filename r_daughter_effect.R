library("Matching")
library("foreign")
library("rgenoud")

# load data
setwd("/Users/Colette/Downloads")
load("~/Downloads/basic.RData")

#get rid of all units that have a missing ("NA") datapoint 
x <- na.omit(x)

#use x dataset for the rest of the time -- we no longer have to do x$ for our main data
attach(x)

#fix nboys so it is numeric 
nboys <- as.numeric(as.character(nboys))

set.seed(19)

#Changing religion so Protestant and Other religion are not seen as WILDLY different because 4-1 > 2-1
#0=None, 1=Protestant, 2=Catholic, 3=Other Christian, 4=Other religion
losing_my_religion <- rep(0, 397)
losing_my_religion[which(rgroup == 0)] <- 1

protestant <- rep(0, 397)
protestant[which(rgroup == 1)] <- 1

catholic <- rep(0, 397)
catholic[which(rgroup == 2)] <- 1

other_christ <- rep(0, 397)
other_christ[which(rgroup == 3)] <- 1

other_religion <- rep(0, 397)
other_religion[which(rgroup == 4)] <- 1

all_christ <- rep(0,397)
all_christ[which(rgroup == 1)] <- 1
all_christ[which(rgroup == 2)] <- 1
all_christ[which(rgroup == 3)] <- 1

#add the all_christ column to our data
x <- cbind(x,all_christ)


Tr = anygirls
Y = nowtot
# King's covariates
X2 = cbind(female, white, srvlng, age, demvote, repub)
# My covariates
X3 = cbind(female, white, age, demvote, repub, all_christ)

#kept for my own good
#x2 = female + white + srvlng + age + demvote + repub
#x3 = female + white + age + demvote + repub + all_christ 

gen.match <- GenMatch(Tr = Tr, X = X3, pop.size = 500, max.generations = 500, wait.generations = 50)
summary(gen.match)
matched_data <- Match(Y = Y, Tr = Tr, X = X3, Weight.matrix = gen.match)
summary(matched_data)

gen.balance <- MatchBalance(Tr ~ female + white + age + demvote + repub + all_christ, match.out = matched_data, nboots = 1000)


############################################################################################################

# PLOTS for Gary

# separation of the control and treated units before matching
treat <- subset(x, anygirls == 1)
contr <- subset(x, anygirls == 0)


# FEMALE before matching 
plot(density(treat$female), lwd = 3, col = "red", main = "Balance on Gender Before Matching", xlab = "0 = Male, 1 = Female")
lines(density(contr$female), lwd = 3, col = "black")
# FEMALE after matching
plot(density(female[matched_data$index.treated]), lwd = 3, col = "black", main = "Balance on Gender After Matching", xlab = "0 = Male, 1 = Female")
lines(density(female[matched_data$index.control]), lwd = 3, col = "red")


# WHITE before matching 
plot(density(treat$white), lwd = 3, col = "red", main = "Balance on Race Before Matching", xlab = "0 = Not White, 1 = White")
lines(density(contr$white), lwd = 3, col = "black")
# WHITE after matching
plot(density(white[matched_data$index.treated]), lwd = 10, col = "black", main = "Balance on Race After Matching", xlab = "0 = Not White, 1 = White")
lines(density(white[matched_data$index.control]), lwd = 3, col = "white")


# SRVLNG before matching 
plot(density(treat$srvlng), lwd = 3, col = "red", main = "Balance on Serving Length Before Matching", xlab = "Serving Length in Years")
lines(density(contr$srvlng), lwd = 3, col = "black")
# SRVLNG after matching
plot(density(srvlng[matched_data$index.treated]), lwd = 3, col = "red", main = "Balance on Serving Length After Matching", xlab = "Serving Length in Years")
lines(density(srvlng[matched_data$index.control]), lwd = 3, col = "black")


# AGE before matching 
plot(density(treat$age), lwd = 3, col = "red", main = "Balance on Age Before Matching", xlab = "Age in Years")
lines(density(contr$age), lwd = 3, col = "black")
# AGE after matching
plot(density(age[matched_data$index.treated]), lwd = 3, col = "red", main = "Balance on Age After Matching", xlab = "Age in Years")
lines(density(age[matched_data$index.control]), lwd = 3, col = "black")


# DEMVOTE before matching 
plot(density(treat$demvote), lwd = 3, col = "red", main = "Balance on DemVote Before Matching", xlab = "Percentage of Democratic Constituents")
lines(density(contr$demvote), lwd = 3, col = "black")
# DEMVOTE after matching
plot(density(demvote[matched_data$index.treated]), lwd = 3, col = "red", main = "Balance on DemVote After Matching", xlab = "Percentage of Democratic Constituents")
lines(density(demvote[matched_data$index.control]), lwd = 3, col = "black")


# REPUB before matching 
plot(density(treat$repub), lwd = 3, col = "red", main = "Balance on Party Before Matching", xlab = "0 = Democrat, 1 = Republican")
lines(density(contr$repub), lwd = 3, col = "black")
# REPUB after matching
plot(density(repub[matched_data$index.treated]), lwd = 10, col = "black", main = "Balance on Party After Matching", xlab = "0 = Democrat, 1 = Republican")
lines(density(repub[matched_data$index.control]), lwd = 3, col = "white")


# makenboysnumericagain 
nt_nboys <- as.numeric(as.character(treat$nboys))
nc_nboys <- as.numeric(as.character(contr$nboys))
# NBOYS before matching 
plot(density(nt_nboys), lwd = 3, col = "red")
lines(density(nc_nboys), lwd = 3, col = "black")
# NBOYS after matching
plot(density(nboys[matched_data$index.treated]), lwd = 3, col = "red")
lines(density(nboys[matched_data$index.control]), lwd = 3, col = "black")


###########################################################################################################

# PLOTS FOR MY COVARIATES 

# REPUB before matching 
plot(density(treat$repub), lwd = 3, col = "red", main = "Balance on Party Before Matching", xlab = "0 = Democrat, 1 = Republican")
lines(density(contr$repub), lwd = 3, col = "black")
# REPUB after matching
plot(density(repub[matched_data$index.treated]), lwd = 10, col = "black", main = "Balance on Party After Matching", xlab = "0 = Democrat, 1 = Republican")
lines(density(repub[matched_data$index.control]), lwd = 3, col = "white")


# FEMALE before matching 
plot(density(treat$female), lwd = 3, col = "red", main = "Balance on Gender Before Matching", xlab = "0 = Male, 1 = Female")
lines(density(contr$female), lwd = 3, col = "black")
# FEMALE after matching
plot(density(female[matched_data$index.treated]), lwd = 3, col = "red", main = "Balance on Gender After Matching", xlab = "0 = Male, 1 = Female")
lines(density(female[matched_data$index.control]), lwd = 3, col = "black")


# WHITE before matching 
plot(density(treat$white), lwd = 3, col = "red", main = "Balance on Race Before Matching", xlab = "0 = Not White, 1 = White")
lines(density(contr$white), lwd = 3, col = "black")
# WHITE after matching
plot(density(white[matched_data$index.treated]), lwd = 10, col = "black", main = "Balance on Race After Matching", xlab = "0 = Not White, 1 = White")
lines(density(white[matched_data$index.control]), lwd = 3, col = "white")


# AGE before matching 
plot(density(treat$age), lwd = 3, col = "red", main = "Balance on Age Before Matching", xlab = "Age in Years")
lines(density(contr$age), lwd = 3, col = "black")
# AGE after matching
plot(density(age[matched_data$index.treated]), lwd = 3, col = "red", main = "Balance on Age After Matching", xlab = "Age in Years")
lines(density(age[matched_data$index.control]), lwd = 3, col = "black")


# DEMVOTE before matching 
plot(density(treat$demvote), lwd = 3, col = "red", main = "Balance on DemVote Before Matching", xlab = "Percentage of Democratic Constituents")
lines(density(contr$demvote), lwd = 3, col = "black")
# DEMVOTE after matching
plot(density(demvote[matched_data$index.treated]), lwd = 3, col = "red", main = "Balance on DemVote After Matching", xlab = "Percentage of Democratic Constituents")
lines(density(demvote[matched_data$index.control]), lwd = 3, col = "black")