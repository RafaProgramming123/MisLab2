import 'package:flutter/material.dart';

import '../models/joke_model.dart';
import '../services/firebase_service.dart';
import '../services/jokes_service.dart';

class JokesListScreen extends StatefulWidget {
  final String type;
  JokesListScreen({super.key, required this.type});

  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  final JokeService jokeService = JokeService();
  final FirebaseService firebaseService = FirebaseService();
  Set<int> favoritedJokes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Jokes'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(

        child: FutureBuilder<List<Joke>>(
          future: jokeService.getJokesByType(widget.type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load jokes'));
            } else {
              final jokes = snapshot.data!;
              return jokes.isEmpty
                  ? const Center(
                child: Text(
                  "No jokes found!",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: jokes.length,
                itemBuilder: (context, index) {
                  final joke = jokes[index];
                  final isFavorited = favoritedJokes.contains(index);

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            joke.setup,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            joke.punchline,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                isFavorited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorited
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () async {
                                await firebaseService
                                    .saveFavoriteJoke(joke);
                                setState(() {
                                  if (isFavorited) {
                                    favoritedJokes.remove(index);
                                  } else {
                                    favoritedJokes.add(index);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
