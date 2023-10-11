FullCalendar.globalLocales.push(function () {
  'use strict';

  var zhCn = {
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

  return zhCn;

}());
