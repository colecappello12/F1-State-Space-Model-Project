library(tidyverse)
library(ggplot2)
library(rstan)

options(mc.cores = parallel::detectCores())

# Get data ready

austria_laps <- read_csv("Austria_laps.csv")

hamilton_df <- austria_laps %>%
  filter(Driver == "HAM", is.na(PitOutTime) & is.na(PitInTime), LapTime < 100) %>%
  mutate(Compound_Code = as.integer(factor(Compound,levels = c("HARD","MEDIUM","SOFT"))))

hamilton_laps <- hamilton_df$LapTime

hamilton_compound <- hamilton_df$Compound_Code

hamilton_pit <- rep(0,length(hamilton_compound))

for(i in 2:length(hamilton_df$Stint)) {
  if(hamilton_df$Stint[i] != hamilton_df$Stint[i-1]) {
    hamilton_pit[i-1] <- 1
  }    
}                  

fuel.kg <- seq(110,1,length.out = length(hamilton_laps))

hamilton_map <- sort(unique(hamilton_compound))
hamilton_used <- length(hamilton_map)

# Data for stan code
hamilton_data <- list(TT = length(hamilton_laps), y = hamilton_laps, C = 3, Compound = hamilton_compound, C_used = hamilton_used, compound_map = hamilton_map, Pit = hamilton_pit, z_reset0 = 69, v_reset0 = 0, sdo0 = .3, fuel_mass = fuel.kg)

# Fit Model
test_model <- stan(file = "full_race_1driver_and_fuel_base.stan",
                   data = hamilton_data,
                   chains = 3, iter = 30000,
                   control = list(adapt_delta = .99, max_treedepth = 12))

posterior <- extract(test_model)

alphas <- colMeans(posterior[["z"]])

yhat <- colMeans(posterior[["y_rep"]])

df_base <- tibble(Lap = 1:63,
                  alphas = alphas,
                  observations = hamilton_laps,
                  yhat = yhat)

Tstat <- function(y) {
  return(sum((y - df_base$yhat)^2))
}    

yrep <- posterior$y_rep

Tstats <- rep(NA,dim(yrep)[1])
for(i in 1:dim(yrep)[1]) {
  Tstats[i] <- Tstat(yrep[i,])
}

png("PPC_Base.png", width = 800, height = 600)
hist(Tstats)
abline(v = Tstat(df_base$observations), col = 'blue')
dev.off()

Tobs <- Tstat(df_base$observations)
count <- 0
for(i in 1:length(Tstats)) {
  if(Tstats[i] > Tobs) {
    count <- count + 1
  }    
}    

pval <- count/length(Tstats)
pval


##########################################################################################

# Data for stan code
hamilton_data <- list(TT = length(hamilton_laps), y = hamilton_laps, C = 3, Compound = hamilton_compound, C_used = hamilton_used, compound_map = hamilton_map, Pit = hamilton_pit, z_reset0 = c(69.5,69,68.5), v_reset0 = 0, sdo0 = .3, fuel_mass = fuel.kg)

test_model <- stan(file = "full_race_1driver_and_fuel_Extension1.stan",
                   data = hamilton_data,
                   chains = 3, iter = 30000,
                   control = list(adapt_delta = .99, max_treedepth = 12))

posterior <- extract(test_model)

alphas <- colMeans(posterior_test[["z"]])

yhat <- colMeans(posterior[["y_rep"]])

df_ext1 <- tibble(Lap = 1:63,
                  alphas = alphas,
                  observations = hamilton_laps,
                  yhat = yhat)

Tstat <- function(y) {
  return(sum((y - df_ext1$yhat)^2))
}    

yrep <- posterior$y_rep

Tstats <- rep(NA,dim(yrep)[1])
for(i in 1:dim(yrep)[1]) {
  Tstats[i] <- Tstat(yrep[i,])
}

png("PPC_Ext1.png", width = 800, height = 600)
hist(Tstats)
abline(v = Tstat(df_ext1$observations), col = 'blue')
dev.off()

Tobs <- Tstat(df_ext1$observations)
count <- 0
for(i in 1:length(Tstats)) {
  if(Tstats[i] > Tobs) {
    count <- count + 1
  }    
}    

pval <- count/length(Tstats)
pval


##########################################################################################

hamilton_data <- list(TT = length(hamilton_laps), y = hamilton_laps, C = 3, Compound = hamilton_compound, C_used = hamilton_used, compound_map = hamilton_map, Pit = hamilton_pit, z_reset0 = c(69,68.5,68), v_reset0 = 0, sdo0 = .3, fuel_mass = fuel.kg)

test_model <- stan(file = "full_race_1driver_and_fuel_Extension2.stan",
                   data = hamilton_data,
                   chains = 3, iter = 30000,
                   control = list(adapt_delta = .99, max_treedepth = 12))

posterior <- extract(test_model)

alphas <- colMeans(posterior[["z"]])

yhat <- colMeans(posterior[["y_rep"]])

df_ext2 <- tibble(Lap = 1:63,
                  alphas = alphas,
                  observations = hamilton_laps,
                  yhat = yhat)

Tstat <- function(y) {
  return(sum((y - df_ext2$yhat)^2))
}    

yrep <- posterior$y_rep

Tstats <- rep(NA,dim(yrep)[1])
for(i in 1:dim(yrep)[1]) {
  Tstats[i] <- Tstat(yrep[i,])
}

png("PPC_Ext2.png", width = 800, height = 600)
hist(Tstats)
abline(v = Tstat(df_ext2$observations), col = 'blue')
dev.off()

Tobs <- Tstat(df_ext2$observations)
count <- 0
for(i in 1:length(Tstats)) {
  if(Tstats[i] > Tobs) {
    count <- count + 1
  }    
}    

pval <- count/length(Tstats)
pval