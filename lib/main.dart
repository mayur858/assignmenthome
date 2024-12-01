import 'package:assignmenthome/screens/tabs.dart';
import 'package:flutter/material.dart';

final theme = ThemeData(
  primarySwatch: Colors.amber, 
  primaryColor: Colors.amber[800], 
  hintColor: Colors.amber[800], 
  scaffoldBackgroundColor: Colors.white, 

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.black87, 
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.amber[800], 
    textTheme: ButtonTextTheme.primary, 
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.amber, 
    titleTextStyle:
        TextStyle(fontSize: 20, color: Colors.white), 
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.amber[800], 
    selectedItemColor: Colors.black54, 
    unselectedItemColor: Colors.black54, 
  ),

);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TabsScreen(title: 'Dashboard',),
    );
  }
}
