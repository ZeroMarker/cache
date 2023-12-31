$(document).ready(function() {
    var groupBox = $("#groupBox"),
        moduleBox = $("#moduleBox");
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
        queryParams: {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindGroup",
            ArgCnt: 1
        },
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterGroup").val();
        },
        onSelect: function(index, row) {
            selectGroup(row, moduleBox);
        }
    });

    moduleBox.treegrid({
        idField: "RowId",
        treeField: "Description",
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        checkbox: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#moduleTool",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "Description", title: "名称", width: 280 },
                { field: "URL", title: "链接页面", width: 280 },
                { field: "Icon", title: "图标", width: 160 },
                { field: "ParentModuleDesc", title: "父模块", width: 160 },
                { field: "MenuModule", title: "是否菜单", width: 100 },
                { field: "ActiveDesc", title: "是否激活", width: 100 },
                { field: "PermissionID", title: "授权ID", width: 80, hidden: true }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDataModule",
            Arg1: "",
            Arg2: "",
            ArgCnt: 2
        }
    });

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
            var selectedGroup = groupBox.datagrid("getSelected"),
                modules = moduleBox.treegrid("getData"),
                permissionList = [];
            if (!selectedGroup) {
                $.messager.alert("提示", "未选择安全组，请先选择安全组并授权后保存！", "warning");
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
                    permissionList.push({
                        RowId: permissionID,
                        GroupID: selectedGroup.RowId,
                        DataModule: module.RowId,
                        ClassName: ANCLS.Config.ModPermission,
                        Active: "Y"
                    });
                }
                if (!isChecked && permissionID != "") {
                    permissionList.push({
                        RowId: permissionID,
                        GroupID: selectedGroup.RowId,
                        DataModule: module.RowId,
                        ClassName: ANCLS.Config.ModPermission,
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
                        dhccl.showMessage(data, "保存", null, null, function() {

                        });
                    }
                })
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

function selectGroup(row, moduleBox) {
    // 加载已授权的模块信息
    $.ajax({
        url: ANCSP.DataQuery,
        async: false,
        data: {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindModulePermission",
            Arg1: row.RowId,
            Arg2: "Y",
            ArgCnt: 2
        },
        type: "post",
        dataType: "json",
        success: function(data) {
            var moduleList = [];
            // 选择已授权的模块
            $.each(data, function(index, item) {
                moduleBox.treegrid("checkNode", item.DataModule)
                if ($.inArray(item.DataModule, moduleList) < 0) {
                    moduleList.push(item.DataModule);
                }
                var currentRow = moduleBox.treegrid("find", item.DataModule);
                currentRow.PermissionID = item.RowId;
            });
            // 未授权的模块去除选择(如果已经选择的话)
            var checkedRows = moduleBox.treegrid("getCheckedNodes");
            if (checkedRows && checkedRows.length > 0) {
                $.each(checkedRows, function(index, checkedRow) {
                    if ($.inArray(checkedRow.RowId, moduleList) < 0) {
                        moduleBox.treegrid("uncheckNode", checkedRow.RowId);
                    }
                });
            }
        }
    });
}