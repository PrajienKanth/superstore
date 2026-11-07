import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv("Superstore.csv", encoding="latin1", dtype={"Postal Code": str})
print("CSV rows:", len(df))

engine = create_engine("mysql+pymysql://root:root@localhost:3306/superstore")
df.to_sql("superstore", engine, if_exists="replace", index=False, chunksize=1000)

print("Import done")