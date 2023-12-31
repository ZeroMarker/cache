$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 160 },
            { field: "Description", title: "名称", width: 160 },
            { field: "Uom", title: "单位", width: 160 },
            { field: "OptsType", title: "选项类型", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "数据选项",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.DataOptions,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDataOptions",
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
        onBeforeLoad: function(param) {
            param.Arg1 = "";
            param.ArgCnt = 1;
        }
    });
});

function initParam(param) {}