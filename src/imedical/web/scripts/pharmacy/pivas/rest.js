/**
 * 模块:     排班管理-请假管理-常规设置
 * 编写日期: 2018-07-04
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridRest();
    $('#txtAlias').on('keypress', function(event) {
        if (event.keyCode == "13") {
            Query();
        }
    });
    $('#btnSave').on("click", Save);
    setTimeout(Query, 100);
});

function InitDict() {
    var thisYear = (new Date()).getFullYear();
    var thisMonth = (new Date()).getMonth();
    var years = [
        { RowId: thisYear, Description: thisYear + "年" },
        { RowId: thisYear + 1, Description: thisYear + 1 + "年" }
    ];
    PIVAS.ComboBox.Init({
        Id: "cmbYear",
        data: {
            data: years
        }
    }, {
        editable: false,
        multiple: false,
        mode: "local",
        placeholder: "年份...",
        onSelect: function() {
            Query();
        }
    });
    $("#cmbYear").combobox("setValue", thisYear);
    var months = [];
    for (var i = 1; i < 13; i++) {
        months.push({ RowId: i, Description: i + "月" });
    }
    PIVAS.ComboBox.Init({
        Id: "cmbMonth",
        data: {
            data: months
        }
    }, {
        editable: false,
        multiple: false,
        mode: "local",
        placeholder: "月份...",
        onSelect: function() {
            Query();
        }
    });
    $("#cmbMonth").combobox("setValue", thisMonth);

}

function InitGridRest() {
    var columns = [
        [
            { field: "prId", title: 'prId', hidden: true, width: 100, halign: 'center' },
            { field: "userId", title: '人员Id', width: 100, hidden: true },
            { field: "userCode", title: '人员代码', width: 157 },
            { field: "userName", title: '人员姓名', width: 157 },
            {
                field: "prRestDays",
                title: '固定休假天数',
                width: 157,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false,
                        validType: 'PosNumber'
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        columns: columns,
        toolbar: "#gridRestBar",
        border: false,

        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'prRestDays'
                });
            }
        },
    };
    DHCPHA_HUI_COM.Grid.Init("gridRest", dataGridOption);
}

// 查询
function Query() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("提示", "请先选择年份", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("提示", "请先选择月份", "warning");
        return;
    }
    var alias = $("#txtAlias").val();
    var inputStr = SessionLoc + "^" + year + "^" + month + "^" + alias;
    $("#gridRest").datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Rest',
            QueryName: 'PIVARestUser',
            inputStr: inputStr
        },
    });
}

/// 保存
function Save() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("提示", "请先选择年份", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("提示", "请先选择月份", "warning");
        return;
    }
    var monthDate = year + "-" + month + "-01";
    $('#gridRest').datagrid('endEditing');
    var gridChanges = $('#gridRest').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridRest').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var params = (iData.prId || "") + "^" + SessionLoc + "^" + (iData.userId || "") + "^" + monthDate + "^" + (iData.prRestDays || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Rest", "SaveMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $("#gridRest").datagrid("reload");
}