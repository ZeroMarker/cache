/// UDHCAccForgetPWApply.js

var Guser;
var GuserCode;
var RegNo;
var PatientID;
var PatName;
var CardNo;
var IDCardNo;
var AccountID;
var RegNoobj;
var CardNoobj;
var PatNameobj;
var PatientIDobj;
var IDCardNoobj;
var AccountNoobj;
var AccountTypeobj;
var AccTypeobj;
var AccountStatusobj;
var AccStatusobj;
var AccountBalanceobj;
var CredTypeobj;

var DepPriceobj;
var NewAccountobj;
var NewAccountClassobj;

var AddDepositobj;
var AddDepositClassobj;
var CancelAccountobj;
var CancelAccountClassobj;
var AccountIDobj;
var CardIDobj;
var CredTypeIDobj;
var Clearobj;
var computername
var today;
var CardVerify;
var readcardobj;
var SetDefPassWobj;
var ChgPasswordobj;
var RLNameobj;
var RLCredTypeobj;
var RLCredTypeIDobj;
var RLCredNoobj;
var RLAddressobj;
var RLPhoneNoobj;
var RLProofobj;
var RLRemarkobj;
var ResetPWApplyobj;
var bcheckcred;
var RLAccBalance;
var RLCredNo;
var RLCredType;
var RLCredTypeID;
var getPWDEditReqobj;
var RLCredTypeListObj;

var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";

function combo_CardTypeKeydownHandler() {
	var myoptval = getValueById("CardTypeDefine");
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
		$("#readcard").linkbutton('disable');
	} else {
		//m_CCMRowID=GetCardEqRowId();

		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		$("#readcard").linkbutton('enable');
	}

	//Set Focus
	if (myary[16] == "Handle") {
		setValueById("CardNo");
	} else {
		setValueById("readcard");
	}
}

function BodyLoadHandler() {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
	RegNoobj = document.getElementById('RegNo');
	CardNoobj = document.getElementById('CardNo');
	PatNameobj = document.getElementById('PatName');
	PatientIDobj = document.getElementById('PatientID');
	IDCardNoobj = document.getElementById('IDCardNo');
	AccountNoobj = document.getElementById('AccountNo');
	AccountTypeobj = document.getElementById('AccountType');
	AccTypeobj = document.getElementById('AccType');
	AccountStatusobj = document.getElementById('AccountStatus');
	AccStatusobj = document.getElementById('AccStatus');
	AccountBalanceobj = document.getElementById('AccountBalance');

	ChgPasswordobj = document.getElementById('ChgPassword');
	DepPriceobj = document.getElementById('DepPrice');
	CredTypeobj = document.getElementById('CredType');

	AccountIDobj = document.getElementById('AccountID');
	CardIDobj = document.getElementById('CardID');
	CredTypeIDobj = document.getElementById('CredTypeID');
	Clearobj = document.getElementById('Clear');

	RLNameobj = document.getElementById('RLName');

	RLCredNoobj = document.getElementById('RLCredNo');
	RLAddressobj = document.getElementById('RLAddress');
	RLPhoneNoobj = document.getElementById('RLPhoneNo');
	RLProofobj = document.getElementById('RLProof');
	RLRemarkobj = document.getElementById('RLRemark');
	ResetPWApplyobj = document.getElementById('ResetPWApply');
	RLNameobj.onkeydown = nextfocus;
	RLAddressobj.onkeydown = nextfocus;
	RLPhoneNoobj.onkeydown = nextfocus;
	RLProofobj.onkeydown = nextfocus;
	RLRemarkobj.onkeydown = nextfocus;
	getPWDEditReqobj = document.getElementById('getPWDEditReq');

	if (RLCredNoobj) {
		RLCredNoobj.onkeydown = RLCredNo_Click;
	}
		
	readcardobj = document.getElementById('readcard');
	if (readcardobj) {
		readcardobj.onclick = ReadHFMagCard_Click;
	}
	
	if (ResetPWApplyobj) {
		ResetPWApplyobj.onclick = ChgPassWord_Click;
	}
	
	if (Clearobj) {
		Clearobj.onclick = Clear_Click;
	}
	
	if (RegNoobj) {
		RegNoobj.onkeydown = getpatbyRegNo;
	}
		
	if (CardNoobj) {
		CardNoobj.onkeydown = getpatbyCardNo;
	}
		
	if (IDCardNoobj) {
		IDCardNoobj.onkeydown = getpatbyIDCardNo;
	}

	RLCredTypeListObj = document.getElementById('RLCredTypeList');
	if (RLCredTypeListObj) {
		$('#RLCredTypeList').combobox({
			valueField: 'id',
			textField: 'text'
		});
		RLCredTypeListObj.onkeydown = nextfocus;
	}
	
	RegNoobj.readOnly = true;
	CardNoobj.readOnly = true;
	PatNameobj.readOnly = true;
	AccountNoobj.readOnly = true;
	AccountTypeobj.readOnly = true;
	AccTypeobj.readOnly = true;
	AccountStatusobj.readOnly = true;
	AccStatusobj.readOnly = true;
	AccountBalanceobj.readOnly = true;
	CredTypeobj.readOnly = true;
	CardNoobj.readOnly = true;
	IDCardNoobj.readOnly = true;
	DepPriceobj.readOnly = true;
	//RLCredTypeobj.readOnly = true;
	bcheckcred = "";

	$("#ResetPWApply").linkbutton('disable');
	//DHCWeb_DisBtn(ResetPWApplyobj);
	//var WshNetwork = new ActiveXObject("WScript.NetWork");
	//computername=WshNetwork.ComputerName;
	DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth = getValueById("ReadCredType");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToCombobox", "RLCredTypeList");
	}

	$('#CardTypeDefine').combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		onChange: function (newVal, oldVal) {
			CardTypeDefine_OnChange();
		}
	});
	ReadCardType();
	combo_CardTypeKeydownHandler();
}

