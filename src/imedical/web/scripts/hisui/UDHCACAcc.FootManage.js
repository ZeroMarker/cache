/// UDHCACAcc.FootManage.js

document.write("<script type='text/javascript' src='../scripts/DHCBillMisPosPay.js'></script>");
document.write("<script type='text/javascript' src='../scripts/DHCBillPayScanCodeService.js'></script>");
document.write("<script type='text/javascript' src='../scripts/DHCBillPayService.js'></script>");

var GV = {
	PrtXMLName: "",   //XML Stream Mode Name
	CardCostFlag: "",
	Required: "N"
};

$(function () {
	$("td.i-tableborder>table").css("border-spacing", "0px 8px");

	$("#ReadCard").linkbutton({
		onClick: function() {
			readHFMagCardClick();
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
			$("#PayMode").combobox("clear");
			$.each(data, function (index, item) {
				if (item.selected) {
					$("#PayMode").combobox("select", item.CTPMRowID);
					return false;
				}
			});
		},
		onSelect: function (rec) {
			GV.Required = rec.RPFlag;
			SetPayInfoStatus((rec.RPFlag != "Y"));
		}
	});
	
	$HUI.combobox("#Bank", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text'
	});
	
	$HUI.combobox("#FootType", {
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		data: [{id: "P", text: $g("缴款")},
			   {id: "R", text: $g("退款")}]
	});
	
	$HUI.combobox("#InsType", {
		panelHeight: 180,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryPatType&ResultSetType=array&hospId=" + session['LOGON.HOSPID'],
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onLoadSuccess: function(data) {
			if (data.length > 0) {
				setValueById("InsType", data[0].id);
			}
		}
	});
	
	$("#Calculate").linkbutton({
		onClick: function() {
			Calculate_Click();
		}
	});
	
	$("#ClearWin").linkbutton({
		onClick: function() {
			clearClick();
		}
	});
	
	$("#PreDList").linkbutton({
		onClick: function () {
			PreDList_Click();
		}
	});
	
	$("#APayList").linkbutton({
		onClick: function() {
			APayList_Click();
		}
	});
	
	$("#UnPrtDetails").linkbutton({
		onClick: function() {
			UnPrtDetails_Click();
		}
	});
	
	$("#CardNo").focus().keydown(function(e) {
		cardNoKeydown(e);
	});
	
	disableById("bRePrint");
	disableById("bPRTDetail");
	
	$("#Foot").linkbutton({
		disabled: true,
		onClick: function() {
			footClick();
		}
	});
	
	IntDoc();
	
	document.onkeydown = docKeydown;
});

function bRePrint_Click() {
	var myACINVStr = getValueById("APINVStr");
	DHCP_GetXMLConfig("InvPrintEncrypt", GV.PrtXMLName);
	BillPrintNew(myACINVStr);
	disableById("bRePrint");
}

function footClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (accMRowId == "") {
				$.messager.popover({msg: "账户不存在，请读卡重试", type: "info"});
				return reject();
			}
			//校验支付方式必填信息
			if (GV.Required == "Y") {
				if (!myCardChequeNo) {
					$.messager.popover({msg: "请输入支票号码/卡号", type: "info"});
					focusById("CardChequeNo");
					return reject();
				}
				if (!myBank) {
					$.messager.popover({msg: "请选择银行", type: "info"});
					focusById("Bank");
					return reject();
				}
			}
			//判断是否有未退的除门诊预交金之外的押金信息
			var rtn = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "GetOtherPreDepInfo", accM: accMRowId}, false);
			if (rtn) {
				$.messager.alert("提示", $g("此账户有待退的") + rtn + $g("，请先在【预交金退款】界面退款后再结算账户。"), "info");
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var msg = "";
			if (needCancelReg == "Y") {
				msg = $g("此账户有未就诊的挂号记录，如需退号，请先退号，");				
			}
			msg += $g("确认结算该账户？");
			$.messager.confirm("确认", msg, function(r) {
				return r ? resolve() : reject();
			});
		}).then(function() {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", "是否回收卡？", function(r) {
					if (r) {
						isReclaimCard = 1;
						return resolve();
					}
					resolve();
				});
			});
		});
	};
	
	var _chkBadPrice = function() {
		return new Promise(function (resolve, reject) {
			if (isNaN(accMLeft)) {
				accMLeft = 0;
			}
			accMLeft = parseFloat(accMLeft).toFixed(2);
			if (isNaN(myReturnSum)) {
				myReturnSum = 0;
			}
			myReturnSum = parseFloat(myReturnSum).toFixed(2);
			if (myReturnSum == accMLeft) {
				return resolve();
			}
			$.messager.confirm("确认", "要产生坏账，是否继续?", function(r) {
				if (!r) {
					return reject();
				}
				var myAmt = Math.abs(myReturnSum);
				if (isNaN(myCardFareCost)) {
					myCardFareCost = 0;
				}
				if (isReclaimCard == 1) {
					myAmt = parseFloat(myAmt) + parseFloat(myCardFareCost);
				}
				myAmt = myAmt.toFixed(2);
				
				var msg = "";
				if (+myReturnSum < 0) {
					msg = $g("需要") + "<font color=\"red\">" + $g("收款") + myAmt + "</font>" + $g("元，是否继续？");
				} else {
					msg = ($g("需要") + "<font color=\"red\">" + $g("退款") + myAmt + "</font>" + $g("元，是否继续？")) + ((isReclaimCard == 1) ? ("<br>" + $g("其中退卡费：") + myCardFareCost + $g("元")) : "");
				}
				$.messager.confirm("确认", msg, function(r) {
					return r ? resolve() : reject();
				});
			});
		});
	};
	
	var _chkUnprint = function() {
		return new Promise(function (resolve, reject) {
			var rtn = $.m({ClassName: "web.UDHCAccPrtPayFoot", MethodName: "CheckUnPrintINV", AccRowID: accMRowId, HospId: session['LOGON.HOSPID']}, false);
			if (rtn == 0) {
				return resolve();
			}
			$.messager.alert("提示", "存在未打印发票，请确认纸质发票已放好并打印", "info", function() {
				resolve();
			});
			return;
		});
	};
	
	var _foot = function() {
		return new Promise(function (resolve, reject) {
			var myPDInfo = BuildPDInfo();
			var myPDPMInfo = BuildPDMInfo();
			var expStr = myCardRowID + "^" + session['LOGON.GROUPID'] + "^" + isReclaimCard + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
			expStr += "^" + ClientIPAddress;
			var rtn = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "AccFootMan", AccRowID: accMRowId, UserDR: session['LOGON.USERID'], BadPrice: myBadPrice, PDInfo: myPDInfo, PDPMInfo: myPDPMInfo, ExpStr: expStr}, false);
			var myAry = rtn.split(String.fromCharCode(2));
			if (myAry[0] == 0) {
				accPayInvIdStr = myAry[1] || "";
				parkPreDepRowId = myAry[2] || "";
				parkCardInvRowId = myAry[3] || "";
				initCardInvRowId = myAry[4] || "";
				setValueById("APINVStr", accPayInvIdStr);
				return resolve();
			}
			$.messager.alert("提示", ("账户结算失败，错误代码：" + myAry[0]), "error");
			reject();
		});
	};
	
	var _success = function() {
		//+2023-03-06 ZhYW 
		var msg = "账户结算成功";
		var iconCls = "success";
		if (parkCardInvRowId != "") {
			var tradeType = "CARD";
			var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'];
			var refSrvRtnObj = RefundPayService(tradeType, initCardInvRowId, parkCardInvRowId, "", "", tradeType, expStr);
			if (refSrvRtnObj.ResultCode != 0) {
				msg = $g("HIS退卡成功，第三方退款失败：") + refSrvRtnObj.ResultCode + $g("，错误代码：") + refSrvRtnObj.ResultMsg;
				iconCls = "error";
			}
		}
		$.messager.alert("提示", msg, iconCls);

		//print DHC_AccINVPay
		//Print Patient Pay List and PreDeposit List
		DHCP_GetXMLConfig("InvPrintEncrypt", GV.PrtXMLName);
		BillPrintNew(accPayInvIdStr);
		if (parkPreDepRowId != "") {
			GV.CardCostFlag = "";
			PatRegPatInfoPrint(parkPreDepRowId, "UDHCAccDeposit", "ReadAccDPEncrypt");
		}
		if (parkCardInvRowId != "") {
			GV.CardCostFlag = "Y";
			PatRegPatInfoPrint(parkCardInvRowId, "UDHCCardInvPrt", "ReadAccCarDPEncrypt");
		}
	};
	
	if ($("#Foot").linkbutton("options").disabled) {
		return;
	}
	$("#Foot").linkbutton("disable");
	
	var accMRowId = getValueById("AccRowID");
	var accMLeft = getValueById("AccLeft");
	var myReturnSum = getValueById("ReturnSum");
	var myCardFareCost = getValueById("CardFareCost");  //卡费
	var myCardChequeNo = getValueById("CardChequeNo");
	var myBank = getValueById("Bank");
	var needCancelReg = getValueById("NeedCancelReg");
	var myBadPrice = getValueById("BadPrice");
	var myCardRowID = getValueById("CardFRowID");

	var isReclaimCard = 0;  //是否回收卡
	
	var accPayInvIdStr = "";
	var parkPreDepRowId = "";
	var parkCardInvRowId = "";
	var initCardInvRowId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_chkBadPrice)
		.then(_chkUnprint)
		.then(_foot)
		.then(function() {
			_success();
			$("#bPRTDetail, #bRePrint").linkbutton("enable");
		}, function() {
			$("#Foot").linkbutton("enable");
		});
}

