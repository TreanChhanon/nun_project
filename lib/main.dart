import 'package:flutter/material.dart';
import 'package:nun/screen/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assignment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7BA5B3)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
