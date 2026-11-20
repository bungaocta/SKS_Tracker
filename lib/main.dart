import 'package:flutter/material.dart';
 
import 'view/home_page.dart';
 
void main() {
  runApp(const SKSTrackerApp());
}
 
class SKSTrackerApp extends StatelessWidget {
  const SKSTrackerApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKS Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
 