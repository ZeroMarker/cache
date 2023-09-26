//
//名称	DHCPESendAudit.hisui.js
//功能  粘贴
//创建	2018.09.20
//创建人  xy

$(function(){
	 
	InitCombobox();
	
	InitSendAuditDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏 
    $("#Bclear").click(function() {	
		 Bclear_click();		
        }); 
      
      
    /*  	
	$("#DoRegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        }); 
        */
        

     $("#AutoSend").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#NoSend").checkbox('setValue',false);}
	       	 		        
        	}
        });
		
    $("#NoSend").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#AutoSend").checkbox('setValue',false);}
	       	 		        
        	}
        }); 
 
	
})

	
function InitCombobox()
{
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	//性别
		var SexObj = $HUI.combobox("#Sex_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
	//团体
	var PGADM_DR_NameObj = $HUI.combogrid("#PGADM_DR_Name",{
		panelWidth:490,
		url:$URL+"?ClassName=web.DHCPE.PreGADM&QueryName=SearchPreGADMShort",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Name',
		onBeforeLoad:function(param){
			param.Code = param.q;
		},
		
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Name',title:'团体名称',width:140},
			{field:'Code',title:'编码',width:100},
			{field:'Begin',title:'开始日期',width:100},
			{field:'End',title:'截止日期',width:100},
			{field:'DelayDate',title:'状态',width:50}
			
			
		]]
		})
		
}



function InitSendAuditDataGrid(){
	
	
	$HUI.datagrid("#SendAuditQueryTab",{
		url: $URL,
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列  
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchSendAudit", 
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			DoRegNo:$("#DoRegNo").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GID:$("#PGADM_DR_Name").combobox('getValue'),
			Sex:$("#Sex_DR_Name").combobox('getValue'),
			AutoSend:$HUI.checkbox('#AutoSend').getValue() ? "on" : "",
			NoSend:$HUI.checkbox('#NoSend').getValue() ? "on" : ""
		},
		frozenColumns:[[
		{field:'TPAADM',hidden:true,title:'就诊id'},
			{field:'str',title:'粘贴操作',width:'80',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TPAADM!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_order.png"  title="取消粘贴" border="0" onclick="CacleSendAudit('+rowData.TPAADM+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/check_reg.png" title="粘贴"  border="0" onclick="SendAudit('+rowData.TPAADM+')"></a>';
			
				}
				}},
			{field:'TResult',title:'体检结果',width:'120',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TPAADM!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png" title="查看结果" border="0" onclick="ResultView('+rowData.TPAADM+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" title="报告预览" border="0" onclick="ReportView('+rowData.TPAADM+')"></a>\
					<a><img style="padding:0 0px 0px 10px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/lt_rt_55.png" title="结果对比" border="0" onclick="openContrastWin('+rowData.TPAADM+')"></a>';
			
				}
				}},
					
		]],
		columns:[[
			
			{field:'TRegNo',width:'100',title:'登记号'},
			{field:'TName',width:'100',title:'姓名'},
			{field:'TSex',width:'60',title:'性别'},
			{field:'TBirth',width:'100',title:'出生日期'},
			{field:'TVIPLevel',width:'60',title:'VIP等级'},
			{field:'TGDesc',width:'100',title:'团体名称'},
			{field:'TSendUser',width:'100',title:'操作人'},
			{field:'TSendDate',width:'100',title:'操作日期'},
			{field:'TSendTime',width:'100',title:'操作时间'},
			{field:'TAppDate',width:'100',title:'收表日期'},
			{field:'TReportDate',width:'100',title:'报告约期'},
			{field:'TNoResultItem',width:'200',title:'不能送检原因'},
			{field:'THadRec',width:40,title:'收表',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			
			{field:'TSendAudit',width:40,title:'粘贴',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportAudit',width:40,title:'初审',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TMainAudit',width:40,title:'复审',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportPrint',width:70,title:'报告打印',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value!="") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:20px' disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TFetchReport',width:40,title:'已取',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},

			/*
			{field:'TReportStatus',width:'270',title:'报告状态',
			formatter:function(value,rowData,rowIndex){
				if ( "" != value ) {
					//alert(value)
					rvalue="";
					var val = value.split("^");
					var valLen = val.length;
					for(var i=0;i<valLen;i++){
						str=val[i];
						strone=str.split("&");
						if (strone[0]=="1") {checked="checked=checked"}
						else{checked=""}
					
							rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"+strone[1]
						
					}
					//alert(rvalue)
					return rvalue;
				}
				
				}}
				*/
			
			
			
			
		]]
		
		
	
	})

	
}


