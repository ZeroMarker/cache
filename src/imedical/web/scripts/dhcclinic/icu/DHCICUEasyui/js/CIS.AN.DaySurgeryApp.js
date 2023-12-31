var operApplication={
    newApp:true,
    editableStatus:"DaySurgery",
    yesNoOptions:[{
        value:"Y",
        text:"是"
    },{
        value:"N",
        text:"否"
    }],
    testOptions:[{
        value:"N",
        text:"未知",
    },{
        value:"-",
        text:"阴性"
    },{
        value:"+",
        text:"阳性"
    }],
    relatedEMRecords:null,
    controlDatas:null
};
var EpisodeID=getEpisodeByMenu();
var opsId="";
var isConfirm="";
if(dhccl.getQueryString("IsConfirm"))
{
    //alert(dhccl.getQueryString("IsConfirm"))
    isConfirm=dhccl.getQueryString("IsConfirm");
}
//alert(isConfirm)
function initPage(){
    $(".spinner-text").each(function(index,item){
        var spinnerWidth=$(item).width();
        $(item).css("width",(spinnerWidth-5)+"px");
    });
    //设置默认值
   
    initAppForm();
    //alert("formok")
    setDefaultValue();
    //alert("infook")
 
}
/**
 * 初始化手术申请表单
 */
function initAppForm(){
    initDiagBox();
    initOperBox();
    initAppFormOptions();
    loadAppFormData();
}

/**
 * 初始化术前诊断数据表格
 */
function initDiagBox(){
    // var diagDescOptions=getDiagnosisOptions();
    var columns=[[
        {field:"DiagID",title:"诊断ID",hidden:true},
        {field:"DiagDesc",title:"诊断描述",width:710}
    ]];

    $("#preopDiagBox").datagrid({
        width: 715,
        height: 120,
        singleSelect: true,
        rownumbers: false,
        columns:columns,
        toolbar:"#preopDiagTool",
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        onBeforeLoad:function(param){
           
        },
        onLoadSuccess:function(data){
            initDiagButtons();
        },
        onSelect:function(index,row){
            if(row && row.DiagDesc){
                $("#Diagnosis").combogrid("setValue",row.DiagID);
                $("#Diagnosis").combogrid("setText",row.DiagDesc);
            }
        }
    });

    $("#Diagnosis").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMRCDiagnosis";
            param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        panelWidth:300,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"Description",title:"名称",width:180},
            {field:"ICDCode",title:"ICD",width:100}
        ]],
        mode: "remote"
    });

    $("#btnAddDiag").linkbutton({
        onClick:function(){
            addDiagnosis();
        }
    });

    $("#btnEditDiag").linkbutton({
        onClick:function(){
            editDiagnosis();
        }
    });

    $("#btnDelDiag").linkbutton({
        onClick:function(){
            removeDiagnosis();
        }
    });
}

