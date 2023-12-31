var deptEquip = {
    datagrid: null
};

$(document).ready(function() {
    var columns = [
        [
            { field: "EquipCode", title: "代码", width: 120 },
            { field: "EquipDesc", title: "名称", width: 160 },
            { field: "EquipMFRDesc", title: "品牌", width: 160 },
            { field: "EquipModelDesc", title: "型号", width: 160 },
            { field: "EquipTypeDesc", title: "类型", width: 80 },
            { field: "SerialNumber", title: "序列号", width: 160 },
            { field: "LocDesc", title: "位置", width: 160 },
            {
                field: "BarCode",
                title: "条码",
                width: 300,
                formatter: function(value, row, index) {
                    var imgID = "barcode" + row.EquipCode;
                    var ret = "<img id='" + imgID + "' class='barcode' data-code='" + row.EquipCode + "' ";
                    ret += "data-desc='" + row.EquipCode + " " + row.EquipDesc + " " + row.LocDesc + "' />"
                    return ret;
                }
            }
        ]
    ];

    deptEquip.datagrid = $("#dataBox");
    deptEquip.datagrid.datagrid({
        headerCls: 'panel-header-gray',
        title: "麻醉科设备登记",
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
            QueryName: "FindDeptEquipAN",
            ArgCnt: 0
        },
        onSelect: function(index, row) {
            deptEquip.form.form("load", row);
        },
        onBeforeLoad: function(param) {
            var filterRoom = $("#filterRoom").combobox("getValue");
            if ($("#filterRoom").combobox("getText") === "") {
                filterRoom = "";
            }
            var filterEquipType = $("#filterEquipType").combobox("getValue");
            if ($("#filterEquipType").combobox("getText") === "") {
                filterEquipType = "";
            }
            param.Arg1 = session.DeptID;
            param.Arg2 = filterRoom;
            param.Arg3 = filterEquipType;
            param.ArgCnt = 3;
        },
        view: groupview,
        groupField: "LocDesc",
        groupFormatter: function(value, rows) {
            return value + " 共" + rows.length + "台设备";
        },
        onLoadSuccess: function(data) {
            $(".barcode").each(function(index, el) {
                var equipCode = $(this).attr("data-code");
                JsBarcode("#" + $(this).attr("id"), equipCode, {
                    height: 40,
                    text: $(this).attr("data-desc"),
                    fontSize: 12,
                    format: "CODE128B"
                });
            });
        }
    });

    deptEquip.dialog = $("#dataDialog");
    deptEquip.dialog.dialog({
        buttons: [{
            text: "保存",
            iconCls: "icon-save",
            handler: function() {
                deptEquip.form.submit();
            }
        }, {
            text: "取消",
            iconCls: "icon-cancel",
            handler: function() {
                deptEquip.dialog.dialog("close");
            }
        }],
        onClose: function() {
            deptEquip.form.form("clear");
        },
        onOpen: function() {
            initDefaultValue();
        }
    });

    deptEquip.form = $("#dataForm");
    deptEquip.form.form({
        onSubmit: function(param) {
            var isValid = $(this).form("validate");
            if (isValid) saveData();
            return isValid;
        },
        success: function(data) {
            console.log("success:" + data);
            deptEquip.form.form("clear");
            deptEquip.datagrid.datagrid("reload");
            if (deptEquip.dialog) {
                deptEquip.dialog.dialog("close");
            }
        }
    });

    $("#filterEquipType").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEquipType";
            param.ArgCnt = 0;
        }
    });

    $("#filterRoom,#Location").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2 = "R^B";
            param.ArgCnt = 2;
        }
    });

    $("#EquipType").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEquipType";
            param.ArgCnt = 0;
        },
        onSelect: function(record) {
            var typeModels = [];
            var models = deptEquip.equipModels;
            var length = models.length;
            for (var i = 0; i < length; i++) {
                var model = models[i];
                if (model.EquipType === record.RowId) typeModels.push(model);
            }
            $("#EquipModel").combobox('loadData', typeModels);
        }
    });

    $("#EquipModel").combobox({
        valueField: "RowId",
        textField: "Description"
    });

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindEquipModel",
        ArgCnt: 0
    }, "json", true, function(data) {
        deptEquip.equipModels = data;
        $("#EquipModel").combobox('loadData', deptEquip.equipModels);
    });
});

