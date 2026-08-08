enum TyreCondition { excellent, monitor, attention, replace }

enum AppointmentStatus { requested, confirmed, quoteAvailable, completed, cancelled }

class Pneumatico {
  const Pneumatico({
    required this.posizione,
    required this.pressioneBase,
    required this.usuraBase,
    required this.temperatura,
    this.marca = '',
    this.modello = '',
    this.misura = '',
    this.dot = '',
    this.battistradaMm = 0,
    this.condizione = TyreCondition.excellent,
  });

  final String posizione;
  final double pressioneBase;
  final int usuraBase;
  final int temperatura;
  final String marca;
  final String modello;
  final String misura;
  final String dot;
  final double battistradaMm;
  final TyreCondition condizione;

  // Kept for backward compatibility while legacy pages are migrated.
  int calcolaUsuraDinamica(double _) => usuraBase.clamp(10, 100).toInt();
}

class Veicolo {
  const Veicolo({
    required this.nome,
    required this.anno,
    required this.chilometriIniziali,
    required this.immagineUrl,
    this.targa = '',
    required this.antSx,
    required this.antDx,
    required this.postSx,
    required this.postDx,
    this.isPrincipale = false,
    this.ultimoControllo,
  });

  final String nome;
  final String anno;
  final String chilometriIniziali;
  final String immagineUrl;
  final String targa;
  final bool isPrincipale;
  final Pneumatico antSx;
  final Pneumatico antDx;
  final Pneumatico postSx;
  final Pneumatico postDx;
  final TyreInspection? ultimoControllo;

  List<Pneumatico> get pneumatici => [antSx, antDx, postSx, postDx];
  int chilometriTotali(double _) => int.tryParse(chilometriIniziali) ?? 0;
  int mediaUsuraGenerale(double _) =>
      (pneumatici.map((item) => item.usuraBase).reduce((a, b) => a + b) / 4).round();
}

class TyreInspection {
  const TyreInspection({
    required this.id,
    required this.date,
    required this.workshopName,
    required this.mileage,
    required this.note,
  });

  final String id;
  final DateTime date;
  final String workshopName;
  final int mileage;
  final String note;
}

class ServiceRecord {
  const ServiceRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.workshopName,
    required this.mileage,
    this.note = '',
  });

  final String id;
  final String title;
  final DateTime date;
  final String workshopName;
  final int mileage;
  final String note;
}