function initOperBox(){
    // var operationOpts=getOperationOptions();
    // var operClassOpts=getOperClassOptions();
    // var surgeonDeptOpts=getSurgeonDeptOptions();
    // var surgeonOpts=getSurgeonOptions();
    var columns=[[
        {field:"RowId",title:"ID",hidden:true},
        {field:"Operation",title:"Operation",hidden:true},
        {field:"OperClass",title:"OperClass",hidden:true},
        {field:"Surgeon",title:"Surgeon",hidden:true},
        {field:"Assistant",title:"Assistant",hidden:true},
        {field:"OperInfo",title:"手术名称",width:300,formatter:function(value,row,index){
            var retArr=[row.OperationDesc];
            if(row.OperClassDesc){
                retArr.push("("+row.OperClassDesc);
            }
            if(row.BodySiteDesc){
                if (row.OperClassDesc) retArr.push(",")
                retArr.push(row.BodySiteDesc);
            }
            if(row.BladeTypeDesc){
                if(row.OperClassDesc || row.BodySiteDesc) retArr.push(",")
                retArr.push(row.BladeTypeDesc);
            }
            if(row.OperClassDesc || row.BodySiteDesc || row.BladeTypeDesc){
                retArr.push(")");
            }

            return retArr.join("");
        }},
        {field:"OperNote",title:"名称备注",width:180},
        {field:"SurgeonDeptDesc",title:"术者科室",width:100},
        {field:"SurgeonDesc",title:"主刀",width:80},
        {field:"AssistantDesc",title:"助手",width:140},
        {field:"SurgeonExpert",title:"外院专家",width:144}
    ]];

    //20211105
    $("#Operation").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.DaySurgery;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = $("#Surgeon").combobox("getValue");
            param.Arg3 = $("#SurgeonDeptID").combobox("getValue");
            param.Arg4 ="";
            param.Arg5 =session.HospID;
            param.Arg6 =$("#OperDate").datebox("getValue");
            param.ArgCnt = 6;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"名称",width:240},
            {field:"OperClassDesc",title:"分级",width:60},
            {field:"ICDCode",title:"ICD",width:120},
            {field:"ExternalID",title:"ExternalID",hidden:true}
        ]],
        pagination:true,
        pageSize:10,
        mode: "remote",
        onSelect:function(rowIndex,record){
           
               
                $("#OperClass").combobox("setValue",record.OperClass);
                $("#BladeType").combobox("setValue",record.BladeType);
                $("#BodySite").combobox("setValue",record.BodySite);
                $("#BodySite").combobox("reload");
           
            
        },
        onChange:function(newValue,oldValue){
	        if( $("#Surgeon").combobox("getValue")=="")
	        {
            	$("#Surgeon").combobox("reload");
	        }
        }
    });

    $("#OperClass").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindOperClass";
            param.ArgCnt=0;
        }
    });
    $("#BodySite").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindBodySiteByOper";
            param.Arg1=$("#Operation").combogrid("getValue");
            param.ArgCnt=1;
        }
    });
    $("#BladeType").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindBladeType";
            param.ArgCnt=0;
        }
    });
    $("#Surgeon").combobox({
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName="CIS.AN.BL.DaySurgery";
            param.QueryName="FindSurgeonByOper";
            param.Arg1 = param.q?param.q:"";
            param.Arg2=$("#SurgeonDeptID").combobox("getValue");
            if(!param.Arg2){
				param.Arg2=session.DeptID;
            }
            param.Arg3 = "Y";
            param.Arg4 = session.HospID;
            param.Arg5 = $("#Operation").combobox("getValue");
            param.ArgCnt = 5;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        /*
        onSelect:function(rowIndex,record){
	        if($("#Operation").combogrid("getValue")=="")
	        {
		         var grid=$("#Operation").combogrid("grid");
            	grid.datagrid("reload");
	        }
        }*/
        
		onChange:function(newValue,oldValue){
            //alert($("#Surgeon").combobox("getValue"))
            if($("#Operation").combogrid("getValue")=="")
            {
            	var grid=$("#Operation").combogrid("grid");
            	grid.datagrid("reload");
            }
            
        }
        
    });
    /*
    $(".sur-careprov").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindResource";
            param.Arg1=param.q?param.q:"";
            param.Arg2=$("#SurgeonDeptID").combobox("getValue");
            if(!param.Arg2){
                param.Arg2=session.DeptID;
            }
            param.Arg3="Y";
            param.Arg4=session.HospID;
            param.ArgCnt=4;
        },
        // panelWidth:450,
        valueField: "CareProvider",
        textField: "CareProvDesc",
        // columns:[[
        //     {field:"RowId",title:"ID",hidden:true},
        //     {field:"CareProvDesc",title:"医护姓名",width:240},
        //     {field:"DeptDesc",title:"所在科室",width:200}
        // ]],
        mode: "remote"
    });
    */
   $(".sur-careprov").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad: function(param) {
        param.ClassName=CLCLS.BLL.Admission;
        param.QueryName="FindCareProvByLoc";
        param.Arg1=param.q?param.q:"";
        param.Arg2=$("#SurgeonDeptID").combobox("getValue");
        if(!param.Arg2){
            param.Arg2=session.DeptID;
        }
        param.ArgCnt=2;
    },
    // panelWidth:450,
    valueField: "RowId",
    textField: "Description",
    // columns:[[
    //     {field:"RowId",title:"ID",hidden:true},
    //     {field:"CareProvDesc",title:"医护姓名",width:240},
    //     {field:"DeptDesc",title:"所在科室",width:200}
    // ]],
    mode: "remote"
});

    $("#operationBox").datagrid({
        width: 985,
        height: 300,
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        sytle:{"border-radius":"2px"},
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operationTool",
        url: ANCSP.DataQuery,
        columns:columns,
        onLoadSuccess:function(data){
            initOperButtons();
        },
        onSelect:function(index,row){
            selectOperation(index,row);
        }
    });

    $("#btnAddOperation").linkbutton({
        onClick:function(){
            addOperation();
        }
    });

    $("#btnEditOperation").linkbutton({
        onClick:function(){
            editOperation();
        }
    });

    $("#btnDelOperation").linkbutton({
        onClick:function(){
            removeOperation();
        }
    });
}

function initAppFormOptions(){
    /*
    $("#AppDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindDeptListDept";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.Arg3=session.HospID;
            param.ArgCnt=3;
        },
        onChange:function(newValue,oldValue){
            $(".sur-careprov").combobox("reload");
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        editable:false
    });
    */
   $("#AppDeptID").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=CLCLS.BLL.Admission;
        param.QueryName="FindLocationOld";
        param.Arg1=param.q?param.q:"";
        param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
        param.ArgCnt=2;
    },
    onChange:function(newValue,oldValue){
    },
    valueField: "RowId",
    textField: "Description",
    mode: "remote",
    editable:false
});
//20200628+预住院科室
$("#OperExecDeptID").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=CLCLS.BLL.Admission;
        param.QueryName="FindLocationOld";
        param.Arg1=param.q?param.q:"";
        param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
        param.Arg3=session.HospID;
        param.ArgCnt=3;
    },
    valueField: "RowId",
    textField: "Description",
    mode: "remote"
    
});
    $("#SurgeonDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.Arg3=session.HospID;
            param.ArgCnt=3;
        },
        onChange:function(newValue,oldValue){
            var grid=$("#Operation").combogrid("grid");
            grid.datagrid("reload");
            $("#Surgeon").combobox("clear");
            $("#Surgeon").combobox("reload");
            $(".sur-careprov").combobox("clear");
            $(".sur-careprov").combobox("reload");
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
        //editable:false
    });
