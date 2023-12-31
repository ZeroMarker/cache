/**
 * 初始化页面
 */
function initPage()
{
    initConditionForm();
    initOperListGrid();
    initCancelReasonDialog();
}

/**
 * 初始化查询条件表单
 */
function initConditionForm(){

    var today=(new Date()).format("yyyy-MM-dd");
    $("#OperStartDate,#OperEndDate").datebox("setValue",today);

    $("#AppDept").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        mode:"remote"
    });

    $("#PatWard").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindWard";
            param.ArgCnt = 0;
        }
    });

    $("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2="R";
            param.ArgCnt = 2;
        }
    });

    $("#OperStatus").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperStatus";
            param.ArgCnt = 0;
        }
    });

    $("#btnQuery").linkbutton({
        onClick:queryOperList
    });

    $("#btnExport").linkbutton({
        onClick:exportOperList
    });

    setQueryConditions();
}

/**
 * 根据配置信息设置默认查询条件
 */
function setQueryConditions(){
    var permission=operationListConfig.getPermission(session.GroupID);
    if(permission && permission.qryConditions){
        var conditions=permission.qryConditions;
        if(!conditions.startDate) conditions.startDate=0;
        if(!conditions.endDate) conditions.endDate=0;
        var today=new Date();
        var startDate=today.addDays(conditions.startDate);
        var endDate=today.addDays(conditions.endDate);
        var startDateStr=startDate.format("yyyy-MM-dd");
        var endDateStr=endDate.format("yyyy-MM-dd");
        $("#OperStartDate").datebox("setValue",startDateStr);
        $("#OperEndDate").datebox("setValue",endDateStr);
        if(conditions.appDeptEnable===0){
            $("#AppDept").combobox("disable");
        }
    }
}

/**
 * 初始化手术列表表格
 */
function initOperListGrid(){
    var columns=[[
        {field:"CheckStatus",title:"勾选",checkbox:true},
        {field:"OperDate",title:"手术日期",width:100},
        {field:"RoomDesc",title:"手术间",width:69},
        {field:"OperSeq",title:"台次",width:45},
        {field:"PatName",title:"患者姓名",width:76},
        {field:"PatGender",title:"性别",width:45},
        {field:"PatAge",title:"年龄",width:50},
        {field:"PatDeptDesc",title:"科室",width:120},
        {field:"PrevDiagnosis",title:"术前诊断",width:160},
        {field:"PlanOperDesc",title:"手术名称",width:200},
        {field:"SourceTypeDesc",title:"类型",width:50,styler: function (value, row, index) {
            switch (row.SourceType) {
                case "B":
                    return "background-color:yellow;";
                case "E":
                    return "background-color:red;";
                default:
                    return "background-color:white;";
            }
        }},
        {field:"PlanSurgeonDesc",title:"主刀",width:62},
        {field:"PlanAsstDesc",title:"助手",width:80},
        {field:"ScrubNurseDesc",title:"器械护士",width:112},
        {field:"CircualNurseDesc",title:"巡回护士",width:112},
        {field:"AnaMethodDesc",title:"麻醉方法",width:100},
        {field:"AnaDocDesc",title:"麻醉医生",width:80},
        {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
            return "background-color:" + row.StatusColor + ";";
        }}
    ]];

    $("#operlistBox").datagrid({
        fit:true,
        title:"手术列表",
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        rownumbers: true,
        pagination: true,
        pageSize: 300,
        pageList: [50, 100, 200,300,400,500],
        remoteSort: false,
        checkbox: true,
        // checkOnSelect:false,
        // selectOnCheck:false,
        toolbar:"#operlistTool",
        columns:columns,
        url:ANCSP.DataQuery,
        // rowStyler: function (index, row) {
        //     return "background-color:" + row.StatusColor + ";";
        // },
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperScheduleList;
            param.QueryName="FindOperScheduleList";
            param.Arg1=$("#OperStartDate").datebox("getValue");
            param.Arg2=$("#OperEndDate").datebox("getValue");
            param.Arg3=session.DeptID;
            param.Arg4="";
            param.Arg5=$("#AppDept").combobox("getValue");
            param.Arg6=$("#PatWard").combobox("getValue");
            param.Arg7=$("#OperStatus").combobox("getValue");
            param.Arg8=$("#OperRoom").combobox("getValue");
            param.Arg9=$("#RegNo").val();
            param.Arg10=$("#MedcareNo").val();
            param.ArgCnt=10;
        },
        onSelect:function(rowIndex,rowData){
            selectPatient(rowData);
            //$("#operlistBox").parent(".datagrid-view").find("tr .sourcetype-book").css("color","#528dbf");
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td").css({"color":"#FFF","background-color":"#0081c2"});
            //$("#operlistBox").parent(".datagrid-view").find("tr .sourcetype-em").css("color","#528dbf");
            // $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] .sourcetype-em").css("color","#FFF");
        },
        onUnselect:function(rowIndex,rowData){
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td").css({"color":"#000","background-color":"#fff"});
            switch(rowData.SourceType){
                case "B":
                    $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='SourceTypeDesc']").css({"color":"#000","background-color":"yellow"});
                    break;
                case "E":
                    $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='SourceTypeDesc']").css({"color":"#000","background-color":"#red"});
                    break;
            }
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='StatusDesc']").css({"color":"#000","background-color":""+rowData.StatusColor+""});
            // $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] .sourcetype-em").css("color","red");
        }
    });

    setOperlistBoxColumnDisplay();

    $("#btnCancelOperation").linkbutton({
        onClick:cancelOperation
    });

    $("#btnEditOperation").linkbutton({
        onClick:editOperation
    });

    $("#btnAuditOperation").linkbutton({
        onClick:function(){
            $.messager.confirm("提示","是否审核所有勾选的手术？",function(r){
                if(r){
                    auditOperation();
                }
            });
        }
    })
}

