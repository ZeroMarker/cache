var chargeItem = {
    datagrid: null
};

$(document).ready(function() {
    var columns = [
        [
            { field: "DeptDesc", title: "科室", width: 120 },
            { field: "Code", title: "代码", width: 80 },
            { field: "Description", title: "描述", width: 160 },
            { field: "Alias", title: "简拼", width: 80 },
            { field: "Price", title: "单价", width: 80 },
            { field: "UnitDesc", title: "单位", width: 80 },
            { field: "Specification", title: "规格", width: 80 },
            { field: "Batch", title: "批号", width: 80 },
            { field: "IsActive", title: "是否有效", width: 80 },
            { field: "ChargeCategoryDesc", title: "分类", width: 100 }
        ]
    ];

    chargeItem.datagrid = $("#dataBox");
    chargeItem.datagrid.datagrid({
        headerCls: 'panel-header-gray',
        title: "收费项目列表",
        columns: columns,
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageList: [10, 20, 30, 40, 50, 100, 200],
        pageSize: 200,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindChargeItem",
            Arg1: "",
            Arg2: "",
            ArgCnt: 2
        },
        onSelect: function(index, row) {
            chargeItem.form.form("load", row);
        },
        onBeforeLoad: function(param) {
            param.Arg1 = session.DeptID;
            param.Arg2 = $("#filterDesc").val();
            param.ArgCnt = 2;
        },
        // view: groupview,
        // groupField: "DeptDesc",
        // groupFormatter: function(value, rows) {
        //     return value + " 共" + rows.length + "项";
        // },
        onLoadSuccess: function(data) {}
    });

    chargeItem.dialog = $("#dataDialog");
    chargeItem.dialog.dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-save",
            handler: function() {
                chargeItem.form.submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-cancel",
            handler: function() {
                chargeItem.dialog.dialog("close");
            }
        }],
        onClose: function() {
            chargeItem.form.form("clear");
        },
        onOpen: function() {
            initDefaultValue();
        }
    });

    chargeItem.form = $("#dataForm");
    chargeItem.form.form({
        onSubmit: function(param) {
            param.Dept=session.DeptID;
            var isValid = $(this).form("validate");
            if (isValid) saveData();
            return isValid;
        },
        success: function(data) {
            console.log("success:" + data);
            chargeItem.form.form("clear");
            chargeItem.datagrid.datagrid("reload");
            if (chargeItem.dialog) {
                chargeItem.dialog.dialog("close");
            }
        }
    });

    $("#ChargeCategory").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindChargeCategory";
            param.ArgCnt = 0;
        },
        onSelect: function(record) {}
    });

    $("#Unit").combobox({
        valueField: "RowId",
        // textField: "Description",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            // param.ClassName = ANCLS.BLL.CodeQueries;
            param.ClassName=CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        },
        onSelect: function(record) {}
    });

    $("#DoseUnit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindUom";
            param.Arg1 = '';
            param.Arg2 = 'D';
            param.ArgCnt = 2;
        },
        onSelect: function(record) {}
    });
});

/**
 * 新增按钮处理函数
 * @param {DataForm} dataForm - 数据表单对象
 * @author chenchangqing 20170811
 */
function addData() {
    if (chargeItem.dialog) {
        chargeItem.dialog.dialog({
            title: "新增记费项目",
            iconCls: "icon-add"
        });
        if (chargeItem.form[0].RowId) {
            chargeItem.form[0].RowId.value = "";
        }
        chargeItem.dialog.dialog("open");
    }
}

/**
 * 修改按钮处理函数
 */
function editData() {
    if (hasRowSelected(true)) {
        if (chargeItem.dialog) {
            chargeItem.dialog.dialog({
                title: "修改记费项目",
                iconCls: "icon-edit"
            });
            var selectedRow = chargeItem.datagrid.datagrid("getSelected");
            chargeItem.form.form("load", selectedRow);
            chargeItem.dialog.dialog("open")
        } else {
            chargeItem.form.submit();
        }
    }
}

/**
 * 保存数据处理函数
 */
function saveData() {
    var param = chargeItem.form.serializeJson();
    if (!param.RowId) param.CreateUser = session.UserID;
    param.Dept=session.DeptID;

    dhccl.saveDatas(ANCSP.DataService, $.extend(param, {
        ClassName: ANCLS.Config.ChargeItem,
        UpdateUser: session.UserID
    }), function(data) {

    });

}

/**
 * 删除按钮处理函数
 */
function delData() {
    if (hasRowSelected(true)) {
        $.messager.confirm("确认", "你的操作不可逆转，是否删除该数据记录？", function(result) {
            if (result) {
                var selectedRow = chargeItem.datagrid.datagrid("getSelected");
                var rowId = selectedRow["RowId"];
                var msg = dhccl.removeData(ANCLS.Config.ChargeItem, rowId);
                dhccl.showMessage(msg, "删除", null, null, function() {
                    chargeItem.form.form("clear");
                    chargeItem.datagrid.datagrid("reload");
                });
            }
        });
    }
}

/**
 * 查询按钮处理函数
 */
function queryData() {
    chargeItem.datagrid.datagrid("reload");
}

/**
 * 判断数据表格是否选中一行
 * @param {string} showPrompt - 未选中行时是否提示
 */
function hasRowSelected(showPrompt) {
    var result = false;
    if (chargeItem.datagrid) {
        var selectedRow = chargeItem.datagrid.datagrid("getSelected");
        if (selectedRow) {
            result = true;
        } else {
            result = false;
        }
    }
    if (!result && showPrompt) {
        $.messager.alert("提示", "请先选择一行再进行操作！", "warning");
    }
    return result;
}

function initDefaultValue(dataForm) {
    $("#Dept").val(session.DeptID);
}

function reloadOptions() {}

function setEquipValue() {}