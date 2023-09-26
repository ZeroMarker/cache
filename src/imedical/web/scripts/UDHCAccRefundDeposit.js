/// UDHCAccRefundDeposit.js

var Guser;
var GuserCode;
var GuserName;
var RegNo;
var PatientID;
var PatName;
var CardNo;
var CardVerify;
var ExchCardVerify;
var IDCardNo;
var Companyobj;
var PayAccNoobj;
var ChequeDateobj;
var Remarkobj;
var AccountIDobj;
var CardNoobj;
var amtobj;
var ReceiptsNoobj;
var BackReasonobj;
var AddDepositobj;
var AddDepositClassobj;
var PayModeobj;
var PayModeIDobj;
var BankCardTypeobj;
var BankCardTypeIDobj;
var CardChequeNoobj;
var Bankobj;
var BankIDobj;
var Clearobj;
var Passwordobj;
var PayModeIDobj;
var CardVerify;
var Balanceobj;
var readcardobj;
var GroupID;
var PayModeListobj;
var BankListobj;
var BankCardTypeobj;
var PrtXMLName = "UDHCAccDeposit";
var m_CCMRowID = "";
var m_SelectCardTypeDR = "";
var m_ReceiptsType = "";
var m_CardNoLength = 0;
var m_ReadCardMode="";
var m_Hospital_DR=session['LOGON.HOSPID'];
var subyjinfor;	//add by xiongwang 住院押金

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
	GuserName = session["LOGON.USERNAME"];
	GroupID = session['LOGON.GROUPID'];
	RegNoobj = document.getElementById('RegNo');
	PatNameobj = document.getElementById('PatName');
	Companyobj = document.getElementById('Company');
	PayAccNoobj = document.getElementById('PayAccNo');
	ChequeDateobj = document.getElementById('ChequeDate');
	Remarkobj = document.getElementById('Remark');
	AccountIDobj = document.getElementById('AccountID');
	CardNoobj = document.getElementById('CardNo');
	amtobj = document.getElementById('amt');
	ReceiptsNoobj = document.getElementById('ReceiptsNo');
	BackReasonobj = document.getElementById('BackReason');
	AddDepositobj = document.getElementById('AddDeposit');
	AddDepositClassobj = document.getElementById('AddDepositClass');
	//PayModeobj = document.getElementById('PayMode');
	//PayModeIDobj = document.getElementById('PayModeID');
	//BankCardTypeobj = document.getElementById('BankCardType');
	//BankCardTypeIDobj = document.getElementById('BankCardTypeID');
	CardChequeNoobj = document.getElementById('CardChequeNo');
	//Bankobj = document.getElementById('Bank');
	//BankIDobj = document.getElementById('BankID');
	Clearobj = document.getElementById('Clear');
	//Passwordobj = document.getElementById('Password');
	BankListobj = document.getElementById('BankList');
	BankListobj.onkeydown = nextfocus;
	BankListobj.size = 1;
	BankListobj.multiple = false;
	BankCardTypeListobj = document.getElementById('BankCardTypeList');
	BankCardTypeListobj.onkeydown = nextfocus;
	BankCardTypeListobj.size = 1;
	BankCardTypeListobj.multiple = false;
	PayModeListobj = document.getElementById('PayModeList');
	PayModeListobj.onchange = PayModeObj_OnChange;
	PayModeListobj.onkeydown = nextfocus;
	PayModeListobj.size = 1;
	PayModeListobj.multiple = false;

	Balanceobj = document.getElementById('Balance');

	readcardobj = document.getElementById('ReadCard');
	if (readcardobj) {
		readcardobj.onclick = ReadHFMagCard_Click;
	}
	if (AddDepositobj) {
		AddDepositobj.onclick = AddDeposit_Click;
	}
	if (Clearobj) {
		Clearobj.onclick = Clear_Click;
	}
	//amtobj.onkeydown = amt_onkeydown;
	amtobj.onkeydown = nextfocus;
	amtobj.onkeypress = DHCWeb_SetLimitFloat;
	Companyobj.onkeydown = nextfocus;
	CardChequeNoobj.onkeydown = nextfocus;
	ChequeDateobj.onkeydown = nextfocus;
	PayAccNoobj.onkeydown = nextfocus;
	Remarkobj.onkeydown = nextfocus;
	//+2018-01-17 ZhYW 
	BackReasonobj.onkeypress = LimitInvalidChar_KeyPress;
	BackReasonobj.onkeydown = nextfocus;
	if (RegNoobj) {
		RegNoobj.onkeydown = getpatbyRegNo;
	}
	if (CardNoobj) {
		CardNoobj.onkeydown = getpatbyCardNo;
	}
	//RegNoobj.readOnly = true;
	CardNoobj.readOnly = true;
	PatNameobj.readOnly = true;
	if ((PatNameobj) && (PatNameobj.value != "")) {
		PatNameobj.value = DHCWeb_AscTransChar(PatNameobj.value);
	}
	var obj = document.getElementById("PatCal");
	if (obj) {
		obj.onclick = PatCal_OnClick;
	}
	ReceiptsNoobj.readOnly = true;
	//BankCardTypeobj.readOnly = true;
	//Bankobj.readOnly = true;
	//PayModeobj.readOnly = true;
	Balanceobj.readOnly = true;
	var obj = document.getElementById("phone");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("patID");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById('CardTypeDefine');
	if (obj) {
		ReadCardType();
		obj.setAttribute("isDefualt", "true");
		var cookieCardTypeSelIndex = DHCBILL.getCookie("UDHCAccRefundDeposit_CardTypeDefine_selectedIndex");
		if (cookieCardTypeSelIndex != "") {
			obj.selectedIndex = cookieCardTypeSelIndex;
		}
		combo_CardType = dhtmlXComboFromSelect("CardTypeDefine");
	}

	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle = combo_CardTypeKeydownHandler;
	}

	getAccBalance();
	IntDoc();
	//SetPayInfoStatus(true);
	PayModeObj_OnChange();
	DHCP_GetXMLConfig("DepositPrintEncrypt", "UDHCAccDeposit");
	GetCurrentRecNo();
	if (RegNoobj.value == "") {
		websys_setfocus('ReadCard');
	} else {
		websys_setfocus('amt');
	}
	DHCWeb_DisBtnA("RePrint");
	var obj = document.getElementById("tUDHCAccRefundDeposit");
	if (obj) {
		obj.ondblclick = UDHCAccRefundDeposit_OnDBClick;
	}
	document.onkeydown = Doc_OnKeyDown;
	
	//add by xiongwang 2018-03-14
	obj = document.getElementById('TransferIP');
	if (obj) {
		obj.onclick = TransferIP_Click;
	}
	GetTransferConfig();
	getzyjfconfig();
}

