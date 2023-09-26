/**
 * 模块:     频次规则维护
 * 编写日期: 2018-03-21
 * 编写人:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var NeedSelRow = "";
var GridCmbFreq;
$(function() {
    InitDict();
    InitGridFreqRule();
    $("#btnAdd").on("click", function() {
        $("#gridFreqRule").datagrid('addNewRow', {
            editField: 'freqId'
        });
    });
    $("#btnDelete").on("click", DeleteHandler);
    $("#btnUp").on("click", function() {
        MoveFreq(-1);
    });
    $("#btnDown").on("click", function() {
        MoveFreq(1);
    });

});

function InitDict() {
    PIVAS.ComboBox.Init({ Id: "cmbPivaLoc", Type: "PivaLoc" }, {
        editable: false,
        placeholder: "配液中心...",
        width: 180,
        onSelect: function(selData) {
            QueryPIVAFreqRule(selData.RowId);
        },
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("select", datas[i].RowId);
                    break;
                }
            }
        }
    });
    GridCmbFreq = PIVAS.GridComboBox.Init({ Type: "Freq" }, {
        required: true,
        onSelect: function(selData) {
            SavePIVAFreqRule(selData.RowId);
        }
    });
}
/// 查询频次规则列表
function QueryPIVAFreqRule(locId) {
    NeedSelRow = "";
    $('#gridFreqRule').datagrid('query', {
        inputStr: locId
    });
}
///频次规则列表
function InitGridFreqRule() {
    var columns = [
        [
            { field: "pfrId", title: '频次规则id', width: 100, hidden: true, sortable: true },
            { field: "freqDesc", title: '频次描述', width: 100, hidden: true },
            {
                field: "freqId",
                title: '频次',
                width: 317,
                editor: GridCmbFreq,
                descField: 'freqDesc',
                formatter: function(value, row, index) {
                    return row.freqDesc
                }
            },
            { field: "ordNum", title: '优先级顺序', width: 150, hidden: true, sortable: true }
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
        toolbar: "#gridFreqRuleBar",
        pagination: false,
        onClickRow: function(rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function(data) {
            $(this).datagrid('options').editIndex = undefined;
            if (NeedSelRow != "") {
                $(this).datagrid('selectRow', NeedSelRow);
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridFreqRule", dataGridOption);
}

function SavePIVAFreqRule(freqId) {
    var locId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (locId == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选择配液中心",
            type: 'alert'
        });
        return;
    }
    if (freqId == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选择频次",
            type: 'alert'
        });
        return;
    }
    var params = locId + "^" + freqId;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "SavePIVAFreqRule", params);
    var saveArr = saveRet.split("^");
    if (saveArr[0] == -1) {
        $.messager.alert('提示', saveArr[1], 'warning');
    } else if (saveArr[0] < -1) {
        $.messager.alert('提示', saveArr[1], 'error');
    }
    QueryPIVAFreqRule(locId);
}

function DeleteHandler() {
    var gridSelect = $('#gridFreqRule').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选中需要删除的记录",
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function(r) {
        if (r) {
            var pfrId = gridSelect.pfrId;
            var delRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "DeletePIVAFreqRule", pfrId);
            $('#gridFreqRule').datagrid("query", {});
        }
    })
}

///moveFlag(1:下移,-1:上移)
function MoveFreq(moveFlag) {
    if ($("#gridFreqRule").datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先保存或者删除正在编辑的记录",
            type: 'alert'
        });
        return;
    }

    var gridSelect = $('#gridFreqRule').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请选择需要移动的记录",
            type: 'alert'
        });
        return;
    }
    var rowCnt = $("#gridFreqRule").datagrid('getRows').length;
    var origIndex = $("#gridFreqRule").datagrid('getRowIndex', gridSelect);
    var index = parseInt(origIndex) + parseInt(moveFlag);
    if (index < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "无法上移",
            type: 'alert'
        });
        return;
    } else if ((index + 1) > rowCnt) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "无法下移",
            type: 'alert'
        });
        return;
    }
    var origPfrId = $("#gridFreqRule").datagrid('getData').rows[origIndex].pfrId;
    var pfrId = $("#gridFreqRule").datagrid('getData').rows[index].pfrId;
    var inputStr = origPfrId + "^" + pfrId;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "MovePIVAFreqRule", inputStr);
    var saveArr = saveRet.split("^");
    if (saveArr[0] == -1) {
        $.messager.alert('提示', saveArr[1], 'warning');
        return;
    } else if (saveArr[0] < -1) {
        $.messager.alert('提示', saveArr[1], 'error');
        return;
    }
    NeedSelRow = index;
    $('#gridFreqRule').datagrid("query", {});
}

///MySort(index, "down", "gridBatchrulesFreq")
function MySort(index, type, gridname) {
    //先留着,暂时不用
    return
    var $grid = $('#' + gridname);
    if ("up" == type) {
        if (index != 0) {
            var nextrow = parseInt(index) - 1;
            var lastrow = parseInt(index);
            var toup = $grid.datagrid('getData').rows[lastrow];
            var todown = $grid.datagrid('getData').rows[index - 1];
            $grid.datagrid('getData').rows[lastrow] = todown;
            $grid.datagrid('getData').rows[nextrow] = toup;
            $grid.datagrid('refreshRow', lastrow);
            $grid.datagrid('refreshRow', nextrow);
            $grid.datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $grid.datagrid('getRows').length;
        if (index != rows - 1) {
            var nextrow = parseInt(index) + 1;
            var lastrow = parseInt(index);
            var todown = $grid.datagrid('getData').rows[lastrow];
            var toup = $grid.datagrid('getData').rows[nextrow];
            $grid.datagrid('getData').rows[nextrow] = todown;
            $grid.datagrid('getData').rows[lastrow] = toup;
            $grid.datagrid('refreshRow', lastrow);
            $grid.datagrid('refreshRow', nextrow);
            $grid.datagrid('selectRow', nextrow);
        }
    }
}