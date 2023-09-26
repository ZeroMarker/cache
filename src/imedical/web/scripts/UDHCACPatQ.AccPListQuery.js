/// UDHCACPatQ.AccPListQuery.js

var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_CardNoLength = 0;
var m_ReadCardMode="";
var m_Hospital_DR=session['LOGON.HOSPID'];

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
		DHCWebD_SetObjValueC("CardNo", CardNo);
	}
	return CardNo;
}

function combo_CardTypeKeydownHandler() {
	//var myoptval=combo_CardType.getActualValue();
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

function BodyLoadHandler() {
	var obj = document.getElementById("ReadCard");
	if (obj) {
		obj.onclick = ReadHFMagCard_Click;
	}
	var obj = document.getElementById("Clear");
	if (obj) {
		obj.onclick = Clear_OnClick;
	}

	var obj = document.getElementById("CardNoA");
	if (obj) {
		obj.onkeydown = CardNoA_OnKeyDown;
	}
	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeydown = CardNo_OnKeyDown;
	}
	var obj = document.getElementById("Print");
	if (obj) {
		obj.onclick = Print_OnClick;
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
	combo_CardTypeKeydownHandler();
	ReadPatAccInfo();
}

function Print_OnClick() {
	
}

function CardNoA_OnKeyDown() {
	
	var mykey = event.keyCode;
	if (mykey != 13) {
		return;
	}
	var CardNo = DHCWebD_GetObjValue("CardNoA");
	if (CardNo == "") {
		return;
	}
	alert(1111);
	var encmeth = DHCWebD_GetObjValue("ReadSecEncrypt");
	var myrtn = (cspRunServerMethod(encmeth, CardNo));
	var myary = myrtn.split("^");
	alert(myrtn);
	if (myary[0] != "") {
		DHCWebD_SetObjValueC("SecurityNo", myary[0]);
		var SecurityNo = myary[0];
		var PAPMINo = myary[1];
		var encmeth = DHCWebD_GetObjValue("ReadPAInfoEncrypt");
		var myrtn = (cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo))
		var myary = myrtn.split("^");
		if (myary[0] == 0) {
			WrtPatAccInfo(myrtn);
			Find_click();   //Query_OnClick();
		} else {
			alert(t[myary[0]]);
			return;
		}
	}
}

function Query_OnClick() {
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var PAPMINo = DHCWebD_GetObjValue("PAPMINo");
	var CardNo = DHCWebD_GetObjValue("CardNo");
	if (CardNo == "") {
		var CardNo = DHCWebD_GetObjValue("CardNoA");
	}
	var SecurityNo = DHCWebD_GetObjValue("SecurityNo");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACPatQ.AccPListQuery&AccRowID=" + myAccRowID;
	lnk = lnk + "&CardNo=" + CardNo  + "&SecurityNo=" + SecurityNo;
	window.location.href = lnk;
}

function Clear_OnClick() {
	location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCACPatQ.AccPListQuery';
}

function ReadPatAccInfo() {
	var PAPMINo = DHCWebD_GetObjValue("PAPMINo");
	var CardNo = DHCWebD_GetObjValue("CardNo");
	if (CardNo == "") {
		var CardNo = DHCWebD_GetObjValue("CardNoA");
	}
	var SecurityNo = DHCWebD_GetObjValue("SecurityNo");
	if ((CardNo == "") && (SecurityNo == "")) {
		return;
	}
	var encmeth = DHCWebD_GetObjValue("ReadPAInfoEncrypt");
	
	var myrtn = (cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo));
	var myary = myrtn.split("^");

	if (myary[0] == 0) {
		WrtPatAccInfo(myrtn);
	} else {
		alert(t[myary[0]]);
	}
}

