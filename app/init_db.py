import mysql.connector
import os
from urllib.parse import urlparse

mysqlUrl = os.getenv("SCALINGO_MYSQL_URL")
dbc = urlparse(mysqlUrl)
conn = mysql.connector.connect(
    database=dbc.path.lstrip('/'),
    user=dbc.username,
    password=dbc.password,
    port=dbc.port,
    host=dbc.hostname
)

cursor = conn.cursor()
with open("init.sql", "r") as f:
    sql = f.read()
    for statement in sql.split(";"):
        if statement.strip():
            cursor.execute(statement)

conn.commit()
cursor.close()
conn.close()
