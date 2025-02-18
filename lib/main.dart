import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mis_lab_2/screens/favourite_joke_screen.dart';
import 'package:mis_lab_2/screens/joke_list_screen.dart';
import 'package:mis_lab_2/screens/jokes_type_screen.dart';
import 'package:mis_lab_2/screens/login_screen.dart';
import 'package:mis_lab_2/screens/random_joke.screen.dart';
import 'package:mis_lab_2/screens/register_screen.dart';
import 'package:mis_lab_2/services/auth_service.dart';
import 'package:mis_lab_2/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'models/joke_model.dart';
import 'providers/password_visibility_provider.dart';
import 'providers/joke_provider.dart';
import 'screens/main_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("Environment file loaded successfully: ${dotenv.env}");
  } catch (e) {
    print("Error loading environment file: $e");
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for notifications
    messaging.requestPermission();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id', // Channel ID
              'channel_name', // Channel Name
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<PasswordVisibilityProvider>(
          create: (_) => PasswordVisibilityProvider(),
        ),
        ChangeNotifierProvider<JokeProvider>(
          create: (_) => JokeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Joke Types',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Jokes'),
          NavigationDestination(
            icon: FutureBuilder<List<Joke>>(
              future: firebaseService.getFavoriteJokes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Icon(Icons.favorite_border);
                }

                if (snapshot.hasError) {
                  return Icon(Icons.error);
                }

                final favoriteJokes = snapshot.data ?? [];
                final jokeCount = favoriteJokes.length;

                return Badge(
                  label: Text(jokeCount.toString()), // Display dynamic count
                  child: const Icon(Icons.favorite),
                );
              },
            ),
            label: 'Favorites',
          ),
        ],
        selectedIndex: currentPageIndex,
      ),
      body: [
        JokesTypeScreen(),
        FavoriteJokesScreen(),
      ][currentPageIndex],
    );
  }
}
