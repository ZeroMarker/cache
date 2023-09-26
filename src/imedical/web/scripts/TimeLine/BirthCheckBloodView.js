//显示的单元格数
var cellCount = 7;
//每个日期对应的单元格的宽度
var DateWidth = 144;
//每一天按几小时分成一个时间段
var TimeSplit = 4;
//每个信息项表的宽度
var tableWidth = DateWidth * (cellCount + 1) + cellCount;
//显示的日期值
var DateValues = null;
//显示的产周的值
var WeekValues = null;
var accessURL = "extgetbirthcheckdata.csp";

var Color = ["#D51616", "#5AAD22"];
Ext.onReady(function() {
    ShowPage();
    //禁止网页放大
    if (document.addEventListener) {
        document.addEventListener('DOMMouseScroll', scrollFunc, false);
    }
    window.onmousewheel = document.onmousewheel = scrollFunc;
});

//禁止网页放大
var scrollFunc = function(e) {
    e = e || window.event;
    if (e.wheelDelta && event.ctrlKey) {//IE/Opera/Chrome  
        event.returnValue = false;
    } else if (e.detail) {//Firefox  
        event.returnValue = false;
    }
}

//显示页面
function ShowPage() {
    var pnlView = new Ext.FormPanel({
        id: 'frmBlood',
        title: '',
        width: (tableWidth + 5),
        height: '100%',
        autoScroll: true,
        renderTo: document.body
    });
    ShowTable();
    BuildData(ViewData.DataArray);
}

//根据模板显示信息
function ShowTable() {
    var frmView = Ext.getCmp("frmBlood");
    var viewHtml = GetHeader();
    if (DataTypeCode == "0306") {
        viewHtml += GetBooldViewHtml();
    }
    var tpl = new Ext.XTemplate(viewHtml, {
        // XTemplate configuration:
        compiled: true,
        disableFormats: true
        // member functions:
    });

    tpl.overwrite(frmView.body);
    frmView.body.dom.style.backgroundColor = "#DFE8F6";
}

//设定头部
function GetHeader() {
    //var patientHtml = '<table id="tbPatient" class ="csTbPatient" border="0" cellpadding="0" cellspacing="0" style="width:' + (tableWidth + (cellCount - 3)) + 'px;" >';
    //patientHtml += '<tr class="csTrPatientContent"><td style="width:45px;padding-left:10px;font-weight:bold;">姓名：</td><td style="width:80px;text-align:left;">' + PatientInfor.name + '</td><td style="width:45px;font-weight:bold;">年龄：</td><td style="width:45px;">' + PatientInfor.age + '</td><td style="width:70px;font-weight:bold;">入院时间：</td><td style="width:100px;">' + PatientInfor.hospitalizedDate + '</td><td style="width:45px;font-weight:bold;">科室：</td><td style="width:100px;">' + PatientInfor.office + '</td><td style="width:45px;font-weight:bold;">医生：</td><td style="width:80px;">' + PatientInfor.doctor + '</td><td style="width:5px;"><img style="cursor:hand;" src="images/leftMove .gif" onclick="MoveLeftRecord();" align="left"/></td><td><div id="divSeeDoctor" class="csSeeDoctor"><table class="csTbSeeDoctor" border="0" cellpadding="0" cellspacing="0"><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></table></div></td><td style="width:5px;"><img style="cursor:hand;" src="images/rightMove.gif" onclick="MoveRightRecord();" align="left"/></td><td style="width:5px;"><td></tr>';
    //patientHtml += '</table>';
    var headerHtml = '<table id="tbHeaderDate" class ="csTbHeader" border="0" cellpadding="0" cellspacing="1" style="width:' + tableWidth + 'px;" ><tr class="csTrDate">';
    headerHtml += '<td style="width:' + DateWidth + 'px;vertical-align:middle;background-image:url(\'images/date_bg.gif\');"><table style="width:100%;height:100%;"><tr><td style="background-color:Transparent;"><img id="imgLastWeek" style="cursor:hand;" src="images/Week-prev.gif" onclick="LastWeek();" align="left"/></td><td style="background-color:Transparent;"><img id="imgLastDate" style="cursor:hand;" src="images/Date-prev.gif" onclick="LastDate();" align="left"/></td><td style="background-color:Transparent;">日期</td><td style="background-color:Transparent;"><img id="imgNextDate" style="cursor:hand;" src="images/Date-next.gif" onclick="NextDate();" align="right"/></td><td style="background-color:Transparent;"><img id="imgNextWeek" style="cursor:hand;" src="images/Week-next.gif" onclick="NextWeek();" align="right"/></td></tr></table></td>';

    DateValues = getDates();
    var count = DateValues.length;
    for (var index = 0; index < count; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index]);
        headerHtml += CreateTd(weekDate);
    }
    headerHtml += '</tr><tr class="csTrTime">';
    headerHtml += '<td style="width:' + DateWidth + 'px;font-weight:bold;" >孕周</td>'
    //var timeGridHtml = CreateTimeGrid();
    WeekValues = getBirthWeek();
    for (var index = 0; index < count; index++) {
        var timeGridHtml = WeekValues[index];
        headerHtml += CreateTd(timeGridHtml);
    }
    headerHtml += '</tr></table>';
    return headerHtml;
}

