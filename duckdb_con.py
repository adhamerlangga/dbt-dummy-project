import duckdb
import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)

con = duckdb.connect(database='target/dev.duckdb')

# result = con.execute('SELECT * FROM raw_customer').fetchdf()
result = con.execute('show all tables').fetchdf()
print(result)
con.close()