function IntDoc() {
	DHCWebD_ClearAllListA("BankList");
	var encmeth = DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "BankList");
	}
	DHCWebD_ClearAllListA("BankCardTypeList");
	var encmeth = DHCWebD_GetObjValue("ReadBankCardType");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "BankCardTypeList");
	}

	DHCWebD_ClearAllListA("PayModeList");
	var encmeth = DHCWebD_GetObjValue("ReadPayMode");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayModeList", GroupID);
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
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	m_ReadCardMode = myary[16];
	m_CardNoLength = myary[17];   //该卡类型定义的卡号长度
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
		//DHCWeb_setfocus("CardNo");
		websys_setfocus('CardNo');
	} else {
		//DHCWeb_setfocus("ReadCard");
		websys_setfocus('ReadCard');
	}
	if (combo_CardType)
		websys_nexttab(combo_CardType.tabIndex);

	var selectedIndex = combo_CardType.getSelectedIndex();
	DHCBILL.setCookie("UDHCAccRefundDeposit_CardTypeDefine_selectedIndex", selectedIndex, 31);
}

function UDHCAccRefundDeposit_OnDBClick() {
	var selectrow = DHCWeb_GetRowIdx(window);
	var obj = document.getElementById("TAccPreDepRowIDz" + selectrow);
	var TAmtObj = document.getElementById("Tamtz" + selectrow);
	var myPreRowID = DHCWebD_GetCellValue(obj);
	var myAmt = DHCWebD_GetCellValue(TAmtObj);
	if (eval(myAmt) > 0) {
		alert('收预交金记录，请到"预交金收款"界面补打。');
		return;
	}
	if (myPreRowID != "") {
		DHCWebD_SetObjValueB("AccPreDepRowID", myPreRowID);
		var obj = document.getElementById("RePrint");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, RePrint_Click);
		}
	} else {
		DHCWeb_DisBtnA("RePrint");
	}
}