function UnPrtDetails_Click() {
	var accMRowId = getValueById("AccRowID");
	AccUnPrtDetails(accMRowId);
}

function clearClick() {
	setValueById("AccRowID", "");
	$(":text:not(#ReceiptNO)").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	$(".checkbox-f").checkbox("setValue", false);
	focusById("CardNo");
}

function PreDList_Click() {
	var accMRowId = getValueById("AccRowID");
	AccPreList(accMRowId);
}

function APayList_Click() {
	var accMRowId = getValueById("AccRowID");
	AccPayList(accMRowId);
}

function IntDoc() {
	getReceiptsNo();
	
	GetReceiptNo();
	
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myAry = rtn.split("^");
	if (myAry[0] == 0) {
		GV.PrtXMLName = myAry[11];
	}
	DHCP_GetXMLConfig("InvPrintEncrypt", GV.PrtXMLName);
}

function readHFMagCardClick() {
	if ($("#ReadCard").linkbutton("options").disabled) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = getValueById("CardNo");
		if (CardNo == "") {
			return;
		}
		DHCACC_GetAccInfo("", CardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		setValueById("SecurityNo", myAry[2]);
		setValueById("PAPMINo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		ReadPatAccInfo();
		GetCardFareCost(myAry[8], myAry[1]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		$.messager.alert("提示", "账户无效", "info", function () {
			focusById("CardNo");
		});
		break;
	default:
	}
}

function BuildPDInfo() {
	var myAry = [];
	myAry[0] = getValueById("ReturnSum") || 0;
	myAry[0] = Math.abs(parseFloat(myAry[0]));
	myAry[1] = session['LOGON.USERID'];
	myAry[2] = "账户结算退款";
	myAry[3] = "";
	myAry[4] = "F";
	myAry[5] = "";
	myAry[6] = session['LOGON.HOSPID'];
	var myInfo = myAry.join("^");
	return myInfo;
}

function BuildPDMInfo() {
	var myAry = [];
	myAry[0] = getValueById("PayMode");
	myAry[1] = getValueById("Bank");
	myAry[2] = getValueById("CardChequeNo");
	myAry[3] = "";
	myAry[4] = "";
	myAry[5] = getValueById("ChequeDate");
	myAry[6] = getValueById("PayAccNO");
	myAry[7] = getValueById("ReturnSum") || 0;
	myAry[7] = Math.abs(parseFloat(myAry[7]));

	return myAry.join("^");
}

function AccPreList(AccMRowID) {
	var url = "dhcbill.opbill.accprelist.csp?AccMRowID=" + AccMRowID;
	websys_showModal({
		url: url,
		title: '预交金明细',
		iconCls: 'icon-w-list'
	});
}

function AccPayList(AccMRowID) {
	var url = "dhcbill.opbill.accpaylist.csp?AccMRowID=" + AccMRowID;
	websys_showModal({
		url: url,
		title: '账户支付明细',
		iconCls: 'icon-w-list',
		width: '85%',
		height: '85%'
	});
}

function AccUnPrtDetails(AccRowID) {
	/*
	var url = "udhcunprtdetails.csp?AccRowID=" + AccRowID;
	websys_showModal({
		url: url,
		title: '未打印账户支付明细',
		iconCls: 'icon-w-list',
		width: 950,
		height: 600
	});
	*/
}

function ReadPatAccInfo() {
	$.m({
		ClassName: "web.UDHCAccManageCLS",
		MethodName: "ReadPatAccInfo",
		PAPMINO: getValueById("PAPMINo"),
		CardNo: getValueById("CardNo"),
		SecurityNo: getValueById("SecurityNo"),
		LangId: session['LOGON.LANGID']
	}, function(rtn) {
		var myAry = rtn.split("^");
		switch(myAry[0]) {
		case "0":
			enableById("Foot");
			var rtn = WrtPatAccInfo(rtn);
			if (!rtn) {
				return;
			}
			CheckPType();
			FootOperTip();
			CheckCheque();
			break;
		default:
			$.messager.popover({msg: t[myAry[0]], type: "info"});
		}
	});
}

function CheckCheque() {
	var accMRowId = getValueById("AccRowID");
	var encmeth = getValueById("CheckCheque");
	if (encmeth == "") {
		return;
	}
	var rtn = cspRunServerMethod(encmeth, accMRowId);
	if (rtn == "true") {
		$.messager.popover({msg: "此账户有非现金支付的预交金，在退预交金时请注意支付方式", type: "info"});
		return;
	}
}

function CheckPType() {
	var rtn = true;
	try {
		var myPreDepSum = getValueById("PreDepSum");
		var myPaySum = getValueById("PaySum");
		var accMLeft = getValueById("AccLeft");
		if (isNaN(myPreDepSum)) {
			myPreDepSum = 0;
		}
		if (isNaN(myPaySum)) {
			myPaySum = 0;
		}
		if (isNaN(accMLeft)) {
			accMLeft = 0;
		}
		myPreDepSum = parseFloat(myPreDepSum);
		myPreDepSum = myPreDepSum.toFixed(2);
		myPaySum = parseFloat(myPaySum);
		myPaySum = myPaySum.toFixed(2);
		accMLeft = parseFloat(accMLeft);
		accMLeft = accMLeft.toFixed(2);
		var mytmpsum = (myPreDepSum - myPaySum).toFixed(2);
		if (+mytmpsum != +accMLeft) {
			$.messager.popover({msg: "账户余额错误", type: "info"});
			return false;
		}
		disableById("FootType");
		if (accMLeft >= 0) {
			setValueById("FootType", "R");
		} else {
			setValueById("FootType", "P");
		}
		$("#ReturnSum").attr("readOnly", true);
		setValueById("ReturnSum", accMLeft);
	} catch (e) {
		$.messager.popover({msg: e.message, type: "error"});
	}
}

function GetReceiptNo() {
	var fairType = "F";
	var insTypeId = "";
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: session['LOGON.USERID'],
		GroupDR: "",
		ExpStr: fairType + "^" + insTypeId + "^" + session['LOGON.HOSPID']
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			var currNo = myAry[1];
			var rowId = myAry[2];
			var endNo = myAry[3];
			var title = myAry[4];
			var leftNum = myAry[5];
			var tipFlag = myAry[6];
			var receiptNo = title + "[" + currNo + "]";
			setValueById("ReceiptNO", receiptNo);
			return;
		}
		$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
	});
}

