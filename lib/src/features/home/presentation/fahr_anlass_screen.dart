import 'package:fartenbuch/src/data/database_providers.dart';
import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:fartenbuch/src/features/home/presentation/fahranlass_erstellen_screen.dart';
import 'package:fartenbuch/src/features/home/presentation/widget/fahranlass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FahranlassScreen extends ConsumerStatefulWidget {
  const FahranlassScreen({super.key});

  @override
  ConsumerState<FahranlassScreen> createState() => _FahranlassScreenState();
}

class _FahranlassScreenState extends ConsumerState<FahranlassScreen> {
  late final DatabaseRepository repository;
  final List<Fahranlass> _kategorien = [];

  @override
  void initState() {
    super.initState();
    repository = ref.read(databaseRepositoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fahranlass auswählen'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final neuerAnlass = await Navigator.push<Fahranlass>(
            context,
            MaterialPageRoute(
              builder: (context) => FahranlassErstellenScreen(),
            ),
          );

          if (neuerAnlass != null) {
            setState(() {
              _kategorien.add(neuerAnlass);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Fahranlass>>(
        future: repository.getFahranlaesse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Fehler beim Laden der Kategorien'));
          }

          final kategorien = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wähle einen Anlass für deine Fahrt',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children:
                        kategorien
                            .map(
                              (cat) =>
                                  FahranlassCard(context: context, cat: cat),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
