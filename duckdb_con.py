import duckdb
import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)

con = duckdb.connect(database='target/dev.duckdb')

# result = con.execute('SELECT distinct customer_city FROM stg_customers limit 5').fetchdf()
result = con.execute('SELECT * FROM stg_order_items limit 5').fetchdf()
# result = con.execute('show all tables').fetchdf()
print(result)
print(result.dtypes)
con.close()