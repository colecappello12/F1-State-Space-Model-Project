import fastf1 as f1
import pandas as pd

# Loads race  data from the Bahrain Grand Prix this year
session = f1.get_session(2025,"Imola","R")
session.load()

# Shows you some info about the event
print(session.event)

# Makes a dataframe with all lap timing data for the driver Verstappen, Norris, and Leclerc
laps = pd.DataFrame(session.laps.pick_drivers(["VER","PIA","LEC","RUS","HAM"]))

def to_secs(row):
    tSecs = row['LapTime'].total_seconds() 
    return tSecs

# Change from a pandas timedelta to a float representing number of seconds in the lap
laps['LapTime'] = laps.apply(to_secs,axis = 1)

# Makes a dataframe with telemetry data for Chalres Leclerc
lec_telm = pd.DataFrame(session.laps.pick_drivers("LEC").get_telemetry())

laps.to_csv("~/Code/F1_Project/F1_Data_Generation/imola_laps.csv")

# lec_telm.to_csv("~/Code/Python_Programs/F1_Data_Generation/lec_telm.csv")