function Doc_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 115) {
		//F4
		var obj = document.getElementById("ReadCard");
		if ((obj)&&(!obj.disabled)) {
			ReadHFMagCard_Click();
		}
	}
	if (key == 118) {
		 //F7
		Clear_Click();
	}
	if (key == 120) {
		 //F9
		AddDeposit_Click();
	}
	DHCWeb_EStopSpaceKey();
}

function amt_onkeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (amtobj.value != "") {
			websys_setfocus('AddDeposit');
		}
	}
}

function PayModeObj_OnChange() {
	if (PayModeListobj.options.length == 0) {
		SetPayInfoStatus(true);
		return;
	}
	var myIdx = PayModeListobj.options.selectedIndex;
	if (myIdx == -1) {
		SetPayInfoStatus(true);
		return;
	}
	var myary = PayModeListobj.options[myIdx].value.split("^");
	if (myary[2] == "Y") {
		SetPayInfoStatus(false);
	} else {
		SetPayInfoStatus(true);
	}
}

function SetPayInfoStatus(SFlag) {
	Companyobj.disabled = SFlag;
	BankListobj.disabled = SFlag;
	BankCardTypeListobj.disabled = SFlag;
	CardChequeNoobj.disabled = SFlag;
	ChequeDateobj.disabled = SFlag;
	PayAccNoobj.disabled = SFlag;
	Remarkobj.disabled = SFlag;
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "ChequeDate";
		var ChequeDateobj1 = document.getElementById(imgname);
	}
	if (SFlag == false) {
		ChequeDateobj1.style.display = "";
	} else {
		ChequeDateobj1.style.display = "none";
	}
}

function getAccBalance() {
	if (AccountIDobj.value != "") {
		p1 = AccountIDobj.value;
		var encmeth = DHCWebD_GetObjValue("getBalanceClass");
		var ren = cspRunServerMethod(encmeth, p1);
		Balanceobj.value = ren;
	}
}

function GetCurrentRecNo() {
	var p1 = Guser;
	var p2 = "D";
	var encmeth = DHCWebD_GetObjValue("GetCurrentRecNoClass");
	var ren = cspRunServerMethod(encmeth, p1, p2);
	var myary = ren.split("^");
	if (myary.length > 5)
		m_ReceiptsType = myary[5];
	if (myary[0] == '0') {
		ReceiptsNoobj.value = myary[3];
	} else {
		DHCWeb_DisBtnA("AddDeposit");
		alert(t[2072]);
	}
}


function getpatbyregno(regno) {
	if (regno == "") {
		return;
	}
	var encmeth = DHCWebD_GetObjValue("getpatclass");
	if (cspRunServerMethod(encmeth, 'setpatinfo_val', '', regno, "", "", "", "") == '1') {
	}
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
		alert(t[2001]);
		websys_setfocus('RegNo');
		return;
	}
	AccountIDobj.value = val[14];
	if (AccountIDobj.value == "" || val[3] != "N") {
		alert(t[2030]);
		websys_setfocus('RegNo');
		return;
	}
	RegNoobj.value = val[0];
	PatNameobj.value = val[2];
	CardNoobj.value = val[4];
	CardVerify = val[12];
	var obj = document.getElementById('phone');
	if (obj) {
		obj.value = val[18];
	}
	var obj = document.getElementById('patID');
	if (obj) {
		obj.value = val[19];
	}
	//location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccRefundDeposit&AccountID='+AccountIDobj.value+'&CardNo='+CardNoobj.value+'&RegNo='+RegNoobj.value+'&PatName='+escape(PatNameobj.value);
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccRefundDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + PatNameobj.value + '&phone=' + val[18] + '&patID=' + val[19];
	websys_setfocus('amt');
	//AccountBalanceobj.value = val[6];
	//AccountStatusobj.value = val[3];
	//DepPriceobj.value = val[7];
}

function getpatbycard() {
	if (CardNoobj.value != "") {
		var CardNo = FormatCardNo();
		CardNoobj.value = CardNo;
		if (!CardVerify) {
			CardVerify = "";
		}
		var encmeth = DHCWebD_GetObjValue("getpatclass");
		var myHospitalDR = DHCACC_GetHospitalDR();
		if (cspRunServerMethod(encmeth, 'setpatinfo_val2', '', "", "", CardNo, CardVerify, "", m_SelectCardTypeDR,myHospitalDR) == '1') {}
	}
}

