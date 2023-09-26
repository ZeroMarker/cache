///UDHCACFinBR.AccListQuery.js
var m_CardNoLength=10; //此界面没有卡类型选项，默认长度10;
function BodyLoadHandler() {
	var obj = document.getElementById("PAPMINo");
	if (obj) {
		obj.onkeydown = PatientNoKeyDown;
	}
	var myReadFlag = "Y";
	var myReadObj = document.getElementById("ReadOnly");
	if (myReadObj) {
		var myReadFlag = myReadObj.value;
	}
	var obj = document.getElementById("BUserCode");
	if ((obj) && (myReadFlag != "N")) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeypress = CardNo_KeyPress;
	}
}

function PatientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNOObj = document.getElementById("PAPMINo");
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", patientNOObj.value);
		patientNOObj.value = rtn;
	}
}

function CardNo_KeyPress() {
	var key = event.keyCode;
	if (key == 13) {
		var CardNo = document.getElementById("CardNo").value;
		CardNo = FormatCardNo();
		document.getElementById("CardNo").value = CardNo;
		Query_click();
	}
}

function FormatCardNo() {
	var CardNo = document.getElementById("CardNo").value;
	if (CardNo != '') {
		var CardNoLength = m_CardNoLength;
		if ((CardNo.length < CardNoLength) && (CardNoLength != 0)) {
			for (var i = (CardNoLength - CardNo.length - 1); i >= 0; i--) {
				CardNo = "0" + CardNo;
			}
		}
	}
	return CardNo;
}

document.body.onload = BodyLoadHandler;
