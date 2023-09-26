//显示的单元格数
var cellCount =7;
//每个日期对应的单元格的宽度
var DateWidth = 144;
//每一天按几小时分成一个时间段
var TimeSplit = 4;
//每个信息项表的宽度
var tableWidth = DateWidth * (cellCount+1) + cellCount;
//显示的就诊ID日期集合
var EpisodeValues = null;
//ajax访问的地址
var accessURL = "TimeLine/extgetoutpatientdata.csp";
//特殊方式显示的数据类型代码
var SpecialDataTypeCode = null;
//是否有特殊显示的数据
var haveSpecialDisplay = false;
//弹出div显示框的Id
var divInforID = "divInfor";
var Color = ["#ff9900", "#cc0000","#0f77e2", "#5AAD22"];
var LineColor = ["#0b3281", "#db6a0f", "#cc0000", "#5AAD22"];
//点的样式
var PointCSS = ["csPointTriangle", "csPointCircle", "csPointCross"];
//每行显示的文本的最多字数
var txtLength = 10;
//行头的背景颜色
var rowHeaderColor = "#ddeef8;color:#132456";
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
    GetPatientList();
    ShowPage();
    ForbidBlowup();
    if (this.parent.opener == null) {
        window.onresize = changPanelSize;
    }
    SetSelectPatient();
    ShowInHospital();
    window.onunload = SC_WinClose;
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
// add cryze 2018-3-24
function myTrim(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}
// add cryze 2018-3-24
//字符串截取 str 原字符串 maxlen 最大长度  英文算0.5
function formatTextByTxtLength(str,maxlen){
	str=myTrim(str);
	var strLen=str.length;
	if (maxlen>=strLen) return str;
	var tempLen=0,subLen=0;
	for (var i = 0; i < strLen; i++) {
       var code = str.charCodeAt(i);
       if(code>=0&&code<=128) {
	       tempLen+=1;
	   }else{
		   tempLen+=2;
	   }

       if (tempLen> 2*maxlen-2 && subLen==0 ) subLen=i;    //第一次超出2*maxlen-2 记住位置 若最终超出 则取此位置截取
       if (tempLen> 2*maxlen) {
	       return str.substr(0,subLen)+"...";
       }
       
    }
    return str;
}
/*2017-4-7*/
function getSize(){
	try{ 
	   if (parent.opener == null && parent.document.frames.length > 0) {
			pnlHeight = parent.document.frames[0].frameElement.offsetHeight - document.getElementById("divHeader").offsetHeight;
			pnlWidth = document.getElementById("divHeader").scrollWidth;
			if (pnlWidth > parent.document.frames[0].frameElement.offsetWidth) {
				pnlWidth = pnlWidth + 16;
				pnlHeight = pnlHeight - 17;
			}
		}else {
			pnlHeight = this.window.innerHeight - document.getElementById("divHeader").offsetHeight;
			pnlWidth = tableWidth+5;
		}
	}catch(e){
		pnlHeight = this.window.innerHeight - document.getElementById("divHeader").offsetHeight;
		pnlWidth = tableWidth+5;
	}
	/**wanghc 2017-4-7 ie下有时高度为0**/
	if (pnlHeight<300){
		pnlHeight = document.documentElement.clientHeight - document.getElementById("divHeader").offsetHeight;
	}
	if ((pnlWidth<300) || (pnlWidth>1100)){
		pnlWidth = document.documentElement.clientWidth;
	}
	return {height:pnlHeight,width:pnlWidth};
}
//窗体调整大小时触发的事件
function changPanelSize() {   
    var obj = getSize(pnlHeight, pnlWidth);
    var pnlView = Ext.getCmp("pnlView");
    var sizeObj = getSize();
    pnlView.setHeight(sizeObj.height);
    pnlView.setWidth(sizeObj.width);
}
//显示页面
function ShowPage() {
    var HeaderHtml = GetHeader();
    document.getElementById("divHeader").innerHTML = HeaderHtml;
	var sizeObj = getSize();
    var pnlView = new Ext.FormPanel({
        id: 'pnlView',
        title: '',
        width: sizeObj.width,
        height: sizeObj.height,
        autoScroll:true,
        renderTo: document.body
    });
    pnlView.addClass("csOutPatientPanel");
    ShowItem();
    Ext.select('tr[class =trInforItemHidden]').setStyle('display', 'none');
    BuildData(ClinicalData.DataArray);
    ShowPatientInfor(ClinicalData.PatientInfo);
    Ext.select('tr[class =trInforItemHidden]').setStyle('display', 'none');
}

