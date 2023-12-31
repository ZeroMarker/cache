$(document).ready(function() {
    var columns = [
        [
            { field: "ReasonTypeDesc", title: "类型", width: 120 },
            { field: "Description", title: "原因", width: 240 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术麻醉原因",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.Reason,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindReason",
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