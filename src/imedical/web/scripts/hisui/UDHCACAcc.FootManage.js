/// UDHCACAcc.FootManage.js

var m_PrtXMLName = "";  //XML Stream Mode Name
var m_YBConFlag = "0";  //default not Connection YB
var m_SelectCardTypeRowID = "";
var m_CardReclaim = "0";
var CardCostFlag = "";
var m_CardNoLength = 0;
var m_ReadCardMode = "";

$(function () {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");

	$("#ReadCard").linkbutton({
		onClick: function() {
			ReadHFMagCard_Click();
		}
	});
	
	$HUI.combobox("#PayMode", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = session['LOGON.GROUPID'];
			param.HospID = session['LOGON.HOSPID'];
			param.TypeFlag = "DEP";
		},
		onLoadSuccess: function(data) {
			$.each(data, function (index, item) {
				if (item.selected) {
					SetPayInfoStatus((item.RPFlag == "Y"));
					return false;
				}
			});
		},
		onSelect: function (rec) {
			SetPayInfoStatus((rec.RPFlag == "Y"));
		}
	});
	
	$HUI.combobox("#Bank", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&JSFunName=GetBankToHUIJson",
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text'
	});
	
	$HUI.combobox("#FootType", {
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		data: [{id: "P", text: "缴款"},
			   {id: "R", text: "退款"}]
	});
	
	$HUI.combobox("#InsType", {
		panelHeight: 180,
		url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadPatType&JSFunName=GetPatTypeToHUIJson",
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.SessionStr = getSessionStr();
		}
	});
	
	$("#Calculate").linkbutton({
		onClick: function() {
			Calculate_Click();
		}
	});
	
	$("#ClearWin").linkbutton({
		onClick: function() {
			Clear_OnClick();
		}
	});
	
	$("#PreDList").linkbutton({
		onClick: function () {
			PreDList_OnClick();
		}
	});
	
	$("#APayList").linkbutton({
		onClick: function() {
			APayList_OnClick();
		}
	});
	
	$("#UnPrtDetails").linkbutton({
		onClick: function() {
			UnPrtDetails_OnClick();
		}
	});
	
	$("#CardNo").keydown(function(e) {
		CardNo_OnKeyPress(e);
	});
	
	$("#ReturnSum").linkbutton({
		onClick: function() {
			ReturnSum_OnKeyPress();
		}
	});
	
	disableById("bRePrint");
	disableById("bPRTDetail");
	disableById("bParkPrint");
	
	$("#bParkPrint").linkbutton({
		onClick: function() {
			bParkPrint_OnClick();
		}
	});

	$("#Foot").linkbutton({
		disabled: true,
		onClick: function() {
			Foot_OnClick();
		}
	});
		
	$("#CardTypeDefine").combobox({
		panelHeight: 'auto',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		valueField: 'value',
		textField: 'caption',
		editable: false,
		onChange: function(newVal, oldVal) {
			CardTypeDefine_OnChange();
		}
	});
	
	IntDoc();
	
	document.onkeydown = Doc_OnKeyDown;

	focusById("CardNo");
});

function bRePrint_OnClick() {
	var myACINVStr = getValueById("APINVStr");
	DHCP_GetXMLConfig("InvPrintEncrypt", m_PrtXMLName);
	BillPrintNew(myACINVStr);
	DHCWeb_DisBtnA("bRePrint");
}

function bParkPrint_OnClick() {
	RefundSaveInfo("A");
}

