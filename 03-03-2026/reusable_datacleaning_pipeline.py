import pandas as pd
import re

# Function for standardize column names
def clean_column_names(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(r'[^\w\s]', '', regex=True)
        .str.replace(' ', '_')
    )
    return df

# Function to save the data
def save_data(df, path):
    df.to_csv(path, index=False)

#  reusable data cleaning pipeline function
def clean_data(file_path):

    # importing dataset
    df = pd.read_csv(file_path)

    # Standardize column names 
    df = clean_column_names(df)

    # Basic data checking Operations
    print("Head:\n", df.head())
    print("\nTail:\n", df.tail())
    print("\nShape:", df.shape)
    print("\nData Types:\n", df.dtypes)
    print("\nInfo:",  df.info())
   
   # Checking missing values
    print("\nMissing Values :\n" , df.isnull().sum())

    # Remove duplicate rows
    print("Duplicate Row Count: " , df.duplicated().sum())
    df = df.drop_duplicates()

    # Handle missing values
    for col in df.columns:
        #  For age and date column
        if col == "age" or "date" in col:
            df[col] = df[col].fillna("Unknown").astype(str)

        # For quantity related columns
        elif col == "units_sold" or "totalpurchase" in col:
            val = round(df[col].mean())
            df[col] = df[col].fillna(val)
        
        # Numerical Columns
        elif df[col].dtype == "int64":
            mean_value = round(df[col].mean())
            df[col] = df[col].fillna(mean_value)

        elif df[col].dtype == "float64":
            mean_val = round(df[col].mean(), 2)
            df[col] = df[col].fillna(mean_val)
        
        # handling values without given conditions
        else:
            df[col] = df[col].fillna("Unknown")

    print("\nMissing values after cleaning:")
    print(df.isnull().sum())
    print(df.shape)

    return df

# Checking the data cleaning pipeline for 1st dataset
cleaned_data = clean_data(r"D:\Internship Tasks\March Tasks\03-03-2026\ecommerce_customer_data.csv")
save_data(cleaned_data, r"D:\Internship Tasks\March Tasks\03-03-2026\Cleaned_ECommerce_Customer.csv")
print("\nCleaned Data")
print(cleaned_data.head())        

# Checking the data cleaning pipeline for 2nd dataset
cleaned_data = clean_data(r"D:\Internship Tasks\March Tasks\03-03-2026\Snitch_Fashion_Sales_Uncleaned.csv")
save_data(cleaned_data, r"D:\Internship Tasks\March Tasks\03-03-2026\Cleaned_Snitch_Fashion_Sales.csv")
print("\nCleaned Data")
print(cleaned_data.head())

# Checking the data cleaning pipeline for 3rd dataset
cleaned_data = clean_data(r"D:\Internship Tasks\March Tasks\03-03-2026\Winter_Travel_and_Activities.csv")
save_data(cleaned_data, r"D:\Internship Tasks\March Tasks\03-03-2026\Cleaned_Winter_Travel_and_Activities.csv")
print("\nCleaned Data")
print(cleaned_data.head())