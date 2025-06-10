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
  real beta;
  

}
transformed parameters {
  vector[TT-1] z;  // a deterministic variable
  z[1] = beta * z1 ;
  for(t in 2:TT-1){
    z[t] = beta * z[t-1];
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
