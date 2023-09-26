/// UDHCAccCallBackFINV.js

var m_YBConFlag = "0";   //default not Connection YB
var ExeFlag = 1;
var M_Computername = "";
var m_AbortFlag = 0;
var m_RefundFlag = 0;
var m_RebillFlag = 0;
var m_RefRowIDStr = new Array();
var m_OverWriteFlag = "N";
var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_CardNoLength = 0;
var m_ReadCardMode = "";
var m_Hospital_DR = session['LOGON.HOSPID'];

function BodyLoadHandler() {
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_OnKeyPress;
	}

	var obj = document.getElementById("RActAccount");
	DHCWeb_DisBtnA("RActAccount");

	var obj = document.getElementById("Clear");
	if (obj) {
		obj.onclick = Clear_OnClick;
	}

	var obj = document.getElementById("ReadCard");
	if (obj) {
		obj.onclick = ReadMagCard_Click;
	}
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
	IntDocument();
	DHCWeb_setfocus("ReceipNO");

	IntDoc();
	document.onkeydown = DHCWeb_EStopSpaceKey;

	var myReloadFlag = DHCWebD_GetObjValue("ReloadFlag");
	if (myReloadFlag == "1") {
		//Load Receipt Info Direct
		event.keyCode = 13;
		ReceipNO_OnKeyPress();
		event.keyCode = 0;
	}
	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeypress = CardNo_OnKeyPress;
	}
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
		//Check Invoice PrtFlag
		mPrtINVFlag = myary[4];
		var myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);    //INVPrtFlag
	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
	}
	var myary = myrtn.split("^");
	m_YBConFlag = myary[9];
	if (m_YBConFlag == "1") {
		//iniInsuForm();
	}
	
	combo_CardTypeKeydownHandler();
		
	//var WshNetwork = new ActiveXObject("WScript.NetWork");
	//M_Computername = WshNetwork.ComputerName;
}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function GetCardTypeRowId() {
	var CardTypeRowId = "";
	var CardTypeValue = combo_CardType.getSelectedValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId() {
	var CardEqRowId = "";
	var CardTypeValue = combo_CardType.getSelectedValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardEqRowId = CardTypeArr[14];
	}
	return CardEqRowId;
}

function GetCardNoLength() {
	var CardNoLength = "";
	var CardTypeValue = combo_CardType.getSelectedValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardNoLength = CardTypeArr[17];
	}

	return CardNoLength;
}

function FormatCardNo() {
	var CardNo = DHCC_GetElementData("CardNo");
	if (CardNo != "") {
		var CardNoLength = GetCardNoLength();
		if ((CardNo.length < CardNoLength) && (CardNoLength != 0)) {
			for (var i = (CardNoLength - CardNo.length - 1); i >= 0; i--) {
				CardNo = "0" + CardNo;
			}
		}
	}
	return CardNo;
}

function combo_CardTypeKeydownHandler() {
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	m_OverWriteFlag = myary[23];
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	m_ReadCardMode = myary[16];
	m_CardNoLength = myary[17];  //该卡类型定义的卡号长度
	//Read Card Mode
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
			DHCWeb_AvailabilityBtnA(obj, ReadMagCard_Click);
		}
	}

	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");
	} else {
		DHCWeb_setfocus("ReadCard");
	}
	if (combo_CardType)
		websys_nexttab(combo_CardType.tabIndex);
}

function RActAccount_OnClick() {
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	if (myCardNo == "") {
		alert(t["ReadCTip"]);
		return;
	}
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	if (myAccRowID == "") {
		alert(t["SelAccINfo"]);
		return;
	}
	var myCardRowID = DHCWebD_GetObjValue("CardRowID");
	if (myCardRowID == "") {
		//Wrt Card
		var myrtn = WrtCard();
		var myary = myrtn.split("^");
		if (myary[0] != "0") {
			return;
		}
		var mySecrityNo = myary[1];
	} else {
		var mySecrityNo = "";
	}
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var myUserDR = session['LOGON.USERID'];
	var myCardInfo = BuildCardInfo(mySecrityNo);
	var myComIP = M_Computername;
	var myExpStr = myCardRowID + "^" + m_SelectCardTypeRowID;
	var myEncrypt = DHCWebD_GetObjValue("SaveAccBackEncrypt");
	if (myEncrypt != "") {
		var myrtn = cspRunServerMethod(myEncrypt, myAccRowID, myUserDR, myCardInfo, myComIP, myExpStr);
		var myary = myrtn.split(String.fromCharCode(2));
		if (myary[0] == "0") {
			DHCWeb_DisBtnA("RActAccount");
			alert(t["AccBackSucc"]);
		} else {
			DHCWeb_DisBtnA("RActAccount");
			alert(t["AccBackFail"] + myary[0]);
		}
	}
}

