import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController _webViewController;
  TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("In-App WebView Example"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Replace 'https://example.com' with your desired URL
              _webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse('https://example.com')));
            },
            child: Text('Load URL'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse('https://example.com')),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
