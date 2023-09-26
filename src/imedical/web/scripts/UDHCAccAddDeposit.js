/// UDHCAccAddDeposit.js

var Guser;
var GuserCode;
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
var today;
var PayModeIDobj;
var CardVerify;
var readcardobj;
var Balanceobj;
var GroupID;
var PayModeListobj;
var BankListobj;
var BankCardTypeobj;
var PrtXMLName = "UDHCAccDeposit";
var m_CCMRowID = "";
var m_SelectCardTypeDR = "";
var m_ReceiptsType = "";
var m_CardNoLength = 0;
var m_ReadCardMode = "";
var m_Hospital_DR = session['LOGON.HOSPID'];

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
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
	Balanceobj = document.getElementById('Balance');
	//Passwordobj = document.getElementById('Password');
	BankListobj = document.getElementById('BankList');
	if (BankListobj) {
		BankListobj.onkeydown = nextfocus;
		BankListobj.size = 1;
		BankListobj.multiple = false;
	}
	BankCardTypeListobj = document.getElementById('BankCardTypeList');
	if (BankCardTypeListobj) {
		BankCardTypeListobj.onkeydown = nextfocus;
		BankCardTypeListobj.size = 1;
		BankCardTypeListobj.multiple = false;
	}
	PayModeListobj = document.getElementById('PayModeList');
	if (PayModeListobj) {
		PayModeListobj.onchange = PayModeObj_OnChange;
		PayModeListobj.onkeydown = nextfocus;
		PayModeListobj.size = 1;
		PayModeListobj.multiple = false;
	}
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
	/*
	if (RegNoobj) {
		RegNoobj.onkeydown = getpatbyRegNo;
	}
	amtobj.onkeydown = amt_onkeydown;
	*/
	amtobj.onkeydown = nextfocus;
	amtobj.onkeypress = DHCWeb_SetLimitFloat;
	Companyobj.onkeydown = nextfocus;
	CardChequeNoobj.onkeydown = nextfocus;
	ChequeDateobj.onkeydown = nextfocus;
	PayAccNoobj.onkeydown = nextfocus;
	Remarkobj.onkeydown = nextfocus;
	if (RegNoobj) {
		//RegNoobj.onkeydown = getpatbyRegNo;
		RegNoobj.readOnly = true;
	}
	if (CardNoobj) {
		CardNoobj.onkeydown = getpatbyCardNo;
	}

	PatNameobj.readOnly = true;
	if ((PatNameobj) && (PatNameobj.value != "")) {
		PatNameobj.value = DHCWeb_AscTransChar(PatNameobj.value);
	}
	ReceiptsNoobj.readOnly = true;
	//BankCardTypeobj.readOnly = true;
	//Bankobj.readOnly = true;
	//PayModeobj.readOnly = true;
	Balanceobj.readOnly = true;

	var obj = document.getElementById('CardTypeDefine');
	if (obj) {
		ReadCardType();
		obj.setAttribute("isDefualt", "true");
		var cookieCardTypeSelIndex = DHCBILL.getCookie("UDHCAccAddDeposit_CardTypeDefine_selectedIndex");
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
		//websys_setfocus('RegNo');
	} else {
		websys_setfocus('amt');
	}
	DHCWeb_DisBtnA("RePrint");

	var obj = document.getElementById("PatCal");
	if (obj) {
		obj.onclick = PatCal_OnClick;
	}
	var obj = document.getElementById("tUDHCAccAddDeposit");
	if (obj) {
		obj.ondblclick = UDHCAccAddDeposit_OnDBClick;
	}
	//+2016-12-16 ZhYW 跳号
	var voidInvNoObj = document.getElementById("voidInvNo");
	if (voidInvNoObj) {
		voidInvNoObj.onclick = altVoidInv;
	}

	document.onkeydown = Doc_OnKeyDown;
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
		//DHCWeb_setfocus("CardNo");
		websys_setfocus('CardNo');
	} else {
		//DHCWeb_setfocus("ReadCard");
		websys_setfocus('ReadCard');
	}
	if (combo_CardType) {
		websys_nexttab(combo_CardType.tabIndex);
	}
	var selectedIndex = combo_CardType.getSelectedIndex();
	DHCBILL.setCookie("UDHCAccAddDeposit_CardTypeDefine_selectedIndex", selectedIndex, 31);
}

