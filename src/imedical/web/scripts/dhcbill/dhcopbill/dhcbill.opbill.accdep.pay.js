/**
 * FileName: dhcbill.opbill.accdep.pay.js
 * Author: ZhYW
 * Date: 2019-07-29
 * Description: 门诊预交金充值
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    if (!CV.CfgMaxAmt) {
			    return value < 10000000;
			}
		    return ((value - CV.CfgMaxAmt) <= 0);
		},
		message: $g("金额输入过大")
	}
});
	
$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initPayMenu();
	initAccDepList();
});

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 13:
		focusNextEle(e.target.id);
		break;
	case 115: //F4
		readHFMagCardClick();
		break;
	case 118: //F7
		clearClick();
		break;
	case 120: //F9
		setValueById("payAmt", $("#payAmt").val());   //numberbox在光标未离开时getValue取不到值，故先赋值
		payClick();
		break;
	default:
	}
}

function initPayMenu() {
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	$HUI.linkbutton("#btn-pay", {
		onClick: function () {
			payClick();
		}
	});
	
	$HUI.linkbutton("#btn-calc", {
		onClick: function () {
			calcClick();
		}
	});
	
	//重打
	$HUI.linkbutton("#btn-reprint", {
		onClick: function () {
			reprintClick();
		}
	});
	
	$HUI.linkbutton("#btn-voidInvNo", {
		onClick: function () {
			skipNoClick();
		}
	});
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});
	
	if (CV.DisablePatientNo) {
		$("#patientNo").prop("disabled", CV.DisablePatientNo).css({"font-weight": "bold"});
	}
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	getReceiptNo();
	
	//押金类型
	$HUI.combobox("#depositType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpDepType&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onLoadSuccess: function(data) {
			depositTypeLoadSuccess(data);
		},
		onSelect: function(rec) {
			setValueById("accMLeft", getPreDepLeftAmt());
			loadAccPreDepList();
		}
	});
	
	$(".combo-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
}

function depositTypeLoadSuccess(data) {
	if (CV.WinFrom != "opcharge") {
		return true;
	}
	if (getValueById("depositType") != CV.PreDepTypeId) {
		if ($.hisui.indexOfArray(data, "id", CV.PreDepTypeId) != -1) {
			setValueById("depositType", CV.PreDepTypeId);
		}
	}
	var accMLeft = getValueById("accMLeft");
	var myAmt = Number(getValueById("patFactPaySum")).sub(accMLeft).toFixed(2);
	myAmt = toRound(myAmt, 1, 1);
	$("#payAmt").focus().numberbox("setValue", myAmt);
	getPatInfo();
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var accMRowId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
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
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		$.messager.alert("提示", "账户无效", "info", function () {
			focusById("CardNo");
		});
		break;
	default:
	}
	
	setValueById("patientId", patientId);
	setValueById("accMRowId", accMRowId);
	if (accMRowId != "") {
		getPatInfo();
	}
}

function getReceiptNo() {
	if (!CV.ReceiptType) {
		return;
	}
	$.m({
		ClassName: "web.UDHCAccAddDeposit",
		MethodName: "GetCurrentRecNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		var currNo = myAry[3];
		var title = myAry[4];
		var invoiceId = myAry[5];
		if (invoiceId) {
			setValueById("receiptNo", (title + "[" + currNo + "]"));
			return;
		}
		$.messager.popover({msg: "没有可用收据，请先领取", type: "info"});
		disableById("btn-pay");
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("accMRowId", "");
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			var encmeth = getValueById("GetAccMInfoEncrypt");
			cspRunServerMethod(encmeth, "setAccMInfo", "", patientNo, "", "", "", "", "", PUBLIC_CONSTANT.SESSION.HOSPID);
		});
	}
}

function setAccMInfo(str) {
	var myAry = str.split("^");
	if (!myAry[1]) {
		$.messager.popover({msg: "患者不存在", type: "info"});
		focusById("patientNo");
		return;
	}
	if ((myAry[3] != "N") || !myAry[14]) {
		$.messager.popover({msg: "没有有效账户", type: "info"});
		focusById("patientNo");
		return;
	}
	setValueById("patientNo", myAry[0]);
	setValueById("patientId", myAry[1]);
	setValueById("CardNo", myAry[4]);
	setValueById("accMLeft", myAry[6]);
	setValueById("accMRowId", myAry[14]);
	setValueById("CardTypeRowId", myAry[20]);
	setValueById("CardTypeNew", myAry[21]);
	getPatInfo();
}

function initAccDepList() {
	var selectRowIndex = undefined;
	GV.AccDepList = $HUI.datagrid("#accDepList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCAccAddDeposit",
		queryName: "AccDepDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tdate", "Tjkdate", "PatName", "Tdate", "Tjkdate", "PDType"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "Ttime") {
					cm[i].formatter = function(value, row, index) {
						return row.Tdate + " " + value;
					}
				}
				if (cm[i].field == "Tjktime") {
					cm[i].formatter = function(value, row, index) {
						return row.Tjkdate + " " + value;
					}
				}
				if ($.inArray(cm[i].field, ["Tamt", "Ttype"]) != -1) {
					cm[i].styler = function(value, row, index) {
						return 'font-weight: bold;color:' + ((row.Tamt >= 0) ? '#21ba45;' : '#f16e57;');
					}
				}
				if ($.inArray(cm[i].field, ["TAccPDRowID", "TDepType"]) != -1) {
					cm[i].hidden = true;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Treceiptsno") {
						cm[i].width = 150;
					}
					if (cm[i].field == "Ttime") {
						cm[i].width = 155;
					}
					if (cm[i].field == "Tjktime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function(data) {
			selectRowIndex = undefined;
		},
		onSelect: function(index, row) {
			if (selectRowIndex == index) {
				GV.AccDepList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			if (row.TAccPDRowID) {
				enableById("btn-reprint");
			}else {
				disableById("btn-reprint");
			}
		},
		onUnselect: function(index, row) {
			selectRowIndex = undefined;
			disableById("btn-reprint");
		}
	});
}

function loadAccPreDepList() {
	var queryParams = {
		ClassName: "web.UDHCAccAddDeposit",
		QueryName: "AccDepDetail",
		AccMRowID: getValueById("accMRowId"),
		DepTypeId: getValueById("depositType"),
		SessionStr: getSessionStr()
	};
	loadDataGridStore("accDepList", queryParams);
}

function getPatInfo() {
	var patientId = getValueById("patientId");
	if (!patientId) {
		return;
	}
	$.cm({
		ClassName: "BILL.COM.PAPatMas",
		MethodName: "GetPatientInfo",
		patientId: patientId
	}, function(json) {
		setValueById("patName", json.PatName);
		setValueById("IDNo", json.ID);
		setValueById("mobPhone", json.MobPhone);
	});
	
	if (getValueById("accMRowId")) {
		setValueById("accMLeft", getPreDepLeftAmt());
		loadAccPreDepList();
	}
}

function focusNextEle(id) {
	var myIdx = -1;
	var inputAry = $("#accDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input[id]");
	inputAry.each(function(index, item) {
		if (this.id == id) {
			myIdx = index;
			return false;
		}
	});
	if (myIdx < 0) {
		return true;
	}
	var id = "";
	var $obj = "";
	var nextId = "";
	for (var i = (myIdx + 1); i < inputAry.length; i++) {
		id = inputAry[i].id;
		if (id == "patientNo") {
			continue;
		}
		$obj = $("#" + id);
		if ($obj.parents("tr").is(":hidden")) {
			continue;
		}
		if ($obj.is(":hidden")) {
			if ($obj.next("span").find("input").attr("readonly") == "readonly") {
				continue;
			}
			if ($obj.next("span").find("input").attr("disabled") == "disabled") {
				continue;
			}
		}else {
			if ($obj.attr("disabled") == "disabled") {
				continue;
			}
		}
		nextId = id;
		break;
	}
	if (nextId) {
		focusById(nextId);
		return false;
	}
	setTimeout(function() {
		focusById("btn-pay");
	});
	return false;
}

function payClick() {
	var _validate = function() {
		var _checkMCFPay = function () {
			return new Promise(function (resolve, reject) {
		 		DHCACC_CheckCardNoForDeposit(cardNo, cardTypeId, resolve);
			});
		};
		
		return new Promise(function (resolve, reject) {
			var bool = true;
			$(".validatebox-text").each(function(index, item) {
				if (!$(this).validatebox("isValid")) {
					bool = false;
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			if (!accMRowId) {
				$.messager.popover({msg: "账户不存在", type: "info"});
				return reject();
			}
			if (!payAmt) {
				$.messager.popover({msg: "请输入金额", type: "info"});
				focusById("payAmt");
				return reject();
			}
			if (!(payAmt > 0)) {
				$.messager.popover({msg: "金额输入错误", type: "info"});
				focusById("payAmt");
				return reject();
			}
			if (CV.ReceiptType && (receiptNo == "")) {
				$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
				return reject();
			}
		 	_checkMCFPay().then(function (bool) {
			 	if (!bool) {
					return reject();
				}
				resolve();
			});
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("收款") + "：<font style='color:red;'>" + payAmt + "</font> " + $g("元，是否确认交款？")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 生成支付方式列表
	* 如果有第三方支付也在此方法中完成
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			var argumentObj = {
				title: '收银台-预交金交款',
				cardNo: cardNo,
		        cardTypeId: cardTypeId,
				patientId: patientId,
				accMRowId: accMRowId,
				accMLeft: accMLeft,
				typeFlag: "DEP",
				payAmt: payAmt,
				bizType: "PRE"
			};
			return BILL_INF.showCheckout(argumentObj).then(function (payMList) {
			    paymStr = payMList;
		        resolve();
		    }, function () {
		        reject();
		    });
		});
	};
	
	/**
	* 充值
	*/
	var _pay = function() {
		return new Promise(function (resolve, reject) {
			var accPDAry = [];
			accPDAry.push(payAmt);
			accPDAry.push(PUBLIC_CONSTANT.SESSION.USERID);
			accPDAry.push(refReason);
			accPDAry.push(password);
			accPDAry.push(accPDType);
			accPDAry.push(remark);
			accPDAry.push(PUBLIC_CONSTANT.SESSION.HOSPID);
			accPDAry.push(initPDRowId);
			accPDAry.push(depTypeId);
			accPDAry.push(accPayInvId);  //+2023-04-21 ZhYW 用于集中打印发票医保分解返钱，这里只为占位
			accPDAry.push(cardNo);       //+2023-04-21 ZhYW 就诊卡卡号
			accPDAry.push(cardTypeId);   //+2023-04-21 ZhYW 就诊卡卡类型
			var accPDStr = accPDAry.join("^");
			
			var rtn = $.m({
				ClassName: "web.UDHCAccAddDeposit",
				MethodName: "NewDeposit",
				AccRowID: accMRowId,
				PDInfo: accPDStr,
				PDPMInfo: paymStr
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				accPDRowId = myAry[1];
				$.messager.alert("提示", "交款成功", "success", function() {
					return resolve();
				});
				return;
			}
	        $.messager.alert("提示", ($g("交款失败：") + (myAry[1] || myAry[0])), "error");
			return reject();
		});
	};
	
	var _success = function() {
		accPreDepPrint(accPDRowId);
		reloadPayMenu();
		if (CV.WinFrom == "opcharge") {
			websys_showModal("options").callbackFunc();
			websys_showModal("close");
		}
	};
	
	/**
	* 撤销第三方交易
	*/
	var _cancelPaySrv = function() {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
		$.each(paymStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2), function(index, item) {
			if (!item) {
				return true;
			}
			var myPayMAry = item.split("^");
			var myETPRowID = myPayMAry[11];
			if (!(myETPRowID > 0)) {
				return true;
			}
			var rtnValue = CancelPayService(myETPRowID, expStr);
			if (rtnValue.ResultCode != 0) {
				$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
			}
		});
	};
	
	if ($("#btn-pay").linkbutton("options").disabled) {
		return;
	}
	$("#btn-pay").linkbutton("disable");
	
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var receiptNo = getValueById("receiptNo");
	var patientId = getValueById("patientId");
	var accMRowId = getValueById("accMRowId");
	var accMLeft = getValueById("accMLeft");
	var payAmt = getValueById("payAmt");
	var password = "";
	var refReason = "";
	var remark = getValueById("remark");
	var accPDType = "P";
	var depTypeId = getValueById("depositType");
	var initPDRowId = "";
	var accPayInvId = "";    //+2023-04-21 ZhYW 用于集中打印发票医保分解返钱
	var paymStr = "";        //支付方式串
	var accPDRowId = "";     //充值记录的Id
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_buildPayMList)
		.then(_pay)
		.then(function() {
			_success();
			$("#btn-pay").linkbutton("enable");
		}, function () {
			_cancelPaySrv();
			$("#btn-pay").linkbutton("enable");
		});
}

