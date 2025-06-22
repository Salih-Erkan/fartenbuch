import 'package:fartenbuch/src/data/mock_database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/presentation/create_fahrt_screen.dart';
import 'package:fartenbuch/src/features/farten/presentation/fahrt_detail_screen.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:flutter/material.dart';

class FahrtListScreen extends StatefulWidget {
  final Fahranlass fahrtAnlass;

  const FahrtListScreen({super.key, required this.fahrtAnlass});

  @override
  State<FahrtListScreen> createState() => _FahrtListScreenState();
}

class _FahrtListScreenState extends State<FahrtListScreen> {
  final repository = MockDatabaseRepository();
  late Future<List<Fahrt>> _fahrtenFuture;

  @override
  void initState() {
    super.initState();
    _ladeFahrten();
  }

  void _ladeFahrten() {
    _fahrtenFuture = repository.getFahrten(widget.fahrtAnlass.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    repository: repository,
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
    );
  }

  Widget _buildFahrtCard(BuildContext context, Fahrt fahrt) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FahrtDetailScreen(fahrt: fahrt)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
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
              _buildFahrtInfo(fahrt),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFahrtInfo(Fahrt fahrt) {
    return IntrinsicHeight(
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
              Text(fahrt.datum, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrtRow(Icons.location_on, Colors.red, fahrt.ziel),
                const SizedBox(height: 8),
                _buildOrtRow(Icons.my_location, Colors.blue, fahrt.start),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrtRow(IconData icon, Color color, Adresse adresse) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adresse.ort,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${adresse.plz}, ${adresse.strasse} ${adresse.hausnummer}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