//取消黏贴
function CacleSendAudit(PAADM)
{
	$.messager.confirm("确认", "您即将取消粘贴,是否继续？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"CacleSendAudit",vPAADM:PAADM},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","取消失败","error");  
				}else{
					$.messager.popover({msg: '取消成功！',type:'success',timeout: 1000});
					BFind_click();
		           return false;

     
				}
			});	
		}
	});
	
}
//黏贴
function SendAudit(PAADM)
{
	var UserID=session['LOGON.USERID'];
	var PAADM=PAADM;
	
	var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"IsSendAudit",
			"RegNo":"",
			"UserID":UserID,
            "CheckFlag":"0",
            "vPAADM":PAADM
		}, false);

	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		$.messager.alert("提示",Arr[1],"info"); 
		return false;
	}
	if (Arr[0]=="-2")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="此人已经收表"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+Arr[1]+EnterKey+"是否继续操作";
		}else{
			AlertInfo=AlertInfo+"是否继续操作";
		}
		
		$.messager.confirm("确认", AlertInfo, function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("提示",ReturnValue[1],"error");  
				}else{
					$.messager.alert("提示","粘贴成功","success"); 
					BFind_click(); 
					}
			});	
		}
	});
		
	}
	if (Arr[0]=="-3")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo=Arr[1]+EnterKey+"是否继续操作";
		$.messager.confirm("确认", AlertInfo, function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("提示",ReturnValue[1],"error");  
				}else{
					$.messager.alert("提示","粘贴成功","success"); 
					BFind_click(); 
					}
			});	
		}
	});
		
	}else if (Arr[0]=="0"){

	
	var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"SendAuditNew",
			"UserID":"",
            "CheckFlag":1,
            "vPAADM":PAADM
		}, false);
		
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("提示",Arr[1],"info"); 
		return false;
	}
	BFind_click();
	}
}

/*
//黏贴
function SendAudit(PAADM)
{
	var UserID=session['LOGON.USERID']
	var PAADM=PAADM
	var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"SendAudit",
			"RegNo":"",
			"UserID":UserID,
            "CheckFlag":"0",
            "vPAADM":PAADM
		}, false);

	
	var Arr=ret.split("^");
	if (Arr[0]=="0"){
		BFind_click();
		return false;
	}
	if (Arr[0]=="-1"){
		$.messager.alert("提示",Arr[1],"info"); 
		//alert(Arr[1])
		return false;
	}
	if (Arr[0]=="-2")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="此人已经收表"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+"未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
		}else{
			AlertInfo=AlertInfo+"是否继续操作";
		}
		if (!confirm(AlertInfo)) return false;
	}
	if (Arr[0]=="-3")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
		if (!confirm(AlertInfo)) return false;
	}
	var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"SendAudit",
			"RegNo":"",
			"UserID":"",
            "CheckFlag":1,
            "vPAADM":PAADM
		}, false);
		
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("提示",Arr[1],"info"); 
		return false;
	}
	BFind_click();
}
*/
//报告预览 
function ReportView(PAADM)
{
	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	
	if(NewVerReportFlag=="Lodop"){
		if (PAADM==""){
			$.messager.alert("提示","就诊ID为空","info");
		    return false;
		}else{
	
			PEPrintReport("V",PAADM,""); //lodop+csp预览体检报告
		} 
		return false;
	}else if(NewVerReportFlag=="Word"){	
		if (PAADM==""){
			$.messager.alert("提示","就诊ID为空","info");
		    return false;
		}else{
			calPEReportProtocol("BPrintView",PAADM);
			
		} 
		return false;	
	 
	}else{
	
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	
	var repUrl="dhcpeireport.normal.csp?PatientID="+PAADM+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(repUrl,"_blank",nwin)
	}
}

//结果预览 
function ResultView(PAADM)
{
		var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var url="dhcpenewdiagnosis.diagnosis.hisui.csp?EpisodeID="+PAADM+"&MainDoctor="+""+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(url,"_blank",nwin)
}

//结果对比
var openContrastWin = function(PAADM){
	
	$HUI.window("#ContrastWin",{
		title:"结果对比",
		minimizable:false,
		collapsible:false,
		modal:true,
		width:970,
		height:400
	});
	
	var QryLisObj = $HUI.datagrid("#QryContrastWin",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.ResultContrast",
			QueryName:"ContrastWithLast",
			PAADM:PAADM
			

		},
		columns:[[
			{field:'TARCIMItem',width:'220',title:'项目名称'},
			{field:'TLastTime',width:'240',title:'上次'},
			{field:'TCurrentTime',width:'240',title:'本次'},
			{field:'TLastTime2',width:'240',title:'上上次'},
		]],
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		})
	
	
};

/*
//结果对比
function ContrastWithLast(PAADM)
{
	
		var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast&PAADM="+PAADM;
		//window.open(str,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=100,left=100,width=1200,height=600");
	   websys_lu(str,false,'width=800,height=500,hisui=true,title=结果对比')
	
}
*/