//取得显示血压的Html
function GetBooldViewHtml() {
    var dataTypeText = "血压";
    var headTable = '<table border="0" cellpadding="0" cellspacing="0" class="csSpecilTable" style="width:' + (DateWidth - 12) + 'px;">';
    var th = "<tr>";
    var td1 = "<tr>";
    var td2 = "<tr>";
    var td3 = "<tr>";
    var td4 = "<tr>";
    var td5 = "<tr>";
    var td6 = "<tr>";

    th += '<td style="color:#0F5988;">' + dataTypeText + "</td>";
    td1 += '<td style="color:#0F5988;">160</td>';
    td2 += '<td style="color:#0F5988;">140</td>';
    td3 += '<td style="color:#0F5988;">120</td>';
    td4 += '<td style="color:#0F5988;">100</td>';
    td5 += '<td style="color:#0F5988;">80</td>';
    td6 += '<td style="color:#0F5988;">60</td>';

    th += "</tr>";
    td1 += "</tr>";
    td2 += "</tr>";
    td3 += "</tr>";
    td4 += "</tr>";
    td5 += "</tr>";
    td6 += "</tr>";
    headTable += th + td1 + td2 + td3 + td4 + td5 + td6 + "</table>"

    var bloodHtml = '<table id="tbBlood" class="csTbInforItem" border="0" cellpadding="0" cellspacing="1"  style="width:' + (tableWidth) + 'px;" >';
    bloodHtml += '<tr class="trInforItemShow"><td style="width:' + DateWidth + 'px;" ><table style="width:100%;" border="0" cellpadding="0" cellspacing="0" ><tr><td style="text-align:left;vertical-align:top;width:12px;"></td><td style="font-weight:bold;text-align:center;vertical-align:top;">' + headTable + '</td></tr></table></td>';
    bloodHtml += CreateChartTd();
    bloodHtml += "</tr></table>";
    return bloodHtml;
}

//创建显示趋势图的TD
function CreateChartTd() {
    var tdsHtml = '<td colspan="' + cellCount + '" style="width:' + (DateWidth * cellCount) + 'px;">';
    tdsHtml += '<div id="divChart' + DataTypeCode + '" class="csChartDiv"></div>';
    tdsHtml += "</td>";
    return tdsHtml;
}


