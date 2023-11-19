import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

const baseUrl = 'http://127.0.0.1:5000/';

void sendPreferences(Map<String, bool> preferences) async {
  log("send preferences", level: 0);
  const url = '${baseUrl}preferences';
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({'preferences': preferences}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Handle a successful response
    log('Preferences sent successfully', level: 0);
  } else {
    // Handle errors
    log('Failed to send preferences: ${response.statusCode}', level: 0);
  }
}

// Fetch one article to be displayed in feed
Future<Map<String, dynamic>> fetchNewsArticles() async {
  final response = await http.get(
    Uri.parse('${baseUrl}news'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    // Handle errors
    throw Exception('Failed to load news articles');
  }
}

Future<Map<String, dynamic>> getNews() async {
  try {
    Map<String, dynamic> article = await fetchNewsArticles();
    print('News Articles:');
    print(article);
    return article;
  } catch (e) {
    throw Exception('Error fetching news articles: $e');
  }
}

// Get all saved articles
Future<List<Map<String, dynamic>>> fetchSavedArticles() async {
  final response = await http.get(
    Uri.parse('${baseUrl}saved'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['saved_articles'];
    final List<Map<String, dynamic>> articles = List<Map<String, dynamic>>.from(
        data.map((item) => item as Map<String, dynamic>));
    return articles;
  } else {
    // Handle errors
    throw Exception('Failed to load saved articles');
  }
}
Future<List<Map<String, dynamic>>> getSaved() async {
  try {
    List<Map<String, dynamic>> articles = await fetchSavedArticles();
    print('Saved Articles:');
    print(articles);
    return articles;
  } catch (e) {
    throw Exception('Error fetching saved articles: $e');
  }
}

void saveArticle(Map<String, String> article) async {
  log("add article to saved", level: 0);
  const url = '${baseUrl}update_saved';
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({'article': article}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Handle a successful response
    log('Successfully saved article', level: 0);
  } else {
    // Handle errors
    log('Failed to save article: ${response.statusCode}', level: 0);
  }
}

void sendQuery(String query) async {
  log("add article to saved", level: 0);
  const url = '${baseUrl}query';
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({'query': query}),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    // Handle a successful response
    log('Successfully sent query', level: 0);
  } else {
    // Handle errors
    log('Failed to send query: ${response.statusCode}', level: 0);
  }
}

void setLanguage(String language) async {
  log("set language", level: 0);
  const url = '${baseUrl}language';
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({'language': language}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Handle a successful response
    log('Langueage sent successfully', level: 0);
  } else {
    // Handle errors
    log('Failed to set language: ${response.statusCode}', level: 0);
  }
}

void main() async {
  // Example call when user submits preferences
  log("main", level: 0);
  Map<String, bool> selectedPreferences = {
    'technology': false,
    'sports': false
  };
  //sendPreferences(selectedPreferences);
  Map<String, dynamic> news = await getNews();
  print(news);
}
