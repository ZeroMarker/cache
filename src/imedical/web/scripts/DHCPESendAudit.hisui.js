//
//����	DHCPESendAudit.hisui.js
//����  ճ��
//����	2018.09.20
//������  xy

$(function(){
	 
	InitCombobox();
	
	InitSendAuditDataGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //���� 
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
	// VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	//�Ա�
		var SexObj = $HUI.combobox("#Sex_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
	//����
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
			{field:'Name',title:'��������',width:140},
			{field:'Code',title:'����',width:100},
			{field:'Begin',title:'��ʼ����',width:100},
			{field:'End',title:'��ֹ����',width:100},
			{field:'DelayDate',title:'״̬',width:50}
			
			
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
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���  
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
		{field:'TPAADM',hidden:true,title:'����id'},
			{field:'str',title:'ճ������',width:'80',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TPAADM!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_order.png"  title="ȡ��ճ��" border="0" onclick="CacleSendAudit('+rowData.TPAADM+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/check_reg.png" title="ճ��"  border="0" onclick="SendAudit('+rowData.TPAADM+')"></a>';
			
				}
				}},
			{field:'TResult',title:'�����',width:'120',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TPAADM!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png" title="�鿴���" border="0" onclick="ResultView('+rowData.TPAADM+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" title="����Ԥ��" border="0" onclick="ReportView('+rowData.TPAADM+')"></a>\
					<a><img style="padding:0 0px 0px 10px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/lt_rt_55.png" title="����Ա�" border="0" onclick="openContrastWin('+rowData.TPAADM+')"></a>';
			
				}
				}},
					
		]],
		columns:[[
			
			{field:'TRegNo',width:'100',title:'�ǼǺ�'},
			{field:'TName',width:'100',title:'����'},
			{field:'TSex',width:'60',title:'�Ա�'},
			{field:'TBirth',width:'100',title:'��������'},
			{field:'TVIPLevel',width:'60',title:'VIP�ȼ�'},
			{field:'TGDesc',width:'100',title:'��������'},
			{field:'TSendUser',width:'100',title:'������'},
			{field:'TSendDate',width:'100',title:'��������'},
			{field:'TSendTime',width:'100',title:'����ʱ��'},
			{field:'TAppDate',width:'100',title:'�ձ�����'},
			{field:'TReportDate',width:'100',title:'����Լ��'},
			{field:'TNoResultItem',width:'200',title:'�����ͼ�ԭ��'},
			{field:'THadRec',width:40,title:'�ձ�',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			
			{field:'TSendAudit',width:40,title:'ճ��',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportAudit',width:40,title:'����',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TMainAudit',width:40,title:'����',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportPrint',width:70,title:'�����ӡ',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value!="") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:20px' disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TFetchReport',width:40,title:'��ȡ',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox' style='margin-left:5px' disabled='true' "+checked+">"	
					return rvalue;
				
				}},

			/*
			{field:'TReportStatus',width:'270',title:'����״̬',
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


//ȡ�����
function CacleSendAudit(PAADM)
{
	$.messager.confirm("ȷ��", "������ȡ��ճ��,�Ƿ������", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"CacleSendAudit",vPAADM:PAADM},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ȡ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ȡ���ɹ���',type:'success',timeout: 1000});
					BFind_click();
		           return false;

     
				}
			});	
		}
	});
	
}
//���
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
		$.messager.alert("��ʾ",Arr[1],"info"); 
		return false;
	}
	if (Arr[0]=="-2")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="�����Ѿ��ձ�"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+Arr[1]+EnterKey+"�Ƿ��������";
		}else{
			AlertInfo=AlertInfo+"�Ƿ��������";
		}
		
		$.messager.confirm("ȷ��", AlertInfo, function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("��ʾ",ReturnValue[1],"error");  
				}else{
					$.messager.alert("��ʾ","ճ���ɹ�","success"); 
					BFind_click(); 
					}
			});	
		}
	});
		
	}
	if (Arr[0]=="-3")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo=Arr[1]+EnterKey+"�Ƿ��������";
		$.messager.confirm("ȷ��", AlertInfo, function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("��ʾ",ReturnValue[1],"error");  
				}else{
					$.messager.alert("��ʾ","ճ���ɹ�","success"); 
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
		$.messager.alert("��ʾ",Arr[1],"info"); 
		return false;
	}
	BFind_click();
	}
}

/*
//���
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
		$.messager.alert("��ʾ",Arr[1],"info"); 
		//alert(Arr[1])
		return false;
	}
	if (Arr[0]=="-2")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="�����Ѿ��ձ�"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+"δ�����Ŀ:"+Arr[1]+EnterKey+"�Ƿ��������";
		}else{
			AlertInfo=AlertInfo+"�Ƿ��������";
		}
		if (!confirm(AlertInfo)) return false;
	}
	if (Arr[0]=="-3")
	{
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="δ�����Ŀ:"+Arr[1]+EnterKey+"�Ƿ��������";
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
		$.messager.alert("��ʾ",Arr[1],"info"); 
		return false;
	}
	BFind_click();
}
*/
//����Ԥ�� 
function ReportView(PAADM)
{
	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	
	if(NewVerReportFlag=="Lodop"){
		if (PAADM==""){
			$.messager.alert("��ʾ","����IDΪ��","info");
		    return false;
		}else{
	
			PEPrintReport("V",PAADM,""); //lodop+cspԤ����챨��
		} 
		return false;
	}else if(NewVerReportFlag=="Word"){	
		if (PAADM==""){
			$.messager.alert("��ʾ","����IDΪ��","info");
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

//���Ԥ�� 
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

//����Ա�
var openContrastWin = function(PAADM){
	
	$HUI.window("#ContrastWin",{
		title:"����Ա�",
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
			{field:'TARCIMItem',width:'220',title:'��Ŀ����'},
			{field:'TLastTime',width:'240',title:'�ϴ�'},
			{field:'TCurrentTime',width:'240',title:'����'},
			{field:'TLastTime2',width:'240',title:'���ϴ�'},
		]],
		pagination:true,
		displayMsg:"",
		pageSize:20,
		fit:true
	
		})
	
	
};

/*
//����Ա�
function ContrastWithLast(PAADM)
{
	
		var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast&PAADM="+PAADM;
		//window.open(str,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=100,left=100,width=1200,height=600");
	   websys_lu(str,false,'width=800,height=500,hisui=true,title=����Ա�')
	
}
*/


// ��ѯ
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

//����
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
		   $.messager.alert("��ʾ","������ǼǺ�","info");
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
		$.messager.alert("��ʾ",Arr[1],"info"); 
		return false;
	}else if (Arr[0]=="-2")
	{
		
		var PAADM=Arr[2];
		var EnterKey=String.fromCharCode(13);
		var AlertInfo="�����Ѿ��ձ�"+EnterKey;
		if (Arr[1]!=""){
			AlertInfo=AlertInfo+Arr[1]+EnterKey+"�Ƿ��������";
		}else{
			AlertInfo=AlertInfo+"�Ƿ��������";
		}
		
		$.messager.confirm("ȷ��", AlertInfo, function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("��ʾ",ReturnValue[1],"error");  
				}else{
					$.messager.alert("��ʾ","ճ���ɹ�","success"); 
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
		var AlertInfo=Arr[1]+EnterKey+"�Ƿ��������";
		$.messager.confirm("ȷ��", AlertInfo, function(r){
		if (r){	
			$.m({ ClassName:"web.DHCPE.FetchReport", MethodName:"SendAuditNew","UserID":"","CheckFlag":1,"vPAADM":PAADM},function(ReturnValue){
				var ReturnValue=ReturnValue.split("^");
				if (ReturnValue[0]!='0') {
					$.messager.alert("��ʾ",ReturnValue[1],"error");  
				}else{
					$.messager.alert("��ʾ","ճ���ɹ�","success"); 
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
		$.messager.alert("��ʾ",Arr[1],"info"); 
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
		 $.messager.popover({msg: "������ǼǺ�", type: "info"});
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
			var AlertInfo="�����Ѿ��ձ�"+EnterKey;
			if (Arr[1]!=""){
				AlertInfo=AlertInfo+"δ�����Ŀ:"+Arr[1]+EnterKey+"�Ƿ��������";
			}else{
				AlertInfo=AlertInfo+"�Ƿ��������";
			}
			if (!confirm(AlertInfo)) return false;
		}
		if (Arr[0]=="-3")
		{
			var EnterKey=String.fromCharCode(13);
			var AlertInfo="δ�����Ŀ:"+Arr[1]+EnterKey+"�Ƿ��������";
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
	


