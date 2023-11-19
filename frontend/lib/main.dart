import 'package:flutter/material.dart';

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
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(91, 149, 117, 188),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
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
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
                    child: Text(
                      'Bread Sheeran',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  
                  // Settings
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
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
                            padding: EdgeInsets.all(12),
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
                            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
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
                                          items: <String>['English', 'French'].map((String value) {
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
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            saveSettings();
                                          },
                                          child: Text('Save Settings'),
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
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showPreferences = !showPreferences;
                              showSettings = !showSettings;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(12),
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
                            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                            child: Container(
                              width: double.infinity,
                              height: 350,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
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
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            savePreferences();
                                          },
                                          child: Text('Save Preferences'),
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
    // Implement the logic to send toggleStates to your desired function or API
    // For example, you can print the states for now
    print('Saving Preferences: $toggleStates');
  }

  void saveSettings() {
    // Implement the logic to send toggleStates to your desired function or API
    // For example, you can print the states for now
    print('Saving Settings: $selectedLanguage');
  }
}
