from flask import Flask, request, jsonify
import psycopg2
from init_db import *

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


@app.route('/', methods=['POST', 'GET'])
def hello():
    name = request.json['name']
    update_database(name)
    return 'Hello, World!'


@app.route('/preferences', methods=['POST'])
def receive_preferences():
    data = request.get_json()
    preferences = data.get('preferences', [])
    # Process preferences
    print('Received preferences:', preferences)
    update_preferences(preferences)
    return jsonify({'message': 'Preferences received successfully'})

@app.route('/news', methods=['GET'])
def get_news_articles():
    article =  {"id": 1, "title": "Article 1"}
    # articles = fetch_news_articles()
    return jsonify(article)

@app.route('/language', methods=['POST'])
def update_language():
    data = request.json
    selected_language = data.get('language')
    # Process the selected language as needed

    print(f"Received selected language: {selected_language}")
    return jsonify({'message': 'Language updated successfully'})


if __name__ == '__main__':
    init_db()
    app.run(debug=True)
