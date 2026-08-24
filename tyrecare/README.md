# TyreCare

App Flutter per il monitoraggio dello stato degli pneumatici, la gestione dei veicoli e la prenotazione di servizi presso officine convenzionate.

## Requisiti

- Flutter SDK compatibile con Dart `^3.12.2`
- Un progetto Firebase configurato per le piattaforme che usano autenticazione

## Avvio

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Per Android è incluso `android/app/google-services.json` e il plugin Google Services è abilitato in Gradle. Per iOS, web, macOS e Windows configura Firebase con FlutterFire prima di avviare l'app su tali piattaforme (ad esempio con `flutterfire configure`). Se Firebase non può essere inizializzato, l'app mostra una schermata esplicativa invece di andare in errore durante l'accesso.

## Debug USB su Android

Il debug USB è una funzione protetta del sistema Android: un'app non può abilitarlo autonomamente. Il progetto è però configurato per il **debug Flutter via USB** (variante `debug`, permesso `INTERNET` per il Dart VM service e icona Android valida).

1. Sul telefono abilita **Opzioni sviluppatore** e **Debug USB**.
2. Collega il telefono con un cavo dati, sbloccalo e accetta la richiesta RSA del computer.
3. Verifica che ADB lo veda:

   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

   Lo stato deve essere `device`, non `unauthorized` o `offline`.
4. Dalla directory `tyrecare` avvia la variante debug:

   ```bash
   flutter clean
   flutter pub get
   flutter devices
   flutter run --debug -d <seriale-del-device>
   ```

Se il dispositivo non compare, il problema è sul collegamento ADB (driver USB OEM su Windows, cavo/porta dati, autorizzazione RSA o impostazioni del telefono), non nel codice dell'app. Non usare `--release`: quella modalità non consente breakpoint e hot reload.

## Backend Firebase condiviso

L’app mobile e la dashboard `../dashboard` usano il progetto Firebase `tyrecare-2fe9a`. Le prenotazioni create da un utente autenticato vengono salvate in Firestore tramite `lib/firebase_backend.dart` nella collezione `appointments`; il profilo cliente viene aggiornato in `customers/{uid}`.

Dalla root del repository, dopo aver installato Firebase CLI e completato `firebase login`, pubblica le regole con:

```bash
firebase use tyrecare-2fe9a
firebase deploy --only firestore
```

Per il primo utente dell’officina abilita Email/Password in Firebase Authentication e crea in Firestore `users/{UID}` con:

```text
workshopId: la-santi-gomme
role: workshop_admin
```

Le regole sono in `../firebase/firestore.rules`. Prima del collegamento con il gestionale reale, sostituisci l’id demo dell’officina e l’adapter Firebase con l’integrazione API concordata con La Santi Gomme.

## Verifiche automatiche

I test in `test/models_test.dart` coprono i calcoli di chilometraggio e usura degli pneumatici. Eseguire `flutter pub get`, `flutter analyze` e `flutter test` prima di ogni rilascio.