function setpatinfo_val2(value) {
	var val = value.split("^");
	if (val[17] == "-200") {
		alert(t["-200"]);
		websys_setfocus('ReadCard');
		return;
	}
	if (val[0] == "") {
		alert(t[2001]);
		websys_setfocus('ReadCard');
		return;
	}
	AccountIDobj.value = val[14];
	if (AccountIDobj.value == "" || val[3] != "N") {
		alert(t[2030]);
		websys_setfocus('ReadCard');
		return;
	}
	RegNoobj.value = val[0];
	//PatientIDobj.value = val[1];
	PatNameobj.value = val[2];
	//CardNoobj.value = val[4];
	//CardVerify = val[12];
	//CardIDobj.value = val[13];
	var obj = document.getElementById('phone');
	if (obj) {
		obj.value = val[18];
	}
	var obj = document.getElementById('patID');
	if (obj) {
		obj.value = val[19];
	}
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccRefundDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + DHCWeb_CharTransAsc(PatNameobj.value) + '&phone=' + val[18] + '&patID=' + val[19]; ;
	websys_setfocus('amt');
}

function getpatbyCardNo(){
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		getpatbycard();
	}
}	

function getpaymodeid(value) {
	var val = value.split("^");
	PayModeIDobj.value = val[1];
}

function getbankcardtypeid(value) {
	var val = value.split("^");
	BankCardTypeIDobj.value = val[1];
}

function getbankid(value) {
	var val = value.split("^");
	BankIDobj.value = val[1];
}

function Clear_Click() {
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccRefundDeposit';
}

function getpatbyIDCardNo() {
}

function IsNumber(str, sign) {
	var number;
	if (str == null) {
		return false;
	}
	if ((sign != null) && (sign != '-') && (sign != '+')) {
		return false;
	}
	number = new Number(str);
	if (isNaN(number)) {
		return false;
	} else if ((sign == null) || (sign == '-' && number < 0) || (sign == '+' && number > 0)) {
		return true;
	} else {
		return false;
	}
}

