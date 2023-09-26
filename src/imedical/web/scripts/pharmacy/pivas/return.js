/**
 * 模块:     配液退药
 * 编写日期: 2018-08-13
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var ReturnPid = "";
$(function () {
    $(".newScroll").mCustomScrollbar({
        theme: "inset-2-dark",
        scrollInertia: 100
    })
    InitDict();
    InitGridPat();
    InitGridOrdExe();
    InitGridWard();
    InitGridArc();
    $('#btnFind').bind("click", Query);
    $('#btnReturn').bind("click", ConfirmReturn);
    $('#txtPatNo').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
            Query();
        }
    });
    $('#txtBarCode').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            Query();
        }
    });
    $('#txtScanCode').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            ConfirmScanReturn();
        }
    });
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    // 日期
    PIVAS.Date.Init({
        Id: 'dateStart',
        LocId: "",
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'dateEnd',
        LocId: "",
        Type: 'End',
        QueryType: 'Query'
    });
    // 病区
    PIVAS.ComboBox.Init({
        Id: 'cmbWard',
        Type: 'Ward'
    }, {
        placeholder: "病区..."
    });
    // 退药原因
    PIVAS.ComboBox.Init({
        Id: 'cmbRetReason',
        Type: 'RetReason'
    }, {
        placeholder: "退药原因...",
        width: 270
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbScanRetReason',
        Type: 'RetReason'
    }, {
        placeholder: "退药原因...",
        width: 200,
        onLoadSuccess: function () {
            $("#cmbScanRetReason").combobox('showPanel');
            $("#cmbScanRetReason").combobox("textbox").focus();
        },
        onHidePanel: function (data) {
            //$("#txtScanCode").focus();
        }
    });
}
// 病人列表
function InitGridPat() {
    var columns = [
        [{
                field: 'admId',
                title: 'admId',
                width: 80,
                halign: 'center',
                hidden: true
            },
            {
                field: 'patId',
                title: 'PatId',
                width: 80,
                halign: 'center',
                hidden: true
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 90
            },
            {
                field: 'patName',
                title: '姓名',
                width: 90
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 180
            }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.Return",
            QueryName: "QueryPat"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        fitColumns: true,
        onSelect: function (rowIndex, rowData) {
            // 查询明细
            var params = QueryParams() + "^" + rowData.admId;
            $('#gridOrdExe').datagrid('query', {
                inputStr: params,
                rows: 9999
            });
        },
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0);
            } else {
                $("#gridOrdExe").datagrid("clear");
                $("#txtBarCode").val("");
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPat", dataGridOption);
}
// 医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [{
                field: 'gridOrdExeChk',
                checkbox: true
            },
            {
                field: "psNumber",
                title: 'psNumber',
                width: 100,
                hidden: true
            },
            {
                field: "psState",
                title: '状态',
                width: 45,
                styler: function (value, row, index) {
                    var psNumber = row.psNumber;
                    var colorStyle = "";
                    if ((parseInt(psNumber) > 50) && (row.packFlag != "P")) {
                        colorStyle = "background-color:#ffe3e3;color:#ff3d2c;font-weight:bold;";
                    }
                    return colorStyle;
                }
            },
            {
                field: "mDsp",
                title: 'mDsp',
                width: 100,
                hidden: true
            },
            {
                field: "dspId",
                title: 'dspId',
                width: 100,
                hidden: true
            },
            {
                field: "doseDateTime",
                title: '用药时间',
                width: 100
            },
            {
                field: "batNo",
                title: '批次',
                width: 50,
                styler: function (value, row, index) {
                    var colorStyle = "";
                    if (row.packFlag != "") {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                styler: function (value, row, index) {
                    var colColor = row.colColor;
                    var colorStyle = "";
                    if ((colColor % 2) == 0) { // 按成组的背景色
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: '药品',
                width: 200
            },
            {
                field: 'incSpec',
                title: '规格',
                width: 100
            },
            {
                field: 'manfDesc',
                title: "厂商",
                width: 100
            },
            {
                field: 'dspQty',
                title: '发药数量',
                width: 70,
                halign: "left",
                align: 'right'
            },
            {
                field: 'canRetQty',
                title: '可退数量',
                width: 70,
                halign: "left",
                align: 'right'
            },
            {
                field: 'sp',
                title: '售价',
                width: 70,
                halign: "left",
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 70
            },
            {
                field: 'packFlag',
                title: '打包',
                width: 70,
                hidden: true
            },
            {
                field: 'dspSubId',
                title: '打包子表Id',
                width: 70,
                hidden: true
            },
            {
                field: 'phacItmLbId',
                title: '发药孙表Id',
                width: 70,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.Return",
            QueryName: "QueryOrdExe"
        },
        fitColumns: false,
        border: true,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: false,
        border: false,
        onLoadSuccess: function () {},
        onClickRow: function (rowIndex, rowData) {},
        rowStyler: function (index, row) {

        },
        onCheck: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp
            });
        },
        onUncheck: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: false,
                Value: rowData.mDsp
            });
        },
        onSelect: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onUnselect: function (rowIndex, rowData) {
			PIVAS.Grid.ClearSelections(this.id);
        },
        onLoadSuccess: function () {
            $("#txtBarCode").val("");
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}

// 病区合计列表
function InitGridWard() {
    var columns = [
        [{
                field: 'wardId',
                title: 'wardId',
                width: 80,
                hidden: true
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 8
            },
            {
                field: 'wardRetCnt',
                title: '已退组数',
                width: 2,
                align: "right",
                halign: 'left'
            }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.Return",
            QueryName: "CalcuTmpWard"
        },
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onSelect: function (rowIndex, rowData) {},
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

// 已扫药品合计
function InitGridArc() {
    var columns = [
        [{
                field: 'arcItmId',
                title: 'arcItmId',
                width: 80,
                hidden: true
            },
            {
                field: 'arcItmDesc',
                title: '药品名称',
                width: 270
            },
            {
                field: 'qty',
                title: '已退数量',
                width: 100,
                align: "right",
                halign: 'left'
            }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.Return",
            QueryName: "CalcuTmpArcim"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onSelect: function (rowIndex, rowData) {},
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init("gridArc", dataGridOption);
}
//查询
function Query() {
    var params = QueryParams();
    $('#gridPat').datagrid('query', {
        inputStr: params,
        rows: 9999
    });
}

function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var locId = SessionLoc;
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var barCode = $("#txtBarCode").val().trim();
    // 第七个参数为就诊Id
    var params = locId + "^" + wardId + "^" + stDate + "^" + edDate + "^" + patNo + "^" + barCode;
    return params;
}

function ConfirmReturn() {
    var rowsData = $("#gridOrdExe").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('提示', '医嘱明细列表无数据', 'warning');
        return;
    }
    if (GetCheckedDspStr("") == "") {
        return;
    }
    $.messager.confirm('提示', "您确认退药吗?", function (r) {
        if (r) {
            $("#cmbRetReason").combobox("clear");
            $('#retReasonWin').window('open');
            $("#cmbRetReason").combobox('showPanel');
            $("#cmbRetReason").combobox("textbox").focus();
        }
    });
}

function Return() {
    var retReasonId = $("#cmbRetReason").combobox("getValue") || "";
    if (retReasonId == "") {
        $.messager.alert('提示', '请选择退药原因', 'warning');
        return;
    }
    $('#retReasonWin').window('close');
    var chkDspData = GetCheckedDspStr(retReasonId);
    var retData = tkMakeServerCall("web.DHCSTPIVAS.Return", "Return", SessionLoc, SessionUser, chkDspData);
    var retDataArr = retData.split("|$|");
    if (retDataArr[0] == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "退药成功",
            type: 'success'
        });
        $("#gridOrdExe").datagrid("reload")
    } else {
        $.messager.alert('提示', retDataArr[1], 'warning');
        return;
    }

}

function GetCheckedDspStr(retReasonId) {
    var dspArr = [];
    var gridChecked = $('#gridOrdExe').datagrid('getChecked');
    if (gridChecked == "") {
        $.messager.alert("提示", "请先选择需要退药记录", "warning");
        return "";
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var cIData = gridChecked[cI];
        var dspId = cIData.dspId;
        if (dspId == "") {
            continue;
        }
        var canRetQty = cIData.canRetQty;
        var dspSubId = cIData.dspSubId;
        var phacItmLbId = cIData.phacItmLbId;
        dspArr.push(dspId + "^" + canRetQty + "^" + retReasonId + "^" + dspSubId + "^" + phacItmLbId);
    }
    return dspArr.join(",");
}
// 扫描退药前确认
function ConfirmScanReturn() {
    var retReasonId = $("#cmbScanRetReason").combobox("getValue") || "";
    if (retReasonId == "") {
        $.messager.alert("提示", "请先选择退药原因", "warning", function () {
            $("#cmbScanRetReason").combobox('showPanel');
            $("#cmbScanRetReason").combobox("textbox").focus();
        });
        return;
    }
    var barCode = $("#txtScanCode").val();
    var chkRet = tkMakeServerCall("web.DHCSTPIVAS.Return", "CheckScan", barCode);
    var chkArr = chkRet.split("|$|");
    if (chkArr[0] < 0) {
        $.messager.confirm('提示', chkArr[1] + ",您确认退药吗?", function (r) {
            if (r) {
                ScanReturn();
            } else {
                $("#txtScanCode").val("");
                $("#txtScanCode").focus();
            }
        });
    } else {
        ScanReturn();
    }
}

// 扫描退药
function ScanReturn() {
    var retReasonId = $("#cmbScanRetReason").combobox("getValue") || "";
    var barCode = $("#txtScanCode").val();
    var retData = tkMakeServerCall("web.DHCSTPIVAS.Return", "ReturnByBarCode", barCode, SessionUser, SessionLoc, retReasonId, ReturnPid, 1);
    var retDataArr = retData.split("|$|");
    if (retDataArr[0] == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "退药成功",
            type: 'success'
        });
        PIVAS.Media.Play("success");
        // 加载标签数据
        PIVASLABEL.Init({
            labelData: retDataArr[1]
        });
        ReturnPid = retDataArr[2];
        $('#gridWard').datagrid('query', {
            pid: ReturnPid,
            rows: 9999
        });
        $('#gridArc').datagrid('query', {
            pid: ReturnPid,
            rows: 9999
        });

    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: retDataArr[1],
            type: 'error'
        });
        PIVAS.Media.Play("warning");
        $("#labelContent").html("");
    }
    $("#txtScanCode").val("");
}

window.onbeforeunload = function () {
    tkMakeServerCall("web.DHCSTPIVAS.Return", "KillCalcuTmpReturn", ReturnPid);
};