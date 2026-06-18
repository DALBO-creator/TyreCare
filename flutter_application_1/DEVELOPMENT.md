# TyreCare - Flutter App Abbozzo Iniziale

Questo è un abbozzo iniziale dell'applicazione TyreCare, un'app Flutter per la gestione della manutenzione degli pneumatici.

## 📱 Funzionalità principali

### 5 Sezioni principali (Tab Bar):

1. **Home** - Dashboard principale
   - Stato generale pneumatici (percentuale usura)
   - Salute di ogni pneumatico (ANT SX, ANT DX, POST SX, POST DX)
   - Data ultimo controllo
   - Bottone CTA per prenotare

2. **Auto** - Garage digitale
   - Gestione multi-veicolo
   - Lista dei veicoli registrati
   - Aggiungi nuovo veicolo
   - Dettagli veicolo

3. **Prenota** - Prenotazioni
   - Lista officine vicine
   - Selezione data e ora
   - Conferma prenotazione
   - Rating officine

4. **Wallet** - Cashback e fedeltà
   - Saldo disponibile
   - Livello fedeltà
   - Punti fedeltà
   - Storico movimenti
   - Transazioni (crediti/debiti)

5. **Profilo** - Dati utente
   - Informazioni personali
   - Impostazioni notifiche
   - Impostazioni app (tema scuro, lingua, privacy)
   - Centro assistenza
   - Logout

## 🎨 Design System

### Colori (Dark Mode):
- **Background**: `#0D0D0D`
- **Surface**: `#1C1C1E`
- **Accent (Rosso)**: `#C0392B`
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#999999`
- **Successo**: `#2ECC71`
- **Warning**: `#F39C12`
- **Error**: `#E74C3C`

### Light Mode:
- **Background**: `#F5F5F7`
- **Surface**: `#FFFFFF`
- **Accent**: `#C0392B` (stesso)

## 📁 Struttura del progetto

```
lib/
├── main.dart                    # Entry point
├── theme/
│   └── app_theme.dart          # Design system e tema
├── screens/
│   ├── home_screen.dart        # Dashboard principale
│   ├── vehicles_screen.dart    # Garage digitale
│   ├── booking_screen.dart     # Prenotazioni
│   ├── wallet_screen.dart      # Wallet e cashback
│   └── profile_screen.dart     # Profilo utente
├── models/
│   └── models.dart             # Modelli dati (Vehicle, Tire, Booking, Wallet, Officia)
└── theme/
    └── app_theme.dart          # Tema dell'applicazione
```

## 📦 Dipendenze principali

- **firebase_core**: Backend Firebase
- **firebase_auth**: Autenticazione
- **cloud_firestore**: Database NoSQL
- **firebase_storage**: Storage file
- **firebase_messaging**: Notifiche push
- **fl_chart**: Grafici
- **qr_flutter**: QR Code
- **geolocator**: Geolocalizzazione
- **google_maps_flutter**: Mappe
- **provider**: State management (consigliato per prossimi step)

## 🚀 Prossimi step di sviluppo

### Fase 1 (MVP):
- [ ] Integrazione Firebase (Auth, Firestore, Storage)
- [ ] Implementare modello dati completamente
- [ ] Aggiungere state management (Provider)
- [ ] Autenticazione utente (registrazione/login)
- [ ] Persistenza dati locale

### Fase 2 (Funzionalità):
- [ ] Algoritmo manutenzione predittiva
- [ ] Sistema notifiche push FCM
- [ ] Integrazione QR Code
- [ ] Mappe e geolocalizzazione
- [ ] API officine

### Fase 3 (Beta):
- [ ] Portale B2B per officine
- [ ] System cashback e wallet
- [ ] Analytics e tracking
- [ ] Ottimizzazione performance

### Fase 4 (Launch):
- [ ] Store listing (App Store & Play Store)
- [ ] Onboarding prime officine
- [ ] Marketing locale
- [ ] Feedback utenti

## 🔧 Come eseguire

```bash
# Installare dipendenze
flutter pub get

# Eseguire l'app
flutter run

# Build per produzione
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

## 📝 Note per lo sviluppo

1. **Theme**: Tutto il tema è centralizzato in `app_theme.dart` - modificare lì per cambiare colori globali
2. **Responsiveness**: Le schermate usano `SingleChildScrollView` e `Padding` per una buona responsiveness
3. **Navigation**: Usa `BottomNavigationBar` per navigazione tra i 5 tab principale
4. **Modelli**: I modelli in `models.dart` supportano conversione da/a Map per Firebase

## 💡 Suggerimenti di implementazione futuri

- Aggiungere `provider` o `riverpod` per state management
- Implementare cache locale con `shared_preferences`
- Aggiungere logging e analytics
- Implementare error handling robusto
- Aggiungere test unitari e di integrazione
- Implementare offline-first architecture
- Aggiungere animazioni e transizioni fluide

## 📄 Licenza

Questo progetto è parte di TyreCare - Automotive Maintenance Platform
