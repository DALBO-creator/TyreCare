# 🚗 TyreCare - Automotive Maintenance App

> Una piattaforma digitale integrata per la manutenzione degli pneumatici e la gestione preventiva della salute dei veicoli.

## 📋 Indice

- [Panoramica](#panoramica)
- [Funzionalità](#funzionalità)
- [Tecnologie](#tecnologie)
- [Setup rapido](#setup-rapido)
- [Struttura del progetto](#struttura-del-progetto)
- [Come iniziare](#come-iniziare)
- [Documentazione](#documentazione)
- [Roadmap](#roadmap)

## 🎯 Panoramica

TyreCare è un'applicazione mobile cross-platform (Flutter) che trasforma la manutenzione degli pneumatici da un evento episodico e reattivo a un servizio continuativo, predittivo e di valore.

**Target Market:**
- 🚙 Automobilisti privati
- 🏪 Gommisti e officine indipendenti
- 🤝 Partner locali dell'ecosistema automotive

**Modello di Business:** SaaS multi-layer con abbonamento officine, commissioni su prenotazioni e partnership commerciali.

## ✨ Funzionalità

### App Cliente
- ✅ **Dashboard pneumatici** - Monitoraggio usura e pressione in tempo reale
- ✅ **Garage digitale** - Gestione multi-veicolo con 3D view
- ✅ **Manutenzione predittiva** - Notifiche intelligenti basate su algoritmi
- ✅ **Prenotazioni online** - Integrazione con officine affiliate
- ✅ **QR Check-in** - Validazione arrivo in officina
- ✅ **Wallet & Cashback** - Sistema di fedeltà e crediti
- ✅ **SOS su strada** - Posizionamento GPS e contatto rapido

### Piattaforma B2B Officine
- 📊 Dashboard KPI (prenotazioni, interventi, fatturato)
- 👥 Gestione clienti e storico interventi
- 📅 Calendario prenotazioni
- 📱 Scansione QR per check-in
- 💰 Gestione servizi e listini
- 📈 Report e statistiche

## 🛠 Tecnologie

### Frontend
- **Framework**: Flutter 3.x
- **Linguaggio**: Dart 3.x
- **State Management**: Provider (pianificato)
- **UI Components**: Material Design 3

### Backend
- **Piattaforma**: Google Firebase
- **Database**: Cloud Firestore
- **Autenticazione**: Firebase Auth
- **Storage**: Firebase Storage
- **Notifiche**: Firebase Cloud Messaging (FCM)
- **Analytics**: Firebase Analytics

### Pacchetti principali
- `fl_chart` - Grafici e visualizzazioni
- `qr_flutter` - Generazione QR Code
- `geolocator` - Geolocalizzazione
- `google_maps_flutter` - Mappe e navigazione
- `provider` - State management
- `intl` - Internazionalizzazione

## 🚀 Setup rapido

### Prerequisiti
```bash
# Verifica l'ambiente Flutter
flutter doctor

# Output atteso:
# ✓ Flutter (Channel stable, 3.x.x)
# ✓ Android toolchain
# ✓ Xcode (se su macOS)
# ✓ VS Code
```

### Installazione
```bash
# 1. Clona il repository
git clone https://github.com/TyreCare/flutter_application_1.git
cd flutter_application_1

# 2. Installa dipendenze
flutter pub get

# 3. Configura Firebase (vedi SETUP.md)
# - Crea progetto Firebase
# - Scarica google-services.json per Android
# - Scarica GoogleService-Info.plist per iOS

# 4. Esegui l'app
flutter run
```

### Comandi utili
```bash
flutter pub upgrade          # Aggiorna dipendenze
flutter analyze             # Analizza il codice
flutter format lib/         # Formatta il codice
flutter build apk           # Build APK Android
flutter build ios           # Build iOS
```

## 📁 Struttura del progetto

```
lib/
├── main.dart                    # Entry point
├── models/                      # Data models
│   └── models.dart
├── screens/                     # UI screens
│   ├── home_screen.dart
│   ├── vehicles_screen.dart
│   ├── booking_screen.dart
│   ├── wallet_screen.dart
│   └── profile_screen.dart
├── services/                    # Backend services
│   └── firebase_service.dart
├── theme/                       # Design system
│   └── app_theme.dart
└── widgets/                     # Reusable widgets
```

## 📖 Documentazione

### File importanti
- **[SETUP.md](SETUP.md)** - Guida installazione e configurazione Firebase
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Guida sviluppo e roadmap
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architettura e best practices
- **[FIRESTORE_SCHEMA.md](FIRESTORE_SCHEMA.md)** - Schema database Firestore

## 🎨 Design System

### Tema Dark Mode (Default)
```
Background:   #0D0D0D
Surface:      #1C1C1E
Accent (Red): #C0392B
Text Primary: #FFFFFF
Text Sec:     #999999
```

### Colori semantici
```
Success: #2ECC71
Warning: #F39C12
Error:   #E74C3C
```

## 🗺 Roadmap

### Fase 1 - MVP (Mesi 1-3)
- [x] Setup iniziale
- [x] Struttura UI base
- [ ] Integrazione Firebase Auth
- [ ] Firestore connection
- [ ] Dashboard pneumatici
- [ ] Garage digitale

### Fase 2 - Completamento (Mesi 3-5)
- [ ] Sistema prenotazioni
- [ ] QR Code validation
- [ ] Wallet e cashback
- [ ] Push notifications
- [ ] State management completo

### Fase 3 - Beta Officina (Mesi 5-7)
- [ ] Portale B2B officina
- [ ] Test con partner
- [ ] Bug fixing e optimizzazione
- [ ] Feedback loop

### Fase 4 - Launch (Mesi 7-8)
- [ ] App Store release
- [ ] Play Store release
- [ ] Marketing campaign
- [ ] Onboarding officine

### Fase 5 - Scale-up (Mesi 9-12)
- [ ] Espansione rete officine
- [ ] Partnership locali
- [ ] Analytics avanzate
- [ ] Versione 2.0

## 💰 Proiezioni finanziarie

| Metrica | Anno 1 | Anno 2 | Anno 3 |
|---------|--------|--------|--------|
| Officine | 20 | 60 | 150 |
| Clienti | 1.000 | 6.000 | 20.000 |
| Ricavi | €30.960 | €98.880 | €261.000 |
| Margine | 60,6% | 73,1% | 80,5% |

## 🤝 Contribuzione

I contributi sono benvenuti! Per favore:

1. Fork il progetto
2. Crea un branch (`git checkout -b feature/AmazingFeature`)
3. Commit i cambiamenti (`git commit -m 'Add AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📝 Licenza

Questo progetto è registrato e riservato. © 2024-2025 TyreCare

## 👨‍💻 Team di sviluppo

- **Lead Developer**: [Solo Developer]
- **Supporto AI**: Claude Haiku 4.5 + GitHub Copilot
- **Business**: Marco Bianchi

## 📞 Contatti

- 📧 Email: marco.bianchi@email.com
- 🌐 Website: (in sviluppo)
- 📱 Social: @TyreCareApp

---

**Versione**: 1.0.0  
**Data**: Giugno 2025  
**Status**: 🔨 In sviluppo - MVP
