/// UDHCACRefundAPI.js

var m_YBConFlag = "0";   //default not Connection YB
var m_InsType = "";
var m_Admsource = "";

$(function () {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
	
	$("#ReceiptNO").keydown(function (e) {
		ReceiptNO_OnKeyPress(e);
	});
	
	$HUI.linkbutton("#Abort", {
		disabled: true,
		onClick: function () {
			Abort_OnClick();
		}
	});
	
	$HUI.linkbutton("#Refund", {
		disabled: true,
		onClick: function () {
			Refund_OnClick();
		}
	});
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			Clear_OnClick();
		}
	});

	IntDoc();

	focusById("ReceiptNO");
});

function IntDoc() {
	var myPrtXMLName = "";
	//Load Base Config
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		mPrtINVFlag = myary[4];
		myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);

	var encmeth = getValueById("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
	}
	var myary = myrtn.split("^");
	m_YBConFlag = myary[9];
	
	$('#PayModeList').combobox({
		url: $URL + '?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array',
		disabled: true,
		valueField: 'CTPM_RowId',
		textField: 'CTPM_Desc'
	});
}

function Abort_OnClick() {
	$.messager.confirm("确认", "确认撤销？", function(r) {
		if (r) {
			RefundSaveInfo("A");
		}
	});
}

function Refund_OnClick() {
	$.messager.confirm("确认", "确认撤销？", function(r) {
		if (r) {
			RefundSaveInfo("S");
		}
	});
}

function Clear_OnClick() {
	$(":text:not(.pagination-num)").val("");
	IntDoc();
	SetACRefOEOrder("");
}

function ReceiptNO_OnKeyPress(e) {
	var key = websys_getKey(e);
	var myReceiptNO = getValueById("ReceiptNO");
	if ((myReceiptNO != "") && (key == 13)) {
		var myUser = session['LOGON.USERID'];
		var encmeth = getValueById("ReadINVByNoEncrypt");
		var HospId = session['LOGON.HOSPID'];
		var myrtn = cspRunServerMethod(encmeth, myReceiptNO, myUser, HospId);
		var rtn = myrtn.split("^")[0];
		if (rtn != "0") {
			$.messager.popover({msg: t['06'], type: 'info'});
			websys_setfocus('ReceiptNO');
			return websys_cancel();
		} else {
			WrtRefundMain(myrtn);
			var myAPIRowID = getValueById("OldAccPayINVRowID");
			SetACRefOEOrder(myAPIRowID);
		}
	}
}

function SetACRefOEOrder(APIRowID) {
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCACRefundINV&APIRowID=" + APIRowID;
	var ACOEList = parent.frames["UDHCACRefundINV"];
	ACOEList.location.href = lnk;
}

function WrtRefundMain(AccINVInfo) {
	// Write Info For Main Form
	var myary = AccINVInfo.split("^");
	setValueById("ReceiptNO", myary[1]);
	setValueById("PatientID", myary[2]);
	setValueById("PatientName", myary[3]);
	setValueById("PatientSex", myary[4]);
	setValueById("INVSum", myary[5]);
	var myBtnFlag = myary[6];
	setValueById("AccNo", myary[7]);
	setValueById("AccLeft", myary[8]);
	setValueById("AccRowID", myary[9]);
	setValueById("AccStatus", myary[10]);
	setValueById("PayModeList", myary[11]);
	setValueById("YBPaySum", myary[12]);
	setValueById("AccStatDesc", myary[13]);
	setValueById("OldAccPayINVRowID", myary[14]);
	setValueById("PatSelfPay", myary[16]);
	setValueById("INSDivDR", myary[17]);

	m_InsType = myary[19];
	m_Admsource = myary[20];
	
	$("#Abort, #Refund").linkbutton('disable');
	if (myary[15] != "N") {
		$.messager.popover({msg: t[myary[15] + "01"], type: 'info'});
		return;
	}
	//Check Account Status
	if (myary[10] == "F") {
		$.messager.popover({msg: t["AccFootTip"], type: 'info'});
		return;
	}
	switch (myBtnFlag) {
	case "S":
		enableById("Refund");
		break;
	case "P":
		enableById("Abort");
		break;
	default:
		$.messager.popover({msg: '请先做退费审核或到药房退药', type: 'alert'});
	}
}

function RefundSaveInfo(RefundFlag) {
	$("#Abort, #Refund").linkbutton('disable');
	var payModeDR = getValueById("PayModeList");
	var payModeCode = "";
	if (payModeDR) {
		var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: payModeDR}, false);
		payModeCode = jsonObj.CTPMCode;
	}
	var AccLeft = getValueById("AccLeft");
	var YBPaySum = getValueById("YBPaySum");
	var myINSDivDR = getValueById("INSDivDR");
	if (myINSDivDR != "") {
		if (payModeCode == 'CPP') {
			$.messager.popover({msg: '请到【退费】界面退费', type: 'info'});
			return;
		}else {
			$.messager.alert('提示', '请注意收取：<font color="red">' + YBPaySum + '</font> 元', 'info', function() {
				_refund();
			});
		}
	}else {
		_refund();
	}
	
	function _refund() {
		var rtn = CardYBPark();
		if (!rtn) {
			return rtn;
		}
		var myAPIRowID = getValueById("OldAccPayINVRowID");
		var myUser = session['LOGON.USERID'];
		var encmeth = getValueById("SaveParkDataEncrypt");
		if (encmeth != "") {
			var rtn = cspRunServerMethod(encmeth, myAPIRowID, myUser, RefundFlag);
			if (rtn == "0") {
				$.messager.popover({msg: '撤销成功', type: 'success'});
			} else {
				$.messager.popover({msg: '撤销失败：' + rtn, type: 'error'});
			}
		}
	}
}

function CardYBPark() {
	var myINSDivDR = getValueById("INSDivDR");
	if (myINSDivDR == "") {
		return true;
	}
	/*
	var encmeth = getValueById('JudgeAPIDate');
	var myAPIRowID = getValueById("OldAccPayINVRowID");
	var Flag = cspRunServerMethod(encmeth, myAPIRowID);
	if(Flag=="-1") {
		$.messager.popover({msg: '发票已跨月，不允许退费!', type: 'info'});
		return false;
	}
	*/
	if ((myINSDivDR != "") && (m_YBConFlag == "0")) {
		$.messager.popover({msg: t["ReqYBTip"], type: 'info'});   //Require YB Connection
		return false;
	}
	var myrtn = QueryYBsysStrik(myINSDivDR);
	if (myrtn == "0") {
		return true;
	} else {
		$.messager.popover({msg: t["YBParErr"], type: 'error'});
		return false;
	}
}

function QueryYBsysStrik(myINSDivDR) {
	/*
	if (insuINSUFlag != "Y") {
		$.messager.popover({msg: 'No YB Client!', type: 'error'});
		return "-1";
	}
	if (insuDLLFlag != "Y") {
		$.messager.popover({msg: 'No Intial', type: 'error'});
		return "-1";
	}
	if (insudHandle <= 0) {
		$.messager.popover({msg: 'dHandle = ' + insudHandle, type: 'error'});
		return "-1";
	}
	*/
	
	var OutString = "";
	var insudHandle = "0";
	var myUser = session['LOGON.USERID'];
	var ExpStr = "";
	var InsuType = m_InsType;
	var CPPFlag = "N";
	OutString = InsuOPDivideStrike(insudHandle, myUser, myINSDivDR, m_Admsource, InsuType, ExpStr, CPPFlag);
	return OutString;
}