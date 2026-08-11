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

## Verifiche automatiche

I test in `test/models_test.dart` coprono i calcoli di chilometraggio e usura degli pneumatici. Eseguire `flutter analyze` e `flutter test` prima di ogni rilascio.
