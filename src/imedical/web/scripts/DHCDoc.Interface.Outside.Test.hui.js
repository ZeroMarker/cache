var PageLogicObj={
	ExtOrgCode:"ZZJ"	
}
var arrayObj1=new Array(
      new Array("Btn_FindPatientCard","FindPatientCard"),
      new Array("Btn_SavePatientCard","SavePatientCard"),
	  new Array("Btn_UpdatePatInfo","UpdatePatInfo"),
	  new Array("Btn_LockOrder","LockOrder"),
      new Array("Btn_UnLockOrder","UnLockOrder"),
	  new Array("Btn_OPRegister","OPRegister"),
	  new Array("Btn_BookService","BookService"),
	  new Array("Btn_GetPatInfo","GetPatInfo"),
	  new Array("Btn_QueryAdmOPReg","QueryAdmOPReg"),
	  new Array("Btn_OPRegReturn","OPRegReturn"),
	  new Array("Btn_QueryPatList","QueryPatList"),
	  new Array("Btn_QueryStopDoctorInfo","QueryStopDoctorInfo"),
	  new Array("Btn_QueryOPAppArriveList","QueryOPAppArriveList"),
	  new Array("Btn_OPAppArrive","OPAppArrive"),
	  new Array("Btn_CancelOrder","CancelOrder"),
	  new Array("Btn_QueryPatCard","QueryPatCard"),
	  new Array("Btn_GetInsuRegPara","GetInsuRegPara"),
	  new Array("Btn_QueryRegStatus","QueryRegStatus"),
	  new Array("Btn_GetOPAllocReport","GetOPAllocReport"),
	  new Array("Btn_OPAllocAutoReport","OPAllocAutoReport")
)

var arrayObj2=new Array(
      new Array("Btn_LockOrder","LockOrder"),
      new Array("Btn_UnLockOrder","UnLockOrder"),
	  new Array("Btn_OPRegister","OPRegister"),
	  new Array("Btn_BookService","BookService"),
	  new Array("Btn_GetPatInfo","GetPatInfo")
)

var arrayObj3=new Array(
      new Array("List_QueryAdmOPReg","QueryAdmOPReg"),
      new Array("List_QueryOPAppArriveList","QueryOPAppArriveList"),
      new Array("List_GetOPAllocReport","GetOPAllocReport")
)

$(document).ready(function(){
	//Init();
	InitHospList();
	InitEvent();
})

function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Interface_OutsideTest",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){	
		ClearData();	
		Init();
		ReloadCardTypeList();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function ClearData(){
	$('input[type="text"]').val("");
	//$("#Text_ExtUserID,#Text_PatientID,#Text_TransactionId,#Text_RegFee,#Text_ScheduleItemCode,#Text_LockQueueNo,#Text_Reponse").val("");
	$("#List_QueryDepartment,#List_QueryDoctor,#List_QueryAdmSchedule,#List_GetPatBillType,#List_QueryTimeRange").combobox('setValue',"").combobox('setText',"");
	$("#Comb_ScheduleDate").datebox('setValue',"");
}
function Init(){ 
	InitPatBillType();
	InitDepartmentGroup();
	 
	InitDepartment();
	 
	//InitDoctor();
	$("#"+"Text_Reponse"+"").val("");
}

function InitEvent(){
	InitCombScheduleDate();
	InitTimeRange();
	InitTransactionId();
	$HUI.tabs("#main_container",{
		onSelect:function(){
			InitPatientID();
			InitCardTypeList();
			InitCardNo();
		}
	})
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		InitBtnClick(param1,param2);    
	}
	$(document.body).bind("keydown",BodykeydownHandler);
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    /*if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}*/
}