/*
    $("#SurgeonDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindDeptListDept";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.Arg3=session.HospID;
            param.ArgCnt=3;
        },
        onChange:function(newValue,oldValue){
            $("#Surgeon").combobox("reload");
            $(".sur-careprov").combobox("reload");

        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
       
    });
    */
    
    $("#AppCareProvID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=$("#AppDeptID").combobox('getValue');
            param.Arg3="";
            param.ArgCnt=3;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        readonly:true
    });
    /*
   $("#AppCareProvID").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=ANCLS.BLL.ConfigQueries;
        param.QueryName="FindResource";
        param.Arg1=param.q?param.q:"";
        param.Arg2=$("#AppDeptID").combobox("getValue");
        param.Arg3="Y";
        param.Arg4=session.HospID;
        param.ArgCnt=4;
    },
    valueField: "CareProvider",
    textField: "CareProvDesc",
    mode: "remote",
    editable:false
});
*/
/*
$("#OperDeptID").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=ANCLS.BLL.ConfigQueries;
        param.QueryName="FindDeptListDept";
        param.Arg1=param.q?param.q:"";
        param.Arg2="OP";
        param.Arg3=session.HospID;
        param.ArgCnt=3;
    },
    valueField: "RowId",
    textField: "Description",
    mode: "remote",
    editable:false
});
*/
$("#OperDeptID").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=CLCLS.BLL.Admission;
        param.QueryName="FindLocationOld";
        param.Arg1=param.q?param.q:"";
        param.Arg2="OP^OUTOP^EMOP";
        param.ArgCnt=2;
    },
    valueField: "RowId",
    textField: "Description",
    mode: "remote"
    //editable:false
});
    $("#PrevAnaMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        required: false

        // multiple: true
    });
   
    
    $("#SourceType").combobox({
        valueField:"code",
        textField:"desc",
        disabled:true,
        // editable:false,
        data:[{
            code:"B",
            desc:"择期"
        },{
            code:"E",
            desc:"急诊"
        }],
        onSelect:function(record){
            var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperDate",record.code);
            if(ret && ret.result){
                $("#OperDate").datebox("setValue",ret.result);
            }
        }
    });

    $("#ReentryOperation").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"Y",
            desc:"是"
        },{
            code:"N",
            desc:"否"
        }]
    });
    $("#IsoOperation,#ECC,#TransAutoblood,#PrepareBlood,#InfectionOper,#MIS,#Antibiosis").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"Y",
            desc:"是"
        },{
            code:"N",
            desc:"否"
        }]
        
    });
   
    $("#AnaDept").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.MethodService,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperApplication;
            param.MethodName="GetAnaDepts";
            var appDeptId=$("#AppDeptID").combobox("getValue");
            if(!appDeptId){
                appDeptId=session.DeptID;
            }
            param.Arg1=appDeptId;
            param.Arg2=session.HospID;
            param.ArgCnt=2;
        },
        mode:"remote"
    });

    $("#SeqType").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"N",
            desc:"正常台"
        },{
            code:"C",
            desc:"接台"
        }]
    });

    
    $("#OperPosition").combobox({
        multiple:true,
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.CodeQueries;
            param.QueryName="FindOperPosition";
            param.ArgCnt=0;
        }
    });

    $(".oper-require").combobox({
        valueField:"value",
        textField:"text",
        data:operApplication.yesNoOptions
    });

    $(".test-item").combobox({
        valueField:"value",
        textField:"text",
        data:operApplication.testOptions
    });

    $("#BloodType").combobox({
        valueField:"value",
        textField:"text",
        data:[{
            text:"未知",
            value:"N"
        },{
            text:"A型",
            value:"A"
        },{
            text:"B型",
            value:"B"
        },{
            text:"AB型",
            value:"AB"
        },{
            text:"O型",
            value:"O"
        }]
    });

    $("#btnSave").linkbutton({
        onClick:function(){
            saveOperApplication();
        }
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });
}

function loadAppFormData(){
    dhccl.parseDateFormat();
    $("#appForm").form("clear");
    //alert(opsId)
    setOperAppData();
    //alert("2")
    setOperList();
   
}

