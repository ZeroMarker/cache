//显示的单元格数
var cellCount =7;
//每个日期对应的单元格的宽度
var DateWidth = 144;
//每一天按几小时分成一个时间段
var TimeSplit = 4;
//每个信息项表的宽度
var tableWidth = DateWidth * (cellCount+1) + cellCount;
//显示的日期值
var DateValues = null;
//显示的产周的值
var WeekValues = null;
//特殊方式显示的数据类型代码
var SpecialDataTypeCode = null;
//是否有特殊显示的数据
var haveSpecialDisplay = false;
//弹出的div显示框的Id
var divInforID = "divInfor";
var Color = ["#ff9900", "#cc0000","#0f77e2", "#5AAD22"];
var LineColor = ["#0b3281", "#db6a0f", "#cc0000", "#5AAD22"];
//点的样式
var PointCSS = ["csPointTriangle", "csPointCircle", "csPointCross"];
//ajax访问的地址
var accessURL = "TimeLine/extgetbirthcheckdata.csp";
//当前选中的就诊记录的索引
var SeeDocIndex = 0;
//每行显示的文本的最多字数
var txtLength = 10;
//行头的背景颜色
var rowHeaderColor = "#ddeef8;color:#132456";
var cellColor = "#C3D1F4";

//页面加载完毕，开始执行
Ext.onReady(function() {
    ShowPage();
    //禁止网页放大
    if (document.addEventListener) {
        document.addEventListener('DOMMouseScroll', scrollFunc, false);
    }
    window.onmousewheel = document.onmousewheel = scrollFunc;
    window.onresize = changPanelSize;
});

//窗体调整大小时触发的事件
function changPanelSize() {
    var pnlHeight = parent.document.frames[0].frameElement.offsetHeight - document.getElementById("divHeader").offsetHeight;
    var pnlWidth = document.getElementById("divHeader").scrollWidth;
    var pnlWidth = document.getElementById("divHeader").scrollWidth;
    if (pnlWidth > parent.document.frames[0].frameElement.offsetWidth) {
        pnlWidth = pnlWidth + 16;
        pnlHeight = pnlHeight - 17;
    }
    var pnlView = Ext.getCmp("pnlView");
    pnlView.setHeight(pnlHeight);
    pnlView.setWidth(pnlWidth);
}

//禁止网页放大
var scrollFunc = function(e) {
    e = e || window.event;
    //IE/Opera/Chrome  
    if (e.wheelDelta && event.ctrlKey) {
        event.returnValue = false;
    } else if (e.detail) {
        //Firefox  
        event.returnValue = false;
    }
}

//显示页面
function ShowPage() {
    var HeaderHtml = GetHeader();
    document.getElementById("divHeader").innerHTML = HeaderHtml;
    var pnlHeight = parent.document.frames[0].frameElement.offsetHeight - document.getElementById("divHeader").offsetHeight;
    var pnlWidth = document.getElementById("divHeader").scrollWidth;
    if (pnlWidth > parent.document.frames[0].frameElement.offsetWidth) {
        pnlWidth = pnlWidth + 16;
        pnlHeight = pnlHeight - 17;
    }
    var pnlView = new Ext.FormPanel({
        id: 'pnlView',
        title: '',
//      width: (tableWidth+6),
        //      height: '100%',
        //baseCls:'',
        bodyBorder: false,
        border:false,
        width: pnlWidth,
        height: pnlHeight,
        autoScroll:true,
        renderTo: document.body
        });

        ShowItem();
        Ext.select('tr[class =trInforItemHidden]').setStyle('display', 'none');
        BuildData(ClinicalData.DataArray);
        ShowPatientInfor(ClinicalData.PatientInfo);
        //ShowSeeDoctorRecord(SeeDocIndex);
        Ext.select('tr[class =trInforItemHidden]').setStyle('display', 'none');
    }

//根据模板显示信息
    function ShowItem() {
    var pnlView = Ext.getCmp("pnlView");
    var viewHtml = CreateItemInfor();
    var tpl = new Ext.XTemplate(viewHtml, {
        // XTemplate configuration:
        compiled: true,
        disableFormats: true,
        // member functions:
        isDisplayChart: DisplayChart,
        isDisplayLine: DisplayLine,
        isDisplayLink: DisplayLink,
        isDisplayIcon: DisplayIcon,
        isDisplayText: DisplayText,
        isDisplayGrid: DisplayGrid,
        isSpecialDisplay: SpecialDisplay,
        isBloodPressure: BloodPressure,
        isCommonDisplay:CommonDisplay
    });

    tpl.overwrite(pnlView.body, CategroyData);
    pnlView.body.dom.style.backgroundColor = "#DFE8F6";
}

//设定头部
function GetHeader() {
    var patientHtml = '<table class ="csTbPatient" border="0" cellpadding="0" cellspacing="0" style="width:' + (tableWidth + (cellCount - 3)) + 'px;" >';
    patientHtml += '<tr class="csTrPatientContent"><td class="csTdPatientInfor"><table id="tbPatient" border="0" cellpadding="0" cellspacing="0"><tr><td style="background-color:Transparent;vertical-align:middle;width:50px;"  rowspan="2"><img id="imgSex" src="../images/TimeLine/manNew.jpg" style="padding-top:2px;width:50px;" /></td><td id="tdName" style="width:80px;padding-left:10px;font-weight:bold;color:#96F53F;font-size:12pt;padding-left:12px;"  rowspan="2"></td><td style="width:50px;font-weight:bold;color:White;">性别：</td><td id="tdSex" style="width:50px;color:#90E4E6;"></td><td style="width:80px;font-weight:bold;color:White;">年龄：</td><td id="tdAge" style="width:80px;color:#90E4E6;"></td><td style="width:40px;font-weight:bold;color:White;"></td><td></td></tr><tr><td style="width:50px;font-weight:bold;color:White;">血型：</td><td id="tdBlood" style="width:50px;color:#90E4E6;"></td><td style="width:80px;font-weight:bold;color:White;">HBV-DNA：</td><td  id="tdHBV" style="width:80px;color:#90E4E6;"></td><td style="width:40px;font-weight:bold;color:White;">唐筛:</td><td id="tdTangSai" style="width:120px;color:#90E4E6;"></td></tr></table></td><td style="width:25px;"></td><td></td></tr>';
    patientHtml += '</table>';
    var headerHtml = '<table id="tbHeaderDate" class ="csTbHeader" border="0" cellpadding="0" cellspacing="1" style="width:'+ tableWidth + 'px;" ><tr class="csTrDate">';
    headerHtml += '<td style="width:' + DateWidth + 'px;vertical-align:middle;background-image:url(\'../images/TimeLine/date_bg.gif\');"><table style="width:100%;height:100%;"><tr><td style="background-color:Transparent;"><img id="imgLastWeek" style="cursor:hand;" src="../images/TimeLine/Week-prev.gif" onclick="LastWeek();" align="left"/></td><td style="background-color:Transparent;"><img id="imgLastDate" style="cursor:hand;" src="../images/TimeLine/Date-prev.gif" onclick="LastDate();" align="left"/></td><td style="background-color:Transparent;">日期</td><td style="background-color:Transparent;"><img id="imgNextDate" style="cursor:hand;" src="../images/TimeLine/Date-next.gif" onclick="NextDate();" align="right"/></td><td style="background-color:Transparent;"><img id="imgNextWeek" style="cursor:hand;" src="../images/TimeLine/Week-next.gif" onclick="NextWeek();" align="right"/></td></tr></table></td>';
    
    DateValues = getDates();

    var count = DateValues.length;
    for (var index = 0; index < count; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index]);
        headerHtml += CreateTd(weekDate);
    }
    headerHtml += '</tr><tr id="trWeeks" class="csTrTime">';
    headerHtml += '<td style="width:' + DateWidth + 'px;font-weight:bold;background-color:#3f75b8; color:White;">孕周</td>'
    //var timeGridHtml = CreateTimeGrid();
    WeekValues = getBirthWeek();
    for (var index = 0; index < count; index++) {
        var timeGridHtml = WeekValues[index];
        headerHtml += CreateTd(timeGridHtml);
    }
    headerHtml += '</tr></table>';
    return patientHtml + headerHtml;
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

