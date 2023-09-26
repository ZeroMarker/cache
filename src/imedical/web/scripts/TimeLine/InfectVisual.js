//显示的单元格数
var cellCount =7;
//每个日期对应的单元格的宽度
var DateWidth = 144;
//每一天按几小时分成一个时间段
var TimeSplit = 4;
//每个信息项表的宽度
var tableWidth = DateWidth * (cellCount+1) + cellCount;
//显示的日期值
var DateValues = null
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
var accessURL = "TimeLine/extgetdata.csp";
//每行显示的文本的最多字数
var txtLength = 10;
//行头的背景颜色
var rowHeaderColor = "#ddeef8;color:#132456";
var cellColor = "#C3D1F4";
var seeDocIndex = 0;
//周列表ID
var divWeekMenuID = "divWeekMenuList";
//显示周信息的Div的ID
var divWeekID = "divWeek";
//病人列表信息
var PatientList = null;
//病人列表信息菜单ID
var divPatientListID = "divPatientList";
//当前显示的长期药品种类
var drugNameList = null;
//子窗口
var SC_CHILD_WINDOW = null;
//当前选则的报告项
var SelectReportItem = null;

//页面加载完毕，开始执行
Ext.onReady(function() {
    //GetPatientList();
    ShowPage();
    ForbidBlowup();
    //if (this.parent.opener == null) {
    //    window.onresize = changPanelSize;
    //}
    //SetSelectPatient();
    window.onunload = SC_WinClose;
});

function dhcsys_getmenuform() {
    var win = top.frames['eprmenu'];
    if (win) {
        var frm = win.document.forms['fEPRMENU'];
        return frm;
    }

    var frm = parent.frames[0].document.forms["fEPRMENU"];
    if (frm) return frm
    var frm = top.document.forms["fEPRMENU"];
    return frm
}


//窗体调整大小时触发的事件
function changPanelSize() {
        var pnlHeight = parent.document.frames[0].frameElement.offsetHeight - document.getElementById("divHeader").offsetHeight;
        var pnlWidth = document.getElementById("divHeader").scrollWidth;
        if (pnlWidth > parent.document.frames[0].frameElement.offsetWidth) {
            pnlWidth = pnlWidth + 16;
            pnlHeight = pnlHeight - 17;
        }
        var pnlView = Ext.getCmp("pnlView");
        pnlView.setHeight(pnlHeight);
        pnlView.setWidth(pnlWidth);
}

//显示页面
function ShowPage() {
    var HeaderHtml = GetHeader();
    document.getElementById("divHeader").innerHTML = HeaderHtml;
    var pnlHeight = 0;
    var pnlWidth = 0;
//   if (this.parent.opener == null && parent.document.frames.length > 0) {
//        pnlHeight = parent.document.frames[0].frameElement.offsetHeight - document.getElementById("divHeader").offsetHeight;
//        pnlWidth = document.getElementById("divHeader").scrollWidth;
//        if (pnlWidth > parent.document.frames[0].frameElement.offsetWidth) {
//            pnlWidth = pnlWidth + 16;
//            pnlHeight = pnlHeight - 17;
//        }
//    }
//    else {
        pnlHeight = this.window.innerHeight - document.getElementById("divHeader").offsetHeight;
        pnlWidth = tableWidth+5;
    //}
    var pnlView = new Ext.FormPanel({
        id: 'pnlView',
        title: '',
        //width: (tableWidth+6),
        //height: '100%',
        width: pnlWidth,
        height: pnlHeight,
        autoScroll:true,
        renderTo: document.body
        });

        ShowItem();
        setWeekValue();
        Ext.select('tr[class =trInforItemHidden]').setStyle('display', 'none');
        BuildData(ClinicalData.DataArray);
        ShowPatientInfor(ClinicalData.PatientInfo);
        //ShowSeeDoctorRecord(seeDocIndex);
        //SetSeeDocLinkStyle();
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
        isLongDrug: LongDrug,
        isConmonType: ConmonType,
        isCommonDisplay:CommonDisplay
    });

    tpl.overwrite(pnlView.body, CategroyData);
    pnlView.body.dom.style.backgroundColor = "#DFE8F6";
}

