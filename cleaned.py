#%%

import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

df = pd.read_csv("student_mental_health_burnout_1M.csv")

username = "postgres"
password = '1864Lf00@#'
password__ = quote_plus(password)
host = "localhost"
port = "5432"
database = "Mental_student"

engine = create_engine(f"postgresql+psycopg2://{username}:{password__}@{host}:{port}/{database}")


table_name = "customer"

df.to_sql(table_name, engine, if_exists = "replace", index = False)

print(f'Data sucessfully loaded into table {table_name} in database {database}.')

# %%
