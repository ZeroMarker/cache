/**
 * ģ��:     �Ű����-�������ά��
 * ��д����: 2018-06-26
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var GridCmbPivaLoc;
$(function() {
    InitDict();
    InitGridDict();
    InitGridSchedulType(); //��ʼ���б�
    $('#btnAdd').on("click", function() {
        var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
        if (pivaLocId == "") {
            $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
            return
        }
        $("#gridSchedulType").datagrid('addNewRow', {
            editField: 'pstDesc',
            defaultRow: {
                pstLocId: $("#cmbPivaLoc").combobox("getValue") || "",
                pstLocDesc: $("#cmbPivaLoc").combobox("getText") || ""
            }
        });
    });
    $('#btnSave').on("click", Save);
    $('#btnDelete').on("click", Delete);
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
            $('#gridSchedulType').datagrid("query", { inputStr: selData.RowId });
        },
        editable: false,
        placeholder: "��Һ����...",
        width: 275
    });
}

function InitGridDict() {
    GridCmbPivaLoc = PIVAS.GridComboBox.Init({
        Type: "PivaLoc",
        QueryParams: { inputStr: SessionLoc }
    }, {
        required: true,
        editable: false
    });
}

function InitGridSchedulType() {
    var columns = [
        [
            { field: "pstId", title: 'pstId', hidden: true, width: 100 },
            {
                field: "pstLocDesc",
                title: '��Һ��������',
                halign: 'center',
                width: 150,
                hidden: true
            },
            {
                field: "pstLocId",
                title: '��Һ����',
                halign: 'center',
                width: 250,
                hidden: true
            },
            {
                field: 'pstDesc',
                title: '�������',
                width: 200,
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.SchedulType',
            QueryName: 'PIVASchedulType'
        },
        columns: columns,
        toolbar: "#gridSchedulTypeBar",
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'pstDesc'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridSchedulType", dataGridOption);
}

// ��ѯ
function Query() {
    $("#gridSchedulType").datagrid("reload");
}

function Save() {
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $('#gridSchedulType').datagrid('endEditing');
    var gridChanges = $('#gridSchedulType').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridSchedulType').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var params = (iData.pstId || "") + "^" + pivaLocId + "^" + (iData.pstDesc || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.SchedulType", "SaveMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridSchedulType').datagrid("reload");
}

function Delete() {
    var gridSelect = $('#gridSchedulType').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pstId = gridSelect.pstId || "";
            var rowIndex = $('#gridSchedulType').datagrid('getRowIndex', gridSelect);
            if (pstId != "") {
                // ��֤
                var checkRet = tkMakeServerCall("web.DHCSTPIVAS.SchedulType", "Check", pstId);
                if (checkRet.split("^")[0] < 0) {
                    $.messager.confirm('ȷ�϶Ի���', checkRet.split("^")[1] + "</br>�Ƿ����ɾ��?", function(r) {
                        if (r) {
                            var delRet = tkMakeServerCall("web.DHCSTPIVAS.SchedulType", "Delete", pstId);
                            var delRetArr = delRet.split("^");
                            var delValue = delRetArr[0];
                            if (delValue < 0) {
                                $.messager.alert("��ʾ", delRetArr[1], "warning");
                                return;
                            }
                            $('#gridSchedulType').datagrid("reload");
                        }
                    });
                } else {
                    var delRet = tkMakeServerCall("web.DHCSTPIVAS.SchedulType", "Delete", pstId);
                    var delRetArr = delRet.split("^");
                    var delValue = delRetArr[0];
                    if (delValue < 0) {
                        $.messager.alert("��ʾ", delRetArr[1], "warning");
                        return;
                    }
                    $('#gridSchedulType').datagrid("reload");
                }
            } else {
                $('#gridSchedulType').datagrid("deleteRow", rowIndex);
            }
        }
    })
}