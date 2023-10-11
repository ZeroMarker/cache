/**
 * ģ��:     ��Һ�ܾ�ԭ��ά��
 * ��д����: 2017-12-30
 * ��д��:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
var GridCmbReasonType;
$(function () {
    InitDict();
    InitGridOperReason();
    $('#btnAdd').on('click', function () {
        $('#gridOperReason').datagrid('addNewRow', { editField: 'reasonCode', defaultRow: { reasonUse: 'Y' } });
    });
    $('#btnSave').on('click', SaveOperReason);
    $('#btnDelete').bind('click', DeleteHandler);
    InitHospCombo();
    PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridOperReason', idField: 'reasonId', sqlTableName: 'PIVA_OperReason' });
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    //PIVAS.ComboBox.Init({ Id: "cmbReasonType", Type: "ReasonType" }, { editable: false })
}

function InitGridOperReason() {
    var columns = [
        [
            { field: 'reasonId', title: 'reasonId', hidden: true },
            {
                field: 'reasonCode',
                title: 'ԭ�����',
                width: 150,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'reasonDesc',
                title: 'ԭ������',
                width: 600,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            { field: 'reasonType', title: 'reasonType', hidden: true },
            { field: 'reasonTypeDesc', title: 'ԭ������', width: 100, hidden: true },
            {
                field: 'reasonUse',
                title: '�Ƿ�ʹ��',
                width: 75,
                halign: 'left',
                align: 'center',
                sortable: true,
                editor: {
                    type: 'icheckbox',
                    options: { on: 'Y', off: 'N' }
                },
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PIVAS.Grid.CSS.CHNYes;
                    } else {
                        return PIVAS.Grid.CSS.CHNNo;
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OperReason',
            QueryName: 'GetOperReason',
            hosp: HospId
        },
        rownumbers: true,
        toolbar: '#gridOperReasonBar',
        columns: columns,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'reasonCode'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOperReason', dataGridOption);
}

function SaveOperReason() {
    $('#gridOperReason').datagrid('endEditing');
    var gridChanges = $('#gridOperReason').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.reasonId || '') + '^' + (iData.reasonCode || '') + '^' + (iData.reasonDesc || '') + '^' + 'R' + '^' + (iData.reasonUse || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OperReason', 'Save', paramsStr, HospId);
    var saveArr = saveRet.split('^');
    if (saveArr[0] < 0) {
        $.messager.alert('��ʾ', saveArr[1], 'warning');
    }
    $('#gridOperReason').datagrid('query', {});
}

function DeleteHandler() {
    var gridSelect = $('#gridOperReason').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ����ʾ', '��ȷ��ɾ����?', function (r) {
        if (r) {
            var reasonId = gridSelect.reasonId || '';
            if (reasonId == '') {
                var rowIndex = $('#gridOperReason').datagrid('getRowIndex', gridSelect);
                $('#gridOperReason').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.OperReason', 'Delete', reasonId, HospId);
                $('#gridOperReason').datagrid('query', {});
            }
        }
    });
}

function InitHospCombo() {
    var genHospObj = PIVAS.AddHospCom({ tableName: 'PIVA_OperReason' });
    if (typeof genHospObj === 'object') {
        genHospObj.options().onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridOperReason').datagrid('options').queryParams.hosp = HospId;
                $('#gridOperReason').datagrid('load');
            }
        };
    }
    var defHosp = $.cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PIVA_OperReason',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
}