function BuildCardInfo(SecrityNo) {
	var mystr = "";
	var myary = new Array();
	myary[myary.length] = DHCWebD_GetObjValue("PatientID");
	myary[myary.length] = DHCWebD_GetObjValue("PAPMIRowID");
	myary[myary.length] = "";     //IDCardNo1
	myary[myary.length] = DHCWebD_GetObjValue("CardNo");
	myary[myary.length] = SecrityNo;
	myary[myary.length] = "";
	myary[myary.length] = "";
	myary[myary.length] = session['LOGON.USERID'];
	myary[myary.length] = M_Computername;
	myary[myary.length] = SecrityNo;

	var myoptval = combo_CardType.getSelectedValue();

	var myCardTypeary = myoptval.split("^");
	var myCardTypeDR = myCardTypeary[0];
	myary[myary.length] = myCardTypeDR;
	mystr = myary.join("^");
	return mystr;
}

function WrtCard() {
	//Read Secrity
	//ReadSecEnvrypt
	if (m_OverWriteFlag != "Y") {
		return "0^";
	}
	var mySecrityNo = "";
	window.status = t[2011];
	var myencmeth = DHCWebD_GetObjValue("ReadSecEnvrypt");
	if (myencmeth != "") {
		var myPAPMINo = DHCWebD_GetObjValue("PatientID");
		mySecrityNo = cspRunServerMethod(myencmeth, myPAPMINo);
	} else {
		alert("Read Err!");
		return "-1^";
	}
	///Write Card First
	if (mySecrityNo != "") {
		//var rtn = DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,mySecrityNo)
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		//var rtn = DHCACC_WrtMagCard("23", myCardNo, mySecrityNo);
		var rtn = DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
		window.status = "";
		if (rtn != "0") {
			alert(t[2014]);
			return "-1^"
		}
	} else {
		return "-1^";
	}
	return "0^" + mySecrityNo;
}

function ReadMagCard_Click() {
	var myVersion = DHCWebD_GetObjValue("DHCVersion");
	if (myVersion == "12") {
		M1Card_InitPassWord();
	}
	window.status = t[2007];
	var rtn = DHCACC_ReadMagCard(m_CCMRowID);
	var myary = rtn.split("^");
	if (myary[0] == '-5') {
		window.status = t[2008];
		return;
	}
	window.status = "";
	if (myary[0] == "0") {
		//Add Check Card No DHCACC_GetPAPMINo
		var myVersion = DHCWebD_GetObjValue("DHCVersion");
		if (myVersion == "12") {
			var myCardStat = DHCACC_GetAccInfoFNoCard(myary[1], myary[2]);
			var myStatAry = myCardStat.split("^");
			if (myStatAry[0] == "0") {
				alert(t["EntCardtip"]);
				DHCWeb_DisBtnA("RActAccount");
				return;
			} else {
				var obj = document.getElementById("RActAccount");
				if (obj) {
					DHCWeb_AvailabilityBtnA(obj, RActAccount_OnClick);
				}
			}
		}
		
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		DHCWebD_SetObjValueB("SecurityNo", myary[2]);
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
	//SetACRefOEOrder("");
	//SetACRefPayList("");
	//SetACRefOrder("");
}

function ReceipNO_OnKeyPress() {
	var key = event.keyCode;
	//var obj = websys_getSrcElement(e);
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	if ((myReceipNO != "") && (key == 13)) {
		var myUser = session['LOGON.USERID'];
		var encmeth = DHCWebD_GetObjValue("ReadINVByNoEncrypt");
		var myrtn = cspRunServerMethod(encmeth, myReceipNO, myUser);
		var rtn = myrtn.split("^")[0];
		if (rtn != "0") {
			alert(t['06']);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		} else {
			WrtRefundMain(myrtn);
			var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
			//SetACRefPayList(myAPIRowID);
			//SetACRefOEOrder(myAPIRowID);
		}
	}
}

function SetACRefundMain() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCallBackFINV";
	location.href = lnk;
}