//设定头部
function GetHeader() {
    var patientHtml = '<table class ="csTbPatient" border="0" cellpadding="0" cellspacing="0" style="width:' + (tableWidth + (cellCount - 3)) + 'px;" >';
    //patientHtml += '<tr class="csTrPatientContent"><td class="csTdPatientInfor"><table id="tbPatient" border="0" cellpadding="0" cellspacing="0"><tr><td style="background-color:Transparent;vertical-align:middle;"  rowspan="2"><img id="imgSex" onError="ShowDefaultImg();" src="../images/TimeLine/manNew.jpg" style="padding-top:2px;" /></td><td id="tdName" style="width:80px;color:Yellow;padding-left:10px;font-weight:bold;font-size:12pt;padding-left:12px;" rowspan="2"><div id="divName" class="csDivName" onclick="ShowPatientList();" ></div></td><td style="width:80px;font-weight:bold;color:White;">性别：</td><td id="tdSex" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">年龄：</td><td id="tdAge" style="width:110px;color:#90E4E6;"></td><td></td><td></td></tr><tr><td style="width:80px;font-weight:bold;color:White;">入院时间：</td><td id="tdInDate" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">科室：</td><td id="tdInDept" style="width:110px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">医生：</td><td id="tdPaDoctor" style="width:80px;color:#90E4E6;"></td></tr></table></td><td style="width:25px;">&nbsp;<img id="imgSetting" src="../images/TimeLine/manager.gif" class="csSetingImg" onclick="ShowSettingPage();" /></td><td style="width:15px;"><img style="cursor:hand;" src="../images/TimeLine/btnLeft.gif" onclick="MoveLeftRecord();" align="left"/></td><td><div id="divSeeDoctor" class="csSeeDoctor"><table class="csTbSeeDoctor" border="0" cellpadding="0" cellspacing="0"><tr style="height:10px;font-weight:bold;"><td colspan="7" style="width:100%;">历次住院记录</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></table></div></td><td style="width:15px;"><img style="cursor:hand;" src="../images/TimeLine/btnRight.gif" onclick="MoveRightRecord();" align="left"/></td><td style="width:2px;"><td></tr>';
    //patientHtml += '<tr class="csTrPatientContent"><td class="csTdPatientInfor"><table id="tbPatient" border="0" cellpadding="0" cellspacing="0"><tr><td style="background-color:Transparent;vertical-align:middle;"  rowspan="2"><img id="imgSex" onError="ShowDefaultImg();" src="../images/TimeLine/manNew.jpg" style="padding-top:2px;" /></td><td id="tdName" style="width:80px;color:Yellow;padding-left:10px;font-weight:bold;font-size:12pt;padding-left:12px;" rowspan="2"><div id="divName" class="csDivName" onclick="ShowPatientList();" ></div></td><td style="width:80px;font-weight:bold;color:White;">性别：</td><td id="tdSex" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">年龄：</td><td id="tdAge" style="width:110px;color:#90E4E6;"></td><td></td><td></td></tr><tr><td style="width:80px;font-weight:bold;color:White;">入院时间：</td><td id="tdInDate" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">科室：</td><td id="tdInDept" style="width:110px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">医生：</td><td id="tdPaDoctor" style="width:80px;color:#90E4E6;"></td></tr></table></td><td style="width:25px;">&nbsp;<img id="imgSetting" src="../images/TimeLine/manager.gif" class="csSetingImg" onclick="ShowSettingPage();" /></td><td style="width:15px;"></td><td></td><td style="width:15px;"></td><td style="width:2px;"><td></tr>';
    patientHtml += '<tr class="csTrPatientContent"><td class="csTdPatientInfor"><table id="tbPatient" border="0" cellpadding="0" cellspacing="0"><tr><td style="background-color:Transparent;vertical-align:middle;"  rowspan="2"><img id="imgSex" onError="ShowDefaultImg();" src="../images/TimeLine/manNew.jpg" style="padding-top:2px;" /></td><td id="tdName" style="width:80px;color:Yellow;padding-left:10px;font-weight:bold;font-size:12pt;padding-left:12px;" rowspan="2"><div id="divName" class="csDivName" ></div></td><td style="width:80px;font-weight:bold;color:White;">性别：</td><td id="tdSex" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">年龄：</td><td id="tdAge" style="width:110px;color:#90E4E6;"></td><td></td><td></td></tr><tr><td style="width:80px;font-weight:bold;color:White;">入院时间：</td><td id="tdInDate" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">科室：</td><td id="tdInDept" style="width:110px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">医生：</td><td id="tdPaDoctor" style="width:80px;color:#90E4E6;"></td></tr></table></td><td style="width:25px;">&nbsp;<img id="imgSetting" src="../images/TimeLine/manager.gif" class="csSetingImg" onclick="ShowSettingPage();" /></td><td style="width:15px;"></td><td></td><td style="width:15px;"></td><td style="width:2px;"><td></tr>';
    patientHtml += '</table>';
    var headerHtml = '<table id="tbHeaderDate" class ="csTbHeader" style="margin-top:0px;" border="0" cellpadding="0" cellspacing="1" style="width:' + tableWidth + 'px;" ><tr class="csTrDate">';
    headerHtml += '<td style="width:' + DateWidth + 'px;vertical-align:middle;background-image:url(\'../images/TimeLine/date_bg.gif\');"><table style="width:100%;height:100%;"><tr><td style="background-color:Transparent;"><img id="imgLastWeek" style="cursor:hand;" src="../images/TimeLine/Week-prev.gif" onclick="LastWeek();" align="left"/></td><td style="background-color:Transparent;"><img id="imgLastDate" style="cursor:hand;" src="../images/TimeLine/Date-prev.gif" onclick="LastDate();" align="left"/></td><td style="background-color:Transparent;vertical-align:middle;">第</td><td style="background-color:Transparent;vertical-align:middle;"><div id="'+divWeekID+'" class="csDivWeek" onclick="ShowWeeks();" >1</div></td><td style="background-color:Transparent;vertical-align:middle;">周</td><td style="background-color:Transparent;"><img id="imgNextDate" style="cursor:hand;" src="../images/TimeLine/Date-next.gif" onclick="NextDate();" align="right"/></td><td style="background-color:Transparent;"><img id="imgNextWeek" style="cursor:hand;" src="../images/TimeLine/Week-next.gif" onclick="NextWeek();" align="right"/></td></tr></table></td>';
    if (!queryDate) {
        if (SeeDoctorInfor.length > 0) {
            queryDate = SeeDoctorInfor[0].episodeDate
        }
    }
  
    var dtArr = queryDate.split("-");
    var dtSelect = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    DateValues = getDates(dtSelect);

    var count = DateValues.length;
    for (var index = 0; index < count; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index]);
        headerHtml += CreateTd(weekDate);
    }
    headerHtml += '</tr><tr class="csTrTime">';
    headerHtml += '<td style="width:' + DateWidth + 'px;font-weight:bold;background-color:#3f75b8; color:White;">时间</td>'
    var timeGridHtml = CreateTimeGrid();
    for (var index = 0; index < count; index++) {
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
    tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;"><a href="####" onclick="ShowBloodView();" dtCode="{DataTypeCode}"> {' + dataTitleAttrName + '}</a></td></tr></table></td>';
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isLongDrug(DataTypeCode)">';
    tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;"><img id="imgSetting" src="../images/TimeLine/manager.gif" class="csSetingImg" onclick="ShowDrugSettingPage();" />&nbsp;&nbsp;{' + dataTitleAttrName + '}</td></tr></table></td>';
    tbInforItemTemplate += '</tpl>';
    tbInforItemTemplate += '<tpl if="this.isConmonType(DataTypeCode)">';
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
        if (SpecialDataTypeCode[num] == "0202") {
            var txtColor = Color[0];
            th += '<td style="color:' + txtColor + ';">' + dataTypeText[num] + "</td>";
            td1 += '<td style="color:' + txtColor + ';">60</td>';
            td2 += '<td style="color:' + txtColor + ';">50</td>';
            td3 += '<td style="color:' + txtColor + ';">40</td>';
            td4 += '<td style="color:' + txtColor + ';">30</td>';
            td5 += '<td style="color:' + txtColor + ';">20</td>';
            td6 += '<td style="color:' + txtColor + ';">10</td>';
        }
        if (SpecialDataTypeCode[num] == "0203") {
            var txtColor = Color[1];
            th += '<td style="color:' + txtColor + ';">' + dataTypeText[num] + "</td>";
            td1 += '<td style="color:' + txtColor + ';">150</td>';
            td2 += '<td style="color:' + txtColor + ';">130</td>';
            td3 += '<td style="color:' + txtColor + ';">110</td>';
            td4 += '<td style="color:' + txtColor + ';">90</td>';
            td5 += '<td style="color:' + txtColor + ';">70</td>';
            td6 += '<td style="color:' + txtColor + ';">50</td>';
        }
        if (SpecialDataTypeCode[num] == "0204") {
            var txtColor = Color[2];
            th += '<td style="color:' + txtColor + ';">' + dataTypeText[num] + "</td>";
            td1 += '<td style="color:' + txtColor + ';">40</td>';
            td2 += '<td style="color:' + txtColor + ';">39</td>';
            td3 += '<td style="color:' + txtColor + ';">38</td>';
            td4 += '<td style="color:' + txtColor + ';">37</td>';
            td5 += '<td style="color:' + txtColor + ';">36</td>';
            td6 += '<td style="color:' + txtColor + ';">35</td>';
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
            var isHidden = false;
            if (tbInfor.rows[1].style.display == "none") {
                isHidden = true;
                tbInfor.rows[1].style.display = "block";
            }
                var records = oneData.records;
                var gridLine = tbInfor.rows[1].cells[1].children[0];
                var xPercent = gridLine.offsetWidth / (cellCount * 24);
                var lineArray = GetLineData(records);
                for (var num = 0; num < lineArray.length; num++) {
                    var lineColorCount = LineColor.length;
                    var lineColorIndex = num % lineColorCount;
                    var lineColor = LineColor[lineColorIndex];
                    //var arrowCss = LineArrowCss[lineColorIndex];
                    var lineData = lineArray[num];
                    var points = GetLinePoint(lineData);
                    if(points.length >0) {
                        var newRow = gridLine.insertRow(gridLine.rows.length);
                        newCell = newRow.insertCell(0);
                        var lineContainer = document.createElement("div");
                        lineContainer.className = "csLineContainer";
                        newCell.appendChild(lineContainer);
                        var config = { height: 30, topDistance: 10, lineColor: lineColor, containerX: DateWidth, widthPerUnit: xPercent, lableCss: 'csLineLabel', maxWidth: (DateWidth * cellCount) };
                        new LineShape(points, lineContainer, config);
                    }
                }
                if (isHidden) {
                    tbInfor.rows[1].style.display = "none";
                }
            }
            else if (DisplayChart(viewType)) {
                var isHidden = false;
                if (tbInfor.rows[1].style.display == "none") {
                    isHidden = true;
                    tbInfor.rows[1].style.display = "block";
                }
                var records = oneData.records;
                var divDisplayChart = tbInfor.rows[1].cells[1].children[0];
                var yData = [];
                var xData = [];
                var chartColor = GetColor(oneData.DataTypeCode);
                var pointStyle = GetPointStyle(oneData.DataTypeCode);
                var chartHeight = divDisplayChart.offsetHeight;
                var yMaxValue = GetYMaxValue(oneData.DataTypeCode);
                var ySartValue = GetYSartValue(oneData.DataTypeCode);
                var xPercent = divDisplayChart.offsetWidth / (cellCount * 24);
                var config = { height: chartHeight, maxHeight: yMaxValue, startHeight: ySartValue, barDistance: xPercent, leftDistance: 0, pointColor: chartColor, lineColor: chartColor, valueColor: chartColor, containerX: DateWidth, pointCss: pointStyle };
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    xData.push(GetTimeValue(oneRecord.ActDate, oneRecord.ActTime));
                    yData.push(oneRecord.DataValue);
                }
                var data = new period(yData, xData);
                new gov.Graphic(data, divDisplayChart.id, config);
                if (isHidden) {
                    tbInfor.rows[1].style.display = "none";
                }
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
                var xPoint = GetTimeValue(lineData.startDate, lineData.startTime);
                isStart = true;
                isEnd = false;
                noEnd = false;
                var lblValue = lineData.DataValue +"|"+lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }

            if (eDate >= showSDate && eDate <= showEDate) {
                var xPoint = GetTimeValue(lineData.endDate, lineData.endTime);
                isEnd = true;
                isStart = false;
                noEnd = false;
                var lblValue = lineData.DataValue + "|" + lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }

            if (sDate < showSDate && eDate > showEDate) {
                var xPoint = 0;
                var lblValue = lineData.DataValue + "|" + lineData.Summary;
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
                var xPoint = GetTimeValue(lineData.startDate, lineData.startTime);
                isStart = true;
                var lblValue = lineData.DataValue + "|" + lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }
            var today = ConvertToDateValue(DateNowServer);
            if (showEDate > today) {
                var xPoint = GetTimeValue(formatDate(today), "23:00");
                isStart = false;
                isEnd = true;
                var lblValue = lineData.DataValue + "|" + lineData.Summary;
                var point = new LinePoint(xPoint, lblValue, isStart, isEnd, noEnd);
                points.push(point);
            }
            if (sDate < showSDate && today >= showEDate) {
                var xPoint = 0;
                var lblValue = lineData.DataValue + "|" + lineData.Summary;
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
        if (drugNameList != null && oneData.CategroyCode=="06")
        {
            var selectDrugs = drugNameList.split("|");
            var flg = false;
            for (var n = 1; n < selectDrugs.length; n++) {
                var oneDrug = selectDrugs[n];
                if (oneData.DataValue.indexOf(oneDrug) > -1) {
                    var flg = true;
                    break;
                }
            }
            if (!flg) {
                continue;
            }
        }
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
    //检查检验
    if (cateCode == "04" || cateCode == "05") {
        var inforArray = record.linkDatas;
        var summary = record.Summary;
        var showRed = false;
        if (cateCode == "05") {
            var flg = summary.split("^")[1];
            summary = summary.split("^")[0];
            if (flg == "1") {
                showRed = true;
            }
        }
        var inforHtml = summary + "<br />";
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
        //var summary = record.Summary;
        if (summary.length > txtLength) {
            summary = summary.substr(0, txtLength) + "...";
        }
        if (cateCode == "05") {
            return CreateColorAlignLink(summary, inforHtml, gridCellIndex, linkPath, cateCode, showRed);
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    //临床评估
    else if (cateCode == "01") {
        linkPath += "?episodeId=" + episodeId + "&PatientID=" + patientID;
        var summary = record.Summary;
        if (summary == "") {
            return "";
        }
        var inforHtml = "";
        if (record.Summary.length > 8) {
           summary = summary.substr(0, 8) + "...";
            var inforHtml = escape(record.Summary);
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
    if (!time) return 0;

    var timeValue = parseInt(time.split(":")[0], 10);
    var miValue = parseInt(time.split(":")[1],10);
    var timeCount = 24 / TimeSplit;
    for (var index = 1; index < timeCount + 1; index++) {
        var startIndex = (index - 1) * TimeSplit;
        var endIndex = index * TimeSplit;
        if ((startIndex <= timeValue) && (timeValue < endIndex)) {
            return index-1;
        }
    }
    
    //var index = parseInt(timeValue/TimeSplit,10);
    //var mod = timeValue%TimeSplit;
//    if (mod == 0) {
//        if (miValue > 0 && index > 0) {
//            index = index + 1;
//        }
//    }
    return 1;
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

//判断是否是是长期药品医嘱
function LongDrug(dataTypeCode) {
    if (dataTypeCode == "0601") {
        return true;
    }
    else {
        return false;
    }
}

//判断是否是普通类型
function ConmonType(dataTypeCode) {
    if (dataTypeCode != "0306" && dataTypeCode != "0601") {
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
    if (code == "0202") {
        return PointCSS[0];
    }
    else if (code == "0203") {
    return PointCSS[1];
    }
    else if (code == "0204") {
    return PointCSS[2];
    }
    return "";
}

//取得颜色值
function GetColor(code) {
    if (code == "0202") {
        return Color[0];
    }
    else if (code == "0203") {
        return Color[1];
    }
    else if (code == "0204") {
        return Color[2];
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
    var dtArr = DateValues[0].split("-");
    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtLast.setDate(parseInt(dtArr[2], 10) - 7);
    var startDate = GetStartDate()
    if (dtLast < startDate) {
        dtLast = startDate;
    }
    DateValues = getDates(dtLast);
    var searchDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': searchDate };
    SubmitForm("pnlView", actionParams);
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
    var searchDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': searchDate };
    SubmitForm("pnlView", actionParams);
}

//日期向前移动一天
function LastDate() {
    var dtArr = DateValues[0].split("-");
    var dtLast = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtLast.setDate(parseInt(dtArr[2], 10) - 1);
    DateValues = getDates(dtLast);
    var searchDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': searchDate };
    SubmitForm("pnlView", actionParams);
}

//日期向后移动一天
function NextDate() {
    var dtArr = DateValues[0].split("-");
    var dtNext = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    dtNext.setDate(parseInt(dtArr[2], 10) + 1);
    DateValues = getDates(dtNext);
    var searchDate = DateValues[0];
    setWeekValue();
    var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': searchDate };
    SubmitForm("pnlView", actionParams);
}

//向左移动就诊记录
function MoveLeftRecord() {
    var count = SeeDoctorInfor.length;
    if ((seeDocIndex - 7) >= 0) {
        seeDocIndex = seeDocIndex - 7;
        ShowSeeDoctorRecord(seeDocIndex);
        //SetSeeDocLinkStyle();
    }
}

//向右移动就诊记录
function MoveRightRecord() {
    var count = SeeDoctorInfor.length;
    if ((seeDocIndex + 7) < count) {
        seeDocIndex = seeDocIndex + 7;
        ShowSeeDoctorRecord(seeDocIndex);
        //SetSeeDocLinkStyle();
    }
}

//显示就诊记录
function ShowSeeDoctorRecord(index) {
    var tbSeeDoc = document.getElementById("divSeeDoctor").children[0];
    var count = SeeDoctorInfor.length;
    tbSeeDoc.rows[1].cells[0].innerHTML = "";
    tbSeeDoc.rows[1].cells[1].innerHTML = "";
    tbSeeDoc.rows[1].cells[2].innerHTML = "";
    tbSeeDoc.rows[1].cells[3].innerHTML = "";
    tbSeeDoc.rows[1].cells[4].innerHTML = "";
    tbSeeDoc.rows[1].cells[5].innerHTML = "";
    tbSeeDoc.rows[1].cells[6].innerHTML = "";
    if(index < count)
    {
        tbSeeDoc.rows[1].cells[0].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index]);
    }
    if ((index + 1) < count) {
        tbSeeDoc.rows[1].cells[1].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index+1]);
    }
    if ((index + 2) < count) {
        tbSeeDoc.rows[1].cells[2].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index+2]);
    }
    if ((index + 3) < count) {
        tbSeeDoc.rows[1].cells[3].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 3]);
    }
    if ((index + 4) < count) {
        tbSeeDoc.rows[1].cells[4].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 4]);
    }
    if ((index + 5) < count) {
        tbSeeDoc.rows[1].cells[5].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 5]);
    }
    if ((index + 6) < count) {
        tbSeeDoc.rows[1].cells[6].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 6]);
    }
}

