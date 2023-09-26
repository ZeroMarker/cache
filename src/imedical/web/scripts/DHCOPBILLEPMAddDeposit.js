/*
 *JS:		DHCOPBILLEPMAddDeposit.js
 *Creator:	hujunbin
 *Date:		14.12.22
 *Desc:		急诊流观交押金
 */
var PrtXMLName = "UDHCEPMDeposit";

var RegNoObj = document.getElementById("RegNo");
var PatNameObj = document.getElementById("PatName");
var InsTypeObj = document.getElementById("InsType");
var patLocObj = document.getElementById("patLoc");
var patWardObj = document.getElementById("patWard");
var patBedObj = document.getElementById("patBed");
var admDateObj = document.getElementById("admDate");
var patAddressObj = document.getElementById("patAddress");
var patPhoneObj = document.getElementById("patPhone");
var amtObj = document.getElementById("amt");
var AddDepositObj = document.getElementById("AddDeposit");
var PayModeObj = document.getElementById("PayMode");
var CardChequeNoObj = document.getElementById("CardChequeNo");
var CardTypeDefineObj = document.getElementById("CardTypeDefine");
var RemarkObj = document.getElementById('Remark');
var PayModeListObj = document.getElementById("PayModeList");
var BankCardTypeListObj = document.getElementById("BankCardTypeList");
var ReadCardObj = document.getElementById('ReadCard');
var ClearObj = document.getElementById('Clear');
var CardNoObj = document.getElementById('CardNo');
var BalanceObj = document.getElementById("Balance");
var BankListObj = document.getElementById("BankList");
var AccountIDObj = document.getElementById("AccountID");
var PayModeIDObj = document.getElementById("PayMOdeID");
var AdmIDObj = document.getElementById("AdmID");
var CompanyObj = document.getElementById("Company");
var ChequeDateObj = document.getElementById("ChequeDate");
var PapmiObj = document.getElementById("Papmi");
var ReceiptsNoObj = document.getElementById("ReceiptsNo");
var CardVerify = "";
var AdmListObj = document.getElementById("AdmList");
var m_SelectCardTypeDR = "";
var m_CardNoLength = 0;
var m_SelectedRow = "";

function BodyLoadHandler() {
	disabledItem();
	initDocument();
	getCurrAcountID();
	getAccBalance();
	setpatbyadm();
	document.onkeydown = Doc_OnKeyDown;
}

function initDocument() {
	initDoc();

	if (CardTypeDefineObj) {
		CardTypeDefineObj.size = 1;
		CardTypeDefineObj.multiple = false;
		ReadCardType();
		CardTypeDefineObj.setAttribute("isDefualt", "true");
		combo_CardType = dhtmlXComboFromSelect("CardTypeDefine");
	}
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle = combo_CardTypeKeydownHandler;
	}

	if (BankCardTypeListObj) {
		BankCardTypeListObj.size = 1;
		BankCardTypeListObj.multiple = false;
	}

	if (PayModeListObj) {
		PayModeListObj.size = 1;
		PayModeListObj.multiple = false;
		PayModeListObj.onchange = PayMode_Change;
	}
	PayMode_Change();
	if (BankListObj) {
		BankListObj.size = 1;
		BankListObj.multiple = false;
	}

	if (ReadCardObj) {
		ReadCardObj.onclick = ReadHFMagCard_Click;
	}
	if (AddDepositObj) {
		AddDepositObj.onclick = AddDeposit_Click;
	}
	if (ClearObj) {
		ClearObj.onclick = Clear_Click;
	}
	if (CardNoObj) {
		CardNoObj.onkeydown = RCardNo_KeyDown;
	}
	if (RegNoObj) {
		RegNoObj.onkeydown = getpatbyRegNo;
	}
	DHCWeb_DisBtnA("RePrint");
	/*
	var obj = document.getElementById("tDHCOPBillEPMAddDeposit");
	if (obj) {
		obj.onclick = UDHCEPMAddDeposit_OnDBClick;
	}
	*/
	if (amtObj) {
		amtObj.onkeydown = amt_onkeydown;
	}
	combo_CardTypeKeydownHandler();
	if (AdmIDObj) {
		if (AdmIDObj.value != "") {
			websys_setfocus('amt');
		}
	}
	var obj = document.getElementById("PatCal");
	if (obj) {
		obj.onclick = PatCal_OnClick;
	}
}

