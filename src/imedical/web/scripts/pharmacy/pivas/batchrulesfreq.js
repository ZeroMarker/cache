/**
 * 模块:     频次规则维护
 * 编写日期: 2018-03-21
 * 编写人:   QianHuanjuan
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
            placeholder: '配液中心...',
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
                // 去重
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
/// 查询频次规则列表
function QueryPIVAFreqRule(locId) {
    NeedSelRow = '';
    $('#gridFreqRule').datagrid('query', {
        inputStr: locId
    });
}
///频次规则列表
function InitGridFreqRule() {
    var columns = [
        [
            { field: 'pfrId', title: '频次规则id', width: 100, hidden: true, sortable: true },
            { field: 'freqDesc', title: '频次描述', width: 100, hidden: true },
            {
                field: 'freqId',
                title: '频次',
                width: 300,
                editor: GridCmbFreq,
                descField: 'freqDesc',
                formatter: function (value, row, index) {
                    return row.freqDesc;
                }
            },
            {
                field: 'upFlag',
                title: '允许上移批次',
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
                title: '允许下移批次',
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
            { field: 'ordNum', title: '优先级顺序', width: 150, hidden: true, sortable: true }
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
            msg: '请先选择配液中心',
            type: 'alert'
        });
        return;
    }

    var gridRows = $grid.datagrid('getRows');
    var length = gridRows.length;
    if (length === 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
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
        $.messager.alert('提示', saveInfo, 'warning');
    } else if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '保存成功',
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
            msg: '请先选中需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var pfrId = gridSelect.pfrId || '';
            if (pfrId !== '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeletePIVAFreqRule', pfrId);
            }
            var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
            $grid.datagrid('deleteRow', rowIndex);
            $grid.datagrid('options').editIndex = undefined;
            DHCPHA_HUI_COM.Msg.popover({
                msg: '删除成功',
                type: 'success'
            });
        }
    });
}

///moveFlag(1:下移,-1:上移)
//function MoveFreq(moveFlag) {
//    if ($("#gridFreqRule").datagrid('options').editIndex != undefined) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "请先保存或者删除正在编辑的记录",
//            type: 'alert'
//        });
//        return;
//    }
//
//    var gridSelect = $('#gridFreqRule').datagrid("getSelected");
//    if (gridSelect == null) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "请选择需要移动的记录",
//            type: 'alert'
//        });
//        return;
//    }
//    var rowCnt = $("#gridFreqRule").datagrid('getRows').length;
//    var origIndex = $("#gridFreqRule").datagrid('getRowIndex', gridSelect);
//    var index = parseInt(origIndex) + parseInt(moveFlag);
//    if (index < 0) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "无法上移",
//            type: 'alert'
//        });
//        return;
//    } else if ((index + 1) > rowCnt) {
//        DHCPHA_HUI_COM.Msg.popover({
//            msg: "无法下移",
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
//        $.messager.alert('提示', saveArr[1], 'warning');
//        return;
//    } else if (saveArr[0] < -1) {
//        $.messager.alert('提示', saveArr[1], 'error');
//        return;
//    }
//    NeedSelRow = index;
//    $('#gridFreqRule').datagrid("query", {});
//}

function MoveSort(moveFlag) {
    var $grid = $('#gridFreqRule');
    if ($grid.datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先保存或者删除正在编辑的记录',
            type: 'alert'
        });
        return;
    }

    var gridSelect = $grid.datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要移动的记录',
            type: 'alert'
        });
        return;
    }
    var rowCnt = $grid.datagrid('getRows').length;
    var origIndex = $grid.datagrid('getRowIndex', gridSelect);
    var index = parseInt(origIndex) + parseInt(moveFlag);
    if (index < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '无法上移',
            type: 'alert'
        });
        return;
    } else if (index + 1 > rowCnt) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '无法下移',
            type: 'alert'
        });
        return;
    }
    var origData = JSON.parse(JSON.stringify($grid.datagrid('getRows')[origIndex])); // 对象为引用, 需要深拷贝
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
