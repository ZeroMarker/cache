var operApplication={
    newApp:true,
    editableStatus:"Application",
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
var PatAppDatas=dhccl.getDatas(ANCSP.DataQuery,{
    ClassName:ANCLS.BLL.OperScheduleList,
    QueryName:"FindOperScheduleList",
    Arg1:"",
    Arg2:"",
    Arg3:"",
    Arg4:session.OPSID,
    ArgCnt:4
},"json");
if(PatAppDatas && PatAppDatas.length>0){
    var PatAppData=PatAppDatas[0];
}
function initPage(){
    $(".spinner-text").each(function(index,item){
        var spinnerWidth=$(item).width();
        $(item).css("width",(spinnerWidth-5)+"px");
    });
    dhccl.parseDateFormat();
    //设置默认值
    initAppForm();
    setDefaultValue();
}
var outOper={
    schedule:null,
    contextMenu:null,
    contextMenuD:null,
    clickColumn:null
};
/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    outOper.schedule=operApplication;
}
/**
 * 初始化手术申请表单
 */
function initAppForm(){
    initOperBox();
    
    initAppFormOptions();
    loadAppFormData();
   
}

function initOperBox(){
   
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
        {field:"AssistantDesc",title:"助手",width:140}
        //{field:"SurgeonExpert",title:"外院专家",width:80}
    ]];

    $("#SurgeonDeptID").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindLocationOld";
            param.Arg1=param.q?param.q:"";
            param.Arg2="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt=2;
        },
        onChange:function(newValue,oldValue){
            $("#Surgeon").combobox("clear");
            $("#Surgeon").combobox("reload");
            $(".sur-careprov").combobox("clear");
            $(".sur-careprov").combobox("reload");
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });
    $("#Operation").combogrid({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.Operation;
            param.QueryName = "FindOperation";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 =  $("#Surgeon").combobox("getValue");
            param.Arg3 = $("#SurgeonDeptID").combobox("getValue");
            param.Arg4 ="";
            param.ArgCnt = 4;
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
            if(!operApplication.selectedPat) return;
            try{
                var EpisodeID=operApplication.selectedPat.EpisodeID;
                var operId=record.ExternalID;
                var userInfo=session.UserID+"^"+session.DeptID+"^"+session.GroupID;
                /*
                var checkValidStr=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"CheckOperValid",EpisodeID,operId,userInfo);
                var checkValidDatas=JSON.parse(checkValidStr);
                var checkValidData=checkValidDatas[0];
                if(checkValidData.passFlag!=="1"){
                    if(checkValidData.manLevel==="C"){
                        $.messager.alert("管制提示","该手术不符合临床知识库管控要求，不能申请！","error");
                        var grid=$(this).combogrid("grid");
                        grid.datagrid("unselectRow",rowIndex);
                        $(this).combogrid("clear");
                    }else if(checkValidData.manLevel==="W"){
                        $.messager.alert("警示","该手术不符合临床知识库管控要求！","warning");
                    }else if(checkValidData.manLevel==="W"){
                        $.messager.alert("提示","该手术不符合临床知识库管控要求！","info");
                    }
                }
                */
                $("#OperClass").combobox("setValue",record.OperClass);
                $("#BladeType").combobox("setValue",record.BladeType);
                $("#BodySite").combobox("setValue",record.BodySite);
                $("#BodySite").combobox("reload");
            }catch(ex){

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
   
    //var surLocId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetPlanSurLocId",session.OPSID);
    //var 
        $("#Surgeon").combobox({
            url: ANCSP.DataQuery,
            onBeforeLoad: function(param) {
                param.ClassName=ANCLS.BLL.ConfigQueries;
                param.QueryName="FindSurgeonByOper";
                param.Arg1=param.q?param.q:"";
                param.Arg2=$("#SurgeonDeptID").combobox("getValue");
                if(!param.Arg2){
					if(PatAppDatas && PatAppDatas.length>0){
						param.Arg2=PatAppDatas[0].AppDeptID   //session.DeptID;
					}
				}
                param.Arg3="Y";
                param.Arg4 = session.HospID;
                param.Arg5 = $("#Operation").combobox("getValue");
                param.ArgCnt=5;
            },
            // panelWidth:450,
            valueField: "Code",
            textField: "Description",
            // columns:[[
            //     {field:"RowId",title:"ID",hidden:true},
            //     {field:"CareProvDesc",title:"医护姓名",width:240},
            //     {field:"DeptDesc",title:"所在科室",width:200}
            // ]],
            mode: "remote"
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
			if(PatAppDatas && PatAppDatas.length>0){
				param.Arg2=PatAppDatas[0].AppDeptID   //session.DeptID;
			}
		}
        param.ArgCnt=2;
    },
    // panelWidth:450,
    valueField: "RowId",
    textField: "Description",
    
    mode: "remote"
});
    $("#operationBox").datagrid({
        width: 1026,
        height: 250,
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

function getOrdNo(){
	var maxOrdNo=30
	var data=new Array();
	for(var i=0;i<maxOrdNo;i++)
	{
		var no=i+1;
		var obj=new Object();
		obj={
			code:no,
			desc:no
			}
		data[i]=obj;
	}
	return data;	
}

function initAppFormOptions(){
    /*
    $("#AppDeptID,#SurgeonDeptID").combobox({
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
$("#OperDeptID").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=ANCLS.BLL.ConfigQueries;
        param.QueryName="FindDeptListDept";
        param.Arg1=param.q?param.q:"";
        param.Arg2="OP^OUTOP^EMOP";
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
    mode: "remote",
    editable:false
});
    $("#AnaMethod").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestMethod";
            param.Arg1 = "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description"
        //required: true
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
    /*
    $("#CircualNurse").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindResource";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = session.DeptID;
            param.Arg3="N";
            param.Arg4=session.HospID;
            param.ArgCnt=4;
        },
        valueField: "CareProvider",
        textField: "CareProvDesc",
        mode: "remote"
    });
    */
   $("#CircualNurse").combobox({
    url: ANCSP.DataQuery,
    onBeforeLoad:function(param){
        param.ClassName=CLCLS.BLL.Admission;
        param.QueryName="FindCareProvByLoc";
        param.Arg1=param.q?param.q:"";
        param.Arg2=$("#OperDeptID").combobox('getValue');
        param.ArgCnt=2;
    },
    valueField: "RowId",
    textField: "Description",
    mode: "remote"
    //readonly:true
});
	//手术间 20191231 YuanLin
	$("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = $("#OperDeptID").combobox('getValue');
            param.Arg2="R";
            param.ArgCnt = 2;
        },
        mode: "remote"
    });

    $("#OperSeq").combobox({
        valueField:'code',
        textField:'desc',
        data:getOrdNo()
        
    });
    $HUI.timespinner("#OperTime,#comeHosTime,#TheatreInTime,#TheatreOutTime",{ 
    });
    $("#btnSavePersonInfo").linkbutton({
        onClick:function(){
            SavePersonalInfo();
        }
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
    $("#appForm").form("clear");
    setOperAppData();
    setOperList();
    
    
}

function setDefaultValue(){
    // 获取新增手术申请还是修改手术申请
    setDefaultPatInfo();
    if (session.OPSID){
        operApplication.newApp=false;
        $("#OperRoom").combobox("reload");
        $("#CircualNurse").combobox("reload");
        $("body").layout("remove","west");
        $(".btnList").css({"padding":"0","width":"auto"});
    }
}
//
function setDefaultPatInfo()
{
    //alert(EpisodeID)
        var banner=operScheduleBanner.init('#patinfo_banner', {});
        dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindPatient",
            Arg1: EpisodeID,
            ArgCnt: 1
        }, "json", true, function(appDatas) {
            if (appDatas && appDatas.length > 0) {
                banner.loadData(appDatas[0]);
                $("#btnOperList").hide();
            }
        });
    
}

function setOperAppData(){
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
         $("#AnaDept").combobox("reload");
         var tmpStDateStr=appData.OperStartDT;
         var tmpEndDateStr=appData.OperFinishDT;
         //alert(tmpStDateStr+"|"+tmpEndDateStr)
         if(tmpStDateStr!="")
         {
            $("#TheatreInDate").datebox("setValue",tmpStDateStr.split(" ")[0]);
            $("#TheatreInTime").timespinner("setValue",tmpStDateStr.split(" ")[1]);
         }
         if(tmpEndDateStr!="")
         {
            $("#TheatreOutDate").datebox("setValue",tmpEndDateStr.split(" ")[0]);
            $("#TheatreOutTime").timespinner("setValue",tmpEndDateStr.split(" ")[1]);
         }
        // 手术部位
        if(appData.BodySite){
            var bodySiteArr=appData.BodySite.split(",");
            $("#BodySite").combobox("setValues",bodySiteArr);
        }
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
    $("#Operation").combogrid("setValues","");
    $("#BodySite").combobox("setValues","");
}

function setOperDate(sourceType){
    var ret=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"GetOperDate",sourceType);
    if(ret && ret.result){
        $("#OperDate").datebox("setValue",ret.result);
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
        assis2Desc="",
        assis3Desc="";
    //$("#Assistant2").combobox("getText")
    //$("#Assistant3").combobox("getText")
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
	if($("#Operation").combogrid("getValue")==""){
        $.messager.alert("提示","请先选择手术名称，再进行添加。","warning");
        return;
	}
    if($("#OperClass").combobox("getValue")==""){
        $.messager.alert("提示","请先选择手术分级，再进行添加。","warning");
        return;
	}
	if($("#Surgeon").combobox("getValue")==""){
        //$.messager.alert("提示","请先选择主刀医生，再进行添加。","warning");
        //return;
	}
    var formData=genOperation();
    formData.RowId="";
    $("#operationBox").datagrid("appendRow",formData); 
    $("#operationForm").form("clear");
}

function editOperation(index){
    var selectedOperation=$("#operationBox").datagrid("getSelected");
    if(!selectedOperation){
        $.messager.alert("提示","请先选择一条手术，再修改。","warning");
        return;
    }
    var selectedIndex=$("#operationBox").datagrid("getRowIndex",selectedOperation);
    var formData=genOperation();
    formData.RowId=selectOperation.RowId;
    $("#operationBox").datagrid("updateRow",{
        index:selectedIndex,
        row:formData
    });
    $("#operationForm").form("clear");
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
    }
}


