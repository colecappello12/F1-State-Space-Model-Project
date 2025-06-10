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
  real z1;
  real v;
  

}
transformed parameters {
  vector[TT-1] z;  // a deterministic variable
  z[1] = z1 + v;
  for(t in 2:TT-1){
    z[t] = z[t-1] + v;
  }  // computed once per iteration
}
/*----------------------- Model --------------------------*/
/* Model block: defines the model */
model {
  
  sdo ~ normal(0,1);
  z1 ~ normal(z0, 5);
  
  y[1] ~ normal(z1, sdo);
  for(t in 1:TT-1){
    y[t+1] ~ normal(z[t], sdo);
  }
}
