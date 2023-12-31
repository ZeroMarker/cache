var editRow={
    index:-1,
    data:null
};
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
        title:"安全组",
	    iconCls:"icon-paper",
	    headerCls:"panel-header-gray",
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
            //selectGroup(row);
            $("#actionBox").datagrid("reload");
        }
    });

    actionBox.datagrid({
        fit: true,
        // singleSelect: true,
        rownumbers: true,
        // pagination: true,
        checkbox: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#actionTool",
        title:"操作功能",
	    iconCls:"icon-paper",
	    headerCls:"panel-header-gray",
        url: ANCSP.DataQuery,
        checkOnSelect: false,
        selectOnCheck: false,
        columns: [
            [
                { field: "CheckStatus", checkbox: true },
                { field: "Description", title: "操作功能", width: 120 },
                { field: "DataModuleDesc", title: "数据模块", width: 100 },
                { field: "ElementID", title: "关联元素", width: 100 },
                { field: "Icon", title: "图标", width: 120 },
                { field: "ExecFunc", title: "执行函数", width: 160 },
                { field: "LinkModuleDesc", title: "链接模块", width: 100,hidden:true },
                { field: "LinkModuleURL", title: "链接csp", width: 240,hidden:true },
                {
                    field: "OperStatus",
                    title: "手术状态",
                    width: 200,
                    formatter:function(value,row,index){
                        return row.OperStatusDesc;
                    },
                    editor: {
                        type: "combobox",
                        options: {
                            data: operStatusList,
                            valueField: "RowId",
                            textField: "Description",
                            multiple: true,
                            editable:false,
                            rowStyle:"checkbox",
                            onHidePanel:function(){
                                var text=$(this).combobox("getText");
                                editRow.data.OperStatusDesc=text;
                            }
                        }
                    }
                },
                { field: "PermissionID", title: "授权ID", width: 80, hidden: true }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindActionPermissionNew",
            Arg1: "",
            ArgCnt: 1
        },
        view: groupview,
        groupField: "DataModuleDesc",
        groupFormatter: function(value, rows) {
            return value + " 共" + rows.length + "项功能";
        },
        onBeforeLoad:function(param){
            var selectedGroup=$("#groupBox").datagrid("getSelected");
            if(selectedGroup){
                param.Arg1=selectedGroup.RowId;
            }
        },
        onLoadSuccess:function(data){
            var selectedGroup=$("#groupBox").datagrid("getSelected");
            if(selectedGroup){
                selectGroup(selectedGroup);
            }
        },
        onAfterEdit: function(index, row, changes) {
            // if (changes.OperStatusDesc) {
            //     var statusArray = changes.OperStatusDesc.split(splitchar.comma),
            //         selectStatusText = "";
            //     for (var i = 0; i < statusArray.length; i++) {
            //         var statusId = statusArray[i];
            //         for (var j = 0; j < operStatusList.length; j++) {
            //             var operStatus = operStatusList[j];
            //             if (operStatus.RowId === statusId) {
            //                 if (selectStatusText != "") selectStatusText += splitchar.comma;
            //                 selectStatusText += operStatus.Description;
            //             }
            //         }
            //     }
            //     actionBox.datagrid("updateRow", {
            //         index: index,
            //         row: {
            //             OperStatusDesc: selectStatusText,
            //             OperStatus: changes.OperStatusDesc
            //         }

            //     });
            // }else{
            //     actionBox.datagrid("updateRow", {
            //         index: index,
            //         row: {
            //             OperStatusDesc: "",
            //             OperStatus: ""
            //         }

            //     });
            // }
        },
        onBeginEdit: function(index, row) {
            editRow.data=row;
            editRow.index=index;
            // var editor = actionBox.datagrid("getEditor", { index: index, field: "OperStatusDesc" });
            // if (editor && editor.target) {
            //     if (row.OperStatus && row.OperStatus != "") {
            //         var statusArray = row.OperStatus.split(splitchar.comma);
            //         $(editor.target).combobox("setValues", statusArray);
            //     }
            // }
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
            endEdit();
            var checkedRows = actionBox.datagrid("getChecked"),
                rows = actionBox.datagrid("getRows"),
                actionPermissions = [],
                selectedGroup = groupBox.datagrid("getSelected");
            if (!selectedGroup) return;
            for (var i = 0; i < checkedRows.length; i++) {
                var dataRow = checkedRows[i];
                var operStatus = dataRow.OperStatus ? dataRow.OperStatus : "";
                actionPermissions.push({
                    GroupID: selectedGroup.RowId,
                    OperAction: dataRow.OperAction,
                    OperStatus: operStatus,
                    RowId: "",
                    Active: "Y",
                    ClassName: ANCLS.Config.ActionPermission
                });
            }
            var dataPara=dhccl.formatObjects(actionPermissions);
            var saveRet=dhccl.runServerMethodNormal(ANCLS.BLL.Permission,"SaveActionPermissions",selectedGroup.RowId,dataPara);
            if(saveRet.indexOf("S^")===0){
                $.messager.popover({msg:"保存授权数据成功",type:"success",timeout:1000});
                // selectGroup(selectedGroup);
                $("#actionBox").datagrid("reload");
            }else{
                $.messager.alert("提示","保存授权数据失败，原因："+saveRet,"error");
            }
            // dhccl.saveDatas(ANCSP.DataListService, {
            //     jsonData: dhccl.formatObjects(actionPermissions),
            //     ClassName:ANCLS.BLL.Permission,
            //     MethodName:"SaveActionPermissions"
            // }, function(result) {
            //     dhccl.showMessage(result, "保存", null, null, function() {
            //         selectGroup(selectedGroup);
            //     });
            // });
        }
    });
});

function endEdit(){
    var actionRows=$("#actionBox").datagrid("getRows");
    if(actionRows && actionRows.length>0){
        for (var i = 0; i < actionRows.length; i++) {
            var actionRow = actionRows[i];
            $("#actionBox").datagrid("endEdit",i);
        }
    }
}

function selectGroup(group) {
    if (group && group.RowId != "") {
        var actionPermissionList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindActionPermission",
            Arg1: group.RowId,
            ArgCnt: 1
        }, "json");
        var operActionList = $("#actionBox").datagrid("getRows");
        $("#actionBox").datagrid("uncheckAll");
        for (var i = 0; i < operActionList.length; i++) {
            var operAction=operActionList[i];
            if(operAction.Active==="Y") $("#actionBox").datagrid("checkRow", i);
        }
        
    }
}