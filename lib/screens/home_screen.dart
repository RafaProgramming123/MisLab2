import 'package:flutter/material.dart';
import '../widgets/joke_card.dart';
import '../services/api_services.dart';
import '../widgets/joke_card.dart';
import '../models/joke_type_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<JokeType> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
  }

  void fetchJokeTypes() async {
    try {
      List<JokeType> types = await ApiService.getJokeTypes();
      setState(() {
        jokeTypes = types;
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Joke Types 211261"),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              Navigator.pushNamed(context, '/random_joke');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jokeTypes.length,
        itemBuilder: (context, index) {
          return JokeCard(type: jokeTypes[index].type);
        },
      ),
    );
  }
}
