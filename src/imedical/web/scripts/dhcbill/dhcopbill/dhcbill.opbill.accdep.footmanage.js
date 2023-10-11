/**
 * FileName: dhcbill.opbill.accdep.footmanage.js
 * Author: GongX
 * Date: 2023-03-21
 * Description: 门诊账户结算
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	setElementEvent();	//设置页面元素事件
	showBannerTip();   //显示患者信息头
	initDoc();
});

function setElementEvent(){
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
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
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
		valueField: 'value',
		textField: 'text',
		data: [{value: "P", text: $g("缴款")},
			   {value: "R", text: $g("退款")}]
	});
	
	$HUI.combobox("#PatType", {
		panelHeight: 180,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryPatType&ResultSetType=array&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onLoadSuccess: function(data) {
			if (data.length > 0) {
				setValueById("PatType", data[0].id);
			}
		}
	});
	
	$("#ClearWin").linkbutton({
		onClick: function() {
			clearClick();
		}
	});
	
	$("#PreDList").linkbutton({
		onClick: function () {
			preDListClick();
		}
	});
	
	$("#APayList").linkbutton({
		onClick: function() {
			payListClick();
		}
	});
	

	$("#CardNo").focus().keydown(function(e) {
		cardNoKeydown(e);
	});
		
	$("#Foot").linkbutton({
		disabled: true,
		onClick: function() {
			footClick();
		}
	});
}

function footClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (accMRowId == "") {
				$.messager.popover({msg: "账户不存在，请读卡重试", type: "info"});
				return reject();
			}
			//判断是否有未退的除门诊预交金之外的押金信息
			var rtn = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "GetOtherPreDepInfo", accM: accMRowId}, false);
			if (rtn) {
				$.messager.alert("提示", $g("此账户有待退的") + rtn + $g("，请先在【预交金退款】界面退款后再结算账户。"), "info");
				return reject();
			}
			var accMCreatMode = getPropValById("DHC_AccManager", accMRowId, "AccM_CreatMode");
			if (accMCreatMode == "P") {
				$.messager.confirm("确认", "该账户为按患者主索引建的账户，不能结算。是否回收卡？", function(r) {
	                if (!r) {
	                    return reject();
	                }
				    showCancelCardWin(myCardRowID);
				    return reject();
			    });
				return;
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
				if (GV.Required == "Y") {
					return resolve();
				}
                return openAppendDlg().then(function(){
                	resolve();
             	},function(){
                	reject();
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
			var rtn = $.m({ClassName: "web.UDHCAccPrtPayFoot", MethodName: "CheckUnPrintINV", AccRowID: accMRowId, HospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
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
			var myPDInfo = buildPDInfo();
			var myPDPMInfo = buildPDMInfo();
			var expStr = myCardRowID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + isReclaimCard + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			expStr += "^" + ClientIPAddress;
			var rtn = $.m({
				ClassName: "web.UDHCAccManageCLS",
				MethodName: "AccFootMan",
				AccRowID: accMRowId,
				UserDR: PUBLIC_CONSTANT.SESSION.USERID,
				BadPrice: myBadPrice,
				PDInfo: myPDInfo,
				PDPMInfo: myPDPMInfo,
				ExpStr: expStr
			}, false);
			var myAry = rtn.split(String.fromCharCode(2));
			if (myAry[0] == 0) {
				accPayInvIdStr = myAry[1] || "";
				parkPreDepRowId = myAry[2] || "";
				parkCardInvRowId = myAry[3] || "";
				initCardInvRowId = myAry[4] || "";
				setValueById("APINVStr", accPayInvIdStr);
				return resolve();
			}
			$.messager.alert("提示", ("账户结算失败，错误代码：" + (myAry[1] || myAry[0])), "error");
			reject();
		});
	};
	
	var _success = function() {
		return new Promise(function (resolve, reject) {
			//+2023-03-06 ZhYW
			var msg = "账户结算成功";
			var iconCls = "success";
			if (parkCardInvRowId != "") {
				var tradeType = "CARD";
				var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
				var refSrvRtnObj = RefundPayService(tradeType, initCardInvRowId, parkCardInvRowId, "", "", tradeType, expStr);
				if (refSrvRtnObj.ResultCode != 0) {
					msg = $g("HIS退卡成功，第三方退款失败：") + refSrvRtnObj.ResultCode + $g("，错误代码：") + refSrvRtnObj.ResultMsg;
					iconCls = "error";
				}
			}
			if (CV.WinFrom != "") {
				$.messager.alert("提示", msg, iconCls);
				return resolve();
			}
			//退卡
			$.messager.confirm("确认", msg + "，是否回收卡？", function(r) {
                if (!r) {
                    return resolve();
                }
			    showCancelCardWin(myCardRowID);
			  	resolve();
		    });
		});
	};
	
	/**
	* print DHC_AccINVPay
	* Print Patient Pay List and PreDeposit List
	*/
	var _printInv = function() {
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
	
	var accMRowId = getValueById("AccMRowId");
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
		.then(_success)
		.then(function() {
			_printInv();
			$("#Foot").linkbutton("enable");
		}, function() {
			$("#Foot").linkbutton("enable");
		});
}

