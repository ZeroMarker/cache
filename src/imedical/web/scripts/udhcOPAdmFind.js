///udhcOPAdmFind.js

function BodyLoadHandler() {
	var obj = document.getElementById("tudhcOPAdmFind");
	if (obj) {
		obj.ondblclick = AdmSelect_Click;
	}
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
		myobj.size = 1;
		myobj.multiple = false;
	}
	loadCardType();
	CardTypeDefine_OnChange();
	//var Obj = document.getElementById('ReadCard');
	//if (Obj) Obj.onclick = ReadCardHandle;

	var obj = document.getElementById("PatientID");
	if (obj)
		obj.onkeydown = PatientNoKeyDown;
	if (obj) {
		obj.style.imeMode = "disabled";
	}

	var obj = document.getElementById("CardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = CardNoKeydown;
		}
	}
	var Locationobj = document.getElementById('Location');
	Locationobj.onkeyup = clearLocation;

	var obj = document.getElementById("PatName");
	if (obj) {
		obj.onkeydown = PatNameKeyDown;
	}
}

//加载卡类型 add by hufaguo 2015-09-10
function loadCardType() {
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
	var cookieCardTypeSelIndex = DHCBILL.getCookie("udhcOPAdmFind_CardTypeDefine_selectedIndex");
	var myobj = document.getElementById("CardTypeDefine");
	if (cookieCardTypeSelIndex != "") {
		this.selectedIndex = cookieCardTypeSelIndex;
	}
}

//Enter键触发  add by hufaguo 2015-09-10
function CardNoKeydown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = document.getElementById("CardNo").value;
		CardNo = FormatCardNo();
		document.getElementById('CardNo').value = CardNo;
		BQuery_click();
	}
}

//比较卡号长度是否完整，不完整补齐 add by hufaguo 2015-09-10
function FormatCardNo() {
	var CardNo = DHCWebD_GetObjValue("CardNo");
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

//根据卡类型得到卡长度 add by hufaguo 2015-09-10
function GetCardNoLength() {
	var CardNoLength = "";
	var CardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardNoLength = CardTypeArr[17];
	}
	return CardNoLength;
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	if (myCardTypeDR == "") {
		return;
	}
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	} else {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById('ReadCard');
		if (obj) {
			obj.disabled = false;
		}
		DHCWeb_setfocus("ReadCard");
	}
	var selectedIndex = this.selectedIndex;
	DHCBILL.setCookie("udhcOPAdmFind_CardTypeDefine_selectedIndex", selectedIndex, 31);
}

//补齐登记号 add by hufaguo 2015-09-10
function PatientNoKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var eSrc = window.event.srcElement;
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNOObj = document.getElementById("PatientID");
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", patientNOObj.value);
		patientNOObj.value = rtn;
		var PatientID = DHCWebD_GetObjValue("PatientID");
		var CardNostr = tkMakeServerCall('web.DHCOPAdmReg', 'GetCardNoByPatientNo', PatientID); //通过登记号找到卡号
		var CardNoobj = document.getElementById('CardNo');
		if (CardNoobj) {
			if (CardNostr != "") {
				var CardNostr1 = CardNostr.split("^");
				var CardNo = CardNostr1[0];
				//CardNoobj.value = CardNo;
			}
		}
		var papname = tkMakeServerCall('web.UDHCJFBaseCommon', 'GetpatnameBYpapid', PatientID);
		var PatNameobj = document.getElementById('PatName');
		PatNameobj.value = papname;
		BQuery_click();
	}
}

/*
function ReadCardHandle() {
	var myEquipDR = DHCWeb_GetListBoxValue("CardTypeDefine");
	var CardInform = DHCACC_ReadMagCard(myEquipDR.split("^")[0]);
	var CardSubInform = CardInform.split("^");
	var rtn = CardSubInform[0];
	var CardNo = CardSubInform[1];
	switch (rtn) {
	case rtn < 0:
		alert("卡无效");
		break;
	default:
		document.getElementById('CardNo').value = CardNo;
		CardNoKeydown();
		break;
	}
}
*/

function AdmSelect_Click() {
	var eSrc = window.event.srcElement;
	if (eSrc.tagName == "IMG") {
		eSrc = window.event.srcElement.parentElement;
	}
	var eSrcAry = eSrc.id.split("z");
	var rowObj = getRow(eSrc);

	if (rowObj.tagName == 'TH') {
		return;
	}
	var row = rowObj.rowIndex;
	var sAdmRowId = document.getElementById('TRowidz' + row).value;
	var sPatDr = document.getElementById('TPatDrz' + row).value;
	//var ReloadFlag = '1';
	var ReloadFlag = opener.parent.frames('udhcOPCharge').document.getElementById("ReloadFlag").value;
	if ((ReloadFlag == 0) || (ReloadFlag == "")) {
		ReloadFlag = 1;
	}
	var SelectPatRowId = sPatDr;
	var SelectAdmRowId = sAdmRowId;
	var mylistObj = document.getElementById('TCardNoz' + row);
	var myRCardNo = DHCWebD_GetCellValue(mylistObj);
	InitPatInfo(ReloadFlag, SelectPatRowId, SelectAdmRowId, myRCardNo);
	window.close();
}

function InitPatInfo(Reload, Pat, Adm, myRCardNo) {
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPPatinfo&ReloadFlag=" + Reload;
	lnk = lnk + "&SelectPatRowId=" + Pat + "&SelectAdmRowId=" + Adm;
	lnk += "&CardNo=" + myCardNo;
	lnk += "&AccRowID=" + myAccRowID;
	lnk += "&RCardNo=" + myRCardNo;
	var PatInfo = opener.parent.frames('udhcOPPatinfo');
	PatInfo.location.href = lnk;
}

function LookupAdmLoc(value) {
	var myary = value.split("^");
	DHCWebD_SetObjValueB("LocRowId", myary[1]);
}

function clearLocation() {
	var Locationobj = document.getElementById('Location');
	if (Locationobj.value == "") {
		document.getElementById('Location').value = "";
		document.getElementById('LocRowId').value = "";
	}
}

function PatNameKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		BQuery_click();
	}
}

document.body.onload = BodyLoadHandler;
