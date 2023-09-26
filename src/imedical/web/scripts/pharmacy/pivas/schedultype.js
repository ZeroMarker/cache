/**
 * 模块:     排班管理-班次类型维护
 * 编写日期: 2018-06-26
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var GridCmbPivaLoc;
$(function() {
    InitDict();
    InitGridDict();
    InitGridSchedulType(); //初始化列表
    $('#btnAdd').on("click", function() {
        var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
        if (pivaLocId == "") {
            $.messager.alert("提示", "请先选择配液中心", "warning");
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
        placeholder: "配液中心...",
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
                title: '配液中心描述',
                halign: 'center',
                width: 150,
                hidden: true
            },
            {
                field: "pstLocId",
                title: '配液中心',
                halign: 'center',
                width: 250,
                hidden: true
            },
            {
                field: 'pstDesc',
                title: '班次类型',
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

// 查询
function Query() {
    $("#gridSchedulType").datagrid("reload");
}

function Save() {
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $('#gridSchedulType').datagrid('endEditing');
    var gridChanges = $('#gridSchedulType').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
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
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridSchedulType').datagrid("reload");
}

function Delete() {
    var gridSelect = $('#gridSchedulType').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pstId = gridSelect.pstId || "";
            var rowIndex = $('#gridSchedulType').datagrid('getRowIndex', gridSelect);
            if (pstId != "") {
                // 验证
                var checkRet = tkMakeServerCall("web.DHCSTPIVAS.SchedulType", "Check", pstId);
                if (checkRet.split("^")[0] < 0) {
                    $.messager.confirm('确认对话框', checkRet.split("^")[1] + "</br>是否继续删除?", function(r) {
                        if (r) {
                            var delRet = tkMakeServerCall("web.DHCSTPIVAS.SchedulType", "Delete", pstId);
                            var delRetArr = delRet.split("^");
                            var delValue = delRetArr[0];
                            if (delValue < 0) {
                                $.messager.alert("提示", delRetArr[1], "warning");
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
                        $.messager.alert("提示", delRetArr[1], "warning");
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