import 'package:flutter/material.dart';
import '../widgets/joke_list_item.dart';
import '../models/joke_model.dart';
import '../services/api_services.dart';
import '../widgets/joke_list_item.dart';

class JokeListScreen extends StatelessWidget {
  final String type;

  const JokeListScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jokes of type: $type 211261")),
      body: FutureBuilder<List<Joke>>(
        future: ApiService.getJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return JokeListItem(joke: jokes[index]);
              },
            );
          }
        },
      ),
    );
  }
}
