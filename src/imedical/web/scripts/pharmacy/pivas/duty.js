/**
 * ģ��:     �Ű����-��λά��
 * ��д����: 2018-06-27
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function() {
    InitDict();
    InitGridDuty();
    InitGridDutyUser();
    $('#btnAdd').on("click", function() {
        var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
        if (pivaLocId == "") {
            $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
            return
        }
        $("#gridDuty").datagrid('addNewRow', {
            editField: 'pdCode'
        });
        $("#gridDutyUser").datagrid("clear");
    });
    $('#txtAlias').on('keypress', function(event) {
        if (event.keyCode == "13") {
            QueryDutyUser();
        }
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
            $('#gridDuty').datagrid("query", { inputStr: selData.RowId });
        },
        editable: false,
        placeholder: "��Һ����...",
        width: 275
    });
}

function InitGridDuty() {
    var columns = [
        [
            { field: "pdId", title: 'pdId', hidden: true, width: 100 },
            {
                field: "pdLocDesc",
                title: '��Һ��������',
                width: 100,
                hidden: true
            },
            {
                field: "pdLocId",
                title: '��Һ����',
                width: 150,
                hidden: true
            },
            {
                field: "pdCode",
                title: '��λ����',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: "pdDesc",
                title: '��λ����',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: "pdShortDesc",
                title: '��λ���',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: "pdMinDays",
                title: '�ݼ�����</br>��Сֵ',
                halign: 'center',
                align: 'right',
                width: 65,
                hidden:true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false,
                        validType: 'PosNumber'
                    }
                }
            },
            {
                field: "pdMaxDays",
                title: '�ݼ�����</br>���ֵ',
                halign: 'center',
                align: 'right',
                width: 65,
                hidden:true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false,
                        validType: 'PosNumber'
                    }
                }
            },
            {
                field: "pdWeekEndFlag",
                title: '˫����</br>����',
                halign: 'center',
                align: 'center',
                width: 65,
                editor: {
                    type: 'icheckbox',
                    options: {
                        required: false,
                        on: 'Y',
                        off: 'N'
                    }
                }
            },
            {
                field: "pdFestivalFlag",
                title: '�ڼ���</br>����',
                halign: 'center',
                align: 'center',
                width: 65,
                editor: {
                    type: 'icheckbox',
                    options: {
                        required: false,
                        on: 'Y',
                        off: 'N'
                    }
                }
            },
            {
                field: "pdFestExFlag",
                title: '�ڼ���</br>����',
                halign: 'center',
                align: 'center',
                width: 65,
                editor: {
                    type: 'icheckbox',
                    options: {
                        required: false,
                        on: 'Y',
                        off: 'N'
                    }
                }
            },
            {
                field: "pdHolidayFlag",
                title: '�����</br>����',
                halign: 'center',
                align: 'center',
                width: 65,
                editor: {
                    type: 'icheckbox',
                    options: {
                        required: false,
                        on: 'Y',
                        off: 'N'
                    }
                }
            },
            {
                field: "pdFreeFlag",
                title: '���ɸ�</br>��־',
                halign: 'center',
                align: 'center',
                width: 65,
                editor: {
                    type: 'icheckbox',
                    options: {
                        required: false,
                        on: 'Y',
                        off: 'N'
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Duty',
            QueryName: 'PIVADuty'
        },
        columns: columns,
        toolbar: "#gridDutyBar",
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                $("#gridDutyUser").datagrid("clear");
                var pdId = rowData.pdId || "";
                if (pdId != "") {
                    QueryDutyUser();
                }
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'pdCode'
            });
        },
        onLoadSuccess: function() {
            $("#gridDutyUser").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDuty", dataGridOption);
}

function InitGridDutyUser() {
    var columns = [
        [
            { field: "pduId", title: 'pduId', hidden: true, width: 100 },
            {
                field: "userId",
                title: 'userId',
                width: 125,
                hidden: true
            },
            {
                field: "userCode",
                title: '��Ա����',
                width: 125
            },
            {
                field: "userName",
                title: '��Ա����',
                width: 125
            },
            {
                field: "colorFlag",
                title: '��ɫ��ʶ',
                width: 125,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Duty',
            QueryName: 'PIVADutyUser'
        },
        fitColumns: true,
        toolbar: "#gridDutyUserBar",
        columns: columns,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {
            SaveDutyUser();
        },
        rowStyler: function(rowIndex, rowData) {
            var colorFlag = rowData.colorFlag;
            if (colorFlag == 1) {
                //return 'background-color:transparent;';
            } else if (colorFlag == 2) {
                return 'background-color:#e2ffde;color:#3c763d;';
            } else if (colorFlag == 3) {
                return 'background-color:#fff3dd;color:#ff3d2c;';
            }
        }
    };
    // ��Ա����,�ѹ�������ʾ������,û�и�λ���м�(��ɫ),������λ�����(ǳ��)
    DHCPHA_HUI_COM.Grid.Init("gridDutyUser", dataGridOption);
}
// ��ѯ
function Query() {
    $("#gridDuty").datagrid("reload");
}
// ��ѯ��ϸ
function QueryDutyUser() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    var pdId = gridSelect.pdId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $("#gridDutyUser").datagrid('query', {
        inputStr: pivaLocId + "^" + pdId + "^" + $("#txtAlias").val()
    });
    $("#txtAlias").val("");
}

function Save() {
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $('#gridDuty').datagrid('endEditing');
    var gridChanges = $('#gridDuty').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridDuty').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var params = (iData.pdId || "") + "^" + pivaLocId + "^" + (iData.pdCode || "") + "^" + (iData.pdDesc || "") + "^" + (iData.pdShortDesc || "") + "^" +
            (iData.pdMinDays || "") + "^" + (iData.pdMaxDays || "") + "^" + (iData.pdWeekEndFlag || "") + "^" + (iData.pdFestivalFlag || "") + "^" + (iData.pdFestExFlag || "") + "^" +
            (iData.pdHolidayFlag || "") + "^" +(iData.pdFreeFlag || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "SaveMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridDuty').datagrid("reload");
}

// �����λ��Ա����
function SaveDutyUser() {
    var gridSelect = $('#gridDuty').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ������Ա�ĸ�λ", "warning");
        return;
    }
    var gridDUSelect = $('#gridDutyUser').datagrid("getSelected");
    if (gridDUSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ��λ�Ĺ�����Ա", "warning");
        return;
    }
    var pdId = gridSelect.pdId || "";
    if (pdId == "") {
        $.messager.alert("��ʾ", "���ȱ����λ", "warning");
        return;
    }
    var pduId = gridDUSelect.pduId;
    var userId = gridDUSelect.userId;
    var params = pduId + "^" + pdId + "^" + userId;
    // ��֤
    var checkRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "CheckDutyUser", params);
    if (checkRet.split("^")[0] < 0) {
        $.messager.confirm('ȷ�϶Ի���', checkRet.split("^")[1] + "</br>�Ƿ��������?", function(r) {
            if (r) {
                var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "SaveDutyUser", params);
                $('#gridDutyUser').datagrid("reload");
            }
        });
    } else {
        var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "SaveDutyUser", params);
        $('#gridDutyUser').datagrid("reload");
    }
}

function Delete() {
    var gridSelect = $('#gridDuty').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pdId = gridSelect.pdId || "";
            var rowIndex = $('#gridDuty').datagrid('getRowIndex', gridSelect);
            if (pdId != "") {
                // ��֤
                var checkRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "CheckDuty", pdId);
                if (checkRet.split("^")[0] < 0) {
                    $.messager.confirm('ȷ�϶Ի���', checkRet.split("^")[1] + "</br>�Ƿ����ɾ��?", function(r) {
                        if (r) {
                            var delRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "Delete", pdId);
                            var delRetArr = delRet.split("^");
                            var delValue = delRetArr[0];
                            if (delValue < 0) {
                                $.messager.alert("��ʾ", delRetArr[1], "warning");
                                return;
                            }
                            $('#gridDuty').datagrid("reload");
                        }
                    });
                } else {
                    var delRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "Delete", pdId);
                    var delRetArr = delRet.split("^");
                    var delValue = delRetArr[0];
                    if (delValue < 0) {
                        $.messager.alert("��ʾ", delRetArr[1], "warning");
                        return;
                    }
                    $('#gridDuty').datagrid("reload");
                }
            } else {
                $('#gridDuty').datagrid("deleteRow", rowIndex);
            }
        }
    })
}