var chargeItemLink = {
    datagrid: null
};

$(document).ready(function() {
    var columns = [
        [
            { field: "ChargeItemDesc", title: "记费项目", width: 120 },
            { field: "DataItemDesc", title: "数据项目", width: 160 },
            { field: "AnaestMethodDesc", title: "麻醉方法", width: 160 }
        ]
    ];

    chargeItemLink.datagrid = $("#dataBox");
    chargeItemLink.datagrid.datagrid({
        headerCls: 'panel-header-gray',
        title: "记费项目关联",
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
            QueryName: "FindChargeItemLink",
            Arg1: '',
            Arg2: '',
            ArgCnt: 2
        },
        onSelect: function(index, row) {
            chargeItemLink.form.form("load", row);
        },
        onBeforeLoad: function(param) {
            var filterChargeItem = $("#filterChargeItem").combobox("getValue");
            if ($("#filterChargeItem").combobox("getText") === "") {
                filterChargeItem = "";
            }
            param.Arg1 = '';
            param.Arg2 = filterChargeItem;
            param.ArgCnt = 2;
        },
        onLoadSuccess: function(data) {}
    });

    chargeItemLink.dialog = $("#dataDialog");
    chargeItemLink.dialog.dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-save",
            handler: function() {
                chargeItemLink.form.submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-cancel",
            handler: function() {
                chargeItemLink.dialog.dialog("close");
            }
        }],
        onClose: function() {
            chargeItemLink.form.form("clear");
        },
        onOpen: function() {
            initDefaultValue();
        }
    });

    chargeItemLink.form = $("#dataForm");
    chargeItemLink.form.form({
        onSubmit: function(param) {
            var isValid = $(this).form("validate");
            if (isValid) saveData();
            return isValid;
        },
        success: function(data) {
            console.log("success:" + data);
            chargeItemLink.form.form("clear");
            chargeItemLink.datagrid.datagrid("reload");
            if (chargeItemLink.dialog) {
                chargeItemLink.dialog.dialog("close");
            }
        }
    });

    $("#filterChargeItem,#ChargeItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindChargeItem";
            param.Arg1 = '';
            param.Arg2 = '';
            param.ArgCnt = 2;
        },
        onSelect: function(record) {}
    });

    $("#DataItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataItem";
            param.Arg1 = '';
            param.Arg2 = '';
            param.ArgCnt = 2;
        },
        onSelect: function(record) {}
    });

    $("#AnaestMethod").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = '';
            param.ArgCnt = 1;
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
    if (chargeItemLink.dialog) {
        chargeItemLink.dialog.dialog({
            title: "新增记费项目关联",
            iconCls: "icon-add"
        });
        if (chargeItemLink.form[0].RowId) {
            chargeItemLink.form[0].RowId.value = "";
        }
        chargeItemLink.dialog.dialog("open");
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
    var param = chargeItemLink.form.serializeJson();

    dhccl.saveDatas(ANCSP.DataService, $.extend(param, {
        ClassName: ANCLS.Config.ChargeItemLink,
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
                var msg = dhccl.removeData(ANCLS.Config.ChargeItemLink, rowId);
                dhccl.showMessage(msg, "删除", null, null, function() {
                    chargeItemLink.form.form("clear");
                    chargeItemLink.datagrid.datagrid("reload");
                });
            }
        });
    }
}

/**
 * 查询按钮处理函数
 */
function queryData() {
    chargeItemLink.datagrid.datagrid("reload");
}

/**
 * 判断数据表格是否选中一行
 * @param {string} showPrompt - 未选中行时是否提示
 */
function hasRowSelected(showPrompt) {
    var result = false;
    if (chargeItemLink.datagrid) {
        var selectedRow = chargeItemLink.datagrid.datagrid("getSelected");
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

}

function reloadOptions() {}

function setEquipValue() {}