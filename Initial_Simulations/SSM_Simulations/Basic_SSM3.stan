/*----------------------- Data --------------------------*/
/* Data block: defines the objects that will be inputted as data */
data {
  int TT; // Length of state and observation time series
  vector[TT] y; // Observations
  real z0; // Initial state value
}
/*----------------------- Parameters --------------------------*/
/* Parameter block: defines the variables that will be sampled */
parameters {
  real<lower=0> sdo; // Standard deviation of the observation equation
  real<lower=0> sdp; // Standard deviation of the process equation
  real<lower=0> sdv; // Standard deviation of the slope 
  vector[TT] z;      // Latent state vector
  vector[TT] v;      // Slope vector
  

}

/*----------------------- Model --------------------------*/
/* Model block: defines the model */
model {
  
  sdo ~ normal(3,.5);
  sdp ~ normal(4,.5);
  sdv ~ normal(2,.5);
  

  z[1] ~ normal(z0, .5);
  v[1] ~ normal(1,.5);
  for(t in 2:TT){
    v[t] ~ normal(v[t-1], sdv);
    z[t] ~ normal(z[t-1] + v[t-1], sdp);
  }
  
  for(t in 1:TT){
    y[t] ~ normal(z[t], sdo);
  }
}