//将需要显示的数据添加到页面中
function BuildData(dataArray) {
    SetButtonState();
    var divChartId = "divChart" + DataTypeCode;
    var divChart = Ext.getDom(divChartId);
    var yData = [];
    var xData = [];
    if (divChart) {
        var count = dataArray.length;
        if (DataTypeCode == "0306") {
            var yData2 = [];
            var yMaxValue = GetYMaxValue();
            var ySartValue = GetYSartValue();
            var xPercent = divChart.offsetWidth / cellCount;
            var chartHeight = divChart.offsetHeight;
            var startPosition = DateWidth / 2;
            //var pointStyle = GetPointStyle(oneData.DataTypeCode);
            
            for (var index = 0; index < count; index++) {
                var oneData = dataArray[index];
                //xData.push(GetTimeValue(oneData.ActDate, oneData.ActTime));
                xData.push(GetDisplayTdIndex(oneData.ActDate));
                
                var highPressure = oneData.DataValue.split("/")[0];
                var lowPressure = oneData.DataValue.split("/")[1];

                yData.push(highPressure);
                yData2.push(lowPressure);
            }

            var config1 = { height: chartHeight, maxHeight: yMaxValue, startHeight: ySartValue, barDistance: xPercent, leftDistance: 0, pointColor: Color[0], lineColor: Color[0], valueColor: Color[0], containerX: DateWidth, pointCss: "",startX:startPosition };
            var data1 = new period(yData, xData);
            new gov.Graphic(data1, divChart.id, config1);

            var config2 = { height: chartHeight, maxHeight: yMaxValue, startHeight: ySartValue, barDistance: xPercent, leftDistance: 0, pointColor: Color[1], lineColor: Color[1], valueColor: Color[1], containerX: DateWidth, pointCss: "",startX:startPosition };
            var data2 = new period(yData2, xData);
            new gov.Graphic(data2, divChart.id, config2);
        }
    }
}

//取得显示数据的TD的索引
function GetDisplayTdIndex(date) {
    for (var index = 0; index < DateValues.length; index++) {
        if (date == DateValues[index]) {
            return index;
        }
    }
    return -1;
}

//取得日期和周几
function GetDateAndWeekDay(dateTxt) {
    var dtArr = dateTxt.split("-");
    var dt = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    var weekDay = dt.getDay();
    var weekDayTxt = "";
    switch (weekDay) {
        case 0: weekDayTxt = "(日)"; break;
        case 1: weekDayTxt = "(一)"; break;
        case 2: weekDayTxt = "(二)"; break;
        case 3: weekDayTxt = "(三)"; break;
        case 4: weekDayTxt = "(四)"; break;
        case 5: weekDayTxt = "(五)"; break;
        case 6: weekDayTxt = "(六)"; break;
    }

    return dateTxt + "&nbsp" + weekDayTxt;
}

//创建TD
function CreateTd(txt) {
    return '<td style="width:' + (DateWidth) + 'px;" >' + txt + '</td>';
}

//格式化日期
function formatDate(d) {
    var _todayDate = d.getDate();
    var _year = d.getYear();
    var _month = d.getMonth() + 1;
    if ((_month + "").length < 2) {
        _month = "0" + _month;
    }
    if ((_todayDate + "").length < 2) {
        _todayDate = "0" + _todayDate;
    }
    return _year + "-" + _month + "-" + _todayDate;
}

//设定日期移动按钮的状态
function SetButtonState() {
    var starDate = GetStartDate();
    var endDate = GetEndDate();
    var dtMaxArry = DateValues[DateValues.length - 1].split("-");
    var dtMinArry = DateValues[0].split("-");
    var maxDate = new Date(dtMaxArry[0], parseInt(dtMaxArry[1], 10) - 1, dtMaxArry[2]);
    var minDate = new Date(dtMinArry[0], parseInt(dtMinArry[1], 10) - 1, dtMinArry[2]);
    if (maxDate >= endDate) {
        document.getElementById("imgNextDate").disabled = true;
        document.getElementById("imgNextDate").src = "images/Date-next-disabled.gif";
        document.getElementById("imgNextWeek").disabled = true;
        document.getElementById("imgNextWeek").src = "images/Week-next-disabled.gif";
    }
    else {
        document.getElementById("imgNextDate").disabled = false;
        document.getElementById("imgNextDate").src = "images/Date-next.gif";
        document.getElementById("imgNextWeek").disabled = false;
        document.getElementById("imgNextWeek").src = "images/Week-next.gif";
    }
    if (minDate <= starDate) {
        document.getElementById("imgLastWeek").disabled = true;
        document.getElementById("imgLastWeek").src = "images/Week-prev-disabled.gif";
        document.getElementById("imgLastDate").disabled = true;
        document.getElementById("imgLastDate").src = "images/Date-prev-disabled.gif";
    }
    else {
        document.getElementById("imgLastWeek").disabled = false;
        document.getElementById("imgLastWeek").src = "images/Week-prev.gif";
        document.getElementById("imgLastDate").disabled = false;
        document.getElementById("imgLastDate").src = "images/Date-prev.gif";
    }
}

