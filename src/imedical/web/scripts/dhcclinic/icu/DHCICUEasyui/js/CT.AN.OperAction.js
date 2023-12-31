$(document).ready(function() {

    $("#filterDataModule,#DataModule,#LinkModule").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindDataModule",
        //     Arg1: "",
        //     Arg2: "",
        //     Arg3: "",
        //     ArgCnt: 3
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.Arg3 = "";
            param.ArgCnt = 3;
        }
    });
    let moduleId=dhccl.getQueryString("moduleId");
    if(moduleId!="")
    {
        $("#filterDataModule").combobox("setValue",moduleId)
    }
    
    var columns = [
        [
            { field: "Code", title: "代码", width: 200 },
            { field: "Description", title: "名称", width: 160 },
            { field: "DataModuleDesc", title: "模块", width: 160 },
            { field: "ElementID", title: "元素ID", width: 120 },
            { field: "Icon", title: "图标", width: 120 },
            { field: "ExecFunc", title: "执行函数", width: 160 },
            { field: "Container", title: "容器元素", width: 120 },
            { field: "Seq", title: "序号", width: 100 },
            { field: "LinkModuleDesc", title: "链接模块", width: 200 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns, 
        //gridTitle: "手术麻醉操作功能",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.OperAction,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindOperActions",
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

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDataModule").combobox("getValue");
            param.ArgCnt = 1;
        },
        view: groupview,
        border:false,
        groupField: "DataModuleDesc",
        groupFormatter: function(value, rows) {
            return value + " 共" + rows.length + "项功能";
        }
    });
});