$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "LocalDesc", title: "名称", width: 120 },
            { field: "ForeignDesc", title: "英文简称", width: 120 },
            { field: "Alias", title: "助记码", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "单位",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: CLCLS.Config.Uom,
        queryType: CLCLS.BLL.StockManager,
        queryName: "FindUom",
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