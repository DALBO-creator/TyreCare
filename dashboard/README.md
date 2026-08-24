# TyreCare Partner Dashboard

Dashboard web first per le officine affiliate TyreCare, con una base Firebase condivisa con l’app mobile.

- HTML semantico;
- CSS custom con colori TyreCare e Bootstrap 5.3 per la griglia responsive;
- Bootstrap Bundle JS per modal, toast e tooltip;
- Chart.js per grafici finanziari e distribuzione dei servizi;
- Firebase Authentication e Cloud Firestore via SDK web compat;
- dati demo locali come fallback per la presentazione.

## Anteprima locale

Dalla root del repository:

```bash
python -m http.server 8080 --directory dashboard
```

Aprire `http://localhost:8080`.

Per usare anche le API locali di Vercel:

```bash
cd dashboard
vercel dev
```

Aprire `http://localhost:3000`.

## Deploy su Vercel

### Da Vercel

1. Importa il repository GitHub in Vercel.
2. Imposta **Root Directory** su `dashboard`.
3. Lascia vuoto il Build Command: il progetto è statico.
4. Imposta Output Directory su `.`.
5. Esegui il deploy.

### Da CLI

```bash
npm i -g vercel
cd dashboard
vercel --prod
```

Se il progetto Vercel è configurato con Root Directory `dashboard`, esegui il comando dalla root del repository oppure imposta Root Directory su `.` quando esegui il deploy direttamente dalla cartella `dashboard`.

## Configurazione Firebase demo

Il progetto Firebase usato è `tyrecare-2fe9a`. La configurazione web pubblica è in `firebase-config.js`; non contiene credenziali server. La protezione reale è affidata a Firebase Authentication e alle regole Firestore.

### 1. Installa e autentica Firebase CLI

```bash
npm install -g firebase-tools
firebase login
firebase use tyrecare-2fe9a
```

### 2. Pubblica le regole Firestore

Dalla root del repository:

```bash
firebase deploy --only firestore
```

Le regole si trovano in `firebase/firestore.rules`, mentre l’indice iniziale è in `firebase/firestore.indexes.json`.

### 3. Abilita l’accesso dell’officina

In Firebase Console:

1. Vai su **Authentication → Sign-in method**.
2. Abilita **Email/Password**.
3. Crea l’utente dell’officina, ad esempio `officina@lasantigomme.it`.
4. Copia l’UID dell’utente.
5. In Firestore crea `users/{UID}` con questi campi:

```text
workshopId: la-santi-gomme
role: workshop_admin
```

6. Facoltativamente crea anche `workshops/la-santi-gomme` con:

```text
name: La Santi Gomme
status: active
```

Dalla dashboard clicca **Collega dati Firebase** e accedi con l’utenza appena creata. Se non sei autenticato, la UI resta in modalità demo e non legge dati reali.

## Flusso mobile ↔ dashboard

L’app Flutter usa `TyreCareFirebaseBackend` in `tyrecare/lib/firebase_backend.dart`. Quando un cliente autenticato invia una prenotazione:

1. viene aggiornato il documento `customers/{uid}`;
2. viene creato un documento in `appointments` con `workshopId: la-santi-gomme`;
3. la dashboard autenticata legge gli appuntamenti e i clienti dell’officina;
4. il personale può cambiare lo stato dell’appuntamento direttamente dalla lista;
5. le note inserite dal cliente sono visibili sotto il servizio;
6. il personale dell’officina può poi lavorare sui dati dal gestionale.

Per il momento la dashboard visualizza i dati demo quando Firestore è vuoto. Il passaggio successivo sarà sostituire i KPI demo con aggregazioni reali su `payments`, `services` e `appointments`.

## Modello dati iniziale

```text
users/{userId}
workshops/{workshopId}
customers/{customerId}
vehicles/{vehicleId}
appointments/{appointmentId}
payments/{paymentId}
services/{serviceId}
```

Ogni documento operativo contiene `workshopId`, così le regole possono isolare i dati tra officine diverse. Non inserire mai chiavi private, service account o credenziali Admin SDK nel frontend o nell’app mobile.
