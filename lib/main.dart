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
            height: 100, // Adjust this value as needed
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
                    onPressed: () => Navigator.pushNamed(context, '/create'),
                    child: Text('Create Body Check'),
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

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bodyCheckController = TextEditingController();
  double _rating = 0;
  bool _isCompleted = false;
  String _selectedBodyPart = 'Head';
  bool _isCustomBodyPartSelected = false;
  String _customBodyPart = '';

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      _showDialog(
        "Success",
        "Body Check details are valid:\nBody Part: ${_isCustomBodyPartSelected ? _customBodyPart : _selectedBodyPart}\nRating: $_rating\nCompleted: $_isCompleted",
      );
      _bodyCheckController.clear();
    } else {
      _showDialog("Error", "Please correct the errors in the form.");
    }
  }

  void _resetForm() {
    setState(() {
      _bodyCheckController.clear();
      _rating = 0;
      _isCompleted = false;
      _selectedBodyPart = 'Head';
      _isCustomBodyPartSelected = false;
      _customBodyPart = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Custom Body Check'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Select Body Part:'),
              Row(
                children: [
                  Radio<String>(
                    value: 'Head',
                    groupValue: _selectedBodyPart,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBodyPart = value!;
                        _isCustomBodyPartSelected = false;
                      });
                    },
                  ),
                  Text('Head'),
                  Radio<String>(
                    value: 'Torso',
                    groupValue: _selectedBodyPart,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBodyPart = value!;
                        _isCustomBodyPartSelected = false;
                      });
                    },
                  ),
                  Text('Torso'),
                  Radio<String>(
                    value: 'Legs',
                    groupValue: _selectedBodyPart,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBodyPart = value!;
                        _isCustomBodyPartSelected = false;
                      });
                    },
                  ),
                  Text('Legs'),
                  Radio<String>(
                    value: 'Custom',
                    groupValue: _selectedBodyPart,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBodyPart = value!;
                        _isCustomBodyPartSelected = true;
                      });
                    },
                  ),
                  Text('Custom'),
                ],
              ),
              if (_isCustomBodyPartSelected)
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _customBodyPart = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Custom Body Part',
                  ),
                  validator: (value) {
                    if (_isCustomBodyPartSelected && value!.isEmpty) {
                      return 'Please enter a custom body part';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              Text(
                'Rate Condition:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _rating,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                min: 0,
                max: 10,
                divisions: 10,
                label: _rating.toStringAsFixed(1),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value!;
                      });
                    },
                  ),
                  Text(
                    'Mark as Completed',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateAndSubmit,
                child: Text('Save Body Check'),
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
              height: 100, // Adjust this value as needed
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
