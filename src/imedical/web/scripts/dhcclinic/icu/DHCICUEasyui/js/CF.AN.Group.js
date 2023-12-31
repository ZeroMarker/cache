function initGroupBox(){
    $("#groupBox").datagrid({
        fit: true,
        title:"安全组",
	    iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        fitColumns:true,
        showPageList:false,
        displayMsg:'',
        toolbar: "#groupTool",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "Description", title: "安全组描述", width: 160 }
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
            selectGroup(row);
        }
    });

    // 安全组描述回车筛选安全组
    $("#filterGroup").bind("keydown", function(e) {
        if (e.keyCode == 13) {
            $("#groupBox").datagrid("reload");
        }
    });
    $("#btnGroupQuery").linkbutton({
        onClick: function() {
            $("#groupBox").datagrid("reload");
        }
    });
}

function initMenuItems(){
    $("#menuBox").treegrid({
        idField: "RowId",
        treeField: "Description",
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        border:false,
        bodyCls:"panel-header-gray",
        checkbox: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#menuTool",
        url: ANCSP.DataQuery,
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
}

function initOperActions(){
    $("#actionBox").datagrid({
        fit: true,
        border:false,
        rownumbers: true,
        bodyCls:"panel-header-gray",
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: "#actionTool",
        url: ANCSP.DataQuery,
        checkOnSelect: false,
        selectOnCheck: false,
        columns: [
            [
                { field: "CheckStatus", checkbox: true },
                { field: "Description", title: "操作功能", width: 180 },
                { field: "DataModuleDesc", title: "数据模块", width: 150 },
                { field: "ElementID", title: "关联元素", width: 150 },
                { field: "Icon", title: "图标", width: 180 },
                { field: "ExecFunc", title: "执行函数", width: 250 },
                { field: "LinkModuleDesc", title: "链接模块", width: 100,hidden:true },
                { field: "LinkModuleURL", title: "链接csp", width: 240,hidden:true },
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
        }
    });

}

function initGroupSettings(){
    $(".whetherOrNot").combobox({
        valueField:"value",
        textField:"text",
        data:CommonArray.WhetherOrNot
    });

    $("#SignCareProvType").combobox({
        valueField:"value",
        textField:"text",
        data:[{
            value:"SGN",
            text:"手术医生"
        },{
            value:"OPN",
            text:"手术护士"
        },{
            value:"AND",
            text:"麻醉医生"
        },{
            value:"ANN",
            text:"麻醉护士"
        },{
            value:"PUD",
            text:"PACU医生"
        },{
            value:"PUN",
            text:"PACU护士"
        },{
            value:"WDN",
            text:"住院护士"
        }]
    });

    $("#DefOperStatus,#CanArrangeStatus").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindOperStatus";
            param.ArgCnt=0;
        },
        multiple:true,
        rowStyle:"checkbox"
    });

    $("#PadSheet").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        },
        multiple:true,
        rowStyle:"checkbox"
    });

    $("#OperListEditColumns").combobox({
        valueField:"value",
        textField:"text",
        data:[{
            value:"OperRoom",
            text:"手术间"
        },{
            value:"OperSeq",
            text:"台次"
        },{
            value:"PlanOperSeq",
            text:"申请台次"
        },{
            value:"ScrubNurse",
            text:"器械护士"
        },{
            value:"CircualNurse",
            text:"巡回护士"
        },{
            value:"NurseInternShip",
            text:"手术实习进修"
        },{
            value:"AnaMethod",
            text:"麻醉方法"
        },{
            value:"AnaExpert",
            text:"麻醉指导"
        },{
            value:"Anesthesiologist",
            text:"麻醉医生"
        },{
            value:"AnaAssistant",
            text:"麻醉助手"
        },{
            value:"AnaStaff",
            text:"麻醉实习进修"
        }],
        multiple:true,
        rowStyle:"checkbox"
    });

    $("#SheetEditFlag").combobox({
        valueField:"Code",
        textField:"Description",
        url:ANCSP.DataQuery,
        rowStyle:"checkbox",
        multiple:true,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindDictDataByCode";
            param.Arg1="SheetEditFlag";
            param.ArgCnt=1;
        }
    })

    $("#btnSaveGroupSetting").linkbutton({
        onClick:function(){
            saveGroupSettings();

        }
    });

    $("#btnSaveAction").linkbutton({
        onClick:function(){
            saveActionPermission();

        }
    });

    $("#btnSaveMenu").linkbutton({
        onClick:function(){
            saveMenuPermission();

        }
    });
}

