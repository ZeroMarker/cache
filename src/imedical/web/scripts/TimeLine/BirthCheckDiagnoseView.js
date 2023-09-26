//显示的列
var ColArray = null;
//列头的宽度
var HeaderWidth=140;
//列的宽度
var CellWidth = 200;
//显示数据的开始索引
var StartIndex = 0;
var accessURL = "extgetbirthcheckdata.csp";
Ext.onReady(function() {
    ShowPage();
});

//显示页面
function ShowPage() {
    var pnlView = new Ext.FormPanel({
        id: 'frmDiagnose',
        title: '',
        width: '100%',
        height: 510,
        autoScroll: true,
        renderTo: document.body
    });

    ShowTable();
    BuildHeader();
    BuildData();
    SetButtonState();
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

//创建表格信息
function CreateTableInfor() {
    var colCount = PageCount;
    var rowCount = DiagnoseType.length;
    if (colCount == 0 || rowCount == 0) {
        Ext.MessageBox.show({
            title: "提示信息",
            msg: "没有数据",
            width: 400,
            buttons: Ext.MessageBox.OK,
            icon: Ext.MessageBox.INFO
        });
        return "";
    }
    var tableWidth = (CellWidth *colCount) + HeaderWidth;
    var tableHtml = '<div class="csDivDiagnose" ><table id="tbDiagnose" class ="csTbDiagnose" border="0" cellpadding="0" cellspacing="1" style="width:' + tableWidth + 'px;" >';
    for (var index = 0; index < rowCount + 1; index++) {
        if (index == 0) {
            tableHtml += CreateTableHeader(colCount);
        }
        else {
            var rowHeaderTxt = DiagnoseType[index-1].Description;
            tableHtml += CreateTableRow(colCount, rowHeaderTxt);
        }
    }
    tableHtml += "</table><div>";
    return tableHtml;
}

//创建表头
function CreateTableHeader(colCount) {
    var headerHtml = '<tr><td class ="csBirthCheckDiagnoseHeader" style="width:' + HeaderWidth + 'px;" ><table style="width:100%;height:100%;"><tr style="background-color:Transparent;"><td><img id="imgLastDate" style="cursor:hand;" src="../../images/TimeLine/Date-prev.gif" onclick="LastData();" align="left"/></td><td >日期</td><td ><img id="imgNextDate" style="cursor:hand;" src="../../images/TimeLine/Date-next.gif" onclick="NextData();" align="right"/></td></tr></table></td>';
    for (var i = 0; i < colCount; i++) {
        headerHtml += '<td class ="csDiagnoseHeader" style="width:' + CellWidth + 'px;" ></td>';
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
function CreatCol() {
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
    if (ColArray.length != 0 && ColArray.length < PageCount) {
        var count = PageCount - ColArray.length;
        for (var i = 0; i < count; i++) {
            ColArray.push("&nbsp;");
        }
    }
}

//创建头部
function BuildHeader() {
    CreatCol();
    var tblDiagnose = document.getElementById("tbDiagnose");
    var headerRow = tblDiagnose.rows[0];
    for (var cellIndex = 1; cellIndex < headerRow.cells.length; cellIndex++) {
        var oneCell = headerRow.cells[cellIndex];
        if ((cellIndex-1) < ColArray.length) {
            oneCell.innerHTML = ColArray[cellIndex-1];
        }
    }
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

//上一页数据
function LastData() {
    StartIndex = StartIndex - PageCount;
    var actionParams = { 'actionCode': 'GetDiagnoseData', 'patientID': patientID, 'startIndex': StartIndex, 'pageCount': PageCount };
    GetData(actionParams);
}

//下一页数据
function NextData() {
    StartIndex = StartIndex + PageCount;
    var actionParams = { 'actionCode': 'GetDiagnoseData', 'patientID': patientID, 'startIndex': StartIndex, 'pageCount': PageCount };
    GetData(actionParams);
}

//清空数据
function ClearData() {
    var tblDiagnose = document.getElementById("tbDiagnose");
    for (var rowIndex = 1; rowIndex < tblDiagnose.rows.length; rowIndex++) {
        var oneRow = tblDiagnose.rows[rowIndex];
        for (var cellIndex = 1; cellIndex < oneRow.cells.length; cellIndex++) {
            var oneCell = oneRow.cells[cellIndex];
            oneCell.innerHTML = "";
        }
    }
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
function GetDataSuccess(o, p,r) {
    DiagnoseInfor = eval(o.responseText);
    ClearData();
    BuildHeader();
    BuildData();
    SetButtonState();
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
