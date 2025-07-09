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

  Map<String, dynamic> toStartMap() {
    return {
      'start_ort': ort,
      'start_strasse': strasse,
      'start_hausnummer': hausnummer,
      'start_plz': plz,
      'start_lat': lat,
      'start_lng': lng,
    };
  }

  Map<String, dynamic> toTargetMap() {
    return {
      'ziel_ort': ort,
      'ziel_strasse': strasse,
      'ziel_hausnummer': hausnummer,
      'ziel_plz': plz,
      'ziel_lat': lat,
      'ziel_lng': lng,
    };
  }

  factory Adresse.fromStartMap(Map<String, dynamic> map) {
    return Adresse(
      ort: map['start_ort'],
      strasse: map['start_strasse'],
      hausnummer: map['start_hausnummer'],
      plz: map['start_plz'],
      lat: (map['start_lat'] as num).toDouble(),
      lng: (map['start_lng'] as num).toDouble(),
    );
  }

  factory Adresse.fromZielMap(Map<String, dynamic> map) {
    return Adresse(
      ort: map['ziel_ort'],
      strasse: map['ziel_strasse'],
      hausnummer: map['ziel_hausnummer'],
      plz: map['ziel_plz'],
      lat: (map['ziel_lat'] as num).toDouble(),
      lng: (map['ziel_lng'] as num).toDouble(),
    );
  }
}
