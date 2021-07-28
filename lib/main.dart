import 'package:flutter/material.dart';
import 'global_variables.dart';
import 'ui.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getKeys();
  runApp(MyApp());
  print(objectTypesCarousel.length);
}

class MyApp extends StatelessWidget {
  Widget runMyApp() {
    if (prefs.getBool("educamwelcomeRunned") == true) {
      return MainPage();
    } else {
      return IntroScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: runMyApp(),
      ),
      navigatorObservers: [analyticsInstance.getAnalyticsObserver()],
    );
  }
}