function InitTransactionId(){
	$('#Text_TransactionId').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var HospitalId=$HUI.combogrid('#_HospList').getValue()
			var TransactionId=$("#Text_TransactionId").val();
			if(TransactionId=="") return;
			var QueueNoActive=tkMakeServerCall("web.DHCLockSchedule","CheckQueueNoActive",TransactionId,"","","",HospitalId)
			if(QueueNoActive.indexOf("^")>-1){
				var QueueNoActiveFlag=QueueNoActive.split("^")[0];
				var QueueNoActiveStr=QueueNoActive.split("^")[1];
				if(QueueNoActiveFlag=="1"){
					var ScheduleItemCode=QueueNoActiveStr.split("!")[0];
					var InsertQueueNo=QueueNoActiveStr.split("!")[1];
					var PatientID=QueueNoActiveStr.split("!")[2];
					var Fee=QueueNoActiveStr.split("!")[3];
					$("#Text_ScheduleItemCode").val(ScheduleItemCode);
					$("#Text_LockQueueNo").val(InsertQueueNo);
					$("#Text_PatientID").val(PatientID);
					$("#Text_RegFee").val(Fee);
				}else{
					if(QueueNoActiveFlag=="Reg"){QueueNoActiveFlag="该号已支付";}
					else if(QueueNoActiveFlag=="NotSamePerson"){QueueNoActiveFlag="该号已被他人锁定";}
					else if(QueueNoActiveFlag=="-100"){QueueNoActiveFlag="订单在系统中不存在";}
					else if(QueueNoActiveFlag=="-101"){QueueNoActiveFlag="锁号错误";}
					else if(QueueNoActiveFlag=="NotCurHosp"){QueueNoActiveFlag="非当前院区的订单，不能操作";}
					else{QueueNoActiveFlag="锁号错误";}
					dhcsys_alert(QueueNoActiveFlag)	
				}
			}else{
				dhcsys_alert("订单信息："+"订单在系统中不存在")
			}
			var HospitalId=$HUI.combogrid('#_HospList').getValue();
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			var request="<Request><TradeCode>1108</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType></CardType><TransactionId>"+TransactionId+"</TransactionId><IDNo></IDNo><PatienName></PatienName></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryRegStatus",
				'RequestStr':request,	
				'HospitalId':HospitalId
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					$("#"+"Text_Reponse"+"").val(objScope.result);
				}
		    })
		}
    });
		
}
function InitPatientID(e){
	var TabValue=GetTabValue();
	$('#Text_PatientID'+TabValue).bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var patNo=$("#Text_PatientID"+TabValue).val();
			var PatientNoLen=tkMakeServerCall("web.DHCDTHealthCommon","GetPatientNoLen")
			if(patNo=="") return;
			for (var i=(PatientNoLen-patNo.length-1); i>=0; i--) {
				patNo="0"+patNo;
			}
			$("#Text_PatientID"+TabValue).val(patNo);
			//var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
		}
    });
}

function ReloadCardTypeList(){
	var TabValue=GetTabValue();
	if($("#List_CardType"+TabValue).length>0){
		$HUI.combobox("#List_CardType"+TabValue).reload()
	}
}
function InitCardTypeList()
{
	var TabValue=GetTabValue();
	if($("#List_CardType"+TabValue).length>0){
		$HUI.combobox("#List_CardType"+TabValue,{      
	    	valueField:'RowId',   
	    	textField:'Code',
	    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Config&QueryName=FindList&ListName=BarCardType&GroupRowId=&ResultSetType=array",  
	    	onLoadSuccess:function(){
		    	$HUI.combobox("#List_CardType"+TabValue).clear();	
		    },onBeforeLoad:function(param){
				param.HospitalId=$HUI.combogrid('#_HospList').getValue();
			}
		});	
	}
}

function InitCardNo(){
	var TabValue=GetTabValue();
	$('#Text_CardNo'+TabValue).unbind();
	$('#Text_CardNo'+TabValue).bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var CardTypeCode=$("#List_CardType"+TabValue).combobox('getValue');
			if(CardTypeCode==""){
				$.messager.alert("提示","请选择正确的卡类型","warning");	
				return false;	
			}
			var CardNo=$("#Text_CardNo"+TabValue).val();
			var CardNoLen=tkMakeServerCall("DHCDoc.Interface.Outside.Test.Service","GetCardNoLenByType",CardTypeCode)
			if(CardNo=="") return;
			for (var i=(CardNoLen-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
			$("#Text_CardNo"+TabValue).val(CardNo);
			var PatientID=tkMakeServerCall("DHCExternalService.RegInterface.SelfRegMethods","getPatIDByCardInfo",CardTypeCode,CardNo);
			var PatientID=tkMakeServerCall("DHCExternalService.CardInterface.CardManager","PatientIDToNo",PatientID);
			$("#Text_PatientID"+TabValue).val(PatientID);
		}
    });	
}

function InitPatBillType(){	
	$HUI.combobox("#List_GetPatBillType",{
		valueField:'RowId',   
    	textField:'Desc',
		editable:true,
		url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=GetPatBillType&RequestStr=&HospitalId=&ResultSetType=array",
		onBeforeLoad:function(param){
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				return false;	
			}
			var PatientID=$("#"+"Text_PatientID"+"").val();
			if(PatientID==""){
				return false;	
			}
			var RequestStr="<Request><TradeCode>3302</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID>"+PatientID+"</PatientID><PatientName></PatientName></Request>"
			param.RequestStr=RequestStr;
			param.HospitalId=$HUI.combogrid('#_HospList').getValue();
		},
    	onShowPanel:function(){
	    	var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				$.messager.alert("提示","请填写操作员工号.","warning");
				$("#List_GetPatBillType").combobox('hidePanel');
				return false;	
			}
			var PatientID=$("#"+"Text_PatientID"+"").val();
			if(PatientID==""){
				$.messager.alert("提示","请填写患者信息.","warning");
				$("#List_GetPatBillType").combobox('hidePanel');
				return false;	
			}
			$(this).combobox("reload")
			var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var RequestStr="<Request><TradeCode>3302</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID>"+PatientID+"</PatientID><PatientName></PatientName></Request>"
	    	$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"GetPatBillType",
				'RequestStr':RequestStr,
				'HospitalId':HospRowId
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					$("#"+"Text_Reponse"+"").val(objScope.result);
				}
		    })
		},
		onChange:function(newValue, oldValue){
			if(newValue==""){
			}
		},
		onSelect:function(){
			var boxvalue=$('#List_GetPatBillType').combobox('getValue');
			if(boxvalue){
			}else{
				$.messager.alert("提示","参数获取错误","warning");
				return false;	
			} 
		}	
	})
}