function clearClick() {
	setValueById("AccMRowId", "");
	setValueById("SecurityNo", "");
	$(":text:not(#ReceiptNO)").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	$(".checkbox-f").checkbox("setValue", false);
	showBannerTip();
	focusById("CardNo");
}

function preDListClick() {
	var myAccRowID = getValueById("AccMRowId");
	accPreList(myAccRowID);
}

function payListClick() {
	var myAccRowID = getValueById("AccMRowId");
	accPayList(myAccRowID);
}

function initDoc() {
	getReceiptsNo();
	getReceiptNo();
	var myrtn = tkMakeServerCall("web.UDHCOPGSConfig", "ReadCFByGRowID", PUBLIC_CONSTANT.SESSION.GROUPID, PUBLIC_CONSTANT.SESSION.HOSPID);
	var myAry = myrtn.split("^");
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
	var patientId = "";
	var securityNo = "";
	var accMRowId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		securityNo = myAry[2];
		patientId = myAry[4];
		setValueById("PatientNo", myAry[5]);
		accMRowId = myAry[7];
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		securityNo = myAry[2];
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		$.messager.alert("提示", "账户无效", "info", function () {
			focusById("CardNo");
		});
		break;
	default:
	}
	
	setValueById("PatientId", patientId);
	setValueById("SecurityNo", securityNo);
	setValueById("AccMRowId", accMRowId);
	if (accMRowId != "") {
		getPatInfo();
	}
}

function buildPDInfo() {
	var myAry = [];
	myAry[0] = getValueById("ReturnSum") || 0;
	myAry[0] = Math.abs(parseFloat(myAry[0]));
	myAry[1] = PUBLIC_CONSTANT.SESSION.USERID;
	myAry[2] = "账户结算退款";
	myAry[3] = "";
	myAry[4] = "F";
	myAry[5] = "";
	myAry[6] = PUBLIC_CONSTANT.SESSION.HOSPID;
	var myInfo = myAry.join("^");
	return myInfo;
}

function buildPDMInfo() {
	var myAry = [];
	myAry[0] = getValueById("PayMode");
	myAry[1] = getValueById("bank");
	myAry[2] = getValueById("checkNo");
	myAry[3] = getValueById("note");   // 备注 note
	myAry[4] = getValueById("company");   // 支付单位 company
	myAry[5] = getValueById("chequeDate");
	myAry[6] = getValueById("payAccNo");
	myAry[7] = getValueById("ReturnSum") || 0;
	myAry[7] = Math.abs(parseFloat(myAry[7]));
	return myAry.join("^");
}

function accPreList(AccMRowID) {
	var url = "dhcbill.opbill.accprelist.csp?AccMRowID=" + AccMRowID;
	websys_showModal({
		url: url,
		title: $g('预交金明细'),
		iconCls: 'icon-w-list'
	});
}