//<========================================================
//start :头部显示相关
//<========================================================
//设定头部
    function GetHeader() {
    var patientHtml = '<table class ="csTbPatient" border="0" cellpadding="0" cellspacing="0" style="width:' + (tableWidth + (cellCount - 3)) + 'px;" >';
    patientHtml += '<tr class="csTrPatientContent"><td class="csTdPatientInfor"><table id="tbPatient" border="0" cellpadding="0" cellspacing="0"><tr><td style="background-color:Transparent;vertical-align:middle;width:60px;"><img id="imgSex" onError="ShowDefaultImg();" src="../images/TimeLine/manNew.jpg" style="padding-top:2px;" /></td><td id="tdName" style="width:80px;padding-left:10px;font-weight:bold;font-size:12pt;padding-left:12px;color:Yellow;text-align:center;"><div id="divName" class="csDivName" onclick="ShowPatientList();" ></div></td><td style="width:55px;font-weight:bold;color:White;">病人ID：</td><td id="tdPatientID" style="width:70px;color:#90E4E6;text-align:left;"></td><td style="width:50px;font-weight:bold;color:White;">性别：</td><td id="tdSex" style="width:30px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">年龄：</td><td id="tdAge" style="width:40px;color:#90E4E6;"></td><td style="width:60px;font-weight:bold;color:White;">病案号：</td><td id="tdPatientNo" style="width:100px;color:#90E4E6;text-align:left;"></td><td></td></tr></table></td><td style="width:25px;">&nbsp;<img id="imgSetting" src="../images/TimeLine/manager.gif" class="csSetingImg" onclick="ShowSettingPage();" /></td><td style="width:15px;"></td><td></td><td style="width:15px;"></td><td style="width:80px;"><div id="divInHospitalView"></div><td></tr>';
    patientHtml += '</table>';
    var headerHtml = '<table id="tbHeaderDate" class ="csTbHeader" border="0" cellpadding="0" cellspacing="1" style="width:'+ tableWidth + 'px;" ><tr class="csTrDate">';
    headerHtml += '<td style="width:' + DateWidth + 'px;vertical-align:middle;background-image:url(\'../images/TimeLine/date_bg.gif\');"><table style="width:100%;height:100%;"><tr><td style="background-color:Transparent;"><img id="imgLastWeek" style="cursor:hand;" src="../images/TimeLine/Week-prev.gif" onclick="LastWeek();" align="left"/></td><td style="background-color:Transparent;"><img id="imgLastDate" style="cursor:hand;" src="../images/TimeLine/Date-prev.gif" onclick="LastDate();" align="left"/></td><td style="background-color:Transparent;vertical-align:middle;">日期</td><td style="background-color:Transparent;"><img id="imgNextDate" style="cursor:hand;" src="../images/TimeLine/Date-next.gif" onclick="NextDate();" align="right"/></td><td style="background-color:Transparent;"><img id="imgNextWeek" style="cursor:hand;" src="../images/TimeLine/Week-next.gif" onclick="NextWeek();" align="right"/></td></tr></table></td>';
    EpisodeValues = getEpisodeValues();
    var count = 0;
    if (EpisodeValues != null) {
        count = EpisodeValues.length;
    }
    for (var index = 0; index < count; index++) {
        var weekDate = GetDateAndWeekDayHour(EpisodeValues[index]);
        //console.log(weekDate);
        weekDate=formatDateByConfig(weekDate);
        headerHtml += CreateTd(weekDate);
    }
    while (count < cellCount) {
        headerHtml += CreateTd("");
        count = count + 1;
    }
    headerHtml += '</tr><tr class="csTrTime">';
    headerHtml += '<td style="width:' + DateWidth + 'px;font-weight:bold;background-color:#3f75b8; color:White;">时间</td>'
    var timeGridHtml = CreateTimeGrid();
    for (var index = 0; index < cellCount; index++) {
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

//取得日期和周几
function GetDateAndWeekDayHour(episodeValue) {
    var lstEpisode = ClinicalData.EpisodeList;
    var nowEpisode = null;
    for (var index = 0; index < lstEpisode.length; index++) {
        if(lstEpisode[index].EpisodeID == episodeValue) {
            nowEpisode = lstEpisode[index];
            break;
        }
    }
    if (nowEpisode == null) {
        return "";
    }
    var dateTxt = nowEpisode.ActDate;
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
    var hourTxt = nowEpisode.ActTime;
    var hour = parseInt(hourTxt.split(":")[0],10);
    var timeTxt = "";
    if (hour <= 5) {
        timeTxt = "凌";
    }
    else if (hour <= 12) {
        timeTxt = "上";
    }
    else if (hour <= 18) {
        timeTxt = "下";
    }
    else {
        timeTxt = "晚";
    }
    return dateTxt + "&nbsp" + weekDayTxt + "&nbsp" + timeTxt+(nowEpisode.PAADMType=="E"?"&nbsp[急]":"");
}

//显示病人信息
function ShowPatientInfor(patientInfor) {
    if (patientInfor) {
        document.getElementById("divName").innerHTML = patientInfor.name;
        //document.getElementById("tdName").innerHTML = patientInfor.name;
        document.getElementById("tdSex").innerHTML = patientInfor.sex;
        if (patientInfor.sex == "男") {
            document.getElementById("imgSex").isMan = true;
        }
        else {
            document.getElementById("imgSex").isMan = false;
        }
        document.getElementById("tdAge").innerHTML = patientInfor.age; // .split("岁")[0] + "岁";
        document.getElementById("tdPatientNo").innerHTML = patientInfor.recordNo;
        document.getElementById("tdPatientID").innerHTML = patientInfor.PAPMINO;
        //ShowPicByPatientID();
        ShowDefaultImg();
    }
}

//显示病人图片按钮ID
function ShowPicByPatientID() {
    var picType = ".jpg";
    //var src="ftp://10.160.16.112:21/picture/"+PatientID+picType;
    var src = "ftp://administrator:123456@10.72.16.158:21/picture/" + patientID + picType;
    document.getElementById("imgSex").src = src;
    document.getElementById("imgSex").style.height = "50px";
}

//图片不存在时显示默认图片
function ShowDefaultImg() {
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

//显示住院时间线连接
function ShowInHospital() {
    var aParams = location.search;
    if (ClinicalData.inEpisodeID != "" && aParams.indexOf("PageName") < 0) {
        var linkHtml = "<a href='####' EpisodeID='" + ClinicalData.inEpisodeID + "' onclick='ShowIntergrateView();' PatientID='" + patientID + "'>历次住院视图</a>";
        document.getElementById("divInHospitalView").innerHTML = linkHtml;
    }
}

//显示住院视图
function ShowIntergrateView() {
    if (SC_CHILD_WINDOW != null) {
        SC_CHILD_WINDOW.close();
    }
    var path = "timelineredirect.csp?PatientID=" + event.srcElement.getAttribute("PatientID") + "&EpisodeID=" + event.srcElement.getAttribute("EpisodeID") + "&&PageName=integrationvisual";
    //var path = "timelineredirect.csp?PatientID=" + event.srcElement.PatientID + "&EpisodeID=" + event.srcElement.EpisodeID + "&&PageName=integrationvisual";
    SC_CHILD_WINDOW = window.open(path, "历次住院视图", "height=800, width=1300, statusbar=yes,scrollbars=yes,menubar=no,toolbar=no,resizable=yes,left=10,top=10");
}

//关闭画面
function SC_WinClose() {
    if (SC_CHILD_WINDOW != null) {
        SC_CHILD_WINDOW.close();
        SC_CHILD_WINDOW = null;
    }
}
//========================================================>
//end :头部显示相关
//========================================================>


//<========================================================
//start :模板相关
//<========================================================
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
        isDepartMent:DepartMentDisplay,
        isConmonType: ConmonType,
        isCommonDisplay: CommonDisplay
    });

    tpl.overwrite(pnlView.body, CategroyData);
    pnlView.body.dom.style.backgroundColor = "#DFE8F6";
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
   // tbInforItemTemplate += '<tpl if="this.isBloodPressure(DataTypeCode)">';
   // tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;"><a href="####" onclick="ShowBloodView();" dtCode="{DataTypeCode}"> {' + dataTitleAttrName + '}</a></td></tr></table></td>';
   // tbInforItemTemplate += '</tpl>';

    tbInforItemTemplate += '<tpl if="this.isDepartMent(DataTypeCode)">';
    tbInforItemTemplate += '<td style="font-weight:bold;text-align:left;vertical-align:middle;background-color:Transparent;"><img id="imgSetting" src="../images/TimeLine/manager.gif" class="csSetingImg" onclick="ShowDepartSettingPage();" />&nbsp;&nbsp;{' + dataTitleAttrName + '}</td></tr></table></td>';
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

//判断是否是显示科室
function DepartMentDisplay(dataTypeCode) {
    if (dataTypeCode == "1701") {
        return true;
    }
    else {
        return false;
    }
}

//判断是否是普通类型
function ConmonType(dataTypeCode) {
    if (dataTypeCode != "0306" && dataTypeCode != "0601" && dataTypeCode != "1701") {
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
function DisplayChart(viewType) {
    return viewType == "C";
}

//判断是否用连接显示
function DisplayLink(viewType) {
    return viewType == "A";
}

//判断是否用图标显示
function DisplayIcon(viewType) {
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

//取得生命体征中点的样式
function GetPointStyle(code) {
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

//取得生命体征中线的颜色值
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
function GetYMaxValue(code) {
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

//隐藏信息
function hiddenItem() {
    var trClick = event.srcElement.parentElement.parentElement;
    var index = 0;
    while (trClick.className != "trInforItemShow" && index < 10) {
        trClick = trClick.parentElement;
        index = index + 1;
    }
    trClick.previousSibling.style.display = "";
    trClick.style.display = "none";
}

//显示信息
function showItem() {
    var trClick = event.srcElement.parentElement.parentElement.parentElement;
    trClick.style.display = "none";
    trClick.nextSibling.style.display = "";
}

//显示科室设定界面
function ShowDepartSettingPage() {
    var path = "TimeLine/departmentconfig.csp?PatientID=" + patientID;
    OpenNewPage(path, 600, 500, "设定显示科室");
}

//设定显示科室
function SetShowDepart() {
    var newHref = location.href.replace("SetDepart=1", "");
    newHref = newHref.replace("####", "");
    Ext.getCmp("newWindow").close();
    location.href = newHref + "&SetDepart=1";
}
//========================================================>
//end :模板相关
//========================================================>


//<========================================================
//start :数据展现相关
//<========================================================
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
                    var tdIndex = GetDisplayTdIndex(oneRecord.EpisodeID);
                    var gridCellIndex = GetDisplayGridTdIndex(oneRecord.ActTime);
                    if (tdIndex >= 0) {
                        tbInfor.rows[1].cells[tdIndex + 1].innerHTML += BuildLinkData(oneRecord, oneData.CategroyCode,tbInfor.getAttribute("Param"), gridCellIndex);
                    }
                }
            }
            else if (DisplayText(viewType)) {
                var records = oneData.records;
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    var tdIndex = GetDisplayTdIndex(oneRecord.EpisodeID);
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
                    var tdIndex = GetDisplayTdIndex(oneRecord.EpisodeID);
                    var gridCellIndex = GetDisplayGridTdIndex(oneRecord.ActTime);
                    if (tdIndex >= 0) {
                        var grid = tbInfor.rows[1].cells[tdIndex + 1].children[0];
                        grid.rows[0].cells[gridCellIndex].innerHTML += BuildIConData(oneRecord, tbInfor.getAttribute("Param"));
                    }
                }
            }
            else if (DisplayGrid(viewType)) {
                var records = oneData.records;
                for (var num = 0; num < records.length; num++) {
                    var oneRecord = records[num];
                    var tdIndex = GetDisplayTdIndex(oneRecord.EpisodeID);
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
                tbInfor.rows[1].style.display = "";
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
                    tbInfor.rows[1].style.display = "";
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
        var showSDate = ConvertToDateValue(EpisodeValues[0]);
        var showEDate = ConvertToDateValue(EpisodeValues[cellCount - 1]);
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
        if(drugNameList != null)
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
//wanghc 20141222 把状态变化转成图形
function BuildAct(ActionJson,cateCode,inDataTypeActCfg){	
	var rtn,isContainFlag = false;
	var itemline = '<td style="width:35px;"><div style="background-color:#db6a0f;width:35px;height:2px;font-size:0px;"/></td><td style="width:10px;"><img src="../images/TimeLine/arrow1.gif"/></td>';
	var dashedline = '<td style="width:35px;"><div style="width:35px;height:2px;font-size:0px;border-bottom:2px dashed #BBBBBB;"/></td><td style="width:10px;"><img src="../images/TimeLine/arrow1.gif"/></td>';
	var startTpl= "<table class='statuschangelineCls' style='width:600px;height:160px;' cellspacing='0' cellpadding='0'><tr style='height:50px;'><td style='width:5px;'></td><td colspan=18><b>&nbsp;"+ActionJson[0].Summary+"</b> 执行状态变化</td></tr>"
	var row1 = "<tr style='height:20px'>",row2="<tr style='height:20px'>", row3="<tr style='height:20px'>";row4="<tr style='height:20px'>";
	var row1DescWidth=["0401","0501","2001","2101"];
	row1DescWidth["0501"]=[90,100,100,90,90,90]; 		 //表示05类型 检验.动作描述的长度
	row1DescWidth["0401"]=[85,85,85,85,85,85];				//表示04类型 检查
	row1DescWidth["2001"]=[85,85,85,85,85,85];				//表示20类型 病理
	row1DescWidth["2101"]=[85,85,85,85,85,85];				//表示20类型 病理
	if ("04"==cateCode){
		if (typeof DataTypeActCfg!="undefined") DataTypeActCfg["0401"] = inDataTypeActCfg;
		else return;
	}
	cateCode = cateCode+"01";
	if (DataTypeActCfg[cateCode]){
		
		for (var i =0; i<DataTypeActCfg[cateCode].length; i++){
			isContainFlag=false;
			for (var j=0; j<ActionJson.length;j++){
				if(ActionJson[j]["ActDesc"]==DataTypeActCfg[cateCode][i]["Description"]){
					row2 += "<td></td><td></td><td>"+ActionJson[j].ActTime+"</td>";
					row3 += "<td></td><td></td><td ><font size='1px'>"+formatDateByConfig(ActionJson[j].ActDate)+"</font></td>";
					row4 += "<td></td><td></td><td >"+ActionJson[j].CareProvider+"</td>";
					isContainFlag=true;
				}
			}
			if (!isContainFlag) {
				row2 += "<td></td><td></td><td></td>";
				row3 += "<td></td><td></td><td ></td>"
				row4 += "<td></td><td></td><td ></td>";
			}
			if (i==0) {
				row1 +="<td></td><td></td><td style='width:"+row1DescWidth[cateCode][i]+"px;'>";
			}else{
				if(isContainFlag) row1 += itemline+"<td style='width:"+row1DescWidth[cateCode][i]+"px;'>";
				else row1 += dashedline+"<td style='width:"+row1DescWidth[cateCode][i]+"px;'>";
			}
			if(isContainFlag){
				row1 += "<div class='DataTypeActNode'>"+DataTypeActCfg[cateCode][i]["Description"]+"</div></td>";
			}else{
				row1 += "<div class='DataTypeActNodeNoDo'>"+DataTypeActCfg[cateCode][i]["Description"]+"</div></td>";
			}
		}
	}
	row1+="<td>&nbsp</td></tr>",row2+="<td>&nbsp</td></tr>",row3+="<td>&nbsp</td></tr>",row4+="<td>&nbsp</td></tr>";
	rtn = startTpl+row1+row2+row3+row4+"<tr></tr></table>";
	return rtn;
}
//创建link显示的内容
function BuildLinkData(record, cateCode,param, gridCellIndex){
    var linkPath = param;
    //检查检验
    if (cateCode == "04" || cateCode == "05" || cateCode=="20"|| cateCode=="21") {
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
           // summary = summary.substr(0, txtLength) + "...";
            summary=formatTextByTxtLength(summary,txtLength);// cryze 2018-3-24 
        }
        if (cateCode == "05" || cateCode =="20" || cateCode =="21") {	        
	    	inforHtml= escape(BuildAct(inforArray,cateCode));
            return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
        }
        if (cateCode =="04"){
	        
	        inforHtml= escape(BuildAct(inforArray,cateCode,record.DataTypeActCfg));
	        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
	    }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    //诊断记录
    else if (cateCode == "01") {
        var level = parseInt(record.DataValue, 10);
        var levelChar = "";
        for (var index = 1; index < level; index++) {
            levelChar = levelChar + "    ";
        }
        if (levelChar != "") {
            levelChar = "  " + levelChar;
        }
        //levelChar + " " + 
        return CreateLabel(record.Summary, gridCellIndex);
    }
    else if (cateCode == "10") {
        linkPath += "?" + record.Parameters;
        var summary = record.Summary;
        var inforHtml = "";
        if (summary.length > txtLength) {
            //summary = summary.substr(0, txtLength) + "...";
            summary=formatTextByTxtLength(summary,txtLength);// cryze 2018-3-24 
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
                //summary = summary.substr(0, txtLength) + "...";
                summary=formatTextByTxtLength(summary,txtLength);// cryze 2018-3-24 
                inforHtml = escape(record.Summary);
            }
        }
        return CreateAlingLink(summary, inforHtml, gridCellIndex, linkPath, cateCode);
    }
    else if (cateCode == "15") {
        if (linkPath != "") {
            linkPath += "?" + record.Parameters;
        }
        else {
            linkPath += record.Parameters;
        }
        if (record.Summary != "") {
            var txtHtml = CreatePanelLink(record.Summary.split("|"),linkPath, cateCode);
            return txtHtml;
        }
        else {
            return "";
        }
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
            //summary = summary.substr(0, txtLength) + "...";
            summary=formatTextByTxtLength(summary,txtLength);// cryze 2018-3-24 
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
    else if (cateCode == "17") {
        var office = record.Summary.split("|")[0];
        var doctor = record.Summary.split("|")[1];
		// office.replace("门诊","") 2016-03-04 wanghc
        var txtHtml = CreateLabel(office + "/" + doctor, gridCellIndex);
        //txtHtml = txtHtml + CreateLabel("医生:" + doctor, gridCellIndex);
        return txtHtml;
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
function GetDisplayTdIndex(episodeId) {
    var count = EpisodeValues.length;
    if(count >0) {
        for (var index = 0; index < count; index++) {
            if (episodeId == EpisodeValues[index]) {
                return index;
            }
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
            return index;
        }
    }
    
    return 1;
}

//显示信息
function ShowInfor() {
    ChangeStyle(1);
    var divInfor = document.getElementById(divInforID);
    if (divInfor) {
        return;
    }
    var infor = event.srcElement.getAttribute("infor");
    if (!infor) {
        if (event.srcElement.children.length > 0) {
            infor = event.srcElement.children[0].getAttribute("infor");
        }
        else {
            infor = event.srcElement.parentElement.getAttribute("infor");
        }
    }
    var divInfor = document.createElement("div");
    divInfor.id = divInforID;
    divInfor.innerHTML = unescape(infor);
    if (infor.indexOf("statuschangelineCls")>-1){
	    var width = 600;
	    divInfor.style.top = (event.clientY+5) + "px";
	    if(event.x>width) {
		    divInfor.style.left = ((event.x + 5)-width) + "px";
	    }else{
	    	divInfor.style.left = (event.x + 5) + "px";
	    }
	    divInfor.style.width = width + "px";
    }else{
	    divInfor.style.top = (event.clientY+5) + "px";
	    divInfor.style.left = (event.x + 5) + "px";
	    divInfor.style.width = 250 + "px";
    }
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

//清除页面中的数据
function ClearRecord() {
    //设定日期
    var tbDate = document.getElementById("tbHeaderDate");
    EpisodeValues = getEpisodeValues();
    var count = 0;
    if (EpisodeValues != null) {
        count = EpisodeValues.length;
    }
    var num = 1;
    for (var index = 0; index < count; index++) {
        var weekDate = GetDateAndWeekDayHour(EpisodeValues[index]);
        weekDate=formatDateByConfig(weekDate);
        tbDate.rows[0].cells[index + 1].innerHTML = weekDate;
        num = num +1
    }
    while (num < cellCount) {
        tbDate.rows[0].cells[num].innerHTML = "";
        num = num + 1;
    }
    
    //清除数据项
    var InforTableArray = Ext.select('table[class =csTbInforItem]').elements;
    var tableCount = InforTableArray.length;
    for (var num = 0; num < tableCount; num++) {
        var oneTable = InforTableArray[num];
        var viewType = oneTable.getAttribute("ViewType"); //ViewType;
        
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

//创建无对齐标记的label
function CreatePanelLink(inforArray, linkPath, cateCode) {
    var inforHtml = "";
    var infor = "";
    for (var index = 0; index < inforArray.length; index++) {
        /*if (index > 4) {
           // break; 
        }*/
        //wanghc 2016-03-04
        if (index>4){
	       inforHtml += "</br>"+inforArray[index];
	    }else{
	        if (inforArray[index] != "") {
	            if (infor != "") {
	                if (inforArray[index].length > txtLength) {
	                    //infor = infor + "</br>" + inforArray[index].substr(0, txtLength) + "...";
	                    infor = infor + "</br>" + formatTextByTxtLength(inforArray[index], txtLength) ;  //cryze 2018-3-24
	                    
	                }
	                else {
	                    infor = infor + "</br>" + inforArray[index];
	                }
	                inforHtml = inforHtml + "</br>" +inforArray[index];
	            }
	            else {
	                if (inforArray[index].length > txtLength) {
	                    //infor =  inforArray[index].substr(0, txtLength) + "...";
	                    infor =  formatTextByTxtLength(inforArray[index], txtLength) ;  //cryze 2018-3-24
	                }
	                else {
	                    infor = inforArray[index];
	                }
	                inforHtml = inforArray[index];
	            }
	        }
        }
    }

    var inforHtml = escape(inforHtml);
    var linkHtml = "";
    if (infor == "") {
        linkHtml = '<div class="csDivPanel" style="width:' + (DateWidth - 12) + 'px;"  onclick="ShowReport();" infor="' + inforHtml + '"   linkPath="' + linkPath + '" cateCode="' + cateCode + '">' + infor + '</div>';
    }
    else {
        linkHtml = '<div class="csDivPanel" style="width:' + (DateWidth - 12) + 'px;"  onmouseover="ShowInfor();" onmouseout="HiddenInfor();" onclick="ShowReport();" infor="' + inforHtml + '"  linkPath="' + linkPath + '" cateCode="' + cateCode + '">' + infor +'</div>';
    }
    return '<div >' + linkHtml + '</div>';
}

//创建无对齐标记的label
function CreateLabel(infor, cellIndex) {
    var inforHtml = escape(infor.replace(/[ ]/g,"&nbsp;"));
    //var flg = false;
    //if (infor.indexOf(" ") > -1) {
        //infor = infor.replace("&nbsp;&nbsp;", " ");
    //    flg = true;
    //}
    if (infor.length > txtLength) {
        //infor = infor.substr(0, txtLength) + "...";
        infor=formatTextByTxtLength(infor,txtLength);// cryze 2018-3-24 
    }
    //if (flg == true) {
    infor = infor.replace(/[ ]/g, "&nbsp;");
    //}
    var lblHtml = '<div class="csDivLabel" style="width:' + (DateWidth - 12) + 'px;" infor="' + inforHtml + '" onmouseover="ShowInfor();" onmouseout="HiddenInfor();">' + infor + '</div>';
    return '<div >' + lblHtml + '</div>';
}

//创建可对齐的label
function CreateAlingLabel(infor, cellIndex) {
    var gridHtml = CreateAlignGridHtml(cellIndex);
    var inforHtml = escape(infor);
    if (infor.length > txtLength) {
        //infor = infor.substr(0, txtLength) + "...";
        infor=formatTextByTxtLength(infor,txtLength);// 2018-3-24 
    }
    var lblHtml = '<div class="csDivLabel" style="width:' + (DateWidth - 4) + 'px;" infor="' + inforHtml + '" onmouseover="ShowInfor();" onmouseout="HiddenInfor();">' + infor + '</div>';
    return '<div class="csAlignDiv">' + gridHtml + lblHtml + '</div>';
}

//创建可对齐的Link
function CreateAlingLink(txt, infor, cellIndex, linkPath, cateCode) {
    var gridHtml = CreateAlignGridHtml(cellIndex);
    var linkHtml = "";
    if (infor == "") {
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
    var tdWidth = (DateWidth - 4) / timeCount;
    for (var index = 1; index < timeCount + 1; index++) {
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

//取得就诊数据集合
function getEpisodeValues() {
    if (ClinicalData.queryEpisodelst !="") {
        return ClinicalData.queryEpisodelst.split("|");
    }
    else {
        return null;
    }
}

//取得x轴时间值
function GetTimeValue(dateValue, timeValue) {
    var dtArr = dateValue.split("-");
    var dt = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    var dtMinArr = EpisodeValues[0].split("-");
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
//========================================================>
//end :数据展现相关
//========================================================>



//<========================================================
//start :页面操作相关函数
//<========================================================
//日期向前移动一周
function LastWeek() {
    var episodeList = ClinicalData.EpisodeList;
    var count = episodeList.length;
    var selectedIndex = -1;
    var lastEpisode = EpisodeValues[EpisodeValues.length-1];
    for (var index = 0; index < count; index++) {
        if (episodeList[index].EpisodeID == lastEpisode) {
            selectedIndex = index;
            break;
        }
    }
    if (selectedIndex > 0 && count > 7) {
        var nextIndex = selectedIndex;
        if (selectedIndex >= 13) {
            nextIndex = selectedIndex - 7;
        }
        else if (selectedIndex >= 6) {
            nextIndex = 6;
        }
        var lstSeachEpisode = "";
        var startIndex = 0;
        if (nextIndex > 6) {
            startIndex = nextIndex - 6;
        }
        for (var index = startIndex; index <= nextIndex; index++) {
            if (lstSeachEpisode != "") {
                lstSeachEpisode = lstSeachEpisode + "|" + episodeList[index].EpisodeID;
            }
            else {
                lstSeachEpisode = episodeList[index].EpisodeID;
            }
        }
        var actionParams = { 'queryCode': queryCode, 'lstEpisodeId': lstSeachEpisode, 'PatientID': patientID, 'actionCode': 'GetDisplayData' };
        SubmitForm("pnlView", actionParams);
    }
}

//日期向后移动一周
function NextWeek() {
    var episodeList = ClinicalData.EpisodeList;
    var count = episodeList.length;
    var selectedIndex = -1;
    var lastEpisode = EpisodeValues[EpisodeValues.length - 1];
    for (var index = 0; index < count; index++) {
        if (episodeList[index].EpisodeID == lastEpisode) {
            selectedIndex = index;
            break;
        }
    }
    if (selectedIndex < (count - 1)) {
        var nextIndex = selectedIndex;
        if ((count-selectedIndex-1) >= 7) {
            nextIndex = selectedIndex + 7;
        }
        else if ((count - selectedIndex) >= 1) {
            nextIndex = count-1;
        }
        var lstSeachEpisode = "";
        var startIndex = 0;
        if (nextIndex > 6) {
            startIndex = nextIndex - 6;
        }
        for (var index = startIndex; index <= nextIndex; index++) {
            if (lstSeachEpisode != "") {
                lstSeachEpisode = lstSeachEpisode + "|" + episodeList[index].EpisodeID;
            }
            else {
                lstSeachEpisode = episodeList[index].EpisodeID;
            }
        }
        var actionParams = { 'queryCode': queryCode, 'lstEpisodeId': lstSeachEpisode, 'PatientID': patientID, 'actionCode': 'GetDisplayData' };
        SubmitForm("pnlView", actionParams);
    }
}

//日期向前移动一天
function LastDate() {
    var episodeList = ClinicalData.EpisodeList;
    var count = episodeList.length;
    var selectedIndex = -1;
    var lastEpisode = EpisodeValues[EpisodeValues.length - 1];
    for (var index = 0; index < count; index++) {
        if (episodeList[index].EpisodeID == lastEpisode) {
            selectedIndex = index;
            break;
        }
    }
    if (selectedIndex > 6) {
        var nextIndex = selectedIndex - 1;
        var lstSeachEpisode = "";
        var startIndex = 0;
        if (nextIndex > 6) {
            startIndex = nextIndex - 6;
        }
        for (var index = startIndex; index <= nextIndex; index++) {
            if (lstSeachEpisode != "") {
                lstSeachEpisode = lstSeachEpisode + "|" + episodeList[index].EpisodeID;
            }
            else {
                lstSeachEpisode = episodeList[index].EpisodeID;
            }
        }
        var actionParams = { 'queryCode': queryCode, 'lstEpisodeId': lstSeachEpisode, 'PatientID': patientID, 'actionCode': 'GetDisplayData' };
        SubmitForm("pnlView", actionParams);
    }
}

//日期向后移动一天
function NextDate() {
    var episodeList = ClinicalData.EpisodeList;
    var count = episodeList.length;
    var selectedIndex = -1;
    var lastEpisode = EpisodeValues[EpisodeValues.length - 1];
    for (var index = 0; index < count; index++) {
        if (episodeList[index].EpisodeID == lastEpisode) {
            selectedIndex = index;
            break;
        }
    }
    if (selectedIndex < count-1) {
        var nextIndex = selectedIndex + 1;
        var lstSeachEpisode = "";
        var startIndex = 0;
        if (nextIndex > 6) {
            startIndex = nextIndex - 6;
        }
        for (var index = startIndex; index <= nextIndex; index++) {
            if (lstSeachEpisode != "") {
                lstSeachEpisode = lstSeachEpisode + "|" + episodeList[index].EpisodeID;
            }
            else {
                lstSeachEpisode = episodeList[index].EpisodeID;
            }
        }
        var actionParams = { 'queryCode': queryCode, 'lstEpisodeId': lstSeachEpisode, 'PatientID': patientID, 'actionCode': 'GetDisplayData' };
        SubmitForm("pnlView", actionParams);
    }
}


function validReportDeploy(path){
	var arr = path.split("?");
    if (path==""){
	    alert("报告还未发布");
	    return false;
    }
	if (arr.length>1 && arr[1].length==0){
		alert("报告还未发布");
		return false;
	}
	if ((arr.length==2) && (arr[1]=="&portal=1")){
		alert("报告还未发布");
		return false;
	}
	return true;
}
//显示报告
function ShowReport() {
    var path = event.srcElement.getAttribute("linkPath");
    var cateCode = event.srcElement.getAttribute("cateCode");
    if (cateCode == "01") {
        OpenNewPage(path, 980, 620, "诊断记录");
    }
    else if (cateCode == "04" || cateCode == "05" || cateCode=="20" || cateCode =="21") {
	     var arr = path.split("?");
	    if (!validReportDeploy(path)){
	    	return ;
	    }
	    if(arr.length>1 && arr[1].length>0){
        	if(cateCode == "05"){ // 检验
				ShowReportInfor(path, 990, 620, "报告");
			}else if(cateCode=="21"){	// 心电
				path = rewriteUrl(path,{"USERID":session['LOGON.USERID']}); 
				window.open(path, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
				return;
			}else if (cateCode=="20"){  // PIS
				path = rewriteUrl(path,{"DOCCODE":session['LOGON.USERCODE']}); 
				window.open(path, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
				return;
			}else{
				path = rewriteUrl(path,{"USERID":session['LOGON.USERID']}); 
				window.open(path, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
				return;
			}
	    }
    }
    else if (cateCode == "15") {
        if (Ext.util.Format.trim(path) != "") {
            ShowReportInfor(path, 820, 570, "报告");
        }
    }
    else {
        OpenNewPage(path, 820, 560, "报告");
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

//切换就诊获取数据
function SubmitForm(frmName, actionParams) {
	//改成request提交
	Ext.Ajax.request({
        url: accessURL,
        params: actionParams,
        method:'POST',
        success: function(resp,opt) {
	        var result = Ext.util.JSON.decode(resp.responseText);
            ClinicalData.DataArray = result.DataArray;
            ClinicalData.queryEpisodelst = result.queryEpisodelst;
            ClearRecord();
            BuildData(ClinicalData.DataArray);
            ShowPatientInfor(ClinicalData.PatientInfo);
        },
        failure: function(resp,opt) {
            Ext.MessageBox.show({
                title: "错误信息",
                msg: "获取数据失败",
                width: 400,
                buttons: Ext.MessageBox.OK,
                icon: Ext.MessageBox.ERROR
            });
        }
	});
	return ;

    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在获取数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            ClinicalData.DataArray = action.result.DataArray;
            ClinicalData.queryEpisodelst = action.result.queryEpisodelst;
            ClearRecord();
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

//设定日期移动按钮的状态
function SetButtonState() {
    var episodeList = ClinicalData.EpisodeList;
    var count = episodeList.length;
    var selectedIndex = -1;
    for (var index = 0; index < count; index++) {
        if (episodeList[index].EpisodeID == EpisodeValues[EpisodeValues.length - 1]) {
            selectedIndex = index;
            break;
        }
    }
    if (selectedIndex == -1 || selectedIndex == count-1) {
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
    if (selectedIndex == -1 || selectedIndex <= 6) {
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


//显示血压的趋势图
//function ShowBloodView() {
//    var path = "TimeLine/bloodpressureview.csp?dataTypeCode=" + event.srcElement.dtCode + "&episodeId=" + episodeId + "&startDate=" + ClinicalData.searchDate;
//    OpenNewPage(path, 980, 278,"血压趋势图");
//}

//显示设置页面
function ShowSettingPage() {
    var newHref = location.href.replace("&SettingFlg=1", "");
    var newHref = location.href.replace("####", "");
    location.href = newHref + "&SettingFlg=1";
}
//========================================================>
//end :页面操作相关
//========================================================>

//<========================================================
//start :病人列表相关函数
//<========================================================
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

//取得菜单上的对象
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
            //for (var n = nameCount; n <= 5; n++) {
            //    name = name + "&nbsp;";
            //}
            var locSeqNo = PatientList[index].LocSeqNo;
            //menuHtml = menuHtml + '<div episodeID="' + PatientList[index].EpisodeID + '" patientID="' + PatientList[index].PatientID + '" mradm="' + PatientList[index].mradm + '" class="csMenuItem" onclick="ChangePatient();" onmouseover="SetMenuStyle(1);" onmouseout="SetMenuStyle(0);"><table><tr><td style="width:10px;">' + locSeqNo + '</td><td style="width:90px;">&nbsp;&nbsp;' + name + '</td><td style="width:60px;">' + PatientList[index].PAPMINO + '</td></tr></table></div>';
            menuHtml = menuHtml + '<div episodeID="' + PatientList[index].EpisodeID + '" patientID="' + PatientList[index].PatientID + '" mradm="' + PatientList[index].mradm + '" class="csMenuItem" onclick="ChangePatient();" onmouseover="SetMenuStyle(1);" onmouseout="SetMenuStyle(0);"><table><tr><td style="width:100px;">&nbsp;&nbsp;' + name + '</td><td style="width:60px;">' + PatientList[index].PAPMINO + '</td></tr></table></div>';
        }
        enuHtml = menuHtml + "</ul>";
        divPatientMenu.className = "csPatientMenu";
        divPatientMenu.style.top = (findPosY(event.srcElement) + 23) + "px";
        divPatientMenu.style.left = findPosX(event.srcElement) + "px";
        if (PatientList.length > 20) {
            divPatientMenu.style.height = "400px";
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
    var changePatientID = ctrl.getAttribute("patientID");
    var episodeID = ctrl.getAttribute("episodeID");
    var mradm = ctrl.getAttribute("mradm");
    // 2017-4-7 优化
    var oldPath = location.href;
    var path = rewriteUrl(oldPath,{"EpisodeID":episodeID,"PatientID":changePatientID,"mradm":mradm}); 
    if (path!=oldPath){
	    location.href = path;
    }
    return ;
}

//隐藏菜单
function HiddenMenu() {
    if (event.srcElement.id != "divName") {
        var divPatientList = document.getElementById(divPatientListID);
        if (divPatientList) {
            divPatientList.parentElement.removeChild(divPatientList);
        }
    }
}

//当鼠标靠近或离开时，设定列表的样式
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
//========================================================>
//end :病人列表相关函数
//========================================================>


//<========================================================
//start :报告显示相关函数
//<========================================================
//显示报表
function ShowReportInfor(url, winWidth, winHeight, title) {
    SelectReportItem = event.srcElement.parentElement;
    var lastDisabled  = false;
    var nextDisabled  = false;
    if (SelectReportItem.previousSibling == null) {
        lastDisabled = true;
    }
    if (SelectReportItem.nextSibling == null) {
        nextDisabled = true;
    }
    var btnLast = new Ext.Button({
        id: "btnLast",
        text: "上一个",
        disabled:lastDisabled,
        handler: LastReport
    });
    var btnNext = new Ext.Button({
        id: "btnNext",
        text: "下一个",
        disabled:nextDisabled,
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
    var divItem = null;
    if (SelectReportItem.children.length > 1) {
        divItem = SelectReportItem.children[1];
    }
    else {
        divItem = SelectReportItem.children[0];
    }
    var path = divItem.getAttribute("linkPath");
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
    var divItem = null;
    if (SelectReportItem.children.length > 1) {
        divItem = SelectReportItem.children[1];
    }
    else {
        divItem = SelectReportItem.children[0];
    }
    var path = divItem.getAttribute("linkPath");
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

//显示医嘱复制页面
function ShowOrderCopy() {
    if (SC_CHILD_WINDOW != null) {
        SC_CHILD_WINDOW.close();
    }
    var newUrl = "http://localhost/dthealth/web/csp/websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.Item.List&EpisodeID="+PageEpisodeId+"&SttDate=&EndDate=&PriorID="
    SC_CHILD_WINDOW = window.open(newUrl, "", "fullscreen=1,statusbar=no,menubar=no,toolbar=no,resizable=yes,left=10,top=10");
}
//========================================================>
//end :报告相关函数
//========================================================>