function InitDepartmentGroup(){	
	$HUI.combobox("#List_QueryDepartmentGroup",{
		valueField:'RowId',   
    	textField:'Desc',
		editable:true,
		url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=QueryDepartmentGroup&RequestStr=&HospitalId=&ResultSetType=array",
		onBeforeLoad:function(param){
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				return false;	
			}
			var RequestStr="<Request><TradeCode>1014</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID></Request>"
			param.RequestStr=RequestStr;
			param.HospitalId=$HUI.combogrid('#_HospList').getValue();
		},
    	onShowPanel:function(){
	    	var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				$.messager.alert("提示","请填写操作员工号.","warning");
				$("#List_QueryDepartmentGroup").combobox('hidePanel');
				return false;	
			}
			$(this).combobox("reload")
			var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var RequestStr="<Request><TradeCode>1014</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID></Request>"
	    	$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryDepartmentGroup",
				'RequestStr':RequestStr,
				'HospitalId':HospRowId
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					$("#"+"Text_Reponse"+"").val(objScope.result);
				}
		    })
		},
		onChange:function(newValue, oldValue){
			if(newValue==""){
				InitDepartment(); 
			}
		},
		onSelect:function(){
			var boxvalue=$('#List_QueryDepartmentGroup').combobox('getValue');
			if(boxvalue){
				InitDepartment(); 
			}else{
				$.messager.alert("提示","参数获取错误","warning");
				return false;	
			} 
		}	
	})
}

function InitDepartment(){
	$HUI.combobox("#"+"List_QueryDepartment"+"",{    
    	valueField:'RowId',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=QueryDepartment&RequestStr=&HospitalId=&ResultSetType=array",
    	onBeforeLoad:function(param){
	    	var HospRowId=$HUI.combogrid('#_HospList').getValue();
			var Groupvalue=$('#List_QueryDepartmentGroup').combobox('getValue');
			var ExtUserID=$("#"+"Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				return false;
			}
			var RequestStr="<Request><TradeCode>1012</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentGroupCode>"+Groupvalue+"</DepartmentGroupCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType></Request>"
			param.RequestStr=RequestStr;
			param.HospitalId=$HUI.combogrid('#_HospList').getValue();
		},
    	onShowPanel:function(){
	    	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var Groupvalue=$('#List_QueryDepartmentGroup').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				$.messager.alert("提示","请填写操作员工号.","warning");
				$("#List_QueryDepartment").combobox('hidePanel');
				return false;	
			}
			$(this).combobox("reload");
	    	var RequestStr="<Request><TradeCode>1012</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentGroupCode>"+Groupvalue+"</DepartmentGroupCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryDepartment",
				'RequestStr':RequestStr,
				'HospitalId':HospRowId
		    },function testget(objScope){
				if(objScope){
					$("#"+"Text_Reponse"+"").val("");
					$("#"+"Text_Reponse"+"").val(objScope.result);
				}
		    })
		},
		onChange:function(newValue, oldValue){
			if(newValue==""){
				InitDoctor(); 
				InitSchedule();
			}
		},
		onSelect:function(){
			var boxvalue=$('#List_QueryDepartment').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				InitDoctor(); 
				InitSchedule();
			}else{
				$.messager.alert("提示","参数获取错误","warning");
				return false;	
			} 
			
		},filter:function(q, row){
			q=q.toUpperCase();
			return (row["AliasDesc"].toUpperCase().indexOf(q) >= 0)||(row["Desc"].toUpperCase().indexOf(q) >= 0);
		}
	});
}

function InitDoctor(){
	var DepartmentVal=$('#List_QueryDepartment').combobox('getValue');
	var ExtUserID=$("#"+"Text_ExtUserID"+"").val();
	if(ExtUserID==""){
		//$.messager.alert("提示","请填写操作员工号.");
		//return false;
	}
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var RequestStr="<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentCode>"+DepartmentVal+"</DepartmentCode></Request>"
	$HUI.combobox("#"+"List_QueryDoctor"+"",{    
    	valueField:'RowId',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=QueryDoctor&RequestStr="+RequestStr+"&HospitalId="+HospRowId+"&ResultSetType=array",
    	onShowPanel:function(){
	    	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var DepartmentVal=$('#List_QueryDepartment').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(DepartmentVal==""){
				$.messager.alert("提示","请选择挂号科室.","warning");
				$("#List_QueryDoctor").combobox('hidePanel');
				return false;	
			}
	    	var RequestStr="<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentCode>"+DepartmentVal+"</DepartmentCode></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryDoctor",
				'RequestStr':RequestStr,
				'HospitalId':HospRowId
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					//window.setTimeout("InitDoctor()",1000); 
					$("#"+"Text_Reponse"+"").val(objScope.result);
					//$HUI.combobox('#List_QueryDoctor').clear();
				}
		    })
		},
		onLoadSuccess:function(){
			$HUI.combobox('#List_QueryDoctor').clear();	
		},
		onSelect:function(){
			var boxvalue=$('#List_QueryDepartment').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				$("#List_QueryTimeRange").combobox('setValue','').combobox('setText','')
				$HUI.combobox("#List_QueryTimeRange",{data:""})
				//var DepartmentID = $('#List_QueryDepartment').combobox('getValue');
				InitSchedule();
			}else{
				$.messager.alert("提示","参数获取错误","warning");
				return false;	
			} 
			
		},filter:function(q, row){
			q=q.toUpperCase();
			return (row["AliasDesc"].toUpperCase().indexOf(q) >= 0)||(row["Desc"].toUpperCase().indexOf(q) >= 0);
		}
	});		
}

