$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "SurgeonDeptDesc", title: "科室", width: 160 },
            { field: "SurgeonDesc", title: "医生", width: 120 },
            { field: "OperationDesc", title: "手术", width: 300 },
            { field: "ActiveDate", title: "激活日期", width: 120 },
            { field: "ExpireDate", title: "失效日期", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "医生关联手术",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "CF.AN.SurgeonOperation",
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindSurgeonOperations",
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
            param.Arg2 = $("#filterCareProvID").combobox("getValue");
            param.ArgCnt = 2;
        }
    });

    $("#filterDeptID,#SurgeonDept").combobox({
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
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        onChange: function(newValue, oldValue) {
            if ($(this).attr("id") == "filterDeptID") {
                $("#filterCareProvID").combobox("reload");
            } else {
                $("#Surgeon").combobox("reload");
            }
        }
    });

    $("#filterCareProvID,#Surgeon").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = param.q?param.q:"";
            var selector = "#filterDeptID";
            if ($(this).attr("id") == "Surgeon") {
                selector = "#SurgeonDept";
            }
            param.Arg2 = $(selector).combobox("getValue");
            param.ArgCnt = 2;
        },
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindCareProvByLoc",
        //     Arg1: "QueryFilter",
        //     ArgCnt: 2
        // },
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
        $("#Surgeon").combobox("setText",selectedRow.SurgeonDesc);
        $("#Operation").combobox("setText",selectedRow.OperationDesc);
        $("#Surgeon").combobox("reload");
    }
    
}