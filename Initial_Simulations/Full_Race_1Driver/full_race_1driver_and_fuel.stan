/*----------------------- Data --------------------------*/
/* Data block: defines the objects that will be inputted as data */
data {
  int TT;	    // Length of state and observation time series
  vector[TT] y;     // Observations
  int C;     	    // Number of Compounds
  int Compound[TT]; // Compound at time t: 1 - Hard, 2 - Medium, 3 - Soft
  int Pit[TT];      // 1 indicates new set of tires put on at time t
  vector[C] z_reset0; 	    // Initial state value
  real v_reset0; 	    // Initial slope value
  real sdo0; 	    // sdo mean
  vector[TT] fuel_mass;
}
/*----------------------- Parameters --------------------------*/
/* Parameter block: defines the variables that will be sampled */
parameters {
  real<lower=0> sdo; // Standard deviation of the process equation
  real<lower=0> sdp; // Standard deviation of the process equation
  vector[TT] z;      // Latent State vector
  vector[C] z_reset; // Estimate reset latent states for each compound
  real v_reset;      // To estimate the initial slope
  vector[C] beta_c;    	     // Slope increase parameter
  real gamma;
}

transformed parameters {
  vector[TT-1] v;	       // Deterministic slope vector	    
  v[1] = v_reset + beta_c[Compound[1]]; 
  for(t in 2:TT-1){
    if (Pit[t-1] == 1) {
       v[t] = v_reset;
    } else {
    v[t] = v[t-1] + beta_c[Compound[t]];  // Compound t instead of t-1 because Compound is length TT
    }
  }  // computed once per iteration
}
/*----------------------- Model --------------------------*/
/* Model block: defines the model */
model {
  
  sdo ~ normal(sdo0,.1);
  sdp ~ normal(.1,.1);
  // Could include a prior for the slope v
  v_reset ~ normal(v_reset0,.1);
  //beta_c[1] ~ normal(.01,.1);
  //beta_c[2] ~ normal(.03,.1);
  //beta_c[3] ~ normal(.08,.1);

  z_reset[1] ~ normal(z_reset0[1],.1);
  z_reset[2] ~ normal(z_reset0[2],2);
  z_reset[3] ~ normal(z_reset0[3],2);

  z[1] ~ normal(z_reset[Compound[1]], .1);
  for(t in 2:TT){
    if (Pit[t-1] == 1) {
    z[t] ~ normal(z_reset[Compound[t]], sdp);
    } else {
    z[t] ~ normal(z[t-1] + v[t-1], sdp);
    }
  }
  
  for(t in 1:TT){
    y[t] ~ normal(z[t] + gamma * fuel_mass[t], sdo);
  }
}

generated quantities {
  // posterior replicates
  vector[TT] y_rep;
  for(t in 1:TT){
    y_rep[t] = normal_rng(z[t] + gamma*fuel_mass[t],sdo);
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

