///UDHCACRefundAPI.js

var m_YBConFlag = "0"; //default not Connection YB
var ExeFlag = 1;
var m_AbortFlag = 0;
var m_RefundFlag = 0;
var m_RebillFlag = 0;
var m_RefRowIDStr = new Array();
var m_InsType = "";
var m_Admsource = "";

function BodyLoadHandler() {
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.onkeypress = ReceiptNO_OnKeyPress;
		if (obj.value != "") {
			ReceiptNO_OnKeyPress();
		}
	}
	var obj = document.getElementById("Abort");
	DHCWeb_DisBtnA("Abort");
	var obj = document.getElementById("Refund");
	DHCWeb_DisBtnA("Refund");
	var obj = document.getElementById("Clear");
	if (obj) {
		obj.onclick = Clear_OnClick;
	}
	IntDocument();
	DHCWeb_setfocus("ReceiptNO");
	IntDoc();
	document.onkeydown = DHCWeb_EStopSpaceKey;
	/*
	var myReloadFlag = DHCWebD_GetObjValue("ReloadFlag");
	if (myReloadFlag == "1"){
		//Load Receipt Info Direct
		event.keyCode = 13;
		ReceiptNO_OnKeyPress();
		event.keyCode = 0;
	}
	*/
}

function IntDoc() {
	var mygLoc = session['LOGON.GROUPID'];
	//Load Base Config
	var encmeth = DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		//_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		//foot Flag
		//Check Invoice PrtFlag
		mPrtINVFlag = myary[4];
		//Get ColPrtXMLName
		var myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); ///INVPrtFlag

	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
	}
	var myary = myrtn.split("^");
	m_YBConFlag = myary[9];
	if (m_YBConFlag == "1") {
		//iniInsuForm();
	}
}

function Abort_OnClick() {
	RefundSaveInfo("A");
}

function Refund_OnClick() {
	RefundSaveInfo("S");
}

function Clear_OnClick() {
	SetACRefundMain();
	SetACRefOEOrder("");
}

function ReceiptNO_OnKeyPress(e) {
	var key = event.keyCode;
	var obj = websys_getSrcElement(e);
	var myReceiptNO = DHCWebD_GetObjValue("ReceiptNO");
	if ((myReceiptNO != "") && (key == 13)) {
		var myUser = session['LOGON.USERID'];
		var encmeth = DHCWebD_GetObjValue("ReadINVByNoEncrypt");
		var myrtn = cspRunServerMethod(encmeth, myReceiptNO, myUser);
		var rtn = myrtn.split("^")[0];
		if (rtn != "0") {
			alert(t['06']);
			websys_setfocus('ReceiptNO');
			return websys_cancel();
		} else {
			WrtRefundMain(myrtn);
			var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
			SetACRefOEOrder(myAPIRowID);
		}
	}
}

function SetACRefundMain() {
	var lnk = "";
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefundAPI";
	RefundMain = parent.frames["UDHCACRefundAPI"];
	RefundMain.location.href = lnk;
}

function SetACRefOEOrder(APIRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefundINV&APIRowID=" + APIRowID;
	var ACOEList = parent.frames["UDHCACRefundINV"];
	ACOEList.location.href = lnk;
}

function IntDocument() {
	var obj = document.getElementById("PayModeList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	DHCWebD_ClearAllListA("PayModeList");
	var encmeth = DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc = session['LOGON.GROUPID'];
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayModeList");
	}

}

function WrtRefundMain(AccINVInfo) {
	// Write Info For Main Form
	var myary = AccINVInfo.split("^");
	DHCWebD_SetObjValueB("ReceiptNO", myary[1]);
	DHCWebD_SetObjValueB("PatientID", myary[2]);
	DHCWebD_SetObjValueB("PatientName", myary[3]);
	DHCWebD_SetObjValueB("PatientSex", myary[4]);
	DHCWebD_SetObjValueB("INVSum", myary[5]);
	var myBtnFlag = myary[6];
	DHCWebD_SetObjValueB("AccNo", myary[7]);
	DHCWebD_SetObjValueB("AccLeft", myary[8]);
	DHCWebD_SetObjValueB("AccRowID", myary[9]);
	DHCWebD_SetObjValueB("AccStatus", myary[10]);
	var obj = document.getElementById("PayModeList");
	if (obj) {
		var mylen = obj.options.length;
		for (var i = 0; i < mylen; i++) {
			var myval = obj.options[i].value;
			var mypayary = myval.split("^");
			if (myary[11] == mypayary[0]) {
				obj.options.selectedIndex = i;
				break;
			}
		}
		obj.disabled = true;
	}
	DHCWebD_SetObjValueB("YBPaySum", myary[12]);
	DHCWebD_SetObjValueB("AccStatDesc", myary[13]);
	DHCWebD_SetObjValueB("OldAccPayINVRowID", myary[14]);
	DHCWebD_SetObjValueB("PatSelfPay", myary[16]);
	DHCWebD_SetObjValueB("INSDivDR", myary[17]);

	m_InsType = myary[19];
	m_Admsource = myary[20];
	
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	if (myary[15] != "N") {
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t[myary[15] + "01"]);
		return;
	}
	//alert("myary[10]=" + myary[10]);
	var myVer = DHCWebD_GetObjValue("DHCVersion");
	//Check Account Status
	//alert("myary[10]=" + myary[10]);
	if (myary[10] == "F") {
		//foot
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t["AccFootTip"]);
		return;
	}
	//alert("myBtnFlag=" + myBtnFlag);
	switch (myBtnFlag) {
	case "S":
		var obj = document.getElementById("Refund");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Refund_OnClick);
		}
		if (myVer == "0") {
			ExeFlag = 0;
		} else {
			ExeFlag = 1;
		}
		break;
	case "P":
		var obj = document.getElementById("Abort");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Abort_OnClick);
		}
		ExeFlag = 0;
		break;
	default:
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert('请先做退费审核或到药房退药.');
		ExeFlag = 1;
		break;
	}
}

