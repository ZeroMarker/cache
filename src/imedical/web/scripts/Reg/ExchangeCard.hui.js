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
	m_CardTypePrefixNo:"",
	m_SupportLossFlag:"",
	m_SupportExChangeFlag:"N",
	m_CardRefFlag:"",
	m_CardSecrityNo:"",
	m_RLCredTypeID:"", //挂失人证件类型代码
	m_CredNo:"", //挂失人证件号码
	m_Computername:ClientIPAddress //GetComputerName()
}
$(function(){
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$("#RLName").focus();
})
function InitEvent(){
	$("#ExchangeCardNo").keydown(ExchangeNOKeyDownHandler);
	$("#ExchCard").click(ExchangeOnClickHandle);
	$("#ReadRegInfo").click(ReadRegInfoOnClick);
	document.onkeydown = DocumentOnKeyDown;
}
function PageHandle(){
	LoadRLCredTypeList();
	LoadCardTypeDefine();
	if (ServerObj.CardID!=""){
		SetPatInfoByCardID();
		SetCardTypeInfoByCardID();
	}
	InitPatRegConfig();
	//设备类型
	LoadIEType();
}
function LoadIEType(){
	$.cm({
		ClassName:"web.UDHCCardCommLinkRegister",
		QueryName:"ReadHardComList",
		HardGroupType:"IE", 
		ExpStr:""
	},function(GridData){
		var cbox = $HUI.combobox("#IEType", {
				valueField: 'HGRowID',
				textField: 'HGDesc', 
				editable:false,
				blurValidValue:true,
				data: GridData["rows"],
				onLoadSuccess:function(){
					var Data=$(this).combobox("getData");
					if (Data.length>0){
						$(this).combobox("select",Data[0]["HGRowID"]);
					}
				}
				
		 });
	});
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
            ModifyCredData(val[23]);
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
			PageLogicObj.m_CardTypePrefixNo=myary[29];
		}
	});
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
	var myEquipDR=$("#CardTypeDefine").combobox("getValue");
    var CardInform=DHCACC_ReadMagCard(PageLogicObj.m_CCMRowID, "R", "23"); 
    var CardSubInform=CardInform.split("^");
    if (CardSubInform[0]=='0'){
	    $("#ExchangeCardNo").val(CardSubInform[1]);
	    IsValidExchangeNo();
	}
}
function IsValidExchangeNo(){
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
			$.messager.alert("提示","此卡正在使用,不能换卡!","info",function(){
				$("#ExchangeCardNo").addClass("newclsInvalid"); 
				$("#ExchangeCardNo").focus();
			});
			return false;
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
			$.messager.alert("提示","此卡正在使用,不能换卡!","info",function(){
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
function ExchangeNOKeyDownHandler(e){
	var eSrc=window.event.srcElement;	
	var key=websys_getKey(e);
	if (key==13) {
		SetExchangeCardNOLength();
		$('#RLName').focus();
	}
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
		ExchangeOnClickHandle();
	}else if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("ExchangeCardNo")>=0){
			return false;
		}
		return true;
	}
}
function ExchangeOnClickHandle(){
    if (!CheckExChange()) return false;
	var mySecrityNo="";			////Relation Constant
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
	$.cm({
		ClassName:"web.DHCBL.CARD.UCardStatusChangeBuilder", 
		MethodName:"CardExechange",
		dataType:"text", 
		CardStatusChangeInfo:myCardInfo
	},function(myren){
		var ren=myren.split("^")
		if(ren[0]=='0'){
			$.messager.alert("提示","换卡成功!","info",function(){
				window.parent.RegReturnListTabDataGridLoad();
				window.parent.destroyDialog("CardManager");
			});
		}else if(ren[0]=='-359'){
			$.messager.alert("提示","作废的卡不能再进行换卡!");
		}else if(ren[0]=='-360'){
			$.messager.alert("提示","挂失状态的卡不能进行换卡!");
		}else if(ren[0]=='-110'){
			$.messager.alert("提示","发送更新医技科室病人信息失败!");
		}else{
			$.messager.alert("提示","保存数据失败");
		}
	})
}
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function CheckExChange(){
	var CardStatus=$("#Flag").val();
    if (CardStatus!="正常"){
	    $.messager.alert("提示","只有正常状态的卡才能进行换卡操作!");
		return false;
    }
	SetExchangeCardNOLength();
	if (ServerObj.CardID==""){
		$.messager.alert("提示","原卡卡号不能为空");
		return false;
	}
	var ExchangeCardNo=$("#ExchangeCardNo").val();
	if (ExchangeCardNo==""){
		$.messager.alert("提示","换卡卡号不能为空!","info",function(){
			$("#ExchangeCardNo").focus();
		});
		return false;
	}else{
		if (!IsValidExchangeNo()){
			return false;
		}
	}
	if (PageLogicObj.m_CardRefFlag=="Y")
	{
		if (ExchangeCardNo==""){
			$.messager.alert("提示","卡号不能为空,请读卡!","info",function(){
				$("#ExchangeCardNo").focus();
			});
			return false;
		}
		////Card NO Length ?= Card Type Define Length
		var myCTDefLength=0;
		if (isNaN(PageLogicObj.m_CardNoLength)){
			myCTDefLength=0;
		}else{
			myCTDefLength = PageLogicObj.m_CardNoLength;
		}
		if ((myCTDefLength!=0)&&(ExchangeCardNo.length!=myCTDefLength)){
			$.messager.alert("提示","卡号长度错误!","info",function(){
				$("#ExchangeCardNo").focus();
			});
			return false;
		}
	}
	////Card No Pre ?= Card Type Define Pre
	if (PageLogicObj.m_CardTypePrefixNo!=""){
		var myPreNoLength=PageLogicObj.m_CardTypePrefixNo.length;
		var myPreNo=ExchangeCardNo.substring(0,myPreNoLength);
		if(myPreNo!=PageLogicObj.m_CardTypePrefixNo){
			$.messager.alert("提示","卡号码前缀错误!","info",function(){
				$("#ExchangeCardNo").focus();
			});
			return false;
		}
	}
	var myval=$("#CardTypeDefine").combobox("getValue");
	PageLogicObj.m_SupportExChangeFlag=myval.split("^")[32];
	if(PageLogicObj.m_SupportExChangeFlag!="Y"){
		var CardTypeDesc=myval.split("^")[2];
		$.messager.alert("提示",CardTypeDesc+" 不支持换卡!");
		return false;
	}	
	var RLName=$("#RLName").val();
	if (RLName==""){
		$.messager.alert("提示","换卡人姓名不能为空!","info",function(){
			$("#RLName").focus();
		});
		return false;
	}
	var CredType=$("#RLCredTypeList").combobox("getValue");
	if (CredType==""){
		$.messager.alert("提示","换卡人证件类型不能为空!");
		return false;
	}
	var RLAddress=$("#RLAddress").val();
	if (RLAddress==""){
		$.messager.alert("提示","换卡人地址不能为空!","info",function(){
			$("#RLAddress").focus();
		});
		return false;
	}
	var RLAddress=$("#RLPhoneNo").val();
	if (RLAddress==""){
		$.messager.alert("提示","换卡人联系电话不能为空!","info",function(){
			$("#RLPhoneNo").focus();
		});
		return false;
	}
	if (!CheckTelOrMobile(RLAddress,"RLPhoneNo","换卡人联系电话")) return false;
	var myIDNo=$("#RLCredNo").val();
	if(myIDNo!=""){
		var myIDrtn=IsCredTypeID();
		if (myIDrtn){
			var myIsID=DHCWeb_IsIdCardNo(myIDNo);
			if (!myIsID){
				$.messager.alert("提示","换卡人身份证号码错误!","info",function(){
					$("#RLCredNo").focus();
				});
				return false;
			}
		}
	}else{
		/*$.messager.alert("提示","换卡人证件号码不能为空!","info",function(){
			$("#RLCredNo").focus();
		});
		return false;*/
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
			if ((AgeAllow!="")&(parseFloat(Age)<=parseFloat(AgeAllow))){}
			else{
				$.messager.alert("提示","换卡人证件号码不能为空!","info",function(){
					$('#RLCredNo').focus();
				});
				return false;
			}
		}
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

function ReadRegInfoOnClick(){
	var myHCTypeDR=$("#IEType").combobox("getValue");
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		var XMLStr=myary[1]
		XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
		var xmlDoc = DHCDOM_CreateXMLDOM();
		xmlDoc.async = false;
		xmlDoc.loadXML(XMLStr);
		if (xmlDoc.parseError.errorCode != 0) {
			alert(xmlDoc.parseError.reason);
			return;
		}
		var nodes = xmlDoc.documentElement.childNodes;
		if (nodes.length<=0){return;}
		for (var i = 0; i < nodes.length; i++) {
			var myItemName = nodes(i).nodeName;
			var myItemValue = nodes(i).text;
			if(myItemName=="CredNo") {
				$("#RLCredNo").val(myItemValue)
			}
			if(myItemName=="Address") {
				$("#RLAddress").val(myItemValue)
			}
		}
		delete(xmlDoc);
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

function ModifyCredData(CardTypeID){
    var CardTypeID=CardTypeID||"";
    var CardCreadType=$.cm({
        ClassName:"web.UDHCOPOtherLB",
        MethodName:"ReadCredTypeExp",
        JSFunName:"GetCredTypeToHUIJson",
        ListName:"",
        HospId:session["LOGON.HOSPID"], 
        CardTypeID:CardTypeID
    },false);
    $("#RLCredTypeList").combobox("loadData",CardCreadType);
}
