/**
 * ģ��:     ��������ά��
 * ��д����: 2018-03-26
 * ��д��:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var NeedSelRow = "";
var GridCmbPivaLoc;
var GridCmbWard;
var GridCmgInc;
var GridCmbBatNo;
var GridCmbInstruc;
$(function() {
    InitDict();
    InitGridDict();
    /* �������� */
    InitGridLocBat();
    $("#btnAdd").on("click", AddNewRowLocBat);
    $("#btnSave").on("click", SaveLocBat);
    $("#btnDelete").on("click", DeleteLocBat);
    /* �������� */

    /* ��ϸ���� */
    InitGridLocBatInc();
    InitGridLocBatIncFix();
    InitGridLocBatInsFix();
    InitGridLocBatCub();
    /* ��ϸ���� */

    $("#btnAddInc,#btnAddIncFix,#btnAddInsFix,#btnAddCub").on("click", AddNewRowLocBatItm);
    $("#btnDelInc,#btnDelIncFix,#btnDelInsFix").on("click", DeleteLocBatItm);
    $("#btnSaveInc,#btnSaveIncFix,#btnSaveInsFix").on("click", SaveLocBatItm);

    /* �ݻ�����*/
    $("#btnDelCub").on("click", DeleteLocBatCub);
    $("#btnSaveCub").on("click", SaveLocBatCub);
    /* �ݻ�����*/

    $("#btnUpInc").on("click", function() {
        MoveInc(-1)
    });
    $("#btnDownInc").on("click", function() {
        MoveInc(1)
    });

});

/// ��ʼ���ֵ�
function InitDict() {
    PIVAS.ComboBox.Init({ Id: "cmbPivaLoc", Type: "PivaLoc" }, {
        editable: false,
        placeholder: "��Һ����...",
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("select", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function() {
            QueryPIVALocBat();
        }
    });
    PIVAS.ComboBox.Init({ Id: "cmbWard", Type: "Ward" }, { width: 250, placeholder: "����..." });
}

function InitGridDict() {
    GridCmbPivaLoc = PIVAS.GridComboBox.Init({ Type: "PivaLoc", QueryParams: { inputStr: SessionLoc } }, { required: true });
    GridCmbWard = PIVAS.GridComboBox.Init({ Type: "Ward" }, { required: true });
    GridCmbBatNo = PIVAS.GridComboBox.Init({ Type: "PIVALocBatNo" }, {
        required: true,
        valueField: 'batNo',
        textField: 'batNo',
        editable : false
    });
    GridCmbInstruc = PIVAS.GridComboBox.Init({ Type: "Instruc" }, { required: true,editable : false });
    GridCmgInc = PIVAS.GridComboGrid.Init({ Type: "IncItm" }, {
        required: true,
        idField: 'incRowId',
        textField: 'incDesc',
        onHidePanel:function(){
	        var val = $(this).combogrid("getValue")||""; 
	        var text = $(this).combogrid("getText")||""; 
	        if (val==text){
	            $(this).combogrid("clear");	            
	        }
        }
    });
}

///���������б�
function InitGridLocBat() {
    //����columns
    var columns = [
        [
            { field: "plbatId", title: '���ι���id', width: 80, hidden: true },
            { field: "locDesc", title: '��Һ��������', width: 80, hidden: true },
            {
                field: "locId",
                title: '��Һ����',
                width: 200,
                descField: 'locDesc',
                editor: GridCmbPivaLoc,
                formatter: function(value, rowData, rowIndex) {
                    return rowData.locDesc;
                }
            },
            { field: "wardDesc", title: '��������', width: 80, hidden: true },
            {
                field: "wardId",
                title: '����',
                width: 220,
                descField: 'wardDesc',
                editor: GridCmbWard,
                formatter: function(value, rowData, rowIndex) {
                    return rowData.wardDesc;
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryPIVALocBat',
            StrParams: SessionLoc
        },
        columns: columns,
        rownumbers: false,
        toolbar: "#gridLocBatBar",
        onDblClickRow: function(rowIndex, rowData) {
            if ((rowData.wardId == "") || (rowData.wardId == undefined)) {
                return false;
            }
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'wardId'
            });
        },
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            QueryLocBatInc();
            QueryLocBatIncFix();
            QueryLocBatInsFix();
            QueryLocBatCub();
            GridCmbBatNo = PIVAS.GridComboBox.Init({ Type: "PIVALocBatNo", QueryParams: { inputStr: rowData.locId } }, {
                required: true,
                valueField: 'batNo',
                textField: 'batNo',
       			editable : false
            });
            var gridCol = $("#gridLocBatIncFix").datagrid('getColumnOption', "batNo");
            gridCol.editor = GridCmbBatNo;
            var gridCol = $("#gridLocBatInsFix").datagrid('getColumnOption', "batNo");
            gridCol.editor = GridCmbBatNo;
            var gridCol = $("#gridLocBatCub").datagrid('getColumnOption', "batNo");
            gridCol.editor = GridCmbBatNo;
        },
        onLoadSuccess: function() {
            QueryLocBatInc();
            QueryLocBatIncFix();
            QueryLocBatInsFix();
            QueryLocBatCub();
        },
        onAfterEdit: function(rowIndex, rowData, changes) {
            // maybe todo
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridLocBat", dataGridOption);
}
// ���Ӳ�������
function AddNewRowLocBat() {
    $("#gridLocBat").datagrid('addNewRow', {
        editField: 'wardId',
        defaultRow: {
            locId: $("#cmbPivaLoc").combobox("getValue")
        }
    });
}

/// ��ѯ��������
function QueryPIVALocBat() {
    var locId = $("#cmbPivaLoc").combobox('getValue') || "";
    var params = locId + "^" + "";
    $('#gridLocBat').datagrid('query', {
        inputStr: params
    });
}
/// ���没������
function SaveLocBat() {
    $('#gridLocBat').datagrid('endEditing');
    var gridChanges = $('#gridLocBat').datagrid('getChanges')
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
        var params = (iData.plbatId || "") + "^" + (iData.wardId || "") + "^" + (iData.locId || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "SavePIVALocBatMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == "-1") {
        $.messager.alert("��ʾ", saveInfo, "warning");
    } else if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "error");
    }
    $('#gridLocBat').datagrid("query", {});
}

