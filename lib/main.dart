import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/create': (context) => CreatePage(), // Define route for CreatePage
      }
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Set the background color to blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello! Welcome to the Body Check App', // Text to display
              style: TextStyle(
                fontSize: 40,
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // Navigate to the CreatePage when the "Creation Page" button is pressed
                Navigator.pushNamed(context, '/create');
              },
              child: Text('Creation Page'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Text(
          'Hello there, welcome to the create page for custom body checks', // Text to display
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black, // Text color
          ),
        ),
      ),
    );
  }
}