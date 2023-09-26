/// DHCOPBillInvInsuPatInfo.js
/// Lid
/// 2014-07-08

var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_YBConFlag = 0;
var PrtXMLName = "";
var listobj = parent.frames["DHCOPBillInvInsuList"];

$(function() {
	init_Layout();
	
	$HUI.linkbutton("#ReadCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	$HUI.linkbutton("#ClearWin", {
		onClick: function () {
			ClearWin_Click();
		}
	});
	
	$("#PAPMINo").keydown(function (e) {
		PAPMINo_KeyPress(e);
	});
	
	$("#CardNo").keydown(function (e) {
		cardNoKeyDown(e);
	});
	
	$HUI.linkbutton("#BtnInvPrint", {
		onClick: function () {
			BtnInvPrint_OnClick();
		}
	});

	$HUI.combobox("#InsType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFCASHIER&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		editable: false,
		disabled: true,
		onBeforeLoad: function(param) {
			param.hospId= session['LOGON.HOSPID'];
		}
	});
	$HUI.combobox("#CardTypeDefine", {
		panelHeight: "auto",
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "value",
		textField: "caption",
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
	
	$HUI.checkbox('#SelAll',{
		onCheckChange:function(){
			SelAll_OnClick();
		}
	});
	
	$HUI.checkbox('#GHFLag', {
		onCheckChange:function() {
			SetSel_OnClick();
		}
	});
		
	IntDocument();
	GetReceiptNo();
	focusById("ReadCard");
});

function BtnInvPrint_OnClick() {
	listobj.BtnInvPrint_OnClick();
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		listobj.NoHideAlert("未找到发票模版!");
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = getValueById("ReadINVDataEncrypt");
			var PayMode = getValueById("PayMode");
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
	DHCP_XMLPrint(myobj, TxtInfo, ListInfo);
}

function GetReceiptNo() {
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: session['LOGON.USERID'],
		GroupDR: "",
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
			setValueById("INVLeftNum", leftNum);
			setValueById("ReceiptNO", receiptNo);
		}else {
			listobj.NoHideAlert("操作员没有可用的票据!");
		}
	});
}

function IntDocument() {
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		mPrtINVFlag = myary[4];
		var myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);

	var encmeth = getValueById("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
	}
	var myary = myrtn.split("^");
	m_YBConFlag = myary[9];
}

function SelAll_OnClick() {
	var myvalue = getValueById("SelAll");
	var Prtobj = parent.frames['DHCOPBillInvInsuList'];
	var mywin = Prtobj.window;
	mywin.SelectAll(myvalue);
}

function PAPMINo_KeyPress(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById('CardNo', '');
		getPatinfo();
	}
}

function getPatinfo() {
	var PAPMINo = getValueById("PAPMINo");
	if (PAPMINo == "") {
		return;
	}
	var CardNo = "";
	var SecurityNo = "";
	var encmeth = getValueById("ReadPatInfo");
	var myrtn = cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo);
	var myary = myrtn.split("^");
	setValueById("PAPMIRowID", myary[19]);
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		WrtPatAccInfo(myrtn);
		var myrtn = CheckPRTFlag();
		if (!myrtn) {
			return;
		}
		RefreshDoc();
	} else {
		listobj.NoHideAlert('无效账户');
	}
}

function ClearWin_Click() {
	setValueById("AccRowID", "");
	setValueById("PAPMIRowID", "");
	PatAccInfoClr();
	RefreshDoc();
	//PatPayINVPrtForPrt("","");
}

function ReadPatAccInfo() {
	var PAPMINo = getValueById("PAPMINo");
	var CardNo = getValueById("CardNo");
	var SecurityNo = getValueById("SecurityNo");
	var encmeth = getValueById("ReadPAInfoEncrypt");
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
		listobj.NoHideAlert('无效账户');
	}
}

function WrtPatAccInfo(myPAInfo) {
	var myary = myPAInfo.split("^");
	setValueById("PAPMINo", myary[1]);
	setValueById("PAName", myary[2]);
	setValueById("PatSex", myary[3]);
	setValueById("PatAge", myary[4]);
	setValueById("CredType", myary[5]);
	setValueById("CredNo", myary[6]);
	setValueById("AccLeft", myary[7]);
	setValueById("AccStatus", myary[8]);
	setValueById("AccNo", myary[9]);
	setValueById("AccOCDate", myary[10]);
	setValueById("BadPrice", myary[11]);
	setValueById("AccDep", myary[12]);
	setValueById("AccRowID", myary[13]);
	var myPatType = myary[16];
	
	setValueById("InsType", myPatType);
}

function CheckPRTFlag() {
	//Add Left Check
	var myLeft = getValueById("AccLeft");
	if (isNaN(myLeft)) {
		myLeft = 0;
	}
	var myLeftBalance = parseFloat(myLeft);
	if (+myLeftBalance < 0) {
		//listobj.NoHideAlert(t["DepPTip"]);
		//return false;
	}
	return true;
}

function RefreshDoc() {
	var myFrameFlag = getValueById("FrameFlag");
	var myAccRowID = getValueById("AccRowID");
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
	var StDate = getValueById("StDate");
	var EndDate = getValueById("EndDate");
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillInvInsuList&AccRowID=" + AccRowID;
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
	var myFrameFlag = getValueById("FrameFlag");
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillInvInsuPatInfo&FrameFlag=" + myFrameFlag;
	window.location.href = lnk;
}

function init_Layout(){
	DHCWeb_ComponentLayout();
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("ReadCard");
			$("#CardNo").attr("readOnly", false);
		} else {
			enableById("ReadCard");
			setValueById("CardNo", "");
			$("#CardNo").attr("readOnly", true);
		}
	} catch (e) {
	}
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById("CardTypeDefine");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("CardNo", myAry[1]);
			setValueById("PAPMINo", myAry[5]);
			getPatinfo();
			break;
		case "-200":
			listobj.NoHideAlert('卡无效');
			break;
		case "-201":
			setValueById("CardNo", myAry[1]);
			setValueById("PAPMINo", myAry[5]);
			getPatinfo();
			break;
		default:
		}
	} catch (e) {
	}
}

/**
* 卡号回车事件
*/
function cardNoKeyDown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("CardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("CardTypeDefine");
			cardNo = FormatCardNo(cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("CardNo", myAry[1]);
				setValueById("PAPMINo", myAry[5]);
				setValueById("SecurityNo", myAry[2]);
				setValueById("PAPMIRowID", myAry[4]);
				ReadPatAccInfo();
				break;
			case "-200":
				listobj.NoHideAlert("卡无效")
				break;
			case '-201':
				setValueById("CardNo", myAry[1]);
				setValueById("PAPMINo", myAry[5]);
				setValueById("SecurityNo", myAry[2]);
				setValueById("PAPMIRowID", myAry[4]);
				ReadPatAccInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function FormatCardNo(CardNo) {
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

function GetCardNoLength() {
	var CardNoLength = "";
	var CardTypeValue = getValueById("CardTypeDefine");
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardNoLength = CardTypeArr[17];
	}
	return CardNoLength;
}
