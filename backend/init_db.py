import psycopg2
import requests
import json

NEWS_API_KEY = '7298fe90084642578b34773b0ed70e88'

conn = psycopg2.connect("dbname=newz user=postgres")

cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS test;")
cur.execute("CREATE TABLE test (id serial PRIMARY KEY, data varchar);")

params = {
    'q': 'tesla',
    'apiKey': '7298fe90084642578b34773b0ed70e88',
    'from': '2023-10-18',
    'sortBy': 'publishedAt'
}

response = requests.get('https://newsapi.org/v2/everything', params=params)

if response.status_code == 200:
    data = response.json()

    articles = data['articles']

    for article in articles:
        cur.execute("INSERT INTO test (data) VALUES (%s)", (article['title'],))

else:
    print(f"Error: {response.status_code} - {response.text}")

conn.commit()
cur.close()
conn.close()
