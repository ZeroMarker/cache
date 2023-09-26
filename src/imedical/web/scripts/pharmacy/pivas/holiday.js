/**
 * ģ��:     �Ű����-�����ά��
 * ��д����: 2018-06-26
 * ��д��:   yunhaibao
 */
var GridCmbYear;
var GridCmbHoliday;
$(function () {
    InitGridDict();
    InitGridHoliday(); //��ʼ���б�
    $('#btnAdd').on('click', function () {
        $('#gridHoliday').datagrid('addNewRow', { editField: 'holidayDesc' });
    });
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
});

function InitGridDict() {
    var thisYear = new Date().getFullYear();
    GridCmbYear = PIVAS.GridComboBox.Init(
        {
            data: {
                data: [
                    { year: thisYear, year: thisYear },
                    { year: thisYear - 1, year: thisYear - 1 },
                    { year: thisYear + 1, year: thisYear + 1 },
                    { year: thisYear + 2, year: thisYear + 2 }
                ]
            }
        },
        {
            editable: false,
            required: true,
            mode: 'local',
            valueField: 'year',
            textField: 'year'
        }
    );
    GridCmbHoliday = PIVAS.GridComboBox.Init(
        {
            data: {
                data: [
                    { holidayDesc: '����', holidayDesc: '����' },
                    { holidayDesc: '���', holidayDesc: '���' },
                    { holidayDesc: 'Ԫ��', holidayDesc: 'Ԫ��' },
                    { holidayDesc: '����', holidayDesc: '����' },
                    { holidayDesc: '������', holidayDesc: '������' },
                    { holidayDesc: '�Ͷ���', holidayDesc: '�Ͷ���' },
                    { holidayDesc: '�����', holidayDesc: '�����' },
                    { holidayDesc: '�����', holidayDesc: '�����' },
                    { holidayDesc: '�����', holidayDesc: '�����' }
                ]
            }
        },
        {
            editable: false,
            required: true,
            mode: 'local',
            valueField: 'holidayDesc',
            textField: 'holidayDesc'
        }
    );
}

function InitGridHoliday() {
    var columns = [
        [
            { field: 'phId', title: 'phId', hidden: true, width: 100 },
            {
                field: 'phYear',
                title: '���',
                width: 150,
                editor: GridCmbYear
            },
            {
                field: 'holidayDesc',
                title: '��������',
                width: 150,
                align: 'left',
                editor: GridCmbHoliday
            },
            {
                field: 'startDate',
                title: '��ʼ����',
                width: 150,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true,
                        validType: "validDate['yyyy-MM-dd']"
                    }
                }
            },
            {
                field: 'endDate',
                title: '��������',
                width: 150,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true,
                        validType: "validDate['yyyy-MM-dd']"
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Holiday',
            QueryName: 'PIVAHoliday'
        },
        columns: columns,
        toolbar: '#gridHolidayBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'holidayDesc'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridHoliday', dataGridOption);
}

// ��ѯ
function Query() {
    $('#gridHoliday').datagrid('query');
}

function Save() {
    $('#gridHoliday').datagrid('endEditing');
    var gridChanges = $('#gridHoliday').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert('��ʾ', 'û����Ҫ���������', 'warning');
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridHoliday').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var params = (iData.phId || '') + '^' + (iData.holidayDesc || '') + '^' + (iData.phYear || '') + '^' + (iData.startDate || '') + '^' + (iData.endDate || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Holiday', 'SaveMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridHoliday').datagrid('query');
}

function Delete() {
    var gridSelect = $('#gridHoliday').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ����Ҫɾ���ļ�¼!', 'warning');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
        if (r) {
            var phId = gridSelect.phId || '';
            var rowIndex = $('#gridHoliday').datagrid('getRowIndex', gridSelect);
            if (phId != '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.Holiday', 'Delete', phId);
                var delRetArr = delRet.split('^');
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert('��ʾ', delRetArr[1], 'warning');
                    return;
                }
            }
            $('#gridHoliday').datagrid('deleteRow', rowIndex);
        }
    });
}