function SetACRefPayList(APIRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.PayList&APIRowID=" + APIRowID;
	var PayList = parent.frames["UDHCACRefund_PayList"];
	PayList.location.href = lnk;
}

function SetACRefOEOrder(APIRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.OEOrder&APIRowID=" + APIRowID;
	var ACOEList = parent.frames["UDHCACRefund_OEOrder"];
	ACOEList.location.href = lnk;
}

function SetACRefOrder(ReceipRowid) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipRowid;
	var PayOrdList = parent.frames["udhcOPRefund_Order"];
	PayOrdList.location.href = lnk;
}

function IntDocument() {
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
}

function WrtRefundMain(AccINVInfo) {
	// Write Info For Main For
	var myary = AccINVInfo.split("^");
	DHCWebD_SetObjValueB("ReceipNO", myary[1]);
	DHCWebD_SetObjValueB("PatientID", myary[2]);
	DHCWebD_SetObjValueB("PatientName", myary[3]);
	DHCWebD_SetObjValueB("PatientSex", myary[4]);
	DHCWebD_SetObjValueB("INVSum", myary[5]);
	var myBtnFlag = myary[6];
	//DHCWebD_SetObjValueB("",);
	DHCWebD_SetObjValueB("AccNo", myary[7]);
	DHCWebD_SetObjValueB("AccLeft", myary[8]);
	DHCWebD_SetObjValueB("AccRowID", myary[9]);
	DHCWebD_SetObjValueB("AccStatus", myary[10]);
	var obj = document.getElementById("RefundPayMode");
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
	}
	DHCWebD_SetObjValueB("YBPaySum", myary[12]);
	DHCWebD_SetObjValueB("AccStatDesc", myary[13]);
	DHCWebD_SetObjValueB("OldAccPayINVRowID", myary[14]);
	DHCWebD_SetObjValueB("PatSelfPay", myary[16]);
	DHCWebD_SetObjValueB("INSDivDR", myary[17]);
	DHCWebD_SetObjValueB("PAPMIRowID", myary[19]);
	DHCWeb_DisBtnA("RActAccount");
	if (myary[15] != "N") {
		alert(t[myary[15] + "01"]);
		return;
	}
	//Check Account Status
	if (myary[10] != "F") {
		//foot
		DHCWeb_DisBtnA("RActAccount");
		alert(t["AccNoFootTip"]);
		return;
	}
	//check
	if (myary[18] == "N") {
		//foot
		DHCWeb_DisBtnA("RActAccount");
		alert(t["AccConfTip"]);
		return;
	}
	var myoptval = combo_CardType.getSelectedValue();
	var myCardTypeary = myoptval.split("^");
	var myReadCardMode = myCardTypeary[16];
	if (myary[20] == "Y") {
		DHCWebD_SetObjValueB("CardRowID", myary[22]);
		DHCWebD_SetObjValueB("CardNo", myary[23]);
		combo_CardType.setComboValue(myary[21]);
		var myoptval = combo_CardType.getSelectedValue();
		var myCardTypeary = myoptval.split("^");
		var myReadCardMode = myCardTypeary[16];
		if (myReadCardMode == "Handle") {
			//DHCWeb_setfocus("CardNo");
			var myobj = document.getElementById("CardNo");
			if (myobj) {
				myobj.disabled = true;
			}
		} else {
			DHCWeb_DisBtnA("ReadCard");
		}

		alert("患者有卡,直接办理帐户激活,不用重新分配卡,如果卡丢失请办理补卡后,再激活账户");
	} else {
		if (myReadCardMode == "Handle") {
			DHCWeb_setfocus("CardNo");
		} else {
			var obj = document.getElementById("ReadCard");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, ReadMagCard_Click);
			}
		}
	}
	var obj = document.getElementById("RActAccount");
	if (obj) {
		DHCWeb_AvailabilityBtnA(obj, RActAccount_OnClick);
	}
}

function M1Card_InitPassWord() {
	try {
		var myobj = document.getElementById("ClsM1Card");
		if (!myobj) {
			return;
		}
		var rtn = myobj.M1Card_Init();
	} catch (e) {
	}
}

function CardNo_OnKeyPress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = FormatCardNo();
		DHCWebD_SetObjValueB("CardNo", cardNo);
		DHCWeb_setfocus("RActAccount");
	}
}

document.body.onload = BodyLoadHandler;
