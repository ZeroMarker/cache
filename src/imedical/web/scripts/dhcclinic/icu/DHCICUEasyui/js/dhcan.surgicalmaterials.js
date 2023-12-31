$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "描述", width: 240 },
            { field: "Note", title: "备注", width: 240 }
        ]
    ]
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术物品",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: ANCLS.Code.SurMaterials,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindSurgicalMaterials",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
})