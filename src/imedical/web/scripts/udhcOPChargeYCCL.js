/// udhcOPChargeYCCL.js

var GUser;
var AllExecute;
var ExeFlag;
var RebillFlag;
var PartRefFlag;
var m_AbortPop = 0;
var m_RefundPop = 0;
var PrtXMLName;
var myCPPFlag = "";
var m_YBConFlag = "0"; //default not Connection YB

function BodyLoadHandler() {
	var obj = document.getElementById("RefundPayMode");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	DHCWebD_ClearAllListA("RefundPayMode");
	var encmeth = DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc = session['LOGON.GROUPID'];
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "RefundPayMode");
	}

	IntDoc();

	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_KeyDown;
	}
	var obj = document.getElementById("Abort");
	if (obj) {
		DHCWeb_DisBtn(obj);
	}
	var obj = document.getElementById("Refund");
	if (obj) {
		DHCWeb_DisBtn(obj);
	}
	var obj = document.getElementById("RefClear");
	if (obj) {
		obj.onclick = RefundClear_Click;
	}
	var obj = document.getElementById("BtnQuery");
	if (obj) {
		obj.onclick = INVQuery_Click;
	}
	var obj = document.getElementById("ReadCardQuery");
	if (obj) {
		obj.onclick = ReadCardQuery_OnClick;
	}
	var obj = document.getElementById("ReadPos");
	if (obj) {
		obj.onclick = ReadPosQuery_OnClick;
	}
	ReadINVInfo();
	DHCWeb_setfocus("ReceipNO");
	document.onkeydown = DHCWeb_EStopSpaceKey;

	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
		var myary = myrtn.split("^");
		m_YBConFlag = myary[12];
	}

	if (m_YBConFlag == "1") {
		DHCWebOPYB_InitForm();
	}
	var obj = document.getElementById("ReTrade");
	if (obj) {
		obj.onclick = ReTrade_Click;
	}
	var obj = document.getElementById("RePrintAcert");
	if (obj) {
		obj.onclick = RePrintAcert_OnClick;
	}
}

function IntDoc() {
	//Load Base Config
	var mygLoc = session['LOGON.GROUPID'];
	var encmeth = DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		//_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		//foot Flag
		m_AbortPop = myary[7];
		m_RefundPop = myary[8];
		//Get PrtXMLName
		var myPrtXMLName = myary[10];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); //INVPrtFlag
}

function INVQuery_Click() {
	QueryInv();
}

function ReadCardQuery_OnClick() {
	var myrtn = DHCACC_GetAccInfo();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//var obj = document.getElementById("PatientID");
		//obj.value = myary[5];
		ReadCardQueryINV(myary[5]);
		//ReadPatInfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		alert(t["-201"]);
		//var obj = document.getElementById("PatientID");
		//obj.value = myary[5];
		//ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function ReadPosQuery_OnClick() {
	var myrtn = DHCACC_GetAccInfobyPos();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//var obj = document.getElementById("PatientID");
		//obj.value = myary[5];
		ReadCardQueryINV(myary[5]);
		//ReadPatInfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		alert(t["-201"]);
		//var obj = document.getElementById("PatientID");
		//obj.value = myary[5];
		//ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk += "&FramName=udhcOPChargeYCCL&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINVYCCL_Query", "status=yes,scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function QueryInv() {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk += "&FramName=udhcOPChargeYCCL";
	lnk += "&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINVYCCL_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click() {
	IntRefMain();
	AddIDToOrder("");
}

function BVerify_Click() {
	var IDobj = document.getElementById("ReceipID");
	var ReceipRowid = IDobj.value;
	GUser = session['LOGON.USERID'];
	var encmeth = DHCWebD_GetObjValue("getVerify");
	if (cspRunServerMethod(encmeth, ReceipRowid, GUser) == '0') {
		alert(t['04']);
	} else {
		alert(t['05']);
	}
}

function ReceipNO_KeyDown(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj) && (obj.value != "") && (key == 13)) {
		var No = obj.value;
		var encmeth = DHCWebD_GetObjValue("getReceipID");
		var rtn = cspRunServerMethod(encmeth, 'SetReceipID', '', No);
		var ReceipID = DHCWebD_GetObjValue("ReceipID");
		if (ReceipID != "") {
			var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
			if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID) == '0') {
				var reTradeObj = websys_$("ReTrade");
				DHCWeb_AvailabilityBtnA(reTradeObj, ReTrade_Click);
				parent.frames['udhcOPRefundyccl_Order'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid=" + ReceipID;
			}
		} else {
			DHCWeb_DisBtnA("ReTrade");
			alert(t['06']);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		}
	}
}

function ReadINVInfo() {
	//read INV Infomation
	var ReceipID = DHCWebD_GetObjValue("ReceipID");
	if (ReceipID == "") {
		return;
	}
	var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
	var rtn = cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID);
	if (rtn == '0') {
		parent.frames['udhcOPRefundyccl_Order'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid=" + ReceipID;
	}
}

