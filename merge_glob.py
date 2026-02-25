import pandas as pd
import os
import glob

# Folder containing CSV files
path = "raw_data"

# Get all CSV files
files = glob.glob(os.path.join(path, "*.csv"))

df_list = []

for file in files:
    df = pd.read_csv(file)
    df_list.append(df)

# Merge vertically
merged_df = pd.concat(df_list, ignore_index=True)

# Save output
merged_df.to_csv("merged_output.csv", index=False)

print("All CSV files merged successfully")