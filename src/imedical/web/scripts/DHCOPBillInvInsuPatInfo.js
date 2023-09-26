/// DHCOPBillInvInsuPatInfo.js
/// Lid
/// 2014-07-08

var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_YBConFlag = 0;
var YBSelfPayMon = "";
var PrtXMLName = "";

function BodyLoadHandler() {
	var obj = document.getElementById("ReadCard");
	if (obj) {
		obj.onclick = ReadHFMagCard_Click;
	}
	var obj = document.getElementById("PAPMINo");
	if (obj) {
		obj.onkeydown = PAPMINo_KeyPress;
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
	DHCWebD_SetObjValueB("SelAll", true); //zhho
	var obj = document.getElementById("SelAll");
	if (obj) {
		obj.onclick = SelAll_OnClick;
	}
	var obj = document.getElementById("GHFLag");
	if (obj) {
		obj.onclick = SetSel_OnClick;
	}
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
	var obj = document.getElementById('BtnInvPrint');
	if (obj) {
		obj.onclick = BtnInvPrint_OnClick;
	}
	IntDocument();
	GetReceiptNo();
	DHCWeb_setfocus("ReadCard");
}

function BtnInvPrint_OnClick() {
	var BtnInvPrintobj = document.getElementById("BtnInvPrint");
	if (BtnInvPrintobj) {
		DHCWeb_DisBtn(BtnInvPrintobj);
	}
	var myGuserDr = session['LOGON.USERID'];
	var myGroupDr = session['LOGON.GROUPID'];
	var myCTLocDr = session['LOGON.CTLOCID'];
	var myHospitalDr = session['LOGON.HOSPID'];
	var mywin = parent.frames["DHCOPBillInvInsuList"].window;
	var myPLInfo = mywin.BulidPLStr();
	//alert(myPLInfo);
	if (myPLInfo == "") {
		alert("请选择支付记录！");
		return;
	}
	var invCount = myPLInfo.split("!").length;
	//循环打印发票
	var UnYBPatTypeobj = document.getElementById('UnYBPatType');
	var UnYBPatType = UnYBPatTypeobj.checked;
	alert("即将打印" + (invCount - 1) + "张发票");
	for (var i = 0; i < invCount - 1; i++) {
		var tmpInvAry = myPLInfo.split("!")[i].split("^");
		var plRowID = tmpInvAry[0];
		var prtRowID = tmpInvAry[1];
		var fairType = tmpInvAry[2];
		var insTypeDR = tmpInvAry[3];
		var admSource = tmpInvAry[4];
		var RegInsuFlag = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "CheckRegInsu", prtRowID);
		if (RegInsuFlag != "Y") {
			var BoolRtn = window.confirm("本次缴费的挂号尚未医保分解,是否打印自费发票");
			if (!BoolRtn) {
				break;
			} else {
				//UnYBPatTypeobj.checked = true;
				UnYBPatType = true; //UnYBPatTypeobj.checked;
			}
		}
		var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
		var insuChargeFlag = InsuCharge.split("^")[0];  //已经分解的小条不再上传发票
		if ((admSource > 0) && (RegInsuFlag == "Y") && (UnYBPatType == false) && (insuChargeFlag == "0")) {
			//调用医保接口
			//挂号不调用医保接口
			//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DYLB^总余额^操作员ID^科室ID^医院ID！Money^MoneyType！Money^MoneyType
			var myYBHand = "";
			var myCPPFlag = "A"; //空：普通门诊收费，Y:集中打印发票，A:支付宝集中打印发票
			var LeftAmt = "";
			var StrikeFlag = "N";
			var GroupDR = myGroupDr;
			var InsuNo = "";
			var CardType = ""; //""document.getElementById('cardMode').value;
			var YLLB = "";
			var DicCode = ""; //document.getElementById('InsurDiagnos').value;
			var PatAdmStat = "";
			var DYLB = "";
			var MoneyType = ""; //卡类型
			var YDFLAG = ""; //document.getElementById('YDFlg').value;
			var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
			//var myExpStrYB = StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^"+DYLB+"^"+"^^^^"+YDFLAG+"^"+LeftAmtStr
			var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
			var myYBINS = admSource;
			var myCurrentInsType = insTypeDR;
			//alert("准备调用医保"+myYBHand+"=="+myCPPFlag+"=="+prtRowID+"=="+myYBExpStr+"=="+myYBINS+"=="+PatAdmStat)
			var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myCPPFlag, prtRowID, myYBExpStr, myYBINS, PatAdmStat);
			//var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand,myGuserDr, prtRowID, myYBINS,myCurrentInsType,myExpStrYB, myCPPFlag);
			//alert(myYBrtn)
			var myYBarry = myYBrtn.split("^");
			if (myYBarry[0] == "YBCancle") {
				alert("支付记录号:" + prtRowID + ", 医保分解失败!需要重新分解");
				return;
			}
			if (myYBarry[0] == "HisCancleFailed") {
				alert("支付记录号:" + prtRowID + ", 医保分解失败!需要重新分解");
				return;
			}
		}
		//打印发票
		var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
		var papmiDr = DHCWebD_GetObjValue("PAPMIRowID");
		var accMDr = DHCWebD_GetObjValue("PAPMIRowID");
		var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
		//alert(myrtn);
		if ((admSource == 0) || (UnYBPatType == true) || (admSource == "") || (admSource == "0")) {
			BillPrintNew(myrtn);
		}
		alert("第" + (i + 1) + "打印完毕");
	}
	ClearWin_Click();
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		alert("未找到发票模版!");
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("ReadINVDataEncrypt");
			var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], Guser, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	TxtInfo = TxtInfo + "^" + "APIFlag" + String.fromCharCode(2) + "(集)";
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
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
	//var CardTypeValue = combo_CardType.getActualValue();
	var CardTypeValue = combo_CardType.getSelectedValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^")
			CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId() {
	var CardEqRowId = "";
	//var CardTypeValue = DHCC_GetElementData("CardType");
	var CardTypeValue = combo_CardType.getSelectedValue();
	//var CardTypeValue = combo_CardType.getActualValue();
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardEqRowId = CardTypeArr[14];
	}
	return CardEqRowId;
}

