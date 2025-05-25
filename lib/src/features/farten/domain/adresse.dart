class Adresse {
  final String ort;
  final String strasse;
  final String hausnummer;
  final String plz;
  final double lat;
  final double lng;

  Adresse({
    required this.ort,
    required this.strasse,
    required this.hausnummer,
    required this.plz,
    required this.lat,
    required this.lng,
  });

  String get vollAdresse => '$strasse $hausnummer, $plz $ort';
}