/// ɾ����������
function DeleteLocBat() {
    var gridSelect = $('#gridLocBat').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var plbatId = gridSelect.plbatId || "";
            if (plbatId == "") {
                var rowIndex = $('#gridLocBat').datagrid('getRowIndex', gridSelect);
                $('#gridLocBat').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "DeletePIVALocBat", plbatId);
                if (delRet.split("^")[0] < 0) {
                    $.messager.alert("��ʾ", delRet.split("^")[1], "warning");
                    return;
                } else {
                    $('#gridLocBat').datagrid("query", {});
                }
            }
        }
    })
}

///ҩƷ˳������б�
function InitGridLocBatInc() {
    var columns = [
        [
            { field: "plbatItmId", title: 'ҩƷ˳�����Id', width: 80, hidden: 'true' },
            {
                field: "incRowId",
                title: 'ҩƷ����',
                width: 300,
                editor: GridCmgInc,
                descField: 'incDesc',
                formatter: function(value, row, index) {
                    return row.incDesc;
                }
            },
            { field: "incDesc", title: 'ҩƷ��������', width: 220, hidden: 'true', align: 'center' },
            { field: "ordNum", title: '˳��', width: 220, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: true,
        pageSize: 100,
        toolbar: "#gridLocBatIncBar",
        onClickRow: function(rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function() {
            $(this).datagrid('options').editIndex = undefined;
            if (NeedSelRow != "") {
                $(this).datagrid('selectRow', NeedSelRow);
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridLocBatInc", dataGridOption);
}

///ҩƷ�̶������б�
function InitGridLocBatIncFix() {
    //����columns
    var columns = [
        [
            { field: "plbatItmId", title: '���������ӱ�Id', width: 80, hidden: true },
            { field: "incDesc", title: 'ҩƷ��������', width: 300, halign: 'center', align: 'left', hidden: true },
            {
                field: "incRowId",
                title: 'ҩƷ����',
                width: 300,
                editor: GridCmgInc,
                descField: 'incDesc',
                formatter: function(value, row, index) {
                    return row.incDesc;
                }
            },
            {
                field: "batNo",
                title: '����',
                width: 100,
                editor: GridCmbBatNo
            },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: false,
        toolbar: "#gridLocBatIncFixBar",
        onClickRow: function(rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function() {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridLocBatIncFix", dataGridOption);
}
/// �÷��̶������б�
function InitGridLocBatInsFix() {
    var columns = [
        [
            { field: "plbatItmId", title: '���������ӱ�Id', width: 80, hidden: true },
            { field: "instrucDesc", title: '�÷�����', width: 80, align: 'left', hidden: true },
            {
                field: "instrucId",
                title: '�÷�',
                width: 200,
                editor: GridCmbInstruc,
                descField: 'instrucDesc',
                formatter: function(value, row, index) {
                    return row.instrucDesc;
                }
            },
            {
                field: "batNo",
                title: '����',
                width: 180,
                editor: GridCmbBatNo
            },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatItm'
        },
        columns: columns,
        rownumbers: false,
        toolbar: "#gridLocBatInsFixBar",
        onClickRow: function(rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function() {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridLocBatInsFix", dataGridOption);
}
//�ݻ������б�
function InitGridLocBatCub() {
    var columns = [
        [
            { field: "plbatCubId", title: '�ݻ�����Id', width: 80, hidden: true },
            {
                field: "batNo",
                title: '����',
                width: 180,
                editor: GridCmbBatNo
            },
            {
                field: "minCub",
                title: '����(ml)',
                width: 120,
                align: 'right',
                halign: 'left',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: "maxCub",
                title: '����(ml)',
                width: 120,
                align: 'right',
                halign: 'left',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryLocBatCub'
        },
        columns: columns,
        rownumbers: false,
        toolbar: "#gridLocBatCubBar",
        onClickRow: function(rowIndex, rowData) {
            var editIndex = $(this).datagrid('options').editIndex;
            if (editIndex != undefined) {
                $(this).datagrid('selectRow', editIndex);
            }
        },
        onLoadSuccess: function() {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridLocBatCub", dataGridOption);
}
/// ���没�������ӱ�
function SaveLocBatItm() {
    var gridLocBatSel = $('#gridLocBat').datagrid('getSelected');
    if (gridLocBatSel == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����ಡ�������¼",
            type: 'alert'
        });
        return;
    }
    var gridId = "";
    var inputData = "";
    var incParams = "";
    var incFixParams = "";
    var insFixParams = "";
    var tabTitle = $('#tabsBatchRulesWard').tabs('getSelected').panel('options').title;
    switch (tabTitle) {
        case 'ҩƷ˳�����':
            gridId = "gridLocBatInc";
            $('#gridLocBatInc').datagrid('endEditing');
            var gridChanges = $('#gridLocBatInc').datagrid('getChanges')
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "û����Ҫ���������",
                    type: 'alert'
                });
                return;
            }
            var incParams = "";
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = (iData.incRowId || "");
                params = params + "!!" + "" + "!!" + "";
                inputData = (inputData == "") ? params : inputData + "|@|" + params;
            }
            break;
        case 'ҩƷ�̶�����':
            gridId = "gridLocBatIncFix";
            $('#gridLocBatIncFix').datagrid('endEditing');
            var gridChanges = $('#gridLocBatIncFix').datagrid('getChanges')
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "û����Ҫ���������",
                    type: 'alert'
                });
                return;
            }
            var incParams = "";
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = (iData.incRowId || "") + "^" + (iData.batNo || "");
                params = "" + "!!" + params + "!!" + "";
                inputData = (inputData == "") ? params : inputData + "|@|" + params;
            }
            break;
        case '�÷��̶�����':
            gridId = "gridLocBatInsFix";
            $('#gridLocBatInsFix').datagrid('endEditing');
            var gridChanges = $('#gridLocBatInsFix').datagrid('getChanges')
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "û����Ҫ���������",
                    type: 'alert'
                });
                return;
            }
            var incParams = "";
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                var params = (iData.instrucId || "") + "^" + (iData.batNo || "");
                params = "" + "!!" + "" + "!!" + params;
                inputData = (inputData == "") ? params : inputData + "|@|" + params;
            }
            break;
        default:
            break;
    }
    var plBatId = gridLocBatSel.plbatId;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "SavePIVALocBatItmMulti", plBatId, inputData);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#' + gridId).datagrid("query", {});
}

//��ȡҩƷ˳������б�
function QueryLocBatInc() {
    NeedSelRow = "";
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = "";
    if (gridSelect) {
        plbatId = gridSelect.plbatId || "";
    }
    $('#gridLocBatInc').datagrid('query', {
        inputStr: "Inc" + "^" + plbatId
    });
}
/// ɾ�����������ӱ�
function DeleteLocBatItm() {
    var tabTitle = $('#tabsBatchRulesWard').tabs('getSelected').panel('options').title;
    var gridId = "";
    switch (tabTitle) {
        case 'ҩƷ˳�����':
            gridId = "gridLocBatInc";
            break;
        case 'ҩƷ�̶�����':
            gridId = "gridLocBatIncFix";
            break;
        case '�÷��̶�����':
            gridId = "gridLocBatInsFix";
            break;
        default:
            break;
    }
    var gridSelect = $('#' + gridId).datagrid('getSelected');
    if ((gridSelect == "") || (gridSelect == null)) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var plbatItmId = gridSelect.plbatItmId || "";
            if (plbatItmId == "") {
                var rowIndex = $('#' + gridId).datagrid('getRowIndex', gridSelect);
                $('#' + gridId).datagrid("deleteRow", rowIndex);
                $('#' + gridId).datagrid('options').editIndex = undefined;
            } else {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "DeletePIVALocBatItm", plbatItmId);
                $('#' + gridId).datagrid("query", {});
            }
        }
    })
}

