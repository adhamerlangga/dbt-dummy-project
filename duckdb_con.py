import duckdb
import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)

con = duckdb.connect(database='target/dev.duckdb')

# result = con.execute('SELECT distinct customer_city FROM stg_customers limit 5').fetchdf()
result = con.execute('SELECT current_database(), current_schema()').fetchdf()
# result = con.execute('show all tables').fetchdf()
# print(result)
# print(result.dtypes)
print("Current database:", result.iloc[0, 0])
print("Current schema:", result.iloc[0, 1])

# List all your tables and which schema they're in
tables = con.execute("""
    SELECT table_catalog, table_schema, table_name 
    FROM information_schema.tables 
    WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
    ORDER BY table_schema, table_name
""").fetchdf()
print("\nYour tables:")
print(tables)

con.close()