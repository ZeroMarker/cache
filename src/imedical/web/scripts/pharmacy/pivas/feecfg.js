/**
 * ģ��:     ��Һ�շ�����
 * ��д����: 2020-01-09
 * ��д��:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
$(function () {
    InitGridFeeCfg();
    InitHospCombo();
    $('#btnSave').on('click', Save);
    $('.dhcpha-win-mask').remove();
});

function InitGridFeeCfg() {
    var columns = [
        [
            {
                field: 'arcim',
                title: 'arcim',
                width: 50,
                hidden: true
            },
            {
                field: 'arcimCode',
                title: 'ҽ�������',
                width: 200,
                align: 'left'
            },
            {
                field: 'arcimDesc',
                title: 'ҽ��������',
                width: 400,
                align: 'left'
            },
            {
                field: 'maxAmt',
                title: 'һ���շ����޽��',
                hidden: true,
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'times',
                title: '����շѴ��� / ��',
                align: 'center',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.FeeCfg',
            QueryName: 'PHAPIVASFeeCfg',
            pHosp: HospId,
            rows: 999
        },
        rownumbers: true,
        columns: columns,
        toolbar: '#gridFeeCfgBar',
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'times'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridFeeCfg', dataGridOption);
}

function Save() {
    $('#gridFeeCfg').datagrid('endEditing');
    var gridRows = $('#gridFeeCfg').datagrid('getRows');
    var gridChanges = $('#gridFeeCfg').datagrid('getChanges');
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
        var times = iData.times || '';
        var maxAmt = iData.maxAmt || '';
        var msgInfo = '';
        if (times != '') {
            if (isNaN(times) == true) {
                msgInfo = '��Ϊ����';
            } else {
                var timeInt = parseInt(times);
                if (timeInt != times) {
                    msgInfo = '��Ϊ����';
                }
                if (timeInt <= 0) {
                    msgInfo = 'Ӧ����0';
                }
            }
        }
        if (maxAmt != '') {
            if (isNaN(maxAmt) == true) {
                msgInfo = '��Ϊ����';
            }
        }
        if (msgInfo != '') {
            var rowIndex = gridRows.indexOf(iData);
            DHCPHA_HUI_COM.Msg.popover({
                msg: '��' + (rowIndex + 1) + '��,' + msgInfo,
                type: 'alert'
            });
            return;
        }
        var params = (iData.arcim || '') + '^' + times + '^' + maxAmt + '^' + HospId;
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.FeeCfg', 'SaveMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridFeeCfg').datagrid('reload');
}

function InitHospCombo() {
    var genHospObj = PIVAS.AddHospCom({ tableName: 'PHAPIVAS_FeeCfg' });
    if (typeof genHospObj === 'object') {
        genHospObj.options().onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridFeeCfg').datagrid('options').queryParams.pHosp = HospId;
                $('#gridFeeCfg').datagrid('reload');
            }
        };
    }
    var defHosp = $.cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PHAPIVAS_FeeCfg',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
}
