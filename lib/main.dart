import 'package:algohub/providers/user_provider.dart';
import 'package:algohub/screens/signup%20_screen.dart';
import 'package:algohub/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TaskProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/splashScreen": (_) => const SplashScreen(),
        "/signup": (_) => const SignupScreen(),
        "/login": (_) => const LoginScreen(),
        "/home": (_) => const HomeScreen(),
      },
      initialRoute: "/splashScreen",
    );
  }
}