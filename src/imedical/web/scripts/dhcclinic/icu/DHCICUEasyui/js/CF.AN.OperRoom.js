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
            { field: "OPClientIP", title: "手术室IP", width: 120 },
            { field: "ANClientIP", title: "麻醉科IP", width: 120 },
            { field: "UnavailableReason", title: "不可用原因", width: 160 }
        ]
    ];

    $("#dataBox").datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterOperDept").combobox("getValue");
            param.Arg2 = '';
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
        }
    });

    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术间",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.Location,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindOperRoomConfig",
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
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = "";
            param.Arg2 = "OP^EMOP^OUTOP^AN^EMAN^OUTAN";
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
        }
    });

    $("#UseDeptID").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhccl.bll.admission,
        //     QueryName: "FindLocation",
        //     Arg1: "QueryFilter",
        //     Arg2: "INOPDEPT^EMOPDEPT^OUTOPDEPT",
        //     ArgCnt: 2
        // },
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "INOPDEPT^EMOPDEPT^OUTOPDEPT";
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
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
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperFloor";
            param.Arg1 = session.HospID;
            param.ArgCnt = 1;
        }
    });
});

function initDefaultValue() {
    $("#Active").combobox("setValue", "Y");
}