function setDefaultValue(){
    // 获取新增手术申请还是修改手术申请
    setDefaultPatInfo();
  
    var checkValidDayStr=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"CheckValidDayOperNew",EpisodeID);
    var newvalidstr=checkValidDayStr.split("^");
    //如果不是修改也不是确认，先判断是不是存在有效的日间申请
     if((newvalidstr[0]=="Y"))
    {
            opsId=newvalidstr[2];
      
            session.OPSID=opsId;
        }
        if((newvalidstr[0]=="N"))
        {
                opsId=newvalidstr[2];
          
                session.OPSID=opsId;
            }
    
    //20211229
    //alert(isConfirm+"|"+session.OPSID+"|"+opsId)
    
    var needAuditStr=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"CheckDayOperAnAudit",EpisodeID);
     var auditstr=needAuditStr.split("^");
     if((auditstr[1]=="Y")&&(auditstr[0]=="Y")&&(auditstr[2]=="")&&(isConfirm=="Y"))
     {
          $.messager.alert("提示","该日间申请尚未进行麻醉术前评估,不能正式确认手术申请！","error");
          $("#btnSave").linkbutton("disable");
		  $("#btnSave").css('background-color','#BBBBBB')
     }
     else if((auditstr[1]=="Y")&&(auditstr[0]=="Y")&&(auditstr[2]!="Y")&&(isConfirm=="Y"))
     {
          $.messager.alert("提示","该日间申请麻醉术前评估未通过！","warning");
          $("#btnSave").linkbutton("disable");
          $("#btnSave").css('background-color','#BBBBBB');
     }
    
    
     
    if (session.OPSID){
        operApplication.newApp=false;
     
        loadAppFormData();
        setNewAppTestResult();
        $("body").layout("remove","west");
        $(".btnList").css({"padding":"0","width":"auto"});
       
        if((newvalidstr[0]=="Y")&&newvalidstr[1]=="A")
        {
        
        $("#btnSave").linkbutton("disable");
        $("#btnSave").css('background-color','#BBBBBB');
        return;
        }
        

    }else{
        operApplication.newApp=true;
        setNewAppDefValue();
        if((newvalidstr[0]=="Y")&&newvalidstr[1]=="A")
        {
            $("#btnSave").linkbutton("disable");
        $("#btnSave").css('background-color','#BBBBBB');
        return;
        }
    }
}
//
function setDefaultPatInfo()
{
       var patDatas= dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindPatient",
            Arg1: EpisodeID,
            ArgCnt: 1
        }, "json");
            if (patDatas && patDatas.length > 0) {
             var patStr=patDatas[0];
            
              $("#PatName").prop("innerText",patStr.PatName);
              
              $("#RegNo").prop("innerText",patStr.RegNo);
             
              $("#MedcareNo").prop("innerText",patStr.MedcareNo);
            
              $("#PatAge").prop("innerText",patStr.PatAge);
             
              $("#PatDeptDesc").prop("innerText",patStr.PatDeptDesc);
              
              $("#AdmReason").prop("innerText",patStr.AdmReason);
              $("#PatGender").prop("innerText",patStr.PatGender);
              $("#PatWardDesc").prop("innerText",patStr.PatWardDesc);
             
              $("#PatBedCode").prop("innerText",patStr.PatBedCode);
                var PatGender=patStr.PatGender;
              $("#patSeximg").prop("innerText","");
              if(PatGender=="男"){
                var imghtml="<img src='../service/dhcanop/img/man.png' style='margin-top:-5px'/>";
                $("#patSeximg").append(imghtml);
            }else if(PatGender=="女"){
                var imghtml="<img src='../service/dhcanop/img/woman.png' />";
                $("#patSeximg").append(imghtml);
            }
            $("#EpisodeID").val(patStr.EpisodeID);
            $("#PatDeptID").val(patStr.PatDeptID);
            $("#PatWardID").val(patStr.PatWardID);
            $("#PatBedID").val(patStr.PatBedID);
            $("#PatDOB").val(patStr.PatDOB);
            $("#CardID").val(patStr.CardID);

            $("#AdmDate").val(patStr.AdmDate);


            }

}
function setNewAppDefValue(){
    // 获取默认手术室
    var retoutinloc=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"GetOutLinkInLocId",session.DeptID);
    $("#SurgeonDeptID").combobox("setValue",retoutinloc);
    $("#OperExecDeptID").combobox("setValue",retoutinloc);   //预住院科室

    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"GetDefOperDeptID",retoutinloc);
    $("#OperDeptID").combobox("setValue",ret);
    
    // 获取择期手术是否已截止
     $("#SourceType").combobox("setValue","B")
    
     
    var sourceType=$("#SourceType").combobox("getValue");
    setOperDate(sourceType);

    // 默认手术申请科室为本科室
    $("#AppDeptID").combobox("setValue",session.DeptID);
   
    $("#AppCareProvID").combobox("reload");
    // 默认手术申请医生为当前登录的医护人员
    $("#AppCareProvID").combobox("setValue",session.CareProvID);

    // 默认手术时间为早上8:00
    $("#OperTime").timespinner("setValue","08:00")

    // 默认手术时长为2小时
    $("#OperDuration").numberspinner("setValue",2)

    // 台次类型默认正常台
    $("#SeqType").combobox("setValue","N");

    // 检验项目默认值为未知
    //$(".test-item").combobox("setValue","");
   // $("#BloodType").combobox("setValue","");
