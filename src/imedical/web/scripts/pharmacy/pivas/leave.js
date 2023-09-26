/**
 * 模块:     排班管理-请假管理-申请请假
 * 编写日期: 2018-07-04
 * 编写人:   yunhaibao
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
                { RowId: 0, Description: "未审核" },
                { RowId: 1, Description: "已审核" },
                //{ RowId: 2, Description: "已完成" },
                { RowId: -1, Description: "已拒绝" }
            ]
        }
    }, {
        placeholder: '请假状态...',
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
            { field: "plUserId", title: '人员Id', hidden: true, width: 100 },
            {
                field: "plStatus",
                title: '状态',
                width: 60,
                styler: function(value, row, index) {
                    if (value == "未审核") {
                        return "background-color:white;color:black;font-weight:bold;"
                    } else if (value == "已审核") {
                        return "background-color:#e2ffde;color:#3c763d;font-weight:bold;"
                    } else if (value == "已完成") {
                        return "background-color:#e3f7ff;color:#1278b8;font-weight:bold;"
                    } else if (value == "已拒绝") {
                        return "background-color:#ffe3e3;color:#ff3d2c;font-weight:bold;"
                    }
                    return "";
                }
            },
            { field: "plUser", title: '申请人', width: 100 },
            { field: "plDateTime", title: '申请时间', width: 155 },
            { field: "plLeaveType", title: '请假类型', width: 75 },
            { field: "plReason", title: '请假原因', width: 200 },
            { field: "plStDate", title: '开始日期', width: 100 },
            { field: "plEdDate", title: '结束日期', width: 100 },
            { field: "plAuditUser", title: '审核人', width: 100 },
            { field: "plAuditDateTime", title: '审核时间', width: 155 },
            { field: "plFinishUser", title: '完成人', width: 100 , hidden: true },
            { field: "plFinishDateTime", title: '完成时间', width: 155 , hidden: true }
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

// 查询
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
// 修改等
function MainTain(type) {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if ((type == "U") && (gridSelect == null)) {
        $.messager.alert("提示", "请先选择需要编辑请假记录", "warning");
        return;
    }
    if (type == "A") {
        $("#cmbLeaveType").combobox("clear");
        $("#dateStart").datebox("setValue", "");
        $("#dateEnd").datebox("setValue", "");
        $("#txtReason").val("");
    } else {
        if ((gridSelect.plStatus == "已审核") || (gridSelect.plStatus == "已完成")) {
            $.messager.alert("提示", "您选择的请假记录" + gridSelect.plStatus, "warning");
            return;
        }
        $("#cmbLeaveType").combobox("setValue", gridSelect.plLeaveTypeId);
        $("#dateStart").datebox("setValue", gridSelect.plStDate);
        $("#dateEnd").datebox("setValue", gridSelect.plEdDate);
        $("#txtReason").val(gridSelect.plReason);
    }
    $('#gridLeaveWin').window({ 'title': "请假信息" + ((type == "A") ? "新增" : "编辑") })
    $('#gridLeaveWin').window('open');
    /*
    $('#gridLeaveWin').window('move', {
        left: event.clientX,
        top: event.clientY,
    });
    */
}
/// 保存
function Save() {
    var winTitle = $("#gridLeaveWin").panel('options').title;
    var plId = "";
    if (winTitle.indexOf("增") >= 0) {
        plId = "";
    } else {
        var gridSelect = $('#gridLeave').datagrid("getSelected");
        if (gridSelect == null) {
            $.messager.alert("提示", "请先选择需要编辑的请假记录", "warning");
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
        $.messager.alert("提示", saveInfo, "warning");
        return;
    }
    $('#gridLeaveWin').window('close');
    Query();
}

function Delete() {
    var gridSelect = $('#gridLeave').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var plId = gridSelect.plId || "";
            var rowIndex = $('#gridLeave').datagrid('getRowIndex', gridSelect);
            if (plId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.Leave", "Delete", plId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("提示", delRetArr[1], "warning");
                    return;
                }
            }
            Query();
        }
    })
}