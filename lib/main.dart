import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Change this to MyApp
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _currentBrightness = Brightness.light;

  void toggleTheme() {
    setState(() {
      _currentBrightness =
          (_currentBrightness == Brightness.light) ? Brightness.dark : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: _currentBrightness),
      home: HomeScreen(toggleTheme: toggleTheme),
      routes: {
        '/create': (context) => CreatePage(),
        '/schedule': (context) => SchedulePage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  HomeScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello! Welcome to the Body Check App',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: Text('Creation Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/schedule');
              },
              child: Text('Schedule'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(toggleTheme: toggleTheme), // Pass toggleTheme here
                  ),
                );
              },
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}


class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _bodyCheckController = TextEditingController();
  double _rating = 0;
  bool _isCompleted = false;
  String _selectedBodyPart = 'Head';
  bool _isCustomBodyPartSelected = false;
  String _customBodyPart = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Body Part:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
            SizedBox(height: 20),
            if (_isCustomBodyPartSelected)
              TextField(
                onChanged: (value) {
                  setState(() {
                    _customBodyPart = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Custom Body Part',
                ),
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
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  String bodyCheck = _bodyCheckController.text;
                  print('Body Part: $_selectedBodyPart');
                  print('Condition Rating: $_rating');
                  print('Is Completed: $_isCompleted');
                  if (_isCustomBodyPartSelected) {
                    print('Custom Body Part: $_customBodyPart');
                  }
                  print('Custom Body Check: $bodyCheck');
                  _bodyCheckController.clear();
                },
                child: Text('Save Body Check'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bodyCheckController.dispose();
    super.dispose();
  }
}


class SettingsPage extends StatefulWidget {
  final VoidCallback toggleTheme; 

  SettingsPage({required this.toggleTheme}); 

  @override
  _SettingsPageState createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {
  Brightness _currentBrightness = Brightness.light;

   void toggleTheme() {
    setState(() {
      _currentBrightness =
          (_currentBrightness == Brightness.light) ? Brightness.dark : Brightness.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData _currentTheme = ThemeData(brightness: _currentBrightness);

    return MaterialApp(
      theme: _currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                _currentBrightness == Brightness.dark ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(title: Text('Option 1')),
                        ListTile(title: Text('Option 2')),
                        ListTile(title: Text('Option 3')),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentBrightness == Brightness.dark ? 'Light Mode' : 'Dark Mode',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                      Switch(
                        value: _currentBrightness == Brightness.dark,
                        onChanged: (value) {
                          toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Body Checks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Option:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
            SizedBox(height: 20),
            Text(
              'Select Time:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                _selectTime(context);
              },
              child: Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 10),
                  Text(
                    _selectedTime.format(context),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your scheduling logic here
                print('Selected Option: $_selectedOption');
                print('Selected Time: ${_selectedTime.format(context)}');
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}


