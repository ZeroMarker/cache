/// udhcOPRefund.Auditing.js

var GUser;
var AllExecute;
var RebillFlag;
var PartRefFlag;
var PrtXMLName;
var m_Version = "";
var m_SelectCardTypeRowID = "";
var mygLocDR = "";
var myULoadLocDR = "";
var Guser = "";
var HospDR = "";
var FramName = "udhcOPRefund_Auditing";

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	myULoadLocDR = session['LOGON.CTLOCID'];
	mygLocDR = session['LOGON.GROUPID'];
	HospDR = session['LOGON.HOSPID'];
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_KeyDown;
	}
	var obj = document.getElementById("PatientID");
	if (obj) {
		obj.onkeydown = PatientNO_KeyDown;
	}
	DHCWeb_DisBtnA("BVerify");   //初始化界面时,"退费审核"设为disabled
	obj = document.getElementById("RefClear");
	if (obj) {
		obj.onclick = RefundClear_Click;
	}
	obj = document.getElementById("BtnQuery");
	if (obj) {
		obj.onclick = INVQuery_Click;
	}
	var obj = document.getElementById("ReadCardQuery");
	if (obj) {
		obj.onclick = ReadCardQuery_OnClick;
	}
	var obj = document.getElementById("Cancel");
	if (obj) {
		obj.onclick = CancelAudit;
	}
	var myobj = document.getElementById("RefundReason");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	ReadINVInfo();
	document.onkeydown = DHCWeb_EStopSpaceKey;

	IntDoc();

	var obj = document.getElementById('CardTypeDefine');
	if (obj) {
		ReadCardType();
		obj.setAttribute("isDefualt", "true");
		combo_CardType = dhtmlXComboFromSelect("CardTypeDefine");
	}
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle = combo_CardTypeKeydownHandler;
	}

	combo_CardTypeKeydownHandler();
}

function IntDoc() {
	m_Version = DHCWebD_GetObjValue("DHCVersion");
	var myPrtXMLName = "";
	switch (m_Version) {
	case "1":
		PrtXMLName = "AHSLOPAudit";
		myPrtXMLName = PrtXMLName;
		break;
	default:
		break;
	}
	if (PrtXMLName != "") {
		DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); //INVPrtFlag
	}
}

function INVQuery_Click() {
	QueryInv();
}

function QueryInv() {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=udhcOPRefund_Auditing";
	lnk += "&AuditFlag=ALL&sFlag=ALL&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=1100,height=600");
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=udhcOPRefund_Auditing&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=ALL&sFlag=ALL&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function ReadCardQuery_OnClick() {
	//var myrtn = DHCACC_GetAccInfo();
	var myCardTypeValue = combo_CardType.getSelectedValue();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
	//alert(myrtn);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//DHCWebD_SetObjValueB("PatientID", myary[5]);
		ReadCardQueryINV(myary[5]);
		///ReadPatInfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		alert(t["-201"]);
		//DHCWebD_SetObjValueB("PatientID", myary[5]);
		//ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function RefundClear_Click() {
	IntRefMain();
	AddIDToOrder("");
}

function BVerify_Click() {
	var mywin = parent.frames["udhcOPRefund_AuditOrder"].window;
	var ret = mywin.checkreqqty();
	if (ret == 1) {
		return;
	}
	var myAuditInfo = mywin.GetAuditInfo();
	var myAudFlag = DHCWebD_GetObjValue("AuditFlag");
	if (myAuditInfo == "DrugReaNull") {
		return;
	}
	//alert("BVerify="+myAudFlag+"myAuditInfo="+myAuditInfo);
	if (((myAudFlag == "4") || (myAudFlag == "3") || (myAudFlag == "2")) && (myAuditInfo == "")) {
		alert(t["SelOETip"]);
		return;
	}
	var myRefReason = DHCWeb_GetListBoxValue("RefundReason");
	if (myRefReason == "") {
		alert(t["AddReaTip"]);
		return;
	}
	var ReceipRowid = DHCWebD_GetObjValue("ReceipID");
	GUser = session['LOGON.USERID'];
	var encmeth = DHCWebD_GetObjValue("getVerify");
	var myLocDR = session["LOGON.CTLOCID"];
	//alert(myAuditInfo);
	var myrtn = cspRunServerMethod(encmeth, ReceipRowid, GUser, myAuditInfo, myRefReason, myLocDR);
	if (myrtn == "0") {
		DHCWeb_DisBtnA("BVerify");
		//Print Audit OEOrdItem
		var myINVStr = "0^" + ReceipRowid;
		//BillPrintNew(myINVStr);
		alert(t["10"]);
		ReloadOrderFrm();
	} else {
		alert(t["11"] + ":" + myrtn);
	}
}

