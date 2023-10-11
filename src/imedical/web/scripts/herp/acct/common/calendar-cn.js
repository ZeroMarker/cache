
Date.dayNames = ["��", "һ", "��", "��", "��", "��", "��"];
// Date.monthNames=["һ��","����","����","����","����","����","����","����","����","ʮ��","ʮһ��","ʮ����"];
Date.monthNames=["01","02","03","04","05","06","07","08","09","10","11","12"];
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