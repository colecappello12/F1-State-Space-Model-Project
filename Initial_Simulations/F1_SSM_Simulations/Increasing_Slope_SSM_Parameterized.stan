/*----------------------- Data --------------------------*/
data {
  int TT;             // Number of time points
  vector[TT] y;       // Observations
  real z0;            // Initial state value
  real v0;            // Initial slope
  real sdo0;          // Prior mean for sdo
}

/*--------------------- Parameters ----------------------*/
parameters {
  real<lower=0> sdo;               // Observation noise
  real<lower=0> sdp;               // Process noise
  real v1;                         // Initial slope offset
  real b;                          // Slope increment
  vector[TT - 1] z_std;            // Standardized latent state innovations
}

/*----------------- Transformed Parameters --------------*/
transformed parameters {
  vector[TT] z;                    // Latent states
  vector[TT - 1] v;                // Time-varying slope

  // Define time-varying slope
  v[1] = v1 + b;
  for (t in 2:(TT - 1)) {
    v[t] = v[t - 1] + b;
  }

  // Non-centered latent state
  z[1] = z0;
  for (t in 2:TT) {
    z[t] = z[t - 1] + v[t - 1] + sdp * z_std[t - 1];
  }
}

/*------------------------ Model ------------------------*/
model {
  // Priors
  sdo ~ normal(sdo0, 0.1);       // Loosened prior
  sdp ~ normal(0.1, 0.05);       
  v1  ~ normal(v0, 0.1);
  b   ~ normal(0.01, 0.05);
  z_std ~ normal(0, 1);          // Standardized innovations

  // Observation model
  y ~ normal(z, sdo);
}

/*------------- Posterior Predictive Checks -------------*/
generated quantities {
  vector[TT] y_rep;
  vector[TT] log_pd;
  real z_pred;
  real y_pred;

  for (t in 1:TT) {
    y_rep[t] = normal_rng(z[t], sdo);
    log_pd[t] = normal_lpdf(y[t] | z[t], sdo);
  }

  // One-step-ahead prediction
  z_pred = z[TT] + v[TT - 1] + normal_rng(0, sdp);
  y_pred = normal_rng(z_pred, sdo);
}
