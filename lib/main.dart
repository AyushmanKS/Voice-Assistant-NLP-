import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walmart/screens/info_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Voice Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
      routes: {'/cart': (_) => CartScreen(), '/info': (_) => InfoScreen()},
    );
  }
}