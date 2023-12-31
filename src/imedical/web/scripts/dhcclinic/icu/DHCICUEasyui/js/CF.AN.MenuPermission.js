$(document).ready(function() {
    var groupBox = $("#groupBox"),
        moduleBox = $("#moduleBox");
    groupBox.datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        title:"安全组",
	    iconCls:"icon-paper",
	    headerCls:"panel-header-gray",
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
        title:"菜单",
	    iconCls:"icon-paper",
	    headerCls:"panel-header-gray",
        pagination: true,
        checkbox: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#moduleTool",
        url: ANCSP.DataQuery,
        // view:groupview,
        // groupField:"MenuDesc",
        // groupFormatter:function(value,rows){
        //     return value;
        // },
        columns: [
            [
                { field: "Description", title: "名称", width: 280 },
                { field: "Url", title: "链接页面", width: 280 },
                { field: "MenuDesc", title: "菜单", width: 160 },
                { field: "PermissionID", title: "授权ID", width: 160,hidden:true },
                { field: "Active", title: "激活状态", width: 160,hidden:true },
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindMenuItems",
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
                        RoleGroup: selectedGroup.RowId,
                        MenuItem: module.RowId,
                        ClassName: ANCLS.Config.MenuPermission,
                        Active: "Y"
                    });
                }
                if (!isChecked && permissionID != "") {
                    permissionList.push({
                        RowId: permissionID,
                        RoleGroup: selectedGroup.RowId,
                        MenuItem: module.RowId,
                        ClassName: ANCLS.Config.MenuPermission,
                        Active: "N"
                    });
                }
            });
            if (permissionList.length > 0) {
                var jsonData = dhccl.formatObjects(permissionList);
                $.ajax({
                    url: ANCSP.DataListService,
                    data: {
                        jsonData: jsonData
                    },
                    type: "post",

                    async: false,
                    success: function(data) {
                        dhccl.showMessage(data, "保存", null, null, function() {
                            var groupRow=$("#groupBox").datagrid("getSelected");
                            selectGroup(groupRow,moduleBox);
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
            QueryName: "FindMenuPermissions",
            Arg1: row.RowId,
            ArgCnt: 1
        },
        type: "post",
        dataType: "json",
        success: function(data) {
            checkMenuItems(data,moduleBox);
        }
    });
}

function checkMenuItems(menuPermissions,moduleBox){
    var modules = moduleBox.treegrid("getData");
    getAllModules(modules);
    for(var i=0;i<systemModules.length;i++){
        var menuItem=systemModules[i];
        menuItem.PermissionID="";
    }
    var moduleList = [];
    // 选择已授权的模块
    $.each(menuPermissions, function(index, item) {
        if(item.Active==="Y"){
            moduleBox.treegrid("checkNode", item.MenuItem);
        }else{
            moduleBox.treegrid("uncheckNode", item.MenuItem);
        }
        
        if ($.inArray(item.MenuItem, moduleList) < 0) {
            moduleList.push(item.MenuItem);
        }
        var currentRow = moduleBox.treegrid("find", item.MenuItem);
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