function existsApplication(){
    
    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"ExistsOperApplication",EpisodeID);
    if(ret && ret.indexOf("Y")===0){
        return true;
    }

    return false;
}

function saveOperApplication(){
    
    if(!$("#appForm").form("validate")) return;
    var appData=$("#appForm").serializeJson();
   
    appData.ClassName=ANCLS.Model.OperSchedule;
    appData.RowId=session.OPSID?session.OPSID:"";
    //appData.BodySite=$("#BodySite").combobox("getValues").join(",");
    appData.OperPosition=$("#OperPosition").combobox("getValues").join(",");
    if(!appData.OperDate) {
        $.messager.alert("提示","手术日期不能为空，请选择好手术日期之后，再保存手术。","warning");
        return;
    }
    appData.EpisodeID=EpisodeID;
   
    appData.OPAdmType="OOP";
    // 拟施手术
    var operList=$("#operationBox").datagrid("getRows");
    if(!operList || operList.length<=0){
        $.messager.alert("提示","未添加拟施手术，请添加好拟施手术之后，再保存手术。","warning");
        return;
    }
    
        var checkSurStr="";
        appData.StatusCode="Finish"; 
     
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
        $.messager.alert("提示","手术登记需选择主刀医师，请修改手术信息","error");  
        return;
       }
    // 实施手术
   
    var dataArr=[];
    
    dataArr.push(appData);
    for(var i=0;i<operList.length;i++){
        var planOperation=operList[i];
        var operation={};
        for(var property in planOperation){
            operation[property]=planOperation[property];
        }
        operation.ClassName=ANCLS.Model.OperList;
        dataArr.push(operation);
    }

    var dataPara=dhccl.formatObjects(dataArr);
    var ret=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"SavePatientInfo",dataPara);
    if(ret.success){
       //入室/离室/入区/离区
    var TheatreInDate=$("#TheatreInDate").datebox("getValue");
    var TheatreInTime=$("#TheatreInTime").timespinner("getValue");
    var TheatreInDT=TheatreInDate+" "+TheatreInTime;
    var TheatreOutDate=$("#TheatreOutDate").datebox("getValue");
    var TheatreOutTime=$("#TheatreOutTime").timespinner("getValue");
    var TheatreOutDT=TheatreOutDate+" "+TheatreOutTime;
    var AreaInDT="";
    var AreaOutDT="";
    var result=dhccl.runServerMethod(ANCLS.BLL.DaySurgery,"SaveOperEventDT",session.OPSID,TheatreInDT,TheatreOutDT,"","",session.UserID);
            var warninginfo="";
                warninginfo="门诊手术登记成功";
            $.messager.confirm("提示",warninginfo,function(r){
                if(r){
                  
                    if(window.parent.closeOutOperDialog){
                        window.parent.closeOutOperDialog();
                    }else{
                        loadAppFormData();
                    }
                
                }else{
                   
                    loadAppFormData(); 
                }
            });
           
    }else{
        $.messager.alert("提示","保存门诊手术登记失败，原因："+ret.result,"error");
    }
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
	//$("#SurIntership").val("");
	
	//参观人员
	//$("#SurVisitors").val("");
	
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
	
	var dhc={
		/*
		获取url传递的参数值
		*/
		getUrlParam:function(name)
		{
			var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
			var r = window.location.search.substr(1).match(reg);
			if (r != null) return unescape(r[2]);
			return null;
		}	
	}
    EpisodeID=dhc.getUrlParam("EpisodeID");
    return EpisodeID;
}
function SavePersonalInfo()
{
    var userId=session.UserID;
    var userLocId=session.DeptID;
    var personalInfo=$("#PatNeedNotice").val();
    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.DaySurgery,"SavePersonalInfo",userId,userLocId,personalInfo);
    //if(ret)
}


$(document).ready(initPage);