//取得就诊起始日
function GetStartDate() {
    var startDateArry = ViewData.StartDate.split("-");
    var starDate = new Date(startDateArry[0], parseInt(startDateArry[1], 10) - 1, startDateArry[2]);
    return starDate;
}

//取得就诊结束日
function GetEndDate() {
    var endDateArry = ViewData.EndDate.split("-");
    var endDate = new Date(endDateArry[0], parseInt(endDateArry[1], 10) - 1, endDateArry[2]);
    return endDate;
}

//取得Y轴最大值
function GetYMaxValue(code) {
    if (DataTypeCode == "0306") {
        return 170;
    }
    return null;
}

//取得Y轴起始值
function GetYSartValue(code) {
    if (DataTypeCode == "0306") {
        return 50;
    }
    return null;
}

//取得x轴时间值
function GetTimeValue(dateValue, timeValue) {
    var dtArr = dateValue.split("-");
    var dt = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    var dtMinArr = DateValues[0].split("-");
    var dtMin = new Date(dtMinArr[0], parseInt(dtMinArr[1], 10) - 1, dtMinArr[2]);
    var hour = 0;
    if (timeValue) {
        hour = parseInt(timeValue.split(":")[0], 10);
    }
    else {
        hour = 12;
    }
    var xValue = parseInt((dt.getTime() - dtMin.getTime()) / parseInt(1000 * 3600, 10), 10) + hour;
    return xValue;
}

