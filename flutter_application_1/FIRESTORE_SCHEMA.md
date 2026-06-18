# Firestore Database Schema

## Collections Structure

### users
```
users/
├── {userId}  (document ID = Firebase Auth UID)
│   ├── email: string
│   ├── nome: string
│   ├── cognome: string
│   ├── livello_cashback: integer (1-5)
│   ├── wallet_balance: number
│   ├── createdAt: timestamp
│   ├── updatedAt: timestamp
│   │
│   └── vehicles/ (subcollection)
│       ├── {vehicleId}
│       │   ├── model: string
│       │   ├── anno: integer
│       │   ├── km: integer
│       │   ├── tipo_gomme: string
│       │   ├── createdAt: timestamp
│       │   │
│       │   └── tyres/ (subcollection)
│       │       ├── {tyreId}
│       │       │   ├── posizione: string (ANT_SX, ANT_DX, POST_SX, POST_DX)
│       │       │   ├── usura_%: number (0-100)
│       │       │   ├── pressione: number (bar)
│       │       │   ├── km_percorsi: integer
│       │       │   └── lastUpdated: timestamp
│       │
│       └── maintenance_history/ (subcollection)
│           ├── {maintenanceId}
│           │   ├── servizio: string
│           │   ├── data: timestamp
│           │   ├── km: integer
│           │   ├── note: string
│           │   ├── cost: number
│           │   ├── officinaId: string (reference)
│           │   └── docURL: string (Firebase Storage reference)
│
│   └── wallet/ (subcollection)
│       ├── data (document)
│       │   ├── balance: number
│       │   ├── loyalty_level: integer
│       │   ├── loyalty_points: integer
│       │   └── lastUpdated: timestamp
│       │
│       └── transactions/ (subcollection)
│           ├── {txId}
│           │   ├── tipo: string (credito/debito)
│           │   ├── importo: number
│           │   ├── descrizione: string
│           │   ├── servizio_ref: string (booking ID)
│           │   └── data: timestamp
│
│   └── notifications/ (subcollection)
│       ├── {notificationId}
│           ├── titolo: string
│           ├── messaggio: string
│           ├── tipo: string (reminder/promo/update)
│           ├── letto: boolean
│           ├── data: timestamp
│           └── bookingId: string (optional reference)
```

### bookings
```
bookings/
├── {bookingId}
│   ├── userId: string (reference to users/{userId})
│   ├── officinaId: string (reference to offices/{officinaId})
│   ├── vehicleId: string (reference to vehicles/{vehicleId})
│   ├── servizio: string
│   ├── data_prenotazione: timestamp
│   ├── status: string (pending/confirmed/completed/cancelled)
│   ├── note: string
│   ├── qr_code: string (generated QR for check-in)
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

### offices
```
offices/
├── {officinaId}
│   ├── nome: string
│   ├── indirizzo: string
│   ├── coordinate: geopoint
│   ├── telefono: string
│   ├── email: string
│   ├── orari_apertura: map
│   │   ├── lunedi: {apertura, chiusura}
│   │   ├── martedi: {apertura, chiusura}
│   │   └── ... (altri giorni)
│   ├── piano_abbonamento: string (base/pro)
│   ├── prezzo_base_controllo: number
│   ├── rating: number (0-5)
│   ├── numero_reviews: integer
│   ├── servizi_disponibili: array
│   ├── immagine_url: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

### qr_validations
```
qr_validations/
├── {qrId}
│   ├── bookingId: string (reference)
│   ├── userId: string (reference)
│   ├── officinaId: string (reference)
│   ├── qr_code: string
│   ├── timestamp: timestamp
│   ├── stato: string (scanned/completed)
│   └── servizio_completato: string
```

## Firestore Security Rules Template

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - each user can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /{document=**} {
        allow read, write: if request.auth.uid == userId;
      }
    }
    
    // Bookings - users can read their own, create new, offices can read theirs
    match /bookings/{bookingId} {
      allow read: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow update: if request.auth.uid == resource.data.userId;
    }
    
    // Offices - public read
    match /offices/{officinaId} {
      allow read: if request.auth.uid != null;
      allow write: if request.auth.uid == resource.data.managerId;
    }
    
    // QR Validations - offices can create and read their own
    match /qr_validations/{qrId} {
      allow read, create, update: if request.auth.uid == resource.data.officinaId;
    }
  }
}
```

## Indexes Required

1. **bookings**
   - userId, bookingDate (descending)
   
2. **offices**
   - coordinate (geopoint range query for nearby search)
   - rating (for sorting by rating)

3. **users.vehicles.maintenance_history**
   - data (descending) for chronological order

## Data Validation Rules

### Tire wear percentage
- Range: 0-100%
- Warning threshold: >75%
- Critical threshold: >90%

### Tire pressure (bar)
- Normal range: 2.0-2.5 bar
- Warning range: 1.8-2.0 or 2.5-2.8 bar
- Critical range: <1.8 or >2.8 bar

### Booking statuses
- pending: prenotazione creata ma non confermata
- confirmed: confermata dall'officina
- completed: servizio completato
- cancelled: annullata

### Loyalty levels
- Bronze: 0-500 punti
- Silver: 501-1500 punti
- Gold: 1501-3000 punti
- Platinum: >3000 punti
