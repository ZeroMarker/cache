$(document).ready(function() {
    var groupBox = $("#groupBox"),
        statusBox = $("#statusBox"),
        moduleBox = $("#moduleBox");

    var selectGroup, groupId;
    var selectStatus, statusId;
    //安全组
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
                { field: "RowId", title: "RowId", width: 60, hidden: true },
                { field: "Description", title: "安全组", width: 160 }
            ]
        ],
        queryParams: {
            ClassName: dhccl.bll.admission,
            QueryName: "FindGroup",
            ArgCnt: 1
        },
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterGroup").textbox("getValue");
        },
        onSelect: function(index, row) {
            selectGroup = groupBox.datagrid("getSelected");
            if (selectGroup) {
                groupId = selectGroup.RowId;
                selectGroupModule(groupId, moduleBox);
            }
        }
    });
    //手术状态
    statusBox.datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 50,
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "Description", title: "手术状态", width: 160 },

            ]
        ],
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindOperStatus",
            Arg1: "",
            ArgCnt: 1
        },
        onSelect: function(index, row) {
            if (groupId) {
                selectStatus = statusBox.datagrid("getSelected");
                if (selectStatus) {
                    statusId = selectStatus.RowId;
                    selectGroupAndStatus(groupId, row, moduleBox);
                }
            } else {
                $.messager.alert("提示", "请先选择安全组！", "warning");
                statusBox.datagrid("clearSelections");
                return;
            }
        }
    });
    //模块
    moduleBox.treegrid({
        idField: "RowId",
        treeField: "Description",
        fit: true,
        checkbox: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#moduleTool",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "Description", title: "操作功能", width: 160 },
                { field: "DataModuleDesc", title: "数据模块", width: 100 },
                { field: "ElementID", title: "关联元素", width: 100 },
                { field: "Icon", title: "图标", width: 100 },
                { field: "ExecFunc", title: "执行函数", width: 100 },
                { field: "LinkModuleDesc", title: "链接模块", width: 100 },
                { field: "LinkModuleURL", title: "链接csp", width: 200 },
                { field: "PermissionID", title: "授权ID", width: 80, hidden: true }
            ]
        ],
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindOperActions",
            Arg1: "",
            ArgCnt: 1
        }

    });
    //安全组筛选
    $("#filterGroup").textbox("textbox").bind("keydown", function(e) {
        if (e.keyCode == 13) {
            groupBox.datagrid("reload");
            statusBox.datagrid("clearSelections");
        }
    });
    $("#btnGroupQuery").linkbutton({
        onClick: function() {
            groupBox.datagrid("reload");
            statusBox.datagrid("clearSelections");
        }
    });

    $("#btnSave").linkbutton({
        onClick: function() {
            var modules = moduleBox.treegrid("getData"),
                permissionList = [];
            if (!selectGroup) {
                $.messager.alert("提示", "未选择安全组，请选择安全组并选择授权模块再保存！", "warning");
                return;
            }
            getAllModules(modules);
            $.each(systemModules, function(index, module) {
                var isChecked = module.checked;
                if (isChecked == false && module.checkState == "indeterminate") {
                    isChecked = true;
                }
                var permissionID = "";
                if (module.PermissionID && module.PermissionID > 0) {
                    permissionID = module.PermissionID;
                }
                if (isChecked) {
                    if (selectStatus) {
                        permissionList.push({
                            RowId: permissionID,
                            GroupID: selectGroup.RowId,
                            OperStatus: selectStatus.RowId,
                            OperAction: module.RowId,
                            ClassName: "DHCAN.ActionPermission",
                            Active: "Y"
                        });
                    } else {
                        permissionList.push({
                            RowId: permissionID,
                            GroupID: selectGroup.RowId,
                            OperStatus: "",
                            OperAction: module.RowId,
                            ClassName: "DHCAN.ActionPermission",
                            Active: "Y"
                        });
                    }
                }
                if (!isChecked && permissionID != "") {
                    permissionList.push({
                        RowId: permissionID,
                        GroupID: selectGroup.RowId,
                        OperStatus: selectStatus.RowId,
                        OperActive: module.RowId,
                        ClassName: "DHCAN.ActionPermission",
                        Active: "N"
                    });
                }

            });
            if (permissionList.length > 0) {
                var jsonData = dhccl.formatObjects(permissionList);
                $.ajax({
                    url: dhccl.csp.dataListService,
                    data: {
                        jsonData: jsonData
                    },
                    type: "post",
                    async: false,
                    success: function(data) {
                        dhccl.showMessage(data, "保存", null, null, function() {});
                    }
                });
            }
        }
    });

});

// 递归获取全部模块节点信息
var systemModules = new Array();

function getAllModules(rootModules) {
    $.each(rootModules, function(index, rootModule) {
        if ($.inArray(rootModule, systemModules) < 0) {
            systemModules.push(rootModule);
        }
        if (rootModule.children && rootModule.children.length > 0) {
            getAllModules(rootModule.children);
        }
    });
}
//获取安全组和手术状态获取权限
function selectGroupAndStatus(groupId, row, moduleBox) {
    $.ajax({
        url: ANCSP.DataQuery,
        async: false,
        data: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindActionPermission",
            Arg1: groupId,
            Arg2: row.RowId,
            Arg3: "Y",
            ArgCnt: 3
        },
        type: "post",
        dataType: "json",
        success: function(data) {
            var moduleList = [];
            $.each(data, function(index, item) {
                moduleBox.treegrid("checkNode", item.OperAction);
                if ($.inArray(item.OperAction, moduleList) < 0) {
                    moduleList.push(item.OperAction);
                }
                var currentRow = moduleBox.treegrid("find", item.OperAction);
                currentRow.PermissionID = item.RowId;
            });
            var checkedRows = moduleBox.treegrid("getCheckedNodes");
            if (checkedRows && checkedRows.length > 0) {
                $.each(checkedRows, function(index, checkedRow) {
                    if ($.inArray(checkedRow.RowId, moduleList) < 0) {
                        moduleBox.treegrid("uncheckNode", checkedRow.RowId);
                    }
                })
            }
        }
    });
}
//获取安全组权限
function selectGroupModule(groupId, moduleBox) {
    $.ajax({
        url: ANCSP.DataQuery,
        async: false,
        data: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindActionPermission",
            Arg1: groupId,
            Arg2: "",
            Arg3: "Y",
            ArgCnt: 3
        },
        type: "post",
        dataType: "json",
        success: function(data) {
            var moduleList = [];
            $.each(data, function(index, item) {
                moduleBox.treegrid("checkNode", item.OperAction);
                if ($.inArray(item.OperAction, moduleList) < 0) {
                    moduleList.push(item.OperAction);
                }
                var currentRow = moduleBox.treegrid("find", item.OperAction);
                currentRow.PermissionID = item.RowId;
            });
            var checkedRows = moduleBox.treegrid("getCheckedNodes");
            if (checkedRows && checkedRows.length > 0) {
                $.each(checkedRows, function(index, checkedRow) {
                    if ($.inArray(checkedRow.RowId, moduleList) < 0) {
                        moduleBox.treegrid("uncheckNode", checkedRow.RowId);
                    }
                })
            }
        }
    });
}