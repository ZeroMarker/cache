/**
 * 模块:     退药申请单查询
 * 编写日期: 2018-06-06
 * 编写人:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || "";
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", SessionLoc);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var Loaded = 0;
$(function () {
    InitDict();
    InitGridRequest();
    InitGridRequestDetail();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
                $(this).val(newPatNo);
                var patInfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatInfoByNo", newPatNo);
                $("#txtPatName").val(patInfo.split("^")[0] || "");
                Query();
            } else {
                $("#txtPatName").val("");
            }
        }
    });
    $("#btnFind").on("click", Query);
    $("#btnPrint").on("click", Print);
    $("#btnRefund").on("click", Refund);
    $("#btnDefaultLoc").on("click", SetDefaultLoc);
    $("#btnDelReqItm").on("click", DeleteReqItm);
    if (LoadAdmId != "") {
        var patInfo = tkMakeServerCall("web.DHCINPHA.Request", "PatInfo", LoadAdmId);
        $("#txtPatNo").val(patInfo.split("^")[0] || "");
        $("#txtPatName").val(patInfo.split("^")[1] || "");
    }
    window.resizeTo(screen.availWidth - 6, (screen.availHeight - 100));
    window.moveTo(3, 90);
});

function InitDict() {
    DHCPHA_HUI_COM.ComboBox.Init({
        Id: 'cmbWard',
        Type: 'Ward'
    }, {
        onLoadSuccess: function () {
            if (Loaded < 2) {
                var datas = $("#cmbWard").combobox("getData");
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionWard) {
                        $("#cmbWard").combobox("select", datas[i].RowId);
                    }
                }
                Loaded++;
            }
        },
        width: 273
    });
    DHCPHA_HUI_COM.ComboBox.Init({
        Id: 'cmbPhaLoc',
        Type: 'PhaLoc'
    }, {
        defaultFilter: 4,
        mode: "local",
        onLoadSuccess: function () {
            if (Loaded < 2) {
                $("#cmbPhaLoc").combobox("setValue", DefPhaLocId);
                Loaded++;
            }
        }
    });
    $("#dateStart").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#dateEnd").datebox("setValue", DHCPHA_TOOLS.Today());
}
// 申请单列表
function InitGridRequest() {
    var columns = [
        [{
                field: 'gridRequestSelect',
                checkbox: true
            },
            {
                field: 'status',
                title: '状态',
                width: 80,
                formatter: function (value, row, index) {
                    var status = row.reqStatus;
                    var refundStatus = row.refundStatus;
                    var statusDiv = "<div style='background:white;color:black;padding-left:8px;border-bottom:1px dashed #cccccc;'>" + status + "</div>";
                    if (status == "退药完成") {
                        statusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    } else if (status == "部分退药") {
                        statusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    }
                    var refundStatusDiv = "<div style='background:white;color:black;padding-left:8px;'>" + refundStatus + "</div>";
                    if (refundStatus == "退费完成") {
                        refundStatusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;">' + refundStatus + '</div>';
                    } else if (refundStatus == "部分退费") {
                        refundStatusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;">' + refundStatus + '</div>';
                    }
                    return '<div style="margin:0px -8px;font-weight:bold;">' + statusDiv + refundStatusDiv + "</div>";
                }
            },
            {
                field: 'reqNo',
                title: '申请单号',
                width: 200
            },
            {
                field: 'reqDate',
                title: '申请日期',
                width: 100
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 180
            },
            {
                field: 'reqUserName',
                title: '申请人',
                width: 75
            },
            {
                field: 'patInfo',
                title: '登记号(床号)',
                width: 160
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'reqTime',
                title: '申请时间',
                width: 100
            },
            {
                field: 'reqStatus',
                title: '退药状态',
                width: 100,
                hidden: true
            },
            {
                field: 'refundStatus',
                title: '退费状态',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: "#gridRequestBar",
        onUncheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onCheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onUncheckAll: function () {
            QueryDetail();
        },
        onCheckAll: function () {
            QueryDetail();
        },
        onLoadSuccess: function () {
            $('#gridRequestDetail').datagrid('clear');
            $('#gridRequest').datagrid('uncheckAll');
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridRequest", dataGridOption);
}
// 获取参数
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var wardId = $('#cmbWard').combobox("getValue");
    var phaLocId = $('#cmbPhaLoc').combobox("getValue");
    var patNo = $('#txtPatNo').val().trim();
    var reqStatus = "A"
    var advRefundFlag = ""
    var incId = ""
    var docFlag = ""
    if (($('#advrefundflag').is(':checked')) == true) {
        advRefundFlag = "Y";
    }

    return stDate + "^" + edDate + "^" + wardId + "^" + phaLocId + "^" + reqStatus + "^" + patNo + "^" + docFlag + "^" + incId + "^" + advRefundFlag + "^" + HospId;
}
// 查询
function Query() {
    var params = QueryParams();
    $('#gridRequest').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCINPHA.QueryRetReq",
            QueryName: "QueryRequest",
            inputStr: params
        }
    });
}

// 申请单明细列表
function InitGridRequestDetail() {
    var columns = [
        [{
                field: 'gridRequestDetailSelect',
                checkbox: true
            },
            {
                field: 'reqItmRowId',
                title: 'reqItmRowId',
                width: 80,
                halign: 'center',
                hidden: true
            },
            {
                field: 'status',
                title: '状态',
                width: 80,
                formatter: function (value, row, index) {
                    var status = row.reqStatus;
                    var refundStatus = row.refundStatus;
                    var statusDiv = "<div style='background:white;color:black;padding-left:8px;border-bottom:1px dashed #cccccc;'>" + status + "</div>";
                    if (status == "退药完成") {
                        statusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    } else if (status == "部分退药") {
                        statusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    }
                    var refundStatusDiv = "<div style='background:white;color:black;padding-left:8px;'>" + refundStatus + "</div>";
                    if (refundStatus == "退费完成") {
                        refundStatusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;">' + refundStatus + '</div>';
                    } else if (refundStatus == "部分退费") {
                        refundStatusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;">' + refundStatus + '</div>';
                    }
                    return '<div style="margin:0px -8px;font-weight:bold;">' + statusDiv + refundStatusDiv + "</div>";
                }
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 80
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 180
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 50
            },
            {
                field: 'reqQty',
                title: '申请数量',
                width: 70,
                halign: 'left',
                align: 'right',
                hidden: false
            },
            {
                field: 'reasonDesc',
                title: '退药原因',
                width: 140
            },
            {
                field: 'reqStatus',
                title: '退药状态',
                width: 80,
                hidden: true
            },
            {
                field: 'refundStatus',
                title: '退费状态',
                width: 80,
                hidden: true
            },
            {
                field: 'retedQty',
                title: '已退数量',
                width: 70,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'surQty',
                title: '未退数量',
                width: 70,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'sp',
                title: '售价',
                width: 70,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'manfDesc',
                title: '厂家',
                width: 100,
                align: 'left'
            },
            {
                field: 'reqDate',
                title: '申请日期',
                width: 100,
                align: 'center'
            },
            {
                field: 'reqTime',
                title: '申请时间',
                width: 100
            },
            {
                field: 'prescNo',
                title: '处方号',
                width: 125
            },
            {
                field: 'reqNo',
                title: '申请单号',
                width: 120,
                hidden: false
            },
            {
                field: 'encryptLevel',
                title: '病人密级',
                width: 80,
                align: 'left'
            },
            {
                field: 'patLevel',
                title: '病人级别',
                width: 80,
                align: 'left'
            },
            {
                field: 'cyFlag',
                title: '草药处方标志',
                width: 80,
                hidden: true
            },
            {
                field: 'needGrpRet',
                title: '成组退',
                width: 180,
                hidden: true
            },
            {
                field: 'mDspId',
                title: 'mDspId',
                width: 180,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 999,
        pageList: [999],
        pagination: false,
        toolbar: "#gridRequestDetailBar",
        onSelect: function (rowIndex, rowData) {

        },
        onUnselect: function (rowIndex, rowData) {

        },
        onLoadSuccess: function () {
            $('#gridRequestDetail').datagrid('uncheckAll');
        },
        onCheck: function (rowIndex, rowData) {
            if (rowData.needGrpRet != "Y") {
                return;
            }
            var cyFlag = rowData.cyFlag;
            if (cyFlag == "Y") {
                DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                    CurRowIndex: rowIndex,
                    GridId: 'gridRequestDetail',
                    Field: 'prescNo',
                    Check: true,
                    Value: rowData.prescNo
                });
            } else {
                DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                    CurRowIndex: rowIndex,
                    GridId: 'gridRequestDetail',
                    Field: 'mDspId',
                    Check: true,
                    Value: rowData.mDspId
                });
            }
        },
        onUncheck: function (rowIndex, rowData) {
            if (rowData.needGrpRet != "Y") {
                return;
            }
            var cyFlag = rowData.cyFlag;
            if (cyFlag == "Y") {
                DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                    CurRowIndex: rowIndex,
                    GridId: 'gridRequestDetail',
                    Field: 'prescNo',
                    Check: false,
                    Value: rowData.prescNo
                });
            } else {
                DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                    CurRowIndex: rowIndex,
                    GridId: 'gridRequestDetail',
                    Field: 'mDspId',
                    Check: false,
                    Value: rowData.mDspId
                });
            }
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridRequestDetail", dataGridOption);
}
// 查询明细
function QueryDetail() {
    var reqIdStr = GetCheckedReqId();
    if ((reqIdStr == null) || (reqIdStr == "")) {
        //$.messager.alert("提示", "请先选择记录", "warning");
        //return;
    }
    $('#gridRequestDetail').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "web.DHCINPHA.QueryRetReq",
            QueryName: "QueryReqItm",
            reqIdStr: reqIdStr,
            inputStr: ""
        }
    });
}

// 获取选中记录的申请单Id
function GetCheckedReqId() {
    var reqIdArr = [];
    var gridRequestChecked = $('#gridRequest').datagrid('getChecked');
    for (var i = 0; i < gridRequestChecked.length; i++) {
        var checkedData = gridRequestChecked[i];
        var reqId = checkedData.reqId;
        if (reqIdArr.indexOf(reqId) < 0) {
            reqIdArr.push(reqId);
        }
    }
    return reqIdArr.join(",");
}
// 获取选中记录的申请明细的id
function GetCheckedReqItmArr() {
    var reqItmArr = [];
    var gridReqDetailChecked = $('#gridRequestDetail').datagrid('getChecked');
    for (var i = 0; i < gridReqDetailChecked.length; i++) {
        var checkedData = gridReqDetailChecked[i];
        var reqItmRowId = checkedData.reqItmRowId;
        if (reqItmArr.indexOf(reqItmRowId) < 0) {
            reqItmArr.push(reqItmRowId);
        }
    }
    return reqItmArr.join("^");
}

function Refund() {
    var reqIdStr = GetCheckedReqId();
    if (reqIdStr == "") {
        $.messager.alert("提示", "请选择需要提前退费的记录", "warning");
        return;
    }
    $.messager.confirm("确认提示", "您确定要提前退费吗?", function (r) {
        if (r) {
            var saveRet = tkMakeServerCall("web.DHCINPHA.Request", "RefundReqMulti", reqIdStr, SessionUser);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                $.messager.alert("提示", saveInfo, "warning");
                return;
            }
            Query();
        }
    });
}

function DeleteReqItm() {
    var reqItmIdStr = GetCheckedReqItmArr();
    if (reqItmIdStr == "") {
        $.messager.alert("提示", "请先勾选需要删除的记录", "warning");
        return;
    }
    $.messager.confirm("删除提示", "您确认删除明细吗?", function (r) {
        if (r) {
            var delRet = tkMakeServerCall("web.DHCINPHA.Request", "DeleteItms", reqItmIdStr);
            var delRetArr = delRet.split("^");
            var delVal = delRetArr[0];
            var delInfo = delRetArr[1];
            if (delVal < 0) {
                $.messager.alert("提示", delInfo, "warning");
                //return;
            }
            QueryDetail();
        }
    });


}

function SetDefaultLoc() {
    var PhaLoc = $('#cmbPhaLoc').combobox("getValue") || "";
    var PhaLocDesc = $('#cmbPhaLoc').combobox("getText") || "";
    if (PhaLoc == "") {
        //$.messager.alert("提示", "请先选择发药科室", "warning");
        //return;
    }
    if (SessionLoc == "") {
        return;
    }
    var confirmText = "确认将 " + PhaLocDesc + " 设置成默认科室吗?";
    if (PhaLoc == "") {
        confirmText = "确认默认科室设置为空吗?";
    }
    $.messager.confirm("确认提示", confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall("web.DHCSTRETREQUEST", "SetDefaultPhaLoc", PhaLoc, SessionLoc);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert("提示", "设置成功", "info");
                return;
            }
        }
    });
}

/// 打印申请单
function Print() {
    var reqIdStr = GetCheckedReqId();
    if (reqIdStr == "") {
        $.messager.alert("提示", "请勾选需要打印的退药申请单", "warning");
        return;
    }
    var hospDesc = tkMakeServerCall("web.DHCSTKUTIL", "GetHospName", session['LOGON.HOSPID']);
    var webFormatDate = $.fn.datebox.defaults.formatter(new Date());
    var RQDTFormat = "yyyy-MM-dd HH:mm:ss";
    if (webFormatDate.indexOf("/") >= 0) {
        RQDTFormat = "dd/MM/yyyy HH:mm:ss";
    }
    var fileName = "DHCST_INPHA_退药申请单.raq&reqIdStr=" + reqIdStr + "&userName=" + session['LOGON.USERNAME'] + "&hospDesc=" + hospDesc + "&RQDTFormat=" + RQDTFormat;
    DHCCPM_RQPrint(fileName, 800, 600)
}