function AddDeposit_Click() {
	var Password;
	if ((m_ReceiptsType != "") && (ReceiptsNoobj.value == "")) {
		alert(t[2072]);
		return;
	}
	var myencrypt = DHCWebD_GetObjValue("MTransEncrypt");
	if (myencrypt != "") {
		var myAmt = amtobj.value;
		if (isNaN(myAmt)) {
			myAmt = 0;
		}
		var myRMB = cspRunServerMethod(myencrypt, myAmt);
		myAmt = myAmt.toString();
		//myAmt = myAmt.toFixed(2);
		var myrtn = confirm(t['RefSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
		if (myrtn == false) {
			return;
		}
	}
	if (AccountIDobj.value == "") {
		alert(t[2030]);
		return;
	}
	if (amtobj.value == "") {
		alert(t[2039]);
		websys_setfocus('amt');
		return;
	}
	if (PayModeListobj.value == "") {
		alert(t[2040]);
		websys_setfocus('PayModeList');
		return;
	}
	if (!IsNumber(amtobj.value)) {
		alert(t[2041]);
		websys_setfocus('amt');
		return;
	}
	if (amtobj.value <= 0) {
		alert(t[2041]);
		websys_setfocus('amt');
		return;
	}
	var amtabs = Math.abs(amtobj.value);
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_CCMRowID = myary[14];
	var ren = DHCACC_CheckMCFPay(amtabs, CardNoobj.value, "", myCardTypeDR);
	var myary = ren.split("^");
	if (myary[0] == '-204') {
		alert(t[2042]);
		return;
	}
	if (myary[0] == '-205') {
		alert(t[2043]);
		return;
	}
	if (myary[0] == '-206') {
		alert(t[2044]);
		return;
	}
	if (myary[0] != '0' && myary[0] != '-208') {
		return;
	}
	
	var mytmparray = PayModeListobj.value.split("^");
	var PayModeid = mytmparray[0];
	if (mytmparray[2] == "Y") {
		//Require Pay Info
		var myCheckNO = websys_trim(DHCWebD_GetObjValue("CardChequeNo"));
		if (myCheckNO == "") {
			alert(t['InCheckNo']);
			websys_setfocus("CardChequeNo");
			return false;
		}
	}
	var Bankid = "";
	var BankCardTypeid = "";
	if (BankListobj.value != "") {
		mytmparray = BankListobj.value.split("^");
		var Bankid = mytmparray[0];
	}
	if (BankCardTypeListobj.value != "") {
		mytmparray = BankCardTypeListobj.value.split("^");
		var BankCardTypeid = mytmparray[0];
	}
	//var Password = Passwordobj.value;
	var p1 = AccountIDobj.value + "^" + amtobj.value + "^" + Guser + "^" + ReceiptsNoobj.value + "^" + BackReasonobj.value + "^" + Password + "^" + PayModeid + "^" + BankCardTypeid + "^" + CardChequeNoobj.value + "^" + Bankid + "^" + Companyobj.value + "^" + PayAccNoobj.value + "^" + ChequeDateobj.value + "^" + Remarkobj.value + "^R" + "^" + session['LOGON.HOSPID'];
	var encmeth = DHCWebD_GetObjValue("AddDepositClass");
	var rtn = cspRunServerMethod(encmeth, '', '', p1);
	var myary = rtn.split("^");
	var ren = myary[0];
	if (ren == 'passerr') {
		alert(t[2042]);
		return;
	}
	if (ren == 'amterr') {
		alert(t[2041]);
		return;
	}
	if (ren == 'accerr') {
		alert(t[2046]);
		return;
	}
	if (ren == 'noamt') {
		alert(t[2043]);
		return;
	}
	if (ren == '0') {
		var myVersion = DHCWebD_GetObjValue("DHCVersion");
		switch (myVersion) {
		case "1":
			var myReStr = rtn + "^^";
			Print_Click(myReStr);
			break;
		default:
			//Read Data From Server
			var myrtn = true;
			//alert("print:"+myary[6]);
			BillPrintNew(myary[6]);
			break;
		}
		alert(t["RefOK"]);
		//var myReStr = rtn+"^^***********";
		//Print_Click(myReStr);
		var phone = DHCWebD_GetObjValue("phone");
		location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccRefundDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + DHCWeb_CharTransAsc(PatNameobj.value) + '&phone=' + phone;
	} else {
		alert(ren + t[2045]);
	}
}

function Print_Click(value) {
	var val = value.split("^");
	var TxtInfo = "";
	var ListInfo = "";
	var c = String.fromCharCode(2);
	TxtInfo = "CardNo" + c + CardNoobj.value + "^" + "PatName" + c + PatNameobj.value + "^" + "amt" + c + val[1] + "^" + "amtdx" + c + val[2] + "^";
	TxtInfo = TxtInfo + "Balance" + c + val[3] + "^" + "Guser" + c + GuserName + "^" + "Datetime" + c + val[4];
	TxtInfo += "^BillNo" + c + val[5];
	TxtInfo += "^StubL" + c + val[7];

	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("ReadAccDPEncrypt");
			//var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], Guser, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
	DHCP_GetXMLConfig("DepositPrintEncrypt", "UDHCAccDeposit")
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function ReadHFMagCard_Click() {
	window.status = t[2007];
	var myoptval = combo_CardType.getSelectedValue();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myoptval);
	var myary = myrtn.split("^");
	if (myary[0] == '-5') {
		window.status = t[2008];
		return;
	}
	window.status = "";
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		CardNoobj.value = myary[1];
		CardVerify = myary[2];
		getpatbycard();
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

function ReadMagCard_Click() {
	var obj = document.getElementById("ClsHFCard");
	if (obj) {
		window.status = t[2007];
		var rtn = obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		var myary = rtn.split("^");
		if (myary[0] == '-5') {
			window.status = t[2008];
			return;
		}
		window.status = "";
		if (myary[0] == "0") {
			CardNoobj.value = myary[1];
			CardVerify = myary[2];
			getpatbycard();
		} else {
			//window.status = "Cancel Read Card";
		}
	}
}

function PatCal_OnClick() {
	FootExpCalculate();
}

function FootExpCalculate() {
	var iHeight = 400;
	var iWidth = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	websys_createWindow(lnk, "udhcOPCashExpCal", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}

///重打
function RePrint_Click() {
	var myrtn = window.confirm("是否确认重打?");
	if (!myrtn) {
		return myrtn;
	}
	var myVersion = DHCWebD_GetObjValue("DHCVersion");
	switch (myVersion) {
	case "1":
		var obj = document.getElementById("PreDepInfo");
		if (obj) {
			var mystr = obj.value + "^" + t["RPTip"] + "^";
			Print_Click(mystr);
			//var mystr = obj.value+"^"+t["RPTip"]+"^"+"***********";
			//Print_Click(mystr);
		}
		break;
	default:
		var myAccPreDepRowID = DHCWebD_GetObjValue("AccPreDepRowID");
		if (myAccPreDepRowID != "") {
			RePrtBillNew(myAccPreDepRowID);
		}
		break;
	}
}

function RePrtBillNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("ReadAccDPEncrypt");
			//var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "1^";
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], Guser, myExpStr);
			DHCWeb_DisBtnA("RePrint");
		}
	}
}

