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
    #set_preferences(preferences)
    return jsonify({'message': 'Preferences received successfully'})

@app.route('/news', methods=['GET'])
def get_news_articles():
    articles =  [
        {"id": 1, "title": "Article 1"},
        {"id": 2, "title": "Article 2"},
        {"id": 3, "title": "Article 3"},
    ]
    # articles = fetch_news_articles()
    return jsonify({'news_articles': articles})

if __name__ == '__main__':
    app.run(debug=True)
