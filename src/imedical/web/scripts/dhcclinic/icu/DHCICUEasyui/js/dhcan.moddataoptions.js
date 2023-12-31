$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 160 },
            { field: "Description", title: "名称", width: 160 },
            { field: "OptsType", title: "选项类型", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "模块数据选项",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.ModDataOptions,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindModDataOptions",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        onSubmitCallBack: initParam,
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        pageSize: 10,
        onBeforeLoad: function(param) {
            param.Arg1 = dhccl.getQueryString("relatedModuleID");
            param.ArgCnt = 1;
        }
    });
});

function initParam(param) {
    param.DataModule = dhccl.getQueryString("relatedModuleID");
}