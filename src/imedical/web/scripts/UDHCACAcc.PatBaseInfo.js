///UDHCACAcc.PatBaseInfo.js

var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_CardAccountRelation = "";

function BodyLoadHandler() {
	var obj = document.getElementById("PAPMINo");
	if (obj) {
		obj.onkeypress = PAPMINo_KeyPress;
	}
	
	var obj = document.getElementById("ReadCard");
	if (obj) {
		obj.onclick = ReadHFMagCard_Click;
	}

	var obj = document.getElementById("ClearWin");
	if (obj) {
		obj.onclick = ClearWin_Click;
	}

	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeypress = CardNo_KeyPress;
	}

	var obj = document.getElementById("InsType");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.disabled = true;
	}
	DHCWebD_SetObjValueB("SelAll", true);
	var obj = document.getElementById("SelAll");
	if (obj) {
		obj.onclick = SelAll_OnClick;
	}

	///modfiy 2014-12-01 集中打印发票区分是否调用过医保接口
	var obj = document.getElementById("GHFlag");
	if (obj) {
		//obj.onclick = SetSel_OnClick;
	}
	//
	document.onkeydown = Doc_OnKeyDown;

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

	DHCWeb_setfocus("ReadCard");
}

function IntDocument() {
	DHCWebD_ClearAllListA("InsType");
	var encmeth = DHCWebD_GetObjValue("ReadPatTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "InsType");
	}
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

	var obj = document.getElementById("CancleSum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("YBTPaySum");
	if (obj) {
		obj.readOnly = true;
	}
	combo_CardTypeKeydownHandler();
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
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	m_CardAccountRelation = myary[24];
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
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

function Doc_OnKeyDown() {
	if ((event.altKey) && ((event.keyCode == 82) || (event.keyCode == 114))) {
		//Alt+R
		document.onkeydown = function () {
			return false;
		}
		DHCWeb_DisBtnA("ReadCard");
		ReadHFMagCard_Click();
		var obj = document.getElementById("ReadCard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
		document.onkeydown = Doc_OnKeyDown;
	}
}

function SelAll_OnClick() {
	var myvalue = DHCWebD_GetObjValue("SelAll");
	var Prtobj = parent.frames['UDHCACAcc_PatPayList'];
	var mywin = Prtobj.window;
	mywin.SelectAll(myvalue);
}

function CardNo_KeyPress() {
	var key = event.keyCode;
	if (key == 13) {
		var CardNo = FormatCardNo();
		if (CardNo == "") {
			return;
		}
		DHCWebD_SetObjValueB("CardNo", CardNo);
		//
		var mySecurityNo = "";
		if((m_CardAccountRelation == "CA") || (m_CardAccountRelation == "CL")){
			var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, CardNo, mySecurityNo, "");
		}else{
			var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, CardNo, mySecurityNo, "PatInfo");
		}
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn + "^" + myCardNo + "^" + myCheckNo + "^" + myLeftM + "^" + myPAPMI + "^" + myPAPMNo;
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("SecurityNo", myary[2]);
			DHCWebD_SetObjValueB("PAPMINo", myary[5]);
			ReadPatAccInfo();
			//Account Can Pay
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("PAPMINo", myary[5]);
			ReadPatInfo();   //+2017-05-27 ZhYW 账户无效时,通过登记号查询
			break;
		default:
			//alert("");
		}
	}
}

function ClearWin_Click() {
	var obj = document.getElementById("AccRowID");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("PAPMIRowID");
	if (obj) {
		obj.value = "";
	}
	PatAccInfoClr();
	RefreshDoc();
	//PatPayINVPrtForPrt("", "");
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = combo_CardType.getSelectedValue();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
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
}

function ReadPatAccInfo() {
	var PAPMINo = DHCWebD_GetObjValue("PAPMINo");
	var CardNo = DHCWebD_GetObjValue("CardNo");
	var SecurityNo = DHCWebD_GetObjValue("SecurityNo");
	var encmeth = DHCWebD_GetObjValue("ReadPAInfoEncrypt");
	var myrtn = (cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo));
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		WrtPatAccInfo(myrtn);
		var myrtn = CheckPRTFlag();
		if (!myrtn) {
			return;
		}
		RefreshDoc();
	} else {
		alert(t[myary[0]]);
	}
}

