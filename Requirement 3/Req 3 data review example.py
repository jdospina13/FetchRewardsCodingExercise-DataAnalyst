import pandas as pd

#Read data
df = pd.read_json("receipts_corrected.json")

#Show data columns
df.columns

#Show column types, total rows, number of null values in columns
df.info()

#Show statistical description of numerical columns
df.describe()

#Get categorical columns and show their description
categorical = df[ ['_id', 'bonusPointsEarnedReason', 'createDate', 'dateScanned', 'finishedDate', 'modifyDate', 'pointsAwardedDate', 'purchaseDate','rewardsReceiptItemList', 'rewardsReceiptStatus','userId'] ]
categorical.describe()

#Search for receipt with max spent value
df['totalSpent'].idxmax()
df.iloc[469]

#Search for receipt with min spent value
df['totalSpent'].idxmin()
df.iloc[15]

#Search for receipt with negative or zero spent value
df[df['totalSpent'] <= 0]