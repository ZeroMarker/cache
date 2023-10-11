/// UDHCACRefundAPI.js

var m_YBConFlag = "0";   //default not Connection YB
var m_InsType = "";
var m_Admsource = "";

$(function () {
	if (websys_isIE) {
		$.getScript("../scripts/dhcbill/plugin/browser/browser-polyfill.min.js");
	}

	$("td.i-tableborder>table").css("border-spacing", "0px 8px");
	
	$("#ReceiptNO").focus().keydown(function (e) {
		receiptNOKeydown(e);
	});
	
	$HUI.linkbutton("#Cancel", {
		disabled: true,
		onClick: function () {
			cancelClick();
		}
	});
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			clearClick();
		}
	});

	IntDoc();
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
	
	$("#PayModeList").combobox({
		url: $URL + '?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array',
		disabled: true,
		valueField: 'CTPM_RowId',
		textField: 'CTPM_Desc'
	});
}

function cancelClick() {
	var _cfmCancel = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _validCancel = function() {
		return new Promise(function (resolve, reject) {
			var payModeDR = getValueById("PayModeList");
			var payModeCode = "";
			if (payModeDR) {
				payModeCode = getPropValById("CT_PayMode", payModeDR, "CTPM_Desc");
			}
			var AccLeft = getValueById("AccLeft");
			var YBPaySum = getValueById("YBPaySum");
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (payModeCode == "CPP") {
				$.messager.popover({msg: "请到【退费】界面退费", type: "info"});
				return reject();
			}
			$.messager.alert("提示", "请注意收取：<font color=\"red\">" + YBPaySum + "</font> 元", "info", function() {
				return resolve();
			});
			return;
		});
	};
	
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!(insuDivId > 0)) {
				return resolve();
			}
			/*
			var encmeth = getValueById('JudgeAPIDate');
			var flag = cspRunServerMethod(encmeth, accPInvId);
			if (flag == -1) {
				$.messager.popover({msg: '发票已跨月，不允许退费', type: 'info'});
				return reject();
			}
			*/
			if (m_YBConFlag == 0) {
				$.messager.popover({msg: '退此发票需要连接医保', type: 'info'});   //Require YB Connection
				return reject();
			}
			var myYBHand = "0";
			var ExpStr = "^^^^";
			var InsuType = m_InsType;
			var CPPFlag = "N";
			var rtn = InsuOPDivideStrike(myYBHand, session['LOGON.USERID'], insuDivId, m_Admsource, m_InsType, ExpStr, CPPFlag);
			if (rtn != 0) {
				$.messager.popover({msg: "医保退费失败：" + rtn, type: "error"});
				return resolve();
			}
			return resolve();
		});
	};
	
	/**
	* 撤销
	*/
	var _cancel = function() {
		$.m({
			ClassName: "web.udhcOPRefEditIF",
			MethodName: "WriteOffAPI",
			AccPInvId: accPInvId,
			UserId: session['LOGON.USERID']
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "撤销成功", type: "success"});
				return;
			}
			$.messager.popover({msg: "撤销失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	};
	
	if ($("#Cancel").hasClass("l-btn-disabled")) {
		return;
	}
	$("#Cancel").linkbutton("disable");

	var accPInvId = getValueById("OldAccPayINVRowID");
	var insuDivId = getValueById("INSDivDR");
	
	var promise = Promise.resolve();
	promise
		.then(_cfmCancel)
		.then(_validCancel)
		.then(_insuPark)
		.then(_cancel, function () {
			$("#Cancel").linkbutton("enable");
		})
}

function clearClick() {
	$(":text:not(.pagination-num)").val("");
	IntDoc();
	SetACRefOEOrder("");
}

function receiptNOKeydown(e) {
	var key = websys_getKey(e);
	var myReceiptNO = getValueById("ReceiptNO");
	if ((myReceiptNO != "") && (key == 13)) {
		var myUser = session['LOGON.USERID'];
		var encmeth = getValueById("ReadINVByNoEncrypt");
		var HospId = session['LOGON.HOSPID'];
		var myrtn = cspRunServerMethod(encmeth, myReceiptNO, myUser, HospId);
		var rtn = myrtn.split("^")[0];
		if (rtn != 0) {
			$.messager.popover({msg: '此发票号不存在或非集中打印发票', type: 'info'});
			websys_setfocus('ReceiptNO');
			return websys_cancel();
		}
		WrtRefundMain(myrtn);
		var accPInvId = getValueById("OldAccPayINVRowID");
		SetACRefOEOrder(accPInvId);
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
	
	disableById("Cancel");
	//$("#Abort, #Refund").linkbutton('disable');
	if (myary[15] != "N") {
		var msg = "此发票已经被" + ((myary[15] == "A") ? "作废" : "红冲");
		$.messager.popover({msg: msg, type: 'info'});
		return;
	}
	//Check Account Status
	if (myary[10] == "F") {
		$.messager.popover({msg: '账户已经结算，请激活账户后再办理退费', type: 'info'});
		return;
	}
	if ($.inArray(myBtnFlag, ["S", "P"]) != -1) {
		enableById("Cancel");
	}else {
		$.messager.popover({msg: '请先做退费审核或到药房退药', type: 'info'});
	}
}