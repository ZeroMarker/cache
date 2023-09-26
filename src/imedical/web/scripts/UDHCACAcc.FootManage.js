/// UDHCACAcc.FootManage.js

///Foot For DHC_AccManager
var PrtXMLName = "";    //XML Stream Mode Name
var mPrtINVFlag = 1;    //Print Invoice Flag
var m_Version = "";     //Control
var m_YBConFlag = "0";  //default not Connection YB
var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_ReceiptsType = "";
var m_CardReclaim = "0";
var CardCostFlag = "";
var m_CardNoLength = 0;
var m_ReadCardMode = "";

function BodyLoadHandler() {
	var obj = document.getElementById("ReadCard");
	if (obj) {
		obj.onclick = ReadHFMagCard_Click;
	}
	var obj = document.getElementById("PayMode");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = PayMode_OnChange;
	}
	var obj = document.getElementById("Bank");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	var obj = document.getElementById("InsType");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	var obj = document.getElementById("Calculate");
	if (obj) {
		obj.onclick = Calculate_Click;
	}
	var obj = document.getElementById("ClearWin");
	if (obj) {
		obj.onclick = ClearWin_OnClick;
	}
	var obj = document.getElementById("PreDList");
	if (obj) {
		obj.onclick = PreDList_OnClick;
	}
	var obj = document.getElementById("APayList");
	if (obj) {
		obj.onclick = APayList_OnClick;
	}
	var obj = document.getElementById("UnPrtDetails");
	if (obj) {
		obj.onclick = UnPrtDetails_OnClick;
	}
	DHCWeb_DisBtnA("Foot");
	DHCWeb_DisBtnA("bRePrint");

	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeypress = CardNo_OnKeyPress;
	}

	var obj = document.getElementById("ReturnSum");
	if (obj) {
		obj.onkeypress = ReturnSum_OnKeyPress;
	}
	DHCWeb_DisBtnA("bPRTDetail");
	DHCWeb_DisBtnA("bParkPrint");

	var obj = document.getElementById("bParkPrint");
	if (obj) {
		DHCWeb_AvailabilityBtnA(obj, bParkPrint_OnClick);
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
	var obj = document.getElementById("hometel");
	if (obj) {
		obj.readOnly = true;
	}

	GetCurrentRecNo();
	IntDoc();
	
	document.onkeydown = Doc_OnKeyDown;

	websys_setfocus("CardNo");
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
	//var CardTypeValue = DHCC_GetElementData("CardType");
	var CardTypeValue = combo_CardType.getActualValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId() {
	var CardEqRowId = "";
	//var CardTypeValue = DHCC_GetElementData("CardType");
	var CardTypeValue = combo_CardType.getActualValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardEqRowId = CardTypeArr[14];
	}
	return CardEqRowId;
}

function GetCardNoLength() {
	var CardNoLength = "";
	//var CardTypeValue = DHCC_GetElementData("CardType");
	var CardTypeValue = combo_CardType.getActualValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardNoLength = CardTypeArr[17];
	}
	
	return CardNoLength;
}

function FormatCardNo() {
	var CardNo = DHCC_GetElementData("CardNo");
	if (CardNo != '') {
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
	//var myoptval = combo_CardType.getActualValue();
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	m_ReadCardMode = myary[16];
	m_CardNoLength = myary[17]; //该卡类型定义的卡号长度
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
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");
	} else {
		DHCWeb_setfocus("ReadCard");
	}
	if (combo_CardType) {
		websys_nexttab(combo_CardType.tabIndex);
	}
}

function LoadDOCXML() {
	var myPrtXMLName = "";
	var mygLoc = session['LOGON.GROUPID'];
	///Load Base Config
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
	if (myPrtXMLName == "") {
		return;
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); //INVPrtFlag
}

