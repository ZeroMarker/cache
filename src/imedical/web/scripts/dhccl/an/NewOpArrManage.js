var dhccl={
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

var EpisodeID=dhccl.getUrlParam("EpisodeID");
var opaId=dhccl.getUrlParam("opaId"); 
var appType=dhccl.getUrlParam("appType"); 
var loadwardflag=0;
var loadanflag=0;
var loadopflag=0;
var selTabIndex=0;
var patInfo="";
var appList="";
var selectOperIndex="";
var operloadflag=0;
var applocid="";
var applocdesc="";
//var starttime=new Date(); 
var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];

$(function(){
	InitForm();
	//var starttime2=new Date();
	//alert("加载完全用时"+(starttime2-starttime)) 
});
function InitForm()
{	
	if(appType=="anaes")
        {
	        selTabIndex=1;
	        $("#paneltitle").prop("innerText","麻醉安排");
	        $("#btnSave").linkbutton('disable');
	        $("#btnOpSave").linkbutton('disable');
    	}
    	else if(appType=="op")
        {
	        $("#paneltitle").prop("innerText","手术安排");
	        selTabIndex=2;
	        $("#btnSave").linkbutton('disable');
	        $("#btnAnSave").linkbutton('disable');
    	}
    	else if(appType=="RegOp")
        {
	        $("#paneltitle").prop("innerText","手术登记");
	        selTabIndex=2;
	        //$("#btnSave").linkbutton('disable');
	        //$("#btnAnSave").linkbutton('disable');
    	}
	patInfo=getPatInfo();
    appList=patInfo.split("@");
	InitPatInfo(appList);
	InitTabArea(selTabIndex);
	InitOperDelegates();	//按钮操作
    //DayInRequired(appType);	//必填项目
}
function InitTabArea(selTabIndex)
{
	var index2=0;
	 $('#tt').tabs('select', selTabIndex);
	var tab = $('#tt').tabs('getSelected');
	var index2 = $('#tt').tabs('getTabIndex',tab);
	if(index2==0)
	{
		InitWardInfo();
		loadWardData(appList);
	}
	else if(index2==1)
	{
		InitAnInfo();
		loadAnData(appList);
		
	}
	else
	{
		InitOpLocInfo();
		loadOpData(appList);
	}
	$('#tt').tabs({
		border:false,   
    	onSelect:function(title,index){
		    	if((index==0)&&(loadwardflag==0))
	    		{
	        		InitWardInfo();
	        		loadwardflag=1;
	        		loadWardData(appList);
	    		}
	    		else if((index==0)&&(loadwardflag==1))
	    		{
	        		loadWardData(appList);
	    		}
	    		else if((index==1)&&(loadanflag==0))
	    		{
		    		InitAnInfo();
		    		loadanflag=1;
		    		loadAnData(appList);
	    		}
	    		else if((index==1)&&(loadanflag==1))
	    		{
		    		loadAnData(appList);
	    		}
	    		else if((index==2)&&(loadopflag==1))
	    		{
		    		InitOpLocInfo();
		    		loadopflag=1;
		    		loadOpData(appList);	
	    		} 
	    		else if((index==2)&&(loadopflag==0))
	    		{
		    		loadOpData(appList);
	    		}
    	}
	    
    });
    
}
//---------------------
function InitPatInfo(appList)
{
	    var opDateTime=appList[4];
    var opDateTimeList=opDateTime.split("^");
       //----患者基本信息
	var patBaseInfo=appList[0];
	var baseInfoList=patBaseInfo.split("^");
    //$("#PatName").val(baseInfoList[1]);
    $("#PatName").prop("innerText",baseInfoList[1]);
    //$("#RegNo").val(baseInfoList[2]);
    $("#RegNo").prop("innerText",baseInfoList[2]);
    //$("#PatGender").val(baseInfoList[3]);
    var PatGender=baseInfoList[3]
    $("#PatGender").prop("innerText",baseInfoList[3]);
    //$("#PatAge").val(baseInfoList[4]);
    $("#PatAge").prop("innerText",baseInfoList[4]);
    
    $("#PatLoc").prop("innerText",baseInfoList[5]);
    $("#AdmReason").prop("innerText",baseInfoList[8]);
    $("#PatSecret").prop("innerText",baseInfoList[9]+baseInfoList[10]);
    $("#PatWard").prop("innerText",baseInfoList[6]);
    //$("#PatBedNo").val(baseInfoList[7]);
    $("#PatBedNo").prop("innerText",baseInfoList[7]);
    $("#patSeximg").prop("innerText","");
    if(PatGender=="男"){
			var imghtml="<img src='../images/man.png' alt='' style='margin-top:-5px;'/>"
			$("#patSeximg").append(imghtml)
		}else if(PatGender=="女"){
			var imghtml="<img src='../images/woman.png' alt='' style='margin-top:-5px;'/>";
			$("#patSeximg").append(imghtml)
		}
		var patWardInfo=appList[1];
	var wardInfoList=patWardInfo.split("^");
	var appLoc=wardInfoList[1];
    applocid=appLoc.split("!")[0];
    applocdesc=appLoc.split("!")[1];
    $("#AppLocation").prop("innerText",applocdesc);
     var appDoc=wardInfoList[2];
     $("#AppDoctor").prop("innerText",appDoc.split("!")[1]);
    
	//------
    var admDisChargeFlag=baseInfoList[11];
	if(admDisChargeFlag=="Y") 
	{
        $.messager.alert("提示","该患者已医疗结算,无法申请手术！","error");
        $("#btnSave").linkbutton('disable');
    }
}
//---------------------
// 根据术前诊断列表信息，设置术前诊断，多个术前诊断以“,”拼接
function setPrevDiagnos() {
    var rows = $("#preopDiagBox").datagrid("getRows"),
        result = "";
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
            if (result != "") {
                result += ",";
            }
            var diagID = row.DiagID ? row.DiagID : "";
            result += diagID;
        });
        $("#PrevDiagnosis").val(result);
    }
}

//获取患者基本信息
function getPatInfo(){
    var datas=$.m({
        ClassName:"web.DHCANOPArrange",
        MethodName:"GetAnSingle",
        opaId:opaId,
        EpisodeID:EpisodeID,
        userId:session['LOGON.USERID'],
        type:"In"
    },false);
    return datas;
}
//获取RH血型下来狂
function getRHBloodTypeItems(){
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"RHBlood",
        ResultSetType:"array"
    },false)
    return result;
}
//获取检验项目下拉框
function getLabTestItems(){
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"checkqu",
        ResultSetType:"array"
    },false);
    return result;
}

function getLabInfo(){
    var LabInfoStr=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetLabInfo",
        admId:"^"+EpisodeID
    },false);
    var LabInfo=LabInfoStr.split("^");
    if(LabInfo[0].length>0){
        loadComboboxByDesc("#BloodType",LabInfo[0]);
    }
    if(LabInfo[1].length>0){
        loadComboboxByDesc("#RHBloodType",LabInfo[1]);
    }
    if(LabInfo[3].length>0){
        loadComboboxByDesc("#HbsAg",LabInfo[3]);
    }
    if(LabInfo[4].length>0){
        loadComboboxByDesc("#HcvAb",LabInfo[4]);
    }
    if(LabInfo[5].length>0){
        loadComboboxByDesc("#HivAb",LabInfo[5]);
    }
    if(LabInfo[6].length>0){
        loadComboboxByDesc("#Syphilis",LabInfo[6]);
    }
}


//---------------------
//combobox加载id!desc格式对象数据
function loadCombobox(container,item)
{
	if("undefined" == typeof item) return;
	var itemList=item.split("!")
	if(itemList.length>1)
	{
		$(container).combobox('setValue',itemList[0]);
		$(container).combobox('setText',itemList[1]);
	}
}
function loadComboboxByDesc(container,desc)
{   
    var datas=$(container).combobox('getData');
    if(datas&&datas.length>0)
    {
	    for(var i=0;i<datas.length;i++)
	    {
		    var data=datas[i];
		     if((data.RHDesc)&&(data.RHDesc==desc)){
                $(container).combobox('setValue',data.RHId);
                $(container).combobox('setText',data.RHDesc);
            }
            else if((data.typ)&&(data.typ==desc))
            {
                 $(container).combobox('setValue',data.ord);
                  $(container).combobox('setText',data.typ);
            }
            else if((data.BLDTDesc)&&(data.BLDTDesc==desc))
            {
	             $(container).combobox('setValue',data.BLDTRowId);
	             $(container).combobox('setText',data.BLDTDesc);
            }

	    }
	    /*
        $.each(datas,function(i,data){
	        alert("?")
           if((data.RHDesc)&&(data.RHDesc==desc)){
	           alert("in1")
                $(container).combobox('setValue',data.RHId);
                $(container).combobox('setText',data.RHDesc);
            }
            else if((data.typ)&&(data.typ==desc))
            {
	             alert("in2")
                 $(container).combobox('setValue',data.ord);
                  $(container).combobox('setText',data.typ);
            }
            else if((data.BLDTDesc)&&(data.BLDTDesc==desc))
            {
	             alert("in3")
	             $(container).combobox('setValue',data.BLDTRowId);
	             $(container).combobox('setText',data.BLDTDesc);
            }

        })
        */
    }
}
function getIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i].split("!")[0];
            idStr.push(id);
        }
    }
    return idStr;
}
function getDescStr(str)
{
    var descStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var desc=strList[i].split("!")[1];
            descStr.push(desc);
        }
    }
    return descStr;
}

function getNewIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i];
            idStr.push(id);
        }
    }
    return idStr;
}

//-------------------------
/// 初始化术前诊断列表组件
function initPrevDiagnosGrid() {
    var preopDiagBox=$HUI.datagrid("#preopDiagBox",{
        height:80,
        fit:true,
        singleSelect:true,
        showHeader:false,
        rownumbers:true,
        toolbar:"#preopDiagTool",
        columns: [
            [
                { field: "DiagID", title: "ID", width: 80, hidden: true },
                { field: "DiagDesc", title: "名称", width: 500 }
            ]
        ]
    })
}
///初始化手术列表组件
function initOperationGrid(){
    var operationBox=$HUI.datagrid("#operationBox",{
        fit:true,
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operationTool",
        columns: [
            [
                { field: "Operation", title: "手术名称Id", width: 240, hidden: true },
                { field: "OperationDesc", title: "手术名称", width: 240 },
                { field: "OperClass", title: "手术分级Id", width: 60 ,hidden:true },
                { field: "OperClassDesc", title: "手术分级", width: 60 },
                { field: "BladeType", title: "手术分级Id", width: 60 ,hidden:true },
                { field: "BladeTypeDesc", title: "切口类型", width: 60 },
                { field: "SurgeonLoc", title: "手术分级Id", width: 60 ,hidden:true },
                { field: "SurgeonLocDesc", title: "术者科室", width: 80 },
                { field: "Surgeon", title: "主刀id", width: 60 ,hidden:true },
                { field: "SurgeonDesc", title: "主刀", width: 50 },
                { field: "SurgeonNoteDesc", title: "备注", width: 50 ,hidden:true },
                { field: "SurgonAss1", title: "一助", width: 50 ,hidden:true },
                { field: "SurgonAss1Desc", title: "一助", width: 50 },
                { field: "SurgonAss2", title: "二助", width: 50 ,hidden:true },
                { field: "SurgonAss2Desc", title: "二助", width: 50 },
                { field: "SurgonAss3", title: "三助", width: 50 ,hidden:true },
                { field: "SurgonAss3Desc", title: "三助", width: 50 },
                { field: "SurgonAsso", title: "其他", width: 50 ,hidden:true },
                { field: "SurgonAssoDesc", title: "其他", width: 50 },
                { field: "OperNote", title: "名称备注", width: 60 },
                { field: "OpSub", title: "OpSub", width: 1, hidden: true }	//20190118+dyl+8
            ]
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
        }

    });
}