function getReceiptsNo() {
	$.m({
		ClassName: "web.UDHCAccAddDeposit",
		MethodName: "GetCurrentRecNo",
		userId: session['LOGON.USERID'],
		hospId: session['LOGON.HOSPID']
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			var currNo = myAry[3];
			var title = myAry[4];
			var invoiceId = myAry[5];
			if (invoiceId > 0) {
				setValueById("ReceiptsNo", (title + "[" + currNo + "]"));
			}
			return;
		}
		$.messager.popover({msg: "没有可用预交金收据，请先领取", type: "info"});
	});
}

function Calculate_Click() {
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=" + getValueById("PaySum");
	websys_showModal({
		url: url,
		title: '计算器',
		iconCls: 'icon-w-cal',
		width: 525,
		height: 170
	});
}

function SetPayInfoStatus(isDisable) {
	if(isDisable){
		setValueById("CardChequeNo", "");
		setValueById("PayUnit", "");
		setValueById("PayAccNO", "");
		setValueById("Note", "");
		setValueById("Bank", "");	
		setValueById("ChequeDate", "");	
	}
	$("#CardChequeNo").prop("disabled", isDisable);
	$("#PayUnit").prop("disabled", isDisable);
	$("#PayAccNO").prop("disabled", isDisable);
	$("#Note").prop("disabled", isDisable);
	$("#Bank").combobox({disabled: isDisable});
	$("#ChequeDate").datebox({disabled: isDisable});
}

