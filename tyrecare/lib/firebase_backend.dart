import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
