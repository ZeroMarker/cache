/// UDHCJFCardRef.js

var m_CardNoLength = 0;
var m_SelectCardTypeDR = "";
var combo_CardType;
var tempclear = "";
var m_CCMRowID = "";
function loadCardType() {
	DHCWebD_ClearAllListA("OPCardType");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "OPCardType");
	}
	OPCardType_OnChange();
}

function SetCardNOLength() {
	var obj = document.getElementById('opcardno');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

function OPCardType_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("OPCardType");
	var myary = myoptval.split("^");
	//myary[16]="Handle"
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	///Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("opcardno");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("readcard");
	} else {
		var myobj = document.getElementById("opcardno");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("readcard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, readcard_click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		websys_setfocus("opcardno");
	} else {
		websys_setfocus("readcard");
	}
	m_CardNoLength = myary[17];
}

function GetCardTypeRowId() {
	var CardTypeRowId = "";
	var CardTypeValue = DHCWeb_GetListBoxValue("OPCardType");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}

function ReadCardClickHandler() {
	var CardTypeRowId = GetCardTypeRowId();
	var myoptval = DHCWeb_GetListBoxValue("OPCardType");
	//通过读卡按钮时调用函数需要这个
	//m_CCMRowID=GetCardEqRowId();
	var bool = false;
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	if (myrtn == -200) {
		//alert("此卡无效!");
		websys_setfocus('opcardno');
		return bool;
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		var PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		//PatientNO.value = PatientNo;
		var RegnoObj = document.getElementById("Regno");
		if (RegnoObj) {
			RegnoObj.value = PatientNo;
		}
		var obj = document.getElementById("PatientNO");
		if (obj) {
			obj.value = PatientNo;
		}
		var CardNoObj = document.getElementById("CardNo");
		if (CardNoObj) {
			CardNoObj.value = CardNo;
		}
		var papnoObj = document.getElementById("papno");
		if (papnoObj) {
			papnoObj.value = PatientNo;
		}
		var opcardnoObj = document.getElementById("opcardno");
		if (opcardnoObj) {
			opcardnoObj.value = CardNo;
		}
		getpatinfo1();
		bool = true;
		break;
	case "-200":
		alert(t['InvaildCard']);
		websys_setfocus('opcardno');
		bool = false;
		break;
	case "-201":
		//alert(t['21']);
		var PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		var RegnoObj = document.getElementById("Regno");
		if (RegnoObj) {
			RegnoObj.value = PatientNo;
		}
		var obj = document.getElementById("PatientNO");
		if (obj) {
			obj.value = PatientNo
		}
		var CardNoObj = document.getElementById("CardNo");
		if (CardNoObj) {
			CardNoObj.value = CardNo;
		}
		var papnoObj = document.getElementById("papno");
		if (papnoObj) {
			papnoObj.value = PatientNo;
		}
		var opcardnoObj = document.getElementById("opcardno");
		if (opcardnoObj) {
			opcardnoObj.value = CardNo;
		}
		getpatinfo1();
		bool = true;
		break;
	default:
		//alert("Error:"+rtn);
		websys_setfocus('opcardno');
		bool = false;
		break;
	}
	return bool;
}