function WrtPatAccInfo(myPAInfo) {
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

	//var obj = document.getElementById("CredNo");
	//DHCWebD_SetListValueA(obj, myary[6]);

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
	var obj=document.getElementById("PAPMIRowID");
	DHCWebD_SetListValueA(obj,myary[19]);

	var myPatType = myary[16];
	var mylen = 0;
	var myobj = document.getElementById("InsType");
	if (myobj) {
		mylen = myobj.options.length;
		for (var i = 0; i < mylen; i++) {
			var myary = myobj.options[i].value.split("^");
			if (myPatType == myary[0]) {
				myobj.options.selectedIndex = i;
				break;
			}
		}

	}

}

function CheckPRTFlag() {
	//Add Left Check
	var myLeft = DHCWebD_GetObjValue("AccLeft");
	if (isNaN(myLeft)) {
		myLeft = 0;
	}
	var myLeftBalance = parseFloat(myLeft);
	if (+myLeftBalance < 0) {
		alert(t["DepPTip"]);
		return false;
	}
	return true;
}

function RefreshDoc() {
	DelServerTMP();
	var myFrameFlag = DHCWebD_GetObjValue("FrameFlag");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	switch (myFrameFlag) {
	case "ColPrt":
		//var PLFrame = parent.
		AccPayListForPrt(myAccRowID);
		PatPayINVPrtForPrt(myAccRowID, "");
		break;
	case "Foot":
		AccPrePayListForFoot(myAccRowID);
		AccManFootForFoot(myAccRowID);
		break;
	}
}

function AccPayListForPrt(AccRowID) {
	var myUnYBFlag = 0;
	var obj = document.getElementById("UnYBPatType");
	if (obj) {
		if (true == obj.checked) {
			myUnYBFlag = 1;
		}
	}
	//modify 2014-12-01 集中打印发票区分医保是否已结算
	var myGHFlag = 0;
	var obj = document.getElementById("GHFlag");
	if (obj) {
		if (true == obj.checked) {
			myGHFlag = 1;
		}
	}
	var myRegFlag = 0;
	var obj = document.getElementById("RegFlag");
	if (obj) {
		if (true == obj.checked) {
			myRegFlag = 1;
		}
	}

	var PAPMIRowID = document.getElementById("PAPMIRowID").value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPayList&AccRowID=" + AccRowID;
	lnk += "&INVPrtFlag=N" + "&INVFlag=N" + "&FUserDR=" + "&FootFlag=";
	lnk += "&FrameFlag=ColPrt";
	lnk += "&UnYBPatType=" + myUnYBFlag;
	lnk += "&PAPMIRowID=" + PAPMIRowID;
	lnk += "&GHFlag=" + myGHFlag;
	lnk += "&RegFlag=" + myRegFlag;     //modify 2014-12-01 集中打印发票区分医保是否已结算
	var plobj = parent.frames['UDHCACAcc_PatPayList'];
	plobj.location.href = lnk;
}

function PatPayINVPrtForPrt(AccRowID, PLRowIDStr) {
	var myUnYBFlag = 0;
	var obj = document.getElementById("UnYBPatType");
	if (obj) {
		if (true == obj.checked) {
			myUnYBFlag = 1;
		}
	}
	//modify 2014-12-01 集中打印发票区分医保是否已结算
	var myGHFlag = 0;
	var obj = document.getElementById("GHFlag");
	if (obj) {
		if (true == obj.checked) {
			myGHFlag = 1;
		}
	}
	var myRegFlag = 0;
	var obj = document.getElementById("RegFlag");
	if (obj) {
		if (true == obj.checked) {
			myRegFlag = 1;
		}
	}
	var PAPMIRowID = document.getElementById("PAPMIRowID").value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPayINVPrt&AccRowID=" + AccRowID + "&PLRowIDStr=";
	lnk += "&FrameFlag=ColPrt&PLRowIDStr=" + PLRowIDStr;
	lnk += "&UnYBPatType=" + myUnYBFlag;
	lnk += "&GHFlag=" + myGHFlag;     //modify 2014-12-01 集中打印发票区分医保是否已结算
	lnk += "&PAPMIRowID=" + PAPMIRowID;
	lnk += "&RegFlag=" + myRegFlag

	var Prtobj = parent.frames['UDHCACAcc_PatPayINVPrt'];
	Prtobj.location.href = lnk;
}