// 检验项目结果取自检验组
    setNewAppTestResult();
    $("#AppUserID").val(session.UserID);

    $("#PlanSeq").numberspinner("setValue",1);

    $("#ReentryOperation").combobox("setValue","N");

    $("#Anaesthesia").combobox("setValue","Y");
    setPrevDiagnosis();
}
function setNewAppTestResult(){
	var standardItem="BloodType"+"^"+"RHBloodType"+"^"+"HbsAg"+"^"+"HcvAb"+"^"+"HivAb"+"^"+"Syphilis"+"^"+"MDROS";
	var standardCode="ABO"+"^"+"RH"+"^"+"HbsAg"+"^"+"HCV-Ab"+"^"+"HIV-Ab"+"^"+"TPAb"+"^"+"MDROS";
    var standardItemArr=standardItem.split("^");
    var standardCodeArr=standardCode.split("^");

    var opdate=$("#OperDate").datebox("getValue");
	for(var i=0;i<standardCodeArr.length;i++){
		var TestItemData=dhccl.runServerMethod("web.DHCClinicCom","GetTestResult",EpisodeID,"","",standardCodeArr[i],dateAddDays(opdate,-27),"00:00",opdate,"00:00");
        var TestItemDataArr=TestItemData.result.split(splitchar.two);
		switch (TestItemDataArr[0]){
			case "A型":
			TestItemData="A";
			break;
			case "B型":
			TestItemData="B";
			break;
			case "AB型":
			TestItemData="AB";
			break;
			case "O型":
			TestItemData="O";
			break;
			case "阴性(-)":
			TestItemData="-";
			break;
			case "阳性(+)":
			TestItemData="+";
			break;
			default:
            var reg = /^[0-9]+.?[0-9]*$/;
            if (reg.test(TestItemDataArr[0])) {
				var min=TestItemDataArr[2].split("-")[0];
				var max=TestItemDataArr[2].split("-")[1]
				if((parseInt(TestItemDataArr[0])>=parseInt(min))&&(parseInt(TestItemDataArr[0])<=parseInt(max))) TestItemData="-";
				else TestItemData="+";
			}
			else TestItemData="N";
			break;
		}
		$("#"+standardItemArr[i]).combobox("setValue",TestItemData);
	}
}
function setOperAppData(){
    //alert(session.OPSID)
    var appDatas=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperScheduleList,
        QueryName:"FindOperScheduleList",
        Arg1:"",
        Arg2:"",
        Arg3:"",
        Arg4:session.OPSID,
        ArgCnt:4
    },"json");
    if(appDatas && appDatas.length>0){
        var appData=appDatas[0];
        $("#appForm").form("load",appData);
        $("#AppCareProvID").combobox("reload");
        //术前诊断
        if(appData.PrevDiagnosis){
            /*
            var diagArr=appData.PrevDiagnosis.split(",");
            var diagObjects=[];
            for(var i=0;i<diagArr.length;i++){
                diagObjects.push({
                    DiagID:"",
                    DiagDesc:diagArr[i]
                });
            }
            $("#preopDiagBox").datagrid("loadData",diagObjects);
            */
           //20210506+dyl
            var prevDiagnosisDesc=appData.PrevDiagnosis;
            if(prevDiagnosisDesc)
            {
                var diagListArr=prevDiagnosisDesc.split("&&&"),diagList=[];
             for(var i=0;i<diagListArr.length;i++){
                var diagArr=diagListArr[i].split("###");
                diagList.push({
                    DiagID:diagArr[0],
                    DiagDesc:diagArr[1]
                   // DiagNote:diagArr[2]
                });
                }
                $("#preopDiagBox").datagrid("loadData",diagList);
            }
        }

        // 手术部位
        /*
        if(appData.BodySite){
            var bodySiteArr=appData.BodySite.split(",");
            //$("#BodySite").combobox("setValues",bodySiteArr);
        }
        */
        $("#Surgeon").combobox("setValue","");
       $("#BodySite").combobox("setValue","");
       $("#Operation").combogrid("setValue","");
        // 手术体位
        if(appData.OperPosition){
            var operPosArr=appData.OperPosition.split(",");
            $("#OperPosition").combobox("setValues",operPosArr);
        }
    }
}

function setOperList(){
    var operList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperationList,
        QueryName:"FindOperationList",
        Arg1:session.OPSID,
        ArgCnt:1
    },"json");
    if(operList && operList.length>0)
    {
        $("#operationBox").datagrid("loadData",operList);
    }
    
    $("#OperNote").val("");  //YuanLin 20200212 需单独处理一次
    $("#SurgeonExpert").val("");
}

function setPrevDiagnosis(){
   
    $("#preopDiagBox").datagrid("loadData",[]);
    var admDiagnosisList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:CLCLS.BLL.Admission,
        QueryName:"FindAdmDiagnosis",
        Arg1:EpisodeID,
        Arg2:"",
        ArgCnt:2
    },"json");
    if(admDiagnosisList && admDiagnosisList.length>0)
    {
        $("#preopDiagBox").datagrid("loadData",admDiagnosisList);
    }
}

function setOperDate(sourceType){
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"GetOperDate",sourceType);
    if(ret && ret.result){
        $("#OperDate").datebox("setValue",ret.result);
    }
}

function initDiagButtons(){
    $("span.diagEditBtns .edit-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            editDiagnosis(index);
        }
    });

    $(".diagSaveBtns .save-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            saveDiagnosis(index);
        },
        disabled:true
    });

    $(".diagRemoveBtns .remove-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            removeDiagnosis(index);
        }
    });
}

function addDiagnosis(){
    
    
    var diagnosis={
        DiagID:$("#Diagnosis").combogrid("getValue"),
        DiagDesc:$("#Diagnosis").combogrid("getText")
    };
    if(!diagnosis.DiagID && !diagnosis.DiagDesc){
        $.messager.alert("提示","请先选择诊断字典，再添加。","warning");
        return;
    }
    var preopDiagList=$("#preopDiagBox").datagrid("getRows");
    for(var i=0;i<preopDiagList.length;i++){
        var planPreopDiag=preopDiagList[i];
        if(diagnosis.DiagID==planPreopDiag.DiagID){
            $.messager.alert("提示","该诊断已添加，请重新选择。","warning");
            return;
        }
    }
    $("#preopDiagBox").datagrid("appendRow",diagnosis);
    $("#Diagnosis").combogrid("clear");
}