function accPayList(AccMRowID) {
	var url = "dhcbill.opbill.accpaylist.csp?AccMRowID=" + AccMRowID;
	websys_showModal({
		url: url,
		title: $g('账户支付明细'),
		iconCls: 'icon-w-list'
	});
}

function getPatInfo() {
	$.m({
		ClassName: "web.UDHCAccManageCLS",
		MethodName: "ReadPatAccInfo",
		CardNo: getValueById("CardNo"),
		CardTypeId: getValueById("CardTypeRowId"),
		SecurityNo: getValueById("SecurityNo"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			enableById("Foot");
			var rtn = wrtPatAccInfo(rtn);
			if (!rtn) {
				return;
			}
			checkPType();
			checkCheque();
			return;
		}
		$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
	});
}

function checkCheque() {
	var accRowId = getValueById("AccMRowId");
	var rtn = tkMakeServerCall("web.UDHCAccManageCLSIF", "CheckCheque", accRowId);
	if (rtn == "true") {
		$.messager.popover({msg: "此账户有非现金支付的预交金，在退预交金时请注意支付方式", type: "info"});
		return;
	}
}

function checkPType() {
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
			$.messager.popover({msg: "账户余额错误", type: "info"});
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
		$.messager.popover({msg: e.message, type: "error"});
	}
}

function getReceiptNo() {
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: PUBLIC_CONSTANT.SESSION.USERID,
		GroupDR: PUBLIC_CONSTANT.SESSION.GROUPID,
		ExpStr: "F^^" + PUBLIC_CONSTANT.SESSION.HOSPID
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
		}else {
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
		}
	});
}

function getReceiptsNo() {
	$.m({
		ClassName: "web.UDHCAccAddDeposit",
		MethodName: "GetCurrentRecNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
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

function wrtPatAccInfo(myPAInfo) {
	var myAry = myPAInfo.split("^");
	setValueById("PatientNo", myAry[1]);
	setValueById("AccLeft", myAry[7]);
	setValueById("AccStatus", myAry[8]);
	setValueById("AccNo", myAry[9]);
	setValueById("AccOCDate", myAry[10]);
	setValueById("BadPrice", myAry[11]);
	setValueById("AccDep", myAry[12]);
	setValueById("AccMRowId", myAry[13]);
	setValueById("PreDepSum", myAry[14]);
	setValueById("PaySum", myAry[15]);
	setValueById("PatType", myAry[16]);
	setValueById("CardFRowID", myAry[17]);
	setValueById("NeedCancelReg", myAry[18]);
	setValueById("PatientId", myAry[19]);
	setValueById("HomeTel", myAry[20]);
	setValueById("CardFareCost", myAry[22]);   //卡费
	refreshBar(myAry[19], "");
	return true;
}

function billPrintNew(INVstr) {
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var PayMode = "";
			var myExpStr = "";
			var Printinfo = tkMakeServerCall("web.UDHCOPINVPrtIF", "GetOPPrtData", "xmlPrintFun", GV.PrtXMLName, INVtmp[invi], PUBLIC_CONSTANT.SESSION.USERCODE, PayMode, myExpStr);
		}
	}
}

function patRegPatInfoPrint(RowIDStr, CurXMLName, ClassName , MethodName) {
	if (CurXMLName == "") {
		return;
	}
	var INVtmp = RowIDStr.split("^");
	if (INVtmp.length > 0) {
		DHCP_GetXMLConfig("InvPrintEncrypt", CurXMLName);
	}
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var myExpStr = "";
			var myCardFareCost = getValueById("CardFareCost");
			if (GV.CardCostFlag == "Y") {
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCCardInvPrt2");
				var Printinfo = tkMakeServerCall(ClassName , MethodName, "xmlPrintFun", myCardFareCost, INVtmp[invi], PUBLIC_CONSTANT.SESSION.USERID, myExpStr);
			} else {
				DHCP_GetXMLConfig("InvPrintEncrypt", "UDHCAccDeposit2");
				var Printinfo = tkMakeServerCall(ClassName , MethodName, "xmlPrintFun", CurXMLName, INVtmp[invi], PUBLIC_CONSTANT.SESSION.USERID, myExpStr);
			}
		}
	}
}

