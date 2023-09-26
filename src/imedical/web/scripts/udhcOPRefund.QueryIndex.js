/// udhcOPRefund.QueryIndex.js

var m_SelectCardTypeDR = "";
var m_CardNoLength = 12;

function BodyLoadHandler() {
	var obj = document.getElementById("BClear");
	if (obj) {
		obj.onclick = BClear_Click;
	}
	var obj = document.getElementById("Audit");
	if (obj) {
		obj.onclick = Audit_Click;
		Audit_Click();
	}
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_OnKeyDown;
	}
	var obj = document.getElementById("ReadCardQuery");
	if (obj) {
		obj.onclick = CardQuery_Click;
	}
	var obj = document.getElementById("PatientNO");
	if (obj) {
		obj.onkeydown = PatientNoKeyDown;
	}
	var obj = document.getElementById("RCardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = RCardNo_KeyDown;
		}
	}
	var obj = document.getElementById('ReadInsuCard');
	if (obj) {
		obj.onclick = ReadInsuCard_OnClick;
	}
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
		myobj.onchange = CardTypeDefine_OnChange;
	}
	
	//+ZhYW 2018-02-08
	var obj = websys_$("ChargeUser");
	if (obj) {
		obj.onkeyup = ClearChargeUser;
	}
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
	CardTypeDefine_OnChange();
	document.onkeydown = DocumentOnKeydown;
	InitTableStyle();
}

function InitTableStyle() {
	var Guser = session['LOGON.USERID'];
	var GroupDR = session['LOGON.GROUPID'];
	var CTLocDR = session['LOGON.CTLOCID'];
	var HospDR = session['LOGON.HOSPID'];
	var tabOPList = document.getElementById("tudhcOPRefund_QueryIndex");
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var eSrc = tabOPList.rows[row];
		var CurrowObj = getRow(eSrc);
		var TPrtRowidObj = document.getElementById('TINVRowidz' + row);
		var PrtRowid = DHCWebD_GetCellValue(TPrtRowidObj);
		
		var TabFlagObj = document.getElementById('TabFlagz' + row);
		var TabFlag = DHCWebD_GetCellValue(TabFlagObj);
		var ExpStr = Guser + "^" + GroupDR + "^" + CTLocDR + "^" + HospDR + "^^^^^";
		var RefundFlag = tkMakeServerCall("web.udhcOPQUERYExp", "CheckRefundPrtInv", PrtRowid, TabFlag, ExpStr);
		if (RefundFlag == "1") {
			//含允许退费医嘱
			CurrowObj.style.backgroundColor = "#FFEFD5"; //背景色
			//CurrowObj.style.color="#FA8072";	         //前景色
		}
	}
}
function BClear_Click() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.QueryIndex";
	window.location.href = lnk;
}

function Audit_Click() {
	var Auditobj = document.getElementById("Audit");
	var obj = document.getElementById("AuditFlag");
	if (obj) {
		if (Auditobj.checked) {
			obj.value = "A";
		} else {
			obj.value = "ALL";
		}
	}
}

function CardQuery_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		websys_$("RCardNo").value = myary[1];
		var obj = document.getElementById("PatientNO");
		obj.value = myary[5];
		ReadPatInfo();
		break;
	case "-200":
		alert("无效卡");
		break;
	case "-201":
		websys_$("RCardNo").value = myary[1];
		var obj = document.getElementById("PatientNO");
		obj.value = myary[5];
		ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCardQuery");
	} else {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCardQuery");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, CardQuery_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("RCardNo");

	} else {
		DHCWeb_setfocus("ReadCardQuery");
	}
	m_CardNoLength = myary[17];
}

function DocumentOnKeydown() {
	DHCWeb_EStopSpaceKey();
	var e = event ? event : (window.event ? window.event : null);
	var keycode;
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if (keycode == 115) {
		var obj = document.getElementById("ReadCardQuery");
		if (obj) {
			obj.click();
		}
	}
}
function ReceipNO_OnKeyDown(e) {
	if (!e)
		var key = websys_getKey(e);
	if (key == 13) {
		Find_click();
	}
}

function PatientNoKeyDown(e) {
	var key = websys_getKey(e);
	if ((key == 13)) {
		ReadPatInfo();
	}
}

function RCardNo_KeyDown(e) {
	var key = websys_getKey(e);
	if ((key == 13)) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("RCardNo");
		if (myCardNo == ""){
			return;
		}
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			DHCWebD_SetObjValueB('PatientNO', myary[5]);
			ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			var myPAPMNo = myary[5];
			DHCWebD_SetObjValueB('PatientNO', myary[5]);
			ReadPatInfo();
			break;
		default:
		}
		return;
	}
}

function ReadInsuCard_OnClick() {
	try {
		var rtn = ReadCard("N");
		if ((rtn == "-1") || (rtn == "")) {
			return;
		}
		var myArr = rtn.split("|");
		var obj = document.getElementById('RCardNo');
		if (obj) {
			obj.value = myArr[0];
		}
		var CardNo = myArr[0];
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, CardNo, "", "PatInfo");
		if (CardNo == "") {
			return;
		}
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			DHCWebD_SetObjValueB('PatientNO', myary[5]);
			ReadPatInfo();
			break;
		case "-200":  //卡无效,InvaildCard:卡无效
			alert("卡无效");
			//websys_setfocus('RegNo');
			break;
		case "-201":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			DHCWebD_SetObjValueB('PatientNO', myary[5]);
			ReadPatInfo();
			break;
		default:
		}
	} catch (e) {
		alert("读卡错误:" + " " + e.message);
		return;
	}
}

