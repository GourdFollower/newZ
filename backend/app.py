from flask import Flask, request, jsonify
import psycopg2

app = Flask(__name__)

def update_database(name):
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS test;")
    cur.execute("CREATE TABLE test (id serial PRIMARY KEY, data varchar);")

    cur.execute("INSERT INTO test (data) VALUES (%s)", (name,))
    conn.commit()
    
    cur.close()
    conn.close()



@app.route('/', methods=['POST'])
def hello():
    name = request.json['name']
    update_database(name)
    return 'Hello, World!'
