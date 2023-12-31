function initPage(){
    initQueryPanel();
    initQueryBox();
}

function initQueryBox(){
    var columns=[[
        {field:"OperDate",title:"手术日期",width:100},
        {field:"RegNo",title:"登记号",width:100},
        {field:"PatName",title:"患者姓名",width:100},
        {field:"PatGender",title:"性别",width:100},
        {field:"PatAge",title:"年龄",width:100},
        {field:"PatHeight",title:"身高",width:100},
        {field:"PatWeight",title:"体重",width:100},
        {field:"ASAClassDesc",title:"ASA分级",width:100},
        {field:"SourceTypeDesc",title:"手术类型",width:100},
        {field:"PreFastingDesc",title:"术前禁食",width:100},
        {field:"BloodType",title:"ABO",width:100},
        {field:"RHBloodType",title:"RHD",width:100},
        {field:"PrevDiagnosis",title:"术前诊断",width:200},
        {field:"PlanOperDesc",title:"拟施手术",width:200},
        {field:"OperPositionDesc",title:"手术体位",width:100},
        {field:"PreMedication",title:"术前用药",width:200},
        {field:"PreOperNote",title:"术前特殊情况",width:200}
    ]];

    $("#statQueryBox").datagrid({
        fit:true,
        title:"手术麻醉明细数据",
        headerCls:"panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 100,
        pageList: [50, 100, 200,300,400,500],
        columns:columns,
        url:ANCSP.MethodService,
        onBeforeLoad:function(param){
            param.ClassName="CIS.AN.BL.OperStatistic";
            param.MethodName="GetOperList";
            param.Arg1=$("#startDate").datebox("getValue");
            param.Arg2=$("#endDate").datebox("getValue");
            param.Arg3=session.DeptID;
            param.Arg4="";
            param.Arg5=param.page;
            param.Arg6=param.rows;
            param.ArgCnt=6;

            var queryConditions=getExtQueryCondtions();
            if(queryConditions && queryConditions.length>0){
                param.Arg4=dhccl.formatObjects(queryConditions);
            }
        }
    });
}

function initQueryPanel(){
    dhccl.parseDateFormat();
    var today=(new Date()).format("yyyy-MM-dd");
    $("#startDate,#endDate").datebox("setValue",today);
    var queryView=new StatQueryView({
        panel:"#query-panel"
    });
    queryView.init();

    $("#btnQuery").linkbutton({
        onClick:function(){
            $("#statQueryBox").datagrid("reload");
        }
    });

    $("#btnExport").linkbutton({
        onClick:function(){
            exportOperList();
        }
    });
}

/**
 * 导出手术列表
 */
function exportOperList(){
    var data=$("#statQueryBox").datagrid("getData");
    var rows=data.rows;
    // if (!rows || rows.length<1){
    //     $.messager.alert("提示","请先选勾选需要导出的手术，再进行操作。","warning");
    //     return;
    // }
    var columnFields=$("#statQueryBox").datagrid("getColumnFields");
    if(!columnFields || columnFields.length<1) return;
    var aoa=[],     // array of array
        fieldArray=[];
    for(var fieldInd=0;fieldInd<columnFields.length;fieldInd++){
        var columnField=columnFields[fieldInd];
        var columnOpts=$("#statQueryBox").datagrid("getColumnOption",columnField);
        fieldArray.push(columnOpts.title);
    }
    aoa.push(fieldArray);
    for(var i=0;i<rows.length;i++){
        var row=rows[i],
            valueArray=[];
        for(var j=0;j<columnFields.length;j++){
            var columnField=columnFields[j];
            var columnOpts=$("#statQueryBox").datagrid("getColumnOption",columnField);
            valueArray.push(row[columnOpts.field] || '');
        }
        aoa.push(valueArray);
    }
    if (aoa.length>0 && window.excelmgr){
        window.excelmgr.aoa2excel(aoa,"手术麻醉明细数据.xlsx");
    }
}

function getExtQueryCondtions(){
    var conditionItems=[];
    $(".item").each(function(index,item){
        var rowId=$(item).attr("data-rowid");
        var queryCode=$(item).combobox("getValue");
        if (!queryCode) return;
        var queryValue=$("#value"+rowId).val();
        var operator=$("#operator"+rowId).combobox("getValue");
        if(!operator) return;
        var operType=$("#operator"+rowId).attr("data-opertype");
        if(!operType) return;
        var logical=$("#logical"+rowId).combobox("getValue");
        conditionItems.push({
            Code:queryCode,
            Value:queryValue,
            Operator:operator,
            OperType:operType,
            Logical:logical
        });
    });

    return conditionItems;
}

$(document).ready(initPage);