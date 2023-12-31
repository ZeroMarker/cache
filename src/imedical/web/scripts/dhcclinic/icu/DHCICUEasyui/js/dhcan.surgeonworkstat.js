$(document).ready(function() {
    var columns = [
        [
            { field: "SurgeonDeptDesc", title: "科室", width: 120, hidden: true },
            { field: "CareProvDesc", title: "医生姓名", width: 120 },
            { field: "Count1", title: "一台区", width: 100 },
            { field: "Count2", title: "二台区", width: 100 },
            { field: "Count3", title: "三台区", width: 100 },
            { field: "Count4", title: "四台区", width: 100 },
            { field: "Count5", title: "五台区", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#surgeonWorkBox"),
        gridColumns: columns,
        gridTitle: "手术医生工作量统计表",
        gridTool: "#surgeonWorkTools",
        form: $("#surgeonWorkForm"),
        modelType: ANCLS.Model.OperSchedule,
        queryType: ANCLS.BLL.WorkStat,
        queryName: "FindSurgeonWorkStat",
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
        onBeforeLoad: function(param) {
            param.Arg1 = $("#startDate").datebox("getValue");
            param.Arg2 = $("#endDate").datebox("getValue");
            param.Arg3 = $("#surgeonDept").combobox("getValue");
            param.Arg4 = $("#surgeon").combobox("getValue");
            param.ArgCnt = 4;
        },
        sortName: "",
        sortOrder: "",
        remoteSort: false,
        pagination: false,
        view: groupview,
        groupField: "SurgeonDeptDesc",
        groupFormatter: function(value, rows) {
            return value;
        }
    });

    initQueryConditions();

    $("#btnPrint").linkbutton({
        onClick: function() {
            printSurgeonWork();
        }
    });
});

function initDefaultValue(dataForm) {

}

function initQueryConditions() {
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue", today);

    $("#surgeonDept").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT"
            param.ArgCnt = 2;

        },
        onSelect: function(record) {
            $("#surgeon").combobox("reload");
        },
        mode: "remote"
    });

    $("#surgeon").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = $("#surgeonDept").combobox("getValue");
            param.ArgCnt = 2;
        },
        mode: "remote"
    });
}

function printSurgeonWork() {
    lodop = getLodop();
    lodop.PRINT_INIT("IMDRecord" + session.OPSID);
    // lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    if (lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer)) {
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        lodop.PREVIEW();

    } else {
        createPrintOnePage(lodop);
        lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
        lodop.PREVIEW();
    }
}

function createPrintOnePage(lodop) {
    lodop.ADD_PRINT_TEXT(30, 300, "100%", 60, "手术医生工作量汇总");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    // lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    // lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    lodop.ADD_PRINT_HTM(35, 500, "100%", 28, "<span tdata='pageNO'>第##页</span><span tdata='pageCount'>共##页</span>");
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var headerHtmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;}",
        "th {font-size:14px;font-weight:bold;text-align:center}",
        "tr>td {text-align:center;font-size:12px;} tr {height:24px;}",
        ".opercount {width:30px;} .itemtitle {width:60px;} </style>",
        "<table style='table-layout:fixed;'><thead><tr><th style='width:100px'>手术医生</th>",
        "<th style='width:120px'>一台区</th><th style='width:120px'>二台区</th>",
        "<th style='width:120px'>三台区</th><th style='width:120px'>四台区</th>",
        "<th style='width:120px'>五台区</th></tr></thead><tbody>",
    ];
    var htmlArr = [];

    var recordDataObj = $("#surgeonWorkBox").datagrid("getData");
    if (recordDataObj.rows && recordDataObj.rows.length > 0) {
        htmlArr.push(headerHtmlArr.join(""));
        for (var i = 0; i < recordDataObj.rows.length; i++) {
            var recordData = recordDataObj.rows[i];
            htmlArr.push("<tr>");
            htmlArr.push("<td>" + recordData.CareProvDesc + "</td>");
            htmlArr.push("<td>" + recordData.Count1 + "</td>");
            htmlArr.push("<td>" + recordData.Count2 + "</td>");
            htmlArr.push("<td>" + recordData.Count3 + "</td>");
            htmlArr.push("<td>" + recordData.Count4 + "</td>");
            htmlArr.push("<td>" + recordData.Count5 + "</td>");
            htmlArr.push("</tr>");
            preVendor = recordData.Vendor;
        }
        htmlArr.push("</tbody></table>");
        lodop.ADD_PRINT_TABLE(80, 20, 1060, "100%", htmlArr.join(""));
    }
}