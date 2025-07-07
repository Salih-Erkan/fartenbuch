import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/data/supabase_database_repository.dart';
import 'package:fartenbuch/src/features/splash/splash_screen.dart';
//import 'package:fartenbuch/src/features/splash/splash_screen1.dart';
import 'package:fartenbuch/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fahrtenbuch',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
