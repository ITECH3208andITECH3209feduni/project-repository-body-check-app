import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateManager(ThemeData(brightness: Brightness.light)),
      child: MyApp(),
    ),
  );
}

class AppStateManager with ChangeNotifier {
  ThemeData _themeData;
  String _selectedMascot = 'assets/mascot_shark.png';
  String _userName = '';

  AppStateManager(this._themeData);

  ThemeData get themeData => _themeData;
  String get selectedMascot => _selectedMascot;
  String get userName => _userName;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light
        ? ThemeData(brightness: Brightness.dark)
        : ThemeData(brightness: Brightness.light);
    notifyListeners();
  }

  void setMascot(String mascot) {
    _selectedMascot = mascot;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    return MaterialApp(
      theme: appStateManager.themeData,
      home: appStateManager.userName.isEmpty ? IntroScreen() : HomeScreen(),
      routes: {
        '/create': (context) => CreatePage(),
        '/schedule': (context) => SchedulePage(),
        '/settings': (context) => SettingsPage(),
        '/stomach': (context) => StomachScreen(), // New route for the stomach screen
      },
    );
  }
}

class IntroScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bodycheck.png',
                height: 150,
              ),
              SizedBox(height: 20),
              Image.asset(appStateManager.selectedMascot, height: 100),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF00E676),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  'Hello there! I\'m Ziggy, let\'s check up on your body. What\'s your name?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Please enter your name below:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    appStateManager.setUserName(_nameController.text);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StomachScreen()), // Navigate to the new screen
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF000080),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StomachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ziggy the shark image with fixed size
              Image.asset(
                appStateManager.selectedMascot,
                width: 120,  // Adjust width
                height: 120, // Adjust height
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF00E676),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  "Let's take a look at your stomach!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              // Stomach image acting as an icon with increased size and tappable action
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Image.asset(
                  'assets/stomach.png',
                  width: 150,  // Adjust width for better proportion
                  height: 150, // Adjust height for better proportion
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Icon(
          Icons.home,
          color: Color(0xFF00E676),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFF00E676)),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: Color(0xFF00E676)),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/bodycheck.png',
              height: 200,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF00E676),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            "Let's try this out!",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          appStateManager.selectedMascot,
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Welcome to the Body Check App, ${appStateManager.userName}!'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, '/create');
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: $result')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF000080),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text('Submit a Body Check'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/schedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF000080),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text('Schedule Checks'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showIndividualHelp(context, 'Creation Page', 'Create a custom body check.');
                  },
                  child: Text('Creation Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showIndividualHelp(context, 'Schedule Page', 'Schedule your body checks.');
                  },
                  child: Text('Schedule Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showIndividualHelp(context, 'Settings Page', 'Toggle between light and dark themes.');
                  },
                  child: Text('Settings Page'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showIndividualHelp(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  final List<String> mascots = [
    'assets/mascot_fox.png',
    'assets/mascot_shark.png',
    'assets/mascot_lizard.png',
  ];

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/bodycheck.png',
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Mascot:',
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: mascots.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      appStateManager.setMascot(mascots[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected ${mascots[index].split('/').last}')),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF4DD0E1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.asset(
                        mascots[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: appStateManager.themeData.brightness == Brightness.dark,
                onChanged: (value) {
                  appStateManager.toggleTheme();
                },
                activeColor: Color(0xFF00E676),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/Breathless.png',
    'assets/Butterflies.png',
    'assets/Bloated.png',
    'assets/Cramp.png',
    'assets/Dry.png',
    'assets/Gassy.png',
    'assets/Growling.png',
    'assets/Nauseous.png',
    'assets/Wobbly.png',
  ];

  final List<String> imageDescriptions = [
    'Breathless',
    'Butterflies',
    'Bloated',
    'Cramp',
    'Dry',
    'Gassy',
    'Growling',
    'Nauseous',
    'Wobbly',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Body Check'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF00E676),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      "How are you feeling today?",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    'assets/mascot_shark.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, imageDescriptions[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF4DD0E1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(imagePaths[index], height: 80, width: 80),
                              SizedBox(height: 10),
                              Text(
                                imageDescriptions[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Two new buttons at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // "I'm not sure" button
                  ElevatedButton(
                    onPressed: () {
                      // Add any action you want for this button
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF000080), // Navy blue color
                      foregroundColor: Colors.white, // White text
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text("I'm not sure"),
                  ),
                  // "Save and exit" button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF000080), // Navy blue color
                      foregroundColor: Colors.white, // White text
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text("Save and exit"),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Body Checks'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text('Here you can schedule your body checks.'),
        ),
      ),
    );
  }
}