function reloadPayMenu() {
	$("#remark").val("");
	$("#payAmt").numberbox("clear");
	setValueById("accMLeft", getPreDepLeftAmt());
	if (CV.ReceiptType) {
		getReceiptNo();
	}
	loadAccPreDepList();
}

/**
* 根据押金类型获取对应的押金余额
*/
function getPreDepLeftAmt() {
	var accMRowId = getValueById("accMRowId");
	var depTypeId = getValueById("depositType");
	return (accMRowId > 0) ? $.m({ClassName: "web.UDHCAccAddDeposit", MethodName: "GetPreDepLeftAmt", accM: accMRowId, depTypeId: depTypeId}, false) : "";
}

function reprintClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.AccDepList.getSelected();
			if (!row || !row.TAccPDRowID) {
				$.messager.popover({msg: "请选择要补打的预交金记录", type: "info"});
				return reject();
			}
			if (row.Tamt < 0) {
				$.messager.popover({msg: "预交金退款记录，请到【预交金退款】界面补打", type: "info"});
				return reject();
			}
			accPDRowId = row.TAccPDRowID;
			resolve();
	    });
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认补打？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	if ($("#btn-reprint").linkbutton("options").disabled) {
		return;
	}
	$("#btn-reprint").linkbutton("disable");
	
	var accPDRowId = "";
	var reprtFlag = 1;
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function () {
			accPreDepPrint(accPDRowId + "#" + reprtFlag);
			$("#btn-reprint").linkbutton("enable");
		}, function () {
			$("#btn-reprint").linkbutton("enable");
		});
}

function clearClick() {
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	$(":text:not(.pagination-num,.combo-text)").val("");
	focusById("CardNo");
	$(".numberbox-f").numberbox("clear");
	$(".combobox-f").combobox("reload");
	loadAccPreDepList();
	if (CV.ReceiptType) {
		getReceiptNo();
	}
}

/**
 * 门诊预交金跳号
 */
function skipNoClick() {
	var argumentObj = {
		receiptType: "OD"
	};
	BILL_INF.showSkipInv(argumentObj).then(getReceiptNo);
}

function calcClick() {
	var iHeight = 400;
	var iWidth = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	websys_createWindow(lnk, "udhcOPCashExpCal", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}