function InitCombScheduleDate(){
	$("#Comb_ScheduleDate").datebox({
		formatter :function(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return dtformat=="YMD"?(y+'-'+m+'-'+d):(d+'/'+m+'/'+y);
		},
		onSelect:function(){
			$("#"+"Text_Reponse"+"").val("");
			InitSchedule();	
		}
	
	});
}

function InitSchedule(){
	$HUI.combobox("#"+"List_QueryAdmSchedule").setValue("");
	var DepartmentCode=$('#List_QueryDepartment').combobox('getValue');
	var DoctorCode=$('#List_QueryDoctor').combobox('getValue');
	var ScheduleDate=$('#Comb_ScheduleDate').datebox('getValue');
	var ExtUserID=$("#"+"Text_ExtUserID"+"").val();
	var PatientID=$("#"+"Text_PatientID"+"").val();
	var PatBillType=$('#List_GetPatBillType').combobox('getValue');
	if(ExtUserID==""){
		//$.messager.alert("提示","请填写操作员工号.");
		//return false;
	}
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var RequestStr="<Request><TradeCode>1004</TradeCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><ExtUserID>"+ExtUserID+"</ExtUserID><StartDate>"+ScheduleDate+"</StartDate><EndDate>"+ScheduleDate+"</EndDate><DepartmentCode>"+DepartmentCode+"</DepartmentCode><BillTypeID>"+PatBillType+"</BillTypeID><DoctorCode>"+DoctorCode+"</DoctorCode><RBASSessionCode></RBASSessionCode><PatientID>"+PatientID+"</PatientID></Request>"
	var ObjScope=$.cm({
		ClassName:"DHCDoc.Interface.Outside.Test.Service",
		MethodName:"GetJsonStrByService",
		'DoMethodName':"QueryAdmSchedule",
		'RequestStr':RequestStr,
		'HUIFlag':"1",
		'HospitalId':HospRowId
	},false)
	//if(ObjScope=="")return;
	var EditTypeArr=new Array();
	for(var i=0;i<ObjScope.length;i++){
		//aRtnObj.ServiceDate_" "_aRtnObj.DepartmentName_" "_aRtnObj.DoctorName_" "_aRtnObj.SessionName
		var value=ObjScope[i].ScheduleItemCode;
		if (ObjScope[i].ServiceName){
			var desc=ObjScope[i].ServiceDate+" "+ObjScope[i].DoctorName+"("+ObjScope[i].ServiceName+")"+" "+ObjScope[i].SessionName+" 价格:"+ObjScope[i].Fee;
		}else{
			var desc=ObjScope[i].ServiceDate+" "+ObjScope[i].DoctorName+" "+ObjScope[i].SessionName+" 价格:"+ObjScope[i].Fee;
		}
		var onestr = {"value":value, "desc":desc};
		EditTypeArr.push(onestr);	
	}
	$HUI.combobox("#"+"List_QueryAdmSchedule",{ 
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		editable:false,
		onShowPanel:function(){
	    	var DepartmentCode=$('#List_QueryDepartment').combobox('getValue');
			var DoctorCode=$('#List_QueryDoctor').combobox('getValue');
			var ScheduleDate=$('#Comb_ScheduleDate').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			var PatBillType=$('#List_GetPatBillType').combobox('getValue');
			if(DepartmentCode==""){
				$HUI.combobox("#"+"List_QueryAdmSchedule",{data:""})
				$.messager.alert("提示","请选择挂号科室.","warning");
				$("#List_QueryAdmSchedule").combobox('hidePanel');
				return false;	
			}
			if(ScheduleDate==""){
				//$.messager.alert("提示","请选择出诊日期.");
				//return false;	
			}
			var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var RequestStr="<Request><TradeCode>1004</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><ExtUserID>"+ExtUserID+"</ExtUserID><StartDate>"+ScheduleDate+"</StartDate><EndDate>"+ScheduleDate+"</EndDate><DepartmentCode>"+DepartmentCode+"</DepartmentCode><BillTypeID>"+PatBillType+"</BillTypeID><DoctorCode>"+DoctorCode+"</DoctorCode><RBASSessionCode></RBASSessionCode><PatientID>"+PatientID+"</PatientID></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryAdmSchedule",
				'RequestStr':RequestStr,
				'HospitalId':HospRowId	
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					//window.setTimeout("InitSchedule()",1000); 
					$("#"+"Text_Reponse"+"").val(objScope.result);
					//$HUI.combobox('#List_QueryAdmSchedule').clear();
				}
		    })
		},
		onLoadSuccess:function(){
			$HUI.combobox('#List_QueryAdmSchedule').setValue("");	
		},
		onSelect:function(){
			var boxvalue=$('#List_QueryAdmSchedule').combobox('getValue');
			var boxtext=$('#List_QueryAdmSchedule').combobox('getText');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				var RegFee=boxtext.split(":")[1];
				//var RegFee=parseFloat(RegFee)*100;
				$('#Text_ScheduleItemCode').val(boxvalue);
				$('#Text_RegFee').val(RegFee);
				InitScheduleTimeRange();
			}else{
				$.messager.alert("提示","参数获取错误","warning");
				return false;	
			} 
			
		}
	})
}

