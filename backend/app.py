from flask import Flask, request, jsonify
import psycopg2
import nltk
from nltk.corpus import stopwords

from init_db import *

app = Flask(__name__)
stop_words = set(stopwords.words('english'))


@app.route('/', methods=['POST', 'GET'])
def hello():
    name = request.json['name']
    return 'Hello, World!'


@app.route('/preferences', methods=['POST'])
def receive_preferences():
    data = request.get_json()
    preferences = data.get('preferences', [])
    # Process preferences
    print('Received preferences:', preferences)
    update_preferences(preferences)
    return jsonify({'message': 'Preferences received successfully'})

# Fetch article from database to send to feed
@app.route('/news', methods=['GET'])
def get_news_articles():
    #article =  {"id": 1, "title": "Article 1"}
    article = return_article()
    return article

@app.route('/update_saved', methods=['POST'])
def update_saved():
    data = request.get_json()
    article = data.get('article', [])
    id = article.get('id')
    # Process preferences
    print('Received id: ', str(id))
    add_saved(id)
    return jsonify({'message': 'Saved article received successfully'})

@app.route('/saved', methods=['GET'])
def get_saved_articles():
    articles = get_saved()
    return articles

@app.route('/language', methods=['POST'])
def update_language():
    data = request.json
    selected_language = data.get('language')
    # Process the selected language as needed

    print(f"Received selected language: {selected_language}")
    return jsonify({'message': 'Language updated successfully'})


@app.route('/query', methods=['POST'])
def run_query():
    data = request.json
    query = data.get('query')
    # Process query
    filtered_words = [word for word in query.split() if word not in stop_words]
    query = 'AND'.join(filtered_words)
    # query and return list of dictionaries
    r = query_articles(query, 100)
    return r

if __name__ == '__main__':
    #init_db()
    fake_init()
    app.run(debug=True)
