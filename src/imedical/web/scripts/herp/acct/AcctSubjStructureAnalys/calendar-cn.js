
Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];
Date.monthNames=["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"];
if (Ext.DatePicker) {
    Ext.apply(Ext.DatePicker.prototype, {
        todayText: "����",
        minText: "��������С����֮ǰ",
        maxText: "�������������֮��",
        disabledDaysText: "",
        disabledDatesText: "",
        monthNames: Date.monthNames,
        dayNames: Date.dayNames,
        nextText: '���� (Control+Right)',
        prevText: '���� (Control+Left)',
        monthYearText: 'ѡ��һ���� (Control+Up/Down ���ı���)',
        todayTip: "{0} (Spacebar)",
        okText: "ȷ��",
        cancelText: "ȡ��",
        format: "y��m��d��"
    });
}