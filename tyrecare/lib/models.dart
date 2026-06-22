// lib/models.dart
class Pneumatico {
  final String modello;
  final double pressioneBase;
  final int usuraIniziale;
  final int temperatura;

  const Pneumatico({
    required this.modello,
    required this.pressioneBase,
    required this.usuraIniziale,
    required this.temperatura,
  });

  int calcolaUsuraDinamica(double kmSimulati) {
    double consumo = kmSimulati / 150; 
    int usuraAttuale = usuraIniziale - consumo.toInt();
    if (usuraAttuale < 10) return 10;
    if (usuraAttuale > 100) return 100;
    return usuraAttuale;
  }
}

class Veicolo {
  final String id;
  final String nome;
  final int chilometriBase;
  final int kmUltimoControllo;
  final int kmProssimoControlloTarget;
  final String anno;
  final String immagineUrl;

  final Pneumatico antSx;
  final Pneumatico antDx;
  final Pneumatico postSx;
  final Pneumatico postDx;

  const Veicolo({
    required this.id,
    required this.nome,
    required this.chilometriBase,
    required this.kmUltimoControllo,
    required this.kmProssimoControlloTarget,
    this.anno = '2022',
    this.immagineUrl = 'https://images.pngimages.com/download/0b18f8e0d6da7e923e1e9a26372bf9dc.png',
    required this.antSx,
    required this.antDx,
    required this.postSx,
    required this.postDx,
  });
}