function initDoc() {
	initPayMode();
	initBankType();
	initBank();
	initRowColor();
	initReceiptNo();
}

function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
		var myCardobj = document.getElementById('CardNo');
		if (myCardobj) {
			myCardobj.value = obj.value;
		}
	}
}

function RCardNo_KeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var obj = document.getElementById("RegNo");
			obj.value = myary[5];
			CardNoObj.value = myary[1];
			CardVerify = myary[2];
			getpatbycard();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			var obj = document.getElementById("RegNo");
			obj.value = myary[5];
			CardNoObj.value = myary[1];
			CardVerify = myary[2];
			getpatbycard();
			break;
		default:
			//alert("");
		}
		return;
	}
}

function ReadHFMagCard_Click() {
	ClsWinDoc();
	window.status = t[2007];
	var myoptval = combo_CardType.getSelectedValue();
	if (m_SelectCardTypeRowID == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myoptval);
	}
	var myary = myrtn.split("^");
	if (myary[0] == '-5') {
		window.status = t[2008];
		return;
	}
	window.status = "";
	var rtn = myary[0];
	/*
	if(rtn == "-201") {
		rtn = "0";
	}
	*/
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//Account Can Pay
		CardNoObj.value = myary[1];
		CardVerify = myary[2];
		getpatbycard();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		CardNoObj.value = myary[1];
		CardVerify = myary[2];
		getpatbycard();
		break;
	default:
		//alert("");
	}

}