/// ��ѯҩƷ�̶������б�
function QueryLocBatIncFix() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = "";
    if (gridSelect) {
        plbatId = gridSelect.plbatId || "";
    }
    $('#gridLocBatIncFix').datagrid('query', {
        inputStr: "IncFix" + "^" + plbatId
    });
}

function QueryLocBatInsFix() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = "";
    if (gridSelect) {
        plbatId = gridSelect.plbatId || "";
    }
    $('#gridLocBatInsFix').datagrid('query', {
        inputStr: "InsFix" + "^" + plbatId
    });
}

/// �����ӱ�����
function AddNewRowLocBatItm() {
    var tabTitle = $('#tabsBatchRulesWard').tabs('getSelected').panel('options').title;
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    if ((gridSelect == "") || (gridSelect == null)) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����ಡ�������¼",
            type: 'alert'
        });
        return;
    }
    var plbatId = gridSelect.plbatId || "";
    if (plbatId == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����ಡ�������¼",
            type: 'alert'
        });
        return;
    }
    switch (tabTitle) {
        case 'ҩƷ˳�����':
            $("#gridLocBatInc").datagrid('addNewRow', {
                editField: 'incRowId'
            });
            break;
        case 'ҩƷ�̶�����':
            $("#gridLocBatIncFix").datagrid('addNewRow', {
                editField: 'incRowId'
            });
            break;
        case '�÷��̶�����':
            $("#gridLocBatInsFix").datagrid('addNewRow', {
                editField: 'instrucId'
            });
            break;
        case '�ݻ�����':
            $("#gridLocBatCub").datagrid('addNewRow', {
                editField: 'batNo'
            });
            break;
        default:
            break;
    }
}
/// ��ѯ�ݻ�����
function QueryLocBatCub() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    var plbatId = "";
    if (gridSelect) {
        plbatId = gridSelect.plbatId || "";
    }
    $('#gridLocBatCub').datagrid('query', {
        inputStr: plbatId
    });
}
/// �����ݻ�����
function SaveLocBatCub() {
    var gridSelect = $('#gridLocBat').datagrid('getSelected');
    if (gridSelect == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����ಡ�������¼",
            type: 'alert'
        });
        return;
    }
    var plbatId = gridSelect.plbatId;
    $('#gridLocBatCub').datagrid('endEditing');
    var gridChanges = $('#gridLocBatCub').datagrid('getChanges')
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
        var maxCub = iData.maxCub || "";
        var minCub = iData.minCub || "";
        var batNo = iData.batNo || "";
        if (batNo == "") {
            $.messager.alert("��ʾ", "���β���Ϊ��", "warning");
            return;
        }
        var params = plbatId + "^" + minCub + "^" + maxCub + "^" + batNo;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "SaveLocBatCubageMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == "-1") {
        $.messager.alert("��ʾ", saveInfo, "warning");
    } else if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "error");
    }
    $('#gridLocBatCub').datagrid("query", {});
}

