$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 160 },
            { field: "OperFloorDesc", title: "手术楼层", width: 160 },
            { field: "OperDeptDesc", title: "手术科室", width: 160 },
            { field: "UseDeptDesc", title: "使用科室", width: 160 },
            { field: "ActiveDesc", title: "是否激活", width: 80 },
            { field: "LocTypeDesc", title: "类型", width: 80 },
            { field: "UnavailableReason", title: "不可用原因", width: 200 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术间",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.Location,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindOperRoom",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterOperDept").combobox("getValue");
            param.ArgCnt = 1;
        }
    });

    $("#filterOperDept,#OperDeptID").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindLocation",
        //     Arg1: "",
        //     Arg2: "OP^EMOP^OUTOP",
        //     ArgCnt: 2
        // }
        onBeforeLoad: function(param) {
            param.ClassName = dhccl.bll.admission;
            param.QueryName = "FindLocation";
            param.Arg1 = "";
            param.Arg2 = "OP^EMOP^OUTOP";
            param.ArgCnt = 2;
        }
    });

    $("#UseDeptID").combobox({
        valueField: "RowId",
        textField: "Code",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "INOPDEPT^EMOPDEPT^OUTOPDEPT",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = dhccl.bll.admission;
            param.QueryName = "FindLocation";
            param.Arg1 = "QueryFilter";
            param.Arg2 = "INOPDEPT^EMOPDEPT^OUTOPDEPT";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

    $("#OperFloor").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindOperFloor",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperFloor";
            param.ArgCnt = 0;
        }
    });
});

function initDefaultValue() {
    $("#Active").combobox("setValue", "Y");
}