function RefundSaveInfo(RefundFlag) {
	var myACINVStr = getValueById("APINVStr");
	var INVtmp = myACINVStr.split("^");
	for (var i = 0; i < INVtmp.length; i++) {
		var myAPIRowID = INVtmp[i];
		if (myAPIRowID != "") {
			break;
		}
	}
	//PrtStr
	var myUser = session['LOGON.USERID'];
	if (myAPIRowID == "") {
		return;
	}
	var encmeth = getValueById("BuildOrdStr");
	var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, myUser, "");
	var mytmpary = rtnvalue.split(String.fromCharCode(5));
	var myAPIRowID = mytmpary[1];
	var PrtStr = mytmpary[2];
	var m_RebillFlag = 1;
	//var myAPIRowID = getValueById("OldAccPayINVRowID");
	if (myAPIRowID == "") {
		return;
	}
	//RefundFlag
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myAry = mystr.split("^");
	var myPayModeDR = myAry[0];
	var myRefPaySum = getValueById("RefundSum");
	var myExpStr = "";
	var encmeth = getValueById("SaveParkDataEncrypt");
	if (encmeth != "") {
		var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, PrtStr, myUser, RefundFlag, gloc, myUserLocID, myPayModeDR, myRefPaySum, m_RebillFlag, myExpStr);
		var myAry = rtnvalue.split(String.fromCharCode(2));
		var rtn = myAry[0].split("^");
		if (rtn[0] == '0') {
			//Set CID  for  YB
			setValueById("CID", myAry[2]);
			//var mystr = YBInsDiv();
			DHCP_GetXMLConfig("InvPrintEncrypt", m_PrtXMLName);
			BillPrintNew(myAry[1]);
			return true;
		} else {
			switch (rtn[0]) {
			case 109:
				DHCWeb_HISUIalert(t['08']);
			default:
				DHCWeb_HISUIalert("补打失败:" + rtn[0]);
			}
			return false;
		}
	}
}

function CardNo_OnKeyPress(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = getValueById("CardNo");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardNo, mySecurityNo, "");
		var myAry = myrtn.split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("CardNo", myAry[1]);
			setValueById("SecurityNo", myAry[2]);
			setValueById("PAPMINo", myAry[5]);
			ReadPatAccInfo();
			GetCardFareCost(m_SelectCardTypeRowID, myAry[1]);
			break;
		case "-200":
			DHCWeb_HISUIalert(t["-200"]);
			break;
		case "-201":
			DHCWeb_HISUIalert(t["-201"]);
			break;
		default:
			//DHCWeb_HISUIalert("");
		}
	}
}

function Foot_OnClick() {
	//disableById("Foot");
	var myAccRowID = getValueById("AccRowID");
	if (myAccRowID == "") {
		DHCWeb_HISUIalert("账户不存在,请读卡重试");
		return;
	}
	var rtn = CheckFoot();
	if (!rtn) {
		enableById("Foot");
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "CheckUnPrintINV", myAccRowID);
	if (rtn != "0") {
		var myrtn = HISUI_Confirm("存在未打印发票,请确认纸质发票已放好并打印");
		if (!myrtn) {
			enableById("Foot");
			return;
		}
	}
	//Foot
	var myUserDR = session['LOGON.USERID'];
	var myCTLocDr = session['LOGON.CTLOCID'];
	var myHospDr = session['LOGON.HOSPID'];
	var myBadPrice = getValueById("BadPrice");
	var myPDInfo = BuildPDInfo();
	var myPDPMInfo = BuildPDMInfo();
	var myCardRowID = getValueById("CardFRowID");
	var myExpStr = myCardRowID + "^" + session['LOGON.GROUPID'] + "^" + m_CardReclaim + "^" + myCTLocDr + "^" + myHospDr;
	var encmeth = getValueById("FootEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, myAccRowID, myUserDR, myBadPrice, myPDInfo, myPDPMInfo, myExpStr);
	}
	//Print
	var myAry = myrtn.split(String.fromCharCode(2));
	if (myAry[0] == "0") {
		//print DHC_AccINVPay
		//Print Patient Pay List and PreDeposit List
		DHCP_GetXMLConfig("InvPrintEncrypt", m_PrtXMLName);
		BillPrintNew(myAry[1]);
		
		if (myAry.length > 2) {
			if (myAry[2] != "") {
				CardCostFlag = "";
				PatRegPatInfoPrint(myAry[2], "UDHCAccDeposit", "ReadAccDPEncrypt");
			}
		}
		if (myAry.length > 3) {
			if ((m_CardReclaim == "1") && (myAry[3] != "")) {
				CardCostFlag = "Y";
				PatRegPatInfoPrint(myAry[3], "UDHCCardInvPrt", "ReadAccCarDPEncrypt");
			}
		}
		enableById("bPRTDetail");
		enableById("bRePrint");
		enableById("bParkPrint");
		setValueById("APINVStr", myAry[1]);
		DHCWeb_HISUIalert(t["FootOK"]);
	} else {
		DHCWeb_HISUIalert("结算失败, 错误代码:" + myAry[0]);
		enableById("Foot");
	}
}

