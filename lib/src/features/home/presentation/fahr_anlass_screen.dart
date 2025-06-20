import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:fartenbuch/src/features/home/presentation/fahranlass_erstellen_screen.dart';
import 'package:fartenbuch/src/features/home/presentation/widget/fahranlass_card.dart';
import 'package:flutter/material.dart';
import 'package:fartenbuch/src/data/mock_database_repository.dart';

class FahranlassScreen extends StatefulWidget {
  FahranlassScreen({super.key});

  @override
  State<FahranlassScreen> createState() => _FahranlassScreenState();
}

class _FahranlassScreenState extends State<FahranlassScreen> {
  final MockDatabaseRepository repository = MockDatabaseRepository();
  late Future<List<Fahranlass>> _futureKategorien;
  List<Fahranlass> _kategorien = [];

  @override
  void initState() {
    super.initState();
    _futureKategorien = repository.getFahranlaesse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Fahranlass auswählen',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final neuerAnlass = await Navigator.push<Fahranlass>(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                       FahranlassErstellenScreen(repository: repository),
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