function GetCardNoLength() {
	var CardNoLength = "";
	//var CardTypeValue = DHCC_GetElementData("CardType");
	var CardTypeValue = combo_CardType.getSelectedValue();
	//var CardTypeValue = combo_CardType.getActualValue();
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
	//var myoptval = combo_CardType.getActualValue();
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	//Read Card Mod
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	} else {
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

function GetReceiptNo() {
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	var myPINVFlag = "Y";
	var myExpStr = Guser + "^" + myPINVFlag + "^" + Group;
	var encmeth = DHCWebD_GetObjValue("GetreceipNO");
	if (cspRunServerMethod(encmeth, "SetReceipNO", "", myExpStr) != 0) {
		alert("操作员没有可用的票据!");
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
	DHCWebD_SetObjValueA("INVLeftNum", myary[2]);
	if (myary[1] != "0") {
		obj.className = 'clsInvalid';
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
			obj.disabled = false;
			obj.onclick = ReadHFMagCard_Click;
		}
		document.onkeydown = Doc_OnKeyDown;
	}
}

function IntDocument() {
	DHCWebD_ClearAllListA("InsType");
	var encmeth = DHCWebD_GetObjValue("ReadPatTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "InsType");
	}
	combo_CardTypeKeydownHandler();

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
		//Get ColPrtXMLName
		var myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName); //INVPrtFlag
	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
	}
	var myary = myrtn.split("^");
	m_YBConFlag = myary[9];
}

function SelAll_OnClick() {
	var myvalue = DHCWebD_GetObjValue("SelAll");
	var Prtobj = parent.frames['DHCOPBillInvInsuList'];
	var mywin = Prtobj.window;
	mywin.SelectAll(myvalue);
}

function PAPMINo_KeyPress() {
	var key = event.keyCode;
	if (key == 13) {
		var PAPMINo = DHCWebD_GetObjValue("PAPMINo");
		if (PAPMINo == "") {
			return;
		}
		var CardNo = "";
		var SecurityNo = "";
		var encmeth = DHCWebD_GetObjValue("ReadPatInfo");
		var myrtn = (cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo));
		var myary = myrtn.split("^");
		DHCWebD_SetObjValueB("PAPMIRowID", myary[19]);
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
}

