import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/design/theme_provider.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Create an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoginSuccessful = false;
  String _userData = '';

  @override
  void initState() {
    super.initState();
    // Check if the user is already signed in when the widget is initialized
    _checkLoginStatus();
  }

  // Function to check if the user is signed in
  Future<void> _checkLoginStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _isLoginSuccessful = true;
      });
      _fetchUserData(FirebaseAuth.instance.currentUser?.email ?? '');
    }
  }

  Future<void> _fetchUserData(String email) async {
    try {
      DocumentSnapshot userDataSnapshot = await _firestore
          .collection('User')
          .doc(email)
          .get(); // Fetch using email
      if (userDataSnapshot.exists) {
        setState(() {
          String userEmail = userDataSnapshot['email'];
          String phoneNumber = userDataSnapshot['phoneNumber'];
          String username = userDataSnapshot['username'];
          _userData =
          'Email: $userEmail\nPhone Number: $phoneNumber\nUsername: $username';
        });
      }
    } catch (e) {
      _userData = 'Error fetching user data: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: _isLoginSuccessful
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login successful'),
                  SizedBox(height: 20),
                  Text('Below are the data'),
                  SizedBox(height: 20),
                  Text('User Data $_userData'),
                ],
              )
            : CircularProgressIndicator(), // Placeholder for loading indicator
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          theme.toggleDarkMode();
        },
        tooltip: 'toggle dark/light mode',
        child: const Icon(Icons.visibility),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider())
        ],
        child: Consumer<ThemeProvider>(builder: (context, th, _) {
          return MaterialApp(
            title: 'Firebase Demo',
            theme: th.isDarkMode
                ? ThemeData.dark()
                : ThemeData(
                    cardColor: Colors.cyanAccent,
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
            home: Menu(),
          );
        }));
  }
}
