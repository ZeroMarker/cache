$(document).ready(function() {
    var groupBox = $("#groupBox"),
        actionBox = $("#actionBox");
    var operStatusList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.CodeQueries,
        QueryName: "FindOperStatus",
        ArgCnt: 0
    }, "json");

    groupBox.datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 50,
        toolbar: "#groupTool",
        url: ANCSP.DataQuery,
        
        columns: [
            [
                { field: "Description", title: "安全组", width: 160 }
            ]
        ],
        // queryParams: {
        //     ClassName: CLCLS.BLL.Admission,
        //     QueryName: "FindGroup",
        //     ArgCnt: 1
        // },
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindGroup";
            param.Arg1 = $("#filterGroup").val();
            param.ArgCnt = 1;
        },
        onSelect: function(index, row) {
            selectGroup(row);
        }
    });

    actionBox.datagrid({
        fit: true,
        // singleSelect: true,
        rownumbers: true,
        pagination: true,
        checkbox: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#actionTool",
        url: ANCSP.DataQuery,
        checkOnSelect:false,
        selectOnCheck:false,
        columns: [
            [
                { field: "CheckStatus", checkbox: true },
                { field: "Description", title: "操作功能", width: 120 },
                { field: "DataModuleDesc", title: "数据模块", width: 100 },
                { field: "ElementID", title: "关联元素", width: 100 },
                { field: "Icon", title: "图标", width: 120 },
                { field: "ExecFunc", title: "执行函数", width: 160 },
                { field: "LinkModuleDesc", title: "链接模块", width: 100 },
                { field: "LinkModuleURL", title: "链接csp", width: 240 },
                {
                    field: "OperStatusDesc",
                    title: "手术状态",
                    width: 200,
                    editor: {
                        type: "combobox",
                        options: {
                            data: operStatusList,
                            valueField: "RowId",
                            textField: "Description",
                            multiple: true
                        }
                    }
                },
                { field: "PermissionID", title: "授权ID", width: 80, hidden: true }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperActions",
            Arg1: "",
            ArgCnt: 1
        },
        view: groupview,
        groupField: "DataModuleDesc",
        groupFormatter: function(value, rows) {
            return value + " 共" + rows.length + "项功能";
        },
        onAfterEdit: function(index, row, changes) {
            if (changes.OperStatusDesc) {
                var statusArray = changes.OperStatusDesc.split(splitchar.comma),
                    selectStatusText = "";
                for (var i = 0; i < statusArray.length; i++) {
                    var statusId = statusArray[i];
                    for (var j = 0; j < operStatusList.length; j++) {
                        var operStatus = operStatusList[j];
                        if (operStatus.RowId === statusId) {
                            if (selectStatusText != "") selectStatusText += splitchar.comma;
                            selectStatusText += operStatus.Description;
                        }
                    }
                }
                actionBox.datagrid("updateRow", {
                    index: index,
                    row: {
                        OperStatusDesc: selectStatusText,
                        OperStatus: changes.OperStatusDesc
                    }

                });
            }
        },
        onBeginEdit: function(index, row) {
            var editor = actionBox.datagrid("getEditor", { index: index, field: "OperStatusDesc" });
            if (editor && editor.target) {
                if (row.OperStatus && row.OperStatus != "") {
                    var statusArray = row.OperStatus.split(splitchar.comma);
                    $(editor.target).combobox("setValues", statusArray);
                }
            }
        },
        onLoadSuccess: function(data) {

        }
    });

    actionBox.datagrid('enableCellEditing');

    // 安全组描述回车筛选安全组
    $("#filterGroup").bind("keydown", function(e) {
        if (e.keyCode == 13) {
            groupBox.datagrid("reload");
        }
    });

    $("#btnGroupQuery").linkbutton({
        onClick: function() {
            groupBox.datagrid("reload");
        }
    });

    $("#btnSave").linkbutton({
        onClick: function() {
            var checkedRows = actionBox.datagrid("getChecked"),
                rows = actionBox.datagrid("getData").rows,
                actionPermissions = [],
                selectedGroup = groupBox.datagrid("getSelected");
            if (!selectedGroup) return;
            for (var i = 0; i < rows.length; i++) {
                var dataRow = rows[i],
                    active = "Y";
                if (checkedRows.indexOf(dataRow) >= 0) {
                    active = "Y";
                } else if (dataRow.PermissionID != "") {
                    active = "N";
                } else {
                    continue;
                }
                var operStatus = dataRow.OperStatus ? dataRow.OperStatus : "";
                actionPermissions.push({
                    GroupID: selectedGroup.RowId,
                    OperAction: dataRow.RowId,
                    OperStatus: operStatus,
                    RowId: dataRow.PermissionID,
                    Active: active,
                    ClassName: ANCLS.Config.ActionPermission
                });
            }
            dhccl.saveDatas(dhccl.csp.dataListService, {
                jsonData: dhccl.formatObjects(actionPermissions)
            }, function(result) {
                dhccl.showMessage(result, "保存", null, null, function() {
                    selectGroup(selectedGroup);
                });
            });
        }
    })
});

function selectGroup(group) {
    if (group && group.RowId != "") {
        var actionPermissionList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindActionPermission",
            Arg1: group.RowId,
            ArgCnt: 1
        }, "json");
        var operActionList = $("#actionBox").datagrid("getData").rows;
        for (var i = 0; i < operActionList.length; i++) {
            $("#actionBox").datagrid("updateRow", {
                index: i,
                row: {
                    PermissionID: "",
                    OperStatus: "",
                    OperStatusDesc: ""
                }
            });
        }
        $("#actionBox").datagrid("uncheckAll");
        if (actionPermissionList && actionPermissionList.length > 0 && operActionList && operActionList.length > 0) {
            for (var i = 0; i < operActionList.length; i++) {
                var operAction = operActionList[i];
                for (var j = 0; j < actionPermissionList.length; j++) {
                    var actionPermission = actionPermissionList[j];
                    if (actionPermission.OperAction === operAction.RowId) {
                        $("#actionBox").datagrid("updateRow", {
                            index: i,
                            row: {
                                PermissionID: actionPermission.RowId,
                                OperStatus: actionPermission.OperStatus,
                                OperStatusDesc: actionPermission.OperStatusDesc
                            }
                        });
                        // operAction.PermissionID = actionPermission.RowId;
                        // operAction.OperStatus = actionPermission.OperStatus;
                        // operAction.OperStatusDesc = actionPermission.OperStatusDesc;
                        if (actionPermission.Active === "Y") $("#actionBox").datagrid("checkRow", i);
                    }
                }
            }
        }
    }
}