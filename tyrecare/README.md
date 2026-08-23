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

## Verifiche automatiche

I test in `test/models_test.dart` coprono i calcoli di chilometraggio e usura degli pneumatici. Eseguire `flutter analyze` e `flutter test` prima di ogni rilascio.