function InitScheduleTimeRange(){
	$HUI.combobox("#List_QueryTimeRange").setValue("");
	var ScheduleItemCode=$('#List_QueryAdmSchedule').combobox('getValue');
	var ExtUserID=$("#"+"Text_ExtUserID"+"").val();
	var PatientID=$("#"+"Text_PatientID"+"").val();
	if(ExtUserID==""){
		//$.messager.alert("提示","请填写操作员工号.");
		//return false;
	}
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var RequestStr="<Request><TradeCode>10041</TradeCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><ExtUserID>"+ExtUserID+"</ExtUserID><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><ServiceCode></ServiceCode><RBASSessionCode></RBASSessionCode></Request>"
	var ObjScope=$.cm({
		ClassName:"DHCDoc.Interface.Outside.Test.Service",
		MethodName:"GetJsonStrByService",
		'DoMethodName':"QueryScheduleTimeInfo",
		'RequestStr':RequestStr,
		'HUIFlag':"1",
		'HospitalId':HospRowId
	},false)
	//if(ObjScope=="")return;
	var EditTypeArr=new Array();
	for(var i=0;i<ObjScope.length;i++){
		var value=ObjScope[i].StartTime+"-"+ObjScope[i].EndTime;
		var desc=ObjScope[i].StartTime+"-"+ObjScope[i].EndTime;
		var onestr = {"value":value, "desc":desc};
		EditTypeArr.push(onestr);	
	}
	EditTypeArr.splice(0,0,{"value":"", "desc":"-"})
	$HUI.combobox("#List_QueryTimeRange",{ 
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		editable:false,
		onShowPanel:function(){
			var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var ScheduleItemCode=$('#List_QueryAdmSchedule').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ScheduleItemCode==""){
				$HUI.combobox("#List_QueryTimeRange",{data:""})
				$.messager.alert("提示","请选择一个排班.","warning");
				$("#List_QueryTimeRange").combobox('hidePanel');
				return false;	
			}
			var HospRowId=$HUI.combogrid('#_HospList').getValue();
	    	var RequestStr="<Request><TradeCode>10041</TradeCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><ExtUserID>"+ExtUserID+"</ExtUserID><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><ServiceCode></ServiceCode><RBASSessionCode></RBASSessionCode></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryScheduleTimeInfo",
				'RequestStr':RequestStr,
				'HospitalId':HospRowId	
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					$("#"+"Text_Reponse"+"").val(objScope.result);
				}
		    })
		},
		onLoadSuccess:function(){
			$HUI.combobox('#List_QueryTimeRange').setValue("");	
		},
		onSelect:function(){
			var boxvalue=$(this).combobox('getValue');
			var boxtext=$(this).combobox('getText');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				
			}else{
				//$.messager.alert("提示","参数获取错误","warning");
				//return false;	
			} 
			
		}
	})
}

function InitCardBtn(param1,param2){
	$("#"+param1+"").click(function(){
		var val="CardManager";
	    ButtonClick(val,param2);
	 });	
}

function InitSelfRegBtn(param1,param2){
	$("#"+param1+"").click(function(){
		var val="SelfReg";
	    ButtonClick(val,param2);
	 });	
}

function InitBtnClick(param1,param2){
	$("#"+param1+"").click(function(){
	    ButtonClick("",param2)	
	 });
}