function editDiagnosis(index){
    var selectedDiag=$("#preopDiagBox").datagrid("getSelected");
    if(!selectedDiag){
        $.messager.alert("提示","请先选择一条术前诊断记录，再修改。","warning");
        return;
    }
    var selectedIndex=$("#preopDiagBox").datagrid("getRowIndex",selectedDiag);
    var diagnosis={
        DiagID:$("#Diagnosis").combogrid("getValue"),
        DiagDesc:$("#Diagnosis").combogrid("getText")
    };
    if(!diagnosis.DiagID && !diagnosis.DiagDesc){
        $.messager.alert("提示","请先选择诊断字典，再修改。","warning");
        return;
    }
    var preopDiagList=$("#preopDiagBox").datagrid("getRows");
    for(var i=0;i<preopDiagList.length;i++){
        var planPreopDiag=preopDiagList[i];
        if(diagnosis.DiagID==planPreopDiag.DiagID){
            $.messager.alert("提示","该诊断已添加，请重新选择。","warning");
            return;
        }
    }
    $("#preopDiagBox").datagrid("updateRow",{
        index:selectedIndex,
        row:diagnosis
    });
}

function removeDiagnosis(index){
    var selectedDiag=$("#preopDiagBox").datagrid("getSelected");
    if(!selectedDiag){
        $.messager.alert("提示","请先选择一条术前诊断，再删除。","warning");
        return;
    }
    var selectedIndex=$("#preopDiagBox").datagrid("getRowIndex",selectedDiag);
    $.messager.confirm("提示","是否删除选择的术前诊断?",function(r){
        if(r){
            $("#preopDiagBox").datagrid("deleteRow",selectedIndex);
            $("#Diagnosis").combogrid("clear");
        }
    });
}

function getDiagnosisOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMRCDiagnosis";
            param.Arg1=param.q?param.q:"";
            param.ArgCnt = 1;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"诊断描述",width:400}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,record){
            
        }
    }
}

function getOperationOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "";
            param.Arg3 = "";
            param.ArgCnt = 3;
        },
        panelWidth:450,
        idField: "RowId",
        textField: "Description",
        columns:[[
            {field:"RowId",title:"ID",hidden:true},
            {field:"Description",title:"名称",width:240},
            {field:"OperClassDesc",title:"分级",width:60},
            {field:"ICDCode",title:"ICD",width:120}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,record){
            
        }
    }
}

function getOperClassOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperClass";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function getSurgeonDeptOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function getSurgeonOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function getAssistantOptions(){
    return {
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt=2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    }
}

function initOperButtons(){
    $(".operEditBtns .edit-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            editOperation(index);
        }
    });

    $(".operSaveBtns .save-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            saveOperation(index);
        },
        disabled:true
    });

    $(".operRemoveBtns .remove-btns").linkbutton({
        onClick:function(){
            var index=$(this).attr("data-rowindex");
            removeOperation(index);
        }
    });
}

function genOperation(){
    var formData=$("#operationForm").serializeJson();
    //var surAssistant=formData.Assistant1+","+formData.Assistant2+","+formData.Assistant3+","+formData.Assistant4+","+formData.Assistant5;
    var assis1Desc=$("#Assistant1").combobox("getText"),
        assis2Desc=$("#Assistant2").combobox("getText"),
        assis3Desc=$("#Assistant3").combobox("getText");
    
    var surAssisDesc=assis1Desc;
    if(assis2Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis2Desc;
    }
    if(assis3Desc){
        if(surAssisDesc) surAssisDesc+=",";
        surAssisDesc+=assis3Desc;
    }
    var surAssistant=formData.Assistant1;
    if (formData.Assistant2){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant2;
    }
    if (formData.Assistant3){
        if(surAssistant) surAssistant+=",";
        surAssistant+=formData.Assistant3;
    }

    formData.Assistant=surAssistant;
    formData.AssistantDesc=surAssisDesc;
    formData.OperationDesc=$("#Operation").combogrid("getText");
    formData.OperClassDesc=$("#OperClass").combobox("getText");
    formData.SurgeonDesc=$("#Surgeon").combobox("getText");
    formData.BodySiteDesc=$("#BodySite").combobox("getText");
    formData.BladeTypeDesc=$("#BladeType").combobox("getText");
    formData.SurgeonDeptDesc=$("#SurgeonDeptID").combobox("getText");
    return formData;
}

function addOperation(){
    if(!$("#operationForm").form("validate")) return;
    
	var Operation = $("#Operation").combogrid("grid").datagrid("getSelected");
	if (Operation == null || Operation == undefined){
        $.messager.alert("提示","请选择手术名称，不允许手写填入。","warning");
        return;
    }
   var lastSurgeonLocId=$("#SurgeonDeptID").combobox("getValue");
    var lastSurgeonLoc=$("#SurgeonDeptID").combobox("getText");
    var operList=$("#operationBox").datagrid("getRows");
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        if(Operation.RowId==planOperation.Operation){
            $.messager.alert("提示","该手术已添加，请重新选择。","warning");
            return;
        }
    }
	if($("#Operation").combogrid("getValue")==""){
        $.messager.alert("提示","请先选择手术名称，再进行添加。","warning");
        return;
	}
    if($("#OperClass").combobox("getValue")==""){
        $.messager.alert("提示","请先选择手术分级，再进行添加。","warning");
        return;
	}
	if(($("#BodySite").combobox("getValue")=="")){
        $.messager.alert("提示","请先选择手术部位，再进行添加。","warning");
        return;
    }
    if(($("#BladeType").combobox("getValue")=="")){
        $.messager.alert("提示","请先选择切口类型，再进行添加。","warning");
        return;
	}
    var formData=genOperation();
    formData.RowId="";
    $("#operationBox").datagrid("appendRow",formData); 
    $("#operationForm").form("clear");
    $("#SurgeonDeptID").combobox("setValue",lastSurgeonLocId);
    $("#SurgeonDeptID").combobox("setText",lastSurgeonLoc);
}