function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //F7
		//F7 清屏
		e.preventDefault();
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();
		footClick();
		break;
	default:
	}
}

/**
* 附加数据弹出框最新
*/ 
function openAppendDlg() {
    return new Promise(function (resolve, reject) {
        $("#appendDlg").form("clear");
        if (GV.Required != "Y") {
            return resolve();
        }
        $("#appendDlg").show();
        var dlgObj = $HUI.dialog("#appendDlg", {
            title: $g('附加项'),
            iconCls: 'icon-w-plus',
            draggable: false,
            resizable: false,
            cache: false,
            modal: true,
            closable: false,
            onBeforeOpen: function () {
                setValueById("chequeDate", getDefStDate(0));

                //银行卡类型
                $HUI.combobox("#bankCardType", {
                    panelHeight: 'auto',
                    url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryBankCardType&ResultSetType=array',
                    method: 'GET',
                    valueField: 'id',
                    textField: 'text',
                    blurValidValue: true,
                    defaultFilter: 5
                });

                //银行
                $HUI.combobox("#bank", {
                    panelHeight: 150,
                    url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array',
                    method: 'GET',
                    valueField: 'id',
                    textField: 'text',
                    blurValidValue: true,
                    defaultFilter: 5,
                    loadFilter: function(data) {
                        return data.filter(function (item) {
					   		return (item.id > 0);
					  	});
                    }
                });
                
                //公费单位
				var patientId = getValueById("PatientId");
				$HUI.combobox("#company", {
                    panelHeight: 150,
                    url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryHCPList&ResultSetType=array&patientId=' + patientId + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
                    method: 'GET',
                    valueField: 'id',
                    textField: 'text',
                    blurValidValue: true,
                    defaultFilter: 5,
                    loadFilter: function(data) {
                        return data.filter(function (item) {
					   		return (item.id > 0);
					  	});
                    }
                });
            },
            onOpen: function () {
	            var $container = $("#appendDlg");
             	var inputsSelector = ".combo-text,.item-textbox";
           		$container.find(inputsSelector).each(function (index, ele) {
                    if (index == 0) {
                        ele.focus();
                    }
                    $(this).on('keydown', function (e) {
                        var key = websys_getKey(e);
                        if (key == 13) {
                            var inputs = $container.find(inputsSelector); //获取所有输入框
                            var idx = inputs.index(this); //获取当前输入框的位置索引
                            var step = 1;
                            if (idx == inputs.length - 1) {
                                //判断是否是最后一个输入框
                                idx = -1;
                                setTimeout(function () {
                 					focusById("btn-ok");
            					}, 20);
                                return false;
                            }
                            //inputs[idx + step].focus().select();
                            inputs[idx + step].focus();
                            if ($(inputs[idx + step]).hasClass('combo-text')) {
                                $(inputs[idx + step]).parent().prev().combo('showPanel');
                            }
                        }
                        e.stopPropagation();
                    });
                });
            },
            buttons: [{
                    text: $g('确认'),
                    id: 'btn-ok',
                    handler: function () {
                        var bool = true;
                        var id = "";
                        $("#appendDlg label.clsRequired").each(function (index, item) {
                            id = $($(this).parent().next().find("input"))[0].id;
                            if (!id) {
                                return true;
                            }
                            if (!getValueById(id)) {
                                bool = false;
                                focusById(id);
                                $.messager.popover({msg: "请输入<font color=\"red\">" + $(this).text() + "</font>", type: "info"});
                                return false;
                            }
                        });
                        if (!bool) {
                            return;
                        }
                        dlgObj.close();
                        resolve();
                    }
                }, {
                    text: $g('关闭'),
                    handler: function () {
                        dlgObj.close();
                        return reject();
                    }
                }
            ]
        });
    });
}

// 打开退卡窗口
function showCancelCardWin(cardId) {
	var url = "reg.cancelcard.hui.csp?CardID=" + cardId;
	websys_showModal({
		url: url,
		title: $g('退卡'),
		iconCls: 'icon-w-list',
		width: 795,
		height: 475
	});
}