function ReturnSum_OnKeyPress() {
	DHCWeb_SetLimitFloat();
}

function UnPrtDetails_OnClick() {
	var myAccRowID = getValueById("AccRowID");
	AccUnPrtDetails(myAccRowID);
}

function Clear_OnClick() {
	$(":text:not(#ReceiptNO)").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	$(".checkbox-f").checkbox("setValue", false);
}

function PreDList_OnClick() {
	var myAccRowID = getValueById("AccRowID");
	AccPreList(myAccRowID);
}

function APayList_OnClick() {
	var myAccRowID = getValueById("AccRowID");
	AccPayList(myAccRowID);
}

function IntDoc() {
	GetReceiptNo();
	
	var myPrtXMLName = "";
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myAry = myrtn.split("^");
	if (myAry[0] == 0) {
		myPrtXMLName = myAry[11];
	}
	m_PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);

	var myHospDr = session['LOGON.HOSPID'];
	var encmeth = getValueById("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, myHospDr);
	}
	var myAry = myrtn.split("^");
	m_YBConFlag = myAry[9];
	
	disableById("Foot");
}

function getSessionStr() {
	var myAry = [];
	myAry[4] = session['LOGON.HOSPID'];
	var sessionStr = myAry.join("^");
	return sessionStr;
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = getValueById("CardTypeDefine");
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
	var myAry = myrtn.split("^");
	var rtn = myAry[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		setValueById("CardNo", myAry[1]);
		setValueById("SecurityNo", myAry[2]);
		setValueById("PAPMINo", myAry[5]);
		ReadPatAccInfo();
		GetCardFareCost(m_SelectCardTypeRowID, myAry[1]);
		//Account Can Pay
		break;
	case "-200":
		DHCWeb_HISUIalert(t["-200"]);
		break;
	case "-201":
		DHCWeb_HISUIalert(t[rtn]);
		break;
	default:
		//DHCWeb_HISUIalert("");
	}
}