function editOperation(index){
    var selectedOperation=$("#operationBox").datagrid("getSelected");
    if(!selectedOperation){
        $.messager.alert("提示","请先选择一条手术，再修改。","warning");
        return;
    }
    var selectedIndex=$("#operationBox").datagrid("getRowIndex",selectedOperation);
    var formData=genOperation();
    var lastSurgeonLocId=$("#SurgeonDeptID").combobox("getValue");
    var lastSurgeonLoc=$("#SurgeonDeptID").combobox("getText");
    formData.RowId=selectOperation.RowId;
    $("#operationBox").datagrid("updateRow",{
        index:selectedIndex,
        row:formData
    });
    $("#operationForm").form("clear");
    $("#SurgeonDeptID").combobox("setValue",lastSurgeonLocId);
    $("#SurgeonDeptID").combobox("setText",lastSurgeonLoc);
}

function removeOperation(index){
    var selectedOperation=$("#operationBox").datagrid("getSelected");
    if(!selectedOperation){
        $.messager.alert("提示","请先选择一条手术，再修改。","warning");
        return;
    }
    var selectedIndex=$("#operationBox").datagrid("getRowIndex",selectedOperation);
    $.messager.confirm("提示","是否删除选择的手术?",function(r){
        if(r){
            if(selectedOperation.RowId){
                $("#operationBox").datagrid("deleteRow",selectedIndex);
                $("#operationForm").form("clear");
            }else{
                $("#operationBox").datagrid("deleteRow",selectedIndex);
                $("#operationForm").form("clear");
            }
        }
    });
}

function selectOperation(index,row){
    if(row){
        $("#operationForm").form("load",row);
        $("#Operation").combogrid("setText",row.OperationDesc);
        $("#Surgeon").combobox("setText",row.SurgeonDesc);
        
        if(row.Assistant){
            var assisArr=row.Assistant.split(",");
            var assisDescArr=row.AssistantDesc.split(",");
            for(var i=0;i<assisArr.length;i++){
                var assisIndex=i+1;
                $("#Assistant"+assisIndex).combobox("setValue",assisArr[i]);
                $("#Assistant"+assisIndex).combobox("setText",assisDescArr[i]);
            }
        }
		else{
			$("#Assistant1").combobox("setValue","");
			$("#Assistant1").combobox("setText","");
			$("#Assistant2").combobox("setValue","");
			$("#Assistant2").combobox("setText","");
			$("#Assistant3").combobox("setValue","");
			$("#Assistant3").combobox("setText","");
		}
    }
}


function existsApplication(){
   
    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"ExistsOperApplication",EpisodeID);
    if(ret && ret.indexOf("Y")===0){
        return true;
    }

    return false;
}

