import mysql.connector

    # openning the connection to MySQL
def get_connection():
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="BTSclara",
            database="URB_database_bronze"
        )
        return connection

def close_connection(cursor, connection) -> None:
    cursor.close()
    connection.close()