function SetCardNOLength() {
	var obj = document.getElementById('RCardNo');
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

function ReadPatInfo() {
	var PatNo = DHCWebD_GetObjValue('PatientNO');
	if (PatNo != "") {
		var encmeth = DHCWebD_GetObjValue('GetPAPMI');
		var myExpStr = "";
		var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
		if (PatDr == "") {
			alert("登记号错误.");
			websys_setfocus('PatientNO');
			return websys_cancel();
		}
		SetPatientInfo(PatDr);  //设置基本信息
		Find_click();
	}
}

function SetPatientInfo(PatDr) {
	var encmeth = DHCWebD_GetObjValue('GetPatInfo');
	var myExpStr = "";
	var PatInfoStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var PatInfo = PatInfoStr.split("^");
	DHCWebD_SetObjValueB('PatientNO', PatInfo[1]);
	DHCWebD_SetObjValueB('PatientName', PatInfo[2]);
	DHCWebD_SetObjValueB('PatSex', PatInfo[3]);
	DHCWebD_SetObjValueB('PatAge', PatInfo[4]);
	DHCWebD_SetObjValueB('EncryptLevel', PatInfo[22]);
	DHCWebD_SetObjValueB('PatLevel', PatInfo[23]);
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-05-27
 * Description: 结算发票退费
 */
function BtnPRTRefOnClick(Me, rowId, invNo) {
	var reloadFlag = 1;
	var lnk = 'udhcoprefund.csp?ReloadFlag=' + reloadFlag + '&ReceipID=' + rowId + '&ReceipNO=' + invNo;
	var iHeight = 800;
	var iWidth = 1300;
    var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	window.showModalDialog(lnk, window, 'dialogWidth:' + iWidth + 'px;dialogHeight:' + iHeight + 'px;resizable:yes;');
	//websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=' + iWidth + ',height=' + iHeight + ',left=' + iLeft + ',top=' + iTop + '');
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-05-27
 * Description: 卡支付发票退费
 */
function BtnAccPRefOnClick(Me, rowId, invNo) {
	var reloadFlag = 1;
	var lnk = 'udhcaccpayinvrefund.csp?ReloadFlag=' + reloadFlag + '&APIINVNo=' + invNo;
	var iHeight = 800;
	var iWidth = 1300;
    var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
    window.showModalDialog(lnk, window, 'dialogWidth:' + iWidth + 'px;dialogHeight:' + iHeight + 'px;resizable:yes;');
	//websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=' + iWidth + ',height=' + iHeight + ',left=' + iLeft + ',top=' + iTop + '');
}

/**
* Creator: ZhYW
* CreatDate: 2018-02-08
*/
function GetUserID(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("ChargeUserID", myAry[1]);
}

/**
* Creator: ZhYW
* CreatDate: 2018-02-08
*/
function ClearChargeUser() {
	var ChargeUserID = websys_$V("ChargeUser");
	if (ChargeUserID == ""){
		DHCWebD_SetObjValueB("ChargeUserID", "");
	}
}

function BtnCancleStayChargeOnClick(Me, rowId, invNo){
	var guser = session['LOGON.USERID'];
	var groupDr = session['LOGON.GROUPID'];
	var ctLocDr = session['LOGON.CTLOCID'];
	var prtRowId = rowId;
	if (prtRowId == "") {
		alert("请选中要撤销的发票记录.");
		return;
	}
	//判断是否为留观发票
	var stayFlag = tkMakeServerCall("web.UDHCJFBaseCommon","GetPrtInvStat", prtRowId);
	if(stayFlag != "Y"){
		alert("非留观发票,不能撤销！");
		return;
	}
	var myrtn = window.confirm("是否确认撤销留观结算?");
	if (!myrtn) {
		return myrtn;
	}
	//获取发票费别信息
	var tmp = tkMakeServerCall("web.UDHCJFBaseCommon", "GetInsTypeInfoByPrtRowId", prtRowId);
	var insTypeDr = tmp.split("^")[0];
	var admSource = tmp.split("^")[1];
	
	//获取医保结算指针
	var insDivDr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPrtInsDivDR", prtRowId, "PRT");
	if(insDivDr != ""){
		//医保退费
		var myYBHand = "0";
		var myCPPFlag = "";
		var StrikeFlag = "S";
		var InsuNo = "";
		var CardType = "";
		var YLLB = "";
		var DicCode = "";
		var DYLB = "";
		var LeftAmt = "";
		var MoneyType = ""; //卡类型
		var LeftAmtStr = LeftAmt + "!" + LeftAmt + "^" + MoneyType;
		var myExpStr = StrikeFlag + "^" + groupDr + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DYLB + "^" + LeftAmtStr;
		var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, guser, insDivDr, admSource, insTypeDr, myExpStr, myCPPFlag);
		if (rtn != "0") {
			alert(t["YBParkErrTip"]);
			return;
		}
	}
	
	//HIS撤销
	var expStr = "";
	var rtnvalue = tkMakeServerCall("web.DHCOPBillStayCharge", "StayChargeCancel", prtRowId, guser, groupDr, ctLocDr, expStr);
	var rtn = rtnvalue.split("^");
	if (rtn[0] == '0'){
		alert("撤销成功.");
		Find_click();
	}else{
		alert("撤销留观结算失败:" + rtnvalue);
	}
}


document.body.onload = BodyLoadHandler;