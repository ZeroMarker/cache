var PageLogicObj={
	m_Computername:GetComputerName()
}
$(function(){
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	$("#RLName").focus();
})
function InitEvent(){
	$("#BtnCancel").click(BtnCancelClickHandle);
	document.onkeydown = DocumentOnKeyDown;
}
function DocumentOnKeyDown(e){
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
	if(e.keyCode==120){ 
		BtnCancelClickHandle();
		return false;
	}
}
function PageHandle(){
	LoadRLCredTypeList();
	LoadCardTypeDefine();
	if (ServerObj.CardID!=""){
		SetPatInfoByCardID();
	}
	LoadPayMode();
}
function LoadPayMode(){
	///�˿�ֻ֧��ԭ֧����ʽ���ֽ�
	///����ȫ��֧����ʽ����web.UDHCOPOtherLB.cls  ReadPayMode����

	$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"PayModeToCancleCard",
		CardRowId:ServerObj.CardID,
		dataType:"text",
	},function(Data){
		var cbox = $HUI.combobox("#PayMode", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				blurValidValue:true,
				data: eval("("+Data+")"),		
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
		ClassName:"web.DHCBL.CARD.UCardRefInfo", 
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
			$("#Sex").val(val[20]);
			$("#Birth").val(val[21]);
			$('#PatCharge').val(val[23]); 
			$('#CardFareCost').val(parseFloat(val[18]).toFixed(2));
			$('#ReceiptNO').val(val[19]);
 			var Data=$("#CardTypeDefine").combobox("getData");
			for (var i=0;i<Data.length;i++){
				var text=Data[i]["text"];
				if (text==val[22]){
					$("#CardTypeDefine").combobox("select",Data[i]["id"]);
					var myary=Data[i]["id"].split("^");
					if (myary[7]!="Y"){
						$("#BtnCancel").hide();
					}
					break;
				}
			}
		}
	});
}
function BtnCancelClickHandle(){
	$.messager.confirm('ȷ�϶Ի���', '���߾����Ƿ����?', function(r){
		if (r){
		    if (!CheckRptLoss()) return false;
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
					"RLProof="+"",
					"RLRemark="+$("#RLRemark").val(),
					"SecrityNo="+"",
					"UserDR="+session['LOGON.USERID'],
					"ComputerIP="+PageLogicObj.m_Computername,
					"LogonHospDR="+session['LOGON.HOSPID']
				];
				var myCardInfo=Card_GetEntityClassInfoToXML(ParseInfo,"CardStatusChange");
				var PayMode=$("#PayMode").combobox("getValue")
				var ExpStr=session['LOGON.HOSPID']+"^"+PayMode
				$.cm({
					ClassName:"web.DHCBL.CARDIF.ICardRefInfo", 
					MethodName:"CancelCardInfo",
					dataType:"text",
					UserDR:session['LOGON.USERID'], sFlag:"A", 
					CardStatusChangeInfo:myCardInfo, ExpStr:ExpStr
				},function(myrtn){
					var myrtnAry=myrtn.split('$');			
					if(myrtnAry[0]=='-355'){
						$.messager.alert("��ʾ","�˿���ǰ״̬�������˿�!");
					}else if(myrtnAry[0]=='-373'){
						$.messager.confirm("ȷ�϶Ի���","���˻�����,�Ƿ���㣿",function(rtn){
							if(rtn){
								/*var src="websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCACAcc.FootManage";
								window.showModalDialog(src,"�˻�����","dialogwidth:80em;dialogheight:60em;center:1;status:no");*/
								websys_showModal({
									url:"websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCACAcc.FootManage",
									title:'�˻�����',
									width:'80%',height:'60%',
								})
							}
						})
						//$.messager.alert("��ʾ","����Ӧ����Ч�˻�,���ܰ����˿�,����ʹ�������˻�����");
					}else if(myrtnAry[0]==0){
						var AlertStr="�˿��ɹ�!"
						if(myrtnAry[3]!="") {
							var AlertStr="�˿��ɹ�!���˻�����������:"+myrtnAry[3]+",�����˻�����!"
						}
						$.messager.alert("��ʾ",AlertStr,"info",function(){
							var InvInfo=myrtnAry[1];
							var myParkRowID=myrtnAry[2];
							PatRegPatInfoPrint(myParkRowID,"UDHCCardInvPrt2","ReadAccCarDPEncrypt")
							window.parent.RegReturnListTabDataGridLoad();
							window.parent.destroyDialog("CardManager");
						});
					}else{
						$.messager.alert("��ʾ","�˿�ʧ��!");
					}
				});
		}
	});
}
//����js ���� �˿���ӡ�վ�
///������dhc_cardinvprt Rowid��"UDHCCardInvPrt", "ReadAccCarDPEncrypt"
//PatRegPatInfoPrint("","UDHCCardInvPrt","ReadAccCarDPEncrypt")
function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName)
{
	if (CurXMLName==""){
		return;
	}
	var INVtmp=RowIDStr.split("^");
	if (INVtmp.length>0){
		DHCP_GetXMLConfig("InvPrintEncrypt",CurXMLName);
	}
	for (var invi=0;invi<INVtmp.length;invi++){
		if (INVtmp[invi]!=""){
			var encmeth=$("#"+EncryptItemName).val();
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew","",INVtmp[invi], Guser,"");
		}			
	}
}
function InvPrintNew(TxtInfo,ListInfo)
{
	var PDlime=String.fromCharCode(2);
	var TxtInfo=TxtInfo+"^"+"hospitalDesc"+PDlime+session['LOGON.HOSPDESC'];
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}
function CheckRptLoss()
{
	if (ServerObj.CardID==""){
		$.messager.alert("��ʾ","ԭ�����Ų���Ϊ��");
		return false;
	}
	var CardStatusFlag=$("#Flag").val();
	if (CardStatusFlag!="����"){
		$.messager.alert("��ʾ","�������������˿�!");
		return false;
	}
	return true;
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