//创建就诊记录的link
function CreateSeeDocLink(infor) {
    return '<a type="link" href="####" onclick="ChangeInfor();" inforId="'+ infor.episodeId + '" >' + infor.episodeDate + '</a>';
}

//切换就诊记录
function ChangeInfor() {
    episodeId = event.srcElement.inforId;
    var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': '','changeEpisodeId':'1'};
    SubmitFormChangeEpisodeId("pnlView", actionParams);
}


//清除页面中的数据
function ClearRecord() {
    var tbDate = document.getElementById("tbHeaderDate");
    var count = DateValues.length;
    for (var index = 1; index < count + 1; index++) {
        var weekDate = GetDateAndWeekDay(DateValues[index-1]);
        tbDate.rows[0].cells[index].innerHTML = weekDate;
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
        OpenNewPage(path, 980, 620, "诊断记录");
    }
    else if (cateCode == "10") {
        OpenNewPage(path, 990, 600, "临床路径");
    }
    else if (cateCode == "04" || cateCode == "05") {
        ShowReportInfor(path, 990, 620, "报告");
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
    newWindow.center();
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

//切换日期获取数据
function SubmitForm(frmName, actionParams) {
    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在获取数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            ClinicalData.searchDate = action.result.searchDate;
            ClinicalData.EndDate = action.result.EndDate;
            ClinicalData.DataArray = action.result.DataArray;
            ClinicalData.StartDate = action.result.StartDate;
            ClinicalData.PatientInfo = action.result.PatientInfo;
            ClearRecord();
            BuildData(ClinicalData.DataArray);
            ShowPatientInfor(ClinicalData.PatientInfo);
            //SetSeeDocLinkStyle();
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

//切换日期获取数据
function SubmitFormChangeEpisodeId(frmName, actionParams) {
    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在获取数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            drugNameList = null;
            ClinicalData.searchDate = action.result.searchDate;
            var selectDate = ClinicalData.searchDate;
            if (selectDate == "") {
                selectDate = GetSelectDate();
            }
            var dtArr = selectDate.split("-");
            selectDate = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
            DateValues = getDates(selectDate);
            ClinicalData.DataArray = action.result.DataArray;
            ClinicalData.EndDate = action.result.EndDate;
            ClinicalData.StartDate = action.result.StartDate;
            ClinicalData.PatientInfo = action.result.PatientInfo;
            setWeekValue();
            ClearRecord();
            BuildData(ClinicalData.DataArray);
            ShowPatientInfor(ClinicalData.PatientInfo);
            //SetSeeDocLinkStyle();
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

//取得选择的就诊日期
function GetSelectDate() {
    var linkArray = document.getElementById("divSeeDoctor").getElementsByTagName("a");
    for (var i = 0; i < linkArray.length; i++) {
        var oneLink = linkArray[i];
        if (oneLink.inforId == episodeId) {
            return oneLink.innerText;
        }
    }
    return "";
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

//创建带颜色可对齐的Link
function CreateColorAlignLink(txt, infor, cellIndex, linkPath, cateCode,colorFlg) {
    var gridHtml = CreateAlignGridHtml(cellIndex);
    var color = "color:#18704e;";
    if (colorFlg) {
        color = "color:Red;";
    }
    var linkHtml = "";
    if (infor == "") {
        linkHtml = '<div class="csNoColorDivLink" style="width:' + (DateWidth - 4) + 'px;' + color + '" isLink="1" onmouseover="ChangeStyle(1);" onmouseout="ChangeStyle(0);" onclick="ShowReport();" infor="' + infor + '"   linkPath="' + linkPath + '" cateCode="' + cateCode + '">' + txt + '</div>';
    }
    else {
        linkHtml = '<div class="csNoColorDivLink" style="width:' + (DateWidth - 4) + 'px;' + color + '" isLink="1" onmouseover="ShowInfor();" onmouseout="HiddenInfor();" onclick="ShowReport();" infor="' + infor + '"  linkPath="' + linkPath + '" cateCode="' + cateCode + '">' + txt + '</div>';
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
    for (var index = 0; index < timeCount ; index++) {
        if (index == cellIndex) {
            gridHtml += '<td class="csAlignGridTd" style="width:' + tdWidth + 'px;"></td>';
        }
        else {
            gridHtml += '<td  style="width:' + tdWidth + 'px;" ></td>';
        }
    }
    gridHtml += "</tr></table>";
    return gridHtml;
}

//设定日期移动按钮的状态
function SetButtonState() {
    var starDate = GetStartDate();
    var endDate = GetEndDate();
    var dtMaxArry = DateValues[DateValues.length-1].split("-");
    var dtMinArry = DateValues[0].split("-");
    var maxDate = new Date(dtMaxArry[0], parseInt(dtMaxArry[1], 10) - 1, dtMaxArry[2]);
    var minDate = new Date(dtMinArry[0], parseInt(dtMinArry[1], 10) - 1, dtMinArry[2]);
    if (!endDate || maxDate >= endDate) {
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
    if (!starDate || minDate <= starDate) {
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
function GetStartDate() {
    if (ClinicalData.StartDate != "") {
        var startDateArry = ClinicalData.StartDate.split("-");
        var starDate = new Date(startDateArry[0], parseInt(startDateArry[1], 10) - 1, startDateArry[2]);
        return starDate;
    }
    else {
        return null;
    }
}

//取得就诊结束日
function GetEndDate() {
    if (ClinicalData.EndDate != "") {
        var endDateArry = ClinicalData.EndDate.split("-");
        var endDate = new Date(endDateArry[0], parseInt(endDateArry[1], 10) - 1, endDateArry[2]);
        return endDate;
    }
    else {
        return null;
    }
}

//显示血压的趋势图
function ShowBloodView() {
    var path = "TimeLine/bloodpressureview.csp?dataTypeCode=" + event.srcElement.dtCode + "&episodeId=" + episodeId + "&startDate=" + ClinicalData.searchDate;
    OpenNewPage(path, 980, 278,"血压趋势图");
}

//显示病人信息
function ShowPatientInfor(patientInfor) {
    //document.getElementById("divName").innerHTML = patientInfor.name;
    document.getElementById("tdName").innerHTML = patientInfor.name;
    document.getElementById("tdSex").innerHTML = patientInfor.sex;
    if (patientInfor.sex == "男") {
        document.getElementById("imgSex").isMan = true;
    }
    else {
        document.getElementById("imgSex").isMan = false;
    }
    document.getElementById("tdAge").innerHTML = patientInfor.age.split("岁")[0] + "岁";
    var inDate = patientInfor.inDate;
    if (inDate != "") {
        var dtArr = inDate.split("-");
        document.getElementById("tdInDate").innerHTML = dtArr[0] + "年" + dtArr[1] + "月" + dtArr[2] + "日";
    }
    else {
        document.getElementById("tdInDate").innerHTML = patientInfor.inDate;
    }
    document.getElementById("tdInDept").innerHTML = patientInfor.inDept;
    document.getElementById("tdPaDoctor").innerHTML = patientInfor.paDoctor;
    //ShowPicByPatientID();
    ShowDefaultImg();
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
    if (event.srcElement.id != divWeekID) {
        var divWeekMenu = document.getElementById(divWeekMenuID);
        if (divWeekMenu) {
            divWeekMenu.parentElement.removeChild(divWeekMenu);
        }
    }
    if (event.srcElement.id != "divName") {
        var divPatientList = document.getElementById(divPatientListID);
        if (divPatientList) {
            divPatientList.parentElement.removeChild(divPatientList);
        }
    }
}

//生成数据
function GenerateData() {
    var divMenuItem = document.getElementById("divMenu");
    divMenuItem.style.display = "none";
    var actionParams = { 'episodeId': episodeId, 'actionCode': 'GenerateData' };
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

//设定当前选中的就诊连接的样式
function SetSeeDocLinkStyle() {
    var linkArray = document.getElementById("divSeeDoctor").getElementsByTagName("a");
    for (var i = 0; i < linkArray.length; i++) {
        var oneLink = linkArray[i];
        if (oneLink.inforId == episodeId) {
            oneLink.className = "csSeeDocLinkSeleted";
        }
        else {
            oneLink.className = "";
        }
    }
}

//显示就诊周列表
function ShowWeeks() {
    if(ClinicalData)
    {
        var startDate = GetStartDate();
        var endDate = GetEndDate();
        if (startDate != null && endDate != null) {
            var days = parseInt(Math.abs(endDate - startDate) / 1000 / 60 / 60 / 24,10);
            var weeks = parseInt(days / 7,10);
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
    if (event.srcElement.tagName == "LI") {
        if (mouseFlg == "0") {
            event.srcElement.className = "csMenuItem";
        }
        else {
            event.srcElement.className = "csMenuMouseOut";
        }
    }
    else {
        if (event.srcElement.tagName == "DIV") {
            if (mouseFlg == "0") {
                event.srcElement.className = "csMenuItem";
            }
            else {
                event.srcElement.className = "csMenuMouseOut";
            }
        }
        else {
            var parentCtrl = event.srcElement.parentElement;
            while (parentCtrl.tagName != "DIV") {
                parentCtrl = parentCtrl.parentElement;
            }
            if (mouseFlg == "0") {
                parentCtrl.className = "csMenuItem";
            }
            else {
                parentCtrl.className = "csMenuMouseOut";
            }
        }
    }
}

//切换周
function ChangeWeek() {
    var selectWeek = parseInt(event.srcElement.innerText,10);
    var nowWeek = parseInt(document.getElementById(divWeekID).innerText, 10);
    var divWeekMenu = document.getElementById(divWeekMenuID);
    if (divWeekMenu) {
        divWeekMenu.parentElement.removeChild(divWeekMenu);
    }
    if(selectWeek != nowWeek)
    {
        document.getElementById(divWeekID).innerText = selectWeek;
        var searchDate ="";
        if (selectWeek == 1) {
            searchDate = ConvertToDateValue(ClinicalData.StartDate);
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
        var actionParams = { 'queryCode': queryCode, 'episodeId': episodeId, 'startDate': searchDate };
        SubmitForm("pnlView", actionParams);
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


//取得病人列表数据
function GetPatientList() {
    var actionParams = { 'actionCode': 'GetPatientList' };
    Ext.Ajax.request({
        url: accessURL,
        success: GetPatientListSuccess,
        failure: null,
        params: actionParams
    });
}
//取得病人列表数据成功
function GetPatientListSuccess(resp, opts) {
    var result = Ext.util.JSON.decode(resp.responseText);
    PatientList = result.PatientList;
}

//显示病人列表菜单
function ShowPatientList() {
    var aParams = location.search;
    if (PatientList != null && aParams.indexOf("PageName") < 0) {
        var divPatientMenu = document.createElement("div");
        divPatientMenu.id = divPatientListID;
        var menuHtml = "<ul>";
        for (var index = 0; index < PatientList.length; index++) {
            var nameCount = PatientList[index].PAPMIName.length;
            var name = PatientList[index].PAPMIName;
            for (var n = nameCount; n <= 5; n++) {
                name = name + "&nbsp;";
            }
            menuHtml = menuHtml + '<div episodeID="' + PatientList[index].EpisodeID + '" patientID="' + PatientList[index].PatientID + '" mradm="' + PatientList[index].mradm + '" class="csMenuItem" onclick="ChangePatient();" onmouseover="SetMenuStyle(1);" onmouseout="SetMenuStyle(0);"><table><tr><td style="width:40px;">' + PatientList[index].PAAdmBed + '床</td><td style="width:80px;">&nbsp;&nbsp;' + name + '</td></tr></table></div>';
            //menuHtml = menuHtml + "<li episodeID='" + PatientList[index].EpisodeID + "' patientID='" + PatientList[index].PatientID + "' class='csMenuItem' onclick='ChangePatient()' onmouseover='SetMenuStyle(1);' onmouseout='SetMenuStyle(0);'>&nbsp;&nbsp;" + name + "&nbsp;&nbsp;&nbsp;" + PatientList[index].PAAdmWard + "&nbsp;&nbsp;&nbsp;" + PatientList[index].PAAdmBed + "床</li>";
            //menuHtml = menuHtml + "<li episodeID='" + PatientList[index].EpisodeID + "' patientID='" + PatientList[index].PatientID + "' class='csMenuItem' onclick='ChangePatient()' onmouseover='SetMenuStyle(1);' onmouseout='SetMenuStyle(0);'>&nbsp;&nbsp;" + name + "</span><span style='style='padding-right:5px;'>" + PatientList[index].PAAdmBed + "床</span></li>";
        }
        enuHtml = menuHtml + "</ul>";
        divPatientMenu.className = "csPatientMenu";
        divPatientMenu.style.top = (findPosY(event.srcElement) + 23) + "px";
        divPatientMenu.style.left = findPosX(event.srcElement) + "px";
        if (PatientList.length > 20) {
            divPatientMenu.style.height = "400px";
            divPatientMenu.style.width = "140px";
        }
        divPatientMenu.innerHTML = menuHtml;
        document.body.appendChild(divPatientMenu);
    }
}

//切换病人
function ChangePatient() {
    var ctrl = event.srcElement;
    while (ctrl.tagName != "DIV") {
        ctrl = ctrl.parentElement;
    }
    var Params = getUrlParam();
    var changePatientID = ctrl.patientID;
    var episodeID = ctrl.episodeID;
    var mradm = ctrl.mradm;
    var address = location.href.split('?')[0];
    if (Params.length > 0) {
        address = address + "?";
        for (var index = 0; index < Params.length; index++) {
            var oneParam = Params[index];
            if (oneParam.Key == "EpisodeID") {
                oneParam.Value = episodeID;
            }
            else if (oneParam.Key == "PatientID") {
                oneParam.Value = changePatientID;
            }
            else if (oneParam.Key == "mradm") {
                oneParam.Value = mradm;
            }
            if (index > 0) {
            address = address +"&"
            }
            address = address + oneParam.Key + "=" + oneParam.Value;
        }
    }
    location.href = address;
}

//显示设置页面
function ShowSettingPage() {
    var newHref = location.href.replace("&SettingFlg=1", "");
    newHref = newHref.replace("####", "");
    location.href = newHref + "&SettingFlg=1";
}

//显示药品设定界面
function ShowDrugSettingPage() {
    var path = "TimeLine/drugconfig.csp?EpisodeID=" + episodeId;
    OpenNewPage(path, 600, 500, "设定显示药品");
}

//设定显示的药品
function SetShowDrug(drugList, flg) {
    Ext.getCmp("newWindow").close();
    if (drugNameList == null && !flg) {
        return;
    }
    else if (drugNameList != drugList) {
        drugNameList = drugList;
        ShowDrug(ClinicalData.DataArray);
    }
}

//重新显示长期药品
function ShowDrug(dataArray) {
    //清除数据
    var InforTableArray = Ext.select('table[class =csTbInforItem]').elements;
    var tableCount = InforTableArray.length;
    for (var num = 0; num < tableCount; num++) {
        var oneTable = InforTableArray[num];
        var viewType = oneTable.ViewType;
        if (DisplayLine(viewType)) {
            var gridHtml = CreateLineGridHtml();
            var inforCell = oneTable.rows[1].cells[1];
            inforCell.innerHTML = gridHtml;
        }
    }
    
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
            if (DisplayLine(viewType)) {
                var isHidden = false;
                if (tbInfor.rows[1].style.display == "none") {
                    isHidden = true;
                    tbInfor.rows[1].style.display = "block";
                }
                var records = oneData.records;
                var gridLine = tbInfor.rows[1].cells[1].children[0];
                var xPercent = gridLine.offsetWidth / (cellCount * 24);
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
                        var config = { height: 30, topDistance: 10, lineColor: lineColor, containerX: DateWidth, widthPerUnit: xPercent, lableCss: 'csLineLabel', maxWidth: (DateWidth * cellCount) };
                        new LineShape(points, lineContainer, config);
                    }
                }
                if (isHidden) {
                    tbInfor.rows[1].style.display = "none";
                }
            }
        }
    }
}

//显示病人图片按钮ID
function ShowPicByPatientID() {
    var picType = ".jpg";
    //var src="ftp://10.160.16.112/picture/"+ patientID + picType;
    var src = "ftp://administrator:123456@10.72.16.158:21/picture/" + patientID + picType;
    document.getElementById("imgSex").src = src;
    document.getElementById("imgSex").style.height = "50px";
}

//图片不存在时显示默认图片
function  ShowDefaultImg() {
    var imgCtrl = document.getElementById("imgSex");
    if (imgCtrl.isMan) {
        imgCtrl.src = "../images/TimeLine/manNew.jpg";
    }
    else {
        imgCtrl.src = "../images/TimeLine/womanNew.jpg";
    }
    imgCtrl.style.height = "";
    imgCtrl.style.width = "50px";
}

//关闭画面
function SC_WinClose() {
    if (SC_CHILD_WINDOW != null) {
        SC_CHILD_WINDOW.close();
        SC_CHILD_WINDOW = null;
    }
}

//设定当前选中的病人
function SetSelectPatient() {
    if (top.frames.length > 0) {
        var Params = getUrlParam();
        var frm = dhcsys_getmenuform();
        var frmEpisodeID = frm.EpisodeID;
        var frmPatientID = frm.PatientID;
        var frmmradm = frm.mradm;
        if (Params.length > 0) {
            for (var index = 0; index < Params.length; index++) {
                var oneParam = Params[index];
                if (oneParam.Key == "EpisodeID") {
                    frmEpisodeID.value = oneParam.Value;
                }
                else if (oneParam.Key == "PatientID") {
                    frmPatientID.value = oneParam.Value;
                }
                else if (oneParam.Key == "mradm") {
                    frmmradm.value = oneParam.Value;
                }
            }
        }
    }
}

//<========================================================
//start :报告显示相关函数
//<========================================================
function ShowReportInfor(url, winWidth, winHeight, title) {
    SelectReportItem = event.srcElement.parentElement;
    var lastDisabled = false;
    var nextDisabled = false;
    if (SelectReportItem.previousSibling == null) {
        lastDisabled = true;
    }
    if (SelectReportItem.nextSibling == null) {
        nextDisabled = true;
    }
    var btnLast = new Ext.Button({
        id: "btnLast",
        text: "上一个",
        disabled: lastDisabled,
        handler: LastReport
    });
    var btnNext = new Ext.Button({
        id: "btnNext",
        text: "下一个",
        disabled: nextDisabled,
        handler: NextReport
    });
    var iframe = Ext.DomHelper.createHtml({
        tag: 'iframe',
        name: 'iframename',
        src: url,
        width: "100%",
        height: "100%"

    });
    var winReport = new Ext.Window({
        id: "winReport",
        title: title,
        modal: true,
        width: winWidth,
        height: winHeight,
        maximizable: true,
        closable: true,
        x: 10,
        y: 10,
        html: iframe,
        buttons: [btnLast, btnNext]
    });
    winReport.show();
    winReport.center();
}

//上一个报表
function LastReport() {
    SelectReportItem = SelectReportItem.previousSibling;
    var divItem = SelectReportItem.children[1];
    var path = divItem.linkPath;
    Ext.getCmp("winReport").body.dom.children[0].src = path;
    if (SelectReportItem.previousSibling == null) {
        Ext.getCmp("btnLast").disable();
    }
    else {
        Ext.getCmp("btnLast").enable();
    }
    if (SelectReportItem.nextSibling == null) {
        Ext.getCmp("btnNext").disable();
    }
    else {
        Ext.getCmp("btnNext").enable();
    }
}

//下一个报表
function NextReport() {
    SelectReportItem = SelectReportItem.nextSibling;
    var divItem = SelectReportItem.children[1];
    var path = divItem.linkPath;
    Ext.getCmp("winReport").body.dom.children[0].src = path;
    if (SelectReportItem.previousSibling == null) {
        Ext.getCmp("btnLast").disable();
    }
    else {
        Ext.getCmp("btnLast").enable();
    }
    if (SelectReportItem.nextSibling == null) {
        Ext.getCmp("btnNext").disable();
    }
    else {
        Ext.getCmp("btnNext").enable();
    }
}
//========================================================>
//end :报告相关函数
//========================================================>