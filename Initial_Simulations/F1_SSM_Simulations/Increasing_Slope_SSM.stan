/*----------------------- Data --------------------------*/
/* Data block: defines the objects that will be inputted as data */
data {
  int TT; // Length of state and observation time series
  vector[TT] y; // Observations
  real z0; // Initial state value
  real v0; // Initial slope value
  real sdo0; // sdo mean
}
/*----------------------- Parameters --------------------------*/
/* Parameter block: defines the variables that will be sampled */
parameters {
  real<lower=0> sdo; // Standard deviation of the process equation
  real<lower=0> sdp; // Standard deviation of the process equation
  vector[TT] z;      // Latent State vector
  real v1;   	     // To estimate the initial slope
  real b;    	     // Slope increase parameter
  
  

}

transformed parameters {
  vector[TT-1] v;	       // Deterministic slope vector	    
  v[1] = v1 + b;
  for(t in 2:TT-1){
    v[t] = v[t-1] + b;
  }  // computed once per iteration
}
/*----------------------- Model --------------------------*/
/* Model block: defines the model */
model {
  
  sdo ~ normal(sdo0,.1);
  sdp ~ normal(.1,.1);
  // Could include a prior for the slope v
  v1 ~ normal(v0,.1);
  b ~ normal(.01,.1);

  z[1] ~ normal(z0, .1);
  for(t in 2:TT){
    z[t] ~ normal(z[t-1] + v[t-1], sdp);
  }
  
  for(t in 1:TT){
    y[t] ~ normal(z[t], sdo);
  }
}

generated quantities {
  // posterior replicates
  vector[TT] y_rep;
  for(t in 1:TT){
    y_rep[t] = normal_rng(z[t],sdo);
  }
  // log predictive density
  vector[TT] log_pd;
  for(t in 1:TT){
    log_pd[t] = normal_lpdf(y[t] | z[t], sdo);
  }
  // one step ahead observation estimate
  real z_pred;
  real y_pred;
  z_pred = normal_rng(z[TT] + v[TT-1],sdp);
  y_pred = normal_rng(z_pred,sdo);	
}

