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
Future<List<Map<dynamic, dynamic>>> fetchSavedArticles() async {
  final response = await http.get(
    Uri.parse('${baseUrl}saved'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['saved_articles'];
    final List<Map<dynamic, dynamic>> articles =
        List<Map<dynamic, dynamic>>.from(
            data.map((item) => item as Map<dynamic, dynamic>));
    return articles;
  } else {
    // Handle errors
    throw Exception('Failed to load saved articles');
  }
}

Future<List<Map<dynamic, dynamic>>> getSaved() async {
  try {
    List<Map<dynamic, dynamic>> articles = await fetchSavedArticles();
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

// Future<List<dynamic>> sendQuery(String query) async {
//   log("add article to saved", level: 0);
//   const url = '${baseUrl}query';

//   final response = await http.post(
//     Uri.parse(url),
//     body: jsonEncode({'query': query}),
//     headers: {'Content-Type': 'application/json'},
//   );
//   if (response.statusCode == 200) {
//     // Handle a successful response
//     print("Successfully sent query");
//     log('Successfully sent query', level: 0);

//     // send GET request
//     final response = await http.get(
//     Uri.parse(url)
//     );
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data;
//     } else {
//       // Handle errors
//       throw Exception('Failed to retrieve queried articles');
//     }

//   } else {
//     // Handle errors
//     throw Exception('Failed to send query');
//   }
// }

Future<List<dynamic>> sendQuery(String query) async {
  final url = Uri.parse('${baseUrl}search_query');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result['success']) {
        //print(result['articles']);
        return result['articles'];
      } else {
        print('Error: ${result['error']}');
        return [];
      }
    } else {
      print('Failed to fetch articles. Status code: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error: $error');
    return [];
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
    log('Language sent successfully', level: 0);
  } else {
    // Handle errors
    log('Failed to set language: ${response.statusCode}', level: 0);
  }
}

// Testing
void main() async {
  final query = 'Palestine';
  List<dynamic> a = await sendQuery(query);
  print(a[0]);
}

List<dynamic> savedArticles = [];
void updateSaved() async {
  try {
    savedArticles = await getSaved(); // Notice the 'await' keyword
  } catch (e) {
    print('Failed to load saved articles: $e');
    // Handle the error state or notify the user
    savedArticles = [];
  }
}

// void main() async {
//   // Example call when user submits preferences
//   log("main", level: 0);
//   Map<String, bool> selectedPreferences = {
//     'technology': false,
//     'sports': false
//   };
//   //sendPreferences(selectedPreferences);
//   //Map<String, dynamic> news = await getNews();
//   //print(news);
//   updateSaved();
//   print(savedArticles);
// }
