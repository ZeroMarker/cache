/**
 * 初始化编辑表单
 */
function initDataForm() {
    $("#OperDept,#OutOperDept,#EMOperDept,#IVTOperDept").combobox({
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

    $("#ANDept,#OutANDept,#EMANDept,#IVTANDept").combobox({
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
}

/**
 * 初始化数据表格
 */
function initDataBox() {
    $("#dataBox").datagrid({
        columns: [
            [
                { field: "HospDesc", title: "院区", width: 200 },
                { field: "OperDeptDesc", title: "住院手术室", width: 120 },
                { field: "OutOperDeptDesc", title: "门诊手术室", width: 120 },
                { field: "EMOperDeptDesc", title: "急诊手术室", width: 120 },
                { field: "IVTOperDeptDesc", title: "介入手术室", width: 120 },
                { field: "ANDeptDesc", title: "住院麻醉科", width: 120 },
                { field: "OutANDeptDesc", title: "门诊麻醉科", width: 120 },
                { field: "EMANDeptDesc", title: "急诊麻醉科", width: 120 },
                { field: "IVTANDeptDesc", title: "介入麻醉科", width: 120 }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindHospitals";
            param.Arg1 = session.HospID;
            param.ArgCnt = 1;
        },
        onSelect: function(rowIndex, rowData) {
            $("#dataForm").form("load", rowData);
        },
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        pageSize: 200,
        pageList: [50, 100, 200],
        headerCls: "panel-header-gray"
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
                    formData.RowId = "";
                    formData.ClassName = ANCLS.Config.Hospital;
                    formData.HospitalID = session.HospID;
                    let formDatas = [formData];
                    let formDataStr = dhccl.formatObjects(formDatas);
                    dhccl.saveDatas(ANCSP.DataListService, {
                        jsonData: formDataStr
                    }, function(data) {
                        if (data.indexOf("S^") === 0) {
                            $("#dataBox").datagrid("reload");
                        } else {
                            $.messager.alert("提示", "新增失败，原因：" + data);
                        }
                    });
                }
            }
        }
    });

    $("#btnEdit").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#dataBox"), true) && $("#dataForm").form("validate")) {
                var formData = $("#dataForm").serializeJson();
                if (formData) {
                    formData.ClassName = ANCLS.Config.Hospital;
                    formData.HospitalID = session.HospID;
                    var formDatas = [formData];
                    var formDataStr = dhccl.formatObjects(formDatas);
                    dhccl.saveDatas(ANCSP.DataListService, {
                        jsonData: formDataStr
                    }, function(data) {
                        if (data.indexOf("S^") === 0) {
                            $("#dataBox").datagrid("reload");
                            $("#dataForm").form("clear");
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
                let formData = $("#dataForm").serializeJson();
                let ret = dhccl.removeData(ANCLS.Config.Hospital, formData.RowId);
                if (ret.indexOf("S^") === 0) {
                    $("#dataBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", "删除失败，原因：" + data);
                }
            }
        }
    });
}

function initPage() {
    initDataBox();
    initDataForm();
    initOperActions();
}

$(document).ready(initPage);