function CheckFoot() {
	//1  Check  Pay Mode
	//2  Check have Bad Price????
	var rtn = true;
	if (HISUI_Confirm(t["CardReclaim"])) {
		m_CardReclaim = "1";
	} else {
		m_CardReclaim = "0";
	}
	var myPayMode = getValueById("PayMode");
	var myAry = myPayMode.split("^");
	if (myAry[1] == "1") {
		//check
		var myCardChequeNo = getValueById("CardChequeNo");
		var myBank = getValueById("Bank");
		if (myCardChequeNo == "") {
			DHCWeb_HISUIalert(t["ReqCheque"]);
			websys_setfocus("CardChequeNo");
			return false;
		}
		if (myBank == "") {
			DHCWeb_HISUIalert(t["ReqBank"]);
			websys_setfocus("Bank");
			return false;
		}
	} else {
	}

	//check if have BadPrice
	var myAccLeft = getValueById("AccLeft");
	if (isNaN(myAccLeft)) {
		myAccLeft = 0;
	}
	var myReturnSum = getValueById("ReturnSum");
	if (isNaN(myReturnSum)) {
		myReturnSum = 0;
	}

	myAccLeft = parseFloat(myAccLeft);
	myAccLeft = myAccLeft.toFixed(2);
	myReturnSum = parseFloat(myReturnSum);
	myReturnSum = myReturnSum.toFixed(2);

	if (myReturnSum != myAccLeft) {
		var myrtn = HISUI_Confirm(t["BadPTip"]);
		rtn = myrtn;
	}

	if (rtn) {
		var myMTransEncrypt = getValueById("MTransEncrypt");
		if (myMTransEncrypt != "") {
			if (myReturnSum < 0) {
				var myAmt = -myReturnSum;
			} else {
				var myAmt = myReturnSum;
			}
			if (isNaN(myAmt)) {
				myAmt = 0;
			}
			var myCardFareCost = getValueById("CardFareCost");
			if ((isNaN(+myCardFareCost)) || (myCardFareCost == "")) {
				myCardFareCost = 0;
			}
			if (m_CardReclaim == "1") {
				myAmt = parseFloat(myAmt) + parseFloat(myCardFareCost);
				myAmt = myAmt.toFixed(2);
			}
			var myRMB = cspRunServerMethod(myMTransEncrypt, myAmt);
			myAmt = myAmt.toString();
			var ReceiptsNo = getValueById("ReceiptsNo");
			//myAmt = myAmt.toFixed(2);
			if (+myReturnSum < 0) {
				var myrtn = HISUI_Confirm(t['GetSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
			} else {
				if (m_CardReclaim == "1") {
					var myrtn = HISUI_Confirm(t['RefSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"] + String.fromCharCode(10) + String.fromCharCode(13) + t["RefCardFareCost"] + myCardFareCost);
				} else {
					var myrtn = HISUI_Confirm(t['RefSum'] + myAmt + "(" + myRMB + ")" + t["ConTip"]);
				}
			}
			rtn = myrtn;
		}
	}
	return rtn;
}

function BuildPDInfo() {
	var myAry = new Array();
	myAry[0] = getValueById("ReturnSum");
	if (isNaN(myAry[0])) {
		myAry[0] = 0;
	}
	myAry[0] = -parseFloat(myAry[0]);
	myAry[1] = "F";
	myAry[2] = session['LOGON.USERID'];
	myAry[3] = "";
	myAry[4] = "账户结算退款";
	myAry[5] = session['LOGON.HOSPID'];
	var myInfo = myAry.join("^");
	return myInfo;
}

function BuildPDMInfo() {
	//PDPMInfo = PayModeDR_"^"_CardDR_"^"_ChequeNO_"^"_CMBankDR_"^"_Branch
	//_"^"_Amt_"^"_PayAccNO_"^"_ChequeDat_"^"_Remark
	var myInfo = "";
	var myAry = new Array;
	var myPMInfo = getValueById("PayMode");
	var myPMAry = myPMInfo.split("^");
	myAry[0] = myPMAry[0];
	myAry[1] = "";
	myAry[5] = getValueById("ReturnSum");
	if (isNaN(myAry[5])) {
		myAry[5] = 0;
	}
	myAry[5] = -parseFloat(myAry[5]);
	if (myPMAry[1] == "1") {
		myAry[2] = getValueById("CardChequeNo");
		myAry[3] = getValueById("Bank");
		myAry[4] = getValueById("PayUnit");
		myAry[6] = getValueById("PayAccNO");
		myAry[7] = getValueById("ChequeDate");
		myAry[8] = getValueById("Note");
	} else {
		myAry[2] = "";
		myAry[3] = "";
		myAry[4] = "";
		myAry[6] = "";
		myAry[7] = "";
		myAry[8] = "";
	}
	myInfo = myAry.join("^");

	return myInfo;
}

function AccPreList(AccRowID) {
	var inputPara = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPreList&AccountID=" + AccRowID;
	inputPara += "&HospId=" + session['LOGON.HOSPID'];
	DHCWeb_initDatagrid("UDHCACAccPatPreList", "预交金明细", "icon-w-list", 950, 600, inputPara, "", "", 1);
}

function AccPayList(AccRowID) {
	var inputPara = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCACAcc.PatPayList&AccRowID=" + AccRowID + '&RegFlag=' + '3';
	inputPara += "&HospId=" + session['LOGON.HOSPID'];
	DHCWeb_initDatagrid("","账户支付明细", "icon-w-list", 950, 600, inputPara, "", "", 2);
}

function AccUnPrtDetails(AccRowID) {
	/*
	var lnk = "udhcunprtdetails.csp?AccRowID=" + AccRowID;
	lnk += "&FrameFlag=ColPrt";
	var NewWin = open(lnk, "udhcunprtdetails", "scrollbars=yes,resizable=yes,top=50,left=50,width=950,height=600");
	var inputPara="invRowId=" + AccRowID;
	DHCWeb_initDatagrid("udhcunprtdetails","账户支付明细", "icon-w-list", 950, 600, inputPara);
	*/
}

function ReadPatAccInfo() {
	var PAPMINo = getValueById("PAPMINo");
	var CardNo = getValueById("CardNo");
	var SecurityNo = getValueById("SecurityNo");
	var encmeth = getValueById("ReadPAInfoEncrypt");
	var myrtn = cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo);
	var myAry = myrtn.split("^");
	if (myAry[0] == "0") {
		var myrtn = WrtPatAccInfo(myrtn);
		if (!myrtn) {
			return;
		}
		CheckPType();
		FootOperTip();
		CheckCheque();
		$("#Foot").linkbutton('enable');
	} else {
		DHCWeb_HISUIalert(t[myAry[0]]);
	}
}

function CheckCheque() {
	var myAccRowID = getValueById("AccRowID");
	var encmeth = getValueById("CheckCheque");
	if (encmeth == "") {
		return;
	}
	var myrtn = cspRunServerMethod(encmeth, myAccRowID);
	if (myrtn == "true") {
		DHCWeb_HISUIalert(t["HaveChequePayMode"]);
		return;
	}
}

function CheckPType() {
	var rtn = true;
	try {
		var myPreDepSum = getValueById("PreDepSum");
		var myPaySum = getValueById("PaySum");
		var myAccLeft = getValueById("AccLeft");
		if (isNaN(myPreDepSum)) {
			myPreDepSum = 0;
		}
		if (isNaN(myPaySum)) {
			myPaySum = 0;
		}
		if (isNaN(myAccLeft)) {
			myAccLeft = 0;
		}
		myPreDepSum = parseFloat(myPreDepSum);
		myPreDepSum = myPreDepSum.toFixed(2);
		myPaySum = parseFloat(myPaySum);
		myPaySum = myPaySum.toFixed(2);
		myAccLeft = parseFloat(myAccLeft);
		myAccLeft = myAccLeft.toFixed(2);
		var mytmpsum = (myPreDepSum - myPaySum).toFixed(2);
		if (+mytmpsum != +myAccLeft) {
			DHCWeb_HISUIalert(t["ErrLeft"]);
			return false;
		}
		disableById("FootType");
		if (myAccLeft >= 0) {
			setValueById("FootType", "R");
		} else {
			setValueById("FootType", "P");
		}
		$("#ReturnSum").attr("readOnly", true);
		setValueById("ReturnSum", myAccLeft);
	} catch (e) {
		DHCWeb_HISUIalert(e.message);
	}
}

function GetReceiptNo() {
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: session['LOGON.USERID'],
		GroupDR: session['LOGON.GROUPID'],
		ExpStr: "F^^" + session['LOGON.HOSPID']
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == "0") {
			var currNo = myAry[1];
			var rowId = myAry[2];
			var endNo = myAry[3];
			var title = myAry[4];
			var leftNum = myAry[5];
			var tipFlag = myAry[6];
			var receiptNo = title + "[" + currNo + "]";
			setValueById("ReceiptNO", receiptNo);
		}else {
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
		}
	});
}

