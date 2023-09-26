/**
 * ģ��:     Ƶ�ι���ά��
 * ��д����: 2018-03-21
 * ��д��:   QianHuanjuan
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
        placeholder: "��Һ����...",
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
/// ��ѯƵ�ι����б�
function QueryPIVAFreqRule(locId) {
    NeedSelRow = "";
    $('#gridFreqRule').datagrid('query', {
        inputStr: locId
    });
}
///Ƶ�ι����б�
function InitGridFreqRule() {
    var columns = [
        [
            { field: "pfrId", title: 'Ƶ�ι���id', width: 100, hidden: true, sortable: true },
            { field: "freqDesc", title: 'Ƶ������', width: 100, hidden: true },
            {
                field: "freqId",
                title: 'Ƶ��',
                width: 317,
                editor: GridCmbFreq,
                descField: 'freqDesc',
                formatter: function(value, row, index) {
                    return row.freqDesc
                }
            },
            { field: "ordNum", title: '���ȼ�˳��', width: 150, hidden: true, sortable: true }
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
            msg: "����ѡ����Һ����",
            type: 'alert'
        });
        return;
    }
    if (freqId == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ��Ƶ��",
            type: 'alert'
        });
        return;
    }
    var params = locId + "^" + freqId;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "SavePIVAFreqRule", params);
    var saveArr = saveRet.split("^");
    if (saveArr[0] == -1) {
        $.messager.alert('��ʾ', saveArr[1], 'warning');
    } else if (saveArr[0] < -1) {
        $.messager.alert('��ʾ', saveArr[1], 'error');
    }
    QueryPIVAFreqRule(locId);
}

function DeleteHandler() {
    var gridSelect = $('#gridFreqRule').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var pfrId = gridSelect.pfrId;
            var delRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "DeletePIVAFreqRule", pfrId);
            $('#gridFreqRule').datagrid("query", {});
        }
    })
}

///moveFlag(1:����,-1:����)
function MoveFreq(moveFlag) {
    if ($("#gridFreqRule").datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "���ȱ������ɾ�����ڱ༭�ļ�¼",
            type: 'alert'
        });
        return;
    }

    var gridSelect = $('#gridFreqRule').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫ�ƶ��ļ�¼",
            type: 'alert'
        });
        return;
    }
    var rowCnt = $("#gridFreqRule").datagrid('getRows').length;
    var origIndex = $("#gridFreqRule").datagrid('getRowIndex', gridSelect);
    var index = parseInt(origIndex) + parseInt(moveFlag);
    if (index < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "�޷�����",
            type: 'alert'
        });
        return;
    } else if ((index + 1) > rowCnt) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "�޷�����",
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
        $.messager.alert('��ʾ', saveArr[1], 'warning');
        return;
    } else if (saveArr[0] < -1) {
        $.messager.alert('��ʾ', saveArr[1], 'error');
        return;
    }
    NeedSelRow = index;
    $('#gridFreqRule').datagrid("query", {});
}

///MySort(index, "down", "gridBatchrulesFreq")
function MySort(index, type, gridname) {
    //������,��ʱ����
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