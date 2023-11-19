import psycopg2
from psycopg2.extras import RealDictCursor
import json
from newsapi import NewsApiClient
import random


NEWS_API_KEY = 'ef20faf5d267474d85bfdd0b53a5f7c0'
current_category = None
LANGUAGE = 'en'


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

    categories = ['business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology']
    saved = []
    cur.execute("INSERT INTO users (name, category_pref, articles_saved) VALUES (%s, %s, %s)", ("Bread Sheeran", categories, saved))
    conn.commit()

    start_id = 0
    for i in categories:
        start_id = obtain_news(i, 'en', 100, start_id)

    sql = "DELETE FROM news WHERE length(author) > 20 OR length(source) > 20 OR \
      not(author ILIKE '% %') OR length(description) < 50;"
    cur.execute(sql)
    
    conn.commit()
    cur.close()
    conn.close()


def update_preferences(preferences_dict):
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

    pref_array = []
    for key in preferences_dict:
        if preferences_dict[key] == True:
            pref_array.append(key.lower())
    sql = "UPDATE users SET category_pref = %s WHERE id = 1;"
    cur.execute(sql, (pref_array,))

    conn.commit()
    cur.close()
    conn.close()


def obtain_news(cat, lang, size, start_id):
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

    newsapi = NewsApiClient(api_key=NEWS_API_KEY)

    top_headlines = newsapi.get_top_headlines(category=cat, language=lang, page_size=size)
    articles = top_headlines['articles']

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


def get_saved():
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()
    sql = "SELECT articles_saved FROM users"
    cur.execute(sql)
    saved = cur.fetchone()[0]
    print(saved)

    list_saved = []
    for i in saved:
        j = return_json(i, cur)
        list_saved.append(j)

    conn.commit()
    cur.close()
    conn.close()
    return list_saved


def add_saved(id):
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()
    sql = "SELECT articles_saved FROM users"
    cur.execute(sql)
    saved = cur.fetchone()[0]
    saved.append(id)
    sql = "UPDATE users SET articles_saved = %s WHERE id = 1;"
    cur.execute(sql, (saved,))
    conn.commit()
    cur.close()
    conn.close()


def query_articles(query, size):
    conn = psycopg2.connect("dbname=newz user=postgres")
    cur = conn.cursor()

    newsapi = NewsApiClient(api_key=NEWS_API_KEY)

    top_headlines = newsapi.get_everything(q = query, language=LANGUAGE, page_size=size, sort_by='relevancy')
    articles = top_headlines['articles']

    print(articles[0])
    return articles

def change_language():
    pass