function EnBtn(myBtnFlag) {
	switch (myBtnFlag) {
	case "S":
		var obj = document.getElementById("Refund");
		if (obj) {
			obj.disabled = false;
			obj.onclick = Refund_OnClick;
		}
		break;
	case "A":
		var obj = document.getElementById("Abort");
		if (obj) {
			obj.disabled = false;
			obj.onclick = Abort_OnClick;
		}
		break;
	default:
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		break;
	}
}

function RefundSaveInfo(RefundFlag) {
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	var mystr = DHCWeb_GetListBoxValue("PayModeList");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var myPayModeCode = myary[1];
	var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
	var AccLeft = DHCWebD_GetObjValue("AccLeft");
	var YBPaySum = DHCWebD_GetObjValue("YBPaySum");
	
	if (myINSDivDR != '') {
		if (myPayModeCode == 'CPP') {
			alert("请到【卡支付退费】界面退费.");
			return;
		}else {
			alert("请注意收取:" + YBPaySum + "元.");
		}
	}
	var rtn = CardYBPark();
	if (rtn == false) {
		return rtn;
	}
	var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	var myUser = session['LOGON.USERID'];
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("PayModeList");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
	var myExpStr = "";
	//alert(myAPIRowID);
	var encmeth = DHCWebD_GetObjValue("SaveParkDataEncrypt");
	//INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	if (encmeth != "") {
		var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, myUser, RefundFlag);
		var myary = rtnvalue;
		var rtn = myary;
		//alert(rtn);
		if (rtn == "0") {
			alert("撤销成功!");
		} else {
			alert(rtnvalue);
			switch (rtn[0]) {
			case 109:
				alert(t['08']);
			default:
				alert(t['09']);
			}
			return false;
		}
	}
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	//alert(INVstr);
	//var myary = INVstr.split(String.fromCharCode(2));
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue('ReadINVDataEncrypt');
			var PayMode = DHCWebD_GetObjValue('PayMode');
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

function CardYBPark() {
	var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
	if (myINSDivDR == "") {
		//Not YB
		return true;
	}
	/*
	var encmeth = DHCWebD_GetObjValue('JudgeAPIDate');
	var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	var Flag = cspRunServerMethod(encmeth, myAPIRowID);
	if(Flag=="-1"){
		alert("发票已跨月,不允许退费!");
		return false;
	}
	*/
	if ((myINSDivDR != "") && (m_YBConFlag == "0")) {
		alert(t["ReqYBTip"]);    //Require YB Connection
		return false;
	}
	var myrtn = QueryYBsysStrik(myINSDivDR);
	if (myrtn == "0") {
		return true;
	} else {
		alert(t["YBParErr"]);
		return false;
	}
}

function QueryYBsysStrik(myINSDivDR) {
	/*
	if (insuINSUFlag != "Y"){
		alert("No YB Client!");
		return "-1";
	}
	if (insuDLLFlag != "Y"){
		alert("No Intial");
		return "-1";
	}
	if (insudHandle <= 0){
		alert("dHandle = " + insudHandle);
		return "-1";
	}
	*/
	
	var OutString = "";
	var insudHandle = "0";
	var myUser = session['LOGON.USERID'];
	var ExpStr = "";
	var InsuType = m_InsType;
	var CPPFlag = "N";
	//alert("myINSDivDR:"+myINSDivDR+"---InsuType:"+InsuType);
	OutString = InsuOPDivideStrike(insudHandle, myUser, myINSDivDR, m_Admsource, InsuType, ExpStr, CPPFlag);

	return OutString;
}

document.body.onload = BodyLoadHandler;