/**
* Creator: ZhYW
* CreatDate: 2018-01-17
* Description: 阻止"^"号输入
*/
function LimitInvalidChar_KeyPress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 94) {
		window.event.keyCode = 0;
		return websys_cancel();
	}
}


/**
* Creator: xiongwang
* CreatDate: 2018-03-14
* Description: 门诊账户转住院押金
*/
function GetTransferConfig()
{
	var myrtn = tkMakeServerCall("web.DHCOPConfig","ReadOPSPConfig");
	var str = myrtn.split("^");
	if (str[45] == "1"){
		document.getElementById("TransferIP").style.display="block";
		var obj = document.getElementById("IPRcpNo");
		if (obj){
			var IPRcpNo = GetIPRcpNo();
			obj.value = IPRcpNo;
		}
	}else {
		document.getElementById("TransferIP").style.display="none";
	}
}

function GetIPRcpNo()
{
	var rtn = tkMakeServerCall("web.DHCBillDepConversion", "GetDEPZZDepTypeID");
	var deptype = rtn.split("^")[1];
	var Guser = session['LOGON.USERID'];
	var myrtn = tkMakeServerCall("web.UDHCJFBaseCommon","GetRcptNo","","",Guser,deptype);
	var str = myrtn.split("^");
	var IPRcpNo = str[2];
	return IPRcpNo;
}
function TransferIP_Click()
{
	var Password;
	var PayModeid = tkMakeServerCall("web.DHCBillDepConversion", "GetDEPZZPayModeID");
	if (PayModeid == ""){
		alert("请维护转账支付方式,系统默认取支付方式代码为:DEPZZ");
		return;
	}
	
	if ((m_ReceiptsType != "") && (ReceiptsNoobj.value == "")) {
		alert("您已经没有可用退款收据,请领取收据");
		return;
	}
	var CurIPRcpNo = document.getElementById("IPRcpNo").value;
	if (CurIPRcpNo == ""){
		alert("您已经没有可用押金收据");
		return;
	}
	if (amtobj.value == "") {
		alert("金额不能为空");
		websys_setfocus('amt');
		return;
	}
	if ((!IsNumber(amtobj.value))||(amtobj.value <= 0)) {
		alert("金额输入有误,请重新输入");
		websys_setfocus('amt');
		return;
	}
	var amtabs = Math.abs(amtobj.value);
	var myencrypt = DHCWebD_GetObjValue("MTransEncrypt");
	if (myencrypt != "") {
		var myAmt = amtobj.value;
		if (isNaN(myAmt)) {
			myAmt = 0;
		}
		var myRMB = cspRunServerMethod(myencrypt, myAmt);
		myAmt = myAmt.toString();
		//myAmt = myAmt.toFixed(2);
		var myrtn = confirm("转账金额:" + myAmt + "(" + myRMB + ")" + ",是否继续?");
		if (myrtn == false) {
			return;
		}
	}
	if (AccountIDobj.value == "") {
		alert("没有有效账户,不能进行预交金转账");
		return;
	}
	
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_CCMRowID = myary[14];
	var ren = DHCACC_CheckMCFPay(amtabs, CardNoobj.value, "", myCardTypeDR);
	var myary = ren.split("^");
	if (myary[0] == '-204') {
		alert("密码验证失败");
		return;
	}else if (myary[0] == '-205') {
		alert("账户余额不足,不能转账");
		return;
	}else if (myary[0] == '-206') {
		alert("卡号和账户不匹配,不能转账");
		return;
	}else if (myary[0] != '0' && myary[0] != '-208') {
		alert("账户验证失败,不能转账");
		return;
	}
	var hospital =session['LOGON.HOSPID']
	var p1 = AccountIDobj.value + "^" + amtobj.value + "^" + Guser + "^" + ReceiptsNoobj.value + "^" + BackReasonobj.value + "^" + Password + "^" + PayModeid + "^^^^^^^^R^" + hospital;
	
	var rtn = tkMakeServerCall("web.DHCBillDepConversion", "GetDEPZZDepTypeID");
	var deptypeid = rtn.split("^")[0];
	var deptype = rtn.split("^")[1];
	var Adm = document.getElementById("IPAdmID").value;
	if (Adm ==""){
		alert("请选择病人住院记录");
		websys_setfocus('IPAdm');
		return ;	
	}
	var admrtn=CheckDischstatus(Adm); //判断患者住院记录是否做最终结算  add  zhli  18.9.6
	if (admrtn==0){
		alert("此住院记录已做最终结算不允许转押金!");
		return;
	}
	var myrtn = tkMakeServerCall("web.UDHCJFBaseCommon","GetRcptNo","","",Guser,deptype);
	var mystr = myrtn.split("^");
	var CurNo = CurIPRcpNo;
	var receiptrowid = mystr[0];
	var EndNo = mystr[1];
	var Title = mystr[3];
	var UserLoc = session['LOGON.CTLOCID'];
	var dep = deptypeid + "^" + amtobj.value + "^" + PayModeid + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + Adm + "^" + CurNo + "^" + UserLoc + "^" + Guser + "^" + EndNo + "^" + Title + "^" + "" + "^" + "" + "^" + "" + "^" + receiptrowid + "^" + "" + "^" + hospital;
	
	var rtn = tkMakeServerCall("web.DHCBillDepConversion", "AcountTransDeposit",p1,dep);
	
	var myary = rtn.split("^");
	var ren = myary[0];
	switch (ren){
		case 'passerr':
			alert("密码验证失败");
			break;
		case 'amterr':
			alert("金额输入有误,请重新输入");
			break;
		case 'accerr':
			alert("账户有误,操作失败");
			break;
		case 'noamt':
			alert("账户余额不足,不能退款");
			break;
		case '-2':
			alert("此收据号已经使用过,请刷新界面.");
			break;
		case 'refundFail':
			alert("退门诊账户失败.");
			break;
		case '-2':
			alert("此收据号已经使用过,请刷新界面.");
			break;
		case '-3':
			alert("病人已退院,不允许交押金.");
			break;
		case '-4':
			alert("没有可用收据号,请核实.");
			break;
		case '0':
			alert("转账成功！")
			//打印门诊退款收据
			BillPrintNew(myary[1]);
			//住院押金打印
			var returnval =tkMakeServerCall("web.UDHCJFDeposit", "getyjdetail","","",myary[2]);
			subyjinfor = returnval.split("^");
			//DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFDeposit");
			DHCP_GetXMLConfig("DepositPrintEncrypt", "DHCJFDeposit");
			printYJ("", "");
			var phone = DHCWebD_GetObjValue("phone");
			location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccRefundDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + PatNameobj.value + '&phone=' + phone;
			break;
		default:
			alert("转账失败,错误代码：" + Error);
			break;
	}
}

