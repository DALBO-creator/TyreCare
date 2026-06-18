class Vehicle {
  final String id;
  final String userId;
  final String model;
  final int year;
  final int mileage;
  final String tireType;
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.model,
    required this.year,
    required this.mileage,
    required this.tireType,
    required this.createdAt,
  });

  factory Vehicle.fromMap(Map<String, dynamic> data) {
    return Vehicle(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? 0,
      mileage: data['mileage'] ?? 0,
      tireType: data['tireType'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'model': model,
      'year': year,
      'mileage': mileage,
      'tireType': tireType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Tire {
  final String id;
  final String vehicleId;
  final String position; // ANT_SX, ANT_DX, POST_SX, POST_DX
  final double wearPercentage;
  final double pressure;
  final int kmDriven;

  Tire({
    required this.id,
    required this.vehicleId,
    required this.position,
    required this.wearPercentage,
    required this.pressure,
    required this.kmDriven,
  });

  factory Tire.fromMap(Map<String, dynamic> data) {
    return Tire(
      id: data['id'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      position: data['position'] ?? '',
      wearPercentage: (data['wearPercentage'] ?? 0.0).toDouble(),
      pressure: (data['pressure'] ?? 0.0).toDouble(),
      kmDriven: data['kmDriven'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'position': position,
      'wearPercentage': wearPercentage,
      'pressure': pressure,
      'kmDriven': kmDriven,
    };
  }
}

class Booking {
  final String id;
  final String userId;
  final String officinaId;
  final String vehicleId;
  final String service;
  final DateTime bookingDate;
  final String status; // pending, confirmed, completed, cancelled
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.officinaId,
    required this.vehicleId,
    required this.service,
    required this.bookingDate,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> data) {
    return Booking(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      officinaId: data['officinaId'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      service: data['service'] ?? '',
      bookingDate: data['bookingDate'] != null
          ? DateTime.parse(data['bookingDate'])
          : DateTime.now(),
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'officinaId': officinaId,
      'vehicleId': vehicleId,
      'service': service,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Wallet {
  final String userId;
  final double balance;
  final int loyaltyLevel; // 1-5
  final DateTime lastUpdated;

  Wallet({
    required this.userId,
    required this.balance,
    required this.loyaltyLevel,
    required this.lastUpdated,
  });

  factory Wallet.fromMap(Map<String, dynamic> data) {
    return Wallet(
      userId: data['userId'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      loyaltyLevel: data['loyaltyLevel'] ?? 1,
      lastUpdated: data['lastUpdated'] != null
          ? DateTime.parse(data['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'balance': balance,
      'loyaltyLevel': loyaltyLevel,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class Officia {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String subscriptionPlan; // base, pro
  final DateTime createdAt;

  Officia({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.subscriptionPlan,
    required this.createdAt,
  });

  factory Officia.fromMap(Map<String, dynamic> data) {
    return Officia(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      subscriptionPlan: data['subscriptionPlan'] ?? 'base',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'subscriptionPlan': subscriptionPlan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
