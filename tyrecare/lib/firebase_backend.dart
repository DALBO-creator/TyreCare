import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

/// Minimal Firestore adapter shared by the mobile booking flow and the
/// partner dashboard. Keep the workshop id in one place until the real
/// workshop-management contract is available.
class TyreCareFirebaseBackend {
  TyreCareFirebaseBackend({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    this.workshopId = 'la-santi-gomme',
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String workshopId;

  Stream<List<Appointment>> watchCurrentUserAppointments() {
    final user = _auth.currentUser;
    if (user == null) return const Stream<List<Appointment>>.empty();

    return _firestore
        .collection('appointments')
        .where('customerId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final appointments = snapshot.docs.map((document) {
            final data = document.data();
            final rawDate = data['preferredDate'];
            final date = rawDate is Timestamp
                ? rawDate.toDate()
                : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now();
            final statusName = data['status']?.toString() ?? AppointmentStatus.requested.name;
            final status = AppointmentStatus.values.firstWhere(
              (value) => value.name == statusName,
              orElse: () => AppointmentStatus.requested,
            );
            return Appointment(
              id: document.id,
              service: data['service']?.toString() ?? 'Servizio TyreCare',
              workshopName: data['workshopName']?.toString() ?? 'La Santi Gomme',
              preferredDate: date,
              preferredTime: data['preferredTime']?.toString() ?? '--:--',
              status: status,
              note: data['note']?.toString() ?? '',
            );
          }).toList();
          appointments.sort((left, right) => left.preferredDate.compareTo(right.preferredDate));
          return appointments;
        });
  }

  Future<void> createAppointment({
    required String service,
    required DateTime preferredDate,
    required String preferredTime,
    required String note,
    required String workshopName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('È necessario aver effettuato l’accesso per prenotare.');
    }

    final customerReference = _firestore.collection('customers').doc(user.uid);
    final appointmentReference = _firestore.collection('appointments').doc();
    final customerName = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : (user.email ?? 'Cliente TyreCare');

    final batch = _firestore.batch();
    batch.set(customerReference, {
      'uid': user.uid,
      'displayName': customerName,
      'email': user.email,
      'workshopId': workshopId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    batch.set(appointmentReference, {
      'workshopId': workshopId,
      'workshopName': workshopName,
      'customerId': user.uid,
      'customerName': customerName,
      'customerEmail': user.email,
      'service': service,
      'preferredDate': Timestamp.fromDate(preferredDate),
      'preferredTime': preferredTime,
      'note': note.trim(),
      'status': 'requested',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}
