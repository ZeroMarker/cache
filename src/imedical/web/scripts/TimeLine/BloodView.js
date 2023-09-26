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
var accessURL = "extgetdata.csp";
//周列表ID
var divWeekMenuID = "divWeekMenuList";
//显示周信息的Div的ID
var divWeekID = "divWeek";

var Color = ["#D51616", "#5AAD22"];

Ext.onReady(function() {
    ShowPage();
    ForbidBlowup();
});

//日期格式转换
function formatDateByConfig(datestr){
	if((websys_dateformat==4)&&(datestr.indexOf("-")>-1)){
		var arr=datestr.split("&nbsp");
		arr[0]=arr[0].split("-").reverse().join("/");
		datestr=arr.join("&nbsp");
    }
    return datestr;
}
//显示页面
function ShowPage() {
    var pnlView = new Ext.FormPanel({
        id: 'frmBlood',
        title: '',
        width: (tableWidth+5),
        height: '100%',
        autoScroll: true,
        renderTo: document.body
    });

    ShowTable();
    BuildData(ViewData.DataArray);
    setWeekValue();
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
    //patientHtml += '<tr class="csTrPatientContent"><td style="width:45px;padding-left:10px;font-weight:bold;">姓名：</td><td style="width:80px;text-align:left;">' + PatientInfor.name + '</td><td style="width:45px;font-weight:bold;">年龄：</td><td style="width:45px;">' + PatientInfor.age + '</td><td style="width:70px;font-weight:bold;">入院时间：</td><td style="width:100px;">' + PatientInfor.hospitalizedDate + '</td><td style="width:45px;font-weight:bold;">科室：</td><td style="width:100px;">' + PatientInfor.office + '</td><td style="width:45px;font-weight:bold;">医生：</td><td style="width:80px;">' + PatientInfor.doctor + '</td><td style="width:5px;"><img style="cursor:hand;" src="../../images/TimeLine/leftMove .gif" onclick="MoveLeftRecord();" align="left"/></td><td><div id="divSeeDoctor" class="csSeeDoctor"><table class="csTbSeeDoctor" border="0" cellpadding="0" cellspacing="0"><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></table></div></td><td style="width:5px;"><img style="cursor:hand;" src="../../images/TimeLine/rightMove.gif" onclick="MoveRightRecord();" align="left"/></td><td style="width:5px;"><td></tr>';
    //patientHtml += '</table>';
    var headerHtml = '<table id="tbHeaderDate" class ="csTbHeader" border="0" cellpadding="0" cellspacing="1" style="width:' + tableWidth + 'px;" ><tr class="csTrDate">';
    headerHtml += '<td style="width:' + DateWidth + 'px;vertical-align:middle;background-image:url(\'../../images/TimeLine/date_bg.gif\');"><table style="width:100%;height:100%;"><tr><td style="background-color:Transparent;"><img id="imgLastWeek" style="cursor:hand;" src="../../images/TimeLine/Week-prev.gif" onclick="LastWeek();" align="left"/></td><td style="background-color:Transparent;"><img id="imgLastDate" style="cursor:hand;" src="../../images/TimeLine/Date-prev.gif" onclick="LastDate();" align="left"/></td><td style="background-color:Transparent;vertical-align:middle;">第</td><td style="background-color:Transparent;"><div id="' + divWeekID + '" class="csDivWeek" onclick="ShowWeeks();" >1</div></td><td style="background-color:Transparent;vertical-align:middle;">周</td><td style="background-color:Transparent;"><img id="imgNextDate" style="cursor:hand;" src="../../images/TimeLine/Date-next.gif" onclick="NextDate();" align="right"/></td><td style="background-color:Transparent;"><img id="imgNextWeek" style="cursor:hand;" src="../../images/TimeLine/Week-next.gif" onclick="NextWeek();" align="right"/></td></tr></table></td>';
    var dtArr = queryDate.split("-");
    var dtSelect = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    DateValues = getDates(dtSelect);
    var count = DateValues.length;
    for (var index = 0; index < count; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index]);
        weekDate=formatDateByConfig(weekDate);
        headerHtml += CreateTd(weekDate);
    }
    headerHtml += '</tr><tr class="csTrTime">';
    headerHtml += '<td style="width:' + DateWidth + 'px;font-weight:bold;" >时间</td>'
    var timeGridHtml = CreateTimeGrid();
    for (var index = 0; index < count; index++) {
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
            var xPercent = divChart.offsetWidth / (cellCount * 24);
            var chartHeight = divChart.offsetHeight;
            
            //var pointStyle = GetPointStyle(oneData.DataTypeCode);
            
            for (var index = 0; index < count; index++) {
                var oneData = dataArray[index];
                xData.push(GetTimeValue(oneData.ActDate, oneData.ActTime));
                
                var highPressure = oneData.DataValue.split("/")[0];
                var lowPressure = oneData.DataValue.split("/")[1];

                yData.push(highPressure);
                yData2.push(lowPressure);
            }

            var config1 = { height: chartHeight, maxHeight: yMaxValue, startHeight: ySartValue, barDistance: xPercent, leftDistance: 0, pointColor: Color[0], lineColor: Color[0], valueColor: Color[0], containerX: DateWidth, pointCss: "" };
            var data1 = new period(yData, xData);
            new gov.Graphic(data1, divChart.id, config1);

            var config2 = { height: chartHeight, maxHeight: yMaxValue, startHeight: ySartValue, barDistance: xPercent, leftDistance: 0, pointColor: Color[1], lineColor: Color[1], valueColor: Color[1], containerX: DateWidth, pointCss: "" };
            var data2 = new period(yData2, xData);
            new gov.Graphic(data2, divChart.id, config2);
        }
    }
}