function ButtonClick(param1,param2){
	var HospRowId=$HUI.combogrid('#_HospList').getValue();
	var request="";
	var SelTab = $("#main_container").tabs('getSelected');    
	var TabIndex = $("#main_container").tabs('getTabIndex',SelTab);
	var TabValue="";
	if(TabIndex==0)TabValue="CardManager";
	else if(TabIndex==1)TabValue="SelfReg";
	else if(TabIndex==2)TabValue="Other";
	else if(TabIndex==4)TabValue="OPAlloc";
	var PatBillType=$('#List_GetPatBillType').combobox('getValue');
	if(TabValue=="SelfReg"){
		var ExtUserID=$("#Text_ExtUserID"+"").val();
		if(ExtUserID==""){
			$.messager.alert("提示","请填写操作员工号.","warning");
			return false;	
		}
		if(param2=="LockOrder"){
			var PatientID=$("#Text_PatientID"+"").val();
			if(PatientID==""){
				//$.messager.alert("提示","请填写患者登记号,或根据卡号确定登记号.","warning");
				//return false;	
			}
			
			var AdmSchedule=$('#List_QueryAdmSchedule').combobox('getValue');
			if(AdmSchedule==""){
				//$.messager.alert("提示","请选择出诊记录.","warning");
				//return false;	
			}
			var ScheduleTimeRange=$('#List_QueryTimeRange').combobox('getValue');
			var TimeStartTime="",TimeEndTime="";
			if(ScheduleTimeRange!=""){
				var TimeStartTime=ScheduleTimeRange.split("-")[0];
				var TimeEndTime=ScheduleTimeRange.split("-")[1];
			}
			//request="<Request><TradeCode>10015</TradeCode><CardNo></CardNo><CardTypeCode></CardTypeCode><PatientID>"+PatientID+"</PatientID><ScheduleItemCode>"+AdmSchedule+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><BeginTime></BeginTime><EndTime></EndTime></Request>"
			request="<Request><TradeCode>10015</TradeCode><CardNo></CardNo><CardTypeCode></CardTypeCode><PatientID>"+PatientID+"</PatientID><ScheduleItemCode>"+AdmSchedule+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><BeginTime>"+TimeStartTime+"</BeginTime><EndTime>"+TimeEndTime+"</EndTime><BillTypeID>"+PatBillType+"</BillTypeID></Request>"
		}
		
		else if(param2=="UnLockOrder"){
			var TransactionId=$("#Text_TransactionId"+"").val();
			var PatientID="";
			var ScheduleItemCode="";
			var LockQueueNo="";
			if(TransactionId==""){
				$.messager.alert("提示","请填写锁定订单号.","warning");
				return false;	
				var PatientID=$("#Text_PatientID"+"").val();
				if(PatientID==""){
					$.messager.alert("提示","请填写患者登记号,或根据卡号确定登记号.","warning");
					return false;	
				}
				
				var ScheduleItemCode=$('#Text_ScheduleItemCode').val();
				if(ScheduleItemCode==""){
					$.messager.alert("提示","请填写锁定出诊记录.","warning");
					return false;	
				}
				
				var LockQueueNo=$('#Text_LockQueueNo').val();
				if(LockQueueNo==""){
					$.messager.alert("提示","请填写锁定序号.","warning");
					return false;	
				}
			}
			
			request="<Request><TradeCode>10016</TradeCode><TransactionId>"+TransactionId+"</TransactionId><ExtUserID>"+ExtUserID+"</ExtUserID></Request>"
		}else if(param2=="QueryRegStatus"){
			var TransactionId=$("#Text_TransactionId"+"").val();
			var PatientID="";
			var ScheduleItemCode="";
			var LockQueueNo="";
			if(TransactionId==""){
				$.messager.alert("提示","请填写锁定订单号.","warning");
				return false;	
			}
			
			request="<Request><TradeCode>1108</TradeCode><TransactionId>"+TransactionId+"</TransactionId><ExtUserID>"+ExtUserID+"</ExtUserID></Request>"
		}
		else if(param2=="OPRegister"){
			var UserID=tkMakeServerCall("DHCExternalService.RegInterface.GetRelate","GetUser",ExtUserID)
			var GroupID=tkMakeServerCall("DHCExternalService.RegInterface.GetRelate","GetGroup",UserID);
			var NotUseLockRegFlag=tkMakeServerCall("DHCDoc.Interface.Outside.Config","GetConfigNode",GroupID,"NotUseLockReg")
			var TransactionId=$("#Text_TransactionId"+"").val();
			var RegFee=$("#Text_RegFee"+"").val();
			if(RegFee==""){
				$.messager.alert("提示","费用不能为空.","warning");
				return false;
			}
			var PatientID="";
			var PatientID=$("#Text_PatientID"+"").val();
			var ScheduleItemCode=$("#Text_ScheduleItemCode"+"").val();
			var LockQueueNo=$("#Text_LockQueueNo"+"").val();
			if(NotUseLockRegFlag!="1"){
				if(TransactionId==""){
					$.messager.alert("提示","请填写锁定订单号.","warning");
					return false;
				}
				request="<Request><TradeCode>1101</TradeCode><TransactionId>"+TransactionId+"</TransactionId><ExtOrgCode>"+PageLogicObj.ExtOrgCode+"</ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode></ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID>"+PatientID+"</PatientID><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>"+RegFee+"</PayFee><QueueNo></QueueNo><BillTypeID>"+PatBillType+"</BillTypeID></Request>"
			}else{
				if(PatientID==""){
					$.messager.alert("提示","请填写患者登记号,或根据卡号确定登记号.","warning");
					return false;	
				}
				
				if(ScheduleItemCode==""){
					$.messager.alert("提示","请选择出诊记录.","warning");
					return false;	
				}
				request="<Request><TradeCode>1101</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType>02</CardType><PatientID>"+PatientID+"</PatientID><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>"+RegFee+"</PayFee><QueueNo></QueueNo><BillTypeID>"+PatBillType+"</BillTypeID></Request>"

			}
				
		}
		else if(param2=="BookService"){
			var PatientID="";
			var PatientID=$("#Text_PatientID"+"").val();
			var CardNo=$("#Text_CardNo"+"").val();
			var CardTypeCode=$("#List_CardType").combobox('getValue');
			var CardTypeCode=tkMakeServerCall("DHCDoc.Interface.Outside.Test.Service","GetCardTypeCode",CardTypeCode)
			var ScheduleItemCode=$("#Text_ScheduleItemCode"+"").val();
			var LockQueueNo=$("#Text_LockQueueNo"+"").val();
			
			if(CardNo==""){
				//$.messager.alert("提示","请填写患者卡号.","warning");
				//return false;	
			}
			if(ScheduleItemCode==""){
				//$.messager.alert("提示","请选择出诊记录.","warning");
				//return false;	
			}
			request="<Request><TradeCode>1000</TradeCode><ExtOrgCode>"+PageLogicObj.ExtOrgCode+"</ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><TransactionId></TransactionId><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><CardNo>"+CardNo+"</CardNo><CardType>"+CardTypeCode+"</CardType><CredTypeCode></CredTypeCode><IDCardNo></IDCardNo><TelePhoneNo></TelePhoneNo><MobileNo></MobileNo><PatientName></PatientName><PayFlag></PayFlag><PayModeCode></PayModeCode><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayFee></PayFee><PayInsuFee></PayInsuFee><PayInsuFeeStr></PayInsuFeeStr><PayTradeNo></PayTradeNo><LockQueueNo></LockQueueNo><Gender></Gender><Address></Address><HISApptID></HISApptID><SeqCode></SeqCode><AdmitRange></AdmitRange></Request>"
		}else if(param2=="GetInsuRegPara"){
			var PatientID="";
			var PatientID=$("#Text_PatientID"+"").val();
			var CardNo=$("#Text_CardNo"+"").val();
			var CardTypeCode=$("#List_CardType").combobox('getValue');
			var CardTypeCode=tkMakeServerCall("DHCDoc.Interface.Outside.Test.Service","GetCardTypeCode",CardTypeCode)
			var ScheduleItemCode=$("#Text_ScheduleItemCode"+"").val();
			if(ScheduleItemCode==""){
				//$.messager.alert("提示","请选择出诊记录.","warning");
				//return false;	
			}
			request="<Request><ExtUserID>"+ExtUserID+"</ExtUserID><CardNo>"+CardNo+"</CardNo><CardType>"+CardTypeCode+"</CardType><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><PatientID>"+PatientID+"</PatientID><PayModeCode>CASH</PayModeCode></Request>"
		}else{
			request=$("#Text_"+param2+"_Request").val();	
		}
	}else if(TabValue=="Other"){
		if((param2=="OPRegReturn")||(param2=="OPAppArrive")||(param2=="CancelOrder")){
			var ExtUserID=$("#Text_ExtUserID"+"_"+TabValue).val();
			if(ExtUserID==""){
				$.messager.alert("提示","请填写操作员工号.","warning");
				return false;	
			}

			if(param2=="OPRegReturn"){
				var boxvalue=$("#List_"+"QueryAdmOPReg").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("提示","请选择待退的挂号记录.","warning");
					return false;		
				}
				request="<Request><TradeCode>1003</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><AdmNo>"+boxvalue+"</AdmNo><TransactionId></TransactionId><RefundType></RefundType></Request>";
			}else if(param2=="OPAppArrive"){
				var boxvalue=$("#List_"+"QueryOPAppArriveList").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("提示","请选择待操作的预约记录.","warning");
					return false;		
				}
				/*var PatientID=$("#Text_PatientID"+"_"+TabValue).val();
				if(PatientID==""){
					$.messager.alert("提示","请填写患者登记号,或根据卡号确定登记号.","warning");
					return false;	
				}*/
				//request="<Request><TradeCode>2001</TradeCode><HospitalId></HospitalId><TransactionId></TransactionId><PatientID>"+PatientID+"</PatientID><OrderCode>"+boxvalue+"</OrderCode><ExtUserID>"+ExtUserID+"</ExtUserID><PayModeCode>CASH</PayModeCode></Request>";
				//将取号接口合并到挂号接口
				var boxtext=$("#List_"+"QueryOPAppArriveList").combobox('getText');
				var RegFee=boxtext.split("价格:")[1].split("元")[0];
				var PatientID=boxtext.split(" ")[1]
				param2="OPRegister"
				request="<Request><TradeCode>1101</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode>"+""+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID>"+PatientID+"</PatientID><AppOrderCode>"+boxvalue+"</AppOrderCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>"+RegFee+"</PayFee><QueueNo></QueueNo></Request>"
			}else if(param2=="CancelOrder"){
				var boxvalue=$("#List_"+"QueryOPAppArriveList").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("提示","请选择待操作的预约记录.","warning");
					return false;		
				}
				request="<Request><TradeCode>2006</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><TransactionId></TransactionId><OrderCode>"+boxvalue+"</OrderCode></Request>";
			}
		}else{
			request=$("#Text_"+param2+"_Request").val();	
		}
	}else if(TabValue=="OPAlloc"){
		var ExtUserID=$("#Text_ExtUserID"+"_"+TabValue).val();
		if((param2=="OPAllocAutoReport")){			
			if(ExtUserID==""){
				$.messager.alert("提示","请填写操作员工号.","warning");
				return false;	
			}

			if(param2=="OPAllocAutoReport"){
				var PatientID="",CardNo="",CardTypeCode="";
				/*var PatientID=$("#Text_PatientID"+"_"+TabValue).val();
				var CardNo=$("#Text_CardNo"+"_"+TabValue).val();
				var CardTypeCode=$("#List_CardType"+"_"+TabValue).combobox('getValue');
				var CardTypeCode=tkMakeServerCall("DHCDoc.Interface.Outside.Test.Service","GetCardTypeCode",CardTypeCode)*/
			
				var boxvalue=$("#List_"+"GetOPAllocReport").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("提示","请选择需报到的就诊记录.","warning");
					return false;		
				}
				request="<Request><TradeCode>1301</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><AdmQueID>"+boxvalue+"</AdmQueID><TransactionId></TransactionId><PatientCard>"+CardNo+"</PatientCard><CardType>"+CardTypeCode+"</CardType><PatientID>"+PatientID+"</PatientID></Request>";
			}
		}else{
			request=$("#Text_"+param2+"_Request").val();	
		}
	}else{
		request=$("#Text_"+param2+"_Request").val();
	}
	$.cm({
		ClassName:"DHCDoc.Interface.Outside.Test.Service",
		MethodName:	"DoInterfaceMethod",
		'ClassType':TabValue,
		'DoMethodName':param2,
		'RequestStr':request,
		'HospitalId':HospRowId
	},function testget(objScope){
		$("#"+"Text_Reponse"+"").val("");
		if(objScope){
			$("#"+"Text_Reponse"+"").val(objScope.result);
			if(param2=="LockOrder"){
				SetNodeValue(objScope.result,param2,"TransactionId");
				SetNodeValue(objScope.result,param2,"RegFee");
				SetNodeValue(objScope.result,param2,"ScheduleItemCode");
				SetNodeValue(objScope.result,param2,"LockQueueNo");
			}else if((param2=="QueryAdmOPReg")||(param2=="QueryOPAppArriveList")||(param2=="GetOPAllocReport")){
				InitOtherList(param2,request);
			}	
		}
	})
}

