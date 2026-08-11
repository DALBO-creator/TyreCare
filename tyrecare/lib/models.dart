enum TyreCondition { excellent, monitor, attention, replace }

enum AppointmentStatus { requested, confirmed, quoteAvailable, completed, cancelled }

class Pneumatico {
  const Pneumatico({
    required this.posizione,
    required this.pressioneBase,
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
  final int temperatura;
  final String marca;
  final String modello;
  final String misura;
  final String dot;
  final double battistradaMm;
  final TyreCondition condizione;

}

class Veicolo {
  const Veicolo({
    required this.nome,
    required this.anno,
    required this.chilometraggio,
    this.targa = '',
    required this.antSx,
    required this.antDx,
    required this.postSx,
    required this.postDx,
    this.ultimoControllo,
  });

  final String nome;
  final String anno;
  final int chilometraggio;
  final String targa;
  final Pneumatico antSx;
  final Pneumatico antDx;
  final Pneumatico postSx;
  final Pneumatico postDx;
  final TyreInspection? ultimoControllo;

  List<Pneumatico> get pneumatici => [antSx, antDx, postSx, postDx];

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

class Appointment {
  const Appointment({
    required this.id,
    required this.service,
    required this.workshopName,
    required this.preferredDate,
    required this.preferredTime,
    required this.status,
    this.note = '',
  });

  final String id;
  final String service;
  final String workshopName;
  final DateTime preferredDate;
  final String preferredTime;
  final AppointmentStatus status;
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