function ReadHFMagCard_Click() {
	var myoptval = combo_CardType.getSelectedValue();
	//var myrtn="0^000001036766^6450340771";
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myoptval);
	//var myrtn = DHCACC_GetAccInfo();
	//alert(myrtn);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		var obj = document.getElementById("PAPMINo");
		if (obj) {
			obj.value = myary[5];
		}
		//var obj = document.getElementById("CardNo");
		//DHCWebD_SetListValueA(obj,myary[1]);
		DHCWebD_SetObjValueC("CardNo", myary[1]);
		DHCWebD_SetObjValueC("CardNoA", myary[1]);
		//var obj = document.getElementById("SecurityNo");
		//DHCWebD_SetListValueA(obj,myary[2]);
		DHCWebD_SetObjValueC("SecurityNo", myary[2]);
		ReadPatAccInfo();
		Query_OnClick();
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

function WrtPatAccInfo(myPAInfo) {
	//s myPAInfo = rtn_"^"_myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	//s myPAInfo = myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	//s myPAInfo = myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	//s myPAInfo = myPAInfo_"^"_myAccRowID
	//myPDSum_"^"_myPLSum

	var myary = myPAInfo.split("^");
	//var obj = document.getElementById("PAPMINo");
	DHCWebD_SetObjValueC("PAPMINo", myary[1]);
	//DHCWebD_SetListValueA(obj, myary[1]);

	//var obj = document.getElementById("PAName");
	DHCWebD_SetObjValueC("PAName", myary[2]);
	//DHCWebD_SetListValueA(obj, myary[2]);

	//var obj = document.getElementById("PatSex");
	//DHCWebD_SetListValueA(obj, myary[3]);
	DHCWebD_SetObjValueC("PatSex", myary[3]);

	//var obj = document.getElementById("PatAge");
	//DHCWebD_SetListValueA(obj,myary[4]);
	DHCWebD_SetObjValueC("PatAge", myary[4]);
	
	DHCWebD_SetObjValueC("CredType", myary[5]);
	//var obj = document.getElementById("CredType");
	//DHCWebD_SetListValueA(obj, myary[5]);
	
	DHCWebD_SetObjValueC("CredNo", myary[6]);
	//var obj = document.getElementById("CredNo");
	//DHCWebD_SetListValueA(obj, myary[6]);

	DHCWebD_SetObjValueC("AccStatus", myary[8]);
	//var obj = document.getElementById("AccStatus");
	//DHCWebD_SetListValueA(obj, myary[8]);

	DHCWebD_SetObjValueC("AccLeft", myary[7]);
	//var obj = document.getElementById("AccLeft");
	//DHCWebD_SetListValueA(obj, myary[7]);

	DHCWebD_SetObjValueC("AccNo", myary[9]);
	//var obj = document.getElementById("AccNo");
	//DHCWebD_SetListValueA(obj, myary[9]);

	DHCWebD_SetObjValueC("AccOCDate", myary[10]);
	//var obj = document.getElementById("AccOCDate");
	//DHCWebD_SetListValueA(obj, myary[10]);

	//var obj = document.getElementById("BadPrice");
	//DHCWebD_SetListValueA(obj, myary[11]);

	DHCWebD_SetObjValueC("AccDep", myary[7]);
	//var obj = document.getElementById("AccDep");
	//DHCWebD_SetListValueA(obj, myary[7]);
	
	DHCWebD_SetObjValueC("AccRowID", myary[13]);
	//var obj = document.getElementById("AccRowID");
	//DHCWebD_SetListValueA(obj, myary[13]);
}

function CardNo_OnKeyDown(){
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);

	if ((key == 13)) {
		var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
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
					if (obj) {
						obj.value = myary[5];
					}
					//var obj = document.getElementById("CardNo");
					//DHCWebD_SetListValueA(obj,myary[1]);
					DHCWebD_SetObjValueC("CardNo", myary[1]);
					DHCWebD_SetObjValueC("CardNoA", myary[1]);
					//var obj = document.getElementById("SecurityNo");
					//DHCWebD_SetListValueA(obj,myary[2]);
					DHCWebD_SetObjValueC("SecurityNo", myary[2]);
					ReadPatAccInfo();
					Query_OnClick();
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
///格式化卡号
function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value
			}
		}
	}
}
document.body.onload = BodyLoadHandler;
