// lib/models.dart
class Pneumatico {
  final String posizione;
  final double pressioneBase;
  final int usuraBase;
  final int temperatura;

  Pneumatico({
    required this.posizione,
    required this.pressioneBase,
    required this.usuraBase,
    required this.temperatura,
  });

  // Calcola l'usura dinamica in base alla simulazione dello slider
  int calcolaUsuraDinamica(double kmSimulati) {
    double consumo = kmSimulati / 150; 
    int usuraAttuale = usuraBase - consumo.toInt();
    if (usuraAttuale < 10) return 10;
    if (usuraAttuale > 100) return 100;
    return usuraAttuale;
  }
}

class Veicolo {
  final String nome;
  final String anno;
  final String chilometriIniziali;
  final String immagineUrl;
  final bool isPrincipale;
  final Pneumatico antSx;
  final Pneumatico antDx;
  final Pneumatico postSx;
  final Pneumatico postDx;

  Veicolo({
    required this.nome,
    required this.anno,
    required this.chilometriIniziali,
    required this.immagineUrl,
    this.isPrincipale = false,
    required this.antSx,
    required this.antDx,
    required this.postSx,
    required this.postDx,
  });

  int chilometriTotali(double kmSimulati) {
    int base = int.tryParse(chilometriIniziali) ?? 0;
    return base + kmSimulati.toInt();
  }

  int mediaUsuraGenerale(double kmSimulati) {
    int usuraAntSx = antSx.calcolaUsuraDinamica(kmSimulati);
    int usuraAntDx = antDx.calcolaUsuraDinamica(kmSimulati);
    int usuraPostSx = postSx.calcolaUsuraDinamica(kmSimulati);
    int usuraPostDx = postDx.calcolaUsuraDinamica(kmSimulati);
    return ((usuraAntSx + usuraAntDx + usuraPostSx + usuraPostDx) / 4).round();
  }
}