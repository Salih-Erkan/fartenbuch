import 'package:fartenbuch/src/data/database_providers.dart';
import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/presentation/create_fahrt_screen.dart';
import 'package:fartenbuch/src/features/farten/presentation/fahrt_detail_screen.dart';
import 'package:fartenbuch/src/features/farten/presentation/widgets/fahrt_list/fahrt_info.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FahrtListScreen extends ConsumerStatefulWidget {
  final Fahranlass fahrtAnlass;

  const FahrtListScreen({super.key, required this.fahrtAnlass});

  @override
  ConsumerState<FahrtListScreen> createState() => _FahrtListScreenState();
}

class _FahrtListScreenState extends ConsumerState<FahrtListScreen> {
  late final DatabaseRepository repository;
  late Future<List<Fahrt>> _fahrtenFuture;

  @override
  void initState() {
    super.initState();
    repository = ref.read(databaseRepositoryProvider);
    _ladeFahrten();
  }

  void _ladeFahrten() {
    _fahrtenFuture = repository.getFahrten(widget.fahrtAnlass.id);
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );

    return Theme(
      data: customTheme,
      child: Scaffold(
        appBar: AppBar(title: Text('Fahrten für ${widget.fahrtAnlass.name}')),
        body: FutureBuilder<List<Fahrt>>(
          future: _fahrtenFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Fehler: ${snapshot.error}'));
            }

            final fahrten = snapshot.data ?? [];
            if (fahrten.isEmpty) {
              return const Center(child: Text('Keine Fahrten gefunden.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: fahrten.length,
              itemBuilder: (context, index) {
                final fahrt = fahrten[index];
                return _buildFahrtCard(context, fahrt);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => CreateFahrtScreen(
                      fahrtenanlassId: widget.fahrtAnlass.id,
                    ),
              ),
            );
            if (result != null) {
              // Nach dem Rückkehr neu laden
              setState(_ladeFahrten);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFahrtCard(BuildContext context, Fahrt fahrt) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FahrtDetailScreen(fahrt: fahrt)),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FahrtInfo(fahrt: fahrt),
        ),
      ),
    );
  }
}
