import 'package:fartenbuch/src/data/supabase_database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/presentation/fahrt_detail_screen.dart';
import 'package:flutter/material.dart';

class FahrtListScreen extends StatelessWidget {
  final repository = SupabaseDatabaseRepository();

  FahrtListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fahrtenübersicht',

          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),

      body: FutureBuilder<List<Fahrt>>(
        future: repository.getFahrten(),

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

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => FahrtDetailScreen(fahrt: fahrt),
                    ),
                  );
                },

                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  elevation: 1,

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          fahrt.beschreibung,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 12),

                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    '${fahrt.entfernung} km',

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    fahrt.datum,

                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),

                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),

                                width: 1,

                                color: Colors.grey[300],
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    // Ziel
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        const Icon(
                                          Icons.location_on,

                                          color: Colors.red,

                                          size: 20,
                                        ),

                                        const SizedBox(width: 8),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                fahrt.ziel.ort,

                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,

                                                  fontSize: 16,
                                                ),
                                              ),

                                              Text(
                                                '${fahrt.ziel.plz}, ${fahrt.ziel.strasse} ${fahrt.ziel.hausnummer}',

                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // Start
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        const Icon(
                                          Icons.my_location,

                                          color: Colors.blue,

                                          size: 20,
                                        ),

                                        const SizedBox(width: 8),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                fahrt.start.ort,

                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,

                                                  fontSize: 16,
                                                ),
                                              ),

                                              Text(
                                                '${fahrt.start.plz}, ${fahrt.start.strasse} ${fahrt.start.hausnummer}',

                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Neue Fahrt hinzufügen
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
