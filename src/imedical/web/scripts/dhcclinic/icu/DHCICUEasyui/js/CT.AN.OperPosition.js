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
        gridTitle: "手术体位",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.OperPosition,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindOperPosition",
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
        onBeforeLoad:function(param){
            param.Arg1="N";
            param.ArgCnt=1;
        }
    })
});