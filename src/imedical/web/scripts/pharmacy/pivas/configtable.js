/**
 * ģ��:     ����̨ά��
 * ��д����: 2018-03-01
 * ��д��:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitGridDict();
    InitDict();
    InitGridConfig();
    $('#btnAdd').on("click", AddNewRow);
    $('#btnSave').on("click", SaveConfigtable);
    $('#btnDelete').on("click", DeleteHandler);
});

function InitDict() {
    PIVAS.ComboBox.Init({ Id: "cmbPivaLoc", Type: "PivaLoc" }, {
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("select", datas[i].RowId);
                }
            }
        },
        onSelect: function(selData) {
            $("#gridConfigtable").datagrid("query", { inputStr: selData.RowId })
        },
        placeholder: "��Һ����...",
        width:218
    });
}

function InitGridDict() {
    // ��Һ����
    GridCmbPivaLoc = PIVAS.GridComboBox.Init({ Type: "PivaLoc" }, { required: true });
}

function InitGridConfig() {
    var columns = [
        [
            { field: "configId", title: 'configId', hidden: true },
            {
                field: 'configLocId',
                title: '����̨����',
                width: 225,
                descField: 'configLoc',
                editor: GridCmbPivaLoc,
                formatter: function(value, row, index) {
                    return row.configLoc
                }
            },
            {
                field: 'configCode',
                title: '����̨����',
                width: 225,
                sortable: 'true',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'configDesc',
                title: '����̨����',
                width: 225,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            { field: 'configLoc', title: '��Һ����', width: 225, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.ConfigTable',
            QueryName: 'PIVAConfigTable',
            inputStr:  '^'+session['LOGON.HOSPID']
        },
        columns: columns,
        toolbar: "#gridConfigtableBar",
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'configCode'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridConfigtable", dataGridOption);
}

// ������
function AddNewRow() {
    $("#gridConfigtable").datagrid('addNewRow', {
        editField: 'configCode',
        defaultRow: {
            configLocId: $("#cmbPivaLoc").combobox("getValue")
        }
    });
}

function SaveConfigtable() {
    $('#gridConfigtable').datagrid('endEditing');
    var gridChanges = $('#gridConfigtable').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "û����Ҫ���������",
            type: 'alert'
        });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.configId || "") + "^" + (iData.configCode || "") + "^" + (iData.configDesc || "") + "^" + (iData.configLocId || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.ConfigTable", "Save", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridConfigtable').datagrid("query", {});
}

function DeleteHandler() {
    var gridSelect = $('#gridConfigtable').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var configId = gridSelect.configId || "";
            if (configId == "") {
                var rowIndex = $('#gridConfigtable').datagrid('getRowIndex', gridSelect);
                $('#gridConfigtable').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.ConfigTable", "DeleteConfig", configId);
                var delArr = delRet.split("^");
			    var delVal = delArr[0];
			    var delInfo = delArr[1];
                if (delVal < 0) {
			        $.messager.alert("��ʾ", delInfo, "warning");
			    }
			    else{
				    $.messager.alert("��ʾ", "ɾ���ɹ�!", "info");
				}
                $('#gridConfigtable').datagrid("query", {});
            }
        }
    })
}