function LookupIPAdm(value)
{
	var str = value.split("^");
	var obj = document.getElementById("IPAdm");
	if (obj){
		obj.value = str[6];
	}
	var obj = document.getElementById("IPAdmID");
	if (obj){
		obj.value = str[0];
	}
}

function a ()
{
	//document.all('test').style.visibility='hidden';isshow=false;}   
	//document.all('test').style.visibility='visible';isshow=true;
}
/**
 * Creator: zhli
 * CreatDate: 2018-09-06
 * Description: 最终结算是否可以交押金
 */
function CheckDischstatus(Adm) {
	if (Adm != "") {
		var rtnStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetOutAdmInOutDateInfo", Adm);
		var dischstatus = rtnStr.split("^")[3];
		if (dischstatus == "护士办理出院") {
			if (FinalChargeCheckDepFlag == "N") { //最终结算不允许交押金
				//alert("此住院记录已做最终结算不允许转押金!");
				//DHCWeb_DisBtnA("BtnPrint");
				return 0;
			} else {
				var rtnnum = tkMakeServerCall("web.UDHCJFCOMMON", "getinfro", Adm); //财务结算不允许交押金
				if (rtnnum == "0") {
					//alert("此住院记录已做财务结算不允许转押金!");
					//DHCWeb_DisBtnA("BtnPrint");
					return 0;
				}
			}
		}
		return 1;
	}
	
}
document.body.onload = BodyLoadHandler;