/**
 * 新增按钮处理函数
 * @param {DataForm} dataForm - 数据表单对象
 * @author chenchangqing 20170811
 */
function addData() {
    if (deptEquip.dialog) {
        deptEquip.dialog.dialog({
            title: "新增麻醉科设备",
            iconCls: "icon-add"
        });
        if (deptEquip.form[0].RowId) {
            deptEquip.form[0].RowId.value = "";
        }
        deptEquip.dialog.dialog("open");
    }
}

/**
 * 修改按钮处理函数
 */
function editData() {
    if (hasRowSelected(true)) {
        if (deptEquip.dialog) {
            deptEquip.dialog.dialog({
                title: "修改设备信息",
                iconCls: "icon-edit"
            });
            var selectedRow = deptEquip.datagrid.datagrid("getSelected");
            deptEquip.form.form("load", selectedRow);
            deptEquip.dialog.dialog("open")
        } else {
            deptEquip.form.submit();
        }
    }
}

/**
 * 保存数据处理函数
 */
function saveData() {
    var param = deptEquip.form.serializeJson();
    var guid = dhccl.guid();
    var savingDatas = [{
            RowId: param.RowId,
            ClassName: ANCLS.Config.DeptEquip,
            Dept: param.Dept,
            EquipCode: param.EquipCode,
            EquipDesc: param.EquipDesc,
            EquipType: param.EquipType,
            EquipModel: param.EquipModel,
            SerialNumber: param.SerialNumber,
            "Location": param.Location,
            Guid: guid
        },
        {
            RowId: param.CollectionRowId,
            ClassName: ANCLS.Config.EquipCollection,
            TcpipAddress: param.TcpipAddress,
            PhysicalPort: param.PhysicalPort,
            Program: param.Program,
            ComPort: param.ComPort || "",
            DeptEquipGuid: guid
        }
    ];

    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.DeptEquip,
        MethodName: "SaveDeptEquip",
        Arg1: dhccl.formatObjects(savingDatas),
        ArgCnt: 1
    }, function(data) {

    });

}

/**
 * 删除按钮处理函数
 */
function delData() {
    if (hasRowSelected(true)) {
        $.messager.confirm("确认", "你的操作不可逆转，是否删除该数据记录？", function(result) {
            if (result) {
                var selectedRow = deptEquip.datagrid.datagrid("getSelected");
                var rowId = selectedRow["RowId"];
                var msg = dhccl.removeData(ANCLS.Config.DeptEquip, rowId);
                dhccl.showMessage(msg, "删除", null, null, function() {
                    deptEquip.form.form("clear");
                    deptEquip.datagrid.datagrid("reload");
                });
            }
        });
    }
}

/**
 * 查询按钮处理函数
 */
function queryData() {
    deptEquip.datagrid.datagrid("reload");
}

/**
 * 打印按钮处理函数
 */
function printBarCode() {
    if (dhccl.hasRowSelected(deptEquip.datagrid, true)) {
        var selectedRow = deptEquip.datagrid.datagrid("getSelected");
        var selector = "#barcode" + selectedRow.EquipCode;
        var image = $(selector).prop("outerHTML");
        var lodop = getLodop();
        lodop.SET_PRINT_PAGESIZE(1, 0, 0, PrintSetting.DeptEquip.BarCodePaper);
        // lodop.ADD_PRINT_IMAGE(0, 0, "100%", "100%", image);
        lodop.ADD_PRINT_BARCODE("2mm", "4mm", "52mm", "21mm", "128B", selectedRow.EquipCode);
        lodop.PREVIEW();
    }
}

/**
 * 判断数据表格是否选中一行
 * @param {string} showPrompt - 未选中行时是否提示
 */
function hasRowSelected(showPrompt) {
    var result = false;
    if (deptEquip.datagrid) {
        var selectedRow = deptEquip.datagrid.datagrid("getSelected");
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