function AccPrePayListForFoot(AccRowID) {
	var lnk = "udhcopaccprepayinfo.csp?AccRowID=" + AccRowID;
	var plobj = parent.frames['udhcopaccprepayinfo'];
	plobj.location.href = lnk;
}

function AccManFootForFoot(AccRowID) {
	//DHCACAcc_FootManage
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.FootManage&AccRowID=" + AccRowID;
	var plobj = parent.frames['UDHCACAcc_FootManage'];
	plobj.location.href = lnk;

}

function PatAccInfoClr() {
	var myFrameFlag = DHCWebD_GetObjValue("FrameFlag");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatBaseInfo&FrameFlag=" + myFrameFlag;
	window.location.href = lnk;
}

function DelServerTMP() {
	var Prtobj = parent.frames["UDHCACAcc_PatPayINVPrt"];
	var mywin = Prtobj.window;
	mywin.DelServerTMP();
}

function SetSel_OnClick() {
	if (document.getElementById("GHFlag").checked) {
		document.getElementById("SelAll").checked = false;
		document.getElementById("SelAll").disabled = true;
	} else {
		document.getElementById("SelAll").checked = true;
		document.getElementById("SelAll").disabled = false;
	}
}

function PAPMINo_KeyPress(e) {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		ReadPatInfo();
	}
}

function ReadPatInfo() {
	var PatientID = document.getElementById("PAPMINo");
	if ((PatientID) && (PatientID.value != "")) {
		var PatNo = PatientID.value;
		var myExpStr = "";
		var PatDr = tkMakeServerCall("web.DHCOPCashierIF", "GetPAPMIByNo", PatNo, myExpStr);
		if (PatDr == "") {
			alert(t['RegNoError']);
			PatientID.className = 'clsInvalid';
			websys_setfocus('PAPMINo');
			return websys_cancel();
		} else {
			PatientID.className = 'clsvalid';
		}
		SetPatientDetail(PatDr);
	}
}

function SetPatientDetail(PatDr) {
	SetPatientInfo(PatDr);
	ReadAccFNoCard();
	RefreshDoc();
}

function SetPatientInfo(PatDr) {
	var myExpStr = "";
	var PatInfoStr = tkMakeServerCall("web.DHCOPCashierIF", "GetPatientByRowId", PatDr, myExpStr);
	var PatInfo = PatInfoStr.split("^");
	var papmi = PatInfo[0];
	var PatientNo = PatInfo[1];
	var patName = PatInfo[2];
	var patSex = PatInfo[3];
	var patAge = PatInfo[5];
	DHCWebD_SetObjValueC("PAPMIRowID", papmi);
	DHCWebD_SetObjValueC("PAPMINo", PatientNo);
	DHCWebD_SetObjValueC("PAName", patName);
	DHCWebD_SetObjValueC("PatSex", patSex);
	DHCWebD_SetObjValueC("PatAge", patAge);
	var myPatType = PatInfo[24];
	var mylen = 0;
	var myobj = document.getElementById("InsType");
	if (myobj) {
		mylen = myobj.options.length;
		for (var i = 0; i < mylen; i++) {
			var myary = myobj.options[i].value.split("^");
			if (myPatType == myary[0]) {
				myobj.options.selectedIndex = i;
				break;
			}
		}
	}
}

function ReadAccFNoCard() {
	//wangjian 2017-08-16
	var PatientID = document.getElementById("PAPMINo");	
	var myExpStr = "";
	var AccInfoStr = tkMakeServerCall("web.UDHCAccManageCLS", "GetAccByPAPMINo", PatientID.value, myExpStr);
	var myary = AccInfoStr.split("^");
	var obj = document.getElementById("AccRowID");
	DHCWebD_SetListValueA(obj, myary[1]);
}

document.body.onload = BodyLoadHandler;
