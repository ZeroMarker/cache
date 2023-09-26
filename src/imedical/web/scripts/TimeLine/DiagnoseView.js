//显示的列
var ColArray = null;
//列头的宽度
var HeaderWidth=140;
//列的宽度
var CellWidth = 200;
//总宽度
var totalWidth = 0;
//访问地址
var accessURL = "extgetdata.csp";
var seeDocIndex = 0;
//显示数据的开始索引
var StartIndex = 0;

Ext.onReady(function() {
    totalWidth = HeaderWidth + CellWidth * PageCount;
    ShowPage();
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
        id: 'frmDiagnose',
        title: '',
        baseCls:'',
        width: totalWidth+25,
        height: 520,
        autoScroll: true,
        renderTo: document.body
    });
    CreateHeader();
    ShowTable();
    ShowSeeDoctorRecord(seeDocIndex);
    ShowPatientInfor(DiagnoseInfor.PatientInfo);
    BuildData();
    SetButtonState();
    SetSeeDocLinkStyle();
}

//根据模板显示信息
function ShowTable() {
    var frmView = Ext.getCmp("frmDiagnose");
    var tableHtml = CreateTableInfor();
    var tpl = new Ext.XTemplate(tableHtml, {
        // XTemplate configuration:
        compiled: true,
        disableFormats: true
        // member functions:
    });

    tpl.overwrite(frmView.body);
    frmView.body.dom.style.backgroundColor = "#DFE8F6";
}

//创建头部
function CreateHeader() {
    var patientHtml = '<table class ="csTbPatient" border="0" cellpadding="0" cellspacing="0" style="width:' + totalWidth + 'px;" >';
    patientHtml += '<tr class="csTrPatientContent"><td class="csTdPatientInfor"><table id="tbPatient" border="0" cellpadding="0" cellspacing="0"><tr><td style="background-color:Transparent;vertical-align:middle;"  rowspan="2"><img id="imgSex" src="../../images/TimeLine/manNew.jpg" style="padding-top:2px;width:50px;" /></td><td id="tdName" style="width:80px;padding-left:10px;font-weight:bold;color:Yellow;font-size:12pt;padding-left:12px;"  rowspan="2"></td><td style="width:80px;font-weight:bold;color:White;">性别：</td><td id="tdSex" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">年龄：</td><td id="tdAge" style="width:110px;color:#90E4E6;"></td><td></td><td></td></tr><tr><td style="width:80px;font-weight:bold;color:White;">入院时间：</td><td id="tdInDate" style="width:100px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">科室：</td><td id="tdInDept" style="width:110px;color:#90E4E6;"></td><td style="width:45px;font-weight:bold;color:White;">医生：</td><td id="tdPaDoctor" style="width:80px;color:#90E4E6;"></td></tr></table></td><td style="width:25px;"></td><td style="width:15px;"><img style="cursor:hand;" src="../../images/TimeLine/btnLeft.gif" onclick="MoveLeftRecord();" align="left"/></td><td><div id="divSeeDoctor" class="csSeeDoctor"><table class="csTbSeeDoctor" border="0" cellpadding="0" cellspacing="0"><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></table></div></td><td style="width:15px;"><img style="cursor:hand;" src="../../images/TimeLine/btnRight.gif" onclick="MoveRightRecord();" align="left"/></td><td style="width:2px;"><td></tr>';
    patientHtml += '</table>';
    document.getElementById("divDiagnoseHeader").innerHTML = patientHtml;
}

//创建表格信息
function CreateTableInfor() {
    var tableHtml = CreateTableHtml();
    return '<div  id="divDiagnose" class="csDivDiagnose" >'+tableHtml+'<div>';
}

//创建表的Html
function CreateTableHtml() {
    var colCount = GetColCount();
    var rowCount = DiagnoseType.length;
    var tableWidth = (CellWidth * colCount) + HeaderWidth;
    var tableHtml = '<table id="tbDiagnose" class ="csTbDiagnose" border="0" cellpadding="0" cellspacing="1" style="width:' + tableWidth + 'px;" >';
    for (var index = 0; index < rowCount + 1; index++) {
        if (index == 0) {
            tableHtml += CreateTableHeader(colCount);
        }
        else {
            var rowHeaderTxt = DiagnoseType[index - 1].Description;
            tableHtml += CreateTableRow(colCount, rowHeaderTxt);
        }
    }
    tableHtml += "</table>";
    return tableHtml;
}

//创建表头
function CreateTableHeader(colCount) {
    var headerHtml = '<tr><td class ="csColRowHeader" style="width:' + HeaderWidth + 'px;" ><table style="width:100%;height:100%;"><tr style="background-color:Transparent;"><td><img id="imgLastDate" style="cursor:hand;" src="../../images/TimeLine/Date-prev.gif" onclick="LastData();" align="left"/></td><td >日期</td><td ><img id="imgNextDate" style="cursor:hand;" src="../../images/TimeLine/Date-next.gif" onclick="NextData();" align="right"/></td></tr></table></td>';
    for (var i = 0; i < colCount; i++) {
        headerHtml += '<td class ="csDiagnoseHeader" style="width:' + CellWidth + 'px;" >'+formatDateByConfig(ColArray[i])+'</td>';
    }
    headerHtml += "</tr>";
    return headerHtml;
}

