import 'package:flutter/material.dart';
import 'package:template_project/signIn.dart';
import 'signUp.dart';
import 'start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'UAS MOBILE JASMINE 2D',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Start(),
    routes: {
      '/signIn': (context) => const SignInPage(),
      '/signUp': (context) => SignUpPage()
    },
  );
 }
}
