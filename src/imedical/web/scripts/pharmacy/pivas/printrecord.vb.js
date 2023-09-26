/**
 * 模块:     配液流程单据打印记录
 * 编写日期: 2018-04-20
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridOrdExe();
    InitGridPrint();
    $('#btnFind').bind("click", Query);
    $('#btnPrint').bind("click", PrintSelect);
    $('#btnPrintAll').bind("click", PrintAll);
    $('#btnClear').bind("click", Clear);
    $('#txtPatNo').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
        }
    });
});

function InitDict() {
    // 日期
    PIVAS.Date.Init({ Id: 'datePrtStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'datePrtEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    PIVAS.ComboBox.Init({ Id: 'cmbPivasLoc', Type: 'PivaLoc' }, {
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivasLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivasLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function(data) {
            var locId = data.RowId;
            PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType', StrParams: locId }, { "placeholder": "配液状态..." });
            PIVAS.ComboBox.Init({ Id: 'cmbPivaStat', Type: 'PIVAState' }, { editable: false });
        }
    });
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { placeholder: "病区..." });
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { "placeholder": "工作组..." });
    PIVAS.ComboBox.Init({ Id: 'cmbPivaStat', Type: 'PIVAState' }, { editable: false, "placeholder": "配液状态..." });
}

// 停止签医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'gridOrdExeChk', checkbox: true },
            { field: 'pNo', title: '序号', width: 40 },
            { field: "doseDateTime", title: '用药时间', width: 100 },
            { field: "patInfo", title: '病人信息', width: 200 },
            { field: "batNo", title: '批次', width: 50 },
            { field: 'incDescStr', title: '药品信息', width: 300 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrDesc', title: '用法', width: 75 },
            { field: 'priDesc', title: '医嘱优先级', width: 80 },
            { field: 'pogId', title: 'pogId', width: 80, hidden: true },
            { field: 'pid', title: 'pid', width: 40, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PrintDetail"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        onLoadSuccess: function() {},
        onClickRow: function(rowIndex, rowData) {},
        onBeforeLoad: function(param) {
            ClearTmpGlobal();
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
// 签明细列表
function InitGridPrint() {
    var columns = [
        [
            { field: 'psName', title: '配液状态', width: 75, styler: PIVAS.Grid.Styler.PivaState },
            { field: 'pogsNo', title: '流程单号', width: 170 },
            { field: 'pogsUserName', title: '操作人', width: 90 },
            { field: 'pogsDateTime', title: '操作时间', width: 155 }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PogsNoList"
        },
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onLoadSuccess: function() {
            ClearTmpGlobal();
            $("#gridOrdExe").dhcstgrideu("clear");
        },
        onClickRow: function(rowIndex, rowData) {
            var params = QueryParams();
            var pogsNo = rowData.pogsNo;
            $('#gridOrdExe').datagrid('query', { pogsNo: pogsNo, inputStr: params });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPrint", dataGridOption);
}
//查询
function Query() {
    var params = QueryParams();
    $('#gridPrint').datagrid('query', { inputStr: params });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //起始日期
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //截止日期
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var pNo = $("#txtPNo").val().trim();
    var workTypeId = $("#cmbWorkType").combobox("getValue");
    var psNumber = $("#cmbPivaStat").combobox("getValue");
    var params = locId + "^" + wardId + "^" + prtStDate + "^" + prtEdDate + "^" + prtStTime + "^" +
        prtEdTime + "^" + patNo + "^" + pNo + "^" + workTypeId + "^" + psNumber;
    return params;
}


function GetCheckedPogArr() {
    var pogArr = [];
    var gridChecked = $('#gridOrdExe').datagrid('getChecked');
    if (gridChecked == "") {
        $.messager.alert("提示", "请先选择记录", "warning");
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == "") {
            continue;
        }
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}

/// 打印勾选
function PrintSelect() {
    if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
        return;
    }
    var pogArr = GetCheckedPogArr();
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        return;
    }
    var printNum = PIVASPRINT.PrintNum;
    for (var pogI = 0; pogI < pogLen; pogI++) {
        var pogId = pogArr[pogI];
        var printTask = "0";
        var count = pogI + 1;
        if (count % (printNum) == 0) {
            printTask = "1";
        }
        if (count == pogLen) {
            printTask = "1";
        }
        PIVASPRINT.Label({
            pogId: pogId,
            printTask: printTask,
            pageNumbers: pogLen,
            pageNo: count,
            rePrint: "(补)"
        })
    }
}
/// 打印所有
function PrintAll() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        $.messager.alert("提示", "请先查询出标签明细", "warning");
        return;
    }
    var pid = gridRows[0].pid;
    $.messager.progress({
        title: "请耐心等待...",
        text: '<b>{value}%</b>  打  印  数  据  中  ',
        interval: 1000000
    })
    $.cm({
        ClassName: "web.DHCSTPIVAS.PrintRecord",
        MethodName: "JsonLabels",
        pid: pid
    }, function(retJson) {
        PIVASPRINT.LabelsJson = retJson;
        var retLen = retJson.length;
        if (retLen > 0) {
            PIVASPRINT.LabelsJsonPrint(retLen, 0)
        } else {
            $.messager.progress("close");
        }
    })
}
/// 清屏
function Clear() {
    ClearTmpGlobal();
    window.location.reload();
    /*
    InitDict();
    $("#gridPrint").datagrid("clear");
    $("#gridOrdExe").datagrid("clear");
    */
}
/// 清除临时global
function ClearTmpGlobal() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        return;
    }
    var pid = gridRows[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.PrintRecord", "KillPrintData", pid);
}
window.onbeforeunload = function() {
    ClearTmpGlobal();
}