# TyreCare Partner Dashboard

Dashboard web first per le officine affiliate TyreCare. È una landing page operativa responsive realizzata con:

- HTML semantico;
- CSS custom con Bootstrap 5.3 per la griglia responsive;
- Bootstrap Bundle JS per modal, toast e tooltip;
- Chart.js per grafici finanziari e distribuzione servizi;
- dati demo locali in `app.js`.

## Anteprima locale

Dalla root del repository:

```bash
python -m http.server 8080 --directory dashboard
```

Aprire `http://localhost:8080`.

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
vercel
```

Per un deploy di produzione:

```bash
vercel --prod
```

## Collegamento al backend TyreCare

I numeri mostrati sono demo. In produzione `app.js` deve leggere i dati da un backend condiviso con l'app mobile, preferibilmente Firebase/Firestore e Firebase Authentication:

- l'app mobile e la dashboard usano lo stesso Firebase project;
- ogni officina ha un `workshopId` e gli utenti hanno un ruolo `workshop_admin` o `workshop_staff`;
- Firestore Security Rules limitano i documenti all'officina dell'utente autenticato;
- le operazioni sensibili, come incassi e report, passano da Cloud Functions;
- la dashboard non contiene mai chiavi private o credenziali server.

Per la dashboard reale, aggiungere Firebase Web SDK oppure un piccolo layer API in `app.js`, usando variabili d'ambiente Vercel per eventuali endpoint pubblici.