function RLCredNo_Click() {
	bcheckcred = "";
	var key = websys_getKey(e);
	if (key == 13) {
		if (RLCredNo != "") {
			var mytmparray = RLCredTypeListObj.value.split("^");
			if (RLCredNo == RLCredNoobj.value && RLCredTypeID == mytmparray[0]) {
				bcheckcred = "OK";
				ResetPWApplyobj.disabled = false;
				ResetPWApplyobj.onclick = ChgPassWord_Click;
				websys_setfocus('RLPhoneNo');
			} else {
				DHCWeb_HISUIalert(t[2062]);
				return;
			}
		} else {
			bcheckcred = "F";
			DHCWeb_HISUIalert(t[2062]);
			websys_setfocus('RLPhoneNo');
			return;
		}
	}
}

function ChgPassWord_Click() {
	if (AccountIDobj.value == "" || AccountNoobj.value == "") {
		DHCWeb_HISUIalert(t[2080]);
		return;
	}
	$("#ResetPWApply").linkbutton('disable');
	if ((bcheckcred != "OK") && (bcheckcred != "F")) {
		DHCWeb_HISUIalert(t[2062]);
		return;
	}

	if (bcheckcred == "F") {
		if (RLNameobj.value == "") {
			DHCWeb_HISUIalert(t[2064]);
			websys_setfocus('RLName');
			return;
		}

		if (RLCredTypeListObj.value == "") {
			DHCWeb_HISUIalert(t[2065]);
			websys_setfocus('RLCredTypeList');
			return;
		}

		if (RLCredNoobj.value == "") {
			DHCWeb_HISUIalert(t[2066]);
			websys_setfocus('RLCredNo');
			return;
		}

		if (RLAddressobj.value == "") {
			DHCWeb_HISUIalert(t[2067]);
			websys_setfocus('RLAddress');
			return;
		}

		if (RLPhoneNoobj.value == "") {
			DHCWeb_HISUIalert(t[2068]);
			websys_setfocus('RLPhoneNo');
			return;
		}
	}

	var mytmparray = RLCredTypeListObj.value.split("^");
	p1 = AccountIDobj.value;
	p2 = Guser;
	p3 = computername;
	p4 = RLNameobj.value + "^" + RLCredNoobj.value + "^" + RLAddressobj.value + "^" + RLPhoneNoobj.value + "^" + RLProofobj.value + "^" + RLRemarkobj.value + "^" + mytmparray[0];

	var encmeth = getValueById("ResetPWApplyClass");
	var rtn = cspRunServerMethod(encmeth, p1, p2, p3, p4);
	if (rtn == "0") {
		DHCWeb_HISUIalert(t[2081]);
		Clear_Click();
	} else {
		DHCWeb_HISUIalert(rtn + "  " + t[2082]);
		return;
	}
}

function Clear_Click() {
	location.href = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCAccForgetPWApply";
}

function getpatbyregno(regno) {
	if (regno == "") {
		return;
	}
	p1 = regno;
	var encmeth = getValueById("getpatclass");
	if (cspRunServerMethod(encmeth, 'setpatinfo_val', '', p1, "", "", "", "") == '1') {}
}