function AddDeposit_Click() {
	DHCWeb_DisBtnA("AddDeposit");
	var checkFlag = checkValue();
	if (!checkFlag) {
		ableAddClick();
		return;
	}
	var mytmparray = PayModeListObj.value.split("^");
	var PayModeid = mytmparray[0];
	if (mytmparray[2] == "Y") {
		//Require Pay Info
		var myCheckNO = websys_trim(DHCWebD_GetObjValue("CardChequeNo"));
		if (myCheckNO == "") {
			alert(t['InCheckNo']);
			websys_setfocus("CardChequeNo");
			ableAddClick();
			return false;
		}
	}
	var Bankid = "";
	var BankCardTypeid = "";
	if (BankListObj.value != "") {
		mytmparray = BankListObj.value.split("^");
		var Bankid = mytmparray[0];
	}
	if (BankCardTypeListObj.value != "") {
		mytmparray = BankCardTypeListObj.value.split("^");
		var BankCardTypeid = mytmparray[0];
	}
	var myencrypt = DHCWebD_GetObjValue("MTransEncrypt");
	if (myencrypt != "") {
		var myAmt = amtObj.value;
		if (isNaN(myAmt)) {
			myAmt = 0;
		}
		var myRMB = cspRunServerMethod(myencrypt, myAmt);
		myAmt = myAmt.toString();
		var myrtn = confirm(t['GetSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
		if (myrtn == false) {
			ableAddClick();
			return;
		}
	}
	var p1 = AdmIDObj.value + "^" + PapmiObj.value + "^" + RegNoObj.value + "^" + CardNoObj.value + "^" + session['LOGON.USERID'] + "^" + "" + "^" + "";
	var p2 = "" + "^" + amtObj.value + "^" + session['LOGON.USERID'] + "^" + "";
	p2 = p2 + "^" + "" + "^" + PayModeid + "^" + BankCardTypeid + "^" + CardChequeNoObj.value + "^" + Bankid + "^" + CompanyObj.value;
	p2 = p2 + "^" + ChequeDateObj.value + "^" + RemarkObj.value + "^P" + "^" + session['LOGON.HOSPID'];
	var p3 = session['LOGON.GROUPID'];
	var encmeth = DHCWebD_GetObjValue('AddDepositClass');
	var rtn = cspRunServerMethod(encmeth, '', '', p1, p2, p3);
	//alert(rtn);
	var myary = rtn.split("^");
	var ren = myary[0];
	if (ren != '0') {
		if (AddDepositObj) {
			DHCWeb_AvailabilityBtnA(AddDepositObj, AddDeposit_Click);
		}
	}
	if (ren == "epmerr") {
		alert("账户错误");
		ableAddClick();
		return;
	} else if (ren == 'passerr') {
		alert(t[2042]);
		ableAddClick();
		return;
	} else if (ren == 'amterr') {
		alert(t[2041]);
		ableAddClick();
		return;
	} else if (ren == 'accerr') {
		alert(t[2046]);
		ableAddClick();
		return;
	} else if (ren == "PayModeErr") {
		alert("支付方式错误");
		return;
	} else if (ren == "adderr") {
		alert("交押金失败");
		ableAddClick();
		return;
	} else if (ren == "admerr") {
		alert("不是急诊流观病人" + ren);
		ableAddClick();
		return;
	}
	if (ren == '0') {
		//Add Version Contral
		getCurrAcountID();
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
		var myAccDepFlag = DHCWebD_GetObjValue("AccDepFlag");
		if (myAccDepFlag == "1") {
			var par_win = parent.window.opener;
			if (par_win) {
				//par_win.transINVStr(myConAry[0]);
			}
			parent.close();
		}
		if (myrtn == true) {
			getpatbyadm();
			//window.location.reload();  //href = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillEPMAddDeposit';
		}
	} else {
		alert(ren + t[2045]);
	}
}

function checkValue() {
	if (AdmIDObj.value == "") {
		alert("不存在有效的就诊记录");
		return false;
	}
	if (amtObj.value == "") {
		alert(t[2039]);
		websys_setfocus('amt');
		return false;
	}
	if (PayModeListObj.value == "") {
		alert(t[2040]);
		websys_setfocus('PayModeList');
		return false;
	}
	if (!IsNumber(amtObj.value)) {
		alert(t[2041]);
		websys_setfocus('amt');
		return false;
	}
	if (amtObj.value <= 0) {
		alert(t[2041]);
		websys_setfocus('amt');
		return false;
	}
	//急诊流观标志
	var flag = checkAdmStayStat(AdmIDObj.value);
	if (flag != "Y") {
		alert("不是急诊流观病人不能在此界面交押金");
		return false;
	}
	return true;
}

function Clear_Click() {
	location.href = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillEPMAddDeposit';
}

function RePrint_Click() {
	var myrtn = window.confirm("确定要重打吗");
	if (!myrtn) {
		return myrtn;
	}
	if (m_SelectedRow == "") {
		return;
	}
	var myAmt = DHCWeb_GetColumnData("Tamt", m_SelectedRow);
	if (eval(myAmt) < 0) {
		alert('退款记录请到【急诊留观退押金】界面重打.');
		return;
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
			DHCWeb_DisBtnA("RePrint");
		}
		break;
	}
}

function getPatByCardNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//getpatbycard();
		ReadHFMagCard_Click()
	}
}

function Doc_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 115) {
		document.onkeydown = function () {
			return false;
		}
		var obj = document.getElementById("ReadCard");
		if ((obj)&&(!obj.disabled)) {
			ReadHFMagCard_Click();
		}
		document.onkeydown = Doc_OnKeyDown;
	}
	//F7
	if (key == 118) {
		Clear_Click();
		document.onkeydown = Doc_OnKeyDown;
	}
	//F9
	if (key == 120) {
		AddDeposit_Click();
		document.onkeydown = Doc_OnKeyDown;
	}

	DHCWeb_EStopSpaceKey();
}

function PayMode_Change() {
	if (PayModeListObj) {
		if (PayModeListObj.options.length == 0) {
			SetPayInfoStatus(true);
			return;
		}
		var myIdx = PayModeListObj.options.selectedIndex;
		if (myIdx == -1) {
			SetPayInfoStatus(true);
			return;
		}
		var myary = PayModeListObj.options[myIdx].value.split("^");
		if (myary[2] == "Y") {
			SetPayInfoStatus(false);
		} else {
			SetPayInfoStatus(true);
		}
	}
}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function initPayMode() {
	var GroupID = session['LOGON.GROUPID'];
	DHCWebD_ClearAllListA("PayModeList");
	var encmeth = DHCWebD_GetObjValue("ReadPayMode");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayModeList", GroupID);
	}
}