/// ɾ���ݻ�����
function DeleteLocBatCub() {
    var gridSelect = $('#gridLocBatCub').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
            var plbatCubId = gridSelect.plbatCubId || "";
            if (plbatCubId == "") {
                var rowIndex = $('#gridLocBatCub').datagrid('getRowIndex', gridSelect);
                $('#gridLocBatCub').datagrid("deleteRow", rowIndex);
                $('#gridLocBatCub').datagrid('options').editIndex = undefined;
            } else {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "DeleteLocBatCubage", plbatCubId);
                $('#gridLocBatCub').datagrid("query", {});
            }
        }
    })
}

// �ƶ�ҩƷ˳��
function MoveInc(moveFlag) {
    if ($("#gridLocBatInc").datagrid('options').editIndex != undefined) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "���ȱ������ɾ�����ڱ༭�ļ�¼",
            type: 'alert'
        });
        return;
    }

    var gridSelect = $('#gridLocBatInc').datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫ�ƶ��ļ�¼",
            type: 'alert'
        });
        return;
    }
    var rowCnt = $("#gridLocBatInc").datagrid('getRows').length;
    var origIndex = $("#gridLocBatInc").datagrid('getRowIndex', gridSelect);
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
    var origPlbItm = $("#gridLocBatInc").datagrid('getData').rows[origIndex].plbatItmId;
    var plbItm = $("#gridLocBatInc").datagrid('getData').rows[index].plbatItmId;
    var inputStr = origPlbItm + "^" + plbItm;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.BatchRules", "MovePIVALocBatItm", origPlbItm, plbItm);
    var saveArr = saveRet.split("^");
    if (saveArr[0] == -1) {
        $.messager.alert('��ʾ', saveArr[1], 'warning');
    } else if (saveArr[0] < -1) {
        $.messager.alert('��ʾ', saveArr[1], 'error');
    }
    NeedSelRow = index;
    $('#gridLocBatInc').datagrid("query", {});
}