function Calculate_Click() {
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=" + getValueById("PaySum");
	DHCWeb_initDatagrid("", "计算器", "icon-w-cal", 515, 168, lnk, "", "", "2");
}

function SetPayInfoStatus(isDisable) {
	$("#CardChequeNo").prop("disabled", isDisable);
	$("#PayUnit").prop("disabled", isDisable);
	$("#PayAccNO").prop("disabled", isDisable);
	$("#Note").prop("disabled", isDisable);
	$("#Bank").combobox({disabled: isDisable});
	$("#ChequeDate").datebox({disabled: isDisable});
}

function WrtPatAccInfo(myPAInfo) {
	var myrtn = true;
	var myAry = myPAInfo.split("^");
	setValueById("PAPMINo", myAry[1]);
	setValueById("PAName", myAry[2]);
	setValueById("PatSex", myAry[3]);
	setValueById("PatAge", myAry[4]);
	setValueById("CredType", myAry[5]);
	//setValueById("CredNo", myAry[6]);
	setValueById("AccStatus", myAry[8]);
	setValueById("AccLeft", myAry[7]);
	setValueById("AccNo", myAry[9]);
	setValueById("AccOCDate", myAry[10]);
	setValueById("BadPrice", myAry[11]);
	setValueById("AccDep", myAry[12]);
	setValueById("AccRowID", myAry[13]);
	setValueById("PreDepSum", myAry[14]);
	setValueById("PaySum", myAry[15]);
	setValueById("InsType", myAry[16]);
	setValueById("CardFRowID", myAry[17]);
	setValueById("hometel", myAry[20]);

	if (myAry[18] == "Y") {
		$.messager.popover({msg: '此账户有未就诊的挂号记录,请确认是否需要退号,如果需要退号,请退号后再做账户结算', type:'info'});
	}
	//Add Check for diffrent Version
	var myVersion = getValueById("DHCVersion");
	switch (myVersion) {
	case "0":
		var myLeft = getValueById("AccLeft");
		if (isNaN(myLeft)) {
			myLeft = 0;
		}
		myLeft = parseFloat(myLeft);
		if (myLeft < 0) {
			DHCWeb_HISUIalert(t["PayMTip"]);
			myrtn = false;
		}
		break;
	default:
		break;
	}
	return myrtn;
}