function getdefaultpaymode() {
	var encmeth = DHCWebD_GetObjValue('getdefaultpaymodeClass');
	var rtn = cspRunServerMethod(encmeth, GroupID);
	var myarray = rtn.split('^');
	if (myarray[0] == '0') {
		PayModeObj.value = myarray[1];
		PayModeIDObj.value = myarray[2];
	}
}

function initBankType() {
	DHCWebD_ClearAllListA("BankCardTypeList");
	var encmeth = DHCWebD_GetObjValue("ReadBankCardType");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "BankCardTypeList");
	}
}

function initBank() {
	DHCWebD_ClearAllListA("BankList");
	var encmeth = DHCWebD_GetObjValue("ReadBankEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "BankList");
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
	m_CardNoLength = myary[17];

	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.disabled = false;
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	} else {
		//m_CCMRowID = GetCardEqRowId();
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.disabled = true;
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		websys_setfocus('CardNo');
	} else {
		websys_setfocus('ReadCard');
	}
	if (combo_CardType) {
		websys_nexttab(combo_CardType.tabIndex);
	}
	var selectedIndex = combo_CardType.getSelectedIndex();
}

function disabledItem() {
	if (PatNameObj) {
		PatNameObj.readOnly = true;
		PatNameObj.disabled = true;
	}
	if (InsTypeObj) {
		InsTypeObj.readOnly = true;
		InsTypeObj.disabled = true;
	}
	if (patLocObj) {
		patLocObj.readOnly = true;
		patLocObj.disabled = true;
	}
	if (patWardObj) {
		patWardObj.readOnly = true;
		patWardObj.disabled = true;
	}
	if (patBedObj) {
		patBedObj.readOnly = true;
		patBedObj.disabled = true;
	}
	if (admDateObj) {
		admDateObj.readOnly = true;
		admDateObj.disabled = true;
	}
	if (patAddressObj) {
		patAddressObj.readOnly = true;
		patAddressObj.disabled = true;
	}
	if (patPhoneObj) {
		patPhoneObj.readOnly = true;
		patPhoneObj.disabled = true;
	}
	if (BalanceObj) {
		BalanceObj.readOnly = true;
		BalanceObj.disabled = true;
	}
	if (AdmListObj) {
		AdmListObj.onkeydown = function () {
			return false;
		}
	}
}

function amt_onkeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (amtObj.value != "") {
			websys_setfocus('AddDeposit');
		}
	}
}

function UDHCEPMAddDeposit_OnDBClick() {
	var selectrow = DHCWeb_GetRowIdx(window);
	var myPreRowID = DHCWeb_GetColumnData("TAccPreDepRowID", selectrow);
	var myAmt = DHCWeb_GetColumnData("Tamt", selectrow);
	if (eval(myAmt) < 0) {
		alert('退款记录请到【急诊留观退押金】界面重打.');
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

function getpatbycard() {
	if (CardNoObj.value != "") {
		var myCardNo = FormatCardNo(CardNoObj.value);
		CardNoObj.value = myCardNo;
		var p1 = myCardNo;
		var p2 = CardVerify;
		//2015-2-28 hujunbin 判断卡是否有效
		var cardInfo = tkMakeServerCall("web.DHCOPBillEPManageCLS", "getaccinfofromcardno", p1, p2, m_SelectCardTypeRowID, "", "", "");
		if (cardInfo.split("^")[0] == "-200") {
			alert("无此卡号的病人");
			return;
		}
		var encmeth = DHCWebD_GetObjValue('getpatclass');
		if (cspRunServerMethod(encmeth, 'setpatinfo_val', '', "", "", p1, p2, "") == '1') {}

	}
}

function getpatbyregno(regno) {
	if (regno == "") {
		return;
	}
	var p1 = regno;
	var encmeth = DHCWebD_GetObjValue('getpatclass');
	if (cspRunServerMethod(encmeth, 'setpatinfo_val', '', p1, "", "", "", "") == '1') {}
}

function getpatbyRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (RegNoObj.value != "") {
			getpatbyregno(RegNoObj.value);
		}
	}
}

