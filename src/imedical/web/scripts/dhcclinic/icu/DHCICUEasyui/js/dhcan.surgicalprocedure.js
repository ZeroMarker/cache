$(document).ready(function() {
    var columns = [
        [{
                field: "PatBaseInfo",
                title: "患者",
                width: 160
            },
            { field: "RegNo", title: "登记号", width: 80 },
            { field: "AppDeptDesc", title: "申请科室", width: 100 },
            { field: "PrevDiagnosisDesc", title: "术前诊断", width: 160 },
            { field: "OperationDesc", title: "手术名称", width: 160 },
            { field: "SurgeonDesc", title: "手术医生", width: 100 },
            { field: "OperRoomDesc", title: "手术间", width: 80 },
            { field: "OperSeq", title: "台次", width: 80 },
            { field: "StatusDesc", title: "状态", width: 80 },
            { field: "ExecDT", title: "时间", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术过程",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.SurgicalProcedure",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindSurgicalProcedures",
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
            param.Arg1 = $("#filterRegNo").textbox("getValue");
            param.Arg2 = $("#filterOperDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.ArgCnt = 3;
        }
    });

    $("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindOperRoom",
            Arg1: session.DeptID,
            ArgCnt: 1
        }
    });

    $("#Status").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindOperStatus",
            ArgCnt: 0
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            dataBox.datagrid("reload");
        }
    });

    $("#filterRegNo").textbox("textbox").bind("keydown", function(e) {
        if (e.keyCode == 13) {
            dataBox.datagrid("reload");
            var regNo = $("#filterRegNo").textbox("getValue"),
                today = getCurrentDate(),
                currentTime = getCurrentTime(),
                data = getDatas(dhccl.csp.methodService, {
                    ClassName: "DHCAN.BLL.SurgicalProcedure",
                    MethodName: "GetNextProcedure",
                    Arg1: regNo,
                    Arg2: $("#filterOperDate").datebox("getValue"),
                    Arg3: session.DeptID,
                    ArgCnt: 3
                }, "json", false);
            if (data) {
                dataForm.form("load", data);
                $("#RowId").val("");
                $("#ExecDate").datebox("setValue", today);
                $("#ExecTime").timespinner("setValue", currentTime);
                if (dataDialog) {
                    initialForm();
                    dataDialog.dialog({
                        title: "新增",
                        iconCls: "icon-add"
                    });
                    dataDialog.dialog("open")
                }
            }
        }
    });

    $("#filterRegNo").textbox("textbox").focus();
});

function initDefaultValue() {
    $("#UpdateUserID").val(session.UserID);
}