function PayMode_OnChange() {
	var obj = document.getElementById("PayMode");
	if (obj) {
		if (obj.options.length == 0) {
			return;
		}
		var myIdx = obj.options.selectedIndex;
		if (myIdx == -1) {
			return;
		}
		var myary = obj.options[myIdx].value.split("^");
		if (myary[1] == "1") {
			SetPayInfoStatus(false);
		} else {
			SetPayInfoStatus(true);
		}
	}
}

function bPRTDetail_OnClick() {
	var myPrtXMLName = "";
	var myVersion = DHCWebD_GetObjValue("DHCVersion");
	switch (myVersion) {
	case "12":
		myPrtXMLName = "JSTOPCColPRTDetails";
		break;
	default:

	}
	if (myPrtXMLName != "") {
		PrtXMLName = myPrtXMLName;
		DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); ///INVPrtFlag
		var myACINVStr = DHCWebD_GetObjValue("APINVStr");
		BillPrintNew(myACINVStr);
	}
	LoadDOCXML();
}

function bRePrint_OnClick() {
	var myACINVStr = DHCWebD_GetObjValue("APINVStr");
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName); ///INVPrtFlag
	BillPrintNew(myACINVStr);
	DHCWeb_DisBtnA("bRePrint");
}

function bParkPrint_OnClick() {
	RefundSaveInfo("A");
	//DHCWeb_DisBtnA("bParkPrint");
}

function RefundSaveInfo(RefundFlag) {
	var mygLoc = session['LOGON.GROUPID'];
	//Load Base Config
	var encmeth = DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		mPrtINVFlag = myary[4];
		var myPrtXMLName = myary[11];
	}

	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); //INVPrtFlag
	var myACINVStr = DHCWebD_GetObjValue("APINVStr");
	var INVtmp = myACINVStr.split("^");
	for (var i = 0; i < INVtmp.length; i++) {
		var myAPIRowID = INVtmp[i];
		if (myAPIRowID != "") {
			break;
		}
	}
	//PrtStr
	var myUser = session['LOGON.USERID'];
	if (myAPIRowID == "") {
		return;
	}
	var encmeth = DHCWebD_GetObjValue("BuildOrdStr");
	var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, myUser, "");
	var mytmpary = rtnvalue.split(String.fromCharCode(5));
	var myAPIRowID = mytmpary[1];
	var PrtStr = mytmpary[2];
	var m_RebillFlag = 1;
	//var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	if (myAPIRowID == "") {
		return;
	}
	//RefundFlag
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
	var myExpStr = "";
	var encmeth = DHCWebD_GetObjValue("SaveParkDataEncrypt");
	//INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	//alert(myAPIRowID+","+PrtStr+","+myUser+","+ RefundFlag+","+ gloc+","+ myUserLocID+","+ myPayModeDR+","+ myRefPaySum+","+ m_RebillFlag+","+ myExpStr);
	if (encmeth != "") {
		var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, PrtStr, myUser, RefundFlag, gloc, myUserLocID, myPayModeDR, myRefPaySum, m_RebillFlag, myExpStr);
		var myary = rtnvalue.split(String.fromCharCode(2));
		var rtn = myary[0].split("^");
		//alert(rtn);
		if (rtn[0] == '0') {
			//Set CID  for  YB
			DHCWebD_SetObjValueB("CID", myary[2]);
			//var mystr = YBInsDiv();
			DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
			BillPrintNew(myary[1]);
			//var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
			//alert(mystr+ t['ParkOK']+myRefPaySum+t["ParkYMB"]);
			return true;
		} else {
			switch (rtn[0]) {
			case 109:
				alert(t['08']);
			default:
				alert("补打失败:" + rtn[0]);
			}
			return false;
		}
	}
}

function CardNo_OnKeyPress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardNo, mySecurityNo, "");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var obj = document.getElementById("PAPMINo");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			DHCWebD_SetListValueA(obj, myary[1]);
			var obj = document.getElementById("SecurityNo");
			DHCWebD_SetListValueA(obj, myary[2]);
			ReadPatAccInfo();
			GetCardFareCost(m_SelectCardTypeRowID, myary[1]);
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			alert(t["-201"]);
			break;
		default:
			//alert("");
		}
	}
}

