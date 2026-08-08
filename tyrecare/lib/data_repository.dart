import 'models.dart';

/// Contract used by the app. Replace [DemoTyreCareRepository] with the
/// GestiTyre API adapter when the integration contract is available.
abstract class TyreCareRepository {
  Future<List<Veicolo>> vehiclesForCustomer(String customerId);
  Future<List<ServiceRecord>> serviceHistory(String vehicleId);
  Future<void> requestAppointment({
    required String vehicleId,
    required String service,
    required DateTime preferredDate,
    required String note,
  });
}

/// Development-only data source. It deliberately lives outside UI widgets so
/// the screens can later use a REST/GestiTyre implementation unchanged.
class DemoTyreCareRepository implements TyreCareRepository {
  const DemoTyreCareRepository();

  @override
  Future<List<Veicolo>> vehiclesForCustomer(String customerId) async => const [];

  @override
  Future<List<ServiceRecord>> serviceHistory(String vehicleId) async => const [];

  @override
  Future<void> requestAppointment({
    required String vehicleId,
    required String service,
    required DateTime preferredDate,
    required String note,
  }) async {}
}