function ReceipNO_KeyDown(e) {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	var Guser = session['LOGON.USERID'];
	var HospDR = session['LOGON.HOSPID'];
	if ((obj) && (obj.value != "") && (key == 13)) {
		var No = obj.value;
		var encmeth = DHCWebD_GetObjValue("getReceipID");
		var mytmprtn = cspRunServerMethod(encmeth, 'SetReceipID', '', No, Guser, HospDR);
		var ReceipID = mytmprtn.split("^")[0];
		if (mytmprtn == '-1') {
			alert(t["12"]);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		} else if (mytmprtn == '-2') {
			alert("错误:-2");
			websys_setfocus('ReceipNO');
			return websys_cancel();
		} else {
			var ReceipID = DHCWebD_GetObjValue("ReceipID");
			var InvType = DHCWebD_GetObjValue("InvType");
			DHCWebD_SetObjValueB("TabFlag", InvType);
			var StatFlag = tkMakeServerCall("web.udhcOPRefund", "GetInvStatFlag", ReceipID);
			if (StatFlag != "") {
				alert("该发票为急诊留观发票,不需要退费申请,需要医生停止医嘱才能退费.");
				return;
			}
			var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
			if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID, InvType) == '0') {
				var myExpStr = Guser + "^" + mygLocDR + "^" + myULoadLocDR + "^" + HospDR;
				var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.AuditOrder&ReceipRowid=" + ReceipID + "&AuditFlag=" + "" + "&InvType=" + InvType + "&ExpStr=" + myExpStr;
				parent.frames['udhcOPRefund_AuditOrder'].location.href = lnk;
			}
		}
	}
}

