import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

void sendPreferences(Map<String, bool> preferences) async {
  log("send preferences", level: 0);
  const url = 'http://127.0.0.1:5000/preferences';
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

Future<Map<String, dynamic>> fetchNewsArticles() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/news'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data =
        json.decode(response.body)['news_article'];
    return data;
  } else {
    // Handle errors
    throw Exception('Failed to load news articles');
  }
}

// Take multiple articles as input

// Future<List<Map<String, dynamic>>> fetchNewsArticles() async {
//   final response = await http.get(
//     Uri.parse('http://127.0.0.1:5000/news'),
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> data =
//         json.decode(response.body)['news_articles'];
//     final List<Map<String, dynamic>> articles =
//         List<Map<String, dynamic>>.from(data.map((item) => item as Map<String, dynamic>));
//     //final List<Map<String, dynamic>> articles = data['news_articles'];
//     return articles;
//   } else {
//     // Handle errors
//     throw Exception('Failed to load news articles');
//   }
// }

void getNews() async {
  try {
    Map<String, dynamic> articles = await fetchNewsArticles();
    print('News Articles:');
    print(articles);
  } catch (e) {
    print('Error fetching news articles: $e');
  }
}

void setLanguage(String language) async {
  log("set language", level: 0);
  const url = 'http://127.0.0.1:5000/language';
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

void main() {
  // Example call when user submits preferences
  log("main", level: 0);
  Map<String, bool> selectedPreferences = {
    'technology': false,
    'sports': false
  };
  sendPreferences(selectedPreferences);
  getNews();
}