//创建行
function CreateTableRow(colCount, rowHeaderTxt) {
    var headerHtml = '<tr style="height:30px;"><td class ="csDiagnoseRowHeader" style="width:' + HeaderWidth + 'px;" >' + rowHeaderTxt + '</td>';
    for (var i = 0; i < colCount; i++) {
        headerHtml += '<td class ="csDiagnoseCell" style="width:' + CellWidth + 'px;" ></td>';
    }
    headerHtml += "</tr>";
    return headerHtml;
}

//取得显示的列数
function GetColCount() {
    ColArray = new Array();
    for (var index = 0; index < DiagnoseInfor.Data.length; index++) {
        var oneInfor = DiagnoseInfor.Data[index];
        var flgExsit = false;
        for (var num = 0; num < ColArray.length; num++) {
            if (oneInfor.ActDate == ColArray[num]) {
                flgExsit = true;
                break;
            }
        }
        if (flgExsit == false) {
            ColArray.push(oneInfor.ActDate);
        }
    }
    if (ColArray.length < PageCount) {
        var count = PageCount - ColArray.length;
        for (var i = 0; i < count; i++) {
            ColArray.push("&nbsp;");
        }
    }
    return ColArray.length;
}

//将需要显示的数据添加到页面中
function BuildData() {
    for (var index = 0; index < DiagnoseInfor.Data.length; index++) {
        var oneInfor = DiagnoseInfor.Data[index];
        var actDate = oneInfor.ActDate;
        var actTime = oneInfor.ActTime;
        var objId = oneInfor.ObjectID;
        var summary = oneInfor.Summary;
        var rowIndex = GetRowIndex(objId);
        var CellIndex = GetCellIndex(actDate);
        if (rowIndex > 0 && CellIndex >0) {
            var tblDiagnose = document.getElementById("tbDiagnose");
            var actTimeTxt = "";
            if (actTime != "") {
                actTimeTxt = actTime.substr(0, 5);
            }
            var showInfor = actTimeTxt + "&nbsp;" + summary;
            tblDiagnose.rows[rowIndex].cells[CellIndex].innerHTML += CreateLabelInfor(showInfor);
        }
    }
}

//取得要显示信息的行
function GetRowIndex(objId) {
	objId=objId.split("||")[0];   //cryze 2016-3-24 用$g(MRDIATypeRowId)_"||"_MRADM_"||"_MRDIASubId作为objectid 
    for (var index = 0; index < DiagnoseType.length; index++) {
        if (objId == DiagnoseType[index].ObjectID) {
            return (index + 1);
        }
    }
    return -1;
}

//取得要显示信息的列
function GetCellIndex(actDate) {
    for (var index = 0; index < ColArray.length; index++) {
        if (actDate == ColArray[index]) {
            return (index+1)
        }
    }
    return -1;
}

//创建文本显示信息
function CreateLabelInfor(txt) {
   return  '<div class="csDiagnoseInfor" style="width:' + (CellWidth-2) + 'px;"><label>' + txt + '</label></div>';

}

//上一次诊断记录
function LastData() {
    StartIndex = StartIndex - PageCount;
    var actionParams = { 'actionCode': 'GetDiagnoseData', 'episodeId': DiagnoseInfor.episodeId, 'startIndex': StartIndex, 'pageCount': PageCount };
    GetData(actionParams);
}

//下一次诊断记录
function NextData() {
    StartIndex = StartIndex + PageCount;
    var actionParams = { 'actionCode': 'GetDiagnoseData', 'episodeId': DiagnoseInfor.episodeId, 'startIndex': StartIndex, 'pageCount': PageCount };
    GetData(actionParams);
}

//显示病人信息
function ShowPatientInfor(patientInfor) {
    document.getElementById("tdName").innerHTML = patientInfor.name;
    document.getElementById("tdSex").innerHTML = patientInfor.sex;
    if (patientInfor.sex == "男") {
        document.getElementById("imgSex").src = "../../images/TimeLine/manNew.jpg";
    }
    else {
        document.getElementById("imgSex").src = "../../images/TimeLine/womanNew.jpg";
    }
    document.getElementById("tdAge").innerHTML = patientInfor.age; //.split("岁")[0] + "岁";
    var inDate = patientInfor.inDate;
    if (inDate != "") {
	    document.getElementById("tdInDate").innerHTML=formatDateByConfig(inDate);
        //var dtArr = inDate.split("-");
        //document.getElementById("tdInDate").innerHTML = dtArr[0] + "年" + dtArr[1] + "月" + dtArr[2] + "日";
    }
    else {
        document.getElementById("tdInDate").innerHTML = patientInfor.inDate;
    }
    document.getElementById("tdInDept").innerHTML = patientInfor.inDept;
    document.getElementById("tdPaDoctor").innerHTML = patientInfor.paDoctor;
}

//向左移动就诊记录
function MoveLeftRecord() {
    var count = SeeDoctorInfor.length;
    if ((seeDocIndex - 7) >= 0) {
        seeDocIndex = seeDocIndex - 7;
        ShowSeeDoctorRecord(seeDocIndex);
        SetSeeDocLinkStyle();
    }
}