function SetNodeValue(xmlresult,param1,param2){
	$.cm({
    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
		MethodName:"GetValueByParseXml",
		'XMLInput':xmlresult,
		'Flag':param1,
		'Node':param2,	
    },function testget(objScope){
	    $("#"+"Text_"+param2+"").val("");
		if(objScope){
			$("#"+"Text_"+param2+"").val(objScope.result);
		}
    })
	/*	    
		$.dhc.util.runServerMethod("DHCDoc.Interface.Outside.Test.Service","GetValueByParseXml","false",function(objScope,value,extraArg){
			$("#"+"Text_"+param2+"").val(objScope.result);
		},"","",xmlresult,param1,param2);
	*/
}

function InitTimeRange(){
	$("#Comb_TimeStartTime").timespinner({    
	    //min: '08:30',    
	    //required: true,    
	    showSeconds: false   
	});  
	$("#Comb_TimeEndTime").timespinner({    
	    //min: '08:30',    
	    //required: true,    
	    showSeconds: false   
	});  	
}

function InitOtherList(paramval,request){
	var HospitalId="";
	$HUI.combobox("#List_"+paramval+"",{ 
    	valueField:'RowId',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName="+paramval+"&RequestStr="+request+"&ResultSetType=array",
    	onLoadSuccess:function(){
	    	$HUI.combobox("#List_"+paramval).setValue('');	
	    },
		onSelect:function(){
			var boxvalue=$("#List_"+paramval).combobox('getValue');
			var boxtext=$("#List_"+paramval).combobox('getText');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				
			}else{
				$.messager.alert("提示","参数获取错误","warning");
				return false;	
			} 
			
		}
	});	
}

function GetTabValue(){
	var SelTab = $("#main_container").tabs('getSelected');    
	var TabIndex = $("#main_container").tabs('getTabIndex',SelTab);
	var TabValue="";
	if(TabIndex==0)TabValue=""
	else if(TabIndex==1)TabValue=""
	else if(TabIndex==2)TabValue="_Other"
	else if(TabIndex==4)TabValue="_OPAlloc"
	return TabValue;
}