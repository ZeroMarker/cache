$(document).ready(function() {
    var columns = [
        [
            { field: "CareProvDesc", title: "护士姓名", width: 120 },
            { field: "OperDate", title: "手术日期", width: 120 },
            { 
                field: "OperationDesc", title: "手术名称", width: 600,
                formatter: function (value, row, index) {
                    var ret=value.replace("&&&","<br>");
                    return ret;
                }
             }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#nurseWorkBox"),
        gridColumns: columns,
        gridTitle: "手术护士工作量统计表",
        gridTool: "#nurseWorkTools",
        form: $("#nurseWorkForm"),
        modelType: ANCLS.Model.OperSchedule,
        queryType: ANCLS.BLL.WorkStat,
        queryName: "FindNurseWorkStat",
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
            param.Arg1=$("#startDate").datebox("getValue");
            param.Arg2=$("#endDate").datebox("getValue");
            param.Arg3=$("#nurseDept").combobox("getValue");
            param.Arg4=$("#nurse").combobox("getValue");
            param.ArgCnt=4;
        },
        sortName: "",
        sortOrder: "",
        remoteSort: false,
        pagination:false,
        view: groupview,
        groupField: "CareProvDesc",
        groupFormatter: function (value, rows) {
            return value;
        }
    });

    initQueryConditions();

    $("#btnPrint").linkbutton({
        onClick:function(){
            printNurseWork();
        }
    });
});

function initDefaultValue(dataForm) {

}

function initQueryConditions() {
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue", today);

    $("#nurseDept").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2="OP^OUTOP^EMOP"
            param.ArgCnt = 2;

        },
        onSelect:function(record){
            $("#nurse").combobox("reload");
        },
        mode:"remote"
    });

    $("#nurse").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2=$("#nurseDept").combobox("getValue");
            param.ArgCnt = 2;
        },
        mode:"remote"
    });
}

function printNurseWork(){
    lodop = getLodop();
    lodop.PRINT_INIT("NurseWorkStat" + session.OPSID);
    // lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(2,0,0,"A4");
    if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer)){
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        lodop.PREVIEW();
        
    }else{
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        lodop.PREVIEW();
    }
}

function createPrintOnePage(lodop){
    lodop.ADD_PRINT_TEXT(30, 452, "100%", 60, "植入性医疗器械使用记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.SET_PRINT_STYLEA(0,"ItemType",1);
    lodop.ADD_PRINT_HTM(35, 750, "100%", 28, "<span tdata='pageNO'>第##页</span><span tdata='pageCount'>共##页</span>");
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var headerHtmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;}",
        "th {font-size:14px;font-weight:bold;text-align:center}",
        "tr>td {text-align:center;font-size:12px;} tr {height:24px;}",
        ".opercount {width:30px;} .itemtitle {width:60px;} </style>",
        "<table style='table-layout:fixed;'><thead><tr><th style='width:100px'>科室</th><th style='width:230px'>产品名称</th>",
        "<th style='width:40px'>数量</th><th style='width:100px'>型号规格</th><th style='width:80px'>批号</th><th style='width:60px'>效期</th>",
        "<th style='width:180px'>供货单位</th><th style='width:60px'>患者姓名</th><th style='width:60px'>住院号</th><th style='width:60px'>手术日期</th>",
        "<th style='width:60px'>手术医生</th></tr></thead><tbody>",
    ];
    var htmlArr=[];
    
    var recordDataObj=$("#materialsBox").datagrid("getData");
    if(recordDataObj.rows && recordDataObj.rows.length>0){
        htmlArr.push(headerHtmlArr.join(""));
        var preVendor=recordDataObj.rows[0].Vendor;
        for(var i=0;i<recordDataObj.rows.length;i++){
            var recordData=recordDataObj.rows[i];
            if(recordData.Vendor!==preVendor){
                htmlArr.push("</tbody></table>");
                lodop.ADD_PRINT_TABLE(80, 20, 1060, "100%", htmlArr.join(""));
                lodop.NEWPAGE();
                htmlArr=[];
                htmlArr.push(headerHtmlArr.join(""));
            }
            htmlArr.push("<tr>");
            htmlArr.push("<td style='width:100px'>"+recordData.PatDeptDesc+"</td>");
            htmlArr.push("<td style='width:230px'>"+recordData.MaterialDesc+"</td>");
            htmlArr.push("<td style='width:40px'>"+recordData.Qty+"</td>");
            htmlArr.push("<td style='width:100px'>"+recordData.Spec+"</td>");
            htmlArr.push("<td style='width:80px'>"+recordData.BatchNo+"</td>");
            htmlArr.push("<td style='width:60px'>"+recordData.ExpireDate+"</td>");
            htmlArr.push("<td style='width:180px'>"+recordData.Vendor+"</td>");
            htmlArr.push("<td style='width:60px'>"+recordData.PatName+"</td>");
            htmlArr.push("<td style='width:60px'>"+recordData.MedcareNo+"</td>");
            htmlArr.push("<td style='width:60px'>"+recordData.OperDate+"</td>");
            htmlArr.push("<td style='width:60px'>"+recordData.SurgeonDesc+"</td>");
            htmlArr.push("</tr>");
            preVendor=recordData.Vendor;
        }
        htmlArr.push("</tbody></table>");
        lodop.ADD_PRINT_TABLE(80, 20, 1060, "100%", htmlArr.join(""));
    }
}