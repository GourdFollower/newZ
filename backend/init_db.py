import psycopg2
import requests
import json
from newsapi import NewsApiClient

NEWS_API_KEY = '7298fe90084642578b34773b0ed70e88'

conn = psycopg2.connect("dbname=newz user=postgres")

cur = conn.cursor()

cur.execute("DROP TABLE IF EXISTS news;")
cur.execute("CREATE TABLE news (id serial PRIMARY KEY, source text, author text, \
    title text, description text, url text, urlToImage text, publishedAt date, \
        content text, category text);")

cur.execute("DROP TABLE IF EXISTS users;")
cur.execute("CREATE TABLE users (id serial PRIMARY KEY, name text, category_pref text[], \
    language_pref text[], country_pref text[], articles_read integer[], \
        articles_saved integer[]);")


def create_user(name):
    sql = "INSERT INTO users (name) VALUES (%s)"
    cur.execute(sql, (name,))


def update_preferences(preferences_dict):
    sql = "UPDATE news SET {0} = %s WHERE id = 1;".format("blah")
    cur.execute(sql, (article[key], count))


def obtain_news(cat, lang, size, start_id):
    newsapi = NewsApiClient(api_key='7298fe90084642578b34773b0ed70e88')

    top_headlines = newsapi.get_top_headlines(category=cat, language=lang, page_size=size)
    articles = top_headlines['articles']

    print(articles[0])

    count = start_id
    new_id = start_id

    for article in articles:
        count += 1

        for key in article:
            if article[key] is None:
                continue

            column = key
            data = article[key]

            if key == 'source':
                if article[key]['name'] is None:
                    continue
                else:
                    data = article[key]['name']
            if key == 'date':
                date = article['publishedAt'].split('T', 1)[0]
                data = date

            cur.execute("SELECT id FROM news WHERE id = %s", (count,))
            if cur.fetchone() is not None:
                sql = "UPDATE news SET {0} = %s WHERE id = %s;".format(column)
                cur.execute(sql, (data, count))
            else:
                sql = "INSERT INTO news ({0}) VALUES (%s)".format(column)
                cur.execute(sql, (data,))
        
        sql = "INSERT INTO news ({0}) VALUES (%s) RETURNING id".format('category')
        cur.execute(sql, (cat,))
        new_id = cur.fetchone()[0]

    return new_id

obtain_news('business', 'en', 30, 0)

conn.commit()
cur.close()
conn.close()
