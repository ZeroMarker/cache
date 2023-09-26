
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
	  new Array("Btn_QueryOPAppArriveList","QueryOPAppArriveList"),
	  new Array("Btn_OPAppArrive","OPAppArrive"),
	  new Array("Btn_CancelOrder","CancelOrder"),
	  new Array("Btn_QueryPatCard","QueryPatCard")
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
      new Array("List_QueryOPAppArriveList","QueryOPAppArriveList")
)

function Init(){ 
	//$.messager.alert("提示","测试前准备工作:<br>1、在His系统中维护好一个新的安全组，到门诊收费安全组配置配置该安全组具有门诊结算权限，不打发票，其他一概不维护<br>2、在His系统中维护好一个新的工号，权限为建卡挂号收费权限，安全组为新建安全组。自助机工号一般为：'ZZJ001'之类；微信工号一般为：'WX001'之类<br>3、将测试串中'<ExtUserID>457</ExtUserID>'中的457替换成本项目维护好的工号")
	/*for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		InitCardBtn(param1,param2);	    
	}
	
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		InitSelfRegBtn(param1,param2);	    
	}*/
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		InitBtnClick(param1,param2);    
	}
	
	$HUI.combobox("#List_QueryAdmOPReg",{});
	$HUI.combobox("#List_QueryOPAppArriveList",{});
	
	InitDepartmentGroup();
	 
	InitDepartment();
	 
	//InitDoctor();
	 
	InitCombScheduleDate();
	 
	//InitSchedule();
	 
	InitTimeRange();
	InitTransactionId();
	$HUI.tabs("#main_container",{
		onSelect:function(){
			InitPatientID();
			InitCardTypeList();
			InitCardNo();
		}
	})
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
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}
}