function UDHCAccAddDeposit_OnDBClick() {
	var selectrow = DHCWeb_GetRowIdx(window);
	var obj = document.getElementById("TAccPreDepRowIDz" + selectrow);
	var TAmtObj = document.getElementById("Tamtz" + selectrow);
	var myPreRowID = DHCWebD_GetCellValue(obj);
	var myAmt = DHCWebD_GetCellValue(TAmtObj);
	if (eval(myAmt) < 0) {
		alert('退预交金记录，请到"预交金退款"界面补打.');
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

function PatCal_OnClick() {
	FootExpCalculate();
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
		}
		break;
	default:
		var myAccPreDepRowID = DHCWebD_GetObjValue("AccPreDepRowID");
		if (myAccPreDepRowID != "") {
			RePrtBillNew(myAccPreDepRowID);
			DHCWeb_DisBtnA("RePrint");
		}
		break;
	}
}

function getAccBalance() {
	if (AccountIDobj.value != "") {
		p1 = AccountIDobj.value;
		var encmeth = DHCWebD_GetObjValue("getBalanceClass");
		var rtn = cspRunServerMethod(encmeth, p1);
		Balanceobj.value = rtn;
	}

	var myAccDepFlag = DHCWebD_GetObjValue("AccDepFlag");
	if (myAccDepFlag == "1") {
		var myPatFactPaySum = DHCWebD_GetObjValue("PatFactPaySum");
		if ((isNaN(myPatFactPaySum)) || (myPatFactPaySum == "")) {
			myPatFactPaySum = 0;
		}
		myPatFactPaySum = parseFloat(myPatFactPaySum);
		var myBalance = DHCWebD_GetObjValue("Balance");
		if ((isNaN(myBalance)) || (myBalance == "")) {
			myBalance = 0;
		}
		myBalance = parseFloat(myBalance);
		if (myPatFactPaySum > myBalance) {
			var myAmt = DHCWeb_CalobjA(myPatFactPaySum, myBalance, "-");
			myAmt = myAmt.toRound(1, 1);
			DHCWebD_SetObjValueA("amt", myAmt);
		}
	}
}

