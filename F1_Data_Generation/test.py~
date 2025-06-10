import pandas as pd
import fastf1 as f1 
import numpy as np
#from force_fcn import getAcceleration

def to_secs(row):
    tSecs = row['Time'].total_seconds() 
    return tSecs

session = f1.get_session(2024, 18, "R")
session.load()
print(session.event)

df = pd.DataFrame(session.laps.pick_drivers("LEC").get_telemetry())
#Changed pick_driver to pick_drivers

df['Time_Secs'] = df.apply(to_secs,axis = 1)
df = df[df['Source'] == 'car']
points = np.array([df['X'],df['Y'],df['Time_Secs']]).transpose()
accel = getAcceleration(points)
a_t = accel[0]
a_n = accel[1]
df["at_x"] = a_t[:,0]
df["at_y"] = a_t[:,1]
df["an_x"] = a_n[:,0]
df["an_y"] = a_n[:,1]
df['a'] = accel[2]
#df['LapTime_Seconds'] = df.apply(to_secs,axis = 1)
df.to_csv("~/Code/R_Programs/F1/Singapore2024LapTelemetryMac.csv")