//创建信息项
function CreateItemInfor() {
    var dataTitleAttrName = "DataTypeDesc";
    var dataTypeCodeAttrName = "DataTypeCode";
    var tbInforItemTemplate = '<tpl for="CategroyConfig">';
    tbInforItemTemplate += '<tpl if="this.isSpecialDisplay(CategroyCode,ViewType)">';
    tbInforItemTemplate += GetSpecilCatogroyHtml();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isCommonDisplay(CategroyCode,ViewType)">';
    tbInforItemTemplate += '<table id="tbDataType_{' + dataTypeCodeAttrName + '}" ViewType="{ViewType}" Param="{Parameters}" class="csTbInforItem" border="0" cellpadding="0" cellspacing="1"  style="width:' + (tableWidth+2) + 'px;" >';
    tbInforItemTemplate += '<tr class="trInforItemHidden"><td style="background-color:'+rowHeaderColor+'; ">';
    tbInforItemTemplate += '<div style=" font-weight:bold; width:100%; text-align:left;">';
    tbInforItemTemplate += '<img style="cursor:hand;" src="../images/TimeLine/expand.gif" onclick="showItem();" />&nbsp;{' + dataTitleAttrName + '}</div></td><td colspan="' + cellCount + '"></td></tr>';
    tbInforItemTemplate += '<tr class="trInforItemShow"><td style="width:' + DateWidth + 'px;background-color:' + rowHeaderColor + ';" ><table style="width:100%;"><tr><td style="text-align:left;vertical-align:top;width:12px;background-color:Transparent;"><img style="cursor:hand;" src="../images/TimeLine/collapse.gif" onclick ="hiddenItem();"/></td>';
    tbInforItemTemplate += '<tpl if="this.isBloodPressure(DataTypeCode)">';
    //tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;">{' + dataTitleAttrName + '}</td></tr></table></td>';
    tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;"><a href="####" onclick="ShowBloodView();" dtCode="{DataTypeCode}"> {' + dataTitleAttrName + '}</a></td></tr></table></td>';
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="!this.isBloodPressure(DataTypeCode)">';
    tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;">{' + dataTitleAttrName + '}</td></tr></table></td>';
    tbInforItemTemplate += '</tpl>';
    
    tbInforItemTemplate += '<tpl if="this.isDisplayChart(ViewType)">';
    tbInforItemTemplate += CreateChartTd();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isDisplayLine(ViewType)">';
    tbInforItemTemplate += CreateLineTd();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isDisplayLink(ViewType)">';
    tbInforItemTemplate += CreateLinkTd();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isDisplayIcon(ViewType)">';
    tbInforItemTemplate += CreateIconTd();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isDisplayText(ViewType)">';
    tbInforItemTemplate += CreateTextTd();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isDisplayGrid(ViewType)">';
    tbInforItemTemplate += CreateGridTd();
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '</tr></table>';
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '</tpl>';
tbInforItemTemplate += '<div style="height:50px;"></div>';
    return tbInforItemTemplate;
}

//取得特别显示类型的Html
function GetSpecilCatogroyHtml() {
    var categroyCodeAttrName = "CategroyCode";
    var categroyTitleAttrName = "CategroyDesc";
    var cgData = CategroyData.CategroyConfig;
    var dataTypeText = [];
    SpecialDataTypeCode = [];
    for (var index = 0; index < cgData.length; index++) {
        var oneDataType = cgData[index];
        if (SpecialDisplay(oneDataType.CategroyCode, oneDataType.ViewType,true)) {
            dataTypeText.push(oneDataType.DataTypeDesc);
            SpecialDataTypeCode.push(oneDataType.DataTypeCode);
        }
    }

    if (dataTypeText.length == 0) return "";
    var headTable = '<table border="0" cellpadding="0" cellspacing="0" class="csSpecilTable" style="width:' + (DateWidth -12) + 'px;">';
    var th = "<tr>";
    var td1 = "<tr>";
    var td2 = "<tr>";
    var td3 = "<tr>";
    var td4 = "<tr>";
    var td5 = "<tr>";
    var td6 = "<tr>";
    for (var num = 0; num < dataTypeText.length; num++) {
        th += '<td style="color:' + Color[num] + ';">' + dataTypeText[num] + "</td>";
        if (SpecialDataTypeCode[num] == "0202") {
            td1 += '<td style="color:' + Color[num] + ';">60</td>';
            td2 += '<td style="color:' + Color[num] + ';">50</td>';
            td3 += '<td style="color:' + Color[num] + ';">40</td>';
            td4 += '<td style="color:' + Color[num] + ';">30</td>';
            td5 += '<td style="color:' + Color[num] + ';">20</td>';
            td6 += '<td style="color:' + Color[num] + ';">10</td>';
        }
        if (SpecialDataTypeCode[num] == "0203") {
            td1 += '<td style="color:' + Color[num] + ';">150</td>';
            td2 += '<td style="color:' + Color[num] + ';">130</td>';
            td3 += '<td style="color:' + Color[num] + ';">110</td>';
            td4 += '<td style="color:' + Color[num] + ';">90</td>';
            td5 += '<td style="color:' + Color[num] + ';">70</td>';
            td6 += '<td style="color:' + Color[num] + ';">50</td>';
        }
        if (SpecialDataTypeCode[num] == "0204") {
            td1 += '<td style="color:' + Color[num] + ';">40</td>';
            td2 += '<td style="color:' + Color[num] + ';">39</td>';
            td3 += '<td style="color:' + Color[num] + ';">38</td>';
            td4 += '<td style="color:' + Color[num] + ';">37</td>';
            td5 += '<td style="color:' + Color[num] + ';">36</td>';
            td6 += '<td style="color:' + Color[num] + ';">35</td>';
        }
    }

    th += "</tr>";
    td1 += "</tr>";
    td2 += "</tr>";
    td3 += "</tr>";
    td4 += "</tr>";
    td5 += "</tr>";
    td6 += "</tr>";
    headTable += th + td1 + td2 + td3 + td4 + td5 + td6 + "</table>"

    var SpecilInforHtml = '<table id="tbCatogroyType_{' + categroyCodeAttrName + '}" ViewType="{ViewType}" class="csTbInforItem" border="0" cellpadding="0" cellspacing="1"  style="width:' + (tableWidth+2) + 'px;" >';
    SpecilInforHtml += '<tr class="trInforItemHidden"><td style="background-color:' + rowHeaderColor + ';">';
    SpecilInforHtml += '<div style=" font-weight:bold; width:100%; text-align:left;">';
    SpecilInforHtml += '<img style="cursor:hand;" src="../images/TimeLine/expand.gif" onclick="showItem();" />&nbsp;{' + categroyTitleAttrName + '}</div></td><td colspan="' + cellCount + '" ></td></tr>';
    SpecilInforHtml += '<tr class="trInforItemShow"><td style="width:' + DateWidth + 'px;background-color:' + rowHeaderColor + ';" ><table style="width:100%;" border="0" cellpadding="0" cellspacing="0" ><tr><td style="text-align:left;vertical-align:top;width:12px;background-color:Transparent;"><img style="cursor:hand;" src="../images/TimeLine/collapse.gif" onclick ="hiddenItem();"/></td><td style="font-weight:bold;text-align:center;vertical-align:top;background-color:Transparent;">' + headTable + '</td></tr></table></td>';
    SpecilInforHtml += CreateChartTd();
    return SpecilInforHtml;
}

