$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 240 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "材料供应商",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: CLCLS.Code.Vendor,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindVendor",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
});