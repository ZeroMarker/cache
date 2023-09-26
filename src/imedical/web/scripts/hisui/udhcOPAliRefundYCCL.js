/// udhcOPAliRefundYCCL.js

var PrtXMLName = "";
var myCPPFlag = "";
var m_YBConFlag = "0";
var listobj = parent.frames["udhcOPAliRefundyccl_Order"];
var RefundInfoFlag;   //是否可在此界面退费

$(function() {
	init_Layout();
	
	$("#ReceipNO").keydown(function (e) {
		ReceipNO_KeyDown(e);
	});
   	$("#PRTReceipID").keydown(function (e) {
		ReceipID_KeyDown(e);
	});
   	
   	$HUI.linkbutton("#RefClear", {
		onClick: function () {
			RefundClear_Click();
		}
	});
	
   	$HUI.linkbutton("#ReTrade", {
		onClick: function () {
			ReTrade_Click();
		}
	});
	
	$HUI.linkbutton("#ReadPos", {
		onClick: function () {
			ReadPosQuery_OnClick();
		}
	});
	
	$HUI.linkbutton("#RePrintAcert", {
		onClick: function () {
			RePrintAcert_OnClick();
		}
	});
   	
	$HUI.combobox("#RefundPayMode", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = session['LOGON.GROUPID'];
			param.HospID = session['LOGON.HOSPID'];
			param.TypeFlag = "FEE";
		}
	});
	
	IntDoc();
	
	focusById("ReceipNO");
});

function IntDoc() {
	var encmeth = getValueById("ReadOPBaseEncrypt");
	if (encmeth != ""){
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
		var myary = myrtn.split("^");
		m_YBConFlag = myary[12];
	}
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myPrtXMLName = "";
	var myary = myrtn.split("^");
	if (myary[0] == 0){
		myPrtXMLName=myary[10];
	}
	
	PrtXMLName=myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);
}

function ReadPosQuery_OnClick(){
	var myrtn = DHCACC_GetAccInfobyPos();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn){
		case "0":
			//var obj=document.getElementById("PatientID");
			//obj.value = myary[5];
			ReadCardQueryINV(myary[5]);
			//ReadPatInfo();
			break;
		case "-200":
			listobj.NoHideAlert('卡无效');
			break;
		case "-201":
			listobj.NoHideAlert('卡无效');
			//var obj=document.getElementById("PatientID");
			//obj.value=myary[5];
			//ReadPatInfo();
			break;
		default:
			//listobj.NoHideAlert("");
	}
}

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";  //YCCL
	lnk+="&FramName=udhcOPRefundYCCL&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","status=yes,scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click() {
	IntRefMain();
	parent.frames['udhcOPAliRefundyccl_Order'].location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid=";
}

function ReceipNO_KeyDown(e) {  
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) {
	   	var No=obj.value;
	   	var encmeth = getValueById("getReceipID");
		var rtn = cspRunServerMethod(encmeth, 'SetReceipID', '', No,"",session['LOGON.HOSPID']);
		var ReceipID = getValueById("ReceipID");
	  	if (ReceipID == "") {
		  	$("#ReTrade").linkbutton('disable');
			listobj.NoHideAlert('无效');
			websys_setfocus('ReceipNO');
			return websys_cancel();
		}else {
			$("#ReTrade").linkbutton('enable');
		   	var ReceipID=getValueById("ReceipID");
		   	var encmeth=getValueById("getReceiptinfo");
		   	var rtn=cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID,session['LOGON.HOSPID']);
	    	if (rtn=='0'&&RefundInfoFlag>0) {
				ReceipID = ReceipID.split("^")[0];
				parent.frames['udhcOPAliRefundyccl_Order'].location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid="+ReceipID;
		   	}
		}
	}
}

