
Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];
// Date.monthNames=["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
Date.monthNames=["01","02","03","04","05","06","07","08","09","10","11","12"];
if (Ext.DatePicker) {
    Ext.apply(Ext.DatePicker.prototype, {
        todayText: "今天",
        minText: "日期在最小日期之前",
        maxText: "日期在最大日期之后",
        disabledDaysText: "",
        disabledDatesText: "",
        monthNames: Date.monthNames,
        dayNames: Date.dayNames,
        nextText: '下月 (Control+Right)',
        prevText: '上月 (Control+Left)',
        monthYearText: '选择一个月 (Control+Up/Down 来改变年)',
        todayTip: "{0} (Spacebar)",
        okText: "确定",
        cancelText: "取消",
        format: "y年m月d日"
    });
}