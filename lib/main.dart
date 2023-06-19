import 'package:digital_three/Screens/login_screen.dart';
import 'package:digital_three/Screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import 'Screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const riverpod.ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const Home(),
        '/login': (BuildContext context) => const Login(),
        '/register': (BuildContext context) => const RegisterScreen(),
      },
      title: 'Testing',
      home: const Login(),
    );
  }
}