function getpatbyRegNo() {
	var key = websys_getKey(e);
	if (key == 13) {
		if (RegNoobj.value != "") {
			getpatbyregno(RegNoobj.value);
		}
	}
}

function setpatinfo_val(value) {
	var val = value.split("^");
	if (val[0] == "") {
		DHCWeb_HISUIalert(t[2001])
		websys_setfocus('RegNo');
		return;
	}
	if (val[3] != "N") {
		DHCWeb_HISUIalert(t[2080]);
		return;
	}
	RegNoobj.value = val[0];
	PatientIDobj.value = val[1];
	PatNameobj.value = val[2];
	CardNoobj.value = val[4];
	CardVerify = val[12];
	CardIDobj.value = val[13];

	AccountIDobj.value = val[14];
	AccountNoobj.value = val[5];
	AccountBalanceobj.value = val[6];
	AccountStatusobj.value = val[3];
	AccStatusobj.value = val[16];
	DepPriceobj.value = val[7];
	AccountTypeobj.value = val[8];
	AccTypeobj.value = val[15];
	//CredTypeIDobj.value = val[9];
	//CredTypeobj.value = val[10];
	//IDCardNoobj.value = val[11];
	RLAccBalance = val[6];
	RLCredTypeID = val[9];
	RLCredNo = val[11];
	/*
	if (AccountTypeobj.value==""){
	AccountTypeobj.value="P";
	AccTypeobj.value="P";
	}
	 */
}

function getpatbycard() {
	SetCardNOLength();
	bcheckcred = "";
	$("#ResetPWApply").linkbutton('disable');
	if (!CardVerify) {
		CardVerify = "";
	}
	if (CardNoobj.value != "") {
		p1 = CardNoobj.value;
		p2 = CardVerify;
		var encmeth = getValueById("getpatclass");
		if (cspRunServerMethod(encmeth, 'setpatinfo_val2', '', "", "", p1, p2, "") == '1') {}

	}
}
function setpatinfo_val2(value) {
	var val = value.split("^");
	if (val[0] == "") {
		DHCWeb_HISUIalert(t[2001])
		websys_setfocus('readcard');
		return;
	}
	if (val[3] != "N") {
		DHCWeb_HISUIalert(t[2080]);
		websys_setfocus('readcard');
		return;
	}
	RegNoobj.value = val[0];
	PatientIDobj.value = val[1];
	PatNameobj.value = val[2];
	CardNoobj.value = val[4];
	CardVerify = val[12];
	CardIDobj.value = val[13];

	AccountIDobj.value = val[14];
	AccountNoobj.value = val[5];
	AccountBalanceobj.value = val[6];
	AccountStatusobj.value = val[3];
	AccStatusobj.value = val[16];
	DepPriceobj.value = val[7];
	AccountTypeobj.value = val[8];
	AccTypeobj.value = val[15];
	//CredTypeIDobj.value=val[9];
	//CredTypeobj.value=val[10];
	//IDCardNoobj.value=val[11];
	RLAccBalance = val[6];
	RLCredTypeID = val[9];
	RLCredNo = val[11];
	/*
	if ( AccountTypeobj.value == ""){
	AccountTypeobj.value = "P";
	}
	 */

}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = getValueById("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, " DHCWeb_AddToCombobox", "CardTypeDefine");
	}
}

function getpatbyCardNo() {
	var key = websys_getKey();
	if (key == 13) {
		getpatbycard();
	}
}

function getpatbyIDCardNo() {}

function setaccid(value) {
	var val = value.split("^");
	AccountIDobj.value = val[0];
	AccountNoobj.value = val[1];
	AccountStatusobj.value = val[2];
}

function ReadHFMagCard_Click() {
	//ClsWinDoc();
	var myCardTypeValue = getValueById("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		CardNoobj.value = myary[1];
		CardVerify = myary[2]
			getpatbycard();
		break;
	case "-200":
		DHCWeb_HISUIalert("卡无效");
		break;
	case "-201":
		DHCWeb_HISUIalert("账户无效");
		break;
	default:
		//DHCWeb_HISUIalert("");
	}
}

function CardTypeDefine_OnChange() {
	var myoptval = getValueById("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		$("#readcard").linkbutton('disable');
		DHCWeb_setfocus("CardNo");
	} else {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("readcard");
		if (obj) {
			$("#readcard").linkbutton('enable');
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");
	} else {
		DHCWeb_setfocus("readcard");
	}
	m_CardNoLength = myary[17];
}

function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

document.body.onload = BodyLoadHandler;