//创建时间的表格
function CreateTimeGrid() {
    var timeCount = 24 / TimeSplit;
    var timeGridHtml = '<table class="csTbTime" border="0" cellpadding="0" cellspacing="0" ><tr>';
    var txtTime = 0;
    var tdTimeWidth = DateWidth / timeCount;
    for (var index = 1; index < timeCount + 1; index++) {
        txtTime = index * TimeSplit;
        if (index == timeCount) {
            timeGridHtml += '<td style="width:' + tdTimeWidth + 'px;">' + txtTime + '</td>';
        }
        else {
            timeGridHtml += '<td class="csTdTime" style="width:' + tdTimeWidth + 'px;" >' + txtTime + '</td>';
        }
    }
    timeGridHtml += "</tr></table>";
    return timeGridHtml;
}

//取得日期
function getDates(selectDate) {
    var date = [];
    date.push(formatDate(selectDate));

    for (var i = 1; i < cellCount; i++) {
        var datevalue = selectDate.getDate();
        selectDate.setDate(parseInt(datevalue, 10) + 1);
        date.push(formatDate(selectDate));
    }
    return date;
}

//创建TD
function CreateTd(txt) {
    return '<td style="width:' + (DateWidth) + 'px;" >' + txt + '</td>';
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
        document.getElementById("imgNextDate").src = "../../images/TimeLine/Date-next-disabled.gif";
        document.getElementById("imgNextWeek").disabled = true;
        document.getElementById("imgNextWeek").src = "../../images/TimeLine/Week-next-disabled.gif";
    }
    else {
        document.getElementById("imgNextDate").disabled = false;
        document.getElementById("imgNextDate").src = "../../images/TimeLine/Date-next.gif";
        document.getElementById("imgNextWeek").disabled = false;
        document.getElementById("imgNextWeek").src = "../../images/TimeLine/Week-next.gif";
    }
    if (minDate <= starDate) {
        document.getElementById("imgLastWeek").disabled = true;
        document.getElementById("imgLastWeek").src = "../../images/TimeLine/Week-prev-disabled.gif";
        document.getElementById("imgLastDate").disabled = true;
        document.getElementById("imgLastDate").src = "../../images/TimeLine/Date-prev-disabled.gif";
    }
    else {
        document.getElementById("imgLastWeek").disabled = false;
        document.getElementById("imgLastWeek").src = "../../images/TimeLine/Week-prev.gif";
        document.getElementById("imgLastDate").disabled = false;
        document.getElementById("imgLastDate").src = "../../images/TimeLine/Date-prev.gif";
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
    var dtArr = DateValues[0].split("-");
    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtLast.setDate(parseInt(dtArr[2], 10) - 7);
    var startDate = GetStartDate()
    if (dtLast < startDate) {
        dtLast = startDate;
    }
    DateValues = getDates(dtLast);
    var queryDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
    SubmitForm("frmBlood", actionParams);
}


//日期向后移动一周
function NextWeek() {
    var dtArr = DateValues[0].split("-");
    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtNext.setDate(parseInt(dtArr[2], 10) + 7);
    var endDate = GetEndDate();
    endDate.setDate(parseInt(endDate.getDate(), 10) - 6);
    if (dtNext > endDate) {
        dtNext = endDate;
    }
    DateValues = getDates(dtNext);
    var queryDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
    SubmitForm("frmBlood", actionParams);
}