function InitTransactionId(){
	$('#Text_TransactionId').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var TransactionId=$("#Text_TransactionId").val();
			if(TransactionId=="") return;
			var QueueNoActive=tkMakeServerCall("web.DHCLockSchedule","CheckQueueNoActive",TransactionId,"","","")
			//alert(QueueNoActive)
			if(QueueNoActive.indexOf("^")>-1){
				var QueueNoActiveFlag=QueueNoActive.split("^")[0];
				var QueueNoActiveStr=QueueNoActive.split("^")[1];
				if(QueueNoActiveFlag=="1"){
					//alert(QueueNoActiveStr)
					var ScheduleItemCode=QueueNoActiveStr.split("!")[0];
					var InsertQueueNo=QueueNoActiveStr.split("!")[1];
					var PatientID=QueueNoActiveStr.split("!")[2];
					$("#Text_ScheduleItemCode").val(ScheduleItemCode);
					$("#Text_LockQueueNo").val(InsertQueueNo);
					$("#Text_PatientID").val(PatientID);
				}else{
					//$.messager.alert("警告",QueueNoActiveFlag);
					if(QueueNoActiveFlag=="Reg"){QueueNoActiveFlag="该号已支付";}
					else if(QueueNoActiveFlag=="NotSamePerson"){QueueNoActiveFlag="该号已被他人锁定";}
					else if(QueueNoActiveFlag=="-100"){QueueNoActiveFlag="订单在系统中不存在";}
					else if(QueueNoActiveFlag=="-101"){QueueNoActiveFlag="锁号错误";}
					else{QueueNoActiveFlag="锁号错误";}
					alert(QueueNoActiveFlag)	
				}
			}else{
				alert("订单信息："+"订单在系统中不存在")
				//$.messager.alert("警告","");		
			}
			var request="<Request><TradeCode>1108</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID></ExtUserID><PatientCard></PatientCard><CardType></CardType><TransactionId>"+TransactionId+"</TransactionId><IDNo></IDNo><PatienName></PatienName></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryRegStatus",
				'RequestStr':request,	
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
	var SelTab = $("#main_container").tabs('getSelected');    
	var TabIndex = $("#main_container").tabs('getTabIndex',SelTab);
	var TabValue="";
	if(TabIndex==0)TabValue=""
	else if(TabIndex==1)TabValue=""
	else if(TabIndex==2)TabValue="_Other"
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

function InitCardTypeList(param1,param2)
{
	var SelTab = $("#main_container").tabs('getSelected');    
	var TabIndex = $("#main_container").tabs('getTabIndex',SelTab);
	var TabValue="";
	if(TabIndex==0)TabValue=""
	else if(TabIndex==1)TabValue=""
	else if(TabIndex==2)TabValue="_Other";
	$HUI.combobox("#List_CardType"+TabValue,{      
    	valueField:'RowId',   
    	textField:'Code',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Config&QueryName=FindList&value=BarCardType&GroupRowId=&ResultSetType=array",  
    	onLoadSuccess:function(){
	    	$HUI.combobox("#List_CardType"+TabValue).clear();	
	    }  	
	});	
}

function InitCardNo(){
	var SelTab = $("#main_container").tabs('getSelected');    
	var TabIndex = $("#main_container").tabs('getTabIndex',SelTab);
	var TabValue="";
	if(TabIndex==0)TabValue=""
	else if(TabIndex==1)TabValue=""
	else if(TabIndex==2)TabValue="_Other"
	
	$('#Text_CardNo'+TabValue).bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var CardTypeCode=$("#List_CardType"+TabValue).combobox('getValue');
			if(CardTypeCode==""){
				$.messager.alert("警告","请选择正确的卡类型");	
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

function InitDepartmentGroup(){	
	var ObjScope=$.cm({
		ClassName:"DHCDoc.Interface.Outside.Test.Service",
		MethodName:"GetJsonStrByService",
		'DoMethodName':"QueryDepartmentGroup",
		'RequestStr':"",
		'HUIFlag':"1",
	},false)
	if(ObjScope=="")return;
	var EditTypeArr=new Array();
	for(var i=0;i<ObjScope.length;i++){
		var value=ObjScope[i].DepartmentCode;
		var desc=ObjScope[i].DepartmentName;
		var onestr = {"value":value, "desc":desc};
		EditTypeArr.push(onestr);	
	}
	$HUI.combobox("#"+"List_QueryDepartmentGroup",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		editable:false,
    	onShowPanel:function(){
	    	$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryDepartmentGroup",
				'RequestStr':""	
		    },function testget(objScope){
			    $("#"+"Text_Reponse"+"").val("");
				if(objScope){
					$("#"+"Text_Reponse"+"").val(objScope.result);
				}
		    })
		},
		onSelect:function(){
			var boxvalue=$('#List_QueryDepartmentGroup').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				InitDepartment(); 
			}else{
				$.messager.alert("警告","参数获取错误");
				return false;	
			} 
			
		}	
	})
}

