$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 60 },
            { field: "Description", title: "名称", width: 300 },
            { field: "Spec", title: "规格", width: 100 },
            { field: "UomDesc", title: "单位", width: 60 },
            { field: "StockCatDesc", title: "分类", width: 100 },
            { field: "Alias", title: "别名", width: 120 },
            { field: "Manufacturer", title: "制造商", width: 120 },
            { field: "Vendor", title: "供应商", width: 120 },
            { field: "GeneralDesc", title: "通用名", width: 160 },
            { field: "GeneralAlias", title: "助记码", width: 120 },
            { field: "ChargeItemDesc", title: "收费项目", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "库存项",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: CLCLS.Config.StockItem,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockItem",
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
            param.Arg1 = $("#filterDesc").val();
            param.Arg2 = $("#filterStockCat").combobox("getValue");
            param.ArgCnt = 2;
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

    $("#StockCatDr,#filterStockCat").combobox({
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

    $("#ChargeItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindChargeItem";
            param.Arg1=session.DeptID;
            param.Arg2=param.q?param.q:"";
            param.ArgCnt = 2;
        },
        mode:"remote"
    });
});

function initDefaultValue(dataForm) {

}

function UpdateFormValue(param) {}