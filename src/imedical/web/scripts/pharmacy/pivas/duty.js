/**
 * 模块:     排班管理-岗位维护
 * 编写日期: 2018-06-27
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function() {
    InitDict();
    InitGridDuty();
    InitGridDutyUser();
    $('#btnAdd').on("click", function() {
        var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
        if (pivaLocId == "") {
            $.messager.alert("提示", "请先选择配液中心", "warning");
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
        placeholder: "配液中心...",
        width: 275
    });
}

function InitGridDuty() {
    var columns = [
        [
            { field: "pdId", title: 'pdId', hidden: true, width: 100 },
            {
                field: "pdLocDesc",
                title: '配液中心描述',
                width: 100,
                hidden: true
            },
            {
                field: "pdLocId",
                title: '配液中心',
                width: 150,
                hidden: true
            },
            {
                field: "pdCode",
                title: '岗位代码',
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
                title: '岗位名称',
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
                title: '岗位简称',
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
                title: '休假天数</br>最小值',
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
                title: '休假天数</br>最大值',
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
                title: '双休日</br>必休',
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
                title: '节假日</br>必休',
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
                title: '节假日</br>倒休',
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
                title: '寒暑假</br>可休',
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
                title: '自由岗</br>标志',
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
                title: '人员工号',
                width: 125
            },
            {
                field: "userName",
                title: '人员姓名',
                width: 125
            },
            {
                field: "colorFlag",
                title: '颜色标识',
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
    // 人员排序,已关联的显示在最上,没有岗位在中间(灰色),其他岗位在最后(浅红)
    DHCPHA_HUI_COM.Grid.Init("gridDutyUser", dataGridOption);
}
// 查询
function Query() {
    $("#gridDuty").datagrid("reload");
}
// 查询明细
function QueryDutyUser() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    var pdId = gridSelect.pdId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
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
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $('#gridDuty').datagrid('endEditing');
    var gridChanges = $('#gridDuty').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
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
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridDuty').datagrid("reload");
}

// 保存岗位人员关联
function SaveDutyUser() {
    var gridSelect = $('#gridDuty').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要关联人员的岗位", "warning");
        return;
    }
    var gridDUSelect = $('#gridDutyUser').datagrid("getSelected");
    if (gridDUSelect == null) {
        $.messager.alert("提示", "请先选择需要岗位的关联人员", "warning");
        return;
    }
    var pdId = gridSelect.pdId || "";
    if (pdId == "") {
        $.messager.alert("提示", "请先保存岗位", "warning");
        return;
    }
    var pduId = gridDUSelect.pduId;
    var userId = gridDUSelect.userId;
    var params = pduId + "^" + pdId + "^" + userId;
    // 验证
    var checkRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "CheckDutyUser", params);
    if (checkRet.split("^")[0] < 0) {
        $.messager.confirm('确认对话框', checkRet.split("^")[1] + "</br>是否继续关联?", function(r) {
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
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pdId = gridSelect.pdId || "";
            var rowIndex = $('#gridDuty').datagrid('getRowIndex', gridSelect);
            if (pdId != "") {
                // 验证
                var checkRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "CheckDuty", pdId);
                if (checkRet.split("^")[0] < 0) {
                    $.messager.confirm('确认对话框', checkRet.split("^")[1] + "</br>是否继续删除?", function(r) {
                        if (r) {
                            var delRet = tkMakeServerCall("web.DHCSTPIVAS.Duty", "Delete", pdId);
                            var delRetArr = delRet.split("^");
                            var delValue = delRetArr[0];
                            if (delValue < 0) {
                                $.messager.alert("提示", delRetArr[1], "warning");
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
                        $.messager.alert("提示", delRetArr[1], "warning");
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