function InitDepartment(){
	var Groupvalue=$('#List_QueryDepartmentGroup').combobox('getValue');
	var ExtUserID=$("#"+"Text_ExtUserID"+"").val();
	if(ExtUserID==""){
		//$.messager.alert("警告","请填写操作员工号.");
		//return false;
	}
	var HospitalId="";
	var RequestStr="<Request><TradeCode>1012</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentGroupCode>"+Groupvalue+"</DepartmentGroupCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><HospitalId>"+HospitalId+"</HospitalId></Request>"
	
	$HUI.combobox("#"+"List_QueryDepartment"+"",{    
    	valueField:'RowId',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=QueryDepartment&RequestStr="+RequestStr+"&ResultSetType=array",
    	onShowPanel:function(){
	    	var Groupvalue=$('#List_QueryDepartmentGroup').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(ExtUserID==""){
				$.messager.alert("警告","请填写操作员工号.");
				return false;	
			}
	    	var RequestStr="<Request><TradeCode>1012</TradeCode><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentGroupCode>"+Groupvalue+"</DepartmentGroupCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><HospitalId>"+HospitalId+"</HospitalId></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryDepartment",
				'RequestStr':RequestStr	
		    },function testget(objScope){
				if(objScope){
					$("#"+"Text_Reponse"+"").val("");
					InitDepartment();
					$("#"+"Text_Reponse"+"").val(objScope.result);
					//$HUI.combobox('#List_QueryDepartment').clear();
				}
		    })
		},
		onLoadSuccess:function(){
			$HUI.combobox('#List_QueryDepartment').clear();	
			InitDoctor(); 
			InitSchedule();
		},
		onSelect:function(){
			var boxvalue=$('#List_QueryDepartment').combobox('getValue');
			if((boxvalue!="undefined")&&(boxvalue!="")){
				//window.setTimeout("$('#List_QueryDepartment').combobox('setValue',boxvalue)",1000);
				//var DepartmentID = $('#List_QueryDepartment').combobox('getValue');
				InitDoctor(); 
				InitSchedule();
			}else{
				$.messager.alert("警告","参数获取错误");
				return false;	
			} 
			
		}
	});
}

function InitDoctor(){
	var DepartmentVal=$('#List_QueryDepartment').combobox('getValue');
	var ExtUserID=$("#"+"Text_ExtUserID"+"").val();
	if(ExtUserID==""){
		//$.messager.alert("警告","请填写操作员工号.");
		//return false;
	}
	var HospitalId="";
	var RequestStr="<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId>"+HospitalId+"</HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentCode>"+DepartmentVal+"</DepartmentCode></Request>"
	$HUI.combobox("#"+"List_QueryDoctor"+"",{    
    	valueField:'RowId',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=QueryDoctor&RequestStr="+RequestStr+"&ResultSetType=array",
    	onShowPanel:function(){
	    	var DepartmentVal=$('#List_QueryDepartment').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(DepartmentVal==""){
				$.messager.alert("警告","请选择挂号科室.");
				return false;	
			}
	    	var RequestStr="<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId>"+HospitalId+"</HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><DepartmentCode>"+DepartmentVal+"</DepartmentCode></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryDoctor",
				'RequestStr':RequestStr	
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
				//var DepartmentID = $('#List_QueryDepartment').combobox('getValue');
				InitSchedule();
			}else{
				$.messager.alert("警告","参数获取错误");
				return false;	
			} 
			
		}
	});		
}

