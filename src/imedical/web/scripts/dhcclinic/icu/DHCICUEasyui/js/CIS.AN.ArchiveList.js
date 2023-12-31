var operList={
    controlDatas:null
}

/**
 * 初始化页面
 */
function initPage()
{
    initConditionForm();
    initOperListGrid();
    //initActionPermission();
}

/**
 * 初始化查询条件表单
 */
function initConditionForm(){
    dhccl.parseDateFormat();
	var today=(new Date()).format("yyyy-MM-dd");
    $("#OperStartDate,#OperEndDate").datebox("setValue",today);

    $("#AppDept").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindDeptListDept";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.Arg3=session.HospID;
            param.ArgCnt=3;
        },
        mode:"remote"
    });

    $("#PatWard").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindWards";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.HospID;
            param.Arg3="";
            param.Arg4="Y";
            param.ArgCnt = 4;
        }
    });

    $("#RegNo").keyup(function(e){
        if(e.keyCode===13){
            var text=$(this).val();
            if(text && text.length<10){
                var zeroArr=[];
                for(var i=0;i<10-text.length;i++){
                    zeroArr.push(0);
                }
                $(this).val(zeroArr.join("")+text);
            }
            queryOperList();
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
        if(conditions.appDeptDefValue===1){
            $("#AppDept").combobox("setValue",session.DeptID);
        }
        
    }
}

/**
 * 初始化手术列表表格
 */
function initOperListGrid(){
    //var columnsConfig=dhccl.runServerMethod("CIS.AN.BL.DataGrid","GetDataColumns",session.ModuleID,"operlistBox",session.GroupID,session.UserID);
    var columns=[[
        {field:"CheckStatus",title:"勾选",checkbox:true},
        {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
            return "background-color:" + row.StatusColor + ";";
        }}, 
        {field:"SourceTypeDesc",title:"类型",width:50,styler: function (value, row, index) {
            switch (row.SourceType) {
                case "B":
                    return "background-color:"+SourceTypeColors.Book+";";
                case "E":
                    return "background-color:"+SourceTypeColors.Emergency+";";
                default:
                    return "background-color:white;";
            }
        }},
        {field:"OperDate",title:"手术日期",width:100},
        {field:"RoomDesc",title:"手术间",width:69},
        {field:"OperSeq",title:"台次",width:45},
        {field:"PlanSeq",title:"拟台",width:45},
        {field:"PatName",title:"患者姓名",width:76},
        {field:"PatGender",title:"性别",width:45},
        {field:"PatAge",title:"年龄",width:50},
        {field:"PatDeptDesc",title:"科室",width:120},
        {field:"PostDiagnosis",title:"手术诊断",width:160},
        {field:"OperDesc",title:"手术名称",width:200},
        {field:"SurgeonDesc",title:"主刀",width:62},
        {field:"AsstDesc",title:"助手",width:80},
        {field:"ScrubNurseDesc",title:"器械护士",width:112},
        {field:"CircualNurseDesc",title:"巡回护士",width:112},
        {field:"AnaMethodDesc",title:"麻醉方法",width:100},
        {field:"AnesthesiologistDesc",title:"麻醉医生",width:80},
        {field:"OperRiskAssessment",title:"手术风险评估",width:104},
        {field:"OperSafetyCheck",title:"手术安全核查",width:104},
        {field:"OperCount",title:"手术清点",width:76},
        {field:"AnaestConsent",title:"麻醉知情同意书",width:118},
        {field:"PreopAnaVisit",title:"术前麻醉访视",width:104},
        {field:"AnaestRecord",title:"麻醉记录",width:76},
        {field:"PACURecord",title:"麻醉恢复记录",width:104},
        {field:"PostopAnaVisit",title:"术后麻醉访视",width:104}
        
    ]];
    //initColumns(columns[0],columnsConfig);
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
        checkOnSelect:true,
        selectOnCheck:true,
        toolbar:"#operlistTool",
        columns:columns,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperScheduleList;
            param.QueryName="FindOperScheduleList";
            param.Arg1=$("#OperStartDate").datebox("getValue");
            param.Arg2=$("#OperEndDate").datebox("getValue");
            param.Arg3=session.DeptID;
            param.Arg4="";
            param.Arg5=$("#AppDept").combobox("getValue");
            param.Arg6=$("#PatWard").combobox("getValue");
            param.Arg7="";
            param.Arg8="";
            param.Arg9=$("#RegNo").val();
            param.Arg10=$("#MedcareNo").val();
           	param.Arg11="";
            param.Arg12="N";
            param.Arg13="N";
            param.ArgCnt=13;
        },
        onSelect:function(rowIndex,rowData){
            selectPatient(rowData);
            var background=$(".datagrid-row-selected").css("background");
            var color=$(".datagrid-row-selected").css("color");
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td").css({"color":"#000","background":"#ffe48d"});
        },
        onUnselect:function(rowIndex,rowData){
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td").css({"color":"#000","background-color":"#fff"});
            switch(rowData.SourceType){
                case "B":
                    $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='SourceTypeDesc']").css({"color":"#000","background-color":SourceTypeColors.Book});
                    break;
                case "E":
                    $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='SourceTypeDesc']").css({"color":"#000","background-color":SourceTypeColors.Emergency});
                    break;
            }
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] td[field='StatusDesc']").css({"color":"#000","background-color":""+rowData.StatusColor+""});
        }
    });

    //setOperlistBoxColumnDisplay();

}