function GetCurrentRecNo() {
	var p1 = Guser;
	var p2 = "D";
	var encmeth = DHCWebD_GetObjValue("GetCurrentRecNoClass");
	var ren = cspRunServerMethod(encmeth, p1, p2);
	var myary = ren.split("^");
	if (myary.length > 5) {
		m_ReceiptsType = myary[5];
	}

	if (myary[0] == '0') {
		ReceiptsNoobj.value = myary[3];
		//var ReceiptsIDobj = document.getElementById('ReceiptsID');
		//ReceiptsIDobj.value = myary[4];
	} else {
		DHCWeb_DisBtnA("AddDeposit");
		alert(t[2072]);
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

function getpatbyregno(regno) {
	if (regno == "") {
		return;
	}
	var encmeth = DHCWebD_GetObjValue("getpatclass");
	if (cspRunServerMethod(encmeth, 'setpatinfo_val', '', regno, "", "", "", "") == '1') {}
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
	Balanceobj.value = val[6];
	CardVerify = val[12];
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + DHCWeb_CharTransAsc(PatNameobj.value);
	websys_setfocus('amt');
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
		if (cspRunServerMethod(encmeth, 'setpatinfo_val2', '', "", "", CardNo, CardVerify, "", m_SelectCardTypeDR, myHospitalDR) == '1') {}
	}
}

function setpatinfo_val2(value) {
	var val = value.split("^");
	if (val[17] == "-200") {
		alert(t["-200"]);
		websys_setfocus("ReadCard");
		return;
	}
	if (val[0] == "") {
		alert(t["2087"]);
		websys_setfocus('ReadCard');
		return;
	}
	AccountIDobj.value = val[14];
	if ((AccountIDobj.value == "") || (val[3] != "N")) {
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
	Balanceobj.value = val[6];
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + DHCWeb_CharTransAsc(PatNameobj.value);
	websys_setfocus('amt');
}

function getpatbyCardNo() {
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
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit';
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
	DHCWeb_DisBtnA("AddDeposit");
	if (AccountIDobj.value == "") {
		alert(t[2030]);
		return;
	}
	if ((m_ReceiptsType != "") && (ReceiptsNoobj.value == "")) {
		alert(t[2072]);
		var obj = document.getElementById("AddDeposit");
		DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
		return;
	}
	if (PayModeListobj.value == "") {
		alert(t[2040]);
		var obj = document.getElementById("AddDeposit");
		DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
		websys_setfocus('PayModeList');
		return;
	}
	if (amtobj.value == "") {
		alert(t[2039]);
		var obj = document.getElementById("AddDeposit");
		DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
		websys_setfocus('amt');
		return;
	}
	if ((!IsNumber(amtobj.value)) || (amtobj.value <= 0)) {
		alert(t[2041]);
		var obj = document.getElementById("AddDeposit");
		DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
		websys_setfocus('amt');
		return;
	}
	var myVersion = DHCWebD_GetObjValue("DHCVersion");
	switch (myVersion) {
	case "":
		break;
	default:
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		//alert(t["CardTip"]);
		var mycheckrtn = DHCACC_CheckCardNoForDeposit(myCardNo, m_SelectCardTypeDR);
		if (!mycheckrtn) {
			alert(t["OldCardTip"]);
			return;
		}
	}
	var mytmparray = PayModeListobj.value.split("^");
	var PayModeid = mytmparray[0];
	if (mytmparray[2] == "Y") {
		//Require Pay Info
		var myCheckNO = websys_trim(DHCWebD_GetObjValue("CardChequeNo"));
		if (myCheckNO == "") {
			alert(t['InCheckNo']);
			var obj = document.getElementById("AddDeposit");
			DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
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
	var myencrypt = DHCWebD_GetObjValue("MTransEncrypt");
	if (myencrypt != "") {
		var myAmt = amtobj.value;
		if (isNaN(myAmt)) {
			myAmt = 0;
		}
		var myRMB = cspRunServerMethod(myencrypt, myAmt);
		myAmt = myAmt.toString();
		//myAmt = myAmt.toFixed(2);
		var myrtn = confirm(t['GetSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
		if (myrtn == false) {
			var obj = document.getElementById("AddDeposit");
			DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
			return;
		}
	}
	/*
	//第三方支付接口 start DHCBillPayService.js
	var IBPRowId = "";
	var ExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^^^^C";
	var PayCenterRtn = PayService("PRE", PayModeid, amtobj.value, ExpStr);
	if (PayCenterRtn.returnCode != 0) {
		alert("支付失败");
		return;
	} else {
		IBPRowId = PayCenterRtn.IBPRowid;
	}
	//
	*/
	var p1 = AccountIDobj.value + "^" + amtobj.value + "^" + Guser + "^" + ReceiptsNoobj.value + "^" + BackReasonobj.value + "^" + Password + "^" + PayModeid + "^" + BankCardTypeid + "^" + CardChequeNoobj.value + "^" + Bankid + "^" + Companyobj.value + "^" + PayAccNoobj.value + "^" + ChequeDateobj.value + "^" + Remarkobj.value + "^P" + "^" + session['LOGON.HOSPID'];
	var encmeth = DHCWebD_GetObjValue("AddDepositClass");
	var rtn = cspRunServerMethod(encmeth, "", "", p1);
	//alert(rtn);
	var myary = rtn.split("^");
	var ren = myary[0];
	if (ren != '0') {
		var obj = document.getElementById("AddDeposit");
		DHCWeb_AvailabilityBtnA(obj, AddDeposit_Click);
	}
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
	if (ren == "PayModeErr") {
		alert("押金支付方式不能为空");
		return;
	}
	if (ren == '0') {
		/*
		//用于第三方支付接口保存信息
		if (IBPRowId != "") {
			var linkRtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "RelationOrderToHIS", IBPRowId, myary[6]);
		}
		*/
		//Add Version Contral
		var myVersion = DHCWebD_GetObjValue("DHCVersion");
		switch (myVersion) {
		case "1":
			var obj = document.getElementById("PreDepInfo");
			if (obj) {
				obj.value = rtn;
			}
			var mystr = obj.value + "^^";
			Print_Click(mystr);
			var obj = document.getElementById("RePrint");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, RePrint_Click);
			}
			var myrtn = confirm(t["AddOK"]);
			break;
		default:
			//Read Data From Server
			alert(t['2073'])
			var myrtn = true;
			BillPrintNew(myary[6]);
			break;
		}
		//Add unload Form Function
		var myAccDepFlag = DHCWebD_GetObjValue("AccDepFlag");
		if (myAccDepFlag == "1") {
			/*
			var par_win = parent.window.opener;
			if (par_win) {
				//parent.frames["udhcOPPatinfo"].document.getElementById("AccLeft").value;
				var leftAmt = tkMakeServerCall("web.UDHCAccManageCLS", "getAccBalance", AccountIDobj.value);
				par_win.document.getElementById("AccLeft").value = leftAmt;
				myOPCharge = par_win.parent.frames('udhcOPCharge');
				myOPOEList = par_win.parent.frames('DHCOPOEList');
				if (myOPOEList) {
					//myOPOEList.location.href = myOPOEList.location.href;
					//myOPOEList.location.reload();
					//window.opener.location.href = window.opener.location.href;
					//window.opener.location.reload();
				}
			}
			if (myOPCharge) {
				var Billobj = myOPCharge.document.getElementById("Bill");
				if (Billobj) {
					myOPCharge.Charge();
				}
			}
			parent.close();
			*/
			websys_showModal("options").originWindow.charge();
			websys_showModal("close");
		}
		if (myrtn == true) {
			location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID=' + AccountIDobj.value + '&CardNo=' + CardNoobj.value + '&RegNo=' + RegNoobj.value + '&PatName=' + DHCWeb_CharTransAsc(PatNameobj.value);
		}
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
	TxtInfo = TxtInfo + "Balance" + c + val[3] + "^" + "Guser" + c + GuserCode + "^" + "Datetime" + c + val[4];
	TxtInfo += "^BillNo" + c + val[5];
	TxtInfo += "^RePrintFlag" + c + val[6];
	TxtInfo += "^StubL" + c + val[7];

	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
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
		}
	}
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
}

function ReadHFMagCard_Click() {
	ClsWinDoc();
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
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//Account Can Pay
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
	ClsWinDoc();
	var obj = document.getElementById("ClsHFCard");
	if (obj) {
		window.status = t[2007];
		var rtn = obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		///alert(rtn);
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
			//window.status="Cancel Read Card.";
		}
	}
}

function ClsWinDoc() {
	DHCWebD_SetObjValueB("CardNo", "");
	DHCWebD_SetObjValueB("RegNo", "");
	DHCWebD_SetObjValueB("PatName", "");
	DHCWebD_SetObjValueB("amt", "");
	DHCWebD_SetObjValueB("Balance", "");
	DHCWebD_SetObjValueB("ReceiptsNo", "");
	DHCWebD_SetObjValueB("Company", "");
	DHCWebD_SetObjValueB("CardChequeNo", "");
	DHCWebD_SetObjValueB("PayAccNo", "");
	DHCWebD_SetObjValueB("Remark", "");
	DHCWebD_SetObjValueB("AccountID", "");
}

function FootExpCalculate() {
	var iHeight = 400;
	var iWidth = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	websys_createWindow(lnk, "udhcOPCashExpCal", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}

/**
 * Creator: ZhYW
 * CreatDate: 2016-12-16
 * Description: 门诊预交金跳号
 */
function altVoidInv() {
	var receiptType = "OD";
	var iHeight = 400;
	var iWidth = 620;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&receiptType=" + receiptType;
	websys_createWindow(lnk, "_blank", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}

document.body.onload = BodyLoadHandler;