//--------------------------
function InitWardInfo()
{
	initPrevDiagnosGrid();
	initOperationGrid();
	$HUI.datebox("#OperDate",{});
	// $HUI.combobox("#OperLocation",{});
	 var OperLocation=$HUI.combobox("#OperLocation",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param){
            param.desc=param.q;
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID=EpisodeID;
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });
	//$HUI.combobox("#PrevAnaMethod",{});
    var PrevAnaMethod=$HUI.combobox("#PrevAnaMethod",{
        valueField: "ID",
        textField: "Des",
        required: $("#IsAnaest").combobox("getValue") === "Y" ? true : false,
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
         onBeforeLoad:function(param){
            param.anmethod=param.q;
                 
        }
      ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAnaestMethod&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
       
    });
	//$HUI.combobox("#diagnosis",{});
    var diagnosis=$HUI.combobox("#diagnosis",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=LookUpMrcDiagnosis&ResultSetType=array",
        valueField:"rowid0",
        textField:"DiagDes",
        onBeforeLoad:function(param){
            param.mrcidAlias=param.q;
        },
        mode: "remote"
        /*
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=LookUpMrcDiagnosis&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
  		*/
    });
    //$HUI.combobox("#BodySite",{});
     var bodysite=$HUI.combobox("#BodySite",{
        valueField: "BODS_RowId",
        textField: "BODS_Desc",
        multiple: true,
        rowStyle:'checkbox',
        editable:false
      ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindBodySite&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
       
    });
	//$HUI.combobox("#OperPos",{});
    var operpos=$HUI.combobox("#OperPos",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOperPosition&ResultSetType=array",
        valueField:"OPPOS_RowId",
        textField:"OPPOS_Desc",
        editable:false,
        allowNull:true,
         panelHeight:'auto'
         ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOperPosition&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });
    	//20191024+dyl
    	/*
	    var material=$HUI.combobox("#MaterialMem",{
        valueField: "CssdId",
        textField: "CssdPack",
        multiple: true,
        rowStyle:'checkbox',
        selectOnNavigation:false,
        editable:false
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCSSDPack&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
        
    });
    */


    //$HUI.combobox("#BloodType",{});
    var bloodtype=$HUI.combobox("#BloodType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBlood&ResultSetType=array",
        valueField:"BLDTRowId",
        textField:"BLDTDesc",
        editable:false,
         panelHeight:'auto',
         allowNull:true
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBlood&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
         
    });
    //$HUI.combobox("#RHBloodType",{});
    var rhbloodtype=$HUI.combobox("#RHBloodType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=RHBlood&ResultSetType=array",
        valueField:"RHId",
        textField:"RHDesc",
        editable:false,
        allowNull:true,
        //data:getRHBloodTypeItems()
       data:[{'RHDesc':"不详",'RHId':"1"}
       ,{'RHDesc':"阴性(-)",'RHId':"2"}
       ,{'RHDesc':"阳性(+)",'RHId':"3"}
       ]
    });
    //$HUI.combobox("#HbsAg,#HcvAb,#HivAb,#Syphilis",{});
       $HUI.combobox("#HbsAg,#HcvAb,#HivAb,#Syphilis",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"ord",
        textField:"typ",
        panelHeight:'auto',
        editable:false,
        rowStyle:'checkbox',
        //data:getLabTestItems()
        data:[{'typ':"不详",'ord':"1"},{'typ':"阴性(-)",'ord':"2"}
        ,{'typ':"阳性(+)",'ord':"3"},{'typ':"化验中",'ord':"4"}
        ]
    });

    //$HUI.combobox("#OperType",{});
    $HUI.combobox("#OperType",{});
        var OperType=$HUI.combobox("#OperType",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
         panelHeight:'auto',
         onSelect:function(record){
		     	setOperDateAndBtn();
	     		}
        ,data:[{'typedesc':"择期",'typecode':"B"},{'typedesc':"急诊",'typecode':"E"}]
    });
    //$HUI.combobox("#ReentryOperation,#IsAnaest",{});
    var yesno=$HUI.combobox("#ReentryOperation,#IsAnaest",{
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        allowNull:true,
         panelHeight:'auto',
        data:[{'typedesc':"是",'typecode':"Y"},{'typedesc':"否",'typecode':"N"}]
    });
    //$HUI.timespinner("#OperTime",{ }); 
    var timeinit=$HUI.timespinner("#OperTime",{
	    min: '08:30',
	    showSeconds: false 
    }); 
    //$HUI.numberspinner("#OperDuration,#PlanSeq",{});
    var numinit=$HUI.numberspinner("#OperDuration,#PlanSeq",{ 
     min: 1,    
    max: 30,    
    editable: false 
    });
}
//
function InitAnInfo()
{
    //---麻醉科相关
    //$HUI.combobox("#AnMainDoc,#AnSuperDoc,#AnAss,#ShiftANDoc,#AnAss",{ }); 
	var AnSuperDoc=$HUI.combobox("#AnMainDoc,#AnSuperDoc,#AnAss,#ShiftANDoc,#AnAss",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        editable:false,
        allowNull:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
       		$(this).combobox('reload');
    		}
  		}
    });
    //$HUI.combobox("#AnNurse",{ }); 
    var AnNurse=$HUI.combobox("#AnNurse",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        allowNull:true,
        panelHeight:'auto',
        editable:false,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="";           
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });
    //$HUI.combobox("#AnaLevel",{ });
    var AnaLevel=$HUI.combobox("#AnaLevel",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetAnaLevel&ResultSetType=array",
        valueField:"anaLevelId",
        textField:"levelDesc",
        editable:false,
        allowNull:true,
        panelHeight:'auto'
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetAnaLevel&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });
    //$HUI.combobox("#AnaMethod",{ });
    var AnaMethod=$HUI.combobox("#AnaMethod",{
        valueField: "ID",
        textField: "Des",
        rowStyle:'checkbox',
        editable:false,
        required: $("#IsAnaest").combobox("getValue") === "Y" ? true : false,
        multiple: true,
        //data:getAnaestMethods()
        onBeforeLoad:function(param){
            param.anmethod=param.q;
                 
        }
      ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAnaestMethod&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });  

}
////手术室相关
function InitOpLocInfo()
{ 
	 //$HUI.combobox("#comOperRoom",{});
    var comOperRoom=$HUI.combobox("#comOperRoom",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
        valueField:"oprId",
        textField:"oprDesc",
         editable:false,
         allowNull:true,
        panelHeight:'auto',
         onBeforeLoad:function(param){
            param.oprDesc='';
            param.locDescOrId="";
            //$("#OperLocation").combobox("getValue");
            param.locListCodeStr="OP";
            param.EpisodeID="";
            param.opaId="";
            param.oprBedType="T";
            param.appLocDescOrId="";
            
        },
        onSelect:function(record)
        {
	        //20181213+dyl
	        var retStr=$.m({
        	ClassName:"web.DHCANOPArrange",
        	MethodName:"GetRoomFirstOrd",
        	opaId:opaId,
        	roomId:record.oprId
    		},false);
    		var cirNurIdStr=retStr.split("^")[0];
    		var cirNurId=getNewIdStr(cirNurIdStr);
    		var scrNurIdStr=retStr.split("^")[1];
    		var scrNurId=getNewIdStr(scrNurIdStr);
    		 $("#comScrubNurse").combobox('setValues',scrNurId);
    		 $("#comCirculNurse").combobox('setValues',cirNurId);
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData');
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		},
      mode:'remote'  
    });
    
    //$HUI.combobox("#comOrdNo",{});
    var comOrdNo=$HUI.combobox("#comOrdNo",{
        valueField:"Id",
        textField:"Desc"
        ,data:[{'Id':"1",'Desc':"1"},{'Id':"2",'Desc':"2"},{'Id':"3",'Desc':"3"},{'Id':"4",'Desc':"4"},{'Id':"5",'Desc':"5"}
        ,{'Id':"6",'Desc':"6"},{'Id':"7",'Desc':"7"},{'Id':"8",'Desc':"8"},{'Id':"9",'Desc':"9"},{'Id':"10",'Desc':"10"}
        ,{'Id':"11",'Desc':"11"},{'Id':"12",'Desc':"12"},{'Id':"13",'Desc':"13"},{'Id':"14",'Desc':"14"},{'Id':"15",'Desc':"15"}
        ,{'Id':"16",'Desc':"16"},{'Id':"17",'Desc':"17"},{'Id':"18",'Desc':"18"},{'Id':"19",'Desc':"19"},{'Id':"20",'Desc':"20"}
        ]
    });
    $HUI.combobox("#chkIfShift",{});
    var yesno2=$HUI.combobox("#chkIfShift",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        allowNull:true,
         panelHeight:'auto',
        data:[{'typedesc':"是",'typecode':"1"},{'typedesc':"否",'typecode':"0"}]
    });
    //$HUI.combobox("#comScrubNurse,#comShiftScrubNurse,#comCirculNurse,#comShiftCirculNurse",{});
        var comScrubNurse=$HUI.combobox("#comScrubNurse,#comShiftScrubNurse,#comCirculNurse,#comShiftCirculNurse",{
	     //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        rowStyle:'checkbox',
        editable:false,
        multiple: true,
         onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="OP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });
    $HUI.datebox("#dateOpStt,#dateOpEnd",{})
    $HUI.timespinner("#timeArrOper,#timeOpStt,#timeOpEnd",{ 
    }); 
    

}

//----------------------
//加载数据
function loadWardData(appList){
	
	var opDateTime=appList[4];
	var opDateTimeList=opDateTime.split("^");
    var operTime=opDateTimeList[1];
    $("#OperTime").timespinner('setValue',operTime);
    var operDuration=opDateTimeList[7];
    $("#OperDuration").numberspinner('setValue',operDuration);
    var patWardInfo=appList[1];
	var wardInfoList=patWardInfo.split("^");
	var operLoc=wardInfoList[0];
    loadCombobox("#OperLocation",operLoc);
    
   var appLoc=wardInfoList[1];
    $("#AppLocation").prop("innerText",appLoc.split("!")[1]);
    var appDoc=wardInfoList[2]
    $("#AppDoctor").prop("innerText",appDoc.split("!")[1]);
    var operDate=opDateTimeList[0];
    $("#OperDate").datebox('setValue',operDate);		//拟日间日期不必填
    var preDiagAndNotes=wardInfoList[3];
    var preDiag=preDiagAndNotes.split("#")[0];
    setDefaultPrevDiagnos(preDiag);
    var preDiagMen=preDiagAndNotes.split("#")[1];
    $("#OperPreDiagMem").val(preDiagMen);
    var opmen=wardInfoList[8];
    $("#AreaOperMem").val(opmen);
     var opdocmem=wardInfoList[7];
    $("#SurgeonNote").val(opdocmem);
    
    var bodsList=wardInfoList[9];
    var bodsIdList=getIdStr(bodsList);
    var bodsDescList=getDescStr(bodsList);
    if(bodsIdList!="") {
	    var bodsDescList=getDescStr(bodsList);
	    $("#BodySite").combobox('setValues',bodsIdList);
	    $("#BodySite").combobox('setText',bodsDescList);
	    }
    else{
	    $("#BodySite").combobox('setValues',"")
    }
    var operPosition=wardInfoList[10];
    loadCombobox("#OperPos",operPosition);
    var bloodType=wardInfoList[11]
    loadCombobox("#BloodType",bloodType);
    var opSeq=wardInfoList[12]
    $("#PlanSeq").numberspinner('setValue',opSeq);

    var anaesInfo=appList[2]
    var anaesInfoList=anaesInfo.split("^");
    var anDocMethodStr=anaesInfoList[8];
    var anDocMethodIdStr=getIdStr(anDocMethodStr)
    var anDocMethodDescStr=getDescStr(anDocMethodStr)
    if(anDocMethodIdStr!="")
    {
    $("#PrevAnaMethod").combobox('setValues',anDocMethodIdStr);
    $("#PrevAnaMethod").combobox('setText',anDocMethodDescStr);
    }

    if((opaId==null)||(opaId==""))
    {
        var checkinbedflag=$.m({
            ClassName:"web.DHCANOPArrange",
            MethodName:"CheckInBedFlag",
            adm:EpisodeID
        },false);
        if(checkinbedflag=="N")
		 {
			// $.messager.alert("提示","患者尚未安排床位","error");
            // $("#btnSave").linkbutton('disable');
		 }
        var checkDisflag=$.m({
            ClassName:"web.DHCANOPArrange",
            MethodName:"CheckDISFlag",
            Adm:EpisodeID
        },false);
        if(checkDisflag=="Y")
		 {
		 	 $.messager.alert("提示","该患者已有出院诊断,不能申请手术","error");
             $("#btnSave").linkbutton('disable');
		 }
         var opSetInfoStr=$.m({
            ClassName:"web.DHCANOPCom",
            MethodName:"GetOpSetInfo"
        },false);
        var opSetInfo=opSetInfoStr.split("^");
        var IfInsertLabInfo=opSetInfo[1];
        if(IfInsertLabInfo=="Y")
        {
            getLabInfo();
        }
    }else{
        loadQTData(opaId);
        loadOperList(opaId);
    }
}
//加载患者基本信息

function loadQTData(opaId){
   var operQTData=$.m({
            ClassName:"web.DHCANOPArrangeHISUI",
            MethodName:"GetQTData",
            opaId:opaId
        },false);
   var appOtherList=operQTData.split("$");
   var checkList=appOtherList[0].split("^");
   var RHBloodTypeDesc=checkList[6];
   loadComboboxByDesc("#RHBloodType",RHBloodTypeDesc);
   var HbsAgDesc=checkList[0];
   loadComboboxByDesc("#HbsAg",HbsAgDesc);
   var HcvAbDesc=checkList[1];
   loadComboboxByDesc("#HcvAb",HcvAbDesc);
   var HivAbDesc=checkList[2];
   loadComboboxByDesc("#HivAb",HivAbDesc);
   var RPRDesc=checkList[3];
   loadComboboxByDesc("#Syphilis",RPRDesc);
   var opType=checkList[4];
   if(opType==1) opType="E";
   else {
       opType="B";
   }
   $("#OperType").combobox('setValue',opType);
   var needAnaesthetist=checkList[11];
   $("#IsAnaest").combobox('setValue',needAnaesthetist);
      if(needAnaesthetist=="N")
   {
	   $("#PrevAnaMethod").combobox({
                required: false
            });
            $("#PrevAnaMethod").combobox("disable");
   }

   var unPlanedOperFlag=checkList[15];
   $("#ReentryOperation").combobox('setValue',unPlanedOperFlag);
   var isolated=checkList[7];
   $("#IsoOperation").checkbox('setValue',isolated=="Y"?true:false);
   var isPrepareBlood=checkList[8];
   $("#PrepareBlood").checkbox('setValue',isPrepareBlood=="Y"?true:false);
   var isUseSelfBlood=checkList[9];
   $("#TransAutoblood").checkbox('setValue',isUseSelfBlood=="Y"?true:false);
   var isExCirculation=checkList[10];
   $("#ECC").checkbox('setValue',isExCirculation=="Y"?true:false);
   var otherTest=checkList[5];
   $("#LabTest").val(otherTest);
      //20191024+dyl+手术材料清单
  // $("#MaterialMem").val(MaterialMem);
  /*
       var MaterialMemStr=checkList[17];
    
     var materialIdStr=getIdStr(MaterialMemStr)
    var materialDescStr=getDescStr(MaterialMemStr)
    if(materialIdStr!="")
    {
    	$("#MaterialMem").combobox('setValues',materialIdStr);
    	$("#MaterialMem").combobox('setText',materialDescStr);
    }
    */

}
function loadOperList(opaId)
{
    var operList=$.cm({
        ClassName:"web.DHCANOPArrange",
        QueryName:"GetOpList",
        opaId:opaId,
        ResultSetType:"array"
    },false);
    var datas=[];
    if(operList&&operList.length>0){
        for(var i=0;i<operList.length;i++)
        {
            var data={
                Operation:operList[i].operId,
                OperationDesc:operList[i].operDesc,
                OperClass:operList[i].opLevelId,
                OperClassDesc:operList[i].opLevelDesc,
                BladeType:operList[i].bldTpId,
                BladeTypeDesc:operList[i].bldTypeDesc,
                SurgeonLoc:operList[i].opdocLocId,
                SurgeonLocDesc:operList[i].opdocLoc,
                Surgeon:operList[i].surgeonId,
                SurgeonDesc:operList[i].surgeon,
                SurgeonNoteDesc:"",
                SurgonAss1:operList[i].Ass1Id,
                SurgonAss1Desc:operList[i].Ass1,
                SurgonAss2:operList[i].Ass2Id,
                SurgonAss2Desc:operList[i].Ass2,
                SurgonAss3:operList[i].Ass3Id,
                SurgonAss3Desc:operList[i].Ass3,
                SurgonAsso:operList[i].AssoId,
                SurgonAssoDesc:operList[i].Asso,
                OperNote:operList[i].operNotes,
                OpSub:operList[i].opSub	////20190118+dyl+3
            }
            datas.push(data);
        }
    }
    $("#operationBox").datagrid('loadData',datas);
}


//----------------------
//加载手术室信息
function loadOpData(appList)
{
    var opDateTime=appList[4];
	var opDateTimeList=opDateTime.split("^")
    var opTheatreInfo=appList[3];
	var opTheatreInfoList=opTheatreInfo.split("^");
	var opRoom=opTheatreInfoList[0];   //手术间
    loadCombobox("#comOperRoom",opRoom);
    var ordNo=opTheatreInfoList[1];
	loadCombobox("#comOrdNo",ordNo+"!"+ordNo);    //台次
    var opArrTime=opDateTimeList[3];
	$("#timeArrOper").timespinner('setValue',opArrTime)
	 var scNurStr=opTheatreInfoList[2];  //器械护士	 
	 var scNurIdStr=getIdStr(scNurStr);
	 var scNurDescStr=getDescStr(scNurStr);
	 if(scNurIdStr!="")
	 {
    	$("#comScrubNurse").combobox('setValues',scNurIdStr);
    	$("#comScrubNurse").combobox('setText',scNurDescStr);
	 }
	 var scSNurStr=opTheatreInfoList[3];  //j器械护士
	 var scSNurIdStr=getIdStr(scSNurStr);
	 var scSNurDescStr=getDescStr(scSNurStr);
	  if(scSNurIdStr!="")
	 {
    	$("#comShiftScrubNurse").combobox('setValues',scSNurIdStr);
    	$("#comShiftScrubNurse").combobox('setText',scSNurDescStr);
	 }
	 var cirNurStr=opTheatreInfoList[4];  //器械护士
	 var cirNurIdStr=getIdStr(cirNurStr);
	 var cirNurDescStr=getDescStr(cirNurStr);
	if(cirNurIdStr!="")
	{
    $("#comCirculNurse").combobox('setValues',cirNurIdStr);
    $("#comCirculNurse").combobox('setText',cirNurDescStr);
	}
	 var cirSNurStr=opTheatreInfoList[5];  //j器械护士
	 var cirSNurIdStr=getIdStr(cirSNurStr);
	 var cirSNurDescStr=getDescStr(cirSNurStr);
	 if(cirSNurIdStr!="")
	 {
    	$("#comShiftCirculNurse").combobox('setValues',cirSNurIdStr);
    	$("#comShiftCirculNurse").combobox('setText',cirSNurDescStr);
	 }

	   var scNurNote=opTheatreInfoList[6];
	   $("#txtScrubNurseNote").val(scNurNote);
	  // alert(opTheatreInfoList)
	   var cirNurNote=opTheatreInfoList[7];
	  $("#txtCirculNurseNote").val(cirNurNote);
	  //alert(opDateTimeList[10]+"|"+opDateTimeList[11])
	   if (appType=="RegOp")
	   {
		    $("#dateOpStt").datebox('setValue',opDateTimeList[8]);		//拟日间日期不必填
    		$("#timeOpStt").timespinner('setValue',opDateTimeList[9]);
		     $("#dateOpEnd").datebox('setValue',opDateTimeList[10]);
		     $("#timeOpEnd").timespinner('setValue',opDateTimeList[11]);
		    //obj.dateOpStt.setRawValue(opDateTimeList[8]);
			//obj.timeOpStt.setRawValue(opDateTimeList[9]);
			//obj.dateOpEnd.setRawValue(opDateTimeList[10]);
			//obj.timeOpEnd.setRawValue(opDateTimeList[11]);
	   }
	   else if (appType=="op")
	   {
		   $("#dateOpStt").datebox("disable");
		   $("#timeOpStt").timespinner("disable");
		   $("#dateOpEnd").datebox("disable");
		   $("#timeOpEnd").timespinner("disable");
	   }
	      var operQTData=$.m({
            ClassName:"web.DHCANOPArrangeHISUI",
            MethodName:"GetQTData",
            opaId:opaId
        },false);
   var appOtherList=operQTData.split("$");
	var opReq=appOtherList[2];
	  $("#txtOpReq").val(opReq);
	  var isshift=appOtherList[5];
	  $("#chkIfShift").combobox('setValue',isshift);
}

	//加载麻醉安排信息
function loadAnData()
{
	var patInfo=getPatInfo();
    var appList=patInfo.split("@");
    var anaInfo=appList[2];
	var anaInfoList=anaInfo.split("^");
	var anDoc=anaInfoList[0];
    loadCombobox("#AnMainDoc",anDoc);
    var anSupDoc=anaInfoList[1];
    loadCombobox("#AnSuperDoc",anSupDoc);
    var anNurse=anaInfoList[2];
    loadCombobox("#AnNurse",anNurse);
    var anAssStr=anaInfoList[3];
    loadCombobox("#AnAss",anAssStr);
    var shiftAnAssStr=anaInfoList[4];
    loadCombobox("#ShiftANDoc",shiftAnAssStr);
    var anMethodStr=anaInfoList[5];
    var anMethodIdStr=getIdStr(anMethodStr)
    if(anMethodIdStr!="")
    {
	    var AnaMetList=getDescStr(anMethodStr);
    	$("#AnaMethod").combobox('setValues',anMethodIdStr);
    	$("#AnaMethod").combobox('setText',AnaMetList);
    }
    var anaLevel=anaInfoList[6]	//麻醉规模	//20160908+dyl
     loadCombobox("#AnaLevel",anaLevel) 
    var anDocNote=anaInfoList[7]	//麻醉备注
    $("#ANDocMem").val(anDocNote)	
}

/// 初始化操作事件
function InitOperDelegates() {
    $("#btnAddDiag").linkbutton({
        onClick: addPrevDiagnos
    });

    $("#btnDelDiag").linkbutton({
        onClick: removePrevDiagnos
    });

    $("#btnAddOperation").linkbutton({
        onClick: addAnaestOperation
    });

    $("#btnEditOperation").linkbutton({
        onClick: editAnaestOperation
    });

    $("#btnDelOperation").linkbutton({
        onClick: removeAnaestOperation
    });

    $("#btnSave").linkbutton({
        onClick: saveOperApplication
    });

    $("#btnCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnAnSave").linkbutton({
        onClick: saveAnRecord
    });

    $("#btnAnCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnOpSave").linkbutton({
        onClick: saveOpRecord
    });

    $("#btnOpCancel").linkbutton({
        onClick: closeWindow
    });
}
//--------------------event
//添加一条诊断
function addPrevDiagnos(){
    var diagID = $("#diagnosis").combobox("getValue");
    
    var diagDesc = $HUI.combobox("#diagnosis").getText();
    if(diagID==diagDesc)
    {
	    $.messager.alert("提示","请从诊断下拉框中选择诊断!","error");
		  return; 
    }
      //20180828+dyl
     var rows = $("#preopDiagBox").datagrid("getRows"),
      result = "";
      var exsitflag2=0
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
	        if(diagID==row.DiagID)
	        {
		        $.messager.alert("提示","该诊断已存在!","error");
                    exsitflag2=1;
                    return;
	        }
        });
    }
    if(exsitflag2==1)return;
    if (diagDesc && diagDesc != "") {
        $HUI.datagrid("#preopDiagBox").appendRow({
            DiagID: diagID,
            DiagDesc: diagDesc
        });
        $HUI.combobox("#diagnosis").clear();
        setPrevDiagnos();
    }
}
//删除一条诊断
function removePrevDiagnos(){
    var selectRow=$HUI.datagrid("#preopDiagBox").getSelected(),
        selectRowIndex=$HUI.datagrid("#preopDiagBox").getRowIndex(selectRow);
    if(selectRow)
    {
        $HUI.datagrid("#preopDiagBox").deleteRow(selectRowIndex);
        setPrevDiagnos();
    }else{
        $.messager.alert("提示","请选择要删除的诊断","error");
        return;
    }
}
function saveOpRecord()
{
	//var ret=_DHCANOPArrange.UpdateOpRecord(opaId,str1,scrNurse,cirNurse,strOp,appType);
	//
     var scrNurIdStr="";
	var sNurArray = $("#comScrubNurse").combobox("getValues");
    if(sNurArray&&sNurArray.length>0)
    {
        scrNurIdStr= sNurArray.join(",");
    }
    //
     var sScrNurIdStr="";
    var sScrNurArray = $("#comShiftScrubNurse").combobox("getValues");
    if(sScrNurArray&&sScrNurArray.length>0)
    {
        sScrNurIdStr= sScrNurArray.join(",");
    }
    //
	  var scrNurNote=$("#txtScrubNurseNote").val();
	  var scrNurse=scrNurIdStr+"#"+sScrNurIdStr+"#"+scrNurNote;

     var cirNurIdStr="";
	var CirNurArray = $("#comCirculNurse").combobox("getValues");
    if(CirNurArray&&CirNurArray.length>0)
    {
        cirNurIdStr= CirNurArray.join(",");
    }
    //
     var sCirNurIdStr="";
    var sCirNurArray = $("#comShiftCirculNurse").combobox("getValues");
    if(sCirNurArray&&sCirNurArray.length>0)
    {
        sCirNurIdStr= sCirNurArray.join(",");
    }
    //
	  var cirNurNote=$("#txtCirculNurseNote").val();
	  var cirNurse=cirNurIdStr+"#"+sCirNurIdStr+"#"+cirNurNote;



    var arrTime=$("#timeArrOper").timespinner('getValue');
    var oproom=$("#comOperRoom").combobox('getValue');
    if (typeof oproom=="undefined") ordNo="";
    if(oproom=="")
    {
	     $.messager.alert("提示","请选择手术间","error");
	     return;
    }
    var ordNo=$("#comOrdNo").combobox('getValue');
    if (typeof ordNo=="undefined") ordNo="";
    if(ordNo=="")
    {
	     $.messager.alert("提示","请选择台次","error");
	     return;
    }
    var ifShift=$("#chkIfShift").combobox('getValue');
    var opReq=$("#txtOpReq").val();
   var opDateTime="";
    if (appType=="RegOp"){
	    var opDateTime= $("#dateOpStt").datebox('getValue')+"|"+$("#timeOpStt").timespinner('getValue')+"|"+$("#dateOpEnd").datebox('getValue')+"|"+$("#timeOpEnd").timespinner('getValue');
       }

    var str1=oproom+"^"+arrTime;
   //alert(str1)
    var strOp=session['LOGON.USERID']+"^"+opReq+"^"+""+"^"+ifShift+"^"+ordNo+"^"+""+"^"+opDateTime;
		if((opaId==null)||(opaId=="")) return;
     else{
        var result=$.m({
             ClassName:"web.DHCANOPArrange",
             MethodName:"UpdateOpRecordNew",
             opaId:opaId,
             str1:str1,
             scr:scrNurse,
             cir:cirNurse,
             strOp:strOp,
             appType:appType,
             AppLocType:"I"
         },false)
		if(result!=0)
		{
			alert(result);
			window.returnValue=0;	//20181207
			return;
     	}
     	else
     	{
	     	$.messager.confirm("确认","手术室信息修改成功，是否继续修改其他信息？",function(r){
                if(!r)
                {
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
	     	
     	}
     }


}
//麻醉安排
function saveAnRecord()
{
	 var anDocId=$("#AnMainDoc").combobox('getValue');
	 if (typeof anDocId=="undefined") anDocId="";
    if(anDocId=="")
    {
	     $.messager.alert("提示","请选择麻醉医师","error");
	     return;
    }
	  var anSupDocId=$("#AnSuperDoc").combobox('getValue'); 
	  var anNurseId=$("#AnNurse").combobox('getValue');
	  var anAssIdStr=$("#AnAss").combobox('getValue');
	  var shiftAnAssIdStr=$("#ShiftANDoc").combobox('getValue');
	 var anaLevel=$("#AnaLevel").combobox('getValue');
	var anaMethodArray = $("#AnaMethod").combobox("getValues");
	if(anaMethodArray.length==0)
	{
		$.messager.alert("提示","请选择麻醉方法","error");
	     return;
	}
     var anaMethodIdStr="";
     
    if(anaMethodArray&&anaMethodArray.length>0)
    {
        anaMethodIdStr= anaMethodArray.join(",");
    }
	var andocmen=$("#ANDocMem").val();
	//opaId,anMethodIdStr,anDocId,anNurseId,anAssIdStr,shiftAnAssIdStr,anSupDocId,anDocNote,anaLevelId,ASAId);
	if((opaId==null)||(opaId=="")) return;
     else{
        var result=$.m({
             ClassName:"web.DHCANOPArrange",
             MethodName:"UpdateAnRecord",
             opaId:opaId,
             anmthIdStr:anaMethodIdStr,
             anDocId:anDocId,
             anNurseId:anNurseId,
             anAssIdStr:anAssIdStr,
             shiftAnAssIdStr:shiftAnAssIdStr,
             anSupDocId:anSupDocId,
             anDocNote:andocmen,
             anaLevelId:anaLevel,
             ASAId:""
         },false)
		if(result!=0)
		{
			
			alert(result);
			window.returnValue=0;	//20181207
			return;
     	}
     	else
     	{
	     	$.messager.confirm("确认","麻醉信息修改成功，是否继续修改其他信息？",function(r){
                if(!r)
                {
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
	     	
     	}
     }
}
//获取选择的拟施麻醉方法
function getPrevAnaMethods(){
    var anaMethodArray = $("#PrevAnaMethod").combobox("getValues"),
        anaMethod="";
    if(anaMethodArray&&anaMethodArray.length>0)
    {
        anaMethod= anaMethodArray.join(",");
    }
    return anaMethod;
}
//获取主手术信息
function getMainOperStr(){
    var datas=$("#operationBox").datagrid('getData')
        mainOperStr="";
    if(datas&&datas.total>0)
    {
        var mainOperId=datas.rows[0].Operation;
        var mainOperClassId=datas.rows[0].OperClass;
        var mainBladeTypeId=datas.rows[0].BladeType;
        var mainOperNote=datas.rows[0].OperNote;
        var mainSurgeonLocId=datas.rows[0].SurgeonLoc;
        var mainSurgeonId=datas.rows[0].Surgeon;
        var mainSurgonAss1Id=datas.rows[0].SurgonAss1;
        var mainSurgonAss2Id=datas.rows[0].SurgonAss2;
        var mainSurgonAss3Id=datas.rows[0].SurgonAss3;
        var mainSurgonAssoId=datas.rows[0].SurgonAsso;
        var mainOpSub=datas.rows[0].OpSub;	//20190118+dyl+1
        var doctorStr=mainSurgeonLocId+"|"+mainSurgeonId+"|"+mainSurgonAss1Id+"|"+mainSurgonAss2Id+"|"+mainSurgonAss3Id+"|"+mainSurgonAssoId;
        mainOperStr=mainOperId+"|"+mainOperClassId+"|"+mainOperNote+"|"+mainBladeTypeId+"||"+doctorStr;
    }
    return mainOperStr;
}
//获取其他手术信息
function getSubOperStr()
{
    var datas=$("#operationBox").datagrid('getData'),
        subOperStr="";
    if(datas.total==0) return;
    for(var i=1;i<datas.total;i++)
    {
        var subOperId=datas.rows[i].Operation;
        var subOperClassId=datas.rows[i].OperClass;
        var subBladeTypeId=datas.rows[i].BladeType;
        var subOperNote=datas.rows[i].OperNote;
        var subSurgeonLocId=datas.rows[i].SurgeonLoc;
        var subSurgeonId=datas.rows[i].Surgeon;
        var subSurgonAss1Id=datas.rows[i].SurgonAss1;
        var subSurgonAss2Id=datas.rows[i].SurgonAss2;
        var subSurgonAss3Id=datas.rows[i].SurgonAss3;
        var subSurgonAssoId=datas.rows[i].SurgonAsso;
        var subOpSub=datas.rows[i].OpSub;	//20190118+dyl+2
        var doctorStr=subSurgeonLocId+"|"+subSurgeonId+"|"+subSurgonAss1Id+"|"+subSurgonAss2Id+"|"+subSurgonAss3Id+"|"+subSurgonAssoId;
        subOperStr=subOperStr+subOperId+"|"+subOperClassId+"|"+subOperNote+"|"+subBladeTypeId+"|"+subOpSub+"|"+doctorStr+"#";
    }
    return subOperStr;
}

//保存手术申请
function saveOperApplication(){
     var checkResult=CheckData();
     if(checkResult==false) return;
     var appLocId=""
     //var appLocId=$("#AppLocation").combobox('getValue');
     var appDocId=""
     //var appDocId=$("#AppDoctor").combobox('getValue');
     var operLocationId=$("#OperLocation").combobox('getValue');
     var operType=$("#OperType").combobox('getValue');
     var operDate=$("#OperDate").datebox('getValue');
     var operTime=$("#OperTime").timespinner('getValue');
     var operDuration=$("#OperDuration").numberspinner('getValue');
     var isAnaest=$("#IsAnaest").combobox('getValue');
     var anaMethod=getPrevAnaMethods();
     var reentryOperation=$("#ReentryOperation").combobox('getValue');
     var prevDiagnosisId=$("#PrevDiagnosis").val();
     var operPreDiagMem=$("#OperPreDiagMem").val();
     var preDiagStr=prevDiagnosisId+"|"+operPreDiagMem;
     var mainOperStr=getMainOperStr();
     if(mainOperStr=="")
     {
	     $.messager.alert("提示","手术不能为空","error");
	     return;
     }
     var subOperStr=getSubOperStr();
     var bodySiteId=$("#BodySite").combobox('getValues');
     bodySiteId=String(bodySiteId).replace(/,/g, "|");
     var operPosId=$("#OperPos").combobox('getValue');
     var operMem=$("#AreaOperMem").val();
     var isoOperation=$("#IsoOperation").checkbox('getValue')?"Y":"N";
     var isECC=$("#ECC").checkbox('getValue')?"Y":"N";
     var isTransAutoblood=$("#TransAutoblood").checkbox('getValue')?"Y":"N";
     var isPrepareBlood=$("#PrepareBlood").checkbox('getValue')?"Y":"N";
     var planSeq=$("#PlanSeq").numberspinner('getValue');
     var bloodTypeId=$("#BloodType").combobox('getValue');
     var RHBloodTypeDesc=$("#RHBloodType").combobox('getText');
     var HbsAgDesc=$("#HbsAg").combobox('getText');
     var HcvAbDesc=$("#HcvAb").combobox('getText');
     var HivAbDesc=$("#HivAb").combobox('getText');
     var SyphilisDesc=$("#Syphilis").combobox('getText');
     var labTestNote=$("#LabTest").val();
     var opDocNote=$("#SurgeonNote").val();
      //20191024+dyl
     var materialMem="";
     //$("#MaterialMem").combobox('getValues');
     
     var str1=appLocId+"^"+appDocId+"^"+operDate+"^"+operTime+"^"+session['LOGON.USERID']+"^"+EpisodeID+"^^"+operMem+"^"+bloodTypeId+"^^^^^^"+operDuration+"^"+opDocNote+"^"+planSeq+"^^^^";
     var appOperInfo=mainOperStr+"^"+preDiagStr+"^"+""+"^"+""+"^"+operLocationId+"^"+bodySiteId+"^"+operPosId+"^"+subOperStr;
     var assDocIdStr="";
     var strCheck=HbsAgDesc+"^"+HcvAbDesc+"^"+HivAbDesc+"^"+SyphilisDesc+"^"+operType+"^"+labTestNote+"^"+RHBloodTypeDesc+"^"+isoOperation+"^"+isPrepareBlood+"^"+isTransAutoblood+"^"+isECC
                  +"^"+isAnaest+"^^^^^"+reentryOperation+"^"+materialMem;
     
     if((opaId==null)||(opaId=="")) return;
     else{
        var result=$.m({
             ClassName:"web.DHCANOPArrangeHISUI",
             MethodName:"updatewardRecord",
             itmjs:"InsertAddOnOperation",
             itmjsex:"",
             opaId:opaId,
             str1:str1,
             op:appOperInfo,
             ass:assDocIdStr,
             strcheck:strCheck,
             anmetId:anaMethod,
             apptype:"ward"
         },false)

         if(result!=0)
         {
	         window.returnValue=0;	//20181207
             $.messager.alert("错误","修改手术申请错误："+result,"warning");
             return;
         }else{
             $.messager.confirm("确认","修改手术申请成功，是否继续修改其他信息？",function(r){
                    if(!r)
                {
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
         }
     }
}
//关闭窗口
function closeWindow(){
	window.returnValue=0;	//20181207
    window.close();
}
function CheckData(){
    if ((!EpisodeID)||(EpisodeID=="")){
		$.messager.alert("提示","请选择患者!","error");
		return false;
    }
    if($HUI.timespinner("#OperTime").getValue()=="") 
    {
        //$.messager.alert("提示","请手术开始时间!","error");
		//return false;
    }
    if($HUI.combobox("#BloodType").getValue()=="")
    {
        //$.messager.alert("提示","请选择患者血型!","error");
		//return false;
    }
}

function InitOperDiag()
{
			$HUI.combobox("#Surgeon",{});
			$HUI.combobox("#Operation",{});
			$HUI.combobox("#OperClass",{});
			$HUI.combobox("#BladeType",{});
			$HUI.combobox("#SurgeonLoc",{});
			$HUI.combobox("#OpDocGroup",{});
			$HUI.combobox("#SurgonAss1",{});
			$HUI.combobox("#SurgonAss2",{});
			$HUI.combobox("#SurgonAss3",{});
			$HUI.combobox("#SurgonAsso",{});
    var surgeon=$HUI.combobox("#Surgeon",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //2
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	       if( typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}

            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="Y";
            param.ifDayOper="";
            param.operId=surgeonoperId;
        },
       
        onChange:function(newValue, oldValue)
        {
	        //主刀变，手术重新加载
	        var lastloc="";
	         var lastlocdes=$("#SurgeonLoc").combobox("getText");
	       if( typeof lastlocdes =="undefined") {lastloc="";}
	        else{ lastloc=$("#SurgeonLoc").combobox("getValue");}
	        if(lastloc=="")
	        {
	        	$('#SurgeonLoc').combobox("reload");
	        }
	        var lastoper="";
	        //$("#Operation").combobox("getValue");
	        var lastoperdesc=$("#Operation").combobox("getText");
	        if(typeof lastoperdesc =="undefined") {lastoper="";}
	        else{ lastoper=$("#Operation").combobox("getValue");}
	        if(lastoper=="")
	        {
	        	$('#Operation').combobox("reload");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#Surgeon");
            },
        mode:"remote"
    });

	
    var operation=$HUI.combobox("#Operation",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindOrcOperation&ResultSetType=array",
        valueField:"rowid",
        textField:"OPTypeDes",
         onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindOrcOperation&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //4
	        var surgeonId="";
	        var surgeonttt=$("#Surgeon").combobox("getText");
	        if( typeof surgeonttt =="undefined") {surgeonId="";}
	        else{surgeonId=$("#Surgeon").combobox("getValue");}
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        
            param.operDescAlias=param.q;
            param.OpDocId=surgeonId;
            param.ifDayOper="";
            param.surgeonLocId="";	//20180727+dyl+3:手术不再与科室有关联
        },
        onSelect:function(record)
        {
	        //5
			var operId=record.rowid;
			 if(operId!="")
	        {
		        $('#OpDocGroup').combobox("disable");
	        }
	        var retStr=$.m({
        	ClassName:"web.DHCANOPArrangeHISUI",
        	MethodName:"GetOperRelated",
        	operId:operId
    		},false);
      		if (retStr=="") return;
	  		var operRelatedList=retStr.split("^");
	  		if (operRelatedList.length<8) return;
	  		loadCombobox("#OperClass",operRelatedList[0]+"!"+operRelatedList[1]);
	  		loadCombobox("#BladeType",operRelatedList[2]+"!"+operRelatedList[3]);
	        var lastsur="";
	        //var lastsur=$("#Surgeon").combobox("getValue");
	        var surgeonscr=$("#Surgeon").combobox("getText");
	        if( typeof surgeonscr =="undefined") {lastsur="";}
	        else{lastsur=$("#Surgeon").combobox("getValue");}
	        if(lastsur=="")
	        {
	        	$("#Surgeon").combobox("reload");
	        }
	         //20180727+dyl+4:手术不再与科室有关联
	       
	        //alert(record.rowid)
        },
        onHidePanel: function () {
               OnHidePanel("#Operation");
            },
        mode:"remote"
    });
	
    var operclass=$HUI.combobox("#OperClass",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOPLevel&ResultSetType=array",
        valueField:"ANCOPLRowId",
        textField:"ANCPLDesc",
       onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOPLevel&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        editable:false
    });
    
    var bladetype=$HUI.combobox("#BladeType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBladeType&ResultSetType=array",
        valueField:"BLDTPRowId",
        textField:"BLDTPDesc",
       onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBladeType&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        editable:false
    });

	
    var surgeonLoc=$HUI.combobox("#SurgeonLoc",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindSurgeonLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
	        //20180727+dyl+1
	        var surgeonId="";
	        var surgeon1=$("#Surgeon").combobox("getText");
	        if (typeof surgeon1=="undefined") {surgeonId="";}
	       else{surgeonId=$("#Surgeon").combobox("getValue");}
	        
	        var surgeonoperId="";
	        var oper1=$("#Operation").combobox("getText");
	         if (typeof (oper1)=="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID=EpisodeID;
            param.operId="";	//surgeonoperId
            param.surgeonId=surgeonId;
        },
        onSelect:function(record){
	        //$("#Operation").combobox("reload");
	        $("#Surgeon").combobox("reload");
	        $("SurgeonAss1").combobox("reload");
	        $("SurgeonAss2").combobox("reload");
	        $("SurgeonAss3").combobox("reload");
	        $("#SurgonAsso").combobox("reload");
	        $("#OpDocGroup").combobox("reload");
        },
        onHidePanel: function () {
               OnHidePanel("#SurgeonLoc");
            },
             onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=FindSurgeonLocList&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        mode:"remote"
    });
    $("#SurgeonLoc").combobox("setValue",applocid);
    $("#SurgeonLoc").combobox("setText",applocdesc);
	    
        //手术医师组
        var OpDocGroup=$HUI.combobox("#OpDocGroup",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindODGroupNew&ResultSetType=array",
        valueField:"groupID",
        textField:"groupID",
        editable:false,
        panelWidth:300,
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindODGroupNew&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
		onBeforeLoad:function(param)
        {
            param.OpDeptId=$("#SurgeonLoc").combobox("getValue");
        },
         onSelect:function(record)
        {
	        //5
	       var doc1=record.surgeon;
	       var doc1Id=record.surgeonID;
			var ass1=record.frtAss;
			var ass1Id=record.frtAssID;
			var ass2=record.secAss;
			var ass2Id=record.secAssID;
			var ass3=record.trdAss;
			var ass3Id=record.trdAssID;
			//alert(doc1+"|"+doc1Id+"+"+ass1)
			$("#Surgeon").combobox("setValue",doc1Id)
			$("#Surgeon").combobox("setText",doc1)
			$("#SurgonAss1").combobox("setValue",ass1Id)
			$("#SurgonAss1").combobox("setText",ass1)
			$("#SurgonAss2").combobox("setValue",ass2Id)
			$("#SurgonAss2").combobox("setText",ass2)
			$("#SurgonAss3").combobox("setValue",ass3Id)
			$("#SurgonAss3").combobox("setText",ass3)
	  		//loadCombobox("#Surgeon",doc1Id+"!"+doc1);
	  		//loadCombobox("#SurgonAss1",ass1Id+"!"+ass1);
			//loadCombobox("#SurgonAss2",ass2Id+"!"+ass2);
			//loadCombobox("#SurgonAss3",ass3Id+"!"+ass3);
			$('#Operation').combobox("reload");
	       
        },
         mode:"remote"
    });

    
    //助手1
    var surgeonass1=$HUI.combobox("#SurgonAss1",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
         onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc=="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
	        var curvalue=record.ctcpId;
	        var sdocId=$("#Surgeon").combobox("getValue");
	        
	        var ss2Id=$("#SurgonAss2").combobox("getValue");
	        var ss3Id=$("#SurgonAss3").combobox("getValue");
	        var ssoId=$("#SurgonAsso").combobox("getValues");
	        if((sdocId==curvalue)||(ss2Id==curvalue)||(ss3Id==curvalue)||(((ssoId+",").indexOf((curvalue+","))!=-1)&&(ssoId!="")))
	        {
		        $.messager.alert("提示", "该医生已经选择，请选择其他医护人员", 'info');
		        $("#SurgonAss1").combobox("setValue","");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#SurgonAss1");
            },
        mode:"remote"
    });
    //助手2
        var surgeonass2=$HUI.combobox("#SurgonAss2",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
	        var curvalue=record.ctcpId;
	        var sdocId=$("#Surgeon").combobox("getValue");
	        var ss1Id=$("#SurgonAss1").combobox("getValue");
	        var ss3Id=$("#SurgonAss3").combobox("getValue");
	        var ssoId=$("#SurgonAsso").combobox("getValues");
	        //ss1Id.indexOf(curvalue)!=-1)
	        if((sdocId==curvalue)||(ss1Id==curvalue)||(ss3Id==curvalue)||(((ssoId+",").indexOf((curvalue+","))!=-1)&&(ssoId!="")))
	        {
		        $.messager.alert("提示", "该医生已经选择，请选择其他医护人员", 'info');
		        $("#SurgonAss2").combobox("setValue","");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#SurgonAss2");
            },
        mode:"remote"
    });
	//助手3
    var surgeonass3=$HUI.combobox("#SurgonAss3",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
	        var curvalue=record.ctcpId;
	        var sdocId=$("#Surgeon").combobox("getValue");
	        var ss2Id=$("#SurgonAss2").combobox("getValue");
	        var ss1Id=$("#SurgonAss1").combobox("getValue");
	        var ssoId=$("#SurgonAsso").combobox("getValues");
	        if((sdocId==curvalue)||(ss1Id==curvalue)||(ss2Id==curvalue)||(((ssoId+",").indexOf((curvalue+","))!=-1)&&(ssoId!="")))
	        {
		        $.messager.alert("提示", "该医生已经选择，请选择其他医护人员", 'info');
		        $("#SurgonAss3").combobox("setValue","");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#SurgonAss3");
            },
        mode:"remote"
    });
    
    var surgeonasso=$HUI.combobox("#SurgonAsso",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc=="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt=="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
        var curvalue=record.ctcpId;
        //alert(curvalue)
        },
        mode:"remote"
    })


	//$("#Operation").combobox("setValue","");
}



