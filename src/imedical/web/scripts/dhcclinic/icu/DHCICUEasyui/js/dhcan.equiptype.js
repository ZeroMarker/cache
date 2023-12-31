$(function() {
    var columns = [
        [
            { field: "RowId", title: "RowId", width: 120, hidden: true },
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "描述", width: 240 }
        ]
    ]
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "设备类型",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: ANCLS.Code.EquipType,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindEquipType",
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