function CardNo_KeyPress() {
	var key = event.keyCode;
	if (key == 13) {
		var CardNo = DHCC_GetElementData("CardNo");
		if (CardNo == "") {
			return;
		}
		var CardTypeRowId = GetCardTypeRowId();
		/*
		if (CardTypeRowId != "") {
			CardNo = FormatCardNo();
		}
		*/
		CardNo = FormatCardNo();
		DHCWebD_SetObjValueB("CardNo", CardNo);
		//var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardNo, "", "");
		var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardNo, "", "PatInfo");
		//var myrtn = DHCACC_GetAccInfo(CardTypeRowId,CardNo,"0","");	 //默认校验码是0
		var myary = myrtn.split("^");
		//alert("myrtn=" + myrtn);
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("SecurityNo", myary[2]);
			DHCWebD_SetObjValueB("PAPMIRowID", myary[4]);
			DHCWebD_SetObjValueB("PAPMINo", myary[5]);
			ReadPatAccInfo();
			//Account Can Pay
			break;
		case "-200":
			alert("无效卡");
			break;
		case "-201":
			//alert("请使用支付宝绑定的卡");
			DHCWebD_SetObjValueB("PAPMIRowID", myary[4]);
			DHCWebD_SetObjValueB("PAPMINo", myary[5]);
			ReadPatAccInfo();
			break;
		default:
			//alert("");
		}
	}
}

function ClearWin_Click() {
	DHCWebD_SetObjValueB("AccRowID", "");
	DHCWebD_SetObjValueB("PAPMIRowID", "");
	PatAccInfoClr();
	RefreshDoc();
	//PatPayINVPrtForPrt("","");
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = combo_CardType.getSelectedValue();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
	//alert(myrtn);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		DHCWebD_SetObjValueB("SecurityNo", myary[2]);
		DHCWebD_SetObjValueB("PAPMIRowID", myary[4]);
		DHCWebD_SetObjValueB("PAPMINo", myary[5]);
		ReadPatAccInfo();
		//Account Can Pay
		break;
	case "-200":
		alert("无效卡");
		break;
	case "-201":
		alert("请使用支付宝绑定的卡");
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
	if (myary[0] == -201) {
		myary[0] = 0;
	}
	if (myary[0] == 0) {
		WrtPatAccInfo(myrtn);
		/*
		var myrtn = CheckPRTFlag();
		if (!myrtn) {
			return;
		}
		*/
		RefreshDoc();
	} else {
		alert(t[myary[0]]);
	}
}

function WrtPatAccInfo(myPAInfo) {
	var myary = myPAInfo.split("^");
	DHCWebD_SetObjValueB("PAPMINo", myary[1]);
	DHCWebD_SetObjValueB("PAName", myary[2]);
	DHCWebD_SetObjValueB("PatSex", myary[3]);
	DHCWebD_SetObjValueB("PatAge", myary[4]);
	DHCWebD_SetObjValueB("CredType", myary[5]);
	//DHCWebD_SetObjValueB("CredNo", myary[6]);
	DHCWebD_SetObjValueB("AccLeft", myary[7]);
	DHCWebD_SetObjValueB("AccStatus", myary[8]);
	DHCWebD_SetObjValueB("AccNo", myary[9]);
	DHCWebD_SetObjValueB("AccOCDate", myary[10]);
	DHCWebD_SetObjValueB("BadPrice", myary[11]);
	DHCWebD_SetObjValueB("AccDep", myary[12]);
	DHCWebD_SetObjValueB("AccRowID", myary[13]);
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
		//alert(t["DepPTip"]);
		//return false;
	}
	return true;
}

function RefreshDoc() {
	var myFrameFlag = DHCWebD_GetObjValue("FrameFlag");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	switch (myFrameFlag) {
	case "ColPrt":
		PayListForPrt(myAccRowID);
		break;
	}
}

function PayListForPrt(AccRowID) {
	var myUnYBFlag = 0;
	var obj = document.getElementById("UnYBPatType");
	if (obj) {
		if (obj.checked) {
			myUnYBFlag = 1;
		}
	}
	var PAPMIRowID = document.getElementById("PAPMIRowID").value;
	var StDate = document.getElementById("StDate").value;
	var EndDate = document.getElementById("EndDate").value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillInvInsuList&AccRowID=" + AccRowID;
	lnk += "&INVPrtFlag=N" + "&INVFlag=N" + "&FUserDR=" + "&FootFlag=";
	lnk += "&FrameFlag=ColPrt";
	lnk += "&UnYBPatType=" + myUnYBFlag;
	lnk += "&PAPMIRowID=" + PAPMIRowID;
	lnk += "&StDate=" + StDate;
	lnk += "&EndDate=" + EndDate;
	var plobj = parent.frames['DHCOPBillInvInsuList'];
	plobj.location.href = lnk;
}

function PatAccInfoClr() {
	var myFrameFlag = DHCWebD_GetObjValue("FrameFlag");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillInvInsuPatInfo&FrameFlag=" + myFrameFlag;
	window.location.href = lnk;
}

document.body.onload = BodyLoadHandler;