// 查询
function BFind_click(){

	$("#SendAuditQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchSendAudit",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			DoRegNo:$("#DoRegNo").val(),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GID:$("#PGADM_DR_Name").combobox('getValue'),
			Sex:$("#Sex_DR_Name").combobox('getValue'),
			AutoSend:$HUI.checkbox('#AutoSend').getValue() ? "on" : "",
			NoSend:$HUI.checkbox('#NoSend').getValue() ? "on" : ""
			})
}

//清屏
function Bclear_click()
{
	$("#DoRegNo").val("");
	$(".hisui-combobox").combobox('select','');
	$("#NoSend").checkbox('setValue',false);
	$("#AutoSend").checkbox('setValue',true);
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");


}
$("#DoRegNo").keydown(function(e) {
			
  if(e.keyCode==13){

	var RegNo=$("#DoRegNo").val();	
 	if(RegNo!="") {
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#DoRegNo").val(RegNo)
		}

	if (RegNo=="") 
	   {
		   $.messager.alert("提示","请输入登记号","info");
		   return false;
	   }

		
	var AutoSend=$("#AutoSend").checkbox('getValue');
	if(AutoSend){
		
	var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"IsSendAudit",
			"RegNo":RegNo,
			"UserID":"",
            "CheckFlag":"0",
            "vPAADM":""
		}, false);

	var Arr=ret.split("^");


	if (Arr[0]=="-1"){
		$.messager.alert("提示",Arr[1],"info"); 
		return false;
	}else if (Arr[0]=="-2")
	{
		
		var PAADM=Arr[2];
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="此人已经收表"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+Arr[1]+EnterKey+"是否继续操作";
		}else{
			AlertInfo=AlertInfo+"是否继续操作";
		}
		
		$.messager.confirm("确认", AlertInfo, function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("提示",ReturnValue[1],"error");  
				}else{
					$.messager.alert("提示","粘贴成功","success"); 
					BFind_click(); 
					}
			});	
		}
			else{
						return false;
					}
	});
		
	}else if (Arr[0]=="-3"){
		var PAADM=Arr[2];
		var EnterKey=String.fromCharCode(13);
		var AlertInfo=Arr[1]+EnterKey+"是否继续操作";
		$.messager.confirm("确认", AlertInfo, function(r){
		if (r){	
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("提示",ReturnValue[1],"error");  
				}else{
					$.messager.alert("提示","粘贴成功","success"); 
					BFind_click(); 
					}
			
			});	
			
		}
			else{
						return false;
					}
	});
		
	}else if (Arr[0]=="0"){
	var PAADM=Arr[1];
	var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"SendAuditNew",
			"UserID":"",
            "CheckFlag":1,
            "vPAADM":PAADM
		}, false);
		
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("提示",Arr[1],"info"); 
		return false;
	}
	BFind_click();
	}

		
	}
				
		
		
	
		}
			
        }); 
/*
function RegNoOnChange()
{
	
	var RegNo=$("#DoRegNo").val();	
 	if(RegNo!="") {
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#DoRegNo").val(RegNo)
		}

	if (RegNo=="") 
	   {
		 $.messager.popover({msg: "请输入登记号", type: "info"});
		   return false;
	   }

		
	var AutoSend=$("#AutoSend").checkbox('getValue');
	if(AutoSend){
		var ret=$.m({
			"ClassName":"web.DHCPE.FetchReport",
			"MethodName":"SendAudit",
			"RegNo":RegNo,
			"UserID":"",
            "CheckFlag":"0",
            "vPAADM":""
		}, false);

	
		var Arr=ret.split("^");
		if (Arr[0]=="0"){
			BFind_click();
			return false;
		}
		if (Arr[0]=="-1"){
			//alert(Arr[1])
			 $.messager.popover({msg: Arr[1], type: "info"});
			return false;
		}
		if (Arr[0]=="-2")
		{
			var EnterKey=String.fromCharCode(13);
			var AlertInfo="此人已经收表"+EnterKey;
			if (Arr[1]!=""){
				AlertInfo=AlertInfo+"未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
			}else{
				AlertInfo=AlertInfo+"是否继续操作";
			}
			if (!confirm(AlertInfo)) return false;
		}
		if (Arr[0]=="-3")
		{
			var EnterKey=String.fromCharCode(13);
			var AlertInfo="未完成项目:"+Arr[1]+EnterKey+"是否继续操作";
			if (!confirm(AlertInfo)) return false;
		}
		var ret=$.m({
				"ClassName":"web.DHCPE.FetchReport",
				"MethodName":"SendAudit",
				"RegNo":RegNo,
				"UserID":"",
            	"CheckFlag":1,
            	"vPAADM":""
			}, false);
		
		var Arr=ret.split("^");
		if (Arr[0]!="0"){
			 $.messager.popover({msg: Arr[1], type: "info"});
			return false;
		}
		BFind_click();
	
	}
				
		
		
	}
	*/
	