function BillPrintNew(INVstr) {
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var PayMode = getValueById("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var encmeth = getValueById("ReadINVDataEncrypt");
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", m_PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, TxtInfo, ListInfo);
}

function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName) {
	//1, RowID String
	//2. CurPrtXMLName
	//3. Encrypt Item
	if (CurXMLName == "") {
		return;
	}
	var INVtmp = RowIDStr.split("^");
	if (INVtmp.length > 0) {
		DHCP_GetXMLConfig("InvPrintEncrypt", CurXMLName);
	}
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = getValueById(EncryptItemName);
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myCarobj = document.getElementById("CardFareCost").value;
			if (CardCostFlag == "Y") {
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCCardInvPrt2");
				var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", myCarobj, INVtmp[invi], Guser, myExpStr);
			} else {
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCAccDeposit2");
				var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", CurXMLName, INVtmp[invi], Guser, myExpStr);
			}
		}
	}
}

function FootOperTip() {
	var myAccRowID = getValueById("AccRowID");
	var myEncrypt = getValueById("FootAlTipEncrypt");
	var myExpStr = "";
	if (myEncrypt != "") {
		var myrtn = cspRunServerMethod(myEncrypt, myAccRowID, "Foot", myExpStr);
		var myAry = myrtn.split("^");
		if (myAry[0] == "1") {
			DHCWeb_HISUIalert(myAry[1]);
		}
	}
}

function GetCardFareCost(myCardTypeID, myCardNo) {
	var myEncrypt = getValueById("GetCardFareCostEncrypt");
	if (myEncrypt != "") {
		var myrtn = cspRunServerMethod(myEncrypt, myCardTypeID, myCardNo);
		setValueById("CardFareCost", myrtn);
	}
}

function Doc_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 115) {
		//F4 读卡
		if ($('#ReadCard').linkbutton('options').disabled){
			return;
		}
		ReadHFMagCard_Click();
	} else if (key == 118) {
		//F7 清屏
		Clear_OnClick();
	} else if (key == 120) {
		//F9 结算
		if ($('#Foot').linkbutton('options').disabled){
			return;
		}
		Foot_OnClick();
	}
}

/**
* 格式化卡号
*/
function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != "") {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

function CardTypeDefine_OnChange() {
	var myCardTypeValue = getValueById("CardTypeDefine");
	var myAry = myCardTypeValue.split("^");
	var myCardTypeDR = myAry[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myAry[16] == "Handle") {
		$("#CardNo").attr("readOnly", false);
		$("#ReadCard").linkbutton('disable');
		focusById("CardNo");
	} else {
		$("#CardNo").attr("readOnly", true);
		$("#ReadCard").linkbutton('enable');
	}
	//Set Focus
	if (myAry[16] == "Handle") {
		focusById("CardNo");
	} else {
		focusById("ReadCard");
	}
	m_CardNoLength = myAry[17];
}

function HISUI_Confirm(msg){
	var rtn = dhcsys_confirm(msg,"YES", "14", "确定|取消");
	return rtn;
}