//创建TD
function CreateTd(txt) {
    return '<td style="width:' + (DateWidth) + 'px;" >' + txt + '</td>';
}

//创建显示连接的TD
function CreateLinkTd() {
    var tdsHtml = "";
    for (var index = 0; index < cellCount; index++) {
        tdsHtml += '<td style="width:' + (DateWidth) + 'px;padding-bottom:3px;" ></td>';
    }
    return tdsHtml;
}

//创建显示文本的TD
function CreateTextTd() {
    var tdsHtml = "";
    for (var index = 0; index < cellCount; index++) {
        tdsHtml += '<td style="width:' + (DateWidth) + 'px;padding-bottom:3px;" ></td>';
    }
    return tdsHtml;
}

//创建显示趋势图的TD
function CreateChartTd() {
    var categroyCodeAttrName = "CategroyCode";
    var tdsHtml = '<td colspan="' + cellCount + '" style="width:' + (DateWidth * cellCount) + 'px;">';
    tdsHtml += '<div id="divChart{' + categroyCodeAttrName + '}" class="csChartDiv"></div>';
    tdsHtml += "</td>";
    return tdsHtml;
}

//创建显示线的TD
function CreateLineTd() {
    var tdsHtml = '<td colspan="' + cellCount + '" style="width:' + (DateWidth * cellCount) + 'px;">';
    tdsHtml += CreateLineGridHtml();
    tdsHtml += "</td>";
    return tdsHtml;
}

//创建显示图标的TD
function CreateIconTd() {
    var gridHtml = CreateIconGridHtml();
    var tdsHtml = "";
    for (var index = 0; index < cellCount; index++) {
        tdsHtml += CreateTd(gridHtml);
    }
    return tdsHtml;
}

//创建显示Grid的TD
function CreateGridTd() {
    var gridHtml = CreateGridHtml();
    var tdsHtml = "";
    for (var index = 0; index < cellCount; index++) {
        tdsHtml += CreateTd(gridHtml);
    }
    return tdsHtml;
}

//将需要显示的数据添加到页面中
function BuildData(dataArray) {
    SetButtonState();
    var count = dataArray.length;
    for (var index = 0; index < count; index++) {
        var oneData = dataArray[index];
        var tableId = "tbDataType_" + oneData.DataTypeCode;
        var tbInfor = Ext.getDom(tableId);
        if (tbInfor == null) {
            tableId = "tbCatogroyType_" + oneData.CategroyCode;
            tbInfor = Ext.getDom(tableId);
        }
        if (tbInfor) {
            var viewType = tbInfor.getAttribute("ViewType");
            if (DisplayLink(viewType)) {
                var records = oneData.records;
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    var tdIndex = GetDisplayTdIndex(oneRecord.ActDate);
                    var gridCellIndex = GetDisplayGridTdIndex(oneRecord.ActTime);
                    if (tdIndex >= 0) {
                        tbInfor.rows[1].cells[tdIndex + 1].innerHTML += BuildLinkData(oneRecord, oneData.CategroyCode,tbInfor.Param, gridCellIndex);
                    }
                }
            }
            else if (DisplayText(viewType)) {
                var records = oneData.records;
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    var tdIndex = GetDisplayTdIndex(oneRecord.ActDate);
                    var gridCellIndex = GetDisplayGridTdIndex(oneRecord.ActTime);
                    if (tdIndex >= 0) {
                        tbInfor.rows[1].cells[tdIndex + 1].innerHTML += BuildTextData(oneRecord, oneData.CategroyCode, gridCellIndex);
                    }
                }
            }
            else if (DisplayIcon(viewType)) {
                var records = oneData.records;
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    var tdIndex = GetDisplayTdIndex(oneRecord.ActDate);
                    var gridCellIndex = GetDisplayGridTdIndex(oneRecord.ActTime);
                    if (tdIndex >= 0) {
                        var grid = tbInfor.rows[1].cells[tdIndex + 1].children[0];
                        grid.rows[0].cells[gridCellIndex].innerHTML += BuildIConData(oneRecord, tbInfor.Param);
                    }
                }
            }
            else if (DisplayGrid(viewType)) {
                var records = oneData.records;
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    var tdIndex = GetDisplayTdIndex(oneRecord.ActDate);
                    var gridCellIndex = GetDisplayGridTdIndex(oneRecord.ActTime);
                    if (tdIndex >= 0) {
                        var grid = tbInfor.rows[1].cells[tdIndex + 1].children[0];
                        grid.rows[0].cells[gridCellIndex].innerHTML += BuildGridData(oneRecord);
                    }
                }
            }
            else if (DisplayLine(viewType)) {
            var records = oneData.records;
                var gridLine = tbInfor.rows[1].cells[1].children[0];
                //var xPercent = gridLine.offsetWidth / (cellCount * 24);
                var xPercent = gridLine.offsetWidth / cellCount;
                var startPosition = DateWidth / 2;
                var lineArray = GetLineData(records);
                for (var num = 0; num < lineArray.length; num++) {
                    var lineColorCount = LineColor.length;
                    var lineColorIndex = num % lineColorCount;
                    var lineColor = LineColor[lineColorIndex];
                    //var arrowCss = LineArrowCss[lineColorIndex];
                    var lineData = lineArray[num];
                    var points = GetLinePoint(lineData);
                    if (points.length > 0) {
                        var newRow = gridLine.insertRow(gridLine.rows.length);
                        newCell = newRow.insertCell(0);
                        var lineContainer = document.createElement("div");
                        lineContainer.className = "csLineContainer";
                        newCell.appendChild(lineContainer);
                        var config = { height: 30, topDistance: 10, lineColor: lineColor, containerX: DateWidth, widthPerUnit: xPercent, lableCss: 'csLineLabel', maxWidth: (DateWidth * cellCount), startX: startPosition };
                        new LineShape(points, lineContainer, config);
                    }
                }
            }
            else if (DisplayChart(viewType)) {
                var records = oneData.records;
                var divDisplayChart = tbInfor.rows[1].cells[1].children[0];
                var yData = [];
                var xData = [];
                var chartColor = GetColor(oneData.DataTypeCode);
                var pointStyle = GetPointStyle(oneData.DataTypeCode);
                var chartHeight = divDisplayChart.offsetHeight;
                var yMaxValue = GetYMaxValue(oneData.DataTypeCode);
                var ySartValue = GetYSartValue(oneData.DataTypeCode);
                //var xPercent = divDisplayChart.offsetWidth / (cellCount * 24);
                var startPosition = DateWidth / 2;
                var xPercent = divDisplayChart.offsetWidth / cellCount;
                var config = { height: chartHeight, maxHeight: yMaxValue, startHeight: ySartValue, barDistance: xPercent, leftDistance: 0, pointColor: chartColor, lineColor: chartColor, valueColor: chartColor, containerX: DateWidth,pointCss:pointStyle,startX:startPosition};
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    //xData.push(GetTimeValue(oneRecord.ActDate, oneRecord.ActTime));
                    xData.push(GetDisplayTdIndex(oneRecord.ActDate));
                    yData.push(oneRecord.DataValue);
                }
                var data = new period(yData, xData);
                new gov.Graphic(data, divDisplayChart.id, config);
            }
        }
    }
}

