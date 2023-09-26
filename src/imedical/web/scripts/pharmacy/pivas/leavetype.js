/**
 * 模块:     排班管理-请假类型维护
 * 编写日期: 2018-06-26
 * 编写人:   yunhaibao
 */
$(function () {
    InitGridLeaveType(); //初始化列表
    $('#btnAdd').on('click', function () {
        $('#gridLeaveType').datagrid('addNewRow', { editField: 'pltDesc' });
    });
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
});

function InitGridLeaveType() {
    var columns = [
        [
            { field: 'pltId', title: 'pltId', hidden: true, width: 100 },
            {
                field: 'pltDesc',
                title: '请假类型',
                width: 150,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'pltLimitDays',
                title: '请假上限天数',
                width: 150,
                halign: 'left',
                align: 'right',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                        validType: 'PosNumber'
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.LeaveType',
            QueryName: 'PIVALeaveType'
        },
        columns: columns,
        toolbar: '#gridLeaveTypeBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'pltDesc'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridLeaveType', dataGridOption);
}

// 查询
function Query() {
    $('#gridLeaveType').datagrid('query');
}

function Save() {
    $('#gridLeaveType').datagrid('endEditing');
    var gridChanges = $('#gridLeaveType').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridLeaveType').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var params = (iData.pltId || '') + '^' + (iData.pltDesc || '') + '^' + (iData.pltLimitDays || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.LeaveType', 'SaveMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridLeaveType').datagrid('query');
}

function Delete() {
    var gridSelect = $('#gridLeaveType').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function (r) {
        if (r) {
            var pltId = gridSelect.pltId || '';
            var rowIndex = $('#gridLeaveType').datagrid('getRowIndex', gridSelect);
            if (pltId != '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.LeaveType', 'Delete', pltId);
                var delRetArr = delRet.split('^');
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert('提示', delRetArr[1], 'warning');
                    return;
                }
            }
            $('#gridLeaveType').datagrid('deleteRow', rowIndex);
        }
    });
}
