$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "DeptDesc", title: "科室", width: 160 },
            { field: "OperationDesc", title: "手术", width: 300 },
            { field: "ActiveDate", title: "激活日期", width: 120 },
            { field: "ExpireDate", title: "失效日期", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "科室关联手术",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "CF.AN.DeptOperation",
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindDeptOperations",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: setFormText,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDeptID").combobox("getValue");
            param.ArgCnt = 1;
        }
    });

    $("#filterDeptID,#DeptID").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "INOPDEPT^OUTOPDEPT^EMOPDEPT",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = $("#filterDeptID").combobox("getValue");
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $("#Operation").combobox({
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperation",
        //     Arg1: "QueryFilter",
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });
});

function setFormText(){
    var selectedRow=$("#dataBox").datagrid("getSelected");
    if(selectedRow){
        $("#Operation").combobox("setText",selectedRow.OperationDesc);
    }
}