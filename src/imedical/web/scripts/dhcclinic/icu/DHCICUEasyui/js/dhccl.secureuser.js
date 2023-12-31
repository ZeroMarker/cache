$(document).ready(function() {
    var columns = [
        [
            { field: "Account", title: "用户工号", width: 120 },
            { field: "FullName", title: "用户姓名", width: 180 },
            { field: "DefLocDesc", title: "默认科室", width: 160 },
            { field: "CASignDesc", title: "CA签名", width: 120 },
            { field: "AccountSignStartDate", title: "手签起始", width: 160 },
            { field: "AccountSignEndDate", title: "手签结束", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "用户信息",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: CLCLS.Config.SecureUser,
        queryType: CLCLS.BLL.SecureUser,
        queryName: "FindSecureUser",
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
            param.Arg1 = $("#filterDept").combobox("getValue");
            param.Arg2=$("#filterAccount").val();
            param.Arg3=$("#filterName").val();
            param.ArgCnt = 3;
        }
    });

    $("#filterDept,#DefLoc").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindAnaestType",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationList";
            param.Arg1=(param.q?param.q:"");
            param.Arg2="";
            param.ArgCnt = 2;
        }
    });
});

function initDefaultValue(dataForm) {
    // if (dataForm.hasRowSelected(false) === false) {
    //     $("#Active").combobox("setValue", "Y");
    // }

}