function saveOperApplication(){
    var PrevAnaMethod=$("#PrevAnaMethod").combobox("getValues");
    if(PrevAnaMethod.length==0){
        $.messager.alert("提示","请选择拟施麻醉，不允许手写填入。","warning");
        return;
    }
    if(!$("#appForm").form("validate")) return;
    var appData=$("#appForm").serializeJson();
   
    appData.ClassName=ANCLS.Model.OperSchedule;
    appData.RowId=session.OPSID?session.OPSID:"";
   
    if (operApplication.newApp){
        //20200602+dyl+预住院科室
        //var needPreLoc=$("#PatDeptID").val();
        //appData.OperExecDeptID=needPreLoc;
		 appData.AppUserID=session.UserID;	//20211021
    }
    //appData.BodySite=$("#BodySite").combobox("getValues").join(",");
    appData.OperPosition=$("#OperPosition").combobox("getValues").join(",");
    if(!appData.OperPosition) {
        $.messager.alert("提示","手术体位不能为空","warning");
        return;
    }
    if($("#OperExecDeptID").combobox("getValue")=="")
    {
        $.messager.alert("提示","日间预住院科室不能为空","warning");
        return; 
    }
    
    if(!appData.OperDate) {
        $.messager.alert("提示","手术日期不能为空，请选择好手术日期之后，再保存手术申请。","warning");
        return;
    }
    if(!appData.OperTime) {
        $.messager.alert("提示","手术时间不能为空，请填写好手术时间之后，再保存手术申请。","warning");
        return;
    }
    appData.EpisodeID=EpisodeID;
    appData.PatName=$("label#PatName").text();
    appData.PatGender=$("label#PatGender").text();
   
    appData.DaySurgery="Y";
    //alert("?")
    appData.RegNo=$("label#RegNo").text();
    appData.OPAdmType="IOP";
    appData.OperExecDeptID=$("#OperExecDeptID").combobox("getValue");
    // 拟施手术
    var operList=$("#operationBox").datagrid("getRows");
    if(!operList || operList.length<=0){
        $.messager.alert("提示","未添加拟施手术，请添加好拟施手术之后，再保存手术申请。","warning");
        return;
    }
    if(isConfirm=="Y")
    {
        var checkSurStr="";
        appData.StatusCode="Application"; 
        for(var ic=0;ic<operList.length;ic++){
            var planOperation=operList[ic];
            planOperation.ClassName=ANCLS.Model.PlanOperList;
           if(checkSurStr!="") checkSurStr=checkSurStr+"^"+planOperation.SurgeonDesc;
           else{
            checkSurStr=planOperation.SurgeonDesc;
           }
        } 
       if(checkSurStr=="")
       {
        $.messager.alert("提示","日间手术确认需选择主刀医师，请修改拟施手术信息","error");  
        return;
       }
        
    }
    else{
        appData.StatusCode="DaySurgery";   //20200217+dyl
    }
    
    // 术前诊断
    var diagList=$("#preopDiagBox").datagrid("getRows");
    if(!diagList || diagList.length<=0){
        $.messager.alert("提示","未添加术前诊断，请添加好术前诊断之后，再保存手术申请。","warning");
        return;
    }
    var diagInfo=getPreopDiag();
    appData.PrevDiagnosis=diagInfo;
    // 拟施手术
    var dataArr=[];
    dataArr.push(appData);
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        planOperation.ClassName=ANCLS.Model.PlanOperList;
        dataArr.push(planOperation);
    }

    // 实施手术
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        var operation={};
        for(var property in planOperation){
            operation[property]=planOperation[property];
        }
        operation.ClassName=ANCLS.Model.OperList;
        dataArr.push(operation);
    }
   
    var warninginfo="";
    if(isConfirm=="Y")
    {
        warninginfo="日间手术确认成功，是否关闭页面？";
    }
    else{
        warninginfo="日间手术修改成功，是否关闭页面？";
        
    }
    var dataPara=dhccl.formatObjects(dataArr);
    var ret=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"SaveOperApplication",dataPara,isConfirm,"",session.UserID);
    if(ret.success){
        if(operApplication.newApp){
            $.messager.alert("提示","保存日间手术申请成功。","info",function(){
                // $("#appForm").form("clear");
                // $("#patientsList").datagrid("clearSelections");
                window.close();
                window.location.reload();
            });
        }else{
           
            $.messager.confirm("提示",warninginfo,function(r){
                if(r){
                    //window.location.reload();
                    if(window.parent.closeDaySurgeryDialog){
                        window.parent.closeDaySurgeryDialog();
                    }else{
                        window.close();
                    }
                
                }else{
                    loadAppFormData(); 
                }
            });
        }
        
        
    }else{
        $.messager.alert("提示","保存日间手术申请失败，原因："+ret.result,"error");
    }
}

function getPreopDiag(){
    //20210506+dyl
    var diagList=$("#preopDiagBox").datagrid("getRows");
    var ret="";
    if(diagList &&diagList.length>0){
        for(var i=0;i<diagList.length;i++){
            var diag=diagList[i];
            if(ret!=""){
                ret+="&&&";
            }
            ret+=diag.DiagID+"###"+diag.DiagDesc+"###"+'';
           // ret+=diag.DiagDesc;
        }
    }

    return ret;
}

function ClearAppData(){
	var rows = $("#operationBox").datagrid('getRows');
	for(var i=0;i<rows.length;i++){
		$("#operationBox").datagrid('deleteRow',i);
	}
	$("#operationForm").form("clear");
	
	//手术部位
	//$("#BodySite").combobox("setValues","");
	
	//手术体位
	$("#OperPosition").combobox("setValues","");
	
	//实习进修
	$("#SurIntership").val("");
	
	//参观人员
	$("#SurVisitors").val("");
	
	//仪器要求
	$("#SurgicalMaterials").val("");
	
	//特殊情况
	$("#SpecialConditions").val("");
	
	//高值耗材
	$("#HighConsume").val("");
	
	//隔离手术
	$("#IsoOperation").combobox("setValues","");
	
	//体外循环
	$("#ECC").combobox("setValues","");
	
	//自体血回输
	$("#TransAutoblood").combobox("setValues","");
	
	//备血
	$("#PrepareBlood").combobox("setValues","");
	
	//感染手术
	$("#InfectionOper").combobox("setValues","");
	
	//微创手术
	$("#MIS").combobox("setValues","");
	
	//使用抗生素
	$("#Antibiosis").combobox("setValues","");
}

function getEpisodeByMenu(){
    var EpisodeID="";
	/*
    var isSet = false;
    var frm = window.parent.parent.document.forms['fEPRMENU'];
    if (frm) {
        EpisodeID=frm.EpisodeID.value;
        isSet = true;
    }
    if (isSet == false) {
        var frm = dhcsys_getmenuform();
        if (frm) {
            EpisodeID=frm.EpisodeID.value
        }
    }
    
    return EpisodeID;
	*/

    EpisodeID=dhccl.getQueryString("EpisodeID");
    if(EpisodeID == null)
    {
        var frm = window.parent.parent.document.forms['fEPRMENU'];
        if (frm) {
            EpisodeID=frm.EpisodeID.value;
        }
       
    }
    return EpisodeID;
}

function dateAddDays(dateStr,dayCount){
	var tempDate=new Date(dateStr.replace(/-/g,"/"));
	var resultDate=new Date((tempDate/1000+(86400*dayCount))*1000);
	var resultDateStr=resultDate.getFullYear()+"-"+(resultDate.getMonth()+1)+"-"+(resultDate.getDate());
    return resultDateStr;
}

$(document).ready(initPage);

