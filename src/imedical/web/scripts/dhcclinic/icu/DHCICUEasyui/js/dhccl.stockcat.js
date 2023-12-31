$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 240 },
            { field: "TypeDesc", title: "类型", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "库存项分类",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: CLCLS.Code.StockCat,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindStockCat",
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