function Foot_OnClick() {
	DHCWeb_DisBtnA("Foot");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	if (myAccRowID == "") {
		alert("账户不存在,请读卡重试.");
		return;
	}
	var rtn = CheckFoot();
	if (!rtn) {
		var obj = document.getElementById("Foot");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Foot_OnClick);
		}
		return;
	}
	var apinum = tkMakeServerCall("web.UDHCAccPrtPayFoot", "CheckUnPrintINV", myAccRowID);
	if (+apinum > 0) {
		var myrtn = window.confirm("存在未打印发票,请确认纸质发票已放好并打印.");
		if (!myrtn) {
			var obj = document.getElementById("Foot");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, Foot_OnClick);
			}
			return;
		}
	}
	//Foot
	var myUserDR = session['LOGON.USERID'];
	var myCTLocDr = session['LOGON.CTLOCID'];
	var myHospDr = session['LOGON.HOSPID'];
	var myBadPrice = DHCWebD_GetObjValue("BadPrice");
	var myPDInfo = BuildPDInfo();
	var myPDPMInfo = BuildPDMInfo();
	var myCardRowID = DHCWebD_GetObjValue("CardFRowID");
	var myExpStr = myCardRowID + "^" + session['LOGON.GROUPID'] + "^" + m_CardReclaim + "^" + myCTLocDr + "^" + myHospDr;
	var encmeth = DHCWebD_GetObjValue("FootEncrypt");
	//alert(myAccRowID+","+myUserDR+","+myBadPrice+","+myPDInfo+","+myPDPMInfo+","+myExpStr);
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, myAccRowID, myUserDR, myBadPrice, myPDInfo, myPDPMInfo, myExpStr);
	}
	//alert("myrtn=" + myrtn);
	//Print
	var myary = myrtn.split(String.fromCharCode(2));
	//alert("myary="+myary+", "+m_CardReclaim+", "+myary.length);
	if (myary[0] == "0") {
		//print DHC_AccINVPay
		//Print Patient Pay List and PreDeposit List
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName); //INVPrtFlag
		BillPrintNew(myary[1]);
		if (myary.length > 2) {
			if (myary[2] != "") {
				CardCostFlag = "";
				PatRegPatInfoPrint(myary[2], "UDHCAccDeposit", "ReadAccDPEncrypt");
			}
		}
		if (myary.length > 3) {
			if ((m_CardReclaim == "1") && (myary[3] != "")) {
				CardCostFlag = "Y";
				PatRegPatInfoPrint(myary[3], "UDHCCardInvPrt", "ReadAccCarDPEncrypt");
			}
		}
		var obj = document.getElementById("bPRTDetail");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, bPRTDetail_OnClick);
		}

		var obj = document.getElementById("bRePrint");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, bRePrint_OnClick);
		}

		var obj = document.getElementById("bParkPrint");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, bParkPrint_OnClick);
		}

		var obj = document.getElementById("APINVStr");
		if (obj) {
			obj.value = myary[1];
		}
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName); //INVPrtFlag
		alert(t["FootOK"]);
	} else {
		alert("结算失败, 错误代码:" + myary[0]);
		var obj = document.getElementById("Foot");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Foot_OnClick);
		}
	}
}

function ReturnSum_OnKeyPress() {
	DHCWeb_SetLimitFloat();
}

function UnPrtDetails_OnClick() {
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	AccUnPrtDetails(myAccRowID);
}

function ClearWin_OnClick() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.FootManage";
	window.location.href = lnk;
}

function PreDList_OnClick() {
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	AccPreList(myAccRowID);
}

function APayList_OnClick() {
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	AccPayList(myAccRowID);
}

