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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(appStateManager.selectedMascot, height: 150),
            SizedBox(height: 20),
            Text(
              'Hello! What\'s your name?',
              style: TextStyle(fontSize: 24),
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
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
              child: Text('Continue'),
            ),
          ],
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
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/bodycheck.png',
            height: 100,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    appStateManager.selectedMascot,
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  Text('Welcome to the Body Check App, ${appStateManager.userName}!'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Wait for the selected description from CreatePage
                      final result = await Navigator.pushNamed(context, '/create');

                      // If a result is returned, show it in a SnackBar
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected: $result')),
                        );
                      }
                    },
                    child: Text('Submit a Body Check'), // Changed text here
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/schedule'),
                    child: Text('Schedule Checks'),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                    _showIndividualHelp(
                        context, 'Creation Page', 'Create a custom body check.');
                  },
                  child: Text('Creation Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showIndividualHelp(
                        context, 'Schedule Page', 'Schedule your body checks.');
                  },
                  child: Text('Schedule Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showIndividualHelp(context, 'Settings Page',
                        'Toggle between light and dark themes.');
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

class CreatePage extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/Breathless.png', // Update with your actual asset paths
    'assets/Butterflies.png',
    'assets/Bloated.png',
    'assets/Cramp.png',
    'assets/Dry.png',
    'assets/Gassy.png',
    'assets/Growling.png',
    'assets/Nauseous.png',
    'assets/Want to move.png',
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
    'Want to move',
    'Wobbly',
  ];

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Swap positions: Speech bubble on the left and mascot on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    'How are you feeling?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 10), // Space between the speech bubble and the mascot
                Image.asset(
                  appStateManager.selectedMascot, // Use the selected mascot
                  width: 100, // Adjust size as needed
                  height: 100,
                ),
              ],
            ),
            SizedBox(height: 20), // Space after the speech bubble
            // GridView for images
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle image click and return the selected description
                      Navigator.pop(context, imageDescriptions[index]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            imagePaths[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          imageDescriptions[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedOption = 1;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

  void _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  void _showDialog(String title, String content) {
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

  void _resetForm() {
    setState(() {
      _selectedOption = 1;
      _selectedTime = TimeOfDay.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule Checks')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Option:'),
              DropdownButton<int>(
                value: _selectedOption,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
                items: <int>[1, 2, 3, 4].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('Option $value'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text('Select Time'),
              ),
              SizedBox(height: 20),
              Text('Selected Time: ${_selectedTime.format(context)}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showDialog(
                      'Success',
                      'Body Check scheduled successfully at ${_selectedTime.format(context)}',
                    );
                  } else {
                    _showDialog('Error', 'Please select an option and time.');
                  }
                },
                child: Text('Save Schedule'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetForm,
        tooltip: 'Undo',
        child: Icon(Icons.undo),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final List<String> mascots = [
    'assets/mascot_fox.png',
    'assets/mascot_shark.png',
    'assets/mascot_lizard.png',
  ];

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context);
    _nameController.text = appStateManager.userName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/bodycheck.png',
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Name:',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Change Your Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (newName) {
                if (newName.isNotEmpty) {
                  appStateManager.setUserName(newName);
                }
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Mascot:',
              style: Theme.of(context).textTheme.headline6,
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
                      border: Border.all(
                        color: appStateManager.selectedMascot == mascots[index]
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor,
                        width: appStateManager.selectedMascot == mascots[index] ? 3 : 1,
                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}