function InitCombScheduleDate(){
	$("#Comb_ScheduleDate").datebox({
		formatter :function(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+m+'-'+d;
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
	if(ExtUserID==""){
		//$.messager.alert("警告","请填写操作员工号.");
		//return false;
	}
	var HospitalId=session['LOGON.HOSPID'];
	var RequestStr="<Request><TradeCode>1004</TradeCode><ExtOrgCode></ExtOrgCode><ClientType>ATM</ClientType><HospitalId>"+HospitalId+"</HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><StartDate>"+ScheduleDate+"</StartDate><EndDate>"+ScheduleDate+"</EndDate><DepartmentCode>"+DepartmentCode+"</DepartmentCode><ServiceCode></ServiceCode><DoctorCode>"+DoctorCode+"</DoctorCode><RBASSessionCode></RBASSessionCode><PatientID>"+PatientID+"</PatientID></Request>"
	var ObjScope=$.cm({
		ClassName:"DHCDoc.Interface.Outside.Test.Service",
		MethodName:"GetJsonStrByService",
		'DoMethodName':"QueryAdmSchedule",
		'RequestStr':RequestStr,
		'HUIFlag':"1",
	},false)
	//if(ObjScope=="")return;
	var EditTypeArr=new Array();
	for(var i=0;i<ObjScope.length;i++){
		//aRtnObj.ServiceDate_" "_aRtnObj.DepartmentName_" "_aRtnObj.DoctorName_" "_aRtnObj.SessionName
		var value=ObjScope[i].ScheduleItemCode;
		var desc=ObjScope[i].ServiceDate+" "+ObjScope[i].DoctorName+" "+ObjScope[i].SessionName+" 价格:"+ObjScope[i].Fee;
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
			if(DepartmentCode==""){
				$HUI.combobox("#"+"List_QueryAdmSchedule",{data:""})
				$.messager.alert("警告","请选择挂号科室.");
				return false;	
			}
			if(ScheduleDate==""){
				//$.messager.alert("警告","请选择出诊日期.");
				//return false;	
			}
	    	var RequestStr="<Request><TradeCode>1004</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>"+HospitalId+"</HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><StartDate>"+ScheduleDate+"</StartDate><EndDate>"+ScheduleDate+"</EndDate><DepartmentCode>"+DepartmentCode+"</DepartmentCode><ServiceCode></ServiceCode><DoctorCode>"+DoctorCode+"</DoctorCode><RBASSessionCode></RBASSessionCode><PatientID>"+PatientID+"</PatientID></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryAdmSchedule",
				'RequestStr':RequestStr	
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
				var RegFee=parseFloat(RegFee)*100;
				$('#Text_ScheduleItemCode').val(boxvalue);
				$('#Text_RegFee').val(RegFee);
				//var DepartmentID = $('#List_QueryDepartment').combobox('getValue');
			}else{
				$.messager.alert("警告","参数获取错误");
				return false;	
			} 
			
		}
	})
	return
	//神奇的下边两种方式，返回值死活获取不到。
	/*$.cm({
		ClassName:"DHCDoc.Interface.Outside.Test.Service",
		QueryName:"FindList",
		'DoMethodName':"QueryAdmSchedule",
		'RequestStr':RequestStr,
		dataType:"json",
		page:1,  
		rows:999,
	},function(jsonData){
		alert(jsonData["rows"])
		$HUI.combobox("#"+"List_QueryAdmSchedule",{ 
	    	valueField:'RowId',   
	    	textField:'Desc',
	    	data: jsonData["rows"],
	    	onShowPanel:function(){
		    	var DepartmentCode=$('#List_QueryDepartment').combobox('getValue');
				var DoctorCode=$('#List_QueryDoctor').combobox('getValue');
				var ScheduleDate=$('#Comb_ScheduleDate').combobox('getValue');
				var ExtUserID=$("#Text_ExtUserID"+"").val();
				if(DepartmentCode==""){
					$.messager.alert("警告","请选择挂号科室.");
					return false;	
				}
				if(ScheduleDate==""){
					//$.messager.alert("警告","请选择出诊日期.");
					//return false;	
				}
		    	var RequestStr="<Request><TradeCode>1004</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>"+HospitalId+"</HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><StartDate>"+ScheduleDate+"</StartDate><EndDate>"+ScheduleDate+"</EndDate><DepartmentCode>"+DepartmentCode+"</DepartmentCode><ServiceCode></ServiceCode><DoctorCode>"+DoctorCode+"</DoctorCode><RBASSessionCode></RBASSessionCode></Request>"
				$.cm({
			    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
					MethodName:"DoInterfaceMethod",
					'ClassType':"SelfReg",
					'DoMethodName':"QueryAdmSchedule",
					'RequestStr':RequestStr	
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
					var RegFee=parseFloat(RegFee)*100;
					$('#Text_ScheduleItemCode').val(boxvalue);
					$('#Text_RegFee').val(RegFee);
					//var DepartmentID = $('#List_QueryDepartment').combobox('getValue');
				}else{
					$.messager.alert("警告","参数获取错误");
					return false;	
				} 
				
			}
		});		
	})*/
	/*
	$HUI.combobox("#"+"List_QueryAdmSchedule",{ 
    	valueField:'RowId',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.Interface.Outside.Test.Service&QueryName=FindList&DoMethodName=QueryAdmSchedule&RequestStr="+RequestStr+"&ResultSetType=array",
    	onShowPanel:function(){
	    	var DepartmentCode=$('#List_QueryDepartment').combobox('getValue');
			var DoctorCode=$('#List_QueryDoctor').combobox('getValue');
			var ScheduleDate=$('#Comb_ScheduleDate').combobox('getValue');
			var ExtUserID=$("#Text_ExtUserID"+"").val();
			if(DepartmentCode==""){
				$.messager.alert("警告","请选择挂号科室.");
				return false;	
			}
			if(ScheduleDate==""){
				//$.messager.alert("警告","请选择出诊日期.");
				//return false;	
			}
	    	var RequestStr="<Request><TradeCode>1004</TradeCode><ExtOrgCode>H1</ExtOrgCode><ClientType>ATM</ClientType><HospitalId>"+HospitalId+"</HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><StartDate>"+ScheduleDate+"</StartDate><EndDate>"+ScheduleDate+"</EndDate><DepartmentCode>"+DepartmentCode+"</DepartmentCode><ServiceCode></ServiceCode><DoctorCode>"+DoctorCode+"</DoctorCode><RBASSessionCode></RBASSessionCode></Request>"
			$.cm({
		    	ClassName:"DHCDoc.Interface.Outside.Test.Service",
				MethodName:"DoInterfaceMethod",
				'ClassType':"SelfReg",
				'DoMethodName':"QueryAdmSchedule",
				'RequestStr':RequestStr	
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
				var RegFee=parseFloat(RegFee)*100;
				$('#Text_ScheduleItemCode').val(boxvalue);
				$('#Text_RegFee').val(RegFee);
				//var DepartmentID = $('#List_QueryDepartment').combobox('getValue');
			}else{
				$.messager.alert("警告","参数获取错误");
				return false;	
			} 
			
		}
	});
	*/	
}
function ButtonClickBak(param){
	var request=$("#Text_"+param+"_Request").val();
	$.dhc.util.runServerMethod("DHCDoc.Interface.Outside.Test.Service","DoInterfaceMethodBak","false",function(objScope,value,extraArg){
		$("#"+"Text_Reponse"+"").val(objScope.result);
	},"","",param,request);
	
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
	var request="";
	var SelTab = $("#main_container").tabs('getSelected');    
	var TabIndex = $("#main_container").tabs('getTabIndex',SelTab);
	var TabValue="";
	if(TabIndex==0)TabValue="CardManager"
	else if(TabIndex==1)TabValue="SelfReg"
	else if(TabIndex==2)TabValue="Other"
	if(TabValue=="SelfReg"){
		var ExtUserID=$("#Text_ExtUserID"+"").val();
		if(ExtUserID==""){
			$.messager.alert("警告","请填写操作员工号.");
			return false;	
		}
		if(param2=="LockOrder"){
			var PatientID=$("#Text_PatientID"+"").val();
			if(PatientID==""){
				$.messager.alert("警告","请填写患者登记号,或根据卡号确定登记号.");
				return false;	
			}
			
			var AdmSchedule=$('#List_QueryAdmSchedule').combobox('getValue');
			if(AdmSchedule==""){
				$.messager.alert("警告","请选择出诊记录.");
				return false;	
			}
			var TimeStartTime=$("#Comb_TimeStartTime").val()  
			var TimeEndTime=$("#Comb_TimeEndTime").val() 
			//request="<Request><TradeCode>10015</TradeCode><CardNo></CardNo><CardTypeCode></CardTypeCode><PatientID>"+PatientID+"</PatientID><ScheduleItemCode>"+AdmSchedule+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><BeginTime></BeginTime><EndTime></EndTime></Request>"
			request="<Request><TradeCode>10015</TradeCode><CardNo></CardNo><CardTypeCode></CardTypeCode><PatientID>"+PatientID+"</PatientID><ScheduleItemCode>"+AdmSchedule+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><BeginTime>"+TimeStartTime+"</BeginTime><EndTime>"+TimeEndTime+"</EndTime></Request>"
		}
		
		else if(param2=="UnLockOrder"){
			var TransactionId=$("#Text_TransactionId"+"").val();
			var PatientID="";
			var ScheduleItemCode="";
			var LockQueueNo="";
			if(TransactionId==""){
				$.messager.alert("警告","请填写锁定订单号.");
				return false;	
				var PatientID=$("#Text_PatientID"+"").val();
				if(PatientID==""){
					$.messager.alert("警告","请填写患者登记号,或根据卡号确定登记号.");
					return false;	
				}
				
				var ScheduleItemCode=$('#Text_ScheduleItemCode').val();
				if(ScheduleItemCode==""){
					$.messager.alert("警告","请填写锁定出诊记录.");
					return false;	
				}
				
				var LockQueueNo=$('#Text_LockQueueNo').val();
				if(LockQueueNo==""){
					$.messager.alert("警告","请填写锁定序号.");
					return false;	
				}
			}
			
			request="<Request><TradeCode>10016</TradeCode><TransactionId>"+TransactionId+"</TransactionId><ExtUserID>"+ExtUserID+"</ExtUserID></Request>"
		}
		else if(param2=="OPRegister"){
			var UserID=tkMakeServerCall("DHCExternalService.RegInterface.GetRelate","GetUser",ExtUserID)
			var GroupID=tkMakeServerCall("DHCExternalService.RegInterface.GetRelate","GetGroup",UserID);
			var NotUseLockRegFlag=tkMakeServerCall("DHCDoc.Interface.Outside.Config","GetConfigNode",GroupID,"NotUseLockReg")
			var TransactionId=$("#Text_TransactionId"+"").val();
			var RegFee=$("#Text_RegFee"+"").val();
			if(RegFee==""){
				$.messager.alert("警告","费用不能为空.");
				return false;
			}
			var PatientID="";
			var PatientID=$("#Text_PatientID"+"").val();
			var ScheduleItemCode=$("#Text_ScheduleItemCode"+"").val();
			var LockQueueNo=$("#Text_LockQueueNo"+"").val();
			if(NotUseLockRegFlag!="1"){
				if(TransactionId==""){
					$.messager.alert("警告","请填写锁定订单号.");
					return false;
				}
				request="<Request><TradeCode>1101</TradeCode><TransactionId>"+TransactionId+"</TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode></ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID>"+PatientID+"</PatientID><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>"+RegFee+"</PayFee><QueueNo></QueueNo></Request>"
			}else{
				if(PatientID==""){
					$.messager.alert("警告","请填写患者登记号,或根据卡号确定登记号.");
					return false;	
				}
				
				if(ScheduleItemCode==""){
					$.messager.alert("警告","请选择出诊记录.");
					return false;	
				}
				request="<Request><TradeCode>1101</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType>02</CardType><PatientID>"+PatientID+"</PatientID><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>"+RegFee+"</PayFee><QueueNo></QueueNo></Request>"

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
				$.messager.alert("警告","请填写患者卡号.");
				return false;	
			}
			//var CardNo=tkMakeServerCall("DHCDoc.Util.Base","GetCardNoByPAPER","ALL",PatientID)
			//alert(CardNo)
			//return false
			if(ScheduleItemCode==""){
				$.messager.alert("警告","请选择出诊记录.");
				return false;	
			}
			request="<Request><TradeCode>1000</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><TransactionId></TransactionId><ScheduleItemCode>"+ScheduleItemCode+"</ScheduleItemCode><CardNo>"+CardNo+"</CardNo><CardType>"+CardTypeCode+"</CardType><CredTypeCode></CredTypeCode><IDCardNo></IDCardNo><TelePhoneNo></TelePhoneNo><MobileNo></MobileNo><PatientName></PatientName><PayFlag></PayFlag><PayModeCode></PayModeCode><PayBankCode></PayBankCode><PayCardNo></PayCardNo><PayFee></PayFee><PayInsuFee></PayInsuFee><PayInsuFeeStr></PayInsuFeeStr><PayTradeNo></PayTradeNo><LockQueueNo></LockQueueNo><Gender></Gender><Address></Address><HISApptID></HISApptID><SeqCode></SeqCode><AdmitRange></AdmitRange></Request>"
				
		}else{
			request=$("#Text_"+param2+"_Request").val();	
		}
	}else if(TabValue=="Other"){
		if((param2=="OPRegReturn")||(param2=="OPAppArrive")||(param2=="CancelOrder")){
			var ExtUserID=$("#Text_ExtUserID"+"_"+TabValue).val();
			if(ExtUserID==""){
				$.messager.alert("警告","请填写操作员工号.");
				return false;	
			}

			if(param2=="OPRegReturn"){
				var boxvalue=$("#List_"+"QueryAdmOPReg").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("警告","请选择待退的挂号记录.");
					return false;		
				}
				request="<Request><TradeCode>1003</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><AdmNo>"+boxvalue+"</AdmNo><TransactionId></TransactionId><RefundType></RefundType></Request>";
			}else if(param2=="OPAppArrive"){
				var boxvalue=$("#List_"+"QueryOPAppArriveList").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("警告","请选择待操作的预约记录.");
					return false;		
				}
				var PatientID=$("#Text_PatientID"+"_"+TabValue).val();
				if(PatientID==""){
					$.messager.alert("警告","请填写患者登记号,或根据卡号确定登记号.");
					return false;	
				}
				//request="<Request><TradeCode>2001</TradeCode><HospitalId></HospitalId><TransactionId></TransactionId><PatientID>"+PatientID+"</PatientID><OrderCode>"+boxvalue+"</OrderCode><ExtUserID>"+ExtUserID+"</ExtUserID><PayModeCode>CASH</PayModeCode></Request>";
				//将取号接口合并到挂号接口
				var boxtext=$("#List_"+"QueryOPAppArriveList").combobox('getText');
				var RegFee=boxtext.split("价格:")[1].split("元")[0];
				param2="OPRegister"
				request="<Request><TradeCode>1101</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><TerminalID></TerminalID><ScheduleItemCode>"+""+"</ScheduleItemCode><ExtUserID>"+ExtUserID+"</ExtUserID><PatientCard></PatientCard><CardType>02</CardType><PatientID>"+PatientID+"</PatientID><AppOrderCode>"+boxvalue+"</AppOrderCode><PayCardNo></PayCardNo><PayModeCode>CASH</PayModeCode><PayFee>"+RegFee+"</PayFee><QueueNo></QueueNo></Request>"
			}else if(param2=="CancelOrder"){
				var boxvalue=$("#List_"+"QueryOPAppArriveList").combobox('getValue');
				if(boxvalue==""){
					$.messager.alert("警告","请选择待操作的预约记录.");
					return false;		
				}
				request="<Request><TradeCode>2006</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>"+ExtUserID+"</ExtUserID><TransactionId></TransactionId><OrderCode>"+boxvalue+"</OrderCode></Request>";
			
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
		'RequestStr':request
	},function testget(objScope){
		$("#"+"Text_Reponse"+"").val("");
		if(objScope){
			$("#"+"Text_Reponse"+"").val(objScope.result);
			if(param2=="LockOrder"){
				SetNodeValue(objScope.result,param2,"TransactionId");
				SetNodeValue(objScope.result,param2,"RegFee");
				SetNodeValue(objScope.result,param2,"ScheduleItemCode");
				SetNodeValue(objScope.result,param2,"LockQueueNo");
			}else if((param2=="QueryAdmOPReg")||(param2=="QueryOPAppArriveList")){
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
				$.messager.alert("警告","参数获取错误");
				return false;	
			} 
			
		}
	});	
}