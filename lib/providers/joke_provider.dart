import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class JokeProvider with ChangeNotifier {
  final List<Joke> _jokes = [];

  List<Joke> get jokes => _jokes;

  void addJoke(Joke joke) {
    _jokes.add(joke);
    notifyListeners();
  }

  int get favoriteCount =>
      _jokes.where((joke) => joke.isFavorite).length;
}