/// 添加一条手术到手术列表
function addAnaestOperation() {
    $("#operDialog").dialog({
        title: "新增手术",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    operloadflag=1;
    $("#operDialog").dialog("open");
    $("#OpSubDr").val("")	//20190118+dyl+7
    //setOperFormDefaultValue();
}
//修改手术信息
function editAnaestOperation(){
    var selectRow=$("#operationBox").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "修改手术",
            iconCls: "icon-w-edit"
        });
         InitOperDiag();
        //$("#operationForm").form('load',selectRow);
               var soperId=selectRow.Operation;
        var soperDesc=selectRow.OperationDesc;
        var soperClassId=selectRow.OperClass;
        var soperClassDesc=selectRow.OperClassDesc;
        var sbladeTypeId=selectRow.BladeType;
        var sbladeTypeDesc=selectRow.BladeTypeDesc;
        var ssurgeonLocId=selectRow.SurgeonLoc;
        var ssurgeonLocDesc=selectRow.SurgeonLocDesc;
        var ssurgeonId=selectRow.Surgeon;
        var ssurgeonDesc=selectRow.SurgeonDesc;
        var ssurgonAss1Id=selectRow.SurgonAss1;
        var ssurgonAss1Desc=selectRow.SurgonAss1Desc;
        var ssurgonAss2Id=selectRow.SurgonAss2;
        var ssurgonAss2Desc=selectRow.SurgonAss2Desc;
        var ssurgonAss3Id=selectRow.SurgonAss3;
        var ssurgonAss3Desc=selectRow.SurgonAss3Desc;
        var sSurgonAssoStr=selectRow.SurgonAsso;
        
        var sSurgonAssoDesc=selectRow.SurgonAssoDesc;
        var soperNote=selectRow.OperNote;
        $("#SurgeonLoc").combobox('setValue',ssurgeonLocId);
		$("#SurgeonLoc").combobox('setText',ssurgeonLocDesc);
        if(ssurgeonLocId!="")
        {
       	//$('#OpDocGroup').combobox("reload");
		//$('#Surgeon').combobox("reload");
		//$('#SurgonAss1').combobox("reload");
		//$('#SurgonAss2').combobox("reload");
		//$('#SurgonAss3').combobox("reload");
		//$('#SurgonAsso').combobox("reload");
        }
		//alert(ssurgeonId+"/"+ssurgeonLocId)
        $("#Operation").combobox('setValue',soperId);
        $("#Operation").combobox('setText',soperDesc);
         $("#OperClass").combobox('setValue',soperClassId);
         $("#OperClass").combobox('setText',soperClassDesc);
        $("#BladeType").combobox('setValue',sbladeTypeId);
        $("#BladeType").combobox('setText',sbladeTypeDesc);
        $("#Surgeon").combobox('setValue',ssurgeonId);
         $("#Surgeon").combobox('setText',ssurgeonDesc);
        $("#SurgonAss1").combobox('setValue',ssurgonAss1Id);
         $("#SurgonAss1").combobox('setText',ssurgonAss1Desc);
        $("#SurgonAss2").combobox('setValue',ssurgonAss2Id);
         $("#SurgonAss2").combobox('setText',ssurgonAss2Desc);
        $("#SurgonAss3").combobox('setValue',ssurgonAss3Id);
         $("#SurgonAss3").combobox('setText',ssurgonAss3Desc);
        if(sSurgonAssoStr!="")
        {
	        var newsurother=getIdStr(sSurgonAssoStr)
        	$("#SurgonAsso").combobox('setValues',newsurother)
        }
        $("#OperNote").val(soperNote);
        var ssubOpSub=selectRow.OpSub;
        $("#OpSubDr").val(ssubOpSub)	////20190118+dyl+4
        //$("#SurgonAsso").combobox('setText',sSurgonAssoDesc)
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");

    }else{
        $.messager.alert("提示", "请先选择要修改的手术！", 'info');
        return;
    }
}
function removeAnaestOperation(){
    var selectRow=$HUI.datagrid("#operationBox").getSelected();
    var rowIndex=$HUI.datagrid("#operationBox").getRowIndex(selectRow);
    if(selectRow)
    {
	     $("#OpSubDr").val("")	//20190118+dyl+9
        $HUI.datagrid("#operationBox").deleteRow(rowIndex);
    }else{
        $.messager.alert("提示", "请先选择要删除的手术！", 'info');
        return;
    }
}
//保存手术信息到前台datagrid中
function saveOperation()
{
    var operId=$HUI.combobox("#Operation").getValue();
    var operDesc=$HUI.combobox("#Operation").getText();
    var operNote=$("#OperNote").val();
    if(operId=="")
    {
        $.messager.alert("提示","手术名称不能为空！","error");
        return;
    }
    var operClassId=$HUI.combobox("#OperClass").getValue();
    var operClassDesc=$HUI.combobox("#OperClass").getText();
    if(operClassId=="")
    {
        $.messager.alert("提示","手术分级不能为空！","error");
        return;
    }
    var bladeTypeId=$HUI.combobox("#BladeType").getValue();
    var bladeTypeDesc=$HUI.combobox("#BladeType").getText();
    if(bladeTypeId=="")
    {
        $.messager.alert("提示","切口类型不能为空！","error");
        return;
    }
    var surgeonLocId=$HUI.combobox("#SurgeonLoc").getValue();
    var surgeonLocDesc=$HUI.combobox("#SurgeonLoc").getText();
    var surgeonId=$HUI.combobox("#Surgeon").getValue();
    var surgeonDesc=$HUI.combobox("#Surgeon").getText();
    if(surgeonId=="")
    {
        $.messager.alert("提示","手术医生不能为空！","error");
        return;
    }
    //var surgeonNote=$("#SurgeonNote").val();
    var surgonAss1Id=$HUI.combobox("#SurgonAss1").getValue();
    var surgonAss1Desc=$HUI.combobox("#SurgonAss1").getText();
    if(surgonAss1Desc=="")
    {
	    surgonAss1Id="";
    }
    
    var surgonAss2Id=$HUI.combobox("#SurgonAss2").getValue();
    var surgonAss2Desc=$HUI.combobox("#SurgonAss2").getText();
    if(surgonAss2Desc=="")
    {
	    surgonAss2Id="";
    }
    
    var surgonAss3Id=$HUI.combobox("#SurgonAss3").getValue();
    var surgonAss3Desc=$HUI.combobox("#SurgonAss3").getText();
    if(surgonAss3Desc=="")
    {
	    surgonAss3Id="";
    }
    
    var SurgonAssoId=$HUI.combobox("#SurgonAsso").getValue();
    var SurgonAssoDesc=$HUI.combobox("#SurgonAsso").getText();
    if(SurgonAssoDesc=="")
    {
	    SurgonAssoId="";
    }
    var opsub=$("#OpSubDr").val()	////20190118+dyl+5
    var rowdata={
        Operation:operId,
        OperationDesc:operDesc,
        OperClass:operClassId,
        OperClassDesc:operClassDesc,
        BladeType:bladeTypeId,
        BladeTypeDesc:bladeTypeDesc,
        SurgeonLoc:surgeonLocId,
        SurgeonLocDesc:surgeonLocDesc,
        Surgeon:surgeonId,
        SurgeonDesc:surgeonDesc,
        //SurgeonNoteDesc:surgeonNote,
        SurgonAss1:surgonAss1Id,
        SurgonAss1Desc:surgonAss1Desc,
        SurgonAss2:surgonAss2Id,
        SurgonAss2Desc:surgonAss2Desc,
        SurgonAss3:surgonAss3Id,
        SurgonAss3Desc:surgonAss3Desc,
        SurgonAsso:SurgonAssoId,
        SurgonAssoDesc:SurgonAssoDesc,
        OperNote:operNote,
        OpSub:opsub	//20190118+dyl+6
    }
    if( $("#EditOperation").val()=="Y")
    {
        //var rowIndex=$HUI.datagrid("#operationBox").getRowIndex();
		$HUI.datagrid("#operationBox").updateRow({index:selectOperIndex,row:rowdata});    
		}
    else
    {
	    var exsitflag=0;
        var data=$HUI.datagrid("#operationBox").getData();
       // alert(data)
        if(data.rows.length>0)
        {
            $.each(data.rows,function(i,row){
                if((row.Operation==rowdata.Operation)||(row.OperationDesc==rowdata.OperationDesc))
                {
                    $.messager.alert("提示","该手术已存在!","error");
                    exsitflag=1;
                    return;
                }
            });
        }
        if(exsitflag==1) return;
        $HUI.datagrid("#operationBox").appendRow(rowdata);
    
    }
    $HUI.dialog("#operDialog").close();
}

