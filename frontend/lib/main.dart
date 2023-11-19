import 'package:flutter/material.dart';
import './utils.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    'Business': false,
    'Entertainment': false,
    'General': false,
    'Health': false,
    'Science': false,
    'Sports': false,
    'Technology': false,
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFE1DBED),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
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
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 0), // Space above the logo
                Image.asset('assets/images/logo.jpg'),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15.0), // Consistent spacing around the container
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3), // Tile colour
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF6D3C90)), // Border colour
                    ),
                    // To do
                  ),
                ),
              ],
            ),
          ),

        /// Saved page
        Scaffold(
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Card(
                  child: Container(
                    height: 250,
                    child: Column(
                      children: [
                        // Top Half: Image
                        Container(
                          height: 110, // Adjust the height as needed
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://montreal.ctvnews.ca/content/dam/ctvnews/en/images/2022/9/14/high-school-1-6068707-1663193049618.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),  // Adjust the radius as needed
                              topRight: Radius.circular(8.0), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        // Bottom Half: Title, Subtext, Read More Button
                        Padding(
                          padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exam scores, graduations and gender gaps: Quebecs high schools, ranked',
                                style: TextStyle(
                                  fontSize: 20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1, // Limit the text to one line
                                overflow: TextOverflow.ellipsis, // Display ellipsis (...) when the text overflows
                              ),
                              SizedBox(height: 8), // Adjust the spacing as needed
                              Text(
                                'A ranking of Quebec high schools was published on Friday, scoring their performance on a variety of academic indicators.',
                                style: TextStyle(fontSize: 16), // Adjust the font size as needed
                                maxLines: 1, // Limit the text to one line
                                overflow: TextOverflow.ellipsis, // Display ellipsis (...) when the text overflows
                              ),
                              SizedBox(height: 8), // Adjust the spacing as needed
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle the first button press
                                    },
                                    child: Text('Read More'),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle the second button press
                                    },
                                    child: Text('Remove from Saved'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 250,
                    child: Column(
                      children: [
                        // Top Half: Image
                        Container(
                          height: 110, // Adjust the height as needed
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://montreal.ctvnews.ca/content/dam/ctvnews/en/images/2022/9/14/high-school-1-6068707-1663193049618.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),  // Adjust the radius as needed
                              topRight: Radius.circular(8.0), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        // Bottom Half: Title, Subtext, Read More Button
                        Padding(
                          padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Title',
                                style: TextStyle(
                                  fontSize: 20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8), // Adjust the spacing as needed
                              Text(
                                'Your Subtext',
                                style: TextStyle(fontSize: 16), // Adjust the font size as needed
                              ),
                              SizedBox(height: 8), // Adjust the spacing as needed
                              ElevatedButton(
                                onPressed: () {
                                  // Handle Read More button press
                                },
                                child: Text('Read More'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 250,
                    child: Column(
                      children: [
                        // Top Half: Image
                        Container(
                          height: 110, // Adjust the height as needed
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://montreal.ctvnews.ca/content/dam/ctvnews/en/images/2022/9/14/high-school-1-6068707-1663193049618.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),  // Adjust the radius as needed
                              topRight: Radius.circular(8.0), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        // Bottom Half: Title, Subtext, Read More Button
                        Padding(
                          padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Title',
                                style: TextStyle(
                                  fontSize: 20, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8), // Adjust the spacing as needed
                              Text(
                                'Your Subtext',
                                style: TextStyle(fontSize: 16), // Adjust the font size as needed
                              ),
                              SizedBox(height: 8), // Adjust the spacing as needed
                              ElevatedButton(
                                onPressed: () {
                                  // Handle Read More button press
                                },
                                child: Text('Read More'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),


        // Search page
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
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
                              height: 350,
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
    print('Saving Preferences: $toggleStates');
    Map<String, bool> preferences = {};
    toggleStates.forEach((key, value) {
      preferences[key] = value;
    });
    sendPreferences(preferences);
  }

  void saveSettings() {
    // Implement the logic to send toggleStates to your desired function or API
    // For example, you can print the states for now
    print('Saving Settings: $selectedLanguage');
  }
}
