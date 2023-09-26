/**
 * ģ��:     �Ű����-��ٹ���-�������
 * ��д����: 2018-07-04
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridLeave();
    $('#btnAdd').on("click", function() {
        MainTain("A");
    });
    $('#btnEdit').on("click", function() {
        MainTain("U");
    });
    $('#btnDelete').on("click", Delete);
    setTimeout(Query, 100);
});

function InitDict() {
    PIVAS.ComboBox.Init({ Id: 'cmbLeaveType', Type: 'PIVALeaveType' }, {
        editable: false,
        width: 330
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbLeaveStatus',
        data: {
            data: [
                { RowId: 0, Description: "δ���" },
                { RowId: 1, Description: "�����" },
                //{ RowId: 2, Description: "�����" },
                { RowId: -1, Description: "�Ѿܾ�" }
            ]
        }
    }, {
        placeholder: '���״̬...',
        editable: false,
        onSelect: function(data) {
            Query();
        }
    });
    $("#cmbLeaveStatus").combobox('setValue', 0);
}

function InitGridLeave() {
    var columns = [
        [
            { field: "plId", title: 'plId', hidden: true, width: 100 },
            { field: "plUserId", title: '��ԱId', hidden: true, width: 100 },
            {
                field: "plStatus",
                title: '״̬',
                width: 60,
                styler: function(value, row, index) {
                    if (value == "δ���") {
                        return "background-color:white;color:black;font-weight:bold;"
                    } else if (value == "�����") {
                        return "background-color:#e2ffde;color:#3c763d;font-weight:bold;"
                    } else if (value == "�����") {
                        return "background-color:#e3f7ff;color:#1278b8;font-weight:bold;"
                    } else if (value == "�Ѿܾ�") {
                        return "background-color:#ffe3e3;color:#ff3d2c;font-weight:bold;"
                    }
                    return "";
                }
            },
            { field: "plUser", title: '������', width: 100 },
            { field: "plDateTime", title: '����ʱ��', width: 155 },
            { field: "plLeaveType", title: '�������', width: 75 },
            { field: "plReason", title: '���ԭ��', width: 200 },
            { field: "plStDate", title: '��ʼ����', width: 100 },
            { field: "plEdDate", title: '��������', width: 100 },
            { field: "plAuditUser", title: '�����', width: 100 },
            { field: "plAuditDateTime", title: '���ʱ��', width: 155 },
            { field: "plFinishUser", title: '�����', width: 100 , hidden: true },
            { field: "plFinishDateTime", title: '���ʱ��', width: 155 , hidden: true }
        ]
    ];
    var dataGridOption = {
        url: null,
        columns: columns,
        toolbar: "#gridLeaveBar",
        border: false,
        nowrap: false
    };
    DHCPHA_HUI_COM.Grid.Init("gridLeave", dataGridOption);
}

// ��ѯ
function Query() {
    var leaveStatus = $("#cmbLeaveStatus").combobox("getValue") || "";
    var inputStr = SessionLoc + "^" + SessionUser + "^" + leaveStatus;
    $("#gridLeave").datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Leave',
            QueryName: 'PIVALeave',
            inputStr: inputStr
        },
    });
}
// �޸ĵ�
function MainTain(type) {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if ((type == "U") && (gridSelect == null)) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ�༭��ټ�¼", "warning");
        return;
    }
    if (type == "A") {
        $("#cmbLeaveType").combobox("clear");
        $("#dateStart").datebox("setValue", "");
        $("#dateEnd").datebox("setValue", "");
        $("#txtReason").val("");
    } else {
        if ((gridSelect.plStatus == "�����") || (gridSelect.plStatus == "�����")) {
            $.messager.alert("��ʾ", "��ѡ�����ټ�¼" + gridSelect.plStatus, "warning");
            return;
        }
        $("#cmbLeaveType").combobox("setValue", gridSelect.plLeaveTypeId);
        $("#dateStart").datebox("setValue", gridSelect.plStDate);
        $("#dateEnd").datebox("setValue", gridSelect.plEdDate);
        $("#txtReason").val(gridSelect.plReason);
    }
    $('#gridLeaveWin').window({ 'title': "�����Ϣ" + ((type == "A") ? "����" : "�༭") })
    $('#gridLeaveWin').window('open');
    /*
    $('#gridLeaveWin').window('move', {
        left: event.clientX,
        top: event.clientY,
    });
    */
}
/// ����
function Save() {
    var winTitle = $("#gridLeaveWin").panel('options').title;
    var plId = "";
    if (winTitle.indexOf("��") >= 0) {
        plId = "";
    } else {
        var gridSelect = $('#gridLeave').datagrid("getSelected");
        if (gridSelect == null) {
            $.messager.alert("��ʾ", "����ѡ����Ҫ�༭����ټ�¼", "warning");
            return;
        }
        plId = gridSelect.plId;
    }
    var plLeaveTypeId = $("#cmbLeaveType").combobox("getValue") || "";
    var plStDate = $("#dateStart").datebox("getValue") || "";
    var plEdDate = $("#dateEnd").datebox("getValue") || "";
    var plReason = $("#txtReason").val();
    var inputStr = plId + "^" + SessionLoc + "^" + SessionUser + "^" + plLeaveTypeId + "^" + plStDate + "^" +
        plEdDate + "^" + plReason;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Leave", "Save", inputStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
        return;
    }
    $('#gridLeaveWin').window('close');
    Query();
}

function Delete() {
    var gridSelect = $('#gridLeave').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var plId = gridSelect.plId || "";
            var rowIndex = $('#gridLeave').datagrid('getRowIndex', gridSelect);
            if (plId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.Leave", "Delete", plId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("��ʾ", delRetArr[1], "warning");
                    return;
                }
            }
            Query();
        }
    })
}