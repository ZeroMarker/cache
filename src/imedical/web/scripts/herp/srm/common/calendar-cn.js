
Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];
Date.monthNames=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];
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