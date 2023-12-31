$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 240 },
            { field: "BGColor", title: "背景颜色", width: 240 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        border:false,
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.OperStatus,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindOperStatus",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });

    dataForm.initDataForm();

    $("#dataBox").datagrid({
        border:false
    });
});