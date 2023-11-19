import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

void sendSavedID(int id) async {
  log("send id", level: 0);
  const url = 'http://127.0.0.1:5000/update_saved';
  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode({'id': id}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Handle a successful response
    log('Saved id sent successfully', level: 0);
  } else {
    // Handle errors
    log('Failed to send saved id: ${response.statusCode}', level: 0);
  }
}

Future<List<Map<String, dynamic>>> fetchSavedArticles() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/saved'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data =
        json.decode(response.body);
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

void main() async {
  // Example call when user submits preferences
  log("main", level: 0);
  //sendSavedID(1);
  List<Map<String, dynamic>> saved = await getSaved();
  print(saved);
}