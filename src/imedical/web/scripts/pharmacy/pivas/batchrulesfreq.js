/**
 * ģ��:     Ƶ�ι���ά��
 * ��д����: 2018-03-21
 * ��д��:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var NeedSelRow = '';
var GridCmbFreq;
$(function () {
    InitDict();
    InitGridFreqRule();
    $('#btnAdd').on('click', function () {
        $('#gridFreqRule').datagrid('addNewRow', {
            editField: 'freqId',
            defaultRow: {
                upFlag: '1',
                downFlag: '1'
            }
        });
    });
    $('#btnDelete').on('click', DeleteHandler);
    $('#btnUp').on('click', function () {
        MoveSort(-1);
    });
    $('#btnDown').on('click', function () {
        MoveSort(1);
    });
    $('#btnSave').on('click', function () {
        SavePIVAFreqRule();
    });
    $('#btnFind').on('click', function () {
        QueryPIVAFreqRule($('#cmbPivaLoc').combobox('getValue'));
    });
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            editable: false,
            placeholder: '��Һ����...',
            width: 200,
            onSelect: function (selData) {
                QueryPIVAFreqRule(selData.RowId);
            },
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            }
        }
    );
    GridCmbFreq = PIVAS.GridComboBox.Init(
        { Type: 'Freq' },
        {
            required: true,
            loadFilter: function (rowsData) {
                // ȥ��
                var newRowsData = [];
                var gridRowsData = $('#gridFreqRule').datagrid('getRows');
                var gridSel = $('#gridFreqRule').datagrid('getSelected');

                for (var i = 0; i < rowsData.length; i++) {
                    var pushFlag = true;
                    var rowID = rowsData[i].RowId;
                    if (gridSel !== null && gridSel.freqId == rowID) {
                    } else {
                        for (var j = 0; j < gridRowsData.length; j++) {
                            var freq = gridRowsData[j].freqId;
                            if (freq === rowID) {
                                pushFlag = false;
                                break;
                            }
                        }
                    }
                    if (pushFlag === true) {
                        newRowsData.push(rowsData[i]);
                    }
                }

                return newRowsData;
            },
            onSelect: function (selData) {
                //SavePIVAFreqRule(selData.RowId);
            }
        }
    );
}
/// ��ѯƵ�ι����б�
function QueryPIVAFreqRule(locId) {
    NeedSelRow = '';
    $('#gridFreqRule').datagrid('query', {
        inputStr: locId
    });
}
///Ƶ�ι����б�
function InitGridFreqRule() {
    var columns = [
        [
            { field: 'pfrId', title: 'Ƶ�ι���id', width: 100, hidden: true, sortable: true },
            { field: 'freqDesc', title: 'Ƶ������', width: 100, hidden: true },
            {
                field: 'freqId',
                title: 'Ƶ��',
                width: 300,
                editor: GridCmbFreq,
                descField: 'freqDesc',
                formatter: function (value, row, index) {
                    return row.freqDesc;
                }
            },
            {
                field: 'upFlag',
                title: '������������',
                width: 100,
                align: 'center',
                editor: {
                    type: 'icheckbox',
                    options: { on: '1', off: '0' }
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PIVAS.Grid.CSS.CHNYes;
                    } else {
                        return PIVAS.Grid.CSS.CHNNo;
                    }
                }
            },
            {
                field: 'downFlag',
                title: '������������',
                width: 100,
                align: 'center',
                editor: {
                    type: 'icheckbox',
                    options: { on: '1', off: '0' }
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PIVAS.Grid.CSS.CHNYes;
                    } else {
                        return PIVAS.Grid.CSS.CHNNo;
                    }
                }
            },
            { field: 'ordNum', title: '���ȼ�˳��', width: 150, hidden: true, sortable: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryPIVAFreqRule',
            StrParams: SessionLoc
        },
        columns: columns,
        rownumbers: true,
        toolbar: '#gridFreqRuleBar',
        pagination: false,

        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onDblClickCell: function (rowIndex, field, value) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('options').editIndex = undefined;
            if (NeedSelRow != '') {
                $(this).datagrid('selectRow', NeedSelRow);
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridFreqRule', dataGridOption);
}

function SavePIVAFreqRule() {
    var $grid = $('#gridFreqRule');
    $grid.datagrid('endEditing');
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    if (locId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ����Һ����',
            type: 'alert'
        });
        return;
    }

    var gridRows = $grid.datagrid('getRows');
    var length = gridRows.length;
    if (length === 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }

    var inputData = '';
    for (var i = 0; i < length; i++) {
        var iData = gridRows[i];
        var params = [locId, iData.pfrId, iData.freqId, iData.upFlag, iData.downFlag, i].join('^');
        inputData = inputData == '' ? params : inputData + '!!' + params;
    }

    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SavePIVAFreqRuleMulti', inputData);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == '-1') {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    } else if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ɹ�',
            type: 'success'
        });
    }
    QueryPIVAFreqRule(locId);
}

function DeleteHandler() {
    var $grid = $('#gridFreqRule');
    var gridSelect = $grid.datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var pfrId = gridSelect.pfrId || '';
            if (pfrId !== '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeletePIVAFreqRule', pfrId);
            }
            var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
            $grid.datagrid('deleteRow', rowIndex);
            $grid.datagrid('options').editIndex = undefined;
            DHCPHA_HUI_COM.Msg.popover({
                msg: 'ɾ���ɹ�',
                type: 'success'
            });
        }
    });
}

///moveFlag(1:����,-1:����)
//function MoveFreq(moveFlag) {
//    if ($("#gridFreqRule").datagrid('options').editIndex != undefined) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "���ȱ������ɾ�����ڱ༭�ļ�¼",
//            type: 'alert'
//        });
//        return;
//    }
//
//    var gridSelect = $('#gridFreqRule').datagrid("getSelected");
//    if (gridSelect == null) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "��ѡ����Ҫ�ƶ��ļ�¼",
//            type: 'alert'
//        });
//        return;
//    }
//    var rowCnt = $("#gridFreqRule").datagrid('getRows').length;
//    var origIndex = $("#gridFreqRule").datagrid('getRowIndex', gridSelect);
//    var index = parseInt(origIndex) + parseInt(moveFlag);
//    if (index < 0) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "�޷�����",
//            type: 'alert'
//        });
//        return;
//    } else if ((index + 1) > rowCnt) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "�޷�����",
//            type: 'alert'
//        });
//        return;
//    }
//    var origPfrId = $("#gridFreqRule").datagrid('getData').rows[origIndex].pfrId;
//    var pfrId = $("#gridFreqRule").datagrid('getData').rows[index].pfrId;
//    var inputStr = origPfrId + "^" + pfrId;
//    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "MovePIVAFreqRule", inputStr);
//    var saveArr = saveRet.split("^");
//    if (saveArr[0] == -1) {
//        $.messager.alert('��ʾ', saveArr[1], 'warning');
//        return;
//    } else if (saveArr[0] < -1) {
//        $.messager.alert('��ʾ', saveArr[1], 'error');
//        return;
//    }
//    NeedSelRow = index;
//    $('#gridFreqRule').datagrid("query", {});
//}

function MoveSort(moveFlag) {
    var $grid = $('#gridFreqRule');
    if ($grid.datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '���ȱ������ɾ�����ڱ༭�ļ�¼',
            type: 'alert'
        });
        return;
    }

    var gridSelect = $grid.datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫ�ƶ��ļ�¼',
            type: 'alert'
        });
        return;
    }
    var rowCnt = $grid.datagrid('getRows').length;
    var origIndex = $grid.datagrid('getRowIndex', gridSelect);
    var index = parseInt(origIndex) + parseInt(moveFlag);
    if (index < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '�޷�����',
            type: 'alert'
        });
        return;
    } else if (index + 1 > rowCnt) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '�޷�����',
            type: 'alert'
        });
        return;
    }
    var origData = JSON.parse(JSON.stringify($grid.datagrid('getRows')[origIndex])); // ����Ϊ����, ��Ҫ���
    var newData = JSON.parse(JSON.stringify($grid.datagrid('getRows')[index]));
    if (!origData.pfrId) {
        origData.pfrId = '';
    }
    if (!newData.pfrId) {
        newData.pfrId = '';
    }
    $grid.datagrid('updateRow', {
        index: origIndex,
        row: newData
    });
    $grid.datagrid('updateRow', {
        index: index,
        row: origData
    });
    $('[datagrid-row-index="' + origIndex + '"]>td[class!=datagrid-td-rownumber]').addClass('datagrid-value-changed');
    $('[datagrid-row-index="' + index + '"]>td[class!=datagrid-td-rownumber]').addClass('datagrid-value-changed');
    $grid.datagrid('selectRow', index);
}
