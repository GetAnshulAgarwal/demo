// lib/main.dart
import 'package:demo/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/post_provider.dart';

void main() {
  String apiToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2MDk5Mjg4ZTM1OGRkYjkyMzI5ZDQyNiIsImlhdCI6MTcyNzc3NzIxMCwiZXhwIjoxNzMwMzY5MjEwfQ.ILp3I9AY6OBG0UGrYr0oU3RET1OdqRNvFbcUsUcS4QQ";
  runApp(MyApp(apiToken: apiToken));
}

class MyApp extends StatelessWidget {
  final String apiToken;

  MyApp({required this.apiToken});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(apiToken: apiToken),
      child: MaterialApp(
        title: 'Demo App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
