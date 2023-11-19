import 'package:flutter/material.dart';
import './utils.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  bool showPreferences = false; // Track the visibility state
  bool showSettings = false;
  String selectedLanguage = 'English';
  Map<String, bool> toggleStates = {
    'Business': true,
    'Entertainment': true,
    'General': true,
    'Health': true,
    'Science': true,
    'Sports': true,
    'Technology': true,
  };
  String source = '';
  String author = '';
  String title = '';
  String lead = '';
  String url = '';
  String media = '';
  String date = '';
  int id = 0;
  bool containersInitialized = false;

  ScrollController _scrollController = ScrollController();
  List<Widget> containers = [];
  List<Widget> favoritesContainers = [];
  List<int> ids = [];
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => updateNewsData());
    controller = WebViewController();
  }

  void _scrollDown() async {
    final newData = await getNews();
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    print("scroll down");
  }

  void updateNewsData() async {
    try {
      final newData = await getNews(); // Notice the 'await' keyword
      setState(() {
        source = newData['source'];
        author = newData['author'];
        title = newData['title'];
        lead = newData['description'];
        url = newData['url'];
        media = newData['urltoimage'];
        date = newData['publishedat'];
        id = newData['id'];
        print(id);
      });
    } catch (e) {
      print('Failed to load news data: $e');
      // Handle the error state or notify the user
    }
  }

  void onScroll() {
    print("start");
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the scroll, add a new container
      setState(() {
        containers = List.from(containers);
        var newContainer =
            buildContainer(id, source, author, title, lead, url, media, date);
        containers.add(newContainer);
      });
    }
  }

  Widget buildContainer(int buttonID, String source, String author, String title, String lead, String url, String media, String date) {
    // Call updateNewsData to fetch the news data
    updateNewsData();
    double containerHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + // Adjust for top padding
            kToolbarHeight + // Adjust for app bar height
            kBottomNavigationBarHeight + // Adjust for bottom navigation bar height
            kBottomNavigationBarHeight);
    return Container(
      height: containerHeight,
      child: Container(
        //height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F2FD),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF6D3C90),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                title.isNotEmpty ? title : "Loading...",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8), // Reduced spacing

              // Source and Author
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    source.isNotEmpty ? source : "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    author.isNotEmpty ? "By $author" : "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8), // Reduced spacing

              // Media Image
              if (media.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      media,
                      fit: BoxFit.cover,
                      height: 225, // Adjust the height as needed
                    ),
                  ),
                ),
              const SizedBox(height: 12), // Reduced spacing

              // Date in Bold and Lead Text
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: date.isNotEmpty ? parseDate(date) + ' - ' : "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: lead.isNotEmpty ? lead : "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge, // Uses bodyLarge for consistency
                    ),
                  ],
                ),
                maxLines: 4, // Increased to 8 lines
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(), // Pushes the button to the bottom

              // Bottom Row with Read More button and Bookmark and Chat buttons
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns items to opposite ends
                children: [
                  // Expanded Read More button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        readMore(url);
                      },
                      child: Text(
                        'Read More'.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Color(
                                0xFF48454F)), // Matches font size with lead, author, and date
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE1DBED), // Custom background color
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  // Spacer for separation
                  const SizedBox(width: 14),
                  // Icon buttons in a row
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE1DBED),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_border,
                              color:
                                  Color(0xFF48454F)), // Unfilled bookmark icon
                          onPressed: () {
                            addToFavorites(buttonID, source, author, title,
                                lead, url, media, date);
                          },
                        ),
                      ),
                      const SizedBox(width: 14), // Spacing between icons
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE1DBED),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline,
                              color:
                                  Color(0xFF48454F)), // More circular chat icon
                          onPressed: () {
                            // Add your chat event handler
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFavoritesContainer(int buttonID, String source, String author,
      String title, String lead, String url, String media, String date) {
    return Card(
      child: Container(
        height: 255,
        child: Column(
          children: [
            // Top Half: Image
            Container(
              height: 110, // Adjust the height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(media),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0), // Adjust the radius as needed
                  topRight: Radius.circular(8.0), // Adjust the radius as needed
                ),
              ),
            ),
            // Bottom Half: Title, Subtext, Read More Button
            Padding(
              padding: EdgeInsets.all(14.0), // Adjust the padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1, // Limit the text to one line
                    overflow: TextOverflow
                        .ellipsis, // Display ellipsis (...) when the text overflows
                  ),
                  SizedBox(height: 8), // Adjust the spacing as needed
                  Text(
                    lead,
                    style: TextStyle(
                        fontSize: 16), // Adjust the font size as needed
                    maxLines: 1, // Limit the text to one line
                    overflow: TextOverflow
                        .ellipsis, // Display ellipsis (...) when the text overflows
                  ),
                  SizedBox(height: 8), // Adjust the spacing as needed
                  Row(
                    children: [
                  // Expanded Read More button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        readMore(url);
                      },
                      child: Text(
                        'Read More'.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Color(
                                0xFF48454F)), // Matches font size with lead, author, and date
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE1DBED), // Custom background color
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  // Spacer for separation
                  const SizedBox(width: 14),
                  // Icon buttons in a row
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE1DBED),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline,
                              color:
                                  Color(0xFF48454F)), // More circular chat icon
                          onPressed: () {
                            // Add your chat event handler
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize containers only once
    if (!containersInitialized) {
      _initializeContainers();
      containersInitialized = true;
    }
    final ThemeData theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: const Color(0xFFE1DBED),
          elevation: 0, // No shadow
          flexibleSpace: Column(
            children: [
              Container(
                height: statusBarHeight, // Status bar height
                color: const Color(0xFFE1DBED),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFE1DBED),
        onDestinationSelected: (int index) {
          if (index==0){
            // Refresh the app by pushing a new instance of the root widget
            setState(() {
              currentPageIndex = index;
            });
            _scrollDown();
          }
          else{
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        indicatorColor: const Color(0xFFB4A6D5),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Scaffold(
          body: Column(
            children: [
              // Fixed header
              const SafeArea(
                child: SizedBox(height: 0), // Space above the logo
              ),
              Image.asset('assets/images/logo.jpg'),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  physics: PageScrollPhysics(),
                  children: containers,
                ),
              ),
            ],
          ),
        ),

        /// Saved page
        Scaffold(
          body: Column(
            children: [
              // Fixed header
              const SafeArea(
                child: SizedBox(height: 0), // Space above the logo
              ),
              Image.asset('assets/images/logo.jpg'),

              // Scrollable content
              Expanded(
                child: ListView(
                  children: favoritesContainers,
                ),
              ),
            ],
          ),
        ),

        // Search page
        Scaffold(
          body: Column(
            children: [
              const SafeArea(
              child: SizedBox(height: 0), // Space above the logo
              ),
              Image.asset('assets/images/logo.jpg'),
              // Search bar and button
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Search bar and button
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                            ),
                            onChanged: (query) {
                              // Handle search query changes
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Handle search action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Profile page
        ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SafeArea(
                    child: SizedBox(height: 0), // Space above the logo
                  ),
                  Image.asset('assets/images/logo.jpg'),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE1DBED),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Center(
                          // Center the image within the ClipOval
                          child: Image.asset(
                            'assets/images/bread_sheeran.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
                    child: Text(
                      'Bread Sheeran',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),

                  // Settings
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showSettings = !showSettings;
                              showPreferences = false;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Settings',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  showSettings
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showSettings,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 12),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 12, 12, 12),
                                child: Column(
                                  children: [
                                    // Language Dropdown
                                    Row(
                                      children: [
                                        Text(
                                          'Language: ',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        DropdownButton<String>(
                                          value: selectedLanguage,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedLanguage = newValue!;
                                            });
                                          },
                                          items: <String>['English', 'French']
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    // Save Settings button
                                    Visibility(
                                      visible: showSettings,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            saveSettings();
                                          },
                                          child: const Text('Save Settings'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Preferences
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showPreferences = !showPreferences;
                              showSettings = false;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Preferences',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  showPreferences
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showPreferences,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 12),
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 12, 12, 12),
                                child: ListView(
                                  children: [
                                    buildToggleTile('Business', theme),
                                    buildToggleTile('Entertainment', theme),
                                    buildToggleTile('General', theme),
                                    buildToggleTile('Health', theme),
                                    buildToggleTile('Science', theme),
                                    buildToggleTile('Sports', theme),
                                    buildToggleTile('Technology', theme),
                                    // Save Preferences button
                                    Visibility(
                                      visible: showPreferences,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            savePreferences();
                                          },
                                          child: const Text('Save Preferences'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ][currentPageIndex],
    );
  }

  void _initializeContainers() {
    // Initial containers
    containers = [
      buildContainer(397, "WION", "WION Web Team", "Mars vanishes in rare celestial event, will come back after 2 weeks - WION", "Mars vanishes in rare celestial event, will come back after 2 weeks", " https://www.wionews.com/science/mars-vanishes-in-rare-celestial-event-will-come-back-after-2-weeks-660104", "https://cdn.wionews.com/sites/default/files/2023/11/18/393892-untitled-design-84.png", "2023-11-18T11:01:03Z"),
      // buildContainer(0, "", "", "", "", "", "", ""),
      // buildContainer(0, "", "", "", "", "", "", ""),
    ];
    favoritesContainers = [
      // buildFavoritesContainer(
      //     0,
      //     "",
      //     "",
      //     "Test Title",
      //     "",
      //     "https://montreal.ctvnews.ca/content/dam/ctvnews/en/images/2022/9/14/high-school-1-6068707-1663193049618.jpg",
      //     "https://montreal.ctvnews.ca/content/dam/ctvnews/en/images/2022/9/14/high-school-1-6068707-1663193049618.jpg",
      //     "")
    ];
  }

  Widget buildToggleTile(String title, ThemeData theme) {
    return SwitchListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyMedium,
      ),
      value: toggleStates[title] ?? false,
      onChanged: (value) {
        setState(() {
          toggleStates[title] = value;
        });
      },
    );
  }

  // Function to save preferences
  void savePreferences() {
    // update preferences in backend
    print('Saving preferences: $toggleStates');
    Map<String, bool> preferences = {};
    toggleStates.forEach((key, value) {
      preferences[key] = value;
    });
    sendPreferences(preferences);
  }

  void saveSettings() {
    // Implement the logic to send toggleStates to your desired function or API
    // For example, you can print the states for now
    print('Saving settings: $selectedLanguage');
    String lang = selectedLanguage.toString();
    setLanguage(lang);
  }

  String parseDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String month = '';
    switch (parsedDate.month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
    }
    String day = parsedDate.day.toString();
    String year = parsedDate.year.toString();
    return month != 'May' ? "$month. $day, $year" : "$month $day, $year";
  }

  void addToFavorites(int id, String source, String author, String title,
      String lead, String url, String media, String date) {
    print(ids);
    print(ids.indexOf(id));
    if(ids.indexOf(id)==-1) {
      setState(() {
        favoritesContainers = List.from(favoritesContainers);
        var newContainer = buildFavoritesContainer(
            id, source, author, title, lead, url, media, date);
        favoritesContainers.add(newContainer);
        ids.add(id);
      });
    }
  }

  void readMore(String url) {
    controller.loadRequest(
      Uri.parse(url),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => buildWebView(context)),
    );
  }

  @override
  Widget buildWebView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          Navigator.pop(context, true);
        },
      )),
      body: WebViewWidget(
        controller: controller,
      ));
  }
}