//取得线的点
function GetLinePoint(lineDatas) {
    var points = [];
    for (var index = 0; index < lineDatas.length; index++) {
        var lineData = lineDatas[index];
        var sDate = ConvertToDateValue(lineData.startDate);
        var eDate = ConvertToDateValue(lineData.endDate);
        var showSDate = ConvertToDateValue(DateValues[0]);
        var showEDate = ConvertToDateValue(DateValues[cellCount - 1]);
        var isStart = false;
        var isEnd = false;
        var noEnd = false;
        if (eDate != "") {
            if (sDate >= showSDate && sDate <= showEDate) {
                //var xPoint = GetTimeValue(lineData.startDate, lineData.startTime);
                var xPoint = GetDisplayTdIndex(lineData.startDate);
                isStart = true;
                isEnd = false;
                noEnd = false;
                var lblValue = lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }

            if (eDate >= showSDate && eDate <= showEDate) {
                //var xPoint = GetTimeValue(lineData.endDate, lineData.endTime);
                var xPoint = GetDisplayTdIndex(lineData.endDate);
                isEnd = true;
                isStart = false;
                noEnd = false;
                var lblValue = "";
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }

            if (sDate < showSDate && eDate > showEDate) {
                var xPoint = 0;
                var lblValue = "";
                isEnd = false;
                isStart = false;
                noEnd = false;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }
        }
        else {
            noEnd = false;
            if (sDate >= showSDate && sDate <= showEDate) {
                //var xPoint = GetTimeValue(lineData.startDate, lineData.startTime);
                var xPoint = GetDisplayTdIndex(lineData.startDate);
                isStart = true;
                var lblValue = lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }
            var today = ConvertToDateValue(DateNowServer);
            if (showEDate > today) {
                //var xPoint = GetTimeValue(formatDate(today), "23:00");
                var xPoint = GetDisplayTdIndex(formatDate(today));
                isStart = false;
                isEnd = true;
                var lblValue = lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }
            if (sDate < showSDate && today > showEDate) {
                var xPoint = 0;
                var lblValue = "";
                isEnd = false;
                isStart = false;
                noEnd = false;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }
        }
    }
    return points;
}

//取得同一条线的数据
function GetLineData(records) {
    var lines = [];
    for (var num = 0; num < records.length; num++) {
        var oneData = records[num];
        var haveFlg = false;
        for (var index = 0; index < lines.length; index++) {
            var line = lines[index];
            if (line[0].objId == oneData.objId) {
                line.push(oneData);
                haveFlg = true;
                break;
            }
        }
        if (haveFlg == false) {
            var oneLine = [];
            oneLine.push(oneData);
            lines.push(oneLine);
        }
    }
    return lines;
}

