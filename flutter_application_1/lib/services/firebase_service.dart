// Firebase Configuration Service
// This service will be used to initialize Firebase and provide access to Firebase services

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;
  late FirebaseMessaging _messaging;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _messaging = FirebaseMessaging.instance;

      // Request notification permissions
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        provisional: false,
        sound: true,
      );

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Auth Methods
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Firestore Methods
  Future<void> createUserProfile(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData);
  }

  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(userId).update(updates);
  }

  // Vehicles
  Future<void> addVehicle(String userId, Map<String, dynamic> vehicleData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('vehicles')
        .add(vehicleData);
  }

  Stream<QuerySnapshot> getUserVehicles(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('vehicles')
        .snapshots();
  }

  // Bookings
  Future<void> createBooking(String userId, Map<String, dynamic> bookingData) async {
    await _firestore.collection('bookings').add({
      ...bookingData,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .snapshots();
  }

  // Offices
  Stream<QuerySnapshot> getNearbyOffices(double latitude, double longitude) {
    return _firestore
        .collection('offices')
        .orderBy('name')
        .snapshots();
  }

  // Wallet
  Future<void> createWallet(String userId, Map<String, dynamic> walletData) async {
    await _firestore.collection('users').doc(userId).collection('wallet').doc('data').set(
      walletData,
    );
  }

  Future<DocumentSnapshot> getWallet(String userId) async {
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('wallet')
        .doc('data')
        .get();
  }

  // Storage
  Future<String> uploadImage(String userId, String imagePath) async {
    try {
      final fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('users/$userId/$fileName');
      await ref.putFile(
        File(imagePath),
      );
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}