function IntDoc() {
	//Load SS_Group Pay Mode
	DHCWebD_ClearAllListA("PayMode");
	var encmeth = DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc = session['LOGON.GROUPID'];
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayMode", mygLoc);
	}
	//Load Bank Name
	DHCWebD_ClearAllListA("Bank");
	var encmeth = DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "Bank");
	}
	//Load Pay Type
	DHCWebD_ClearAllListA("FootType");
	var encmeth = DHCWebD_GetObjValue("ReadPMTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "FootType");
	}
	//ReadPatTypeEncrypt
	DHCWebD_ClearAllListA("InsType");
	var encmeth = DHCWebD_GetObjValue("ReadPatTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "InsType");
	}

	//FootType
	var obj = document.getElementById("FootType");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}

	//YBCardAccPay
	var obj = document.getElementById("YBCardAccPay");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("YBTCPaySum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("YBBAPaySum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("PaySum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("PreDepSum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("BadPrice");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("ReturnSum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("CancleSum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("YBTPaySum");
	if (obj) {
		obj.readOnly = true;
	}

	GetReceiptNo();

	PayMode_OnChange();

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
		//Get PrtXMLName
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

	if (m_YBConFlag == "1") {}
	combo_CardTypeKeydownHandler();
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = combo_CardType.getSelectedValue(); //DHCACC_GetAccInfo
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		var obj = document.getElementById("PAPMINo");
		obj.value = myary[5];
		var obj = document.getElementById("CardNo");
		DHCWebD_SetListValueA(obj, myary[1]);
		var obj = document.getElementById("SecurityNo");
		DHCWebD_SetListValueA(obj, myary[2]);
		ReadPatAccInfo();
		GetCardFareCost(m_SelectCardTypeRowID, myary[1]);
		//Account Can Pay
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		alert(t[rtn]);
		break;
	default:
		//alert("");
	}

	GetReceiptNo();
}

function CheckFoot() {
	///1  Check  Pay Mode
	///2  Check have Bad Price????  if have confirm() to Oper
	///3.
	var rtn = true;
	var mytrue = confirm(t["CardReclaim"]);
	if (mytrue) {
		m_CardReclaim = "1";
	} else {
		m_CardReclaim = "0";
	}
	var myPayMode = DHCWeb_GetListBoxValue("PayMode");
	var myary = myPayMode.split("^");
	if (myary[1] == "1") {
		///check
		var myCardChequeNo = DHCWebD_GetObjValue("CardChequeNo");
		var myBank = DHCWebD_GetObjValue("Bank");
		if (myCardChequeNo == "") {
			alert(t["ReqCheque"]);
			websys_setfocus("CardChequeNo");
			return false;
		}
		if (myBank == "") {
			alert(t["ReqBank"]);
			websys_setfocus("Bank");
			return false;
		}
	} else {}

	//check if have BadPrice
	var myAccLeft = DHCWebD_GetObjValue("AccLeft");
	if (isNaN(myAccLeft)) {
		myAccLeft = 0;
	}
	var myReturnSum = DHCWebD_GetObjValue("ReturnSum");
	if (isNaN(myReturnSum)) {
		myReturnSum = 0;
	}

	myAccLeft = parseFloat(myAccLeft);
	myAccLeft = myAccLeft.toFixed(2);
	myReturnSum = parseFloat(myReturnSum);
	myReturnSum = myReturnSum.toFixed(2);

	if (myReturnSum != myAccLeft) {
		var myrtn = confirm(t["BadPTip"]);
		rtn = myrtn;
	}

	if (rtn) {
		var myencrypt = DHCWebD_GetObjValue("MTransEncrypt");
		if (myencrypt != "") {
			if (myReturnSum < 0) {
				var myAmt = -myReturnSum;
			} else {
				var myAmt = myReturnSum;
			}
			if (isNaN(myAmt)) {
				myAmt = 0;
			}
			var myCardFareCost = DHCWebD_GetObjValue("CardFareCost");

			if ((isNaN(+myCardFareCost)) || (myCardFareCost == "")) {
				myCardFareCost = 0;
			}
			if (m_CardReclaim == "1") {
				myAmt = parseFloat(myAmt) + parseFloat(myCardFareCost);
				myAmt = myAmt.toFixed(2);
			}

			var myRMB = cspRunServerMethod(myencrypt, myAmt);
			myAmt = myAmt.toString();
			var ReceiptsNo = DHCWebD_GetObjValue("ReceiptsNo");
			if ((myAmt != "") && (myAmt != "0") && (ReceiptsNo == "") && (m_ReceiptsType != "")) {
				alert(t[2072]);
				return false;
			}
			///myAmt = myAmt.toFixed(2);
			if (myReturnSum < 0) {
				var myrtn = confirm(t['GetSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
			} else {
				if (m_CardReclaim == "1") {
					var myrtn = confirm(t['RefSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"] + String.fromCharCode(10) + String.fromCharCode(13) + t["RefCardFareCost"] + myCardFareCost);
				} else {
					var myrtn = confirm(t['RefSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
				}
			}
			rtn = myrtn;
		}
	}
	return rtn;
}

function BuildPDInfo() {
	var myHospDr = session['LOGON.HOSPID'];
	var myary = new Array;
	var myInfo = "";
	//PDInfo = amt_"^"_PDType_"^"_user_"^"_BillNum_"^"_BackReason
	myary[0] = DHCWebD_GetObjValue("ReturnSum");
	if (isNaN(myary[0])) {
		myary[0] = 0;
	}
	var myPayType = DHCWeb_GetListBoxValue("FootType");
	if (myPayType == "R") {
		myary[0] = -parseFloat(myary[0]);
	} else {
		myary[0] = -parseFloat(myary[0]);
	}
	myary[1] = "F";
	myary[2] = session['LOGON.USERID'];
	myary[3] = "";
	myary[4] = "账户结算退款";
	myary[5] = myHospDr;
	myInfo = myary.join("^");
	return myInfo;
}

function BuildPDMInfo() {
	//PDPMInfo = PayModeDR_"^"_CardDR_"^"_ChequeNO_"^"_CMBankDR_"^"_Branch
	//_"^"_Amt_"^"_PayAccNO_"^"_ChequeDat_"^"_Remark
	var myInfo = "";
	var myary = new Array;
	var myPMInfo = DHCWeb_GetListBoxValue("PayMode");
	var myPMAry = myPMInfo.split("^");
	//if (myary[1] == "1"){
	myary[0] = myPMAry[0];
	myary[1] = "";
	myary[5] = DHCWebD_GetObjValue("ReturnSum");
	if (isNaN(myary[5])) {
		myary[5] = 0;
	}
	var myPayType = DHCWeb_GetListBoxValue("FootType");
	if (myPayType == "R") {
		myary[5] = -parseFloat(myary[5]);
	} else {
		myary[5] = -parseFloat(myary[5]);
	}
	if (myPMAry[1] == "1") {
		myary[2] = DHCWebD_GetObjValue("CardChequeNo");
		var myBankInfo = DHCWeb_GetListBoxValue("Bank");
		myary[3] = myBankInfo.split("^")[0];
		myary[4] = DHCWebD_GetObjValue("PayUnit");
		myary[6] = DHCWebD_GetObjValue("PayAccNO");
		myary[7] = DHCWebD_GetObjValue("ChequeDate");
		myary[8] = DHCWebD_GetObjValue("Note");
	} else {
		myary[2] = "";
		myary[3] = "";
		myary[4] = "";
		myary[6] = "";
		myary[7] = "";
		myary[8] = "";
	}
	myInfo = myary.join("^");

	return myInfo;
}

function AccPreList(AccRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPreList&AccountID=" + AccRowID;
	var NewWin = open(lnk, "UDHCACAcc_PatPreList", "scrollbars=yes,resizable=yes,top=50,left=50,width=950,height=600");
}

function AccPayList(AccRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPayList&AccRowID=" + AccRowID;
	var NewWin = open(lnk, "UDHCACAcc_PatPayList", "scrollbars=yes,resizable=yes,top=50,left=50,width=950,height=600");
}

function AccUnPrtDetails(AccRowID) {
	var lnk = "udhcunprtdetails.csp?AccRowID=" + AccRowID;
	lnk += "&FrameFlag=ColPrt";
	var NewWin = open(lnk, "udhcunprtdetails", "scrollbars=yes,resizable=yes,top=50,left=50,width=950,height=600");
}

function ReadPatAccInfo() {
	var PAPMINo = DHCWebD_GetObjValue("PAPMINo");
	var CardNo = DHCWebD_GetObjValue("CardNo");
	var SecurityNo = DHCWebD_GetObjValue("SecurityNo");
	var encmeth = DHCWebD_GetObjValue("ReadPAInfoEncrypt");
	var myrtn = (cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo));
	//alert(myrtn);
	var myary = myrtn.split("^");
	if (myary[0] == "0") {
		var myrtn = WrtPatAccInfo(myrtn);
		if (!myrtn) {
			return;
		}
		CheckPType();
		FootOperTip();
		CheckCheque();
		var obj = document.getElementById("Foot");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Foot_OnClick);
		}
	} else {
		alert(t[myary[0]]);
	}
}

function CheckCheque() {
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var encmeth = DHCWebD_GetObjValue("CheckCheque");
	if (encmeth == "") {
		return;
	}
	var myrtn = cspRunServerMethod(encmeth, myAccRowID);
	if (myrtn == "true") {
		alert(t["HaveChequePayMode"]);
		return;
	}

}
function CheckPType() {
	var rtn = true;
	try {
		var myPreDepSum = DHCWebD_GetObjValue("PreDepSum");
		var myPaySum = DHCWebD_GetObjValue("PaySum");
		var myAccLeft = DHCWebD_GetObjValue("AccLeft");
		if (isNaN(myPreDepSum)) {
			myPreDepSum = 0;
		}
		if (isNaN(myPaySum)) {
			myPaySum = 0;
		}
		if (isNaN(myAccLeft)) {
			myAccLeft = 0;
		}
		myPreDepSum = parseFloat(myPreDepSum);
		myPreDepSum = myPreDepSum.toFixed(2);
		myPaySum = parseFloat(myPaySum);
		myPaySum = myPaySum.toFixed(2);
		myAccLeft = parseFloat(myAccLeft);
		myAccLeft = myAccLeft.toFixed(2);
		var mytmpsum = (myPreDepSum - myPaySum).toFixed(2);
		if (mytmpsum != myAccLeft) {
			alert(t["ErrLeft"]);
			return false;
		}
		var obj = document.getElementById("FootType");
		var reobj = document.getElementById("ReturnSum");
		obj.disabled = true;
		if (myAccLeft >= 0) {
			obj.selectedIndex = 1;
			reobj.readOnly = true;
		} else {
			obj.selectedIndex = 0;
			reobj.readOnly = true;
		}
		reobj.value = myAccLeft.toString();
	} catch (e) {
		alert(e.message);
	}
}

function GetCurrentRecNo() {
	var p1 = session['LOGON.USERID'];
	var p2 = "D";
	var encmeth = DHCWebD_GetObjValue("GetCurrentRecNoClass");
	var ren = cspRunServerMethod(encmeth, p1, p2);
	var myary = ren.split("^");
	if (myary.length > 5) {
		m_ReceiptsType = myary[5];
	}
	if (myary[0] == '0') {
		var ReceiptsNoobj = document.getElementById("ReceiptsNo");
		if (ReceiptsNoobj)
			ReceiptsNoobj.value = myary[3];
	} else {
		alert(t[2072]);
	}
}

function GetReceiptNo() {
	var encmeth = DHCWebD_GetObjValue("GetreceipNO");
	var myPINVFlag = "Y";
	var Guser = session['LOGON.USERID'];
	var myExpStr = Guser + "^" + myPINVFlag;
	if (cspRunServerMethod(encmeth, 'SetReceipNO', '', myExpStr) != '0') {
		alert(t['05']);
		return;
	}
}

function SetReceipNO(value) {
	var myary = value.split("^");
	var ls_ReceipNo = myary[0];
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.value = ls_ReceipNo;
	}
	if (myary[1] != "0") {
		obj.className = 'clsInvalid';
	}
}

function SetReceipNOOld(value) {
	var ls_ReceipNo = value;
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.value = ls_ReceipNo;
	}
}

function Calculate_Click() {
	FootExpCalculate();
}

function FootExpCalculate() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	var NewWin = open(lnk, "udhcOPCashExpCal", "scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}

function SetPayInfoStatus(SFlag) {
	var obj = document.getElementById("CardChequeNo");
	if (obj) {
		obj.disabled = SFlag;
	}
	var obj = document.getElementById("Bank");
	if (obj) {
		obj.disabled = SFlag;
	}
	var obj = document.getElementById("ChequeDate");
	if (obj) {
		obj.disabled = SFlag;
	}
	var obj = document.getElementById("PayUnit");
	if (obj) {
		obj.disabled = SFlag;
	}
	var obj = document.getElementById("PayAccNO");
	if (obj) {
		obj.disabled = SFlag;
	}
	var obj = document.getElementById("Note");
	if (obj) {
		obj.disabled = SFlag;
	}
}

function WrtPatAccInfo(myPAInfo) {
	//s myPAInfo=rtn_"^"_myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	//s myPAInfo=myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	//s myPAInfo=myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	//s myPAInfo=myPAInfo_"^"_myAccRowID
	//myPDSum_"^"_myPLSum

	var myrtn = true;
	var myary = myPAInfo.split("^");
	///alert(myary);

	DHCWebD_SetObjValueB("PAPMINo", myary[1]);

	DHCWebD_SetObjValueB("PAName", myary[2]);

	DHCWebD_SetObjValueB("PatSex", myary[3]);

	DHCWebD_SetObjValueB("PatAge", myary[4]);

	DHCWebD_SetObjValueB("CredType", myary[5]);

	//DHCWebD_SetObjValueB("CredNo", myary[6]);

	DHCWebD_SetObjValueB("AccStatus", myary[8]);

	DHCWebD_SetObjValueB("AccLeft", myary[7]);

	DHCWebD_SetObjValueB("AccNo", myary[9]);

	DHCWebD_SetObjValueB("AccOCDate", myary[10]);

	DHCWebD_SetObjValueB("BadPrice", myary[11]);

	DHCWebD_SetObjValueB("AccDep", myary[12]);

	DHCWebD_SetObjValueB("AccRowID", myary[13]);

	DHCWebD_SetObjValueB("PreDepSum", myary[14]);

	DHCWebD_SetObjValueB("PaySum", myary[15]);

	DHCWebD_SetObjValueB("CardFRowID", myary[17]);

	DHCWebD_SetObjValueB("hometel", myary[20]);

	if (myary.length > 18) {
		if (myary[18] == "Y") {
			alert("此账户有未就诊的挂号记录,请确认是否需要退号,如果需要退号,请退号后再做账户结算");
		}
	}
	//Add Check for diffrent Version
	var myVersion = DHCWebD_GetObjValue("DHCVersion");
	switch (myVersion) {
	case "0":
		var myLeft = DHCWebD_GetObjValue("AccLeft");
		if (isNaN(myLeft)) {
			myLeft = 0;
		}
		myLeft = parseFloat(myLeft);
		if (myLeft < 0) {
			alert(t["PayMTip"]);
			myrtn = false;
		}
		break;
	default:
		break;
	}

	return myrtn;
}

function WrtPatAccInfoOld(myPAInfo) {
	//	s myPAInfo=rtn_"^"_myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	//s myPAInfo=myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	//s myPAInfo=myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	///s myPAInfo=myPAInfo_"^"_myAccRowID
	//myPDSum_"^"_myPLSum
	var myary = myPAInfo.split("^");
	var obj = document.getElementById("PAPMINo");
	DHCWebD_SetListValueA(obj, myary[1]);

	var obj = document.getElementById("PAName");
	DHCWebD_SetListValueA(obj, myary[2]);

	var obj = document.getElementById("PatSex");
	DHCWebD_SetListValueA(obj, myary[3]);

	var obj = document.getElementById("PatAge");
	DHCWebD_SetListValueA(obj, myary[4]);

	var obj = document.getElementById("CredType");
	DHCWebD_SetListValueA(obj, myary[5]);

	var obj = document.getElementById("CredNo");
	DHCWebD_SetListValueA(obj, myary[6]);

	var obj = document.getElementById("AccStatus");
	DHCWebD_SetListValueA(obj, myary[8]);

	var obj = document.getElementById("AccLeft");
	DHCWebD_SetListValueA(obj, myary[7]);

	var obj = document.getElementById("AccNo");
	DHCWebD_SetListValueA(obj, myary[9]);

	var obj = document.getElementById("AccOCDate");
	DHCWebD_SetListValueA(obj, myary[10]);

	var obj = document.getElementById("BadPrice");
	DHCWebD_SetListValueA(obj, myary[11]);

	var obj = document.getElementById("AccDep");
	DHCWebD_SetListValueA(obj, myary[12]);

	var obj = document.getElementById("AccRowID");
	DHCWebD_SetListValueA(obj, myary[13]);

	var obj = document.getElementById("PreDepSum");
	DHCWebD_SetListValueA(obj, myary[14]);

	var obj = document.getElementById("PaySum");
	DHCWebD_SetListValueA(obj, myary[15]);

}

function BillPrintNew(INVstr) {
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("ReadINVDataEncrypt");
			var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName) {
	///1, RowID String
	///2. CurPrtXMLName
	///3. Encrypt Item
	if (CurXMLName == "") {
		return;
	}
	var INVtmp = RowIDStr.split("^");
	if (INVtmp.length > 0) {
		DHCP_GetXMLConfig("InvPrintEncrypt", CurXMLName);
	}
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue(EncryptItemName);
			//var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myCarobj = document.getElementById("CardFareCost").value;
			if (CardCostFlag == "Y") {
				//var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",myCarobj,INVtmp[invi], Guser, myExpStr);
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCCardInvPrt2")
				var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", myCarobj, INVtmp[invi], Guser, myExpStr);
			} else {
				//var Printinfo = cspRunServerMethod(encmeth,"InvPrintNew",CurXMLName,INVtmp[invi], Guser, myExpStr);
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCAccDeposit2")
				var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", CurXMLName, INVtmp[invi], Guser, myExpStr);
			}
		}
	}
}

function FootOperTip() {
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var myEncrypt = DHCWebD_GetObjValue("FootAlTipEncrypt");
	var myExpStr = "";
	if (myEncrypt != "") {
		var myrtn = cspRunServerMethod(myEncrypt, myAccRowID, "Foot", myExpStr);
		var myary = myrtn.split("^");
		if (myary[0] == "1") {
			alert(myary[1]);
		}
	}
}

function GetCardFareCost(myCardTypeID, myCardNo) {
	var myobj = document.getElementById("CardFareCost");
	if (!myobj) {
		return;
	}
	var myEncrypt = DHCWebD_GetObjValue("GetCardFareCostEncrypt");
	if (myEncrypt != "") {
		var myrtn = cspRunServerMethod(myEncrypt, myCardTypeID, myCardNo);
		myobj.value = myrtn;
	}
}

function Doc_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 115) {
		//F4 读卡
		var obj = document.getElementById("ReadCard");
		if ((obj)&&(!obj.disabled)) {
			ReadHFMagCard_Click();
		}
	} else if (key == 118) {
		//F7 清屏
		ClearWin_OnClick();
	} else if (key == 120) {
		//F9 结算
		Foot_OnClick();
	}
	DHCWeb_EStopSpaceKey();
}

///格式化卡号
function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != "") {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

document.body.onload = BodyLoadHandler;