//日期向前移动一周
function LastWeek() {
//    var dtArr = DateValues[0].split("-");
//    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    dtLast.setDate(parseInt(dtArr[2], 10) - 7);
//    var startDate = GetStartDate()
//    if (dtLast < startDate) {
//        dtLast = startDate;
//    }
//    DateValues = getDates(dtLast);
//    var queryDate = DateValues[0];
//    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
//    SubmitForm("frmBlood", actionParams);

    var count = ViewData.lastDisplayDate.length;
    if (count > 0) {
        var searchDate = ViewData.lastDisplayDate[count - 1]
        var actionParams = { 'dataTypeCode': DataTypeCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("frmBlood", actionParams);
    }
}

//日期向后移动一周
function NextWeek() {
//    var dtArr = DateValues[0].split("-");
//    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    dtNext.setDate(parseInt(dtArr[2], 10) + 7);
//    var endDate = GetEndDate();
//    endDate.setDate(parseInt(endDate.getDate(), 10) - 6);
//    if (dtNext > endDate) {
//        dtNext = endDate;
//    }
//    DateValues = getDates(dtNext);
//    var queryDate = DateValues[0];
//    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
//    SubmitForm("frmBlood", actionParams);



    var dtArr = DateValues[cellCount - 1].split("-");
    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtNext.setDate(parseInt(dtArr[2], 10) + 1);
    var endDate = GetEndDate();
    //    endDate.setDate(parseInt(endDate.getDate(), 10) - 6);
    //    if (dtNext > endDate) {
    //        dtNext = endDate;
    //    }
    //    DateValues = getDates(dtNext);
    if (dtNext <= endDate) {
        var searchDate = dtNext;
        var actionParams = { 'dataTypeCode': DataTypeCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("frmBlood", actionParams);
    }
}

//日期向前移动一天
function LastDate() {
//    var dtArr = DateValues[0].split("-");
//    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    dtLast.setDate(parseInt(dtArr[2], 10) - 1);
//    DateValues = getDates(dtLast);
//    var queryDate = DateValues[0];
//    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
//    SubmitForm("frmBlood", actionParams);

    var count = ViewData.lastDisplayDate.length;
    if (count > 0) {
        var searchDate = ViewData.lastDisplayDate[0]
        var actionParams = { 'dataTypeCode': DataTypeCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("frmBlood", actionParams);
    }
}

//日期向后移动一天
function NextDate() {
//    var dtArr = DateValues[0].split("-");
//    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    dtNext.setDate(parseInt(dtArr[2], 10) + 1);
//    DateValues = getDates(dtNext);
//    var queryDate = DateValues[0];
//    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
//    SubmitForm("frmBlood", actionParams);

    if (ViewData.displayDate.length > 1) {
        var searchDate = ViewData.displayDate[1]
        var actionParams = { 'dataTypeCode': DataTypeCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("frmBlood", actionParams);
    }
}

//清除页面中的数据
function ClearRecord() {
    var tbDate = document.getElementById("tbHeaderDate");
    var count = DateValues.length;
    for (var index = 1; index < count + 1; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index - 1]);
        tbDate.rows[0].cells[index].innerHTML = weekDate;
        tbDate.rows[1].cells[index].innerHTML = WeekValues[index - 1];
    }

    var divChartArray = Ext.select('div[class =csChartDiv]').elements;
    var Count = divChartArray.length;
    for (var num = 0; num < Count; num++) {
        divChartArray[num].innerHTML = "";
     }
}

//获取数据
function SubmitForm(frmName, actionParams) {
    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在获取数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            ViewData.displayDate = action.result.displayDate;
            ViewData.lastDisplayDate = action.result.lastDisplayDate;
            DateValues = getDates();
            WeekValues = getBirthWeek();
            ClearRecord();
            ViewData.DataArray = action.result.DataArray;
            ViewData.EndDate = action.result.EndDate;
            ViewData.StartDate = action.result.StartDate;
            BuildData(ViewData.DataArray);
        },
        failure: function(form, action) {
            Ext.MessageBox.show({
                title: "错误信息",
                msg: "获取数据失败",
                width: 400,
                buttons: Ext.MessageBox.OK,
                icon: Ext.MessageBox.ERROR
            });
        }
    });
}

//取得日期
function getDates() {
    //    var date = [];
    //    date.push(formatDate(selectDate));

    //    for (var i = 1; i < cellCount; i++) {
    //        var datevalue = selectDate.getDate();
    //        selectDate.setDate(parseInt(datevalue, 10) + 1);
    //        date.push(formatDate(selectDate));
    //    }
    //    return date;
    var date = [];
    var displayDateInfor = ViewData.displayDate;
    var oneDate = new Date();
    for (var i = 0; i < cellCount; i++) {
        if (i < displayDateInfor.length) {
            var dtArr = displayDateInfor[i].split("|")[0].split("-");
            oneDate = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
            date.push(formatDate(oneDate));
        }
        else {
            oneDate.setDate(parseInt(oneDate.getDate(), 10) + 1);
            date.push(formatDate(oneDate));
        }
    }
    return date;
}

//取得产周
function getBirthWeek() {
    var weeks = [];
    var displayDateInfor = ViewData.displayDate;
    //var oneDate = new Date();
    for (var i = 0; i < cellCount; i++) {
        if (i < displayDateInfor.length) {
            //var dtArr = displayDateInfor[i].split("|")[1].split("-");
            //oneDate = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
            //date.push(formatDate(oneDate));
            var weekInfor = "第" + displayDateInfor[i].split("|")[1] + "周";
            weeks.push(weekInfor);
        }
        else {
            //oneDate.setDate(parseInt(oneDate.getDate(), 10) + 1);
            //date.push(formatDate(oneDate));
            var weekInfor = "无数据";
            weeks.push(weekInfor);
        }
    }
    return weeks;
}
