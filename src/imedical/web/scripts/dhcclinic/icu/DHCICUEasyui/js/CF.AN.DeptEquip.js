$(document).ready(function() {
    var columns = [
        [
            { field: "EquipCode", title: "代码", width: 120 },
            { field: "EquipDesc", title: "名称", width: 160 },
            { field: "ManufacturerDesc", title: "品牌", width: 160 },
            { field: "EquipModelDesc", title: "型号", width: 160 },
            { field: "EquipTypeDesc", title: "类型", width: 80 },
            { field: "SerialNumber", title: "序列号", width: 160 },
            { field: "LocDesc", title: "位置", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术室设备登记",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.DeptEquip,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindDeptEquip",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        onSubmitCallBack: setEquipValue,
        submitCallBack: reloadOptions,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
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
        title: "",
        border: false
    });

    $("#filterEquipType,#EquipType").combobox({
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
            param.Arg1 = session.DeptID;
            param.Arg2 = "";
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
        }
    });

    $("#EquipModel").combogrid({
        // valueField: "RowId",
        // textField: "Description",
        // url: ANCSP.DataQuery,
        // onBeforeLoad: function(param) {
        //     param.ClassName = ANCLS.BLL.CodeQueries;
        //     param.QueryName = "FindEquipModel";
        //     param.ArgCnt = 0;
        // }
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEquipModel",
                param.Arg1 = "",
                param.Arg2 = param.q ? param.q : "",
                param.ArgCnt = 2;
        },
        panelWidth: 450,
        idField: "RowId",
        textField: "Description",
        columns: [
            [
                { field: "Description", title: "名称", width: 200 },
                { field: "EQTypeDesc", title: "类型", width: 120 },
                { field: "ManufacturerDesc", title: "品牌", width: 120 }
            ]
        ],
        mode: "remote"
    });

    $("#Manufacturer").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEquipMFR";
            param.ArgCnt = 0;
        }
    });

    $("#btnPrintBarCode").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataForm.datagrid, true)) {
                var selectedRow = dataForm.datagrid.datagrid("getSelected");
                var selector = "#barcode" + selectedRow.EquipCode;
                var image = $(selector).prop("outerHTML");
                var lodop = getLodop();
                lodop.PRINT_INIT("EquipBarCode");
                let ratio = window.devicePixelRatio || 1;
                radio = 1;
                let paperWidth = (ratio * 80) + "mm",
                    paperHeight = "80mm";
                lodop.SET_PRINT_PAGESIZE(1, 800, 800, "");
                //lodop.SET_PRINTER_INDEX(PrintSetting.DeptEquip.BarCodePrinter);
                lodop.ADD_PRINT_BARCODE(5, 5, 96, 96, "QRCode", selectedRow.EquipCode);
                lodop.ADD_PRINT_TEXT(105, 30, "100%", 15, selectedRow.EquipCode);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
                lodop.ADD_PRINT_TEXT(5, 105, "100%", 15, "名  称：" + selectedRow.EquipDesc);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
                lodop.ADD_PRINT_TEXT(30, 105, "100%", 15, "品  牌：" + selectedRow.ManufacturerDesc);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
                lodop.ADD_PRINT_TEXT(55, 105, "100%", 15, "型  号：" + selectedRow.EquipModelDesc);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
                lodop.ADD_PRINT_TEXT(80, 105, "100%", 15, "序列号：" + selectedRow.SerialNumber);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
                lodop.ADD_PRINT_TEXT(105, 105, "100%", 15, "位  置：" + selectedRow.LocDesc);
                lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
                lodop.PREVIEW();
            }
        }
    });
});

function initDefaultValue(dataForm) {
    $("#Dept").val(session.DeptID);
}

function reloadOptions() {}

function setEquipValue() {}