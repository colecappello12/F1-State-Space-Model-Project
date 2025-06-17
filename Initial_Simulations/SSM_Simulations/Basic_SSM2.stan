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
  real<lower=0> sdo; // Standard deviation of the process equation
  real<lower=0> sdp; // Standard deviation of the process equation
  vector[TT] z;          // Latent State vector
  real v;            // Slope parameter
  

}

/*----------------------- Model --------------------------*/
/* Model block: defines the model */
model {
  
  sdo ~ normal(0,3);
  sdp ~ normal(0,3);
  // Could include a prior for the slope v
  // v ~ normal(1,1);
  
  z[1] ~ normal(z0, 3);
  for(t in 2:TT){
    z[t] ~ normal(z[t-1] + v, sdp);
  }
  
  for(t in 1:TT){
    y[t] ~ normal(z[t], sdo);
  }
}
