/* TyreCare Partner OS — demo interactions. Replace the demo data layer with Firebase/API calls in production. */
(() => {
  'use strict';

  const state = {
    calendarDate: new Date(2026, 7, 1),
    selectedDate: new Date(2026, 7, 24),
    range: '30',
  };

  const appointmentDates = new Set([
    '2026-08-03', '2026-08-04', '2026-08-07', '2026-08-11',
    '2026-08-14', '2026-08-18', '2026-08-21', '2026-08-24', '2026-08-27',
  ]);

  const revenueSeries = {
    7: {
      labels: ['18 ago', '19 ago', '20 ago', '21 ago', '22 ago', '23 ago', 'oggi'],
      values: [6480, 7240, 6910, 8460, 7780, 9250, 8200],
      total: '€ 54.320,00',
    },
    30: {
      labels: ['01 ago', '05 ago', '10 ago', '15 ago', '20 ago', '22 ago', 'oggi'],
      values: [12400, 18600, 24500, 31600, 37900, 44200, 48760],
      total: '€ 48.760,40',
    },
    90: {
      labels: ['giu', 'fine giu', 'lug', 'fine lug', 'ago', 'oggi'],
      values: [32600, 44800, 62100, 79200, 103400, 128460],
      total: '€ 128.460,70',
    },
  };

  const WORKSHOP_ID = 'la-santi-gomme';
  let revenueChart;
  let servicesChart;
  let toast;
  let firebaseAuth;
  let firebaseDb;
  let liveUser;
  let liveUnsubscribers = [];
  let liveCounts = { appointments: 0, customers: 0 };

  const $ = (selector, parent = document) => parent.querySelector(selector);
  const $$ = (selector, parent = document) => [...parent.querySelectorAll(selector)];

  function dateKey(date) {
    return [date.getFullYear(), String(date.getMonth() + 1).padStart(2, '0'), String(date.getDate()).padStart(2, '0')].join('-');
  }

  function capitalize(value) {
    return value.charAt(0).toUpperCase() + value.slice(1);
  }

  function formatLongDate(date) {
    return new Intl.DateTimeFormat('it-IT', { day: 'numeric', month: 'long', year: 'numeric' }).format(date);
  }

  function formatShortDate(date) {
    return new Intl.DateTimeFormat('it-IT', { weekday: 'long', day: 'numeric', month: 'long' }).format(date);
  }

  function showToast(message) {
    const messageElement = $('#toastMessage');
    if (!messageElement || !toast) return;
    messageElement.textContent = message;
    toast.show();
  }

  function downloadFile(filename, content, type = 'text/csv;charset=utf-8;') {
    const blob = new Blob(["\ufeff", content], { type });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.setTimeout(() => URL.revokeObjectURL(link.href), 1000);
  }

  function setGreeting() {
    const hour = new Date().getHours();
    const greeting = hour < 12 ? 'Buongiorno' : hour < 18 ? 'Buon pomeriggio' : 'Buonasera';
    const greetingElement = $('#greeting');
    if (greetingElement) greetingElement.textContent = greeting;
  }

  function setupSidebar() {
    const sidebar = $('#sidebar');
    const backdrop = $('#sidebarBackdrop');
    const closeSidebar = () => {
      sidebar?.classList.remove('open');
      backdrop?.classList.remove('visible');
    };
    $('#mobileMenuButton')?.addEventListener('click', () => {
      sidebar?.classList.add('open');
      backdrop?.classList.add('visible');
    });
    $('#sidebarClose')?.addEventListener('click', closeSidebar);
    backdrop?.addEventListener('click', closeSidebar);

    $$('.nav-link').forEach((link) => {
      link.addEventListener('click', () => {
        closeSidebar();
        const section = link.dataset.section;
        if (section) setActiveSection(section);
      });
    });
  }

  const sectionLabels = {
    overview: 'Panoramica',
    clients: 'Clienti',
    appointments: 'Appuntamenti',
    performance: 'Performance',
    payments: 'Incassi',
    messages: 'Messaggi',
    settings: 'Impostazioni',
    help: 'Centro assistenza',
  };

  const sectionAnchors = {
    overview: '#overview',
    clients: '#clients',
    appointments: '#appointments',
    performance: '#performance',
    payments: '#payments',
  };

  function setActiveSection(section) {
    $$('.nav-link').forEach((link) => link.classList.toggle('active', link.dataset.section === section));
    const label = sectionLabels[section] || 'Panoramica';
    const breadcrumb = $('#breadcrumbCurrent');
    if (breadcrumb) breadcrumb.textContent = label;

    const anchor = sectionAnchors[section];
    if (anchor) {
      document.querySelector(anchor)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else if (section !== 'overview') {
      showToast(`${label}: questa sezione sarà collegata al backend a breve.`);
    }
  }

  function setupSectionActions() {
    $$('[data-section]').forEach((element) => {
      if (element.classList.contains('nav-link')) return;
      element.addEventListener('click', (event) => {
        const section = element.dataset.section;
        if (!section) return;
        event.preventDefault();
        setActiveSection(section);
      });
    });
  }

  function createRevenueChart() {
    const canvas = $('#revenueChart');
    if (!canvas || typeof Chart === 'undefined') return;
    const context = canvas.getContext('2d');
    const gradient = context.createLinearGradient(0, 0, 0, 230);
    gradient.addColorStop(0, 'rgba(230, 73, 79, .22)');
    gradient.addColorStop(1, 'rgba(230, 73, 79, 0)');

    Chart.defaults.font.family = 'Arial, Helvetica, sans-serif';
    Chart.defaults.animation.duration = 700;

    revenueChart = new Chart(context, {
      type: 'line',
      data: {
        labels: revenueSeries[30].labels,
        datasets: [{
          data: revenueSeries[30].values,
          borderColor: '#E6494F',
          backgroundColor: gradient,
          borderWidth: 2,
          fill: true,
          tension: .42,
          pointRadius: 0,
          pointHoverRadius: 5,
          pointHoverBackgroundColor: '#fff',
          pointHoverBorderColor: '#E6494F',
          pointHoverBorderWidth: 3,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { intersect: false, mode: 'index' },
        plugins: {
          legend: { display: false },
          tooltip: {
            displayColors: false,
            backgroundColor: '#102033',
            padding: 10,
            titleFont: { size: 9, weight: '700' },
            bodyFont: { size: 11, weight: '500' },
            cornerRadius: 8,
            callbacks: {
              label: (context) => ` € ${context.parsed.y.toLocaleString('it-IT')}`,
            },
          },
        },
        scales: {
          x: { display: false, grid: { display: false } },
          y: {
            beginAtZero: true,
            border: { display: false },
            grid: { color: 'rgba(128, 147, 165, .11)', drawTicks: false },
            ticks: {
              color: '#a5b0bc',
              font: { family: 'Consolas, Liberation Mono, monospace', size: 8 },
              padding: 10,
              maxTicksLimit: 5,
              callback: (value) => `€${Math.round(value / 1000)}k`,
            },
          },
        },
      },
    });
  }

  function createServicesChart() {
    const canvas = $('#servicesChart');
    if (!canvas || typeof Chart === 'undefined') return;
    servicesChart = new Chart(canvas.getContext('2d'), {
      type: 'doughnut',
      data: {
        labels: ['Gomme stagionali', 'Controllo e bilanciatura', 'Convergenza', 'Altri servizi'],
        datasets: [{
          data: [42, 31, 17, 10],
          backgroundColor: ['#E6494F', '#14161B', '#7D848B', '#D9DCDF'],
          borderWidth: 0,
          hoverOffset: 5,
          spacing: 3,
        }],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '76%',
        plugins: {
          legend: { display: false },
          tooltip: {
            displayColors: false,
            backgroundColor: '#102033',
            padding: 9,
            cornerRadius: 8,
            callbacks: { label: (context) => ` ${context.label}: ${context.parsed}%` },
          },
        },
      },
    });
  }

  function updateRevenueChart(range) {
    if (!revenueChart || !revenueSeries[range]) return;
    const series = revenueSeries[range];
    state.range = range;
    revenueChart.data.labels = series.labels;
    revenueChart.data.datasets[0].data = series.values;
    revenueChart.update();
    const total = $('#chartTotal');
    if (total) total.textContent = series.total;
    $$('.range-button').forEach((button) => button.classList.toggle('active', button.dataset.range === range));
  }

  function setupCharts() {
    createRevenueChart();
    createServicesChart();
    $$('.range-button').forEach((button) => button.addEventListener('click', () => updateRevenueChart(button.dataset.range)));
  }

  function renderCalendar() {
    const grid = $('#calendarGrid');
    const label = $('#calendarMonthLabel');
    if (!grid || !label) return;

    const year = state.calendarDate.getFullYear();
    const month = state.calendarDate.getMonth();
    label.textContent = capitalize(new Intl.DateTimeFormat('it-IT', { month: 'long', year: 'numeric' }).format(state.calendarDate));
    grid.innerHTML = '';

    // Convert Sunday-first JavaScript indexing into a Monday-first calendar.
    const firstDayOffset = (new Date(year, month, 1).getDay() + 6) % 7;
    for (let index = 0; index < 42; index += 1) {
      const day = new Date(year, month, 1 - firstDayOffset + index);
      const key = dateKey(day);
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'calendar-day';
      button.textContent = day.getDate();
      button.setAttribute('aria-label', formatLongDate(day));
      if (day.getMonth() !== month) button.classList.add('other-month');
      if (key === '2026-08-24') button.classList.add('today');
      if (key === dateKey(state.selectedDate)) button.classList.add('selected');
      if (appointmentDates.has(key)) button.classList.add('has-appointment');
      button.addEventListener('click', () => {
        state.selectedDate = day;
        if (day.getMonth() !== state.calendarDate.getMonth()) state.calendarDate = new Date(day.getFullYear(), day.getMonth(), 1);
        renderCalendar();
        updateSelectedDayLabel();
      });
      grid.appendChild(button);
    }
  }

  function updateSelectedDayLabel() {
    const label = $('#selectedDayLabel');
    if (!label) return;
    const isToday = dateKey(state.selectedDate) === '2026-08-24';
    label.textContent = `${isToday ? 'Oggi' : capitalize(new Intl.DateTimeFormat('it-IT', { weekday: 'long' }).format(state.selectedDate))}, ${state.selectedDate.getDate()} ${new Intl.DateTimeFormat('it-IT', { month: 'long' }).format(state.selectedDate)}`;
  }

  function setupCalendar() {
    renderCalendar();
    updateSelectedDayLabel();
    $('#previousMonth')?.addEventListener('click', () => {
      state.calendarDate = new Date(state.calendarDate.getFullYear(), state.calendarDate.getMonth() - 1, 1);
      renderCalendar();
    });
    $('#nextMonth')?.addEventListener('click', () => {
      state.calendarDate = new Date(state.calendarDate.getFullYear(), state.calendarDate.getMonth() + 1, 1);
      renderCalendar();
    });
  }

  function setupClientTable() {
    const getRows = () => $$('#clientsTableBody tr');
    const search = $('#clientSearch');
    let currentFilter = 'all';

    const filterRows = () => {
      const query = (search?.value || '').trim().toLowerCase();
      getRows().forEach((row) => {
        const matchesFilter = currentFilter === 'all' || row.dataset.status === currentFilter;
        const matchesSearch = !query || row.textContent.toLowerCase().includes(query);
        row.hidden = !(matchesFilter && matchesSearch);
      });
    };

    $$('.client-tab').forEach((tab) => tab.addEventListener('click', () => {
      currentFilter = tab.dataset.filter || 'all';
      $$('.client-tab').forEach((item) => item.classList.toggle('active', item === tab));
      filterRows();
    }));
    search?.addEventListener('input', filterRows);

    $('#selectAllClients')?.addEventListener('change', (event) => {
      getRows().filter((row) => !row.hidden).forEach((row) => {
        const checkbox = $('.client-check', row);
        if (checkbox) checkbox.checked = event.target.checked;
      });
    });

    const exportClients = () => {
      const visibleRows = getRows().filter((row) => !row.hidden);
      const csv = ['Cliente,Email,Veicolo,Targa,Ultimo intervento,Valore cliente,Stato'];
      visibleRows.forEach((row) => {
        const cells = row.cells;
        const nameBlock = $('.table-person', cells[1]);
        const name = $('strong', nameBlock)?.textContent.trim() || '';
        const email = $('span', nameBlock)?.textContent.trim() || '';
        const vehicle = cells[2]?.childNodes[0]?.textContent.trim() || '';
        const plate = $('small', cells[2])?.textContent.trim() || '';
        const values = [name, email, vehicle, plate, cells[3]?.textContent.trim(), cells[4]?.textContent.trim(), cells[5]?.textContent.trim()];
        csv.push(values.map((value) => `"${String(value).replaceAll('"', '""')}"`).join(','));
      });
      downloadFile('tyrecare-clienti.csv', csv.join('\n'));
      showToast(`${visibleRows.length} clienti esportati in formato CSV.`);
    };

    $('#clientExportButton')?.addEventListener('click', exportClients);
  }

  function setupAppointmentForm() {
    const form = $('#appointmentForm');
    if (!form) return;
    form.addEventListener('submit', async (event) => {
      event.preventDefault();
      const client = $('#appointmentClient').value;
      const date = $('#appointmentDate').value;
      const time = $('#appointmentTime').value;
      const service = $('#appointmentService').value;
      if (!client || !date || !time || !service) return;

      const [year, month, day] = date.split('-').map(Number);
      try {
        if (liveUser && firebaseDb) {
          await firebaseDb.collection('appointments').add({
            workshopId: WORKSHOP_ID,
            workshopName: 'La Santi Gomme',
            customerId: liveUser.uid,
            customerName: client,
            customerEmail: liveUser.email || null,
            service,
            preferredDate: firebase.firestore.Timestamp.fromDate(new Date(year, month - 1, day)),
            preferredTime: time,
            note: $('#appointmentNote').value.trim(),
            status: 'confirmed',
            createdAt: firebase.firestore.FieldValue.serverTimestamp(),
            updatedAt: firebase.firestore.FieldValue.serverTimestamp(),
          });
        }
      } catch (error) {
        console.warn('TyreCare Firebase appointment write failed:', error);
        showToast('Impossibile salvare l’appuntamento. Riprova.');
        return;
      }

      const readableDate = new Intl.DateTimeFormat('it-IT', { day: 'numeric', month: 'long' }).format(new Date(year, month - 1, day));
      const initials = client.split(' ').map((part) => part[0]).join('').slice(0, 2);
      const palette = ['teal-bg', 'violet-bg', 'orange-bg', 'blue-bg'];
      const color = palette[document.querySelectorAll('.appointment-item').length % palette.length];
      const item = document.createElement('div');
      item.className = 'appointment-item';
      item.innerHTML = `<div class="appointment-time"><strong>${time}</strong><span>Nuovo</span></div><div class="appointment-avatar ${color}">${initials}</div><div class="appointment-info"><strong>${client}</strong><span><i class="bi bi-car-front"></i> ${service} · ${readableDate}</span></div><span class="appointment-status pending">Da confermare</span><button class="item-more" aria-label="Opzioni appuntamento"><i class="bi bi-three-dots-vertical"></i></button>`;
      $('#appointmentList')?.prepend(item);

      const modalElement = $('#appointmentModal');
      const modal = modalElement ? bootstrap.Modal.getInstance(modalElement) : null;
      modal?.hide();
      form.reset();
      showToast(`Appuntamento per ${client} creato correttamente.`);
    });
  }

  function setupTheme() {
    const themeToggle = $('#themeToggle');
    const savedTheme = window.localStorage.getItem('tyrecare-theme');
    if (savedTheme === 'dark') document.body.classList.add('dark-mode');
    const updateIcon = () => {
      const icon = $('i', themeToggle);
      if (icon) icon.className = document.body.classList.contains('dark-mode') ? 'bi bi-sun' : 'bi bi-moon-stars';
    };
    updateIcon();
    themeToggle?.addEventListener('click', () => {
      document.body.classList.toggle('dark-mode');
      window.localStorage.setItem('tyrecare-theme', document.body.classList.contains('dark-mode') ? 'dark' : 'light');
      updateIcon();
      showToast(document.body.classList.contains('dark-mode') ? 'Tema scuro attivato.' : 'Tema chiaro attivato.');
    });
  }

  function setupUtilities() {
    toast = new bootstrap.Toast($('#appToast'), { delay: 3500 });
    $$('[data-bs-toggle="tooltip"]').forEach((element) => new bootstrap.Tooltip(element));
    $('#notificationButton')?.addEventListener('click', () => showToast('Hai 3 notifiche non lette nel workspace.'));
    $('#exportReportButton')?.addEventListener('click', () => {
      const report = [
        'TyreCare Partner — Report performance',
        '',
        'Periodo;Agosto 2026',
        'Ricavi netti;€ 48.760,40',
        'Appuntamenti;164',
        'Clienti attivi;284',
        'Ticket medio;€ 347,80',
        'Tasso ritorno clienti;82%',
      ].join('\n');
      downloadFile('tyrecare-report-agosto-2026.csv', report);
      showToast('Report performance esportato.');
    });
    $('.banner-close')?.addEventListener('click', (event) => event.currentTarget.closest('.insight-banner')?.remove());
    $('#globalSearchButton')?.addEventListener('click', () => {
      setActiveSection('clients');
      window.setTimeout(() => $('#clientSearch')?.focus(), 450);
    });
    document.addEventListener('keydown', (event) => {
      if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k') {
        event.preventDefault();
        $('#globalSearchButton')?.click();
      }
    });
  }

  function escapeHtml(value) {
    return String(value ?? '').replace(/[&<>'\"]/g, (character) => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;',
    }[character]));
  }

  function updateBackendStatus(user, error = false) {
    const title = $('#backendStatusTitle');
    const text = $('#backendStatusText');
    const button = $('#backendConnectButton');
    if (!title || !text || !button) return;

    if (user) {
      title.textContent = 'Dati sincronizzati';
      text.innerHTML = '<i class="live-dot"></i> Firebase Live';
      button.innerHTML = '<i class="bi bi-box-arrow-right"></i> Scollega account';
      button.classList.add('connected');
    } else {
      title.textContent = error ? 'Demo locale' : 'Demo locale';
      text.innerHTML = `<i class="live-dot"></i> ${error ? 'Firebase non disponibile' : 'Dati di presentazione'}`;
      button.innerHTML = '<i class="bi bi-cloud-arrow-up"></i> Collega dati Firebase';
      button.classList.remove('connected');
    }
  }

  function authErrorMessage(error) {
    const messages = {
      'auth/invalid-credential': 'Email o password non corrette.',
      'auth/user-not-found': 'Nessuna utenza trovata per questa email.',
      'auth/wrong-password': 'Email o password non corrette.',
      'auth/too-many-requests': 'Troppi tentativi. Riprova tra poco.',
      'auth/network-request-failed': 'Connessione non disponibile. Controlla la rete.',
    };
    return messages[error?.code] || 'Impossibile collegare l’utenza Firebase.';
  }

  function statusLabel(status) {
    const labels = { requested: 'In attesa', confirmed: 'Confermato', completed: 'Completato', cancelled: 'Annullato' };
    return labels[status] || 'In attesa';
  }

  function appointmentClass(status) {
    return status === 'confirmed' || status === 'completed' ? 'confirmed' : 'pending';
  }

  function snapshotDate(value) {
    if (!value) return null;
    if (typeof value.toDate === 'function') return value.toDate();
    if (value.seconds) return new Date(value.seconds * 1000);
    return value instanceof Date ? value : new Date(value);
  }

  function renderLiveAppointments(snapshot) {
    const list = $('#appointmentList');
    if (!list || snapshot.empty) return;
    const documents = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    documents.sort((left, right) => {
      const leftDate = snapshotDate(left.preferredDate)?.getTime() || 0;
      const rightDate = snapshotDate(right.preferredDate)?.getTime() || 0;
      return leftDate - rightDate || String(left.preferredTime || '').localeCompare(String(right.preferredTime || ''));
    });
    list.innerHTML = '';
    documents.slice(0, 8).forEach((appointment, index) => {
      const date = snapshotDate(appointment.preferredDate);
      const customer = escapeHtml(appointment.customerName || 'Cliente TyreCare');
      const service = escapeHtml(appointment.service || 'Servizio da definire');
      const time = escapeHtml(appointment.preferredTime || '--:--');
      const status = appointment.status || 'requested';
      const initials = customer.replace(/[^A-Za-zÀ-ÿ ]/g, '').split(' ').filter(Boolean).map((part) => part[0]).join('').slice(0, 2).toUpperCase() || 'TC';
      const palette = ['teal-bg', 'violet-bg', 'orange-bg', 'blue-bg'];
      const item = document.createElement('div');
      item.className = 'appointment-item';
      item.innerHTML = `<div class="appointment-time"><strong>${time}</strong><span>${date ? new Intl.DateTimeFormat('it-IT', { day: 'numeric', month: 'short' }).format(date) : 'Da definire'}</span></div><div class="appointment-avatar ${palette[index % palette.length]}">${escapeHtml(initials)}</div><div class="appointment-info"><strong>${customer}</strong><span><i class="bi bi-car-front"></i> ${service}</span></div><span class="appointment-status ${appointmentClass(status)}">${statusLabel(status)}</span><button class="item-more" aria-label="Opzioni appuntamento"><i class="bi bi-three-dots-vertical"></i></button>`;
      list.appendChild(item);
      if (date) appointmentDates.add(dateKey(date));
    });
    renderCalendar();
    const counter = $('.nav-link[data-section="appointments"] .nav-counter');
    if (counter) counter.textContent = String(documents.length);
  }

  function renderLiveCustomers(snapshot) {
    const body = $('#clientsTableBody');
    if (!body || snapshot.empty) return;
    body.innerHTML = '';
    snapshot.docs.slice(0, 20).forEach((snapshotDocument, index) => {
      const customer = snapshotDocument.data();
      const name = escapeHtml(customer.displayName || customer.name || 'Cliente TyreCare');
      const email = escapeHtml(customer.email || 'Email non disponibile');
      const initials = name.replace(/[^A-Za-zÀ-ÿ ]/g, '').split(' ').filter(Boolean).map((part) => part[0]).join('').slice(0, 2).toUpperCase() || 'TC';
      const palette = ['teal-bg', 'violet-bg', 'orange-bg', 'blue-bg'];
      const row = window.document.createElement('tr');
      row.dataset.status = 'active';
      row.innerHTML = `<td><input class="form-check-input client-check" type="checkbox" aria-label="Seleziona ${name}"></td><td><div class="table-person"><div class="table-avatar ${palette[index % palette.length]}">${escapeHtml(initials)}</div><div><strong>${name}</strong><span>${email}</span></div></div></td><td>Veicolo da associare</td><td>Profilo TyreCare</td><td class="money-cell">—</td><td><span class="status-pill active">Attivo</span></td><td><button class="row-more" aria-label="Apri cliente ${name}"><i class="bi bi-arrow-up-right"></i></button></td>`;
      body.appendChild(row);
    });
    const counter = $('.nav-link[data-section="clients"] .nav-counter');
    if (counter) counter.textContent = String(snapshot.size);
    const tabCount = $('.client-tab[data-filter="all"] span');
    if (tabCount) tabCount.textContent = String(snapshot.size);
  }

  function stopLiveData() {
    liveUnsubscribers.forEach((unsubscribe) => unsubscribe());
    liveUnsubscribers = [];
    liveCounts = { appointments: 0, customers: 0 };
  }

  function updateLiveRecordCount() {
    const statusText = $('#backendStatusText');
    if (statusText) statusText.innerHTML = `<i class="live-dot"></i> ${liveCounts.appointments + liveCounts.customers} record sincronizzati`;
  }

  function loadLiveData() {
    if (!firebaseDb || !liveUser) return;
    stopLiveData();
    const appointmentsQuery = firebaseDb.collection('appointments').where('workshopId', '==', WORKSHOP_ID).limit(50);
    const customersQuery = firebaseDb.collection('customers').where('workshopId', '==', WORKSHOP_ID).limit(200);
    const onReadError = (error) => {
      console.warn('TyreCare Firebase read failed:', error);
      showToast('Accesso riuscito, ma non è stato possibile leggere i dati dell’officina.');
    };

    liveUnsubscribers.push(appointmentsQuery.onSnapshot((snapshot) => {
      liveCounts.appointments = snapshot.size;
      renderLiveAppointments(snapshot);
      updateLiveRecordCount();
    }, onReadError));
    liveUnsubscribers.push(customersQuery.onSnapshot((snapshot) => {
      liveCounts.customers = snapshot.size;
      renderLiveCustomers(snapshot);
      updateLiveRecordCount();
    }, onReadError));
  }

  function setupFirebase() {
    const config = window.TyreCareFirebaseConfig;
    if (!config || typeof firebase === 'undefined') {
      updateBackendStatus(null, true);
      return;
    }
    try {
      if (!firebase.apps.length) firebase.initializeApp(config);
      firebaseAuth = firebase.auth();
      firebaseDb = firebase.firestore();
      firebaseAuth.onAuthStateChanged((user) => {
        if (!user) stopLiveData();
        liveUser = user;
        updateBackendStatus(user);
        if (user) loadLiveData();
      });
    } catch (error) {
      console.warn('TyreCare Firebase init failed:', error);
      updateBackendStatus(null, true);
    }
  }

  function setupAuth() {
    const button = $('#backendConnectButton');
    const form = $('#authForm');
    const modalElement = $('#authModal');
    if (!button || !form || !modalElement) return;
    const modal = bootstrap.Modal.getOrCreateInstance(modalElement);

    button.addEventListener('click', async () => {
      if (liveUser && firebaseAuth) {
        await firebaseAuth.signOut();
        showToast('Account Firebase scollegato.');
      } else {
        $('#authError').textContent = '';
        modal.show();
      }
    });
    form.addEventListener('submit', async (event) => {
      event.preventDefault();
      if (!firebaseAuth) {
        $('#authError').textContent = 'Firebase non è disponibile in questa sessione.';
        return;
      }
      const submitButton = $('button[type="submit"]', form);
      submitButton.disabled = true;
      $('#authError').textContent = '';
      try {
        await firebaseAuth.signInWithEmailAndPassword($('#authEmail').value.trim(), $('#authPassword').value);
        modal.hide();
        form.reset();
        showToast('Dashboard collegata ai dati reali dell’officina.');
      } catch (error) {
        $('#authError').textContent = authErrorMessage(error);
      } finally {
        submitButton.disabled = false;
      }
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    setGreeting();
    const dateLabel = $('#currentDateLabel');
    if (dateLabel) dateLabel.textContent = formatLongDate(new Date(2026, 7, 24));
    setupSidebar();
    setupSectionActions();
    setupCharts();
    setupCalendar();
    setupClientTable();
    setupAppointmentForm();
    setupTheme();
    setupUtilities();
    setupFirebase();
    setupAuth();
  });
})();
