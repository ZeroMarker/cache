[].push.apply(FullCalendar.globalLocales, function () {
  'use strict';

  var l0 = {
    code: 'af',
    week: {
      dow: 1, // Maandag is die eerste dag van die week.
      doy: 4, // Die week wat die 4de Januarie bevat is die eerste week van die jaar.
    },
    buttonText: {
      prev: 'Vorige',
      next: 'Volgende',
      today: 'Vandag',
      year: 'Jaar',
      month: 'Maand',
      week: 'Week',
      day: 'Dag',
      list: 'Agenda',
    },
    allDayText: 'Heeldag',
    moreLinkText: 'Addisionele',
    noEventsText: 'Daar is geen gebeurtenisse nie',
  };

  var l1 = {
    code: 'ar-dz',
    week: {
      dow: 0, // Sunday is the first day of the week.
      doy: 4, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l2 = {
    code: 'ar-kw',
    week: {
      dow: 0, // Sunday is the first day of the week.
      doy: 12, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l3 = {
    code: 'ar-ly',
    week: {
      dow: 6, // Saturday is the first day of the week.
      doy: 12, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l4 = {
    code: 'ar-ma',
    week: {
      dow: 6, // Saturday is the first day of the week.
      doy: 12, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l5 = {
    code: 'ar-sa',
    week: {
      dow: 0, // Sunday is the first day of the week.
      doy: 6, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l6 = {
    code: 'ar-tn',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l7 = {
    code: 'ar',
    week: {
      dow: 6, // Saturday is the first day of the week.
      doy: 12, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�9�1�8�1�1�1�9�1�0�1�6',
      next: '�1�9�1�8�1�2�1�9�1�8�1�4',
      today: '�1�9�1�8�1�4�1�2�1�9',
      month: '�1�2�1�1�1�9',
      week: '�1�5�1�1�1�0�1�2�1�7',
      day: '�1�4�1�2�1�9',
      list: '�1�5�1�4�1�0�1�7�1�1',
    },
    weekText: '�1�5�1�1�1�0�1�2�1�7',
    allDayText: '�1�9�1�8�1�4�1�2�1�9 �1�7�1�8�1�1',
    moreLinkText: '�1�5�1�6�1�9�1�3',
    noEventsText: '�1�5�1�4 �1�5�1�5�1�7�1�9�1�3 �1�8�1�7�1�9�1�4',
  };

  var l8 = {
    code: 'az',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '�0�3vv�0�5l',
      next: 'Sonra',
      today: 'Bu G��n',
      month: 'Ay',
      week: 'H�0�5ft�0�5',
      day: 'G��n',
      list: 'G��nd�0�5m',
    },
    weekText: 'H�0�5ft�0�5',
    allDayText: 'B��t��n G��n',
    moreLinkText: function(n) {
      return '+ daha �0�4ox ' + n
    },
    noEventsText: 'G�0�2st�0�5rm�0�5k ���0�4��n hadis�0�5 yoxdur',
  };

  var l9 = {
    code: 'bg',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '�ߧѧ٧ѧ�',
      next: '�ߧѧ��֧�',
      today: '�էߧ֧�',
      month: '���֧�֧�',
      week: '���֧էާڧ��',
      day: '���֧�',
      list: '����ѧ�ڧ�',
    },
    allDayText: '����� �է֧�',
    moreLinkText: function(n) {
      return '+���� ' + n
    },
    noEventsText: '����ާ� ���ҧڧ�ڧ� �٧� ���ܧѧ٧ӧѧߧ�',
  };

  var l10 = {
    code: 'bn',
    week: {
      dow: 0, // Sunday is the first day of the week.
      doy: 6, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '�1�8�1�7�1�3�1�6�1�7',
      next: '�1�2�1�8�1�2�1�6�1�7',
      today: '�1�2�1�4',
      month: '�1�2�1�8�1�2',
      week: '�1�2�1�8�1�3�1�2�1�8�1�3',
      day: '�1�4�1�9�1�6',
      list: '�1�2�1�8�1�6�1�9�1�7�1�8',
    },
    weekText: '�1�2�1�8�1�3�1�2�1�8�1�3',
    allDayText: '�1�2�1�8�1�4�1�8�1�4�1�9�1�6',
    moreLinkText: function(n) {
      return '+�1�1�1�6�1�3�1�3�1�8�1�6�1�3�1�3 ' + n
    },
    noEventsText: '�1�7�1�1�1�6�1�1 �1�3�1�1�1�7�1�6�1�3�1�7 �1�6�1�7�1�3',
  };

  var l11 = {
    code: 'bs',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Pro�0�8li',
      next: 'Sljede�0�4i',
      today: 'Danas',
      month: 'Mjesec',
      week: 'Sedmica',
      day: 'Dan',
      list: 'Raspored',
    },
    weekText: 'Sed',
    allDayText: 'Cijeli dan',
    moreLinkText: function(n) {
      return '+ jo�0�8 ' + n
    },
    noEventsText: 'Nema doga�0�4aja za prikazivanje',
  };

  var l12 = {
    code: 'ca',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Anterior',
      next: 'Seg��ent',
      today: 'Avui',
      month: 'Mes',
      week: 'Setmana',
      day: 'Dia',
      list: 'Agenda',
    },
    weekText: 'Set',
    allDayText: 'Tot el dia',
    moreLinkText: 'm��s',
    noEventsText: 'No hi ha esdeveniments per mostrar',
  };

  var l13 = {
    code: 'cs',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'D�0�0��ve',
      next: 'Pozd��ji',
      today: 'Nyn��',
      month: 'M��s��c',
      week: 'T�0�5den',
      day: 'Den',
      list: 'Agenda',
    },
    weekText: 'T�0�5d',
    allDayText: 'Cel�0�5 den',
    moreLinkText: function(n) {
      return '+dal�0�8��: ' + n
    },
    noEventsText: '�0�5��dn�� akce k zobrazen��',
  };

  var l14 = {
    code: 'cy',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Blaenorol',
      next: 'Nesaf',
      today: 'Heddiw',
      year: 'Blwyddyn',
      month: 'Mis',
      week: 'Wythnos',
      day: 'Dydd',
      list: 'Rhestr',
    },
    weekText: 'Wythnos',
    allDayText: 'Trwy\'r dydd',
    moreLinkText: 'Mwy',
    noEventsText: 'Dim digwyddiadau',
  };

  var l15 = {
    code: 'da',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Forrige',
      next: 'N�0�3ste',
      today: 'I dag',
      month: 'M�0�2ned',
      week: 'Uge',
      day: 'Dag',
      list: 'Agenda',
    },
    weekText: 'Uge',
    allDayText: 'Hele dagen',
    moreLinkText: 'flere',
    noEventsText: 'Ingen arrangementer at vise',
  };

  var l16 = {
    code: 'de-at',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Zur��ck',
      next: 'Vor',
      today: 'Heute',
      year: 'Jahr',
      month: 'Monat',
      week: 'Woche',
      day: 'Tag',
      list: 'Termin��bersicht',
    },
    weekText: 'KW',
    allDayText: 'Ganzt�0�1gig',
    moreLinkText: function(n) {
      return '+ weitere ' + n
    },
    noEventsText: 'Keine Ereignisse anzuzeigen',
  };

  var l17 = {
    code: 'de',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Zur��ck',
      next: 'Vor',
      today: 'Heute',
      year: 'Jahr',
      month: 'Monat',
      week: 'Woche',
      day: 'Tag',
      list: 'Termin��bersicht',
    },
    weekText: 'KW',
    allDayText: 'Ganzt�0�1gig',
    moreLinkText: function(n) {
      return '+ weitere ' + n
    },
    noEventsText: 'Keine Ereignisse anzuzeigen',
  };

  var l18 = {
    code: 'el',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4st is the first week of the year.
    },
    buttonText: {
      prev: '���ѦϦǦæρ0�3�̦Ŧͦρ0�9',
      next: '���Ё0�2�̦Ŧͦρ0�9',
      today: '���0�6�̦ŦѦ�',
      month: '���0�6�ͦ��0�9',
      week: '���¦ĦϦ́0�4�Ħ�',
      day: '���́0�5�Ѧ�',
      list: '���ӦƁ0�5�ͦӦ�',
    },
    weekText: '���¦�',
    allDayText: '���˦ρ0�6�̦ŦѦ�',
    moreLinkText: '�ЦŦѦɦҦҁ0�2�ӦŦѦ�',
    noEventsText: '���Ŧ� �ԦЁ0�4�Ѧ֦ϦԦ� �æŦæϦ́0�2�Ӧ� �ЦѦρ0�9 �Ŧ̦Ձ0�4�ͦɦҦ�',
  };

  var l19 = {
    code: 'en-au',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
  };

  var l20 = {
    code: 'en-gb',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
  };

  var l21 = {
    code: 'en-nz',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
  };

  var l22 = {
    code: 'eo',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Anta�0�9a',
      next: 'Sekva',
      today: 'Hodia�0�9',
      month: 'Monato',
      week: 'Semajno',
      day: 'Tago',
      list: 'Tagordo',
    },
    weekText: 'Sm',
    allDayText: 'Tuta tago',
    moreLinkText: 'pli',
    noEventsText: 'Neniuj eventoj por montri',
  };

  var l23 = {
    code: 'es',
    week: {
      dow: 0, // Sunday is the first day of the week.
      doy: 6, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Ant',
      next: 'Sig',
      today: 'Hoy',
      month: 'Mes',
      week: 'Semana',
      day: 'D��a',
      list: 'Agenda',
    },
    weekText: 'Sm',
    allDayText: 'Todo el d��a',
    moreLinkText: 'm��s',
    noEventsText: 'No hay eventos para mostrar',
  };

  var l24 = {
    code: 'es',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Ant',
      next: 'Sig',
      today: 'Hoy',
      month: 'Mes',
      week: 'Semana',
      day: 'D��a',
      list: 'Agenda',
    },
    weekText: 'Sm',
    allDayText: 'Todo el d��a',
    moreLinkText: 'm��s',
    noEventsText: 'No hay eventos para mostrar',
  };

  var l25 = {
    code: 'et',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Eelnev',
      next: 'J�0�1rgnev',
      today: 'T�0�1na',
      month: 'Kuu',
      week: 'N�0�1dal',
      day: 'P�0�1ev',
      list: 'P�0�1evakord',
    },
    weekText: 'n�0�1d',
    allDayText: 'Kogu p�0�1ev',
    moreLinkText: function(n) {
      return '+ veel ' + n
    },
    noEventsText: 'Kuvamiseks puuduvad s��ndmused',
  };

  var l26 = {
    code: 'eu',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Aur',
      next: 'Hur',
      today: 'Gaur',
      month: 'Hilabetea',
      week: 'Astea',
      day: 'Eguna',
      list: 'Agenda',
    },
    weekText: 'As',
    allDayText: 'Egun osoa',
    moreLinkText: 'gehiago',
    noEventsText: 'Ez dago ekitaldirik erakusteko',
  };

  var l27 = {
    code: 'fa',
    week: {
      dow: 6, // Saturday is the first day of the week.
      doy: 12, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�6�1�0�1�8�1�4',
      next: '�1�0�1�7�1�7�1�4',
      today: '�1�9�1�9�1�9�1�2�1�0',
      month: '�1�9�1�9�1�1',
      week: '�1�1�1�5�1�2�1�1',
      day: '�1�9�1�2�1�0',
      list: '�1�0�1�9�1�0�1�9�1�9�1�1',
    },
    weekText: '�1�1�1�5',
    allDayText: '�1�2�1�9�1�9�1�9 �1�9�1�2�1�0',
    moreLinkText: function(n) {
      return '�1�0�1�4�1�2 �1�9�1�0 ' + n
    },
    noEventsText: '�1�1�1�4�1�4 �1�9�1�2�1�4�1�7�1�9�1�7�1�4 �1�0�1�1 �1�0�1�9�1�9�1�4�1�2',
  };

  var l28 = {
    code: 'fi',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Edellinen',
      next: 'Seuraava',
      today: 'T�0�1n�0�1�0�1n',
      month: 'Kuukausi',
      week: 'Viikko',
      day: 'P�0�1iv�0�1',
      list: 'Tapahtumat',
    },
    weekText: 'Vk',
    allDayText: 'Koko p�0�1iv�0�1',
    moreLinkText: 'lis�0�1�0�1',
    noEventsText: 'Ei n�0�1ytett�0�1vi�0�1 tapahtumia',
  };

  var l29 = {
    code: 'fr',
    buttonText: {
      prev: 'Pr��c��dent',
      next: 'Suivant',
      today: "Aujourd'hui",
      year: 'Ann��e',
      month: 'Mois',
      week: 'Semaine',
      day: 'Jour',
      list: 'Mon planning',
    },
    weekText: 'Sem.',
    allDayText: 'Toute la journ��e',
    moreLinkText: 'en plus',
    noEventsText: 'Aucun ��v��nement �� afficher',
  };

  var l30 = {
    code: 'fr-ch',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Pr��c��dent',
      next: 'Suivant',
      today: 'Courant',
      year: 'Ann��e',
      month: 'Mois',
      week: 'Semaine',
      day: 'Jour',
      list: 'Mon planning',
    },
    weekText: 'Sm',
    allDayText: 'Toute la journ��e',
    moreLinkText: 'en plus',
    noEventsText: 'Aucun ��v��nement �� afficher',
  };

  var l31 = {
    code: 'fr',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Pr��c��dent',
      next: 'Suivant',
      today: "Aujourd'hui",
      year: 'Ann��e',
      month: 'Mois',
      week: 'Semaine',
      day: 'Jour',
      list: 'Planning',
    },
    weekText: 'Sem.',
    allDayText: 'Toute la journ��e',
    moreLinkText: 'en plus',
    noEventsText: 'Aucun ��v��nement �� afficher',
  };

  var l32 = {
    code: 'gl',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Ant',
      next: 'Seg',
      today: 'Hoxe',
      month: 'Mes',
      week: 'Semana',
      day: 'D��a',
      list: 'Axenda',
    },
    weekText: 'Sm',
    allDayText: 'Todo o d��a',
    moreLinkText: 'm��is',
    noEventsText: 'Non hai eventos para amosar',
  };

  var l33 = {
    code: 'he',
    direction: 'rtl',
    buttonText: {
      prev: '�0�6�0�5�0�7�0�5�0�5',
      next: '�0�6�0�3�0�2',
      today: '�0�6�0�1�0�7�0�5',
      month: '�0�9�0�7�0�5�0�7',
      week: '�0�7�0�3�0�7�0�0',
      day: '�0�1�0�7�0�5',
      list: '�0�9�0�5�0�6 �0�1�0�7�0�5',
    },
    allDayText: '�0�3�0�4 �0�6�0�1�0�7�0�5',
    moreLinkText: '�0�2�0�9�0�6',
    noEventsText: '�0�2�0�1�0�7 �0�2�0�1�0�6�0�7�0�0�0�1�0�5 �0�4�0�6�0�4�0�4�0�6',
    weekText: '�0�7�0�3�0�7�0�0',
  };

  var l34 = {
    code: 'hi',
    week: {
      dow: 0, // Sunday is the first day of the week.
      doy: 6, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '�1�0�1�1�1�5�1�8�1�0',
      next: '�1�3�1�1�1�8�1�0',
      today: '�1�4�1�6',
      month: '�1�4�1�5�1�2�1�8�1�0',
      week: '�1�4�1�0�1�5�1�4�1�0�1�5',
      day: '�1�6�1�1�1�8',
      list: '�1�9�1�0�1�6�1�5�1�5�1�4�1�4�1�4�1�2',
    },
    weekText: '�1�5�1�1�1�5�1�4�1�0',
    allDayText: '�1�4�1�3�1�2 �1�6�1�1�1�8',
    moreLinkText: function(n) {
      return '+�1�3�1�7�1�1�1�9 ' + n
    },
    noEventsText: '�1�9�1�3�1�6 �1�2�1�9�1�8�1�0�1�7�1�0 �1�9�1�3 �1�0�1�5�1�6�1�6�1�6�1�5�1�2�1�1�1�4 �1�9�1�6�1�8�1�9 �1�9�1�9 �1�8�1�1�1�3',
  };

  var l35 = {
    code: 'hr',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Prija�0�8nji',
      next: 'Sljede�0�4i',
      today: 'Danas',
      month: 'Mjesec',
      week: 'Tjedan',
      day: 'Dan',
      list: 'Raspored',
    },
    weekText: 'Tje',
    allDayText: 'Cijeli dan',
    moreLinkText: function(n) {
      return '+ jo�0�8 ' + n
    },
    noEventsText: 'Nema doga�0�4aja za prikaz',
  };

  var l36 = {
    code: 'hu',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'vissza',
      next: 'el�0�2re',
      today: 'ma',
      month: 'H��nap',
      week: 'H��t',
      day: 'Nap',
      list: 'Lista',
    },
    weekText: 'H��t',
    allDayText: 'Eg��sz nap',
    moreLinkText: 'tov��bbi',
    noEventsText: 'Nincs megjelen��thet�0�2 esem��ny',
  };

  var l37 = {
    code: 'hy-am',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '�0�4�0�1�0�3�0�4�0�2�0�4',
      next: '�0�8�0�1�0�7�0�4�0�2�0�4',
      today: '�0�3�0�1�0�9�0�7�0�2',
      month: '�0�3�0�0�0�1�0�9',
      week: '�0�5�0�1�0�2�0�1�0�9',
      day: '�0�9�0�2',
      list: '�0�9�0�2�0�0�0�1 �0�3�0�4�0�4�0�3�0�1�0�5',
    },
    weekText: '�0�5�0�1�0�2',
    allDayText: '�0�3�0�0�0�2�0�4�0�8�0�7 �0�7�0�2',
    moreLinkText: function(n) {
      return '+ �0�9�0�9 ' + n
    },
    noEventsText: '�0�4�0�1�0�3�0�1�0�5�0�1�0�1�0�4�0�4�0�0 �0�7 �0�1�0�2�0�1�0�4�0�1�0�2�0�7�0�4�0�4�0�9�0�1�0�4�0�4�0�2�0�8 �0�3�0�4�0�4�0�3�0�1�0�4�0�2�0�5�0�2�0�4�0�4',
  };

  var l38 = {
    code: 'id',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'mundur',
      next: 'maju',
      today: 'hari ini',
      month: 'Bulan',
      week: 'Minggu',
      day: 'Hari',
      list: 'Agenda',
    },
    weekText: 'Mg',
    allDayText: 'Sehari penuh',
    moreLinkText: 'lebih',
    noEventsText: 'Tidak ada acara untuk ditampilkan',
  };

  var l39 = {
    code: 'is',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Fyrri',
      next: 'N�0�3sti',
      today: '�0�1 dag',
      month: 'M��nu�0�8ur',
      week: 'Vika',
      day: 'Dagur',
      list: 'Dagskr��',
    },
    weekText: 'Vika',
    allDayText: 'Allan daginn',
    moreLinkText: 'meira',
    noEventsText: 'Engir vi�0�8bur�0�8ir til a�0�8 s�0�5na',
  };

  var l40 = {
    code: 'it',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Prec',
      next: 'Succ',
      today: 'Oggi',
      month: 'Mese',
      week: 'Settimana',
      day: 'Giorno',
      list: 'Agenda',
    },
    weekText: 'Sm',
    allDayText: 'Tutto il giorno',
    moreLinkText: function(n) {
      return '+altri ' + n
    },
    noEventsText: 'Non ci sono eventi da visualizzare',
  };

  var l41 = {
    code: 'ja',
    buttonText: {
      prev: 'ǰ',
      next: '��',
      today: '����',
      month: '��',
      week: '�L',
      day: '��',
      list: '�趨�ꥹ��',
    },
    weekText: '�L',
    allDayText: '�K��',
    moreLinkText: function(n) {
      return '�� ' + n + ' ��'
    },
    noEventsText: '��ʾ�����趨�Ϥ���ޤ���',
  };

  var l42 = {
    code: 'ka',
    week: {
      dow: 1,
      doy: 7,
    },
    buttonText: {
      prev: '�3�6�3�6�3�0�3�8',
      next: '�3�2�3�2�3�9�3�1�3�2�3�0�3�6',
      today: '�3�1�3�0�3�2�3�5',
      month: '�3�5�3�3�3�2',
      week: '�3�7�3�3�3�6�3�4�3�8',
      day: '�3�1�3�0�3�2',
      list: '�3�1�3�0�3�6�3�5 �3�6�3�2�3�5�3�4�3�6�3�0�3�6',
    },
    weekText: '�3�7�3�3',
    allDayText: '�3�9�3�5�3�2�3�8�3�6 �3�1�3�0�3�2',
    moreLinkText: function(n) {
      return '+ �3�7�3�6�3�1�3�2�3�3 ' + n
    },
    noEventsText: '�3�0�3�1�3�0�3�6�3�5�3�5�3�6�3�2�3�9�3�2�3�9�3�6 �3�8�3�4 �3�8�3�4�3�6�3�5',
  };

  var l43 = {
    code: 'kk',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '���ݧէ�0�1�0�5��',
      next: '���֧ݧ֧�0�4',
      today: '���0�3�ԁ0�4��',
      month: '����',
      week: '������',
      day: '���0�3��',
      list: '���0�3�� ��0�5���0�4�ҁ0�4',
    },
    weekText: '����',
    allDayText: '���0�3�߁0�4 �ҧ�ۧ�',
    moreLinkText: function(n) {
      return '+ ��с0�5�� ' + n
    },
    noEventsText: '���0�1���֧�� �0�3��0�4�� ���0�3�ځ0�5�ѧݧѧ� �ا��0�3',
  };

  var l44 = {
    code: 'km',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '�4�4�4�9�4�9',
      next: '�4�0�4�9�4�2�4�7�4�4�4�0�4�5',
      today: '�4�6�4�2�4�4�4�7�4�9�4�5�4�1',
      year: '�4�6�4�2�4�9�4�4�4�0',
      month: '�4�1�4�6',
      week: '�4�1�4�0�4�2�4�5�4�4�4�2�4�7',
      day: '�4�6�4�2�4�4�4�7',
      list: '�4�0�4�9�4�2�4�7�4�6',
    },
    weekText: '�4�1�4�0�4�2�4�5�4�4�4�2�4�7',
    allDayText: '�4�2�4�5�4�9�4�4�4�1�4�5�4�6�4�2�4�4�4�7',
    moreLinkText: '�4�5�4�2�4�6�4�2�4�9�4�7�4�4�4�5',
    noEventsText: '�4�2�4�2�4�4�4�4�4�9�4�2�4�2�4�6�4�7�4�5�4�2�4�5�4�5�4�0�4�4�4�6�4�4�4�7�4�5�4�2�4�6�4�0�4�8�4�0�4�4�4�2�4�2�4�4�4�9',
  };

  var l45 = {
    code: 'ko',
    buttonText: {
      prev: '�3�3�3�7�9�7',
      next: '�9�9�3�3�9�7',
      today: '�2�7�8�3',
      month: '�3�3',
      week: '�3�5',
      day: '�3�1',
      list: '�3�1�3�4�0�8�0�0',
    },
    weekText: '�3�5',
    allDayText: '�3�6�3�1',
    moreLinkText: '�7�3',
    noEventsText: '�3�1�3�4�3�3 �2�3�2�8�9�1�9�9',
  };

  var l46 = {
    code: 'ku',
    week: {
      dow: 6, // Saturday is the first day of the week.
      doy: 12, // The week that contains Jan 1st is the first week of the year.
    },
    direction: 'rtl',
    buttonText: {
      prev: '�1�6�1�6�1�2�1�2�1�9',
      next: '�1�7�1�2�1�9�1�2�1�9',
      today: '�1�8�1�3�1�9�1�9�1�2',
      month: '�1�9�1�9�1�0�1�5',
      week: '�1�1�1�3�1�5�1�2�1�3',
      day: '�1�9�1�8�1�2',
      list: '�1�0�1�3�1�9�1�0�1�9�1�9�1�3',
    },
    weekText: '�1�1�1�3�1�5�1�2�1�3',
    allDayText: '�1�1�1�3�1�9�1�2�1�2 �1�9�1�8�1�2�1�3�1�9�1�3',
    moreLinkText: '�1�0�1�4�1�9�1�2�1�9',
    noEventsText: '�1�1�1�4�1�4 �1�9�1�2�1�2�1�7�1�9�1�2�1�6�1�7 �1�0�1�4�1�3',
  };

  var l47 = {
    code: 'lb',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Zr��ck',
      next: 'Weider',
      today: 'Haut',
      month: 'Mount',
      week: 'Woch',
      day: 'Dag',
      list: 'Terminiwwersiicht',
    },
    weekText: 'W',
    allDayText: 'Ganzen Dag',
    moreLinkText: 'm��i',
    noEventsText: 'Nee Evenementer ze affich��ieren',
  };

  var l48 = {
    code: 'lt',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Atgal',
      next: 'Pirmyn',
      today: '�0�7iandien',
      month: 'M�0�9nuo',
      week: 'Savait�0�9',
      day: 'Diena',
      list: 'Darbotvark�0�9',
    },
    weekText: 'SAV',
    allDayText: 'Vis�0�2 dien�0�2',
    moreLinkText: 'daugiau',
    noEventsText: 'N�0�9ra �0�1vyki�0�5 rodyti',
  };

  var l49 = {
    code: 'lv',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Iepr.',
      next: 'N��k.',
      today: '�0�7odien',
      month: 'M��nesis',
      week: 'Ned���0�4a',
      day: 'Diena',
      list: 'Dienas k��rt��ba',
    },
    weekText: 'Ned.',
    allDayText: 'Visu dienu',
    moreLinkText: function(n) {
      return '+v��l ' + n
    },
    noEventsText: 'Nav notikumu',
  };

  var l50 = {
    code: 'mk',
    buttonText: {
      prev: '���֧���էߧ�',
      next: '��ݧ֧էߧ�',
      today: '���֧ߧ֧�',
      month: '���֧�֧�',
      week: '���֧է֧ݧ�',
      day: '���֧�',
      list: '����ѧ�ڧ�',
    },
    weekText: '���֧�',
    allDayText: '���֧� �է֧�',
    moreLinkText: function(n) {
      return '+���ӧց0�0�� ' + n
    },
    noEventsText: '���֧ާ� �ߧѧ��ѧߧ� �٧� ���ڧܧѧا�ӧс0�8��',
  };

  var l51 = {
    code: 'ms',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Sebelum',
      next: 'Selepas',
      today: 'hari ini',
      month: 'Bulan',
      week: 'Minggu',
      day: 'Hari',
      list: 'Agenda',
    },
    weekText: 'Mg',
    allDayText: 'Sepanjang hari',
    moreLinkText: function(n) {
      return 'masih ada ' + n + ' acara'
    },
    noEventsText: 'Tiada peristiwa untuk dipaparkan',
  };

  var l52 = {
    code: 'nb',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Forrige',
      next: 'Neste',
      today: 'I dag',
      month: 'M�0�2ned',
      week: 'Uke',
      day: 'Dag',
      list: 'Agenda',
    },
    weekText: 'Uke',
    allDayText: 'Hele dagen',
    moreLinkText: 'til',
    noEventsText: 'Ingen hendelser �0�2 vise',
  };

  var l53 = {
    code: 'ne', // code for nepal
    week: {
      dow: 7, // Sunday is the first day of the week.
      doy: 1, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '�1�3�1�2�1�1�1�8�1�5�1�8�1�3',
      next: '�1�3�1�6�1�5�1�9�1�3',
      today: '�1�4�1�6',
      month: '�1�4�1�5�1�1�1�8�1�0',
      week: '�1�5�1�0�1�5�1�4�1�0',
      day: '�1�6�1�1�1�8',
      list: '�1�4�1�4�1�4�1�2',
    },
    weekText: '�1�5�1�0�1�5�1�4�1�0',
    allDayText: '�1�6�1�1�1�8�1�3�1�6�1�1',
    moreLinkText: '�1�5�1�0 �1�8�1�1�1�0�1�9',
    noEventsText: '�1�6�1�9�1�0�1�0�1�7�1�8�1�9�1�3 �1�8�1�0�1�1�1�1 �1�9�1�3�1�8�1�0 �1�2�1�9�1�8�1�0�1�5�1�6�1�4 �1�5�1�0�1�8�1�8�1�5',
  };

  var l54 = {
    code: 'nl',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Vorige',
      next: 'Volgende',
      today: 'Vandaag',
      year: 'Jaar',
      month: 'Maand',
      week: 'Week',
      day: 'Dag',
      list: 'Agenda',
    },
    allDayText: 'Hele dag',
    moreLinkText: 'extra',
    noEventsText: 'Geen evenementen om te laten zien',
  };

  var l55 = {
    code: 'nn',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'F�0�3rre',
      next: 'Neste',
      today: 'I dag',
      month: 'M�0�2nad',
      week: 'Veke',
      day: 'Dag',
      list: 'Agenda',
    },
    weekText: 'Veke',
    allDayText: 'Heile dagen',
    moreLinkText: 'til',
    noEventsText: 'Ingen hendelser �0�2 vise',
  };

  var l56 = {
    code: 'pl',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Poprzedni',
      next: 'Nast�0�1pny',
      today: 'Dzi�0�2',
      month: 'Miesi�0�2c',
      week: 'Tydzie��',
      day: 'Dzie��',
      list: 'Plan dnia',
    },
    weekText: 'Tydz',
    allDayText: 'Ca�0�0y dzie��',
    moreLinkText: 'wi�0�1cej',
    noEventsText: 'Brak wydarze�� do wy�0�2wietlenia',
  };

  var l57 = {
    code: 'pt-br',
    buttonText: {
      prev: 'Anterior',
      next: 'Pr��ximo',
      today: 'Hoje',
      month: 'M��s',
      week: 'Semana',
      day: 'Dia',
      list: 'Lista',
    },
    weekText: 'Sm',
    allDayText: 'dia inteiro',
    moreLinkText: function(n) {
      return 'mais +' + n
    },
    noEventsText: 'N�0�0o h�� eventos para mostrar',
  };

  var l58 = {
    code: 'pt',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Anterior',
      next: 'Seguinte',
      today: 'Hoje',
      month: 'M��s',
      week: 'Semana',
      day: 'Dia',
      list: 'Agenda',
    },
    weekText: 'Sem',
    allDayText: 'Todo o dia',
    moreLinkText: 'mais',
    noEventsText: 'N�0�0o h�� eventos para mostrar',
  };

  var l59 = {
    code: 'ro',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'precedent�0�0',
      next: 'urm�0�0toare',
      today: 'Azi',
      month: 'Lun�0�0',
      week: 'S�0�0pt�0�0m�0�9n�0�0',
      day: 'Zi',
      list: 'Agend�0�0',
    },
    weekText: 'S�0�0pt',
    allDayText: 'Toat�0�0 ziua',
    moreLinkText: function(n) {
      return '+alte ' + n
    },
    noEventsText: 'Nu exist�0�0 evenimente de afi�0�2at',
  };

  var l60 = {
    code: 'ru',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '����֧�',
      next: '���ݧ֧�',
      today: '���֧ԧ�էߧ�',
      month: '���֧���',
      week: '���֧է֧ݧ�',
      day: '���֧ߧ�',
      list: '����ӧ֧��ܧ� �էߧ�',
    },
    weekText: '���֧�',
    allDayText: '���֧�� �է֧ߧ�',
    moreLinkText: function(n) {
      return '+ �֧�� ' + n
    },
    noEventsText: '���֧� ���ҧ��ڧ� �էݧ� ����ҧ�ѧا֧ߧڧ�',
  };

  var l61 = {
    code: 'sk',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Predch��dzaj��ci',
      next: 'Nasleduj��ci',
      today: 'Dnes',
      month: 'Mesiac',
      week: 'T�0�5�0�6de��',
      day: 'De��',
      list: 'Rozvrh',
    },
    weekText: 'Ty',
    allDayText: 'Cel�0�5 de��',
    moreLinkText: function(n) {
      return '+�0�2al�0�8ie: ' + n
    },
    noEventsText: '�0�5iadne akcie na zobrazenie',
  };

  var l62 = {
    code: 'sl',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Prej�0�8nji',
      next: 'Naslednji',
      today: 'Trenutni',
      month: 'Mesec',
      week: 'Teden',
      day: 'Dan',
      list: 'Dnevni red',
    },
    weekText: 'Teden',
    allDayText: 'Ves dan',
    moreLinkText: 've�0�0',
    noEventsText: 'Ni dogodkov za prikaz',
  };

  var l63 = {
    code: 'sm',
    buttonText: {
      prev: 'Talu ai',
      next: 'Mulimuli atu',
      today: 'Aso nei',
      month: 'Masina',
      week: 'Vaiaso',
      day: 'Aso',
      list: 'Faasologa',
    },
    weekText: 'Vaiaso',
    allDayText: 'Aso atoa',
    moreLinkText: 'sili atu',
    noEventsText: 'Leai ni mea na tutupu',
  };

  var l64 = {
    code: 'sq',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'mbrapa',
      next: 'P�0�5rpara',
      today: 'sot',
      month: 'Muaj',
      week: 'Jav�0�5',
      day: 'Dit�0�5',
      list: 'List�0�5',
    },
    weekText: 'Ja',
    allDayText: 'Gjith�0�5 dit�0�5n',
    moreLinkText: function(n) {
      return '+m�0�5 tep�0�5r ' + n
    },
    noEventsText: 'Nuk ka evente p�0�5r t�0�5 shfaqur',
  };

  var l65 = {
    code: 'sr-cyrl',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '����֧���էߧ�',
      next: '��ݧ֧էց0�9��',
      today: '���ѧߧѧ�',
      month: '���֧�֧�',
      week: '���֧էց0�7��',
      day: '���ѧ�',
      list: '���ݧѧߧ֧�',
    },
    weekText: '���֧�',
    allDayText: '���֧� �էѧ�',
    moreLinkText: function(n) {
      return '+ �0�6��� ' + n
    },
    noEventsText: '���֧ާ� �է�ԧс0�0�с0�6�� �٧� ���ڧܧѧ�',
  };

  var l66 = {
    code: 'sr',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'Prethodna',
      next: 'Sledec�0�7i',
      today: 'Danas',
      month: 'M��s��c',
      week: 'N��d��lja',
      day: 'Dan',
      list: 'Plan��r',
    },
    weekText: 'Sed',
    allDayText: 'C��o dan',
    moreLinkText: function(n) {
      return '+ jo�0�8 ' + n
    },
    noEventsText: 'N��ma doga�0�4aja za prikaz',
  };

  var l67 = {
    code: 'sv',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'F�0�2rra',
      next: 'N�0�1sta',
      today: 'Idag',
      month: 'M�0�2nad',
      week: 'Vecka',
      day: 'Dag',
      list: 'Program',
    },
    weekText: 'v.',
    allDayText: 'Heldag',
    moreLinkText: 'till',
    noEventsText: 'Inga h�0�1ndelser att visa',
  };

  var l68 = {
    code: 'ta-in',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '�2�4�2�3�2�8�2�5�2�4�2�0�2�5',
      next: '�2�3�2�9�2�3�2�4�2�5�2�4�2�4�2�3',
      today: '�2�5�2�9�2�5�2�7�2�3',
      month: '�2�4�2�0�2�4�2�4�2�5',
      week: '�2�1�2�0�2�6�2�4�2�5',
      day: '�2�8�2�0�2�9�2�5',
      list: '�2�4�2�1�2�9�2�4�2�6�2�1 �2�3�2�9�2�5�2�9�2�1�2�3�2�0',
    },
    weekText: '�2�1�2�0�2�6�2�4�2�5',
    allDayText: '�2�8�2�0�2�9�2�5 �2�4�2�3�2�0�2�3�2�1�2�4�2�3�2�4�2�5',
    moreLinkText: function(n) {
      return '+ �2�4�2�9�2�8�2�3�2�4�2�5 ' + n
    },
    noEventsText: '�2�9�2�0�2�3�2�5�2�0�2�1�2�9�2�5�2�9 �2�8�2�1�2�9�2�0�2�5�2�1�2�3�2�9�2�9�2�5 �2�5�2�8�2�5�2�8�2�0',
  };

  var l69 = {
    code: 'th',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '�2�9�2�0�2�3�2�3�2�1�2�3�2�1�2�8',
      next: '�2�0�2�7�2�8�2�6�2�5',
      prevYear: '�2�5�2�1�2�9�2�0�2�3�2�3�2�1�2�3�2�1�2�8',
      nextYear: '�2�5�2�1�2�0�2�7�2�8�2�6�2�5',
      year: '�2�5�2�1',
      today: '�2�7�2�7�2�3�2�3�2�1�2�1',
      month: '�2�2�2�8�2�3�2�3�2�3',
      week: '�2�0�2�7�2�5�2�8�2�8�2�1�2�4',
      day: '�2�7�2�7�2�3',
      list: '�2�9�2�9�2�1�2�3�2�8�2�9�2�8�2�3',
    },
    weekText: '�2�0�2�7�2�5�2�8�2�8�2�1�2�4',
    allDayText: '�2�9�2�5�2�3�2�8�2�7�2�7�2�3',
    moreLinkText: '�2�2�2�8�2�0�2�0�2�1�2�2�2�9�2�0�2�1',
    noEventsText: '�2�6�2�1�2�0�2�1�2�1�2�9�2�0�2�6�2�9�2�3�2�3�2�1�2�1�2�1�2�0�2�6�2�6�2�3�2�0�2�8�2�5',
  };

  var l70 = {
    code: 'tr',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: 'geri',
      next: 'ileri',
      today: 'bug��n',
      month: 'Ay',
      week: 'Hafta',
      day: 'G��n',
      list: 'Ajanda',
    },
    weekText: 'Hf',
    allDayText: 'T��m g��n',
    moreLinkText: 'daha fazla',
    noEventsText: 'G�0�2sterilecek etkinlik yok',
  };

  var l71 = {
    code: 'ug',
    buttonText: {
      month: '�1�8�1�9�1�4',
      week: '�1�0�1�3�1�6�1�2�1�3',
      day: '�1�7�1�0�1�0',
      list: '�1�7�1�0�1�0�1�2�1�3�1�9�1�2�1�3�1�6',
    },
    allDayText: '�1�6�1�0�1�2�1�0�1�0 �1�7�1�0�1�0',
  };

  var l72 = {
    code: 'uk',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 7, // The week that contains Jan 1st is the first week of the year.
    },
    buttonText: {
      prev: '�����֧�֧է߁0�4��',
      next: '�էѧ݁0�4',
      today: '�����ԧ�է߁0�4',
      month: '���0�4�����',
      week: '���ڧاէ֧ߧ�',
      day: '���֧ߧ�',
      list: '������է�� �է֧ߧߧڧ�',
    },
    weekText: '���ڧ�',
    allDayText: '���ӧ֧�� �է֧ߧ�',
    moreLinkText: function(n) {
      return '+��� ' + n + '...'
    },
    noEventsText: '���֧ާс0�2 ���Ձ0�4�� �էݧ� �Ӂ0�4�է�ҧ�ѧا֧ߧߧ�',
  };

  var l73 = {
    code: 'uz',
    buttonText: {
      month: 'Oy',
      week: 'Xafta',
      day: 'Kun',
      list: 'Kun tartibi',
    },
    allDayText: "Kun bo'yi",
    moreLinkText: function(n) {
      return '+ yana ' + n
    },
    noEventsText: "Ko'rsatish uchun voqealar yo'q",
  };

  var l74 = {
    code: 'vi',
    week: {
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: 'Tr�0�6�6�3c',
      next: 'Ti�6�5p',
      today: 'H�0�0m nay',
      month: 'Th��ng',
      week: 'Tu�0�9�0�6n',
      day: 'Ng��y',
      list: 'L�6�7ch bi�6�9u',
    },
    weekText: 'Tu',
    allDayText: 'C�5�7 ng��y',
    moreLinkText: function(n) {
      return '+ th��m ' + n
    },
    noEventsText: 'Kh�0�0ng c�� s�6�5 ki�6�3n �0�4�6�9 hi�6�9n th�6�7',
  };

  var l75 = {
    code: 'zh-cn',
    week: {
      // GB/T 7408-1994������Ԫ�ͽ�����ʽ����Ϣ���������ں�ʱ���ʾ������ISO 8601:1988��Ч
      dow: 1, // Monday is the first day of the week.
      doy: 4, // The week that contains Jan 4th is the first week of the year.
    },
    buttonText: {
      prev: '����',
      next: '����',
      today: '����',
      month: '��',
      week: '��',
      day: '��',
      list: '�ճ�',
    },
    weekText: '��',
    allDayText: 'ȫ��',
    moreLinkText: function(n) {
      return '���� ' + n + ' ��'
    },
    noEventsText: 'û���¼���ʾ',
  };

  var l76 = {
    code: 'zh-tw',
    buttonText: {
      prev: '����',
      next: '����',
      today: '����',
      month: '��',
      week: '�L',
      day: '��',
      list: '����б�',
    },
    weekText: '��',
    allDayText: '����',
    moreLinkText: '�@ʾ����',
    noEventsText: 'û���κλ��',
  };

  /* eslint max-len: off */

  var localesAll = [
    l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, 
  ];

  return localesAll;

}());