function getpatbyadm() {
	var adm = AdmIDObj.value;
	if (adm == "") {
		return;
	}
	var p1 = adm;
	var rtn = tkMakeServerCall("web.DHCOPBillEPManageCLS", "getpatinfo", "setpatinfo_val", "", "", "", "", "", p1);

}

function setpatbyadm() {
	var adm = AdmIDObj.value;
	if (adm == "") {
		return;
	}
	var p1 = adm;
	var rtn = tkMakeServerCall("web.DHCOPBillEPManageCLS", "getpatinfo", "setpatinfo_val2", "", "", "", "", "", p1);
}

function setpatinfo_val(value) {
	//s str=RegNo_"^"_Papmi_"^"_name_"^"_zyno_"^"_telphone_"^"_foreign  					;1-5
	//s str=str_"^"_foreignphone_"^"_workaddress_"^"_deptdesc_"^"_warddesc_"^"_bedno    	;6-10
	//s str=str_"^"_admreasondesc_"^"_admdate_"^"_epmNo_"^"_epmID_"^"_Balance				;11-15
	//s str=str_"^"_CredTypeID_"^"_IDCardNo_"^"_epmStatus_"^"_AccStatusName_"^"_myErrCode	;16-20
	var val = value.split("^");
	if (val[0] == "") {
		alert(t[2001]);
		websys_setfocus('RegNo');
		return;
	}
	if (val[23] > 1) {
		RegNoObj.value = val[0];
		alert("该病人有效就诊不唯一，不能根据卡号或登记号进行收退押金");
		return;
	}
	if (val[23] == 0) {
		RegNoObj.value = val[0];
		PapmiObj.value = val[1];
		PatNameObj.value = val[2];
		patAddressObj.value = val[22];
		patPhoneObj.value = val[4];
		alert("该病人当前留观已出院或无留观就诊，请选择就诊列表进行收退押金");
		return;
	}
	AccountIDObj.value = val[14];
	if (AccountIDObj.value == "" || val[18] != "N") {
		websys_setfocus('RegNo');
	}
	RegNoObj.value = val[0];
	PapmiObj.value = val[1];
	PatNameObj.value = val[2];
	AdmIDObj.value = val[21];
	BalanceObj.value = val[15];
	patLocObj.value = val[8];
	patWardObj.value = val[9];
	patBedObj.value = val[10];
	patAddressObj.value = val[22];
	patPhoneObj.value = val[4];
	admDateObj.value = val[12];
	InsTypeObj.value = val[11];

	//escape(PatNameObj.value)
	/*
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillEPMRefundDeposit&AccountID=' + AccountIDObj.value;
	lnk = lnk + '&CardNo=' + CardNoObj.value + '&RegNo=' + RegNoObj.value + '&PatName=' + PatNameObj.value;
	lnk = lnk + "&AdmID=" + AdmIDObj.value + "&patLoc=" + patLocObj.value + "&patWard=" + patWardObj.value;
	lnk = lnk + "&patBed=" + patBedObj.value + "&patAddress=" + patAddressObj.value + "&patPhone=" + patPhoneObj.value;
	lnk = lnk + "&admDate=" + admDateObj.value + "&Papmi=" + PapmiObj.value + "&InsType=" + InsTypeObj.value;
	*/
	var stayFlag = checkAdmStayStat(AdmIDObj.value);
	if (stayFlag != "Y") {
		alert("此病人为非留观病人！");
	}
	refresh();
	websys_setfocus('amt');
	//AccountBalanceObj.value=val[6];
	//AccountStatusObj.value=val[3];
	//DepPriceObj.value=val[7];
}
function setpatinfo_val2(value) {
	//s str=RegNo_"^"_Papmi_"^"_name_"^"_zyno_"^"_telphone_"^"_foreign  					;1-5
	//s str=str_"^"_foreignphone_"^"_workaddress_"^"_deptdesc_"^"_warddesc_"^"_bedno    	;6-10
	//s str=str_"^"_admreasondesc_"^"_admdate_"^"_epmNo_"^"_epmID_"^"_Balance				;11-15
	//s str=str_"^"_CredTypeID_"^"_IDCardNo_"^"_epmStatus_"^"_AccStatusName_"^"_myErrCode	;16-20
	var val = value.split("^");
	if (val[0] == "") {
		alert(t[2001]);
		websys_setfocus('RegNo');
		return;
	}
	if (val[23] > 1) {
		RegNoObj.value = val[0];
		alert("该病人有效就诊不唯一，请选择就诊");
		return;
	}
	AccountIDObj.value = val[14];
	if (AccountIDObj.value == "" || val[18] != "N") {
		websys_setfocus('RegNo');
	}
	RegNoObj.value = val[0];
	PapmiObj.value = val[1];
	PatNameObj.value = val[2];
	AdmIDObj.value = val[21];
	BalanceObj.value = val[15];
	patLocObj.value = val[8];
	patWardObj.value = val[9];
	patBedObj.value = val[10];
	patAddressObj.value = val[22];
	patPhoneObj.value = val[4];
	admDateObj.value = val[12];
	InsTypeObj.value = val[11];
	websys_setfocus('amt');
}