//加载默认术前诊断
function setDefaultPrevDiagnos(preDiag)
{
    var datas=[];
    if(preDiag!="")
    {
        var preDiagList=preDiag.split(",");
        if(preDiagList.length>0)
        {
            for(var i=0;i<preDiagList.length;i++)
            {
                var item=preDiagList[i].split("!");
                if((item[0]=="")&&(item[1]=="")) continue;
                var data={DiagID:item[0],DiagDesc:item[1]};
                datas.push(data);
            }
        }
    }
    $("#preopDiagBox").datagrid('loadData',datas);
    setPrevDiagnos();
}
//20190102+mfc
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
	    if (txt!="")
	    {
	    	$.messager.alert("提示","请从下拉框选择","error"); 
	    	$(item).combobox('setValue',"");
	    	$(item).combobox("setText","");
	    	$(item).combobox("reload");
	    	return;
	    }
	}
}
//选择急诊设置默认手术日期和保存按钮是否可用
function setOperDateAndBtn(){
	var curOptype=$("#OperType").combobox("getValue");
    if(curOptype==="E")
    {
        var curDate=$.m({
            ClassName:"web.DHCANOPCom",
            MethodName:"GetCurentDate",
            ifDisbled:"1"
        },false);
        $HUI.datebox("#OperDate").setValue(curDate);
        $("#btnSave").linkbutton('enable');
    }else{
        var operDate=$.m({
            ClassName:"web.DHCANOPCom",
            MethodName:"GetInitialDateOld",
            userId:session['LOGON.USERID'],
            userGroupId:session['LOGON.GROUPID'],
            ctlocId:session['LOGON.CTLOCID']
        },false);
        $HUI.datebox("#OperDate").setValue(operDate);
        if(checkIfOutTime())
        {
            $("#btnSave").linkbutton('disable');
        }
    }
}
//设置拟施麻醉是否必填
function setPrevAnaMethodIsRequired()
{
	var newValue=$("#IsAnaest").combobox("getValue");
    if (newValue == "Y") {
            $("#PrevAnaMethod").combobox({
                required: true,
                 disabled:false
            });
        } else {
            $("#PrevAnaMethod").combobox({
                required: false
            });
            $("#PrevAnaMethod").combobox("disable");
        }
}



//-------------------------