function ReTrade_Click(){
	var ReceipRowid=getValueById("ReceipID");
	var encmeth=getValueById('getRefundRcpt');
	var rtnvalue=cspRunServerMethod(encmeth, ReceipRowid);
	var myary=rtnvalue.split(String.fromCharCode(2));
	var rtn=myary[0].split("^");
	var abortrowid="";
	var normalrowid="";
	if(rtn[0]=="-1"){
		abortrowid=rtn[1];
	}
	if(rtn[0]=="-2"){
		abortrowid=rtn[2];
		normalrowid=rtn[1];
	}
	if(rtn[0]=="-3"){
		abortrowid=rtn[2];
		normalrowid=rtn[1];
	}
	if(rtn[0]=="0"){
		listobj.NoHideAlert(rtn[1]);
		return;
	}else {
		//add tangtao 2011-11-06   软POS
		var mystr=getValueById("RefundPayMode");
		var myary1=mystr.split("^");
		var myPayModeDR=myary1[0];
		var myPayModeCode=myary1[1];
		if(myPayModeCode=="ALIPAY") {
			var Guser=session['LOGON.USERID'];
    		var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^"+session['LOGON.USERID']+"^补交易退费";
			var retn=tkMakeServerCall("DHCAliPay.ChargeInterface.AliPayLogic","AliPay","OP",normalrowid,abortrowid,"","D",ExpStr)
			if(retn=="0") {
				listobj.NoHideAlert("补交易成功！");
			} else {
				listobj.NoHideAlert("Pos补交易失败,请联系信息部!");	
				return;
			}
		}else if (myPayModeCode=="WECHATPAY"){
			var Guser=session['LOGON.USERID'];
    		var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^"+session['LOGON.USERID']+"^补交易退费";
			var retn=tkMakeServerCall("DHCWeChatPay.ChargeInterface.WeChatPayLogic","WeChatPay","OP",normalrowid,abortrowid,"","D",ExpStr)
			if(retn=="0") {
				listobj.NoHideAlert("补交易成功！");
			} else {
				listobj.NoHideAlert("Pos补交易失败,请联系信息部!");	
				return;
			}
		}else {
			listobj.NoHideAlert("获取配置失败,该支付方式没有银医卡或者软POS支付配置,不能补交易")
		}
	}
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	var INVtmp = INVstr.split("^");
	DHCP_GetXMLConfig("InvPrintEncrypt",PrtXMLName);
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != ""){
			var encmeth = getValueById('getSendtoPrintinfo');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session["LOGON.USERCODE"];
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, TxtInfo, ListInfo);
}

function SetReceipID(value) {
	try {
		var myAry = value.split('^');
		var ReceipID = myAry[0];
		var sFlag = myAry[1];
		if (sFlag == 'PRT') {
			setValueById("ReceipID", ReceipID);
			setValueById("PRTReceipID", ReceipID);
		}
	} catch(e) {
	}
}

function SetReceipInfo(value) {
	RefundInfoFlag=1;
	var Split_Value=value.split("^");
	var GUser=session['LOGON.USERID'];
	setValueById("PatientID", Split_Value[0]);
	setValueById("PatientName", Split_Value[1]);
	setValueById("PatientSex", Split_Value[2]);
	setValueById("Sum", parseFloat(Split_Value[3]).toFixed(2));
	setValueById("RefundPayMode", Split_Value[9]);
	setValueById("INSDivDR", Split_Value[13]);
	setValueById("InsType", Split_Value[17]);
	
	var myColPFlag=Split_Value[10];
	if (myColPFlag=="1"){
		RefundInfoFlag=-1;
		listobj.NoHideAlert(t["ColPTip"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();		
	}
	if ((Split_Value[4]!="A")&&(Split_Value[4]!="S")) {
		listobj.NoHideAlert("此收据没有退费信息");
		RefundInfoFlag=-1;
		return websys_cancel();
	}
	if (Split_Value[5]=="1") {
		//listobj.NoHideAlert(t['12']);
		//websys_setfocus('ReceipNO');
		//return websys_cancel();
	}
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefundyccl_Order'];
	AdmCharge.location.href=lnk;
}

function IntRefMain() {
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundYCCL";
	window.location.href=lnk;
}

function RePrintAcert_OnClick() {
	var UserName=session['LOGON.USERNAME'];
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillFindBankTrade";
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&UserName="+UserName;
	var NewWin=open(lnk,"DHCOPBillFindBankTrade","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function ReceipID_KeyDown(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) {
	   	var IDobj=document.getElementById("ReceipID");
	   	IDobj.value=document.getElementById("PRTReceipID").value;
	   	var rptinfoobj=document.getElementById("getReceiptinfo");
	   	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
    	if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value,session['LOGON.HOSPID'])=='0'&&RefundInfoFlag>0) {
			var ReceipID=IDobj.value.split("^")[0];
			parent.frames['udhcOPAliRefundyccl_Order'].location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid="+ReceipID;
	   	}
	}
}

function init_Layout(){
	$('#cReceipNO').parent().parent().css("width","60px");
	DHCWeb_ComponentLayout();
}