//日期向前移动一天
function LastDate() {
    var dtArr = DateValues[0].split("-");
    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtLast.setDate(parseInt(dtArr[2], 10) - 1);
    DateValues = getDates(dtLast);
    var queryDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
    SubmitForm("frmBlood", actionParams);
}

//日期向后移动一天
function NextDate() {
    var dtArr = DateValues[0].split("-");
    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtNext.setDate(parseInt(dtArr[2], 10) + 1);
    DateValues = getDates(dtNext);
    var queryDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': queryDate };
    SubmitForm("frmBlood", actionParams);
}

//清除页面中的数据
function ClearRecord() {
    var tbDate = document.getElementById("tbHeaderDate");
    var count = DateValues.length;
    for (var index = 1; index < count + 1; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index - 1]);
        weekDate=formatDateByConfig(weekDate);
        tbDate.rows[0].cells[index].innerHTML = weekDate;
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

//显示就诊周列表
function ShowWeeks() {
    if (ViewData) {
        var startDate = GetStartDate();
        var endDate = GetEndDate();
        if (startDate != null && endDate != null) {
            var days = parseInt(Math.abs(endDate - startDate) / 1000 / 60 / 60 / 24, 10);
            var weeks = parseInt(days / 7, 10);
            if (days % 7 > 0) {
                weeks = weeks + 1;
            }
            if (weeks < 2) {
                return;
            }
            var divWeekMenu = document.createElement("div");
            divWeekMenu.id = divWeekMenuID;
            var menuHtml = "<ul>";
            for (var index = 1; index <= weeks; index++) {
                menuHtml = menuHtml + "<li class='csMenuItem' onclick='ChangeWeek()' onmouseover='SetMenuStyle(1);' onmouseout='SetMenuStyle(0);'>" + index + "</li>";
            }
            enuHtml = menuHtml + "</ul>";
            divWeekMenu.className = "csWeekMenu";
            divWeekMenu.style.top = (findPosY(event.srcElement) + 20) + "px"; ;
            divWeekMenu.style.left = findPosX(event.srcElement) + "px";
            if (weeks > 10) {
                divWeekMenu.style.height = "200px";
                divWeekMenu.style.width = "55px";
            }
            divWeekMenu.innerHTML = menuHtml;
            document.body.appendChild(divWeekMenu);
        }
    }
}

//当鼠标靠近或离开时，设定周列表的样式
function SetMenuStyle(mouseFlg) {
    if (mouseFlg == "0") {
        event.srcElement.className = "csMenuItem";
    }
    else {
        event.srcElement.className = "csMenuMouseOut";
    }
}

//切换周
function ChangeWeek() {
    var selectWeek = parseInt(event.srcElement.innerText, 10);
    var nowWeek = parseInt(document.getElementById(divWeekID).innerText, 10);
    var divWeekMenu = document.getElementById(divWeekMenuID);
    if (divWeekMenu) {
        divWeekMenu.parentElement.removeChild(divWeekMenu);
    }
    if (selectWeek != nowWeek) {
        document.getElementById(divWeekID).innerText = selectWeek;
        var searchDate = "";
        if (selectWeek == 1) {
            searchDate = ConvertToDateValue(ViewData.StartDate);
        }
        else {
            var days = (selectWeek - 1) * 7;
            searchDate = GetStartDate();
            searchDate.setDate(parseInt(searchDate.getDate(), 10) + days);
        }
        var endDate = GetEndDate();
        endDate.setDate(parseInt(endDate.getDate(), 10) - 6);
        if (searchDate > endDate) {
            searchDate = endDate;
        }
        DateValues = getDates(searchDate);
        searchDate = DateValues[0];
        var actionParams = { 'dataTypeCode': DataTypeCode, 'episodeId': episodeId, 'startDate': searchDate };
        SubmitForm("frmBlood", actionParams);
    }
}

//隐藏菜单
function HiddenMenu() {
    if (event.srcElement.id != divWeekID) {
        var divWeekMenu = document.getElementById(divWeekMenuID);
        if (divWeekMenu) {
            divWeekMenu.parentElement.removeChild(divWeekMenu);
        }
    }
}

//设定当前数据是第几周
function setWeekValue() {
    var startDate = GetStartDate();
    var searchDate = ConvertToDateValue(DateValues[6]);
    if (startDate != null && searchDate != null) {
        var days = parseInt(Math.abs(searchDate - startDate) / 1000 / 60 / 60 / 24, 10);
        var weeks = parseInt(days / 7, 10);
        if (days % 7 > 0) {
            weeks = weeks + 1;
        }
        document.getElementById(divWeekID).innerText = weeks;
    }
}