function setOperlistBoxColumnDisplay(){
    var testIcon=dhccl.runServerMethod("CIS.AN.BL.OperScheduleList","GetOperConfig","OperListEdit");
    if(testIcon.result=="Y")
    {
        $("#operlistBox").datagrid("enableGridSetting",{clickHandler:function(columnOptList){
        var columnEditor=new DataGridEditor({
            title:"手术列表",
            data:columnOptList,
            moduleId:session.ModuleID,
            elementId:"operlistBox",
            closeCallBack:function(){
                window.location.reload();
            }
        });
        columnEditor.open();
        }});
    }   
}


function initActionPermission(){
    //$(".hisui-linkbutton").linkbutton("disable");
    var actionPermissions=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindActionPermission",
        Arg1:session.GroupID,
        Arg2:session.ModuleID,
        Arg3:"Y",
        ArgCnt:3
    },"json");
    var AuditOperations=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindDataConfigurations",
        Arg1:"",
        ArgCnt:1
    },"json");
    if(actionPermissions && actionPermissions.length>0){
        for(var i=0;i<actionPermissions.length;i++){
            var actionPermission=actionPermissions[i];
            //审核手术按钮受手术申请配置控制 YuanLin 20200212
            //if((actionPermission.ElementID=="btnAuditOperation")&(AuditOperations[8].DataKey=="NeedAuditOperation")&(AuditOperations[8].DataValue=="N")) continue;
            // 不需要审核按钮，只要把按钮移除 CCQ 20200220
            if((actionPermission.ElementID=="btnAuditOperation")&(AuditOperations[8].DataKey=="NeedAuditOperation")&(AuditOperations[8].DataValue=="N")){
                $("#"+actionPermission.ElementID).remove();
            }
            //$("#"+actionPermission.ElementID).linkbutton("enable");
        }

        $(".hisui-linkbutton").each(function(index,item){
            var id=$(item).attr("id");
            var permission=getActionPermssion(id);
            if(!permission){
                $(item).remove();
            }
        });
    }else{
        $(".hisui-linkbutton").each(function(index,item){
            $(item).remove();
        });
    }

    function getActionPermssion(elID){
        var result=null;
        if(actionPermissions && actionPermissions.length>0){
            for(var actionIndex=0;actionIndex<actionPermissions.length;actionIndex++){
                permission=actionPermissions[actionIndex];
                if(permission.ElementID===elID){
                    result=permission;
                }
            }
        }
        return result;
    }
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
    var rows=$("#operlistBox").datagrid("getChecked");
    if (!rows || rows.length<1){
        $.messager.alert("提示","请先选勾选需要导出的手术，再进行操作。","warning");
        return;
    }
    var columnFields=$("#operlistBox").datagrid("getColumnFields");
    if(!columnFields || columnFields.length<1) return;
    var aoa=[],     // array of array
        fieldArray=[];
    for(var fieldInd=0;fieldInd<columnFields.length;fieldInd++){
        var columnField=columnFields[fieldInd];
        var columnOpts=$("#operlistBox").datagrid("getColumnOption",columnField);
        fieldArray.push(columnOpts.title);
    }
    aoa.push(fieldArray);
    for(var i=0;i<rows.length;i++){
        var row=rows[i],
            valueArray=[];
        for(var j=0;j<columnFields.length;j++){
            var columnField=columnFields[j];
            var columnOpts=$("#operlistBox").datagrid("getColumnOption",columnField);
            valueArray.push(row[columnOpts.field] || '');
        }
        aoa.push(valueArray);
    }
    if (aoa.length>0 && window.excelmgr){
        window.excelmgr.aoa2excel(aoa,"手术列表.xlsx");
    }
}

function replacePos(strObj, pos, replacetext)
{
var str = strObj.substr(0, pos-1) + replacetext + strObj.substring(pos+6, strObj.length);
return str;
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

function initColumns(columns,columnsConfig)
{
    for(var i=0;i<columns.length;i++)
    {
        for(var j=0;j<columnsConfig.length;j++)
        {
            var test=columns[i].field;
            var test1=columnsConfig[j].field;
            if(columns[i].field==columnsConfig[j].field)
            {
                if(columnsConfig[j].hidden=="true") columns[i].hidden=true;
                if(columnsConfig[j].sortable=="true") columns[i].sortable=true;
                columns[i].width=columnsConfig[j].width;
                columns[i].SeqNo=columnsConfig[j].SeqNo;
            }
        
        }
    }
    columns.sort(function(a,b){
        return a.SeqNo - b.SeqNo;
    });
}
$(document).ready(initPage);