function ReadINVInfo() {
	var ReceipID = DHCWebD_GetObjValue("ReceipID");
	if (ReceipID == "") {
		return;
	}
	var StatFlag = tkMakeServerCall("web.udhcOPRefund", "GetInvStatFlag", ReceipID);
	if (StatFlag != "") {
		alert("该发票为急诊留观发票,不需要退费申请,需要医生停止医嘱才能退费.");
		return;
	}
	var InvType = DHCWebD_GetObjValue("TabFlag");
	DHCWebD_SetObjValueB("InvType", InvType);
	var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
	if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID, InvType) == '0') {
		var myExpStr = Guser + "^" + mygLocDR + "^" + myULoadLocDR + "^" + HospDR;
		parent.frames['udhcOPRefund_AuditOrder'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.AuditOrder&ReceipRowid=" + ReceipID + "&InvType=" + InvType + "&ExpStr=" + myExpStr;
	}
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("getSendtoPrintinfo");
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session["LOGON.USERCODE"];
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function SetReceipID(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("ReceipID", myAry[0]);
	DHCWebD_SetObjValueB("InvType", myAry[1]);
}

function SetReceipInfo(value) {
	var Split_Value = value.split("^");
	var Sumobj = document.getElementById("Sum");
	var sexobj = document.getElementById("PatientSex");
	var nameobj = document.getElementById("PatientName");
	var noobj = document.getElementById("PatientID");
	var veryobj = document.getElementById("BVerify");
	var myAudObj = document.getElementById("AuditFlag");

	GUser = session['LOGON.USERID'];
	noobj.value = Split_Value[0];
	nameobj.value = Split_Value[1];
	sexobj.value = Split_Value[2];
	Sumobj.value = Split_Value[3];
	myAudObj.value = Split_Value[11];
	DHCWebD_SetObjValueB("EncryptLevel", Split_Value[20]);
	DHCWebD_SetObjValueB("PatLevel", Split_Value[21]);
	//alert(Split_Value[8]);
	//if be Audited  not to Audit
	if (Split_Value[18] != "" && Split_Value[18] != "N") {
		DHCWeb_DisBtn(veryobj);
		alert(t["-201"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}

	DHCWeb_AvailabilityBtnA(veryobj, BVerify_Click);
	if ((Split_Value[8] == "Y") && (Split_Value[12] != "M") && (Split_Value[11] == "0")) {
		//按发票审核时，只能审核一次，按医嘱审核时可以审核多次。
		DHCWeb_DisBtn(veryobj);
		alert(t["04"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	} else {
		if (veryobj) {
			DHCWeb_AvailabilityBtnA(veryobj, BVerify_Click);
		}
	}
	if (Split_Value[4] == "A") {
		DHCWeb_DisBtn(veryobj);
		alert(t["05"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[5] == "1") {
		DHCWeb_DisBtn(veryobj);
		alert(t["06"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
}

function AddIDToOrder(ReceipID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.AuditOrder&ReceipRowid=" + ReceipID;
	var AdmCharge = parent.frames['udhcOPRefund_AuditOrder'];
	AdmCharge.location.href = lnk;
}

function IntRefMain() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund_Auditing";
	var AdmCharge = parent.frames['udhcOPRefund_Auditing'];
	AdmCharge.location.href = lnk;
}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function combo_CardTypeKeydownHandler() {
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	///Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	} else {
		//m_CCMRowID = GetCardEqRowId();
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
}

///Lid
///2010-03-23
///撤销审核
function CancelAudit() {
	var invPrtRowid = DHCWebD_GetObjValue("ReceipID");
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	if ((invPrtRowid == "") || (invPrtRowid == " ")) {
		alert("请选择要取消审核的发票.");
		return;
	}
	/*
	if ((myReceipNO == "") || (myReceipNO == " ")){
		alert("请选择要取消审核的发票.");
		return;
	}
	*/
	var Reload = DHCWebD_GetObjValue("TabFlag");
	var rtn = tkMakeServerCall("web.udhcOPRefund", "CancelAudi", invPrtRowid, Reload, session['LOGON.USERID']);
	if (rtn == 0) {
		alert("撤销审核成功");
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Auditing";
		lnk += "&ReceipID=" + invPrtRowid + "&ReceipNO=" + myReceipNO + "&TabFlag=" + Reload;
		window.location.href = lnk;
	} else if (rtn == -1) {
		alert("该发票已经退费,不允许撤销审核");
	} else if (rtn == -2) {
		alert("该发票未申请退费,不能取消申请");
	} else {
		alert("撤销审核失败");
	}
}

function PatientNO_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj) && (obj.value != "") && (key == 13)) {
		var PatientNO = tkMakeServerCall("web.DHCOPCashier", "FormatPatientNo", websys_$V("PatientID"));
		DHCWebD_SetObjValueB("PatientID", PatientNO);
		ReadCardQueryINV(websys_$V("PatientID"));
	}
}

///刷新医嘱列表
function ReloadOrderFrm() {
	var ReceipID = DHCWebD_GetObjValue("ReceipID");
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	var Reload = DHCWebD_GetObjValue("TabFlag");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Auditing";
	lnk += "&ReceipID=" + ReceipID + "&ReceipNO=" + myReceipNO + "&TabFlag=" + Reload;
	window.location.href = lnk;
}

document.body.onload = BodyLoadHandler;