function WrtPatAccInfo(myPAInfo) {
	var rtn = true;
	var myAry = myPAInfo.split("^");
	setValueById("PAPMINo", myAry[1]);
	setValueById("PAName", myAry[2]);
	setValueById("PatSex", myAry[3]);
	setValueById("PatAge", myAry[4]);
	setValueById("CredType", myAry[5]);
	//setValueById("CredNo", myAry[6]);
	setValueById("AccLeft", myAry[7]);
	setValueById("AccStatus", myAry[8]);
	setValueById("AccNo", myAry[9]);
	setValueById("AccOCDate", myAry[10]);
	setValueById("BadPrice", myAry[11]);
	setValueById("AccDep", myAry[12]);
	setValueById("AccRowID", myAry[13]);
	setValueById("PreDepSum", myAry[14]);
	setValueById("PaySum", myAry[15]);
	setValueById("InsType", myAry[16]);
	setValueById("CardFRowID", myAry[17]);
	setValueById("NeedCancelReg", myAry[18]);
	setValueById("hometel", myAry[20]);
	return rtn;
}

function BillPrintNew(INVstr) {
	var INVtmp = INVstr.split("^");
	for (var i = 0; i < INVtmp.length; i++) {
		if (INVtmp[i] != "") {
			var PayMode = "";
			var userId = session['LOGON.USERID'];
			var userCode = session['LOGON.USERCODE'];
			var expStr = "";
			var encmeth = getValueById("ReadINVDataEncrypt");
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", GV.PrtXMLName, INVtmp[i], userCode, PayMode, expStr);
		}
	}
}

function InvPrintNew(txtInfo, listInfo) {
	DHC_PrintByLodop(getLodop(), txtInfo, listInfo);
}

function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName) {
	if (CurXMLName == "") {
		return;
	}
	var INVtmp = RowIDStr.split("^");
	if (INVtmp.length > 0) {
		DHCP_GetXMLConfig("InvPrintEncrypt", CurXMLName);
	}
	for (var i = 0; i < INVtmp.length; i++) {
		if (INVtmp[i] != "") {
			var encmeth = getValueById(EncryptItemName);
			var userId = session['LOGON.USERID'];
			var userCode = session['LOGON.USERCODE'];
			var expStr = "";
			var myCardFareCost = getValueById("CardFareCost");
			if (GV.CardCostFlag == "Y") {
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCCardInvPrt2");
				var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", myCardFareCost, INVtmp[i], userId, expStr);
			} else {
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCAccDeposit2");
				var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", CurXMLName, INVtmp[i], userId, expStr);
			}
		}
	}
}

function FootOperTip() {
	var accMRowId = getValueById("AccRowID");
	var myEncrypt = getValueById("FootAlTipEncrypt");
	var expStr = "";
	if (myEncrypt != "") {
		var rtn = cspRunServerMethod(myEncrypt, accMRowId, "Foot", expStr);
		var myAry = rtn.split("^");
		if (myAry[0] == 1) {
			$.messager.popover({msg: myAry[1], type: 'info'});
		}
	}
}

function GetCardFareCost(myCardTypeID, myCardNo) {
	var myEncrypt = getValueById("GetCardFareCostEncrypt");
	if (myEncrypt != "") {
		var rtn = cspRunServerMethod(myEncrypt, myCardTypeID, myCardNo);
		setValueById("CardFareCost", rtn);
	}
}

function docKeydown(e) {
	var key = websys_getKey(e);
	if (key == 115) {
		//F4 读卡
		readHFMagCardClick();
	} else if (key == 118) {
		//F7 清屏
		clearClick();
	} else if (key == 120) {
		//F9 结算
		footClick();
	}
}