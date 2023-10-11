/**
 * 模块:     配液收费设置
 * 编写日期: 2020-01-09
 * 编写人:   yunhaibao
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
                title: '医嘱项代码',
                width: 200,
                align: 'left'
            },
            {
                field: 'arcimDesc',
                title: '医嘱项名称',
                width: 400,
                align: 'left'
            },
            {
                field: 'maxAmt',
                title: '一天收费上限金额',
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
                title: '最大收费次数 / 日',
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
            msg: '没有需要保存的数据',
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
                msgInfo = '不为数字';
            } else {
                var timeInt = parseInt(times);
                if (timeInt != times) {
                    msgInfo = '不为整数';
                }
                if (timeInt <= 0) {
                    msgInfo = '应大于0';
                }
            }
        }
        if (maxAmt != '') {
            if (isNaN(maxAmt) == true) {
                msgInfo = '不为数字';
            }
        }
        if (msgInfo != '') {
            var rowIndex = gridRows.indexOf(iData);
            DHCPHA_HUI_COM.Msg.popover({
                msg: '第' + (rowIndex + 1) + '行,' + msgInfo,
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
        $.messager.alert('提示', saveInfo, 'warning');
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