function getCurrAcountID() {
	var p1 = AdmIDObj.value;
	var rtn = tkMakeServerCall("web.DHCOPBillEPManageCLS", "getCurrAcountID", p1);
	var rtnArr = rtn.split("^");
	if (rtnArr[0] == 0) {
		AccountIDObj.value = rtnArr[1];
	}
}

function getAccBalance() {
	if (AccountIDObj.value != "") {
		var p1 = AccountIDObj.value;
		var encmeth = DHCWebD_GetObjValue('getBalanceClass');
		var ren = cspRunServerMethod(encmeth, p1);
		BalanceObj.value = ren;
	} else {
		BalanceObj.value = 0;
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

function RePrtBillNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	DHCP_GetXMLConfig("DepositPrintEncrypt", PrtXMLName);
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
	DHCP_GetXMLConfig("DepositPrintEncrypt", PrtXMLName);
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

function SetPayInfoStatus(SFlag) {
	CompanyObj.disabled = SFlag;
	BankListObj.disabled = SFlag;
	BankCardTypeListObj.disabled = SFlag;
	CardChequeNoObj.disabled = SFlag;
	ChequeDateObj.disabled = SFlag;
	//+2017-08-29 ZhYW 隐藏"支票日期"日期控件
	var chequeDateImgObj = null;
	var Myobj = websys_$('Myid');
	if (Myobj) {
		var imgname = 'ld' + Myobj.value + 'i' + 'ChequeDate';
		chequeDateImgObj = websys_$(imgname);
	}
	if (SFlag) {
		CompanyObj.value = "";
		BankListObj.value = "";
		BankCardTypeListObj.value = "";
		CardChequeNoObj.value = "";
		ChequeDateObj.value = "";
		if (chequeDateImgObj) {
			chequeDateImgObj.style.display = 'none';
		}
	} else {
		if (chequeDateImgObj) {
			chequeDateImgObj.style.display = '';
		}
	}
}

function getpaymodeid(value) {
	var val = value.split("^");
	PayModeIDObj.value = val[1];
}

function getbankcardtypeid(value) {
	var val = value.split("^");
	BankCardTypeIDObj.value = val[1];
}

function getbankid(value) {
	var val = value.split("^");
	BankIDObj.value = val[1];
}

function IsNumber(string, sign) {
	var number;
	if (string == null)
		return false;
	if ((sign != null) && (sign != '-') && (sign != '+')) {
		return false;
	}
	number = new Number(string);
	if (isNaN(number)) {
		return false;
	} else if ((sign == null) || (sign == '-' && number < 0) || (sign == '+' && number > 0)) {
		return true;
	} else {
		return false;
	}
}

function ClsWinDoc() {
	DHCWebD_SetObjValueA("CardNo", "");
	DHCWebD_SetObjValueA("RegNo", "");
	DHCWebD_SetObjValueA("PatName", "");
	DHCWebD_SetObjValueA("amt", "");
	DHCWebD_SetObjValueA("Balance", "");
	DHCWebD_SetObjValueA("ReceiptsNo", "");
	DHCWebD_SetObjValueA("Company", "");
	DHCWebD_SetObjValueA("CardChequeNo", "");
	DHCWebD_SetObjValueA("PayAccNo", "");
	DHCWebD_SetObjValueA("Remark", "");
	DHCWebD_SetObjValueA("AccountID", "");
	DHCWebD_SetObjValueA("AdmID", "");
	DHCWebD_SetObjValueA("patLoc", "");
	DHCWebD_SetObjValueA("patWard", "");
	DHCWebD_SetObjValueA("patBed", "");
	DHCWebD_SetObjValueA("patAddress", "");
	DHCWebD_SetObjValueA("patPhone", "");
}

function ableAddClick() {
	if (AddDepositObj) {
		AddDepositObj.readOnly = false;
		DHCWeb_AvailabilityBtnA(AddDepositObj, AddDeposit_Click);
	}
}

function initRowColor() {
	var Objtbl = document.getElementById('tDHCOPBillEPMAddDeposit');
	var Rows = Objtbl.rows.length;
	for (var i = 1; i <= Rows - 2; i++) {
		var SelRowObj = document.getElementById('Tamtz' + i);
		var amt = SelRowObj.innerText;
		if (eval(amt) < 0) {
			Objtbl.rows[i].style.background = '#FFEBCD';
		}
	}
}
function PatCal_OnClick() {
	FootExpCalculate();
}

function FootExpCalculate() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	var NewWin = open(lnk, "udhcOPCashExpCal", "scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}

function initReceiptNo() {
	var grp = session['LOGON.GROUPID'];
	var guser = session['LOGON.USERID'];
	if (ReceiptsNoObj) {
		ReceiptsNoObj.readOnly = true;
		ReceiptsNoObj.disabled = true;
		var grpsetting = tkMakeServerCall("web.DHCOPConfig", "GetOPBaseConfigForGroupNew", grp);
		if (grpsetting == 101) {
			return;
		}
		var settingArr = grpsetting.split("^");
		var receiptType = "";
		if (settingArr[0] == 0) {
			receiptType = settingArr[28];
		}
		if (receiptType != "") {
			var rtn = tkMakeServerCall("web.DHCOPBillEPAddDeposit", "GetCurrentRecNo", guser, grp, receiptType);
			var rtnArr = rtn.split("^");
			if (rtnArr[0] == 0) {
				ReceiptsNoObj.value = rtnArr[3];
			} else {
				alert("无可用发票票据");
				return;
			}
		}
	}
}

//判断是否留观状态
function checkAdmStayStat(adm) {
	var stayStatStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatAdmStayStat", adm);
	var stayStatFlag = stayStatStr.split("^")[0];
	return stayStatFlag;
}

function selectAdm() {
	AdmIDObj.value = AdmListObj.value;
	setpatbyadm();
	refresh();
}

function refresh() {
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillEPMAddDeposit&AccountID=' + AccountIDObj.value + "&AdmID=" + AdmIDObj.value + "&AdmList=" + AdmIDObj.value;
	location.href = lnk;
}

function SelectRowHandler() {
	var selectrow = DHCWeb_GetRowIdx(window);
	if (selectrow != m_SelectedRow) {
		m_SelectedRow = selectrow;
		var myPreRowID = DHCWeb_GetColumnData("TAccPreDepRowID", selectrow);
		if (myPreRowID != "") {
			DHCWebD_SetObjValueB("AccPreDepRowID", myPreRowID);
			var obj = document.getElementById("RePrint");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, RePrint_Click);
			}
		}else {
			DHCWeb_DisBtnA("RePrint");
		}
	}else {
		m_SelectedRow = "";
		DHCWebD_SetObjValueB("AccPreDepRowID", "");
		DHCWeb_DisBtnA("RePrint");
	}
}

document.body.onload = BodyLoadHandler;
