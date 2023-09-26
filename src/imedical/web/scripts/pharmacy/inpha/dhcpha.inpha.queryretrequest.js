/**
 * ģ��:     ��ҩ���뵥��ѯ
 * ��д����: 2018-06-06
 * ��д��:   QianHuanjuan
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
// ���뵥�б�
function InitGridRequest() {
    var columns = [
        [{
                field: 'gridRequestSelect',
                checkbox: true
            },
            {
                field: 'status',
                title: '״̬',
                width: 80,
                formatter: function (value, row, index) {
                    var status = row.reqStatus;
                    var refundStatus = row.refundStatus;
                    var statusDiv = "<div style='background:white;color:black;padding-left:8px;border-bottom:1px dashed #cccccc;'>" + status + "</div>";
                    if (status == "��ҩ���") {
                        statusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    } else if (status == "������ҩ") {
                        statusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    }
                    var refundStatusDiv = "<div style='background:white;color:black;padding-left:8px;'>" + refundStatus + "</div>";
                    if (refundStatus == "�˷����") {
                        refundStatusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;">' + refundStatus + '</div>';
                    } else if (refundStatus == "�����˷�") {
                        refundStatusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;">' + refundStatus + '</div>';
                    }
                    return '<div style="margin:0px -8px;font-weight:bold;">' + statusDiv + refundStatusDiv + "</div>";
                }
            },
            {
                field: 'reqNo',
                title: '���뵥��',
                width: 200
            },
            {
                field: 'reqDate',
                title: '��������',
                width: 100
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 180
            },
            {
                field: 'reqUserName',
                title: '������',
                width: 75
            },
            {
                field: 'patInfo',
                title: '�ǼǺ�(����)',
                width: 160
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'reqTime',
                title: '����ʱ��',
                width: 100
            },
            {
                field: 'reqStatus',
                title: '��ҩ״̬',
                width: 100,
                hidden: true
            },
            {
                field: 'refundStatus',
                title: '�˷�״̬',
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
// ��ȡ����
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
// ��ѯ
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

// ���뵥��ϸ�б�
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
                title: '״̬',
                width: 80,
                formatter: function (value, row, index) {
                    var status = row.reqStatus;
                    var refundStatus = row.refundStatus;
                    var statusDiv = "<div style='background:white;color:black;padding-left:8px;border-bottom:1px dashed #cccccc;'>" + status + "</div>";
                    if (status == "��ҩ���") {
                        statusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    } else if (status == "������ҩ") {
                        statusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                    }
                    var refundStatusDiv = "<div style='background:white;color:black;padding-left:8px;'>" + refundStatus + "</div>";
                    if (refundStatus == "�˷����") {
                        refundStatusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;">' + refundStatus + '</div>';
                    } else if (refundStatus == "�����˷�") {
                        refundStatusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;">' + refundStatus + '</div>';
                    }
                    return '<div style="margin:0px -8px;font-weight:bold;">' + statusDiv + refundStatusDiv + "</div>";
                }
            },
            {
                field: 'bedNo',
                title: '����',
                width: 80
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'incDesc',
                title: 'ҩƷ����',
                width: 180
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 50
            },
            {
                field: 'reqQty',
                title: '��������',
                width: 70,
                halign: 'left',
                align: 'right',
                hidden: false
            },
            {
                field: 'reasonDesc',
                title: '��ҩԭ��',
                width: 140
            },
            {
                field: 'reqStatus',
                title: '��ҩ״̬',
                width: 80,
                hidden: true
            },
            {
                field: 'refundStatus',
                title: '�˷�״̬',
                width: 80,
                hidden: true
            },
            {
                field: 'retedQty',
                title: '��������',
                width: 70,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'surQty',
                title: 'δ������',
                width: 70,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'sp',
                title: '�ۼ�',
                width: 70,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'manfDesc',
                title: '����',
                width: 100,
                align: 'left'
            },
            {
                field: 'reqDate',
                title: '��������',
                width: 100,
                align: 'center'
            },
            {
                field: 'reqTime',
                title: '����ʱ��',
                width: 100
            },
            {
                field: 'prescNo',
                title: '������',
                width: 125
            },
            {
                field: 'reqNo',
                title: '���뵥��',
                width: 120,
                hidden: false
            },
            {
                field: 'encryptLevel',
                title: '�����ܼ�',
                width: 80,
                align: 'left'
            },
            {
                field: 'patLevel',
                title: '���˼���',
                width: 80,
                align: 'left'
            },
            {
                field: 'cyFlag',
                title: '��ҩ������־',
                width: 80,
                hidden: true
            },
            {
                field: 'needGrpRet',
                title: '������',
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
// ��ѯ��ϸ
function QueryDetail() {
    var reqIdStr = GetCheckedReqId();
    if ((reqIdStr == null) || (reqIdStr == "")) {
        //$.messager.alert("��ʾ", "����ѡ���¼", "warning");
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

// ��ȡѡ�м�¼�����뵥Id
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
// ��ȡѡ�м�¼��������ϸ��id
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
        $.messager.alert("��ʾ", "��ѡ����Ҫ��ǰ�˷ѵļ�¼", "warning");
        return;
    }
    $.messager.confirm("ȷ����ʾ", "��ȷ��Ҫ��ǰ�˷���?", function (r) {
        if (r) {
            var saveRet = tkMakeServerCall("web.DHCINPHA.Request", "RefundReqMulti", reqIdStr, SessionUser);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                $.messager.alert("��ʾ", saveInfo, "warning");
                return;
            }
            Query();
        }
    });
}

function DeleteReqItm() {
    var reqItmIdStr = GetCheckedReqItmArr();
    if (reqItmIdStr == "") {
        $.messager.alert("��ʾ", "���ȹ�ѡ��Ҫɾ���ļ�¼", "warning");
        return;
    }
    $.messager.confirm("ɾ����ʾ", "��ȷ��ɾ����ϸ��?", function (r) {
        if (r) {
            var delRet = tkMakeServerCall("web.DHCINPHA.Request", "DeleteItms", reqItmIdStr);
            var delRetArr = delRet.split("^");
            var delVal = delRetArr[0];
            var delInfo = delRetArr[1];
            if (delVal < 0) {
                $.messager.alert("��ʾ", delInfo, "warning");
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
        //$.messager.alert("��ʾ", "����ѡ��ҩ����", "warning");
        //return;
    }
    if (SessionLoc == "") {
        return;
    }
    var confirmText = "ȷ�Ͻ� " + PhaLocDesc + " ���ó�Ĭ�Ͽ�����?";
    if (PhaLoc == "") {
        confirmText = "ȷ��Ĭ�Ͽ�������Ϊ����?";
    }
    $.messager.confirm("ȷ����ʾ", confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall("web.DHCSTRETREQUEST", "SetDefaultPhaLoc", PhaLoc, SessionLoc);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert("��ʾ", "���óɹ�", "info");
                return;
            }
        }
    });
}

/// ��ӡ���뵥
function Print() {
    var reqIdStr = GetCheckedReqId();
    if (reqIdStr == "") {
        $.messager.alert("��ʾ", "�빴ѡ��Ҫ��ӡ����ҩ���뵥", "warning");
        return;
    }
    var hospDesc = tkMakeServerCall("web.DHCSTKUTIL", "GetHospName", session['LOGON.HOSPID']);
    var webFormatDate = $.fn.datebox.defaults.formatter(new Date());
    var RQDTFormat = "yyyy-MM-dd HH:mm:ss";
    if (webFormatDate.indexOf("/") >= 0) {
        RQDTFormat = "dd/MM/yyyy HH:mm:ss";
    }
    var fileName = "DHCST_INPHA_��ҩ���뵥.raq&reqIdStr=" + reqIdStr + "&userName=" + session['LOGON.USERNAME'] + "&hospDesc=" + hospDesc + "&RQDTFormat=" + RQDTFormat;
    DHCCPM_RQPrint(fileName, 800, 600)
}