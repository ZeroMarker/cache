/**
 * 初始化查询条件
 */
function initQueryOptions() {

    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#dataBox").treegrid("reload")
        }
    });
}

/**
 * 初始化编辑表单
 */
function initDataForm() {
    $("#ItemType").combobox({
        valueField: "value",
        textField: "text",
        editable: false,
        data: [{
            value: "LIS",
            text: "检验"
        }, {
            value: "PACS",
            text: "检查"
        }, {
            value: "PIS",
            text: "病理"
        }, {
            value: "EMR",
            text: "病历"
        }, {
            value: "AN",
            text: "手麻"
        }]
    });

    $("#ControlType").combobox({
        valueField: "value",
        textField: "text",
        editable: false,
        data: [{
            value: "NONE",
            text: "无"
        }, {
            value: "MSG",
            text: "提示"
        }, {
            value: "FORBID",
            text: "禁止"
        }]
    });
    $("#TriggerTiming").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });
    $("#OperCategoryControl").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        }
    });

    // $("#Operation").combobox({
    //     valueField:"RowId",
    //     textField:"Description",
    //     url:ANCSP.DataQuery,
    //     onBeforeLoad:function(param){
    //         param.ClassName = ANCLS.BLL.Operation;
    //         param.QueryName = "FindOperation";
    //         param.Arg1 = param.q?param.q:"";
    //         param.Arg2 = "";
    //         param.Arg3 = "";
    //         param.ArgCnt = 3;
    //     },
    //     mode:"remote"
    // });
}

/**
 * 初始化数据表格
 */
function initDataBox() {
    $("#dataBox").datagrid({
        border: false,
        title: "",
        columns: [
            [
                { field: "Code", title: "项目代码", width: 120 },
                { field: "Description", title: "项目名称", width: 200 },
                { field: "ItemTypeDesc", title: "项目类型", width: 80 },
                { field: "ControlTypeDesc", title: "控制类型", width: 80 },
                { field: "EmergencyDesc", title: "急诊手术提示", width: 120 },
                { field: "LocalAnesthesiaDesc", title: "择期局麻提示", width: 120 },
                { field: "OperCategoryControlDesc", title: "手术级别控制", width: 120 },
                { field: "TriggerTimingDesc", title: "触发时机", width: 120 }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperRiskControl";
            param.Arg1 = '';
            param.Arg2 = '';
            param.Arg3 = session.HospID;
            param.ArgCnt = 3;
        },
        onSelect: function(rowIndex, rowData) {
            $("#dataForm").form("clear");
            $("#dataForm").form("load", rowData);
            if (rowData.Emergency === "on") {
                $("#Emergency").checkbox("setValue", true);
            } else {
                $("#Emergency").checkbox("setValue", false);
            }
            if (rowData.LocalAnesthesia === "on") {
                $("#LocalAnesthesia").checkbox("setValue", true);
            } else {
                $("#LocalAnesthesia").checkbox("setValue", false);
            }
            // if(rowData.OperDesc){
            //     $("#Operation").combobox("setText",rowData.OperDesc)
            // }
        },
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        pageSize: 200,
        pageList: [50, 100, 200],
        headerCls: "panel-header-gray",
        iconCls: "icon-paper"
    });
}

/**
 * 初始化操作按钮
 */
function initOperActions() {
    $("#btnAdd").linkbutton({
        onClick: function() {
            if ($("#dataForm").form("validate")) {
                let formData = $("#dataForm").serializeJson();
                if (formData) {
                    formData.ClassName = ANCLS.Code.OperRiskControl;
                    setCheckValue(formData);
                    formData.RowId = "";
                    formData.HospitalID = session.HospID;
                    let formDatas = [formData];
                    let formDataStr = dhccl.formatObjects(formDatas);
                    dhccl.saveDatas(ANCSP.DataListService, {
                        jsonData: formDataStr
                    }, function(data) {
                        if (data.indexOf("S^") === 0) {
                            $("#dataBox").datagrid("reload");
                            reloadQueryOptions();
                        } else {
                            if (data.indexOf("键不唯一") > 0) {
                                $.messager.alert("提示", "新增失败，原因：代码重复");
                            }
							else if (data.indexOf("Key not unique") > 0) {
                                $.messager.alert("提示", "新增失败，原因：代码重复");
                            } else {
                                $.messager.alert("提示", "新增失败，原因：" + data);
                            }
                        }
                    });
                }
            }
        }
    });

    $("#btnEdit").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#dataBox"), true) && $("#dataForm").form("validate")) {
                let formData = $("#dataForm").serializeJson();
                if (formData) {
                    formData.ClassName = ANCLS.Code.OperRiskControl;
                    setCheckValue(formData);
                    formData.HospitalID = session.HospID;
                    let formDatas = [formData];
                    let formDataStr = dhccl.formatObjects(formDatas);
                    dhccl.saveDatas(ANCSP.DataListService, {
                        jsonData: formDataStr
                    }, function(data) {
                        if (data.indexOf("S^") === 0) {
                            $("#dataBox").datagrid("reload");
                            reloadQueryOptions();
                        } else {
                            $.messager.alert("提示", "修改失败，原因：" + data);
                        }
                    });
                }
            }
        }
    });

    $("#btnDel").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#dataBox"), true)) {
                $.messager.confirm("提示", "确认删除？", function(r) {
                    if (r) {
                        let formData = $("#dataForm").serializeJson();
                        let ret = dhccl.removeData(ANCLS.Code.OperRiskControl, formData.RowId);
                        if (ret.indexOf("S^") === 0) {
                            $("#dataBox").datagrid("reload");
                            reloadQueryOptions();
                        } else {
                            $.messager.alert("提示", "删除失败，原因：" + data);
                        }
                    }
                });

            }
        }
    });

}

function initPage() {
    initQueryOptions();
    initDataBox();
    initDataForm();
    initOperActions();
}

function reloadQueryOptions() {
    $("#dataForm").form("clear");
}

function setCheckValue(formData) {
    if (formData) {
        let emergencyCheck = $("#Emergency").checkbox("getValue");
        let localAnaCheck = $("#LocalAnesthesia").checkbox("getValue");
        let OperCategoryControl = $("#OperCategoryControl").combobox("getValue");
        if (emergencyCheck) {
            formData.Emergency = "on";
        } else {
            formData.Emergency = "off";
        }
        if (localAnaCheck) {
            formData.LocalAnesthesia = "on";
        } else {
            formData.LocalAnesthesia = "off";
        }
        if (OperCategoryControl === "") {
            formData.OperCategoryControl = "";
        }
    }
}

$(document).ready(initPage);