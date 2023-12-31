$(document).ready(function() {
    var columns = [
        [
            { field: "ShiftDate", title: "日期", width: 120 },
            { field: "PatDeptDesc", title: "科室", width: 140 },
            { field: "PatName", title: "患者姓名", width: 120 },
            { field: "PatGender", title: "性别", width: 80 },
            { field: "PatAge", title: "年龄", width: 80 },
            { field: "MedcareNo", title: "住院号", width: 100 },
            { field: "PrevDiagnosisDesc", title: "术前诊断", width: 100 },
            { field: "SpecimenDesc", title: "标本名称", width: 100 },
            { field: "SpecimenQty", title: "标本数量", width: 80 },
            { field: "CirNurse", title: "巡回护士", width: 80 },
            { field: "DutyNurse", title: "标本班护士", width: 100 },
            { field: "CirShiftDT", title: "交接时间", width: 100 },
            { field: "DutyNurse", title: "标本班护士", width: 100 },
            { field: "PathRecipient", title: "病理科接收人", width: 120 },
            { field: "PathShiftDT", title: "交接时间", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#specimenShiftBox"),
        gridColumns: columns,
        gridTitle: "标本交接记录",
        gridTool: "#specimenShiftTools",
        form: $("#dataForm"),
        modelType: ANCLS.Model.SpecimenShift,
        queryType: ANCLS.BLL.SpecimenManager,
        queryName: "FindSpecimenShiftList",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        headerCls: "panel-header",
        onBeforeLoad:function(param){
            param.Arg1=$("#startDate").datetimebox("getValue");
            param.Arg2=$("#endDate").datetimebox("getValue");
            param.Arg3=$("#patName").val();
            param.Arg4=$("#medicareNo").val();
            param.Arg5="";
            param.Arg6="";
            param.ArgCnt=6;
        }
    });

    $("#btnPrint").linkbutton({
        onClick:function(){
            printSpecimenShift();
        }
    });

    initQueryConditions();
});

function initDefaultValue(dataForm) {

}

function initQueryConditions() {
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate").datetimebox("setValue",(today+" 00:00:00"));
    $("#endDate").datetimebox("setValue",(today+" 23:59:59"));
   // $("#startDate,#endDate").datetimebox("setValue", today);

    $("#circualNurse,#specimenNurse").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = session.DeptID;
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });
}

function printSpecimenShift(){
    var lodop=getLodop();
    var tableArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}",
        "th {font-size:16px;font-weight:bold;text-align:center} tr>td {text-align:center} tr {height:24px;} </style>",
        "<table><thead><tr>",
        "<th>日期</th>",
        "<th>科室</th>",
        "<th>患者姓名</th>",
        "<th>性别</th>",
        "<th>年龄</th>",
        "<th>住院号</th>",
        "<th>术前诊断</th>",
        "<th>标本名称</th>",
        "<th>标本数量</th>",
        "<th>巡回护士</th>",
        "<th>标本班护士</th>",
        "<th>交接时间</th>",
        "<th>标本班护士</th>",
        "<th>病理科接收人</th>",
        "<th>交接时间</th>",
        "</tr></thead>",
        "<tbody>"
    ];
    var dataRows=$("#specimenShiftBox").datagrid("getRows");
    if(dataRows && dataRows.length>0){
        for(var i=0;i<dataRows.length;i++){
            var dataRow=dataRows[i];
            tableArr.push("<tr>");
            tableArr.push("<td>"+dataRow.ShiftDate+"</td>");
            tableArr.push("<td>"+dataRow.PatDeptDesc+"</td>");
            tableArr.push("<td>"+dataRow.PatName+"</td>");
            tableArr.push("<td>"+dataRow.PatGender+"</td>");
            tableArr.push("<td>"+dataRow.PatAge+"</td>");
            tableArr.push("<td>"+dataRow.MedcareNo+"</td>");
            tableArr.push("<td>"+dataRow.PrevDiagnosisDesc+"</td>");
            tableArr.push("<td>"+dataRow.SpecimenDesc+"</td>");
            tableArr.push("<td>"+dataRow.SpecimenQty+"</td>");
            tableArr.push("<td>"+dataRow.CirNurse+"</td>");
            tableArr.push("<td>"+dataRow.DutyNurse+"</td>");
            tableArr.push("<td>"+dataRow.CirShiftDT+"</td>");
            tableArr.push("<td>"+dataRow.DutyNurse+"</td>");
            tableArr.push("<td>"+dataRow.PathRecipient+"</td>");
            tableArr.push("<td>"+dataRow.PathShiftDT+"</td>");
            tableArr.push("</tr>");
        }
        
    }
    tableArr.push("</tbody></table>");
    lodop.PRINT_INIT("标本交接纪录");
    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_TEXT(10, 200, "100%", 60, "山西省肿瘤医院临标本交接纪录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.SET_PRINT_STYLEA(0,"ItemType",1);

    lodop.ADD_PRINT_TABLE(50, 10, "100%", "100%", tableArr.join(""));
    if(lodop.SET_PRINTER_INDEX(PrintSetting.Common.Printer)){
        lodop.SET_PRINT_PAGESIZE(2, 0, 0, PrintSetting.Common.Paper);
        lodop.PREVIEW();
    }
}