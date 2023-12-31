$(document).ready(function() {
    var columns = [
        [
            { field: "PatDeptDesc", title: "科室", width: 80 },
            { field: "MaterialDesc", title: "产品名称", width: 240 },
            { field: "Qty", title: "使用数量", width: 80 },
            { field: "Spec", title: "型号规格", width: 120 },
            { field: "Tracker", title: "产品跟踪器", width: 120, hidden: true },
            { field: "ExpireDate", title: "有效期", width: 100 },
            { field: "RegCert", title: "注册证号", width: 100 },
            { field: "Manufacturer", title: "生产企业", width: 100, hidden: true },
            { field: "Vendor", title: "供货单位", width: 180, sortable: true },
            { field: "BatchNo", title: "批号", width: 120 },
            { field: "PatName", title: "患者姓名", width: 100 },
            { field: "MedcareNo", title: "住院号", width: 80 },
            { field: "OperDate", title: "手术日期", width: 100 },
            { field: "SurgeonDesc", title: "手术医生", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#materialsBox"),
        gridColumns: columns,
        gridTitle: "植入医疗器械使用纪录",
        gridTool: "#materialsTools",
        form: $("#dataForm"),
        modelType: CLCLS.Model.StockConsume,
        queryType: ANCLS.BLL.ChargeRecord,
        queryName: "FindIMDRecordNew",
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
            param.Arg1 = session.DeptID;
            param.Arg2 = $("#startDate").datebox("getValue");
            param.Arg3 = $("#endDate").datebox("getValue");
            param.Arg4 = $("#medcareNo").val();
            param.Arg5 = $("#stockItem").combobox("getValue");
            param.ArgCnt = 5;
        },
        sortName: "Vendor",
        sortOrder: "asc",
        remoteSort: false,
        view: groupview,
        groupField: "Vendor",
        groupFormatter: function(value, rows) {
            return value;
        },
    });

    initQueryConditions();

    $("#btnPrint").linkbutton({
        onClick: function() {
            printIMDRecord();
        }
    });
});

function initDefaultValue(dataForm) {

}

function initQueryConditions() {
    var today = (new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue", today);

    $("#stockItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindStockItem";
            param.Arg1 = param.q ? parm.q : "";
            param.ArgCnt = 1;
        }
    });
}

function printIMDRecord() {
    lodop = getLodop();
    lodop.PRINT_INIT("IMDRecord" + session.OPSID);
    // lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
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
    lodop.ADD_PRINT_TEXT(30, 452, "100%", 60, "植入性医疗器械使用记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
    lodop.ADD_PRINT_HTM(35, 750, "100%", 28, "<span tdata='pageNO'>第##页</span><span tdata='pageCount'>共##页</span>");
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

    var groups = $("#materialsBox").datagrid("groups");
    var length = groups.length;
    var group, rowLength;
    var headerHtmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}",
        "th {font-size:14px;font-weight:bold;text-align:center}",
        "tr>td {text-align:center;font-size:12px;} tr {height:24px;}",
        ".opercount {width:30px;} .itemtitle {width:60px;} </style>",
        "<table style='table-layout:fixed;'><thead><tr><th style='width:80px'>科室</th><th style='width:230px'>产品名称</th>",
        "<th style='width:40px'>数量</th><th style='width:80px'>型号规格</th><th style='width:120px'>批号</th><th style='width:60px'>效期</th>",
        "<th style='width:180px'>供货单位</th><th style='width:60px'>患者姓名</th><th style='width:60px'>住院号</th><th style='width:60px'>手术日期</th>",
        "<th style='width:60px'>手术医生</th></tr></thead><tbody>",
    ];

    var htmlArr = [];
    var row, height = 0;
    for (var i = 0; i < length; i++) {
        if (i > 0) {
            lodop.NEWPAGEA();
        }

        htmlArr = [].concat(headerHtmlArr);
        group = groups[i];
        rowLength = group.rows.length;
        for (var j = 0; j < rowLength; j++) {
            row = group.rows[j];
            htmlArr.push("<tr>");
            htmlArr.push("<td style='font-size:12px;'>" + row.PatDeptDesc + "</td>");
            htmlArr.push("<td>" + row.MaterialDesc + "</td>");
            htmlArr.push("<td>" + row.Qty + "</td>");
            htmlArr.push("<td>" + row.Spec + "</td>");
            htmlArr.push("<td>" + row.BatchNo + "</td>");
            htmlArr.push("<td>" + row.ExpireDate + "</td>");
            htmlArr.push("<td>" + row.Vendor + "</td>");
            htmlArr.push("<td>" + row.PatName + "</td>");
            htmlArr.push("<td>" + row.MedcareNo + "</td>");
            htmlArr.push("<td>" + row.OperDate + "</td>");
            htmlArr.push("<td>" + row.SurgeonDesc + "</td>");
            htmlArr.push("</tr>");
        }
        htmlArr.push("</tbody></table>");
        lodop.ADD_PRINT_TABLE(80, 20, 1060, "100%", htmlArr.join(""));
    }
}