//创建link显示的内容
function BuildLinkData(record, cateCode,param, gridCellIndex) {
    var linkPath = param;
    //医嘱
    if (cateCode == "04" || cateCode == "05") {
        var inforArray = record.linkDatas;
        var inforHtml = record.Summary + "<br />";
        for (var index = 0; index < inforArray.length; index++) {
            var oneInfor = inforArray[index];
            var actTime = oneInfor.ActTime;
            if (actTime != "") {
                actTime = actTime.substr(0, 5);
            }
            inforHtml += oneInfor.ActDate + " " + actTime + " " + oneInfor.ActDesc + "<br />";
        }
        inforHtml = escape(inforHtml);
        if (linkPath != "") {
            linkPath += "?" + record.Parameters;
        }
        else {
            linkPath += record.Parameters;
        }
        var summary = record.Summary;
        if (summary.length > txtLength) {
            summary = summary.substr(0, txtLength) + "...";
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    //临床评估
    else if (cateCode == "01") {
        linkPath = "TimeLine/birthcheckdiagnoseview.csp?patientID=" + patientID;
        var summary = record.DataValue;
        var inforHtml = "";
        if (summary.length > txtLength) {
            summary = summary.substr(0, txtLength) + "...";
            inforHtml = escape(record.Summary);
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    else if (cateCode == "10") {
        linkPath += "?" + record.Parameters;
        var summary = record.Summary;
        var inforHtml = "";
        if (summary.length > txtLength) {
            summary = summary.substr(0, txtLength) + "...";
            inforHtml = escape(record.Summary);
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    //手术
    else if (cateCode == "08") {
        var actTime = record.ActTime;
        if (actTime != "") {
            actTime = actTime.substr(0, 5);
        }
        linkPath = record.Parameters;
        var summary = actTime + " " + record.ActDesc;
        var inforHtml = "";
        //手术申请
        if (record.ActCode == "080101") {
            inforHtml = record.Summary;
        }
        else {
            if (summary.length > txtLength) {
                summary = summary.substr(0, txtLength) + "...";
                inforHtml = escape(record.Summary);
            }
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    else {
        if (linkPath != "") {
            linkPath += "?" + record.Parameters;
        }
        else {
            linkPath += record.Parameters;
        }
        var summary = record.Summary;
        var inforHtml = "";
        if (summary.length > txtLength) {
            summary = summary.substr(0, txtLength) + "...";
            inforHtml = escape(record.Summary);
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
}

//创建文本显示的内容
function BuildTextData(record, cateCode, gridCellIndex) {
    var labelHtml = "";
    var actTime = record.ActTime;
    if (actTime != "") {
        actTime = actTime.substr(0, 5);
    }
    //临时药物
    if (cateCode == "07") {
        return CreateAlingLabel(actTime + " " + record.Summary, gridCellIndex);
    }
    else if (cateCode == "09") {
        //医疗文书
        return CreateAlingLabel(actTime + " " + record.Summary, gridCellIndex);
    }
    else {
        return CreateAlingLabel(actTime + " " + record.Summary, gridCellIndex);
    }
    return labelHtml;
}

//创建图标显示的内容
function BuildIConData(record, param) {
    var iconPath = param;
    var inforHtml = record.ActTime + " " + record.Summary;
    inforHtml = escape(inforHtml);
    var IconHtml = '<img class="csIcon" src="' + iconPath + '" infor="' + inforHtml + '" onmouseover="ShowInfor();" onmouseout="HiddenInfor();" /><br/>';
    return IconHtml;
}

//创建grid显示的内容
function BuildGridData(record) {
    var cellHtml = record.DataValue + '<br/>';
    return cellHtml;
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

//取得显示数据的grid的Td索引
function GetDisplayGridTdIndex(time) {
//    if (!time) return 0;
//    var timeValue = parseInt(time.split(":")[0],10);
//    var miValue = parseInt(time.split(":")[1],10);
//    var index = parseInt(timeValue/TimeSplit,10);
//    var mod = timeValue%TimeSplit;
    return 3;
}

//判断是否是特殊类型的图形显示
function SpecialDisplay(CategroyCode, ViewType, flg) {
    if (DisplayChart(ViewType) && CategroyCode == "02") {
        if (flg) {
            return true;
        }
        if (haveSpecialDisplay == false) {
            haveSpecialDisplay = true;
            return true;
        }
        else {
            return false;
        }
    }
    else {
        return false;
    }
}

//判断是否是血压
function BloodPressure(dataTypeCode) {
    if (dataTypeCode == "0306") {
        return true;
    }
    else {
        return false;
    }
}

//判断是否为普通显示
function CommonDisplay(CategroyCode, ViewType) {
    if (DisplayChart(ViewType) && CategroyCode == "02") {
        false;
    }
    else {
        return true;
    }
}

//判断是否用图形显示
function DisplayChart(viewType)
{
    return viewType == "C";
}

//判断是否用连接显示
function DisplayLink(viewType)
{
    return viewType == "A";
}

//判断是否用图标显示
function DisplayIcon(viewType)
{
    return viewType == "I";
}

//判断是否用文本显示
function DisplayText(viewType) {
    return viewType == "L";
}

//判断是否用文本显示
function DisplayGrid(viewType) {
    return viewType == "T";
}

//判断是否用线显示
function DisplayLine(viewType) {
    return viewType == "N";
}

//取得点的样式
function GetPointStyle(code)
{
    if (SpecialDataTypeCode) {
        for (var index = 0; index < SpecialDataTypeCode.length; index++) {
            if (SpecialDataTypeCode[index] == code) {
                return PointCSS[index];
            }
        }
    }
    return "";
}

//取得颜色值
function GetColor(code) {
    if (SpecialDataTypeCode) {
        for (var index = 0; index < SpecialDataTypeCode.length; index++) {
            if (SpecialDataTypeCode[index] == code) {
                return Color[index];
            }
        }
    }
    return "#ff0000";
}

//取得Y轴最大值
function GetYMaxValue(code)
{
//        if (code == "0201") {
//            return 170;
//        }
        if (code == "0202") {
            return 65;
        }
        if (code == "0203") {
            return 160;
        }
        if (code == "0204") {
            return 40.5;
        }
        return null;
    }

//取得Y轴起始值
function GetYSartValue(code) {
//    if (code == "0201") {
//        return 50;
//    }
    if (code == "0202") {
        return 5;
    }
    if (code == "0203") {
        return 40;
    }
    if (code == "0204") {
        return 34.5;
    }
    return null;
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
    var count = ClinicalData.lastDisplayDate.length;
    if (count > 0) {
        var searchDate = ClinicalData.lastDisplayDate[count-1]
        var actionParams = { 'queryCode': queryCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("pnlView", actionParams);
    }
}

//日期向后移动一周
function NextWeek() {
    var dtArr = DateValues[cellCount-1].split("-");
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
        var actionParams = { 'queryCode': queryCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("pnlView", actionParams);
    }
}

//日期向前移动一天
function LastDate() {
//    var dtArr = DateValues[0].split("-");
//    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    dtLast.setDate(parseInt(dtArr[2], 10) - 1);
//    DateValues = getDates(dtLast);
//    var queryDate = DateValues[0];
     var count = ClinicalData.lastDisplayDate.length;
     if (count > 0) {
         var searchDate = ClinicalData.lastDisplayDate[0]
         var actionParams = { 'queryCode': queryCode, 'patientID': patientID, 'startDate': searchDate };
         SubmitForm("pnlView", actionParams);
     }
}

//日期向后移动一天
function NextDate() {
//    var dtArr = DateValues[0].split("-");
//    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    dtNext.setDate(parseInt(dtArr[2], 10) + 1);
//    DateValues = getDates(dtNext);
//    var queryDate = DateValues[0];
    if (ClinicalData.displayDate.length > 1) {
        var searchDate = ClinicalData.displayDate[1].split("|")[0];
        var actionParams = { 'queryCode': queryCode, 'patientID': patientID, 'startDate': searchDate };
        SubmitForm("pnlView", actionParams);
    }
}

////向左移动就诊记录
//function MoveLeftRecord() {
//    var count = SeeDoctorInfor.length;
//    if ((SeeDocIndex - 7) >= 0) {
//        SeeDocIndex = SeeDocIndex - 7;
//        ShowSeeDoctorRecord(SeeDocIndex);
//    }
//}

////向右移动就诊记录
//function MoveRightRecord() {
//    var count = SeeDoctorInfor.length;
//    if ((SeeDocIndex + 7) < count) {
//        SeeDocIndex = SeeDocIndex + 7;
//        ShowSeeDoctorRecord(SeeDocIndex);
//    }
//}

////显示就诊记录
//function ShowSeeDoctorRecord(index) {
//    var tbSeeDoc = document.getElementById("divSeeDoctor").children[0];
//    var count = SeeDoctorInfor.length;
//    tbSeeDoc.rows[0].cells[0].innerHTML = "";
//    tbSeeDoc.rows[0].cells[1].innerHTML = "";
//    tbSeeDoc.rows[0].cells[2].innerHTML = "";
//    tbSeeDoc.rows[0].cells[3].innerHTML = "";
//    tbSeeDoc.rows[0].cells[4].innerHTML = "";
//    tbSeeDoc.rows[0].cells[5].innerHTML = "";
//    tbSeeDoc.rows[0].cells[6].innerHTML = "";
//    if(index < count)
//    {
//        tbSeeDoc.rows[0].cells[0].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index]);
//    }
//    if ((index + 1) < count) {
//        tbSeeDoc.rows[0].cells[1].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index+1]);
//    }
//    if ((index + 2) < count) {
//        tbSeeDoc.rows[0].cells[2].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index+2]);
//    }
//    if ((index + 3) < count) {
//        tbSeeDoc.rows[0].cells[3].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 3]);
//    }
//    if ((index + 4) < count) {
//        tbSeeDoc.rows[0].cells[4].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 4]);
//    }
//    if ((index + 5) < count) {
//        tbSeeDoc.rows[0].cells[5].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 5]);
//    }
//    if ((index + 6) < count) {
//        tbSeeDoc.rows[0].cells[6].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 6]);
//    }
//}

////创建就诊记录的link
//function CreateSeeDocLink(infor) {
//    return '<a type="link" href="####" onclick="ChangeInfor();" inforId="'+ infor.episodeId + '" >' + infor.episodeDate + '</a>';
//}

////切换就诊记录
//function ChangeInfor() {
//    var selectDate = event.srcElement.innerText;
//    var dtArr = selectDate.split("-");
//    selectDate = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
//    DateValues = getDates(selectDate);
//    var queryDate = DateValues[0];
//    episodeId = event.srcElement.inforId;
//    var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': queryDate };
//    SubmitForm("pnlView", actionParams);
//}


//清除页面中的数据
function ClearRecord() {
    var tbDate = document.getElementById("tbHeaderDate");
    var count = DateValues.length;
    for (var index = 1; index < count + 1; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index-1]);
        tbDate.rows[0].cells[index].innerHTML = weekDate;
        tbDate.rows[1].cells[index].innerHTML = WeekValues[index - 1];
    }
    
    var InforTableArray = Ext.select('table[class =csTbInforItem]').elements;
    var tableCount = InforTableArray.length;
    for (var num = 0; num < tableCount; num++) {
        var oneTable = InforTableArray[num];
        var viewType = oneTable.ViewType;
        if (DisplayLink(viewType)) {
            for (var index = 0; index < cellCount; index++) {
                var inforCell = oneTable.rows[1].cells[index + 1];
                inforCell.innerHTML = "";
            }
        }
        else if (DisplayText(viewType)) {
            for (var index = 0; index < cellCount; index++) {
                var inforCell = oneTable.rows[1].cells[index + 1];
                inforCell.innerHTML = "";
            }
        }
        else if (DisplayIcon(viewType)) {
            var gridHtml = CreateIconGridHtml();
            for (var index = 0; index < cellCount; index++) {
                var inforCell = oneTable.rows[1].cells[index + 1];
                inforCell.innerHTML = gridHtml;
            }
        } else if (DisplayGrid(viewType)) {
            var gridHtml = CreateGridHtml();
            for (var index = 0; index < cellCount; index++) {
                var inforCell = oneTable.rows[1].cells[index + 1];
                inforCell.innerHTML = gridHtml;
            }
        }
        else if (DisplayLine(viewType)) {
            var gridHtml = CreateLineGridHtml();
            var inforCell = oneTable.rows[1].cells[1];
            inforCell.innerHTML = gridHtml;
        }
        else if (DisplayChart(viewType)) {
            var inforDiv = oneTable.rows[1].cells[1].children[0];
            inforDiv.innerHTML = "";
        }
    }
}

//创建图标表格的html
function CreateIconGridHtml() {
    var timeCount = 24 / TimeSplit;
    var gridHtml = '<table class="csTbTime" border="0" cellpadding="0" cellspacing="0" ><tr>';
    var tdWidth = DateWidth / timeCount;
    for (var index = 0; index < timeCount; index++) {
        gridHtml += '<td style="width:' + tdWidth + 'px;"></td>';
    }
    gridHtml += "</tr></table>";
    return gridHtml;
}

//创建表格的html
function CreateGridHtml() {
    var timeCount = 24 / TimeSplit;
    var gridHtml = '<table class="csGrid" border="0" cellpadding="0" cellspacing="0" ><tr>';
    var tdWidth = DateWidth / timeCount;
    for (var index = 1; index < timeCount + 1; index++) {
        if (index == timeCount) {
            gridHtml += '<td style="width:' + tdWidth + 'px;"></td>';
        }
        else {
            gridHtml += '<td class="csGridTd" style="width:' + tdWidth + 'px;" ></td>';
        }
    }
    gridHtml += "</tr></table>";
    return gridHtml;
}

//创建线表格的html
function CreateLineGridHtml() {
    var gridHtml = '<table style="width:' + (DateWidth * cellCount) + 'px;" border="0" cellpadding="0" cellspacing="0" ><tr><td style="height:5px;"></td></tr></table>';
    return gridHtml;
}

//显示信息
function ShowInfor() {
    ChangeStyle(1);
    var divInfor = document.getElementById(divInforID);
    if (divInfor) {
        return;
    }
    var infor = event.srcElement.infor;
    if (!infor) {
        infor = event.srcElement.children[0].infor;
    }
    var divInfor = document.createElement("div");
    divInfor.id = divInforID;
    divInfor.innerHTML = unescape(infor);
    //var headerHeight = document.getElementById("divHeader").offsetHeight;
    divInfor.style.top = (event.clientY+5) + "px"; ;
    divInfor.style.left = (event.x + 5) + "px";
    divInfor.className = "csDivInfor";
    document.body.appendChild(divInfor);
}

//隐藏信息
function HiddenInfor() {
    ChangeStyle(0);
    var divInfor = document.getElementById(divInforID);
    if (divInfor) {
        divInfor.parentElement.removeChild(divInfor);
    }
}

//显示报告
function ShowReport() {
    var path = event.srcElement.linkPath;
    var cateCode = event.srcElement.cateCode;
    if (cateCode == "01") {
        OpenNewPage(path, 1185, 550, "诊断记录");
    }
    else if (cateCode == "10") {
    OpenNewPage(path, 990, 600, "临床路径");
    }
    else {
        OpenNewPage(path, 990, 600, "报告");
    }
}

//打开一个新页面
function OpenNewPage(url,winWidth,winHeight,title) {
    var iframe = Ext.DomHelper.createHtml({
        tag: 'iframe',
        name: 'iframename',
        src: url,
        width: "100%",
        height: "100%"

    });
    var newWindow = new Ext.Window({
        id: "newWindow",
        title: title,
        modal: true,
        width: winWidth,
        height: winHeight,
        maximizable: true,
        closable: true,
        x: 10,
        y: 10,
        html: iframe
    });
    newWindow.show();
}

//隐藏信息
function hiddenItem() {
    var trClick = event.srcElement.parentElement.parentElement;
    var index = 0;
    while (trClick.className != "trInforItemShow" && index < 10) {
        trClick = trClick.parentElement;
        index = index + 1;
    }
    trClick.previousSibling.style.display = "block";
    trClick.style.display = "none";
}

//显示信息
function showItem() {
    var trClick = event.srcElement.parentElement.parentElement.parentElement;
    trClick.style.display = "none";
    trClick.nextSibling.style.display = "block";
}

//取得日期
function getDates() {
    var date = [];
    var displayDateInfor = ClinicalData.displayDate;
    var oneDate = new Date();
    for (var i = 0; i < cellCount; i++) {
        if (i < displayDateInfor.length) {
            var dtArr = displayDateInfor[i].split("|")[0].split("-");
            oneDate = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
            date.push(formatDate(oneDate));
        }
        else {
            oneDate.setDate(parseInt(oneDate.getDate(), 10) +1);
            date.push(formatDate(oneDate));
        }
    }
    return date;
}

//取得产周
function getBirthWeek() {
    var weeks = [];
    var displayDateInfor = ClinicalData.displayDate;
    //var oneDate = new Date();
    for (var i = 0; i < cellCount; i++) {
        if (i < displayDateInfor.length) {
            //var dtArr = displayDateInfor[i].split("|")[1].split("-");
            //oneDate = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
            //date.push(formatDate(oneDate));
            var weekInfor = "第"+displayDateInfor[i].split("|")[1]+"周";
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

//取得某月的天数
function getDaysInMonth(yearvalue, monthvalue) {
    yearvalue = parseInt(yearvalue, 10);
    monthvalue = parseInt(monthvalue, 10);
    var datevalue = "";
    if (monthvalue == 1 || monthvalue == 3 || monthvalue == 5 || monthvalue == 7 || monthvalue == 8 || monthvalue == 10 || monthvalue == 12) {
        datevalue = 31;
    }
    else if (monthvalue == 4 || monthvalue == 6 || monthvalue == 9 || monthvalue == 11) {
        datevalue = 30;
    }
    else if (monthvalue == 2) {
        var leapYear = (((yearvalue % 4 == 0) && (yearvalue % 100 != 0)) || (yearvalue % 400 == 0)) ? 1 : 0;
        if (leapYear) {
            datevalue = 29;
        }
        else {
            datevalue = 28;
        }
    }
    return datevalue;
}

//格式化日期
function formatDate(d) {
    var _todayDate = d.getDate();
    var _year = d.getYear();
    var _month = d.getMonth() + 1;
    if ((_month+"").length < 2) {
        _month = "0" + _month;
    }
    if ((_todayDate+"").length < 2) {
        _todayDate = "0" + _todayDate;
    }
    return _year + "-" + _month + "-" + _todayDate;
}

//取得x轴时间值
function GetTimeValue(dateValue, timeValue) {
    var dtArr = dateValue.split("-");
    var dt = new Date(dtArr[0], parseInt(dtArr[1],10)-1, dtArr[2]);
    var dtMinArr = DateValues[0].split("-");
    var dtMin = new Date(dtMinArr[0], parseInt(dtMinArr[1],10)-1, dtMinArr[2]);
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

//获取数据
function SubmitForm(frmName, actionParams) {
    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在获取数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            ClinicalData.displayDate = action.result.displayDate;
            ClinicalData.lastDisplayDate = action.result.lastDisplayDate;
            DateValues = getDates();
            WeekValues = getBirthWeek();
            ClearRecord();
            ClinicalData.DataArray = action.result.DataArray;
            ClinicalData.EndDate = action.result.EndDate;
            ClinicalData.StartDate = action.result.StartDate;
            ClinicalData.PatientInfo = action.result.PatientInfo;
            BuildData(ClinicalData.DataArray);
            ShowPatientInfor(ClinicalData.PatientInfo);
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

//创建可对齐的label
function CreateAlingLabel(infor,cellIndex) {
    var gridHtml = CreateAlignGridHtml(cellIndex);
    var inforHtml = escape(infor);
    if (infor.length > txtLength) {
        infor = infor.substr(0, txtLength) + "...";
    }
    var lblHtml = '<div class="csDivLabel" style="width:' + (DateWidth - 4) + 'px;" infor="' + inforHtml + '" onmouseover="ShowInfor();" onmouseout="HiddenInfor();">' + infor + '</div>';
    return '<div class="csAlignDiv">' + gridHtml + lblHtml + '</div>';
}

//创建可对齐的Link
function CreateAlingLink(txt, infor, cellIndex, linkPath, cateCode) {
    var gridHtml = CreateAlignGridHtml(cellIndex);
    var linkHtml = "";
    if (infor =="") {
        linkHtml = '<div class="csDivLink" style="width:' + (DateWidth - 4) + 'px;" isLink="1" onmouseover="ChangeStyle(1);" onmouseout="ChangeStyle(0);" onclick="ShowReport();" infor="' + infor + '"   linkPath="' + linkPath + '" cateCode="' + cateCode + '">' + txt + '</div>';
    }
    else {
        linkHtml = '<div class="csDivLink" style="width:' + (DateWidth - 4) + 'px;" isLink="1" onmouseover="ShowInfor();" onmouseout="HiddenInfor();" onclick="ShowReport();" infor="' + infor + '"  linkPath="' + linkPath + '" cateCode="' + cateCode + '">' + txt + '</div>';
    }
    return '<div class="csAlignDiv">' + gridHtml + linkHtml + '</div>';
}

//改变样式
function ChangeStyle(flg) {
    if (flg == 1) {
        if (event.srcElement.isLink == "1") {
            event.srcElement.style.backgroundPositionY = "-22px";
        }
        if (event.srcElement.parentNode.isLink == "1") {
            event.srcElement.parentNode.style.backgroundPositionY = "-22px";
        }
    }
    else if (flg == 0) {
        if (event.srcElement.isLink == "1") {
            if (event.toElement && event.toElement.parentNode && event.toElement.parentElement == event.srcElement) {
            }
            else {
                event.srcElement.style.backgroundPositionY = "0px";
            }
        }
        if (event.srcElement.parentNode.isLink == "1") {
            if (event.toElement != event.srcElement.parentNode) {
                event.srcElement.parentNode.style.backgroundPositionY = "0px";
            }
        }
    }
}


//创建表格的html
function CreateAlignGridHtml(cellIndex) {
    var timeCount = 24 / TimeSplit;
    var gridHtml = '<table class="csAlignGrid" border="0" cellpadding="0" cellspacing="0" ><tr>';
    var tdWidth = (DateWidth-4) / timeCount;
    for (var index = 1; index < timeCount + 1; index++) {
        if (index == cellIndex) {
            gridHtml += '<td  style="width:' + tdWidth + 'px;"></td>';
            //gridHtml += '<td class="csAlignGridTd" style="width:' + tdWidth + 'px;"></td>';
        }
        else {
            gridHtml += '<td  style="width:' + tdWidth + 'px;" ></td>';
        }
    }
    gridHtml += "</tr></table>";
    return gridHtml;
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

//设定日期移动按钮的状态
function SetButtonState() {
    var starDate = GetStartDate();
    var endDate = GetEndDate();
    var dtMaxArry = DateValues[DateValues.length-1].split("-");
    var dtMinArry = DateValues[0].split("-");
    var maxDate = new Date(dtMaxArry[0], parseInt(dtMaxArry[1], 10) - 1, dtMaxArry[2]);
    var minDate = new Date(dtMinArry[0], parseInt(dtMinArry[1], 10) - 1, dtMinArry[2]);
    if (maxDate >= endDate) {
        document.getElementById("imgNextDate").disabled = true;
        document.getElementById("imgNextDate").src = "../images/TimeLine/Date-next-disabled.gif";
        document.getElementById("imgNextWeek").disabled = true;
        document.getElementById("imgNextWeek").src = "../images/TimeLine/Week-next-disabled.gif";
    }
    else {
        document.getElementById("imgNextDate").disabled = false;
        document.getElementById("imgNextDate").src = "../images/TimeLine/Date-next.gif";
        document.getElementById("imgNextWeek").disabled = false;
        document.getElementById("imgNextWeek").src = "../images/TimeLine/Week-next.gif";
    }
    if (minDate <= starDate) {
        document.getElementById("imgLastWeek").disabled = true;
        document.getElementById("imgLastWeek").src = "../images/TimeLine/Week-prev-disabled.gif";
        document.getElementById("imgLastDate").disabled = true;
        document.getElementById("imgLastDate").src = "../images/TimeLine/Date-prev-disabled.gif";
    }
    else {
        document.getElementById("imgLastWeek").disabled = false;
        document.getElementById("imgLastWeek").src = "../images/TimeLine/Week-prev.gif";
        document.getElementById("imgLastDate").disabled = false;
        document.getElementById("imgLastDate").src = "../images/TimeLine/Date-prev.gif";
    }
}

//取得就诊起始日
function GetStartDate()
{
    var startDateArry = ClinicalData.StartDate.split("-");
    var starDate = new Date(startDateArry[0], parseInt(startDateArry[1], 10) - 1, startDateArry[2]);
    return starDate;
}

//取得就诊结束日
function GetEndDate()
{
    var endDateArry = ClinicalData.EndDate.split("-");
    var endDate = new Date(endDateArry[0], parseInt(endDateArry[1], 10) - 1, endDateArry[2]);
    return endDate;
}

////显示血压的趋势图
function ShowBloodView() {
    var path = "TimeLine/birthcheckbloodpressureview.csp?dataTypeCode=" + event.srcElement.dtCode + "&patientID=" + patientID + "&startDate=" + ClinicalData.StartDate;
    OpenNewPage(path, 980, 278,"血压趋势图");
}

//显示病人信息
function ShowPatientInfor(patientInfor) {
    document.getElementById("tdName").innerHTML = patientInfor.name;
    document.getElementById("tdSex").innerHTML = patientInfor.sex;
    if (patientInfor.sex == "男") {
        document.getElementById("imgSex").src = "../images/TimeLine/manNew.jpg";
    }
    else {
        document.getElementById("imgSex").src = "../images/TimeLine/womanNew.jpg";
    }
    document.getElementById("tdAge").innerHTML = patientInfor.age.split("岁")[0] + "岁";
    document.getElementById("tdBlood").innerHTML = patientInfor.BloodType;
    document.getElementById("tdHBV").innerHTML = patientInfor.HBVDNA;
    document.getElementById("tdTangSai").innerHTML = patientInfor.PROCHCG;
    
//    var inDate = patientInfor.inDate;
//    if (inDate != "") {
//        var dtArr = inDate.split("-");
//        document.getElementById("tdInDate").innerHTML = dtArr[0] + "年" + dtArr[1] + "月" + dtArr[2] + "日";
//    }
//    else {
//        document.getElementById("tdInDate").innerHTML = patientInfor.inDate;
//    }
//    document.getElementById("tdInDept").innerHTML = patientInfor.inDept;
//    document.getElementById("tdPaDoctor").innerHTML = patientInfor.paDoctor;
}

//转化为日期值
function ConvertToDateValue(dateTxt) {
    if (dateTxt == "") {
        return "";
    }
    var dtArry = dateTxt.split("-");
    var dtValue = new Date(dtArry[0], parseInt(dtArry[1], 10) - 1, dtArry[2]);
    return dtValue;
}

//显示菜单
function showMenu() {
    var divMenuItem = document.getElementById("divMenu");
    divMenuItem.style.top = (event.clientY + 5) + "px"; ;
    divMenuItem.style.left = (event.x + 5) + "px";
    divMenuItem.style.display = "block";
    event.returnValue = false;
    if (window.event) {
        if (event != null) {
            event.cancelBubble = true;
        }
    } else {
        if (event != null) {
            event.stopPropagation();
        }
    }
}

//隐藏菜单
function HiddenMenu() {
    var divMenuItem = document.getElementById("divMenu");
    divMenuItem.style.display = "none";
}

//生成数据
function GenerateData() {
    var divMenuItem = document.getElementById("divMenu");
    divMenuItem.style.display = "none";
    var actionParams = { 'patientID': patientID, 'actionCode': 'GenerateData' };
    Ext.Ajax.request({
        url: accessURL,
        success: GenerateDataSuccess,
        failure: GenerateDataFailure,
        params: actionParams
    });
}
//生成数据成功
function GenerateDataSuccess() {
    Ext.MessageBox.show({
        title: "提示信息",
        msg: "生成数据成功",
        width: 400,
        buttons: Ext.MessageBox.OK,
        icon: Ext.MessageBox.INFO
    });
}
//生成数据失败
function GenerateDataFailure(o, p) {
    Ext.MessageBox.show({
        title: "错误信息",
        msg: "生成数据失败",
        width: 400,
        buttons: Ext.MessageBox.OK,
        icon: Ext.MessageBox.ERROR
    });
}