function setOperlistBoxColumnDisplay(){
    var permission=operationListConfig.getPermission(session.GroupID);
    if(permission){
        var columnFields=$("#operlistBox").datagrid("getColumnFields");
        if(columnFields && columnFields.length>0){
            for(var i=0;i<columnFields.length;i++){
                var field=columnFields[i];
                if(permission.displayColumns && permission.displayColumns.indexOf(field)<0){
                    $("#operlistBox").datagrid("hideColumn",field);
                }
            }
        }
    }
}

function initCancelReasonDialog(){
    $("#ReasonOptions").combobox({
        textField:"text",
        valueField:"value",
        editable:false,
        data:[{
            text:"患者要求",
            value:"患者要求"
        },{
            text:"手术条件不具备",
            value:"手术条件不具备"
        }],
        onSelect:function(record){
            var reason=$("#CancelReason").val();
            if(reason){
                reason+=",";
            }
            reason+=record.text;
            $("#CancelReason").val(reason);
            $(this).combobox("clear");
        }
    });

    $("#btnExitReason").linkbutton({
        onClick:function(){
            $("#CancelReason").val("");
            $("#ReasonOptions").combobox("clear");
            $("#operCancelReason").dialog("close");
        }
    });

    $("#btnSaveReason").linkbutton({
        onClick:function(){
            var selectedData=$("#operlistBox").datagrid("getSelected");
            var opsId=selectedData.OPSID;
            var cancelUserId=session.UserID;
            var reason=$("#CancelReason").val();
            var ret=dhccl.runServerMethod(ANCLS.BLL.OperScheduleList,"CancelOperation",opsId,reason,cancelUserId);
            if(ret.success){
                $.messager.alert("提示","取消手术成功","info",function(){
                    $("#CancelReason").val("");
                    $("#ReasonOptions").combobox("clear");
                    $("#operCancelReason").dialog("close");
                    $("#operlistBox").datagrid("reload");
                });
            }else{
                $.messager.alert("提示","取消手术失败，原因："+ret.result,"error");
            }
        }
    });
}

/**
 * 查询手术列表
 */
function queryOperList(){
    $("#operlistBox").datagrid("reload");
}

/**
 * 导出手术列表
 */
function exportOperList(){

}

/**
 * 作废手术申请
 */
function cancelOperation(){
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再取消手术。","warning");
        return;
    }
    var operPermission=operationListConfig.getOperPermission(session.GroupID,"btnCancelOperation",selectedData.StatusCode);
    if(operPermission===false){
        $.messager.alert("提示","当前安全组或当前状态无取消手术的权限。","warning");
        return;
    }
    $("#operCancelReason").dialog("open");
}

/**
 * 修改手术申请
 */
function editOperation(){
    var selectedData=$("#operlistBox").datagrid("getSelected");
    if(!selectedData){
        $.messager.alert("提示","请先选择手术记录，再进行修改。","warning");
        return;
    }
    var operPermission=operationListConfig.getOperPermission(session.GroupID,"btnEditOperation",selectedData.StatusCode);
    if(operPermission===false){
        $.messager.alert("提示","当前安全组或当前状态无修改手术的权限。","warning");
        return;
    }
    var url="dhcan.operapplication.csp?opsId="+selectedData.OPSID+"&EpisodeID="+selectedData.EpisodeID+"&PatientID="+selectedData.PatientID+"&MRAdmID="+selectedData.MRAdmID;
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#editOperApplication").dialog({
        content:href,
        title:selectedData.PatName+"的手术申请",
        iconCls:"icon-edit"
    });
    
    $("#editOperApplication").dialog("open");
    //window.open(url,selectedData.PatName+"的手术申请");
}

function auditOperation(){
    var selectedRows=$("#operlistBox").datagrid("getSelections");
    if(!selectedRows || selectedRows.length<1){
        $.messager.alert("提示","请先选择手术记录，再审核手术。","warning");
        return;
    }
    var opsIdArr=[];
    for(var i=0;i<selectedRows.length;i++){
        opsIdArr.push(selectedRows[i].OPSID);
    }
    var opsIdStr=opsIdArr.join(";");
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"AuditOperation",opsIdStr,session.UserID);
    if(ret.success){
        $.messager.alert("提示","审核手术成功","info");
        $("#operlistBox").datagrid("reload");
    }else{
        $.messager.alert("提示","审核手术失败，原因："+ret.result,"error");
    }
}

function printOperations(){

}

function closeOperEditDialog(){
    $("#editOperApplication").dialog("close");
    $("#operlistBox").datagrid("clearSelections");
    $("#operlistBox").datagrid("reload");
}

function selectPatient(patOperData){
    if (patOperData) {
        //var eprmenu = window.parent.top.frames["eprmenu"];
        var isSet = false;
        // if (eprmenu) {
        var frm = window.parent.parent.document.forms['fEPRMENU'];
        if (frm) {
            frm.PatientID.value = patOperData.PatientID;
            frm.EpisodeID.value = patOperData.EpisodeID;
            frm.mradm.value = patOperData.MRAdmID;
            if (frm.AnaesthesiaID)
                frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
            isSet = true;
        }
        if (isSet == false) {
            var frm = dhcsys_getmenuform();
            if (frm) {
                frm.PatientID.value = patOperData.PatientID;
                frm.EpisodeID.value = patOperData.EpisodeID;
                frm.mradm.value = patOperData.MRAdmID;
                if (frm.AnaesthesiaID)
                    frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
            }
        }
        //}
    }
}

$(document).ready(initPage);


