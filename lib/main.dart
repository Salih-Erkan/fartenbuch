import 'package:fartenbuch/src/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://imvaofgxrxuwuzxuijvu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImltdmFvZmd4cnh1d3V6eHVpanZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3OTA0MDIsImV4cCI6MjA2NDM2NjQwMn0.ZpcXwTN_XnV1zgwdlvhNrijAwFeX5OxKMG4ljU8UCHY',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fahrtenbuch',
      theme: ThemeData(
        primarySwatch: Colors.blue, // macht App-Leiste & Buttons blau
        scaffoldBackgroundColor: Colors.white, // Hintergrundfarbe
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Colors.blueAccent),
      ),
      home: const SplashScreen(), // <- Splash zuerst anzeigen
    );
  }
}
