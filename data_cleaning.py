import pandas as pd

df = pd.read_csv("merged_output.csv")

missing_values = df.isnull().sum()
print("Missing values for each column")
print(missing_values)

duplicates = df.duplicated().sum()
print("Duplicated rows: ")
print(duplicates)

#handling missing values:
product_category = {
    "Laptop": "Electronics",
    "Mobile": "Electronics",
    "Headphones": "Accessories",
    "Keyboard": "Accessories",
    "Mouse": "Accessories"
}

df["Category"] = df["Product"].map(product_category)

# Fill null values with median
df["Quantity"] = df["Quantity"].fillna(df["Quantity"].median())
df["Price"] = df["Price"].fillna(df["Price"].median())

# Save cleaned data
df.to_csv("cleaned_output.csv", index=False)