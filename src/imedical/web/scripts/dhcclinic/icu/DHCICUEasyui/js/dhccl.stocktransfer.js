$(document).ready(function() {
    $("#startDate,#endDate").datebox("setValue", (new Date()).format("yyyy-MM-dd"));
    var columns = [
        [
            { field: "StockItemDesc", title: "耗材名称", width: 240 },
            { field: "StockItemSpec", title: "规格", width: 80 },
            { field: "Qty", title: "数量", width: 60 },
            { field: "UomDesc", title: "单位", width: 80 },
            { field: "BatchNo", title: "批号", width: 120 },
            { field: "Manufacturer", title: "制造商", width: 160 },
            { field: "Vendor", title: "供应商", width: 160 },
            { field: "StockCatDesc", title: "耗材类型", width: 100 },
            { field: "FullName", title: "入库人", width: 100 },
            { field: "TransferDT", title: "入库时间", width: 160 },
            { field: "BarCode", title: "条码号", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "耗材入库",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: CLCLS.Model.StockTransfer,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockTransfer",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        onSubmitCallBack: UpdateFormValue,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        headerCls: "panel-header",
        onBeforeLoad: function(param) {
            param.Arg1 = session.DeptID;
            param.Arg2 = $("#filterStockItem").combobox("getValue");
            param.Arg3 = $("#startDate").datebox("getValue");
            param.Arg4 = $("#endDate").datebox("getValue");
            param.ArgCnt = 4;
        }
    });

    $("#UomDr").combobox({
        valueField: "RowId",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        }
    });

    $("#StockCatDr").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindStockCat";
            param.ArgCnt = 0;
        }
    });

    $("#ManufacturerDr").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindManufacturer";
            param.ArgCnt = 0;
        }
    });

    $("#VendorDr").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindVendor";
            param.ArgCnt = 0;
        }
    });

    $("#StockItemDr,#filterStockItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindStockItem";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode:"remote"
    });
});

function initDefaultValue(dataForm) {

}

function UpdateFormValue(param) {
    var transferDT = $("#TransferDT").datetimebox("getValue");
    var transferDTArr = transferDT.split(" ");
    param.TransferDate = transferDTArr[0];
    param.TransferTime = transferDTArr[1];
    param.ReceiveLocationDr = session.DeptID;
    param.ReceiveUserDr = session.UserID;

}