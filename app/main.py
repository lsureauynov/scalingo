import mysql.connector
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Database connection
@app.get("/users")
async def get_users():
    conn = mysql.connector.connect(
        database=os.getenv("MYSQL_DATABASE"),
        user=os.getenv("MYSQL_USER"),
        password=os.getenv("MYSQL_ROOT_PASSWORD"),
        host=os.getenv("MYSQL_HOST"),
        port=3306
    )
    cursor = conn.cursor()
    sql_select_Query = "SELECT * FROM user"
    cursor.execute(sql_select_Query)

    records = cursor.fetchall()
    print("Total number of rows in users is: ", cursor.rowcount)
    return {"users": records}