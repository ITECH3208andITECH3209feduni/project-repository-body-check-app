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
      appBar: AppBar(title: Text('Home')),
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
            ElevatedButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Schedule Checks')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                print('Selected Option: $_selectedOption');
                // Add logic for scheduling here
              },
              child: Text('Confirm'),
            ),
          ],
        ),
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




