var PageLogicObj={
	m_CardTypeRowID:"",
	m_CCMRowID:"",
	m_SetFocusElement:"",
	m_CardNoLength:"",
	m_SetRCardFocusElement:"",		//"Name";
	m_SetCardRefFocusElement:"",
	m_OverWriteFlag:"",
	m_SetCardReferFlag:"",
	m_CardINVPrtXMLName:"",
	m_SupportFillFlag:"",
	m_PatPageXMLName:"",
	m_PatCardStChangeValidate:"",
	m_IDCredTypePlate:"01",
	m_SupportLossFlag:"",
	m_CardRefFlag:"",
	m_CardSecrityNo:"",
	m_RLCredTypeID:"", //挂失人证件类型代码
	m_CredNo:"", //挂失人证件号码
	m_Computername:GetComputerName()
}
$(function(){
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$("#RLName").focus();
})
function InitEvent(){
	//挂失
	$("#ReportTheLoss").click(ReportTheLossClickHandle);
	//启用
	$("#CancelTheLoss").click(CancelTheLossClickHandle);
	//补卡
	$("#ExchCard").click(ExchangeOnClickHandle);
	$("#ExchangeCardNo").keydown(ExchangeCardNokeydown);
	document.onkeydown = DocumentOnKeyDown;
}
function PageHandle(){
	LoadRLCredTypeList();
	LoadPayMode();
	LoadCardTypeDefine();
	if (ServerObj.CardID!=""){
		SetPatInfoByCardID();
		SetCardTypeInfoByCardID();
	}
	InitPatRegConfig();
}
function LoadRLCredTypeList(){
	var Data=$.cm({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCredTypeExp",
		dataType:"text",
		JSFunName:"GetCredTypeToHUIJson",
		ListName:""
	},false);
	var cbox = $HUI.combobox("#RLCredTypeList", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: JSON.parse(Data),
			onSelect:function(rec){
				//CardTypeKeydownHandler();
			}
	 });
	 //CardTypeKeydownHandler();
}
function LoadPayMode(){
	var Data=$.cm({
		ClassName:"web.UDHCOPOtherLB", 
		MethodName:"ReadPayMode",
		dataType:"text",
		JSFunName:"GetPayModeToHUIJson",
		ListName:"",
		gGroupID:session['LOGON.GROUPID']
	},false);
	var cbox = $HUI.combobox("#PayMode", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: JSON.parse(Data),
			onSelect:function(rec){
				//CardTypeKeydownHandler();
			}
	 });
	 //CardTypeKeydownHandler();
}
function LoadCardTypeDefine(){
	var Data=$.cm({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCardTypeDefineListBroker",
		dataType:"text",
		JSFunName:"GetCardTypeToHUIJson",
		ListName:"",
		SessionStr:""
	},false);
	var cbox = $HUI.combobox("#CardTypeDefine", {
			valueField: 'id',
			textField: 'text', 
			disabled:true,
			data: JSON.parse(Data),
			onSelect:function(rec){
				//CardTypeKeydownHandler();
			}
	 });
	 //CardTypeKeydownHandler();
}
function SetPatInfoByCardID(){
	$.cm({
		ClassName:"web.DHCBL.CARD.CardManager", 
		MethodName:"getpatinfo",
		dataType:"text",
		itmjs:"", itmjsex:"",CardID:ServerObj.CardID
	},function(value){
		var val=value.split("^");
		if (val[4]!=""){
			$("#RegNo").val(val[0]);
			$("#PatientID").val(val[1]);
			$("#PatName,#RLName").val(val[2]);
			$("#IDCardNo").val(val[3])
			$("#RLCredNo").val(val[12]);
			$("#CardNo").val(val[4]);
			var Data=$("#RLCredTypeList").combobox("getData");
			for (var i=0;i<Data.length;i++){
				var id=Data[i]["id"];
				if (id.split("^")[0]==val[14]){
					$("#RLCredTypeList").combobox("select",id);
					break;
				}
			}
			//$("#RLCredTypeList").combobox("select",val[14])
			$("#RLAddress").val(val[15]);
			$("#RLPhoneNo").val(val[16]);
			$("#Flag").val(val[10]);
			$("#ActiveFlag").val(val[6]);
			PageLogicObj.m_RLCredTypeID=val[14]; //挂失人证件类型代码
			PageLogicObj.m_CredNo=val[12]; //挂失人证件号码
 			var Data=$("#CardTypeDefine").combobox("getData");
			for (var i=0;i<Data.length;i++){
				var text=Data[i]["text"];
				if (text==val[21]){
					$("#CardTypeDefine").combobox("select",Data[i]["id"]);
					break;
				}
			}
		}
	});
}
function SetCardTypeInfoByCardID(){
	$.cm({
		ClassName:"web.DHCBL.CARD.CardManager", 
		MethodName:"getcardtypeinfo",
		dataType:"text",
		CardID:ServerObj.CardID
	},function(myoptval){
		if (myoptval!=""){
			var myary=myoptval.split("^");
			var myCardTypeDR=myary[0];
			PageLogicObj.m_CardTypeRowID = myCardTypeDR;
			if (myCardTypeDR=="")	{
				return false;
			}
			if (myary[3]=="C"){
				$("#CardFareCost").val(myary[6]);
				GetReceiptNo();
			}
			if (myary[16]=="Handle"){
				$("#ExchangeCardNo").attr("readonly",false);
				$("#BReadCard").unbind("click"); 
				$HUI.linkbutton("#BReadCard").disable();
				$("#ExchangeCardNo").focus();
			}else{
				$("#ExchangeCardNo").attr("readonly",true);
				$("#BReadCard").unbind("click"); 
				$HUI.linkbutton("#BReadCard").enable();
				$("#BReadCard").click(ReadCardClickHandler); 
				$("#BReadCard").focus();
			}
			PageLogicObj.m_CCMRowID=myary[14];
			PageLogicObj.m_SetFocusElement = myary[13];
			PageLogicObj.m_CardNoLength=myary[17];
			PageLogicObj.m_SetRCardFocusElement=myary[20]		//"Name";
			PageLogicObj.m_SetCardRefFocusElement=myary[22];
			PageLogicObj.m_OverWriteFlag=myary[23];
			PageLogicObj.m_SetCardReferFlag=myary[21];
			PageLogicObj.m_CardINVPrtXMLName=myary[25];
			PageLogicObj.m_PatPageXMLName=myary[26];
			PageLogicObj.m_PatCardStChangeValidate=myary[27];
			PageLogicObj.m_SupportLossFlag=myary[31];
			PageLogicObj.m_SupportFillFlag=myary[33];
		}
	});
}
function ReportTheLossClickHandle(){
	if (!CheckRptLoss()) return false;
	if (!CheckStChangeValidate()) return false;
	var ParseInfo=["PatientID="+$("#PatientID").val(),
					"CardID="+ServerObj.CardID,
					"RegNo="+$("#RegNo").val(),
					"IDCardNo="+$("#IDCardNo").val(),
					"CardNo="+$("#CardNo").val(),
					"CardTypeDefine="+$("#CardTypeDefine").combobox("getValue").split("^")[0],
					"ActiveFlag="+$("#ActiveFlag").val(),
					"Flag="+$("#Flag").val(),
					"RLName="+$("#RLName").val(),
					"RLCredNo="+$("#RLCredNo").val(),
					"RLCredTypeID="+$("#RLCredTypeList").combobox("getValue").split("^")[0],
					"RLAddress="+$("#RLAddress").val(),
					"RLPhoneNo="+$("#RLPhoneNo").val(),
					"RLRemark="+$("#RLRemark").val(),
					"UserDR="+session['LOGON.USERID'],
					"ComputerIP="+PageLogicObj.m_Computername,
					"LogonHospDR="+session['LOGON.HOSPID']
				];
								
	var myCardInfo=Card_GetEntityClassInfoToXML(ParseInfo,"DHCCardStatusChange");
	$.cm({
		ClassName:"web.DHCBL.CARD.UCardStatusChangeBuilder", 
		MethodName:"CardReportOrCancelLoss",
		dataType:"text",
		CardStatusChangeInfo:myCardInfo,
		oldstatus:"N"
	},function(myrtn){
		if(myrtn=='-355'){
			$.messager.alert("提示","非正常卡不能挂失!");
		}else if(myrtn==0){
			$.messager.alert("提示","卡挂失成功!");
			window.parent.RegReturnListTabDataGridLoad();
			window.parent.destroyDialog("CardManager");
		}else{
			$.messager.alert("提示","卡挂失失败!");
		}
	})
}
function CheckRptLoss(){
	if (ServerObj.CardID==""){
		$.messager.alert("提示","请选择要挂失的卡!");		 
		return false;
	}
	if ($("#ActiveFlag").val()!="N"){
		$.messager.alert("提示","非正常卡不能挂失!");
		return false;
	}
	if(PageLogicObj.m_SupportLossFlag!="Y"){
		$.messager.alert("提示","该卡类型不支持挂失!");	
		return false;
	}
	return true;
}
function CheckStChangeValidate(){
	if(PageLogicObj.m_PatCardStChangeValidate=='Y'){
		var mytmparray=$("#RLCredTypeList").combobox("getValue").split("^"); 
		var CredTypeID=PageLogicObj.m_RLCredTypeID;
		if ((PageLogicObj.m_CredNo!=$("#RLCredNo").val())||(CredTypeID!=mytmparray[0])){
			$.messager.alert("提示","申请人证件信息与挂失卡对应证件信息不一致(证件类型或者号码错误)","info",function(){
				$('#RLCredNo').focus();;
			});	
			return false;
		}	
	}
	return true;
}
function CancelTheLossClickHandle(){
	if (!CheckCancelLoss()) return false;
	var ParseInfo=["PatientID="+$("#PatientID").val(),
					"CardID="+ServerObj.CardID,
					"RegNo="+$("#RegNo").val(),
					"IDCardNo="+$("#IDCardNo").val(),
					"CredType="+$("#CardTypeDefine").combobox("getValue").split("^")[0],
					"CardNo="+$("#CardNo").val(),
					"CardTypeDefine="+$("#CardTypeDefine").combobox("getValue").split("^")[0],
					"ActiveFlag="+$("#ActiveFlag").val(),
					"Flag="+$("#Flag").val(),
					"ExchangeCardNo="+"",
					"DateFrom="+"",
					"DateTo="+"",
					"RLName="+$("#RLName").val(),
					"RLCredNo="+$("#RLCredNo").val(),
					"RLCredType="+$("#RLCredTypeList").combobox("getValue").split("^")[0],
					"RLCredTypeID="+$("#RLCredTypeList").combobox("getValue").split("^")[0],
					"RLAddress="+$("#RLAddress").val(),
					"RLPhoneNo="+$("#RLPhoneNo").val(),
					"RLProof="+$("#RLProof").val(),
					"RLRemark="+$("#RLRemark").val(),
					"UserDR="+session['LOGON.USERID'],
					"ComputerIP="+PageLogicObj.m_Computername,
					"LogonHospDR="+session['LOGON.HOSPID']
				];
	
	var myCardInfo=Card_GetEntityClassInfoToXML(ParseInfo,"DHCCardStatusChange");
	$.cm({
		ClassName:"web.DHCBL.CARD.UCardStatusChangeBuilder", 
		MethodName:"CardReportOrCancelLoss",
		dataType:"text",
		CardStatusChangeInfo:myCardInfo,
		oldstatus:"S"
	},function(myrtn){
		if(myrtn=='-356'){
			$.messager.alert("提示","非挂失状态不允许启用!");
		}else if(myrtn==0){
			$.messager.alert("提示","启用成功","info",function(){
				window.parent.RegReturnListTabDataGridLoad();
				window.parent.destroyDialog("CardManager");
			});
		}else if(myrtn=="-364"){
			$.messager.alert("提示","该患者已经存在此卡类型下的有效卡,不允许启用.");
		}else{
			$.messager.alert("提示","取消挂失失败");
		}
	})
}
function CheckCancelLoss(){
	if ((ServerObj.CardID=="")||($("#ActiveFlag").val()!="S")){
		$.messager.alert("提示","请选择挂失状态的卡!");
		return false;
	}
	return true;
}
function ExchangeOnClickHandle(){
   SetExchangeCardNOLength();	
   if (!CheckExChange()) return false;
   var ActiveFlag=$("#ActiveFlag").val();
   var myRLInfo="";		
   if (ActiveFlag=="N"){
   		if (bcheckcred!="OK" && bcheckcred!="F"){
	   		$.messager.alert("提示","身份验证失败(证件类型或者号码错误)");
	   		return false;
	   	}
   }
	var mySecrityNo=""
	//根据卡类型决定是否写卡
	if (PageLogicObj.m_CardRefFlag=="Y"){
		if (PageLogicObj.m_OverWriteFlag=="Y"){
			var myrtn=WrtCard();
			var myary=myrtn.split("^");
			if (myary[0]!="0"){
				$.messager.alert("提示","写卡失败!");
				return false;
			}else{
				mySecrityNo=myary[1];
			}
		}
	}
	ExchCardVerify="";
	var ParseInfo=["PatientID="+$("#PatientID").val(),
					"CardID="+ServerObj.CardID,
					"RegNo="+$("#RegNo").val(),
					"IDCardNo="+$("#IDCardNo").val(),
					"CardNo="+$("#CardNo").val(),
					"CardTypeDefine="+$("#CardTypeDefine").combobox("getValue").split("^")[0],
					"ActiveFlag="+$("#ActiveFlag").val(),
					"Flag="+$("#Flag").val(),
					"ExchangeCardNo="+$("#ExchangeCardNo").val(),
					"DateFrom="+"",
					"DateTo="+"",
					"RLName="+$("#RLName").val(),
					"RLCredNo="+$("#RLCredNo").val(),
					"RLCredType="+$("#RLCredTypeList").combobox("getValue").split("^")[0],
					"RLCredTypeID="+$("#RLCredTypeList").combobox("getValue").split("^")[0],
					"RLAddress="+$("#RLAddress").val(),
					"RLPhoneNo="+$("#RLPhoneNo").val(),
					"RLProof="+$("#RLProof").val(),
					"RLRemark="+$("#RLRemark").val(),
					"SecrityNo="+mySecrityNo,
					"UserDR="+session['LOGON.USERID'],
					"ComputerIP="+PageLogicObj.m_Computername,
					"LogonHospDR="+session['LOGON.HOSPID']
			];
	var myCardInfo=Card_GetEntityClassInfoToXML(ParseInfo,"DHCCardStatusChange");
	var CardFareCost=$("#CardFareCost").val();
	var CardInvprt=["CardFareCost="+$("#CardFareCost").val(),
					"PayMode="+$("#PayMode").combobox("getValue").split("^")[0],
					"ReceiptNO="+$("#ReceiptNO").val()
				   ];
	var CardInvprtInfo=Card_GetEntityClassInfoToXML(CardInvprt,"CardINVPRT");
	$.cm({
		ClassName:"web.DHCBL.CARD.UCardStatusChangeBuilder", 
		MethodName:"CardReissue",
		dataType:"text", 
		CardStatusChangeInfo:myCardInfo, CardINVInfo:CardInvprtInfo
	},function(myren){
		var ren=myren.split("^");
		if(ren[0]=='0'){
			$.messager.alert("提示","补卡成功!","info",function(){
				//打印发票
				if (ren[1]!=""){
					//原挂失界面缺少元素,是否一直不用?
					//PatRegPatInfoPrint(ren[1],PageLogicObj.m_CardINVPrtXMLName,"ReadCardINVEncrypt");
				}
				window.parent.RegReturnListTabDataGridLoad();
				window.parent.destroyDialog("CardManager");
			});
		}else if(ren[0]=='-361'){
			alert(t[2088]); //todo 2088 2089不知道什么意思
		}else if(ren[0]=='-362'){
			alert(t[2089]);
			$.messager.alert("提示","补卡成功!");
		}else if(ren[0]=='-363'){
			$.messager.alert("提示","没有有效账户,不能进行预交金管理!");
		}else if(ren[0]=='-110'){
			$.messager.alert("提示","发送更新医技科室病人信息失败!","info",function(){
				if (ren[1]!=""){
					//原挂失界面缺少元素,是否一直不用?
					//PatRegPatInfoPrint(ren[1],PageLogicObj.m_CardINVPrtXMLName,"ReadCardINVEncrypt");
				}
				$.messager.alert("提示","写卡成功!","info",function(){
					window.parent.RegReturnListTabDataGridLoad();
					window.parent.destroyDialog("CardManager");
				});	
			});	
		}else{
			$.messager.alert("提示","保存数据失败!错误号："+ren[0]);
		}
	});
}
function SetExchangeCardNOLength(){
	var ExchangeCardNo=$("#ExchangeCardNo").val();
	if (ExchangeCardNo!=""){
		if ((ExchangeCardNo.length<PageLogicObj.m_CardNoLength)&&(PageLogicObj.m_CardNoLength!=0)){
			for (var i=(PageLogicObj.m_CardNoLength-ExchangeCardNo.length-1); i>=0; i--) {
				ExchangeCardNo="0"+ExchangeCardNo;
			}
		}
		if ((ExchangeCardNo.length>PageLogicObj.m_CardNoLength)&&(PageLogicObj.m_CardNoLength!=0)){
			PageLogicObj.m_CardSecrityNo=ExchangeCardNo.substring(PageLogicObj.m_CardNoLength, ExchangeCardNo.length);
			ExchangeCardNo=ExchangeCardNo.substring(0,PageLogicObj.m_CardNoLength);
		}
		$("#ExchangeCardNo").val(ExchangeCardNo);
	}
}
function CheckExChange(){
	var rtn=$.cm({
		ClassName:"web.DHCBL.CARD.UCardStatusChangeBuilder", 
		MethodName:"CheckCardNoByType",
		dataType:"text",
		CardID:ServerObj.CardID,
		CardTypeId:$("#CardTypeDefine").combobox("getValue").split("^")[0]
	},false)
	if (rtn!=0){
		$.messager.alert("提示","此卡类型下的该患者已存在有效卡记录,不能补卡!");
		return false;
	}
	if (ServerObj.CardID==""){
		$.messager.alert("提示","证件号不能为空!");
		return false;
	}
	if ($("#PayMode").combobox("getValue").split("^")[0]==""){
		$.messager.alert("提示","支付方式不能为空!");
		return false;
	}
	var ExchangeCardNo=$("#ExchangeCardNo").val();
	if (ExchangeCardNo==""){
		$.messager.alert("提示","新卡卡号不能为空!","info",function(){
			$("#ExchangeCardNo").focus();
		});
		return false;
	}
	if (!IsValidExchangeNo()){
		return false;
	}
    if(PageLogicObj.m_SupportFillFlag!="Y"){
	    $.messager.alert("提示","该卡类型不支持补卡!");
	    return false;
	}
	var RLName=$("#RLName").val();
	if (RLName==""){
		$.messager.alert("提示","挂失人人姓名不能为空!","info",function(){
			$("#RLName").focus();
		});
		return false;
	}
	var RLCredType=$("#RLCredTypeList").combobox("getValue");
	if (RLCredType==""){
		$.messager.alert("提示","证件类型不能为空!");
		return false;
	}
	var RLCredNo=$("#RLCredNo").val();
	if (RLCredNo==""){
		var myval=$("#RLCredTypeList").combobox("getValue");
		var myCredTypeDR = myval.split("^")[0];
		var CredNoRequired=$.cm({
			ClassName:"web.DHCBL.CARD.UCardRefInfo",
			MethodName:"CheckCardNoRequired",
			dataType:"text",
			CredTypeDr:myCredTypeDR
		},false)
		var AgeAllow=$.cm({
			ClassName:"web.DHCDocConfig", 
			MethodName:"GetDHCDocCardConfig",
			dataType:"text",
			Node:"AllowAgeNoCreadCard"
		},false);
		var Age=$.cm({
			ClassName:"web.DHCBillInterface", 
			MethodName:"GetPapmiAge",
			dataType:"text",
			Papmi:$("#PatientID").val(),
			Adm:"",
			ParamAdmDate:"",ParamAdmTime:""
		},false);
		if (CredNoRequired=="Y"){
			if ((AgeAllow!="")&&(parseFloat(Age)<=parseFloat(AgeAllow))){}
			else{
				$.messager.alert("提示","挂失人证件号码不能为空!","info",function(){
					$("#RLCredNo").focus();
				});
				return false;
			}
		}
	};
	var RLAddress=$("#RLAddress").val();
	if (RLAddress==""){
		$.messager.alert("提示","挂失人地址不能为空!","info",function(){
			$("#RLAddress").focus();
		});
		return false;
	}
	var RLAddress=$("#RLPhoneNo").val();
	if (RLAddress==""){
		$.messager.alert("提示","挂失人联系电话不能为空!","info",function(){
			$("#RLPhoneNo").focus();
		});
		return false;
	}
	var myIDNo=$("#RLCredNo").val();
	if(myIDNo!=""){
		var myIDrtn=IsCredTypeID();
		if (myIDrtn){
			var myIsID=DHCWeb_IsIdCardNo(myIDNo);
			if (!myIsID){
				//$.messager.alert("提示","身份证号码错误!","info",function(){
					$("#RLCredNo").focus();
				//});
				return false;
			}
		}
	}
	return true;	
}
function IsValidExchangeNo() {
	var ExchangeCardNo=$("#ExchangeCardNo").val();
	if (ExchangeCardNo!="")	{
		/*var ren=$.cm({
			ClassName:"web.DHCBL.CARD.CardManager", 
			MethodName:"getcardtypeinfoByCardNoNew",
			dataType:"text",
			CardNo:ExchangeCardNo,
			CardTypeRowId:$("#CardTypeDefine").combobox("getValue").split("^")[0]
		},false)
		var myary=ren.split("^");
		if(myary[0]!="-2")	{
			$.messager.alert("提示","新卡正在使用,不能补卡!","info",function(){
				$("#ExchangeCardNo").addClass("newclsInvalid"); 
				$("#ExchangeCardNo").focus();
			});
			return false;
		}else{
			$("#ExchangeCardNo").removeClass("newclsInvalid"); 
		}*/
		var rtn=$.cm({
			ClassName:"web.DHCBL.CARDIF.ICardRefInfo",
			MethodName:"ReadPatValidateInfoByCardNo",
			dataType:"text",
			CardNO:ExchangeCardNo,
			SecurityNo:"",CardTypeDR:$("#CardTypeDefine").combobox("getValue").split("^")[0],
			ExpStr:""
		},false);
		rtn=rtn.split("^")[0];
		if ((rtn=="-341")||(rtn=="-350")){
			$.messager.alert("提示","此卡正在使用,不能补卡!","info",function(){
				$("#ExchangeCardNo").addClass("newclsInvalid"); 
				$("#ExchangeCardNo").focus();
			});
			return false;
		}else if(rtn=="-351"){
			var CancelInfo=$.cm({
				ClassName:"web.UDHCAccManageCLS7",
				MethodName:"GetCancenlInfo",
				dataType:"text",
				cardno:ExchangeCardNo,
				CardTypeDR:$("#CardTypeDefine").combobox("getValue").split("^")[0]
			},false);
			$.messager.alert('提示',"此卡已经被挂失,不能使用,挂失人:"+CancelInfo.split("^")[0]+",挂失原因:"+CancelInfo.split("^")[1],"info",function(){
				$("#ExchangeCardNo").addClass("newclsInvalid"); 
				$("#ExchangeCardNo").focus();
			});
			return false;
		}else if(rtn=="-352"){
			$.messager.alert('提示',"此卡已经被作废,不能使用!","info",function(){
				$("#ExchangeCardNo").addClass("newclsInvalid"); 
				$("#ExchangeCardNo").focus();
			});
			return false;
		}
	}else{
		return true;
	}
	return true;
}
function IsCredTypeID()
{
	var myval=$("#RLCredTypeList").combobox("getValue");
	var myary = myval.split("^");
	if (myary[1]==PageLogicObj.m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
}
function WrtCard(){
	var mySecrityNo=$.cm({
		ClassName:"web.UDHCAccCardManage", 
		MethodName:"GetCardCheckNo",
		dataType:"text",
		PAPMINo:""
	},false)
	if (mySecrityNo!=""){
		PageLogicObj.m_CardSecrityNo=mySecrityNo;
		var myCardNo=$("#ExchangeCardNo").val();
		var rtn=DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, PageLogicObj.m_CCMRowID);
		if (rtn!="0"){
			return "-1^"
		}
	}else{
		return "-1^";
	}
	return "0^"+mySecrityNo
}
function InitPatRegConfig()
{
	var myvalue=$.cm({
		ClassName:"web.DHCBL.CARD.UCardPATRegConfig", 
		MethodName:"GetCardPatRegConfig",
		dataType:"text",
		SessionStr:""
	},false)
	if (myvalue==""){
		return false;
	}
	var myRtnAry=myvalue.split(String.fromCharCode(2))
	var myary=myRtnAry[0].split("^");
	PageLogicObj.m_CardRefFlag=myary[4];
	var mySetFocusElement=myary[2];
	if (mySetFocusElement!=""){
		$("#"+mySetFocusElement).focus();
	}
}
function GetReceiptNo(){
	var Guser=session['LOGON.USERID'];
	var ExpStr=session['LOGON.USERID'] +"^"+"Y"
	if (cspRunServerMethod(ServerObj.GetreceipNO,"SetReceipNO","", Guser, PageLogicObj.m_CardTypeRowID, ExpStr)) {
	}
	/*var myvalue=$.cm({
		ClassName:"web.DHCBL.CARDIF.ICardINVPRTInfo", 
		MethodName:"ReadReceiptNOForCard", 
		dataType:"text",
		itmjs:"GetReceiptNOHUIToJson", itmjsex:"", UserDR:session['LOGON.USERID'], 
		CardTypeDR:PageLogicObj.m_CardTypeRowID,
		ExpStr:session['LOGON.USERID'] +"^"+"Y"
	},function(value){
		var myary=value.split("^");
		var ls_ReceipNo=myary[0];
		$("#ReceiptNO").val(ls_ReceipNo);
		if (myary[1]!="0"){
			$("#ReceiptNO").addClass("newclsInvalid"); 
		}
	})*/
}
function SetReceipNO(value){
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	$("#ReceiptNO").val(ls_ReceipNo);
	if (myary[1]!="0"){
		$("#ReceiptNO").addClass("newclsInvalid"); 
	}
}
function ReadCardClickHandler(){
	if (ServerObj.DHCVersion=="12"){
		M1Card_InitPassWord();
   }
	var rtn=DHCACC_ReadMagCard(PageLogicObj.m_CCMRowID, "R", "23");
	var myary=rtn.split("^");
	if (myary[0]=='0'){
		$("#ExchangeCardNo").val(myary[1]);
		IsValidExchangeNo();
	}
}
function M1Card_InitPassWord(){
  try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
  }catch(e){
  }
}
function ExchangeCardNokeydown(e){
	var key=websys_getKey(e);
	if (key==13) {
		SetExchangeCardNOLength();
		IsValidExchangeNo();
		return true;
	}
	
}
function DocumentOnKeyDown(e){
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
	if(keyCode==120){ 
		if ($("#ReportTheLoss").length>0){
			ReportTheLossClickHandle();
			return false;
		}else if($("#CancelTheLoss").length>0){
			CancelTheLossClickHandle();
			return false;
		}else{
			ExchangeOnClickHandle();
			return false;
		}
	}else if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("ExchangeCardNo")>=0){
			return false;
		}
		return true;
	}
}
function GetComputerName(){
	var CilentInfo=tkMakeServerCall("User.DHCClientLogin","GetInfo");
	if (CilentInfo!="") {
		var ComputerName=CilentInfo.split("^")[3];
	}else{
		//记录操作电脑的名字
	    var WshNetwork = new ActiveXObject("WScript.NetWork");
		var ComputerName=WshNetwork.ComputerName;
	}
	return ComputerName;
}