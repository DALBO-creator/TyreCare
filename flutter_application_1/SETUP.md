# Setup Iniziale - Istruzioni di configurazione

## 1. Prerequisiti

- Flutter SDK (>= 3.12.2)
- Dart SDK (>= 3.12.2)
- Android Studio / Xcode (per emulatori)
- Firebase CLI
- Un account Google (per Firebase)

Verifica l'installazione:
```bash
flutter doctor
```

## 2. Configurazione Firebase

### Step 1: Creare un progetto Firebase

1. Vai su [Firebase Console](https://console.firebase.google.com/)
2. Clicca "Aggiungi progetto"
3. Nome: "TyreCare"
4. Abilita Google Analytics (opzionale)
5. Crea il progetto

### Step 2: Aggiungere app Android

1. In Firebase Console, vai a Project Settings
2. Clicca "Aggiungi app" > Android
3. Package name: `com.tyrecare.app`
4. Scarica `google-services.json`
5. Posiziona il file in `android/app/google-services.json`

### Step 3: Aggiungere app iOS

1. Clicca "Aggiungi app" > iOS
2. Bundle ID: `com.tyrecare.app`
3. Scarica `GoogleService-Info.plist`
4. Apri `ios/Runner.xcworkspace` in Xcode
5. Aggiungi `GoogleService-Info.plist` al progetto Runner

### Step 4: Configurare Firestore

1. In Firebase Console, vai a "Firestore Database"
2. Clicca "Crea database"
3. Seleziona "modalità sviluppo" (per sviluppo)
4. Seleziona una regione (es. `europe-west1`)

### Step 5: Configurare Authentication

1. In Firebase Console, vai a "Authentication"
2. Clicca "Inizia"
3. Abilita "Email/Password"
4. (Opzionale) Abilita "Google Sign-In"

### Step 6: Configurare Storage

1. In Firebase Console, vai a "Storage"
2. Clicca "Inizia"
3. Seleziona una regione

## 3. Configurazione Android

### Update build.gradle

Apri `android/build.gradle` e assicurati che abbia:

```gradle
buildscript {
    dependencies {
        // Google Services Plugin
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

### Update app/build.gradle

```gradle
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services'  // Aggiungi questa linea
```

## 4. Configurazione iOS

### Aggiornare CocoaPods

```bash
cd ios
pod repo update
pod install
cd ..
```

### Verificare Deployment Target

In Xcode:
1. Seleziona "Runner" nel progetto
2. Vai a "Build Settings"
3. Assicurati che "Minimum Deployments" sia almeno iOS 12

## 5. Installare dipendenze Flutter

```bash
flutter pub get
flutter pub upgrade
```

## 6. Configurare le icone dell'app

### Android
1. Sostituisci `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` con il logo TyreCare
2. Ripeti per altre risoluzioni

### iOS
1. Apri `ios/Runner.xcworkspace` in Xcode
2. Seleziona "Runner" > "Assets.xcassets"
3. Trascina il logo TyreCare su "AppIcon"

## 7. Configurare il package name

### Android

Apri `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        applicationId "com.tyrecare.app"  // Cambia qui
    }
}
```

### iOS

Apri Xcode e modifica il Bundle Identifier in Build Settings

## 8. Test iniziale

```bash
# Pulisci i build precedenti
flutter clean

# Ottieni dipendenze
flutter pub get

# Analizza il codice
flutter analyze

# Esegui l'app
flutter run
```

## 9. Configurazione del database Firestore

Esegui il seguente script Firestore per impostare le collezioni iniziali:

```javascript
// Firestore - Inizializzazione collezioni

// 1. Crea collezione offices con un documento di esempio
db.collection("offices").doc("office_001").set({
    nome: "Gommista Centro",
    indirizzo: "Via Roma 123, Milano",
    coordinate: new firebase.firestore.GeoPoint(45.4641, 9.1896),
    telefono: "+39 02 1234 5678",
    email: "centro@gommista.it",
    orari_apertura: {
        lunedi: { apertura: "09:00", chiusura: "18:00" },
        martedi: { apertura: "09:00", chiusura: "18:00" },
        mercoledi: { apertura: "09:00", chiusura: "18:00" },
        giovedi: { apertura: "09:00", chiusura: "18:00" },
        venerdi: { apertura: "09:00", chiusura: "18:00" },
        sabato: { apertura: "09:00", chiusura: "14:00" },
        domenica: { chiuso: true }
    },
    piano_abbonamento: "pro",
    prezzo_base_controllo: 45.00,
    rating: 4.8,
    numero_reviews: 127,
    servizi_disponibili: ["cambio_gomme", "equilibratura", "gonfiaggio", "riparazione"],
    immagine_url: "",
    createdAt: firebase.firestore.FieldValue.serverTimestamp(),
    updatedAt: firebase.firestore.FieldValue.serverTimestamp()
});
```

## 10. Variabili d'ambiente

Crea un file `.env.example` con le variabili necessarie:

```
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_API_KEY=your_api_key
```

## 11. Comandi utili

```bash
# Pulire il progetto
flutter clean

# Ottenere tutte le dipendenze
flutter pub get

# Aggiornare le dipendenze
flutter pub upgrade

# Formattare il codice
dart format lib/

# Analizzare il codice
flutter analyze

# Eseguire test
flutter test

# Build APK
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release

# Build Web
flutter build web --release
```

## 12. Troubleshooting

### Errore: "FirebaseException: firebase_core"
```bash
flutter pub get
flutter pub upgrade firebase_core
```

### Errore: "Android Gradle Build"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Errore: "CocoaPods conflicts" (iOS)
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Errore: "plugin not found"
```bash
flutter pub get
flutter pub global activate flutterfire_cli
flutterfire configure
```

## 13. Configurazione finale di sicurezza

Prima di andare in produzione:

1. **Firestore Security Rules** - Implementare le regole di sicurezza (vedi FIRESTORE_SCHEMA.md)
2. **API Keys** - Abilitare solo le API necessarie
3. **Authentication** - Configurare i provider di autenticazione
4. **Storage Security Rules** - Impostare regole di accesso ai file
5. **App Check** - Abilitare App Check per proteggere le API

## 14. Prossimi step

1. Implementare il sistema di autenticazione
2. Testare Firestore connection
3. Implementare il primo flusso utente (registrazione)
4. Aggiungere state management (Provider)
5. Implementare localStorage per persistenza dati offline
