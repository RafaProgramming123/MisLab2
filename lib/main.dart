import 'package:flutter/material.dart';
import 'screens/random_joke.screen.dart';
import 'screens/home_screen.dart';
import 'screens/joke_list_screen.dart';


void main() {
  runApp(const JokeApp());
}

class JokeApp extends StatelessWidget {
  const JokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke App 211261',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/jokes_list': (context) => const JokeListScreenRouter(),
        '/random_joke': (context) => const RandomJokeScreen(),
      },
    );
  }
}

class JokeListScreenRouter extends StatelessWidget {
  const JokeListScreenRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final String type = ModalRoute.of(context)?.settings.arguments as String;
    return JokeListScreen(type: type);
  }
}