function ReTrade_Click() {
	var InsTypeobj = document.getElementById("InsType");
	if (InsTypeobj) {
		InsType = InsTypeobj.value;
	}
	var recobj = document.getElementById("ReceipID");
	if (recobj) {
		ReceipRowid = recobj.value;
	}
	if (ReceipRowid != "") {
		var Obj1 = document.getElementById("GetOriginalTradeRowID");
		if (Obj1) {
			var encmeth = Obj1.value;
			rtn = cspRunServerMethod(encmeth, ReceipRowid);
			if (rtn != "") {
				alert("此发票已使用POS交易,无需再交易!");
				return;
			}
		}
	} else {
		alert("发票不存在!");
		return;
	}
	//add tangtao 2011-11-06   软POS
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myary1 = mystr.split("^");
	var myPayModeDR = myary1[0];
	var myPayModeCode = myary1[1];
	var expstr = "DLL" + "^INV^" + myPayModeDR + "^" + session['LOGON.GROUPID'];
	var handDR = "";
	var CommonObj = document.getElementById("GetPayModeHardComm");
	if (CommonObj) {
		var encmeth = CommonObj.value;
		handDR = cspRunServerMethod(encmeth, "OP", myPayModeDR);
		if (handDR != "") {
			var Status = handDR.split("^")[1];
			if (Status == "DLL") {
				var OrderInvPrtObj = document.getElementById("OrderInvPrt");
				if (OrderInvPrtObj) {
					var encmeth = OrderInvPrtObj.value;
					var InvPrtStr = cspRunServerMethod(encmeth, "C", ReceipRowid, "");
					if (InvPrtStr != "-1") {
						InvPrtStr = InvPrtStr + "#" + "";
						var InvPrtStr1 = InvPrtStr;
						invAmt = InvPrtStr1.split("#")[1];
						var rtnValue = CallDLLFun("OP", "C", ReceipRowid, expstr, ReceipRowid, InvPrtStr, "", "");
						tmpAry = rtnValue;
						if (tmpAry == "0") {
							alert("补交易成功!");
						} else {
							alert("补交易失败!");
						}
					} else {
						alert("获取传送信息失败,请重新尝试补交易!");
					}
				}
			} else {
				var BankCardNO = GetCardNo();
				if (BankCardNO == "-1") {
					return;
				}
				//BankCardNO,ReloadFlag,YBConFlag,AdmSource,BankTradeType,ClientType,PrtRowIDStr
				//增加医保以后要考虑YBConFlag , AdmSource
				var retn = BMCOPPay(BankCardNO, "", "", "", "C", "26", ReceipRowid);
				if (retn == "DelHisSuccess") {
					return;
				} else if (retn == "0") {
					alert("补交易成功");
				}
			}
		} else {
			alert("支付方式不是软POS或者银医卡,不能进行补交易!");
		}
	}
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	//var myary = INVstr.split(String.fromCharCode(2));
	var INVtmp = INVstr.split("^");
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);   //INVPrtFlag
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("getSendtoPrintinfo");
			var PayMode = DHCWebD_GetObjValue("PayMode");
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
	try {
		var myAry = value.split('^');
		var ReceipID = myAry[0];
		var sFlag = myAry[1];
		if (sFlag == 'PRT') {
			DHCWebD_SetObjValueB("ReceipID", ReceipID);
		}
	} catch(e) {
	}
}

function SetReceipInfo(value) {
	var myAry = value.split("^");
	var cobj = document.getElementById("Abort");
	var robj = document.getElementById("Refund");

	GUser = session['LOGON.USERID'];

	DHCWebD_SetObjValueB("PatientID", myAry[0]);
	DHCWebD_SetObjValueB("PatientName", myAry[1]);
	DHCWebD_SetObjValueB("PatientSex", myAry[2]);
	DHCWebD_SetObjValueB("Sum", myAry[3]);

	DHCWebD_SetObjValueB("INSDivDR", myAry[13]);
	DHCWebD_SetObjValueB("InsType", myAry[17]);

	if (cobj) {
		DHCWeb_DisBtn(cobj);
	}
	if (robj) {
		DHCWeb_DisBtn(robj);
	}

	if (myAry[9] != "") {
		var obj = document.getElementById("RefundPayMode");
		var myLen = obj.options.length;
		for (var i = 0; i < myLen; i++) {
			var mystr = obj.options[i].value;
			var myary = mystr.split("^");
			if (myary[0] == myAry[9]) {
				obj.selectedIndex = i;
				break;
			}
		}
	}
}

function AddIDToOrder(ReceipID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid=" + ReceipID;
	var AdmCharge = parent.frames['udhcOPRefundyccl_Order'];
	AdmCharge.location.href = lnk;
}

function IntRefMain() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPChargeYCCL";
	var AdmCharge = parent.frames['udhcOPChargeYCCL'];
	AdmCharge.location.href = lnk;
}

function RePrintAcert_OnClick() {
	var UserName = session['LOGON.USERNAME'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillFindBankTrade";
	lnk += "&FramName=udhcOPChargeYCCL";
	lnk += "&UserName=" + UserName;
	var NewWin = open(lnk, "DHCOPBillFindBankTrade", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function GetCardNo() {
	alert("请刷银行卡");
	var myrtn = DHCACC_GetAccInfobyPos();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	if (rtn == "-200") {
		alert(t["-200"]);
		return "-1";
	}
	if (rtn == "-201") {
		alert(t["-201"]);
		return "-1";
	}
	if (rtn == "0") {
		return myary[1]
	} else {
		alert("卡无效");
		return "-1";
	}
}

document.body.onload = BodyLoadHandler;