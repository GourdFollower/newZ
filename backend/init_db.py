import psycopg2
from psycopg2.extras import RealDictCursor
import requests
import json
from newsapi import NewsApiClient
import random


NEWS_API_KEY = '7298fe90084642578b34773b0ed70e88'
current_category = None


def init_db():
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS news;")
    cur.execute("CREATE TABLE news (id serial PRIMARY KEY, source text, author text, \
        title text, description text, url text, urlToImage text, publishedAt text, \
            content text, category text, read boolean);")

    cur.execute("DROP TABLE IF EXISTS users;")
    cur.execute("CREATE TABLE users (id serial PRIMARY KEY, name text, category_pref text[], \
        language_pref text[], country_pref text[], articles_read integer[], \
            articles_saved integer[]);")
    
    conn.commit()
    cur.close()
    conn.close()


def create_user(name):
    sql = "INSERT INTO users (name) VALUES (%s)"
    cur.execute(sql, (name,))


def update_preferences(preferences_dict):
    sql = "UPDATE news SET {0} = %s WHERE id = 1;".format("blah")
    cur.execute(sql, (article[key], count))


def obtain_news(cat, lang, size, start_id):
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

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
                sql = "INSERT INTO news ({0}, category, read) VALUES (%s, %s, %s) RETURNING id".format(column)
                cur.execute(sql, (data, cat, 'false'))
                new_id = cur.fetchone()[0]
    
    sql = "DELETE FROM news WHERE author IS null OR title is null OR description is null \
        OR url is null OR urlToImage is null OR publishedAt is null"
    cur.execute(sql)

    conn.commit()
    cur.close()
    conn.close()
    return new_id


def return_json(id, cur):
    query_sql = "SELECT * FROM news where id = %s"
    cur.execute(query_sql, (id,))
    r = [dict((cur.description[i][0], value) \
               for i, value in enumerate(row)) for row in cur.fetchall()]
    return (r[0] if r else None)


def return_article():
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

    sql = "SELECT category_pref FROM users"
    cur.execute(sql)
    preferences = cur.fetchone()[0]

    searching = True
    while searching == True:
        index = random.randint(0, len(preferences) - 1)

        sql = "SELECT id FROM news WHERE category = %s AND read = false"
        cur.execute(sql, (preferences[index],))
        if cur.fetchone() is not None:
            id = cur.fetchone()[0]
            searching = False

    r = return_json(id, cur)
    sql = "UPDATE news SET read = true WHERE id = %s;"
    cur.execute(sql, (id,))

    json_output = json.dumps(r)
    conn.commit()
    cur.close()
    conn.close()
    return json_output

