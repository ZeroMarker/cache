$(document).ready(function() {
    var columns = [
        [
            { field: "DataField", title: "数据字段", width: 120 },
            { field: "TestCode", title: "检验代码", width: 120 },
            { field: "ActiveDesc", title: "激活状态", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "检验标准码对照项目",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.TestCode,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindTestStandardCode",
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