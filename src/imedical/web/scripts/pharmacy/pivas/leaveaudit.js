/**
 * 模块:     排班管理-请假管理-请假审批
 * 编写日期: 2018-07-04
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var Loaded = '';
$(function () {
    InitDict();
    InitGridLeave();
    $('#btnFind').on('click', Query);
    $('#btnPass').on('click', function () {
        PassLeave(1);
    });
    $('#btnRefuse').on('click', function () {
        PassLeave(-1);
    });
    setTimeout(Query, 500);
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            onLoadSuccess: function () {
                if (Loaded == '') {
                    var datas = $('#cmbPivaLoc').combobox('getData');
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i].RowId == SessionLoc) {
                            $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                            Loaded = 1;
                        }
                    }
                }
            },
            placeholder: '配液中心...',
            editable: false
        }
    );
    PIVAS.ComboBox.Init(
        { Id: 'cmbLeaveType', Type: 'PIVALeaveType' },
        {
            placeholder: '请假类型...'
        }
    );
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaUser', Type: 'LocUser' },
        {
            placeholder: '请假人...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLeaveStatus',
            data: {
                data: [
                    { RowId: 0, Description: '未审核' },
                    { RowId: 1, Description: '已审核' },
                    //{ RowId: 2, Description: "已完成" },
                    { RowId: -1, Description: '已拒绝' }
                ]
            }
        },
        {
            placeholder: '请假状态...'
        }
    );
    $('#cmbLeaveStatus').combobox('setValue', 0);
}

function InitGridLeave() {
    var columns = [
        [
            { field: 'plId', title: 'plId', hidden: true, width: 100 },
            { field: 'plUserId', title: '人员Id', hidden: true, width: 100 },
            {
                field: 'plEdit',
                title: '操作',
                width: 80,
                hidden: true,
                formatter: function (value, row, index) {
                    return '<a name="gridSave"><a><a name="gridEdit" onclick="EditGridRow(' + index + ')"><a>';
                },
                styler: function (value, row, index) {
                    return 'background-color:white';
                }
            },
            {
                field: 'plStatus',
                title: '状态',
                width: 60,
                styler: function (value, row, index) {
                    if (value == '未审核') {
                        return 'background-color:white;color:black;font-weight:bold;';
                    } else if (value == '已审核') {
                        return 'background-color:#e2ffde;color:#3c763d;font-weight:bold;';
                    } else if (value == '已完成') {
                        return 'background-color:#e3f7ff;color:#1278b8;font-weight:bold;';
                    } else if (value == '已拒绝') {
                        return 'background-color:#ffe3e3;color:#ff3d2c;font-weight:bold;';
                    }
                    return '';
                }
            },
            { field: 'plUser', title: '申请人', width: 100 },
            { field: 'plDateTime', title: '申请时间', width: 155 },
            { field: 'plLeaveType', title: '请假类型', width: 75 },
            { field: 'plReason', title: '请假原因', width: 200 },
            {
                field: 'plStDate',
                title: '开始日期',
                width: 100,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'plEdDate',
                title: '结束日期',
                width: 100,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true
                    }
                }
            },
            { field: 'plAuditUser', title: '审核人', width: 100 },
            { field: 'plAuditDateTime', title: '审核时间', width: 155 },
            { field: 'plFinishUser', title: '完成人', width: 100, hidden: true },
            { field: 'plFinishDateTime', title: '完成时间', width: 155, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: null,
        columns: columns,
        toolbar: '#gridLeaveBar',
        border: false,
        nowrap: false,
        fitColumns:true,
        onLoadSuccess: function (data) {
            $("a[name='gridEdit']").linkbutton({ plain: true, iconCls: 'icon-edit' });
            $("a[name='gridSave']").linkbutton({ plain: true, iconCls: 'icon-save' });
        },
        onSelectRow: function (rowIndex, rowData) {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridLeave', dataGridOption);
}

function EditGridRow(rowIndex) {
    $('#gridLeave').datagrid('selectRow', rowIndex);
    $('#gridLeave').datagrid('beginEditRow', {
        rowIndex: rowIndex,
        editField: 'plStDate'
    });
}
// 查询
function Query() {
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    if (locId == '') {
        $.messager.alert('提示', '请选择配液中心', 'warning');
        return;
    }
    var userId = $('#cmbPivaUser').combobox('getValue') || '';
    var leaveStatus = $('#cmbLeaveStatus').combobox('getValue') || '';
    var leaveTypeId = $('#cmbLeaveType').combobox('getValue') || '';
    var inputStr = locId + '^' + userId + '^' + leaveStatus + '^' + leaveTypeId;
    $('#gridLeave').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Leave',
            QueryName: 'PIVALeave',
            inputStr: inputStr
        }
    });
}
// 修改等
function MainTain(type) {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if (type == 'U' && gridSelect == null) {
        $.messager.alert('提示', '请先选择需要编辑请假记录', 'warning');
        return;
    }
    if (type == 'A') {
        $('#cmbLeaveType').combobox('clear');
        $('#dateStart').datebox('setValue', '');
        $('#dateEnd').datebox('setValue', '');
        $('#txtReason').val('');
    } else {
        $('#cmbLeaveType').combobox('setValue', gridSelect.plLeaveTypeId);
        $('#dateStart').datebox('setValue', gridSelect.plStDate);
        $('#dateEnd').datebox('setValue', gridSelect.plEdDate);
        $('#txtReason').val(gridSelect.plReason);
    }
    $('#gridLeaveWin').window({ title: '请假信息' + (type == 'A' ? '新增' : '编辑') });
    $('#gridLeaveWin').window('open');
    $('#gridLeaveWin').window('move', {
        left: event.clientX,
        top: event.clientY
    });
}
/// 保存
function Save() {
    var winTitle = $('#gridLeaveWin').panel('options').title;
    var plId = '';
    if (winTitle.indexOf('增') >= 0) {
        plId = '';
    } else {
        var gridSelect = $('#gridLeave').datagrid('getSelected');
        if (gridSelect == null) {
            $.messager.alert('提示', '请先选择需要编辑的请假记录', 'warning');
            return;
        }
        plId = gridSelect.plId;
    }
    var plLeaveTypeId = $('#cmbLeaveType').combobox('getValue') || '';
    var plStDate = $('#dateStart').datebox('getValue') || '';
    var plEdDate = $('#dateEnd').datebox('getValue') || '';
    var plReason = $('#txtReason').val();
    var inputStr = plId + '^' + SessionLoc + '^' + SessionUser + '^' + plLeaveTypeId + '^' + plStDate + '^' + plEdDate + '^' + plReason;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Leave', 'Save', inputStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
        return;
    }
    $('#gridLeaveWin').window('close');
    Query();
}

// 更新状态
function PassLeave(type) {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请选择需要操作的请假记录', 'warning');
        return;
    }
    var plId = gridSelect.plId;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Leave', 'UpdateStatus', plId, SessionUser, type);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
        return;
    }
    $('#gridLeave').datagrid('reload');
}

function Delete() {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请选择需要删除的记录!', 'warning');
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function (r) {
        if (r) {
            var plId = gridSelect.plId || '';
            var rowIndex = $('#gridLeave').datagrid('getRowIndex', gridSelect);
            if (plId != '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.Leave', 'Delete', plId);
                var delRetArr = delRet.split('^');
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert('提示', delRetArr[1], 'warning');
                    return;
                }
            }
            Query();
        }
    });
}

