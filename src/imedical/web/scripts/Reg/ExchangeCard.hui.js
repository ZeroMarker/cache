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
	m_RLCredTypeID:"", //��ʧ��֤�����ʹ���
	m_CredNo:"", //��ʧ��֤������
	m_Computername:ClientIPAddress //GetComputerName()
}
$(function(){
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
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
	//�豸����
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
			PageLogicObj.m_RLCredTypeID=val[14]; //��ʧ��֤�����ʹ���
			PageLogicObj.m_CredNo=val[12]; //��ʧ��֤������
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
			$.messager.alert("��ʾ","�˿�����ʹ��,���ܻ���!","info",function(){
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
			$.messager.alert("��ʾ","�˿�����ʹ��,���ܻ���!","info",function(){
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
			$.messager.alert('��ʾ',"�˿��Ѿ�����ʧ,����ʹ��,��ʧ��:"+CancelInfo.split("^")[0]+",��ʧԭ��:"+CancelInfo.split("^")[1],"info",function(){
				$("#ExchangeCardNo").addClass("newclsInvalid"); 
				$("#ExchangeCardNo").focus();
			});
			return false;
		}else if(rtn=="-352"){
			$.messager.alert('��ʾ',"�˿��Ѿ�������,����ʹ��!","info",function(){
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
	//�������Backspace������  
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
	//���ݿ����;����Ƿ�д��
	if (PageLogicObj.m_CardRefFlag=="Y"){
		if (PageLogicObj.m_OverWriteFlag=="Y"){
			var myrtn=WrtCard();
			var myary=myrtn.split("^");
			if (myary[0]!="0"){
				$.messager.alert("��ʾ","д��ʧ��!");
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
			$.messager.alert("��ʾ","�����ɹ�!","info",function(){
				window.parent.RegReturnListTabDataGridLoad();
				window.parent.destroyDialog("CardManager");
			});
		}else if(ren[0]=='-359'){
			$.messager.alert("��ʾ","���ϵĿ������ٽ��л���!");
		}else if(ren[0]=='-360'){
			$.messager.alert("��ʾ","��ʧ״̬�Ŀ����ܽ��л���!");
		}else if(ren[0]=='-110'){
			$.messager.alert("��ʾ","���͸���ҽ�����Ҳ�����Ϣʧ��!");
		}else{
			$.messager.alert("��ʾ","��������ʧ��");
		}
	})
}
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function CheckExChange(){
	var CardStatus=$("#Flag").val();
    if (CardStatus!="����"){
	    $.messager.alert("��ʾ","ֻ������״̬�Ŀ����ܽ��л�������!");
		return false;
    }
	SetExchangeCardNOLength();
	if (ServerObj.CardID==""){
		$.messager.alert("��ʾ","ԭ�����Ų���Ϊ��");
		return false;
	}
	var ExchangeCardNo=$("#ExchangeCardNo").val();
	if (ExchangeCardNo==""){
		$.messager.alert("��ʾ","�������Ų���Ϊ��!","info",function(){
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
			$.messager.alert("��ʾ","���Ų���Ϊ��,�����!","info",function(){
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
			$.messager.alert("��ʾ","���ų��ȴ���!","info",function(){
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
			$.messager.alert("��ʾ","������ǰ׺����!","info",function(){
				$("#ExchangeCardNo").focus();
			});
			return false;
		}
	}
	var myval=$("#CardTypeDefine").combobox("getValue");
	PageLogicObj.m_SupportExChangeFlag=myval.split("^")[32];
	if(PageLogicObj.m_SupportExChangeFlag!="Y"){
		var CardTypeDesc=myval.split("^")[2];
		$.messager.alert("��ʾ",CardTypeDesc+" ��֧�ֻ���!");
		return false;
	}	
	var RLName=$("#RLName").val();
	if (RLName==""){
		$.messager.alert("��ʾ","��������������Ϊ��!","info",function(){
			$("#RLName").focus();
		});
		return false;
	}
	var CredType=$("#RLCredTypeList").combobox("getValue");
	if (CredType==""){
		$.messager.alert("��ʾ","������֤�����Ͳ���Ϊ��!");
		return false;
	}
	var RLAddress=$("#RLAddress").val();
	if (RLAddress==""){
		$.messager.alert("��ʾ","�����˵�ַ����Ϊ��!","info",function(){
			$("#RLAddress").focus();
		});
		return false;
	}
	var RLAddress=$("#RLPhoneNo").val();
	if (RLAddress==""){
		$.messager.alert("��ʾ","��������ϵ�绰����Ϊ��!","info",function(){
			$("#RLPhoneNo").focus();
		});
		return false;
	}
	if (!CheckTelOrMobile(RLAddress,"RLPhoneNo","��������ϵ�绰")) return false;
	var myIDNo=$("#RLCredNo").val();
	if(myIDNo!=""){
		var myIDrtn=IsCredTypeID();
		if (myIDrtn){
			var myIsID=DHCWeb_IsIdCardNo(myIDNo);
			if (!myIsID){
				$.messager.alert("��ʾ","���������֤�������!","info",function(){
					$("#RLCredNo").focus();
				});
				return false;
			}
		}
	}else{
		/*$.messager.alert("��ʾ","������֤�����벻��Ϊ��!","info",function(){
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
				$.messager.alert("��ʾ","������֤�����벻��Ϊ��!","info",function(){
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
		//��¼�������Ե�����
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
