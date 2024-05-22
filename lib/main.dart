import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(ThemeData(brightness: Brightness.light)),
      child: MyApp(),
    ),
  );
}

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;

  ThemeManager(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light
        ? ThemeData(brightness: Brightness.dark)
        : ThemeData(brightness: Brightness.light);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      theme: themeManager.themeData,
      home: HomeScreen(),
      routes: {
        '/create': (context) => CreatePage(),
        '/schedule': (context) => SchedulePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Body Check App'),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create'),
              child: Text('Create Body Check'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/schedule'),
              child: Text('Schedule Checks'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: Text('Settings'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Body Part:'),
              Row(
                children: [
                  Radio(
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
                  Radio(
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
                  Radio(
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
                  Radio(
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
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListTile(
        title: Text('Toggle Theme'),
        trailing: Switch(
          value: themeManager.themeData.brightness == Brightness.dark,
          onChanged: (value) {
            themeManager.toggleTheme();
          },
        ),
      ),
    );
  }
}