function ReadCardClickHandlerNew() {
	var bool = false;
	var CardTypeRowId = GetCardTypeRowId();
	//var CardEqRowId = GetCardEqRowId();
	var myoptval = DHCWeb_GetListBoxValue("OPCardType");
	//通过读卡按钮时调用函数需要这个
	//m_CCMRowID = GetCardEqRowId();
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	if (myrtn == -200) {
		//alert("此卡无效!");
		websys_setfocus('opcardno');
		return bool;
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	//AccAmount=myary[3];
	switch (rtn) {
	case "0":
		var PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		var RegnoObj = document.getElementById("Regno");
		if (RegnoObj) {
			RegnoObj.value = PatientNo;
		}
		var PatientNOObj = document.getElementById("PatientNO");
		if (PatientNOObj) {
			PatientNOObj.value = PatientNo;
		}
		var CardNoObj = document.getElementById("CardNo");
		if (CardNoObj) {
			CardNoObj.value = CardNo;
		}
		var opcardnoobj = document.getElementById("opcardno");
		if (opcardnoobj) {
			opcardnoobj.value = CardNo;
		}
		getpatinfo1();
		bool = true;
		break;
	case "-200":
		alert(t['InvaildCard']);
		websys_setfocus('opcardno');
		bool = false;
		break;
	case "-201":
		//alert(t['21']);
		var PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		var RegnoObj = document.getElementById("Regno");
		if (RegnoObj) {
			RegnoObj.value = PatientNo;
		}
		var PatientNOObj = document.getElementById("PatientNO");
		if (PatientNOObj) {
			PatientNOObj.value = PatientNo;
		}
		var CardNoObj = document.getElementById("CardNo");
		if (CardNoObj) {
			CardNoObj.value = CardNo;
		}
		var opcardnoobj = document.getElementById("opcardno");
		if (opcardnoobj) {
			opcardnoobj.value = CardNo;
		}
		getpatinfo1();
		bool = true;
		break;
	default:
		//alert("Error:"+rtn);
		websys_setfocus('opcardno');
		bool = false;
		break;
	}
	return bool;
}

function CardNoKeydownHandler(e) {
	if (evtName == 'opcardno') {
		window.clearTimeout(evtTimer);
		evtTimer = '';
		evtName = '';
	}
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = DHCC_GetElementData("opcardno");
		var CardTypeRowId = GetCardTypeRowId();
		var CardNo = FormatCardNo();
		if (CardNo == "") {
			return;
		}
		var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardNo, "", "PatInfo");
		//var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardNo, "");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		//AccAmount = myary[3];
		switch (rtn) {
		case "0":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			papnoobj.value = PatientNo;
			document.getElementById("opcardno").value = CardNo;
			getpatinfo1();
			break;
		case "-200":
			alert("卡号不存在");
			websys_setfocus('opcardno');
			break;
		case "-201":
			//alert(t['21']);
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			papnoobj.value = PatientNo;
			document.getElementById("opcardno").value = CardNo;
			getpatinfo1();
			break;
		default:
		}

	}
}

function FormatCardNo() {
	var CardNo = DHCC_GetElementData("opcardno");
	if (CardNo != '') {
		var CardNoLength = GetCardNoLength();
		if ((CardNo.length < CardNoLength) && (CardNoLength != 0)) {
			for (var i = (CardNoLength - CardNo.length - 1); i >= 0; i--) {
				CardNo = "0" + CardNo;
			}
		}
	}
	return CardNo
}

function GetCardNoLength() {
	var CardNoLength = "";
	var CardTypeValue = DHCWeb_GetListBoxValue("OPCardType");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardNoLength = CardTypeArr[17];
	}
	return CardNoLength;
}

function initCardType() { //卡类型
	var obj = document.getElementById('OPCardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) {
		obj.setAttribute("isDefualt", "true");
	}
	combo_CardType = dhtmlXComboFromSelect("OPCardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle = combo_CardTypeKeydownHandler; //OPCardType_OnChange
		//combo_CardType.onChange = OPCardType_OnChange;
	}
}

function combo_CardTypeKeydownHandler() {
	var myoptval = combo_CardType.getActualValue();
	tempclear = myoptval;   //by guorongyong   2008-02-27
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("opcardno");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("readcard");
	} else {
		m_CCMRowID = GetCardEqRowId();
		var myobj = document.getElementById("opcardno");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("readcard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadCardClickHandler);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("opcardno");
	} else {
		DHCWeb_setfocus("readcard");
	}
	if (combo_CardType)
		websys_nexttab(combo_CardType.tabIndex);
}

function GetCardEqRowId() {
	var CardEqRowId = "";
	var CardTypeValue = combo_CardType.getActualValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardEqRowId = CardTypeArr[14];
	}
	return CardEqRowId;
}
