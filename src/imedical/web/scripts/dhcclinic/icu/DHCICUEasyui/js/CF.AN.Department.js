function initDeptBox() {
    $("#deptBox").datagrid({
        fit: true,
        title: "科室",
        iconCls: "icon-paper",
        headerCls: "panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        fitColumns: true,
        showPageList: false,
        displayMsg: '',
        toolbar: "#deptTool",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "Description", title: "科室描述", width: 160 }
            ]
        ],
        queryParams: {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocation",
            Arg2: "E^O^AN^OP",
            Arg3: "Y",
            Arg4: session.HospID,
            ArgCnt: 4
        },
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterDept").val();
        },
        onSelect: function(index, row) {
            selectDept(row);
        }
    });

    // 安全组描述回车筛选安全组
    $("#filterDept").bind("keydown", function(e) {
        if (e.keyCode == 13) {
            $("#deptBox").datagrid("reload");
        }
    });
    $("#btnDeptQuery").linkbutton({
        onClick: function() {
            $("#deptBox").datagrid("reload");
        }
    });

    $("#btnSaveDeptSetting").linkbutton({
        onClick: function() {
            saveDeptSettings();
        }
    });
}


function initDeptSettings() {
    $("#OperDept").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "OP^OUTOP^EMOP";
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable: false
    });

    $("#ANDept").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "AN^OUTAN^EMAN";
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable: false
    });

    $("#DSAdmDept").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocation";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = "E^O^AN^OP";
            param.Arg3 = "Y";
            param.Arg4 = session.HospID;
            param.ArgCnt = 4;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $("#OperApp,#AnaApp").combobox({
        valueField: "value",
        textField: "text",
        data: CommonArray.WhetherOrNot,
        editable: false
    });

    $("#ProType").combobox({
        valueField: "value",
        textField: "text",
        data: [{
            value: "NM",
            text: "一般科室",
        }, {
            value: "OP",
            text: "手术室",
        }, {
            value: "AN",
            text: "麻醉科",
        }],
        editable: false
    });
}

function initPage() {
    initDeptBox();
    initDeptSettings();
}

function saveDeptSettings() {
    var selectedDept = $("#deptBox").datagrid("getSelected");
    if (!selectedDept) {
        $.messager.alert("提示", "请先选择科室并进行配置后，再保存！", "warning");
        return;
    }
    var formData = $("#deptForm").serializeJson();
    formData.ClassName = ANCLS.Config.Department;
    formData.HospitalID = session.HospID;
    var jsonStr = dhccl.formatObjects([formData]);
    var saveRet = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonStr
    });
    if (saveRet.indexOf("S^") === 0) {
        $.messager.alert("提示", "科室配置信息保存成功。", "info", function() {
            selectDept(selectedDept);
        });
    } else {
        $.messager.alert("提示", "科室配置信息保存失败，原因：" + saveRet, "error");
    }
}

function selectDept(row) {
    var panel = $("#deptBox").datagrid("getPanel");
    $(panel).panel("setTitle", "科室-" + row.Description);
    $("#deptForm").form("clear");
    $("#DeptID").val(row.RowId);
    var deptSetting = getDeptSetting(row.RowId);
    if (deptSetting) {

        $("#deptForm").form("load", deptSetting);

    }
}

function getDeptSetting(deptId) {
    var deptSettings = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindDepartments",
        Arg1: "",
        Arg2: deptId,
        Arg3: session.HospID,
        ArgCnt: 3
    }, "json");

    var deptSetting = null;
    if (deptSettings && deptSettings.length > 0) {
        deptSetting = deptSettings[0];
    }

    return deptSetting;
}

$(document).ready(initPage);