/*----------------------- Data --------------------------*/
/* Data block: defines the objects that will be inputted as data */
data {
  int TT; // Length of state and observation time series
  vector[TT] y; // Observations
  real z0; // Initial state value
  real v0; // Initial slope value
}
/*----------------------- Parameters --------------------------*/
/* Parameter block: defines the variables that will be sampled */
parameters {
  real<lower=0> sdp; // Standard deviation of the process equation
  real<lower=0> sdo; // Standard deviation of the observation equation
  real<lower=0> sdv;
  vector[TT] z; // State time series
  vector[TT] v;  // Slope time series
}
/*----------------------- Model --------------------------*/
/* Model block: defines the model */
model {
  // Prior distributions
  sdo ~ normal(0, 1);
  sdp ~ normal(0, 1);
  sdv ~ normal(0, 1);
  // Distribution for the first state
  z[1] ~ normal(z0, sdp);
  v[1] ~ normal(v0, sdv);
  // Distributions for all other states
  for(t in 2:TT){
    v[t] ~ normal(v[t-1], sdv);
  }

  for(t in 2:TT){
    z[t] ~ normal(z[t-1] + v[t-1], sdp);
  }  
  
  // Distributions for the observations
  for(t in 1:TT){
    y[t] ~ normal(z[t],sdo);
  }
}

