$(document).ready(function() {
    $("#dataBox").treegrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "Description", title: "名称", width: 240 },
            { field: "Code", title: "代码", width: 240 },
            { field: "MainCategoryDesc", title: "主分类", width: 240 }
        ]
    ];
    var dataForm = new TreeForm({
        treegrid: $("#dataBox"),
        treefield: {
            id: "RowId",
            tree: "Description"
        },
        gridColumns: columns,
        gridTitle: "数据项分类",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.Code.DataCategory",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindDataCategory",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: initQuery,
        openCallBack: null,
        closeCallBack: null,
        delCallBack: initQuery
    });
    dataForm.initDataForm();

    $("#MainCategory").combobox({
        valueField: "RowId",
        textField: "DescCode",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindDataCategory"
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataCategory";
        }
    });
});

function initQuery() {
    $("#MainCategory").combobox("reload");
}