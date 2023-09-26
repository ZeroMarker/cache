/**
 * 模块:     配液停止签打印记录
 * 编写日期: 2018-03-02
 * 编写人:   dinghongying
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridOrdExe();
    InitGridCPrint();
    $('#btnFind').bind("click", Query);
    $('#btnPrint').bind("click", PrintStopLabel);
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
        }
    });
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { placeholder: "病区..." });
}

// 停止签医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'gridOrdExeChk', checkbox: true },
            { field: "doseDateTime", title: '用药时间', width: 95 },
            { field: "wardDesc", title: '病区', width: 150 },
            { field: 'bedNo', title: '床号', width: 50 },
            { field: "patNo", title: '登记号', width: 100 },
            { field: "patName", title: '病人姓名', width: 70 },
            { field: "batNo", title: '批次', width: 50 },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                styler: function(value, row, index) {
                    var colColor = row.colColor;
                    var colorStyle = "";
                    if ((colColor % 2) == 0) { // 按成组的背景色
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: '药品', width: 300 },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrucDesc', title: '用法', width: 75 },
            { field: 'priDesc', title: '医嘱优先级', width: 80 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'bUomDesc', title: '单位', width: 50 },
            { field: 'docName', title: '医生', width: 80 },
            { field: 'pogId', title: 'pogId', width: 80, hidden: true },
            { field: "colColor", title: 'colColor', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + "?action=JsGetStopOeQueryDetail",
        fitColumns: false,
        border: true,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        border: false,
        onLoadSuccess: function() {},
        onClickRow: function(rowIndex, rowData) {},
        rowStyler: function(index, row) {

        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: false,
                Value: rowData.pogId
            });
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $('#gridOrdExe').datagrid("unselectAll");
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
// 停止签明细列表
function InitGridCPrint() {
    var columns = [
        [
            { field: 'cPrtId', title: 'PrtId', width: 125, hidden: true },
            { field: 'cPrtNo', title: '停止签打印号', width: 125 },
            { field: 'cPrtUserName', title: '打印人', width: 100 },
            { field: 'cPrtDateTime', title: '打印时间', width: 150 }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.StopPrint",
            QueryName: "CPrintList"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onLoadSuccess: function() {},
        onClickRow: function(rowIndex, rowData) {
            var wardId = $('#cmbWard').combobox('getValue');
            var patNo = $("#txtPatNo").val().trim();
            $('#gridOrdExe').datagrid({
                queryParams: {
                    params: rowData.cPrtId + "^" + wardId + "^" + patNo
                }
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridCPrint", dataGridOption);
}
//查询
function Query() {
    var params = QueryParams();
    $('#gridCPrint').datagrid("query", {
        inputStr: params
    });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //起始日期
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //截止日期
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var params = locId + "^" + wardId + "^" + prtStDate + "^" + prtEdDate + "^" + prtStTime + "^" + prtEdTime + "^" + patNo;
    return params;
}

// 补打停止签
function PrintStopLabel() {
    $.messager.confirm('打印提示', '您确认重新打印停止签吗?', function(r) {
        if (r) {
            if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
                return;
            }
            var pogArr = GetCheckedPogArr();
            var pogLen = pogArr.length;

            if (pogLen == 0) {
                return;
            }
            // 插入停止签记录表,默认再次打印不插入
            /*
            var pCPRet = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "SaveCPrint", pogArr.join("^"));
            var pCPRetArr = pCPRet.split("^");
            var pCPId = pCPRetArr[0];
            if (pCPId < 0) {
                $.messager.alert('提示', pCPRetArr[1], "warning");
                return;
            }
            */
            var count = 0;
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
                PIVASPRINT.Label({ pogId: pogId, printTask: printTask, rePrint: "(补)" })
            }

        }
    });
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