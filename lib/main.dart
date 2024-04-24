import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(toggleTheme: toggleTheme)));
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

class SettingsPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  SettingsPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
