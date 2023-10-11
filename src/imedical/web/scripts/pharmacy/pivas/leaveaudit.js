/**
 * ģ��:     �Ű����-��ٹ���-�������
 * ��д����: 2018-07-04
 * ��д��:   yunhaibao
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
            placeholder: '��Һ����...',
            editable: false
        }
    );
    PIVAS.ComboBox.Init(
        { Id: 'cmbLeaveType', Type: 'PIVALeaveType' },
        {
            placeholder: '�������...'
        }
    );
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaUser', Type: 'LocUser' },
        {
            placeholder: '�����...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLeaveStatus',
            data: {
                data: [
                    { RowId: 0, Description: 'δ���' },
                    { RowId: 1, Description: '�����' },
                    //{ RowId: 2, Description: "�����" },
                    { RowId: -1, Description: '�Ѿܾ�' }
                ]
            }
        },
        {
            placeholder: '���״̬...'
        }
    );
    $('#cmbLeaveStatus').combobox('setValue', 0);
}

function InitGridLeave() {
    var columns = [
        [
            { field: 'plId', title: 'plId', hidden: true, width: 100 },
            { field: 'plUserId', title: '��ԱId', hidden: true, width: 100 },
            {
                field: 'plEdit',
                title: '����',
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
                title: '״̬',
                width: 60,
                styler: function (value, row, index) {
                    if (value == 'δ���') {
                        return 'background-color:white;color:black;font-weight:bold;';
                    } else if (value == '�����') {
                        return 'background-color:#e2ffde;color:#3c763d;font-weight:bold;';
                    } else if (value == '�����') {
                        return 'background-color:#e3f7ff;color:#1278b8;font-weight:bold;';
                    } else if (value == '�Ѿܾ�') {
                        return 'background-color:#ffe3e3;color:#ff3d2c;font-weight:bold;';
                    }
                    return '';
                }
            },
            { field: 'plUser', title: '������', width: 100 },
            { field: 'plDateTime', title: '����ʱ��', width: 155 },
            { field: 'plLeaveType', title: '�������', width: 75 },
            { field: 'plReason', title: '���ԭ��', width: 200 },
            {
                field: 'plStDate',
                title: '��ʼ����',
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
                title: '��������',
                width: 100,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true
                    }
                }
            },
            { field: 'plAuditUser', title: '�����', width: 100 },
            { field: 'plAuditDateTime', title: '���ʱ��', width: 155 },
            { field: 'plFinishUser', title: '�����', width: 100, hidden: true },
            { field: 'plFinishDateTime', title: '���ʱ��', width: 155, hidden: true }
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
// ��ѯ
function Query() {
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    if (locId == '') {
        $.messager.alert('��ʾ', '��ѡ����Һ����', 'warning');
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
// �޸ĵ�
function MainTain(type) {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if (type == 'U' && gridSelect == null) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ�༭��ټ�¼', 'warning');
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
    $('#gridLeaveWin').window({ title: '�����Ϣ' + (type == 'A' ? '����' : '�༭') });
    $('#gridLeaveWin').window('open');
    $('#gridLeaveWin').window('move', {
        left: event.clientX,
        top: event.clientY
    });
}
/// ����
function Save() {
    var winTitle = $('#gridLeaveWin').panel('options').title;
    var plId = '';
    if (winTitle.indexOf('��') >= 0) {
        plId = '';
    } else {
        var gridSelect = $('#gridLeave').datagrid('getSelected');
        if (gridSelect == null) {
            $.messager.alert('��ʾ', '����ѡ����Ҫ�༭����ټ�¼', 'warning');
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
        $.messager.alert('��ʾ', saveInfo, 'warning');
        return;
    }
    $('#gridLeaveWin').window('close');
    Query();
}

// ����״̬
function PassLeave(type) {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ����Ҫ��������ټ�¼', 'warning');
        return;
    }
    var plId = gridSelect.plId;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Leave', 'UpdateStatus', plId, SessionUser, type);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
        return;
    }
    $('#gridLeave').datagrid('reload');
}

function Delete() {
    var gridSelect = $('#gridLeave').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ����Ҫɾ���ļ�¼!', 'warning');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
        if (r) {
            var plId = gridSelect.plId || '';
            var rowIndex = $('#gridLeave').datagrid('getRowIndex', gridSelect);
            if (plId != '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.Leave', 'Delete', plId);
                var delRetArr = delRet.split('^');
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert('��ʾ', delRetArr[1], 'warning');
                    return;
                }
            }
            Query();
        }
    });
}

