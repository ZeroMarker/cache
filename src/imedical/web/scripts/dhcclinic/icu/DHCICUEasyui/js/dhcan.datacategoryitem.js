$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "ItemDesc", title: "数据项", width: 120 },
            { field: "ItemCode", title: "数据项代码", width: 200 },
            { field: "SeqNo", title: "排序号", width: 80 },
            { field: "CategoryDesc", title: "数据分类", width: 160 },
            { field: "CategoryCode", title: "分类代码", width: 200 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "数据分类关联数据项",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.Code.DataCateItem",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindCategoryItem",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();

    $("#dataBox").datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDesc").val();
            param.Arg2 = $("#filterDataCategory").combobox("getValue");
            param.ArgCnt = 2;
        },
        view: groupview,
        groupField: "CategoryDesc",
        groupFormatter: function(value, rows) {
            return value + " 共" + rows.length + "项数据项";
        }
    });

    $("#filterDataCategory,#DataCategory").combobox({
        valueField: "RowId",
        textField: "DescCode",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindDataCategory",
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataCategory";
        }
    });

    $("#DataItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindDataItem",
        //     Arg1: "",
        //     Arg2: "",
        //     ArgCnt: 2
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataItem";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });
});