//向右移动就诊记录
function MoveRightRecord() {
    var count = SeeDoctorInfor.length;
    if ((seeDocIndex + 7) < count) {
        seeDocIndex = seeDocIndex + 7;
        ShowSeeDoctorRecord(seeDocIndex);
        SetSeeDocLinkStyle();
    }
}

//显示就诊记录
function ShowSeeDoctorRecord(index) {
    var tbSeeDoc = document.getElementById("divSeeDoctor").children[0];
    var count = SeeDoctorInfor.length;
    tbSeeDoc.rows[0].cells[0].innerHTML = "";
    tbSeeDoc.rows[0].cells[1].innerHTML = "";
    tbSeeDoc.rows[0].cells[2].innerHTML = "";
    tbSeeDoc.rows[0].cells[3].innerHTML = "";
    tbSeeDoc.rows[0].cells[4].innerHTML = "";
    tbSeeDoc.rows[0].cells[5].innerHTML = "";
    tbSeeDoc.rows[0].cells[6].innerHTML = "";
    if (index < count) {
        tbSeeDoc.rows[0].cells[0].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index]);
    }
    if ((index + 1) < count) {
        tbSeeDoc.rows[0].cells[1].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 1]);
    }
    if ((index + 2) < count) {
        tbSeeDoc.rows[0].cells[2].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 2]);
    }
    if ((index + 3) < count) {
        tbSeeDoc.rows[0].cells[3].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 3]);
    }
    if ((index + 4) < count) {
        tbSeeDoc.rows[0].cells[4].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 4]);
    }
    if ((index + 5) < count) {
        tbSeeDoc.rows[0].cells[5].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 5]);
    }
    if ((index + 6) < count) {
        tbSeeDoc.rows[0].cells[6].innerHTML = CreateSeeDocLink(SeeDoctorInfor[index + 6]);
    }
}

//取得该就诊号的序号
function GetShowRecordIndex()
{
    var count = SeeDoctorInfor.length;
    for(var index =0; index < count; index++)
    {
      var oneInfor = SeeDoctorInfor[index];
      if(oneInfor.episodeId == DiagnoseInfor.episodeId)
      {
        return index;
      }
    }
}

//创建就诊记录的link
function CreateSeeDocLink(infor) {
    return '<a type="link" href="####" onclick="ChangeInfor();" inforId="' + infor.episodeId + '" >' + formatDateByConfig(infor.episodeDate) + '</a>';
}

//切换就诊记录
function ChangeInfor() {
    var episodeId = event.srcElement.inforId;
    StartIndex = 0;
    var actionParams = { 'actionCode': 'GetDiagnoseData', 'episodeId': episodeId, 'startIndex': StartIndex, 'pageCount': PageCount };
    GetData(actionParams);
}

//取得诊断数据
function GetData(actionParams) {
    Ext.Ajax.request({
        url: accessURL,
        success: GetDataSuccess,
        failure: GetDataFailure,
        params: actionParams
    });
}
//获取数据成功
function GetDataSuccess(o, p, r) {
    DiagnoseInfor = eval(o.responseText);
      ClearData();
      ShowPatientInfor(DiagnoseInfor.PatientInfo);
      BuildData();
      SetButtonState();
      SetSeeDocLinkStyle();
}
//获取数据失败
function GetDataFailure(o, p) {
    Ext.MessageBox.show({
        title: "错误信息",
        msg: "获取数据失败",
        width: 400,
        buttons: Ext.MessageBox.OK,
        icon: Ext.MessageBox.ERROR
    });
}

//清空数据
function ClearData() {
    document.getElementById("divDiagnose").innerHTML = CreateTableHtml();
}

//设定日期移动按钮的状态
function SetButtonState() {
    if ((StartIndex + PageCount) < DiagnoseInfor.inforCount) {
        document.getElementById("imgNextDate").disabled = false;
        document.getElementById("imgNextDate").src = "../../images/TimeLine/Date-next.gif";
    }
    else {
        document.getElementById("imgNextDate").disabled = true;
        document.getElementById("imgNextDate").src = "../../images/TimeLine/Date-next-disabled.gif";
    }

    if ((StartIndex - PageCount) >= 0) {
        document.getElementById("imgLastDate").disabled = false;
        document.getElementById("imgLastDate").src = "../../images/TimeLine/Date-prev.gif";
    }
    else {
        document.getElementById("imgLastDate").disabled = true;
        document.getElementById("imgLastDate").src = "../../images/TimeLine/Date-prev-disabled.gif";
    }
}

//设定当前选中的就诊连接的样式
function SetSeeDocLinkStyle() {
    var linkArray = document.getElementById("divSeeDoctor").getElementsByTagName("a");
    for (var i = 0; i < linkArray.length; i++) {
        var oneLink = linkArray[i];
        if (oneLink.inforId == DiagnoseInfor.episodeId) {
            oneLink.className = "csSeeDocLinkSeleted";
        }
        else {
            oneLink.className = "";
        }
    }
}