function initPage(){
    initGroupBox();
    initMenuItems();
    initOperActions();
    initGroupSettings();
}

function saveGroupSettings(){
    var selectedGroup=$("#groupBox").datagrid("getSelected");
    if(!selectedGroup){
        $.messager.alert("提示","请先选择安全组并进行配置后，再保存！","warning");
        return;
    }
    var formData=$("#groupForm").serializeJson();
    formData.ClassName=ANCLS.Config.SSGroup;
    var statusArr=$("#DefOperStatus").combobox("getValues");
    formData.DefOperStatus=statusArr.join(",");
    var arrangeStatusArr=$("#CanArrangeStatus").combobox("getValues");
    formData.CanArrangeStatus=arrangeStatusArr.join(",");
    var operListEditColumns=$("#OperListEditColumns").combobox("getValues");
    formData.OperListEditColumns=operListEditColumns.join(",");
    var sheetEditFlags=$("#SheetEditFlag").combobox("getValues");
    formData.SheetEditFlag=sheetEditFlags.join(",");
    var PadSheet=$("#PadSheet").combobox("getValues");
    formData.PadSheet=PadSheet.join(",");
    var jsonStr=dhccl.formatObjects([formData]);
    var saveRet=dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:jsonStr
    });
    if(saveRet.indexOf("S^")===0){
        $.messager.alert("提示","安全组配置信息保存成功。","info",function(){
            selectGroup(selectedGroup);
        });
    }else{
        $.messager.alert("提示","安全组配置信息保存失败，原因："+saveRet,"error");
    }
}

function saveMenuPermission(){
    moduleBox = $("#menuBox");
    var selectedGroup = $("#groupBox").datagrid("getSelected"),
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

function saveActionPermission(){
    endEdit();
            var checkedRows = $("#actionBox").datagrid("getChecked"),
                rows = $("#actionBox").datagrid("getRows"),
                actionPermissions = [],
                selectedGroup = $("#groupBox").datagrid("getSelected");
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
                //$("#actionBox").datagrid("reload");
            }else{
                $.messager.alert("提示","保存授权数据失败，原因："+saveRet,"error");
            }
}

function selectGroupForAction(group) {
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

function selectGroupForMenu(row){
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
            checkMenuItems(data,$("#menuBox"));
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

function selectGroup(row){
    var panel=$("#groupBox").datagrid("getPanel");
    $(panel).panel("setTitle","安全组-"+row.Description);
    $("#groupForm").form("clear");
    $("#GroupID").val(row.RowId);
    var groupSetting=getGroupSetting(row.RowId);
    if(groupSetting){
        
        $("#groupForm").form("load",groupSetting);
        if(groupSetting.DefOperStatus){
            var statusArr=groupSetting.DefOperStatus.split(",");
            $("#DefOperStatus").combobox("setValues",statusArr);
        }
        if(groupSetting.OperListEditColumns){
            var operListEditColumns=groupSetting.OperListEditColumns.split(",");
            $("#OperListEditColumns").combobox("setValues",operListEditColumns);
        }
        if(groupSetting.CanArrangeStatus){
            var arrangeStatusArr=groupSetting.CanArrangeStatus.split(",");
            $("#CanArrangeStatus").combobox("setValues",arrangeStatusArr);
        }

        if(groupSetting.SheetEditFlag){
            var sheetEditFlagArr=groupSetting.SheetEditFlag.split(",");
            $("#SheetEditFlag").combobox("setValues",sheetEditFlagArr);
        }
        if(groupSetting.PadSheet){
            var PadSheet=groupSetting.PadSheet.split(",");
            $("#PadSheet").combobox("setValues",PadSheet);
        }
    }
    
    selectGroupForMenu(row);
    selectGroupForAction(row);
}

function getGroupSetting(groupId){
    var groupSettings=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindGroupSetting",
        Arg1:groupId,
        ArgCnt:1
    },"json");

    var groupSetting=null;
    if (groupSettings && groupSettings.length>0){
        groupSetting=groupSettings[0];
    }

    return groupSetting;
}

function endEdit(){
    var actionRows=$("#actionBox").datagrid("getRows");
    if(actionRows && actionRows.length>0){
        for (var i = 0; i < actionRows.length; i++) {
            var actionRow = actionRows[i];
            $("#actionBox").datagrid("endEdit",i);
        }
    }
}

$(document).ready(initPage);