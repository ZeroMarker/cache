/**
 * FileName: dhcbill.opbill.accdep.refund.js
 * Author: ZhYW
 * Date: 2019-07-29
 * Description: 门诊预交金退款
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkRefableAmt: {    //校验退费金额
	    validator: function(value) {
		    return !GV.RefableAmt || (+value <= +GV.RefableAmt);
		},
		message: $g("金额不能超过可退金额")
	}
});

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initRefundMenu();
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
		e.preventDefault();      //F6
		readHFMagCardClick();
		break;
	case 118: //F7
		e.preventDefault();      //F6
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();      //F6
		setValueById("refAmt", $("#refAmt").val());   //numberbox在光标未离开时getValue取不到值，故先赋值
		refundClick();
		break;
	default:
	}
}

function initRefundMenu() {
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//读身份证
	$HUI.linkbutton("#btn-readIDCard", {
		onClick: function () {
			readIDCardClick();
		}
	});
	
	$HUI.linkbutton("#btn-refund", {
		onClick: function () {
			refundClick();
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
	
	$HUI.linkbutton("#btn-trans2IPDep", {
		onClick: function () {
			trans2IPDepClick();
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

	//登记号回车查询事件
	if (CV.DisablePatientNo) {
		$("#patientNo").prop("disabled", CV.DisablePatientNo).css({"font-weight": "bold"});
	}
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//退押金金额
	$HUI.numberbox("#accMLeft", {
		onChange: function(newValue, oldValue) {
			GV.RefableAmt = newValue;
		}
	});
	
	if ($("#depRcptNo").length > 0) {
		getIPDepRcptNo();
	}
	if ($("#admList").length > 0) {
		initAdmList();
	}
	
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
		onSelect: function(rec) {
			setValueById("accMLeft", getPreDepLeftAmt());
			loadAccPreDepList();
		},
		onChange: function(newValue, oldValue) {
			$("#btn-trans2IPDep").linkbutton({disabled: (newValue != CV.PreDepTypeId)});
		}
	});
	
	//支付方式
	$HUI.combobox("#payMode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "RDEP";
		},
		onLoadSuccess: function(data) {
			$.each(data, function (index, item) {
				if (item.selected) {
					setValueById("requiredFlag", item.RPFlag);
					return false;
				}
			});
		},
		onSelect: function(rec) {
			setValueById("requiredFlag", rec.RPFlag);
		}
	});
	
	$(".combo-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
	
	getReceiptNo();
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
	
	//+WangXQ 2023-04-12 判断是否为配置的只能充值不能退款的卡类型
	if(isAllowedRefDepByCardType(getValueById("CardTypeRowId"))) {
		$.messager.alert("提示", "卡类型为" + getValueById("CardTypeNew") + "的就诊卡，只能充值不能退款", "info");
		disableById("btn-refund");
	}else {
		enableById("btn-refund");
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
		disableById("btn-refund");
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
		loadAdmList();
		setValueById("accMLeft", getPreDepLeftAmt());
		loadAccPreDepList();
	}
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCBillDepConversion",
		QueryName: "QueryIPAdmByAccountID",
		AccountID: getValueById("accMRowId"),
		SessionStr: getSessionStr()
	}
	loadComboGridStore("admList", queryParams);
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
		focusById("btn-refund");
	});
	return false;
}

function refundClick() {
	var _validate = function() {
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
			$("td:visible label[class='clsRequired']").each(function() {
				var id = $(this).parent().next().find("input")[0].id;
				if (getValueById(id) == "") {
					$.messager.popover({msg: ($g("请选择") + "<font color='red'>" + $(this).text() + "</font>"), type: "info"});
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
			if (!isCallPaySvr()) {
				if (!refAmt) {
					$.messager.popover({msg: "请输入金额", type: "info"});
					focusById("refAmt");
					return reject();
				}
				if (!(refAmt > 0)) {
					$.messager.popover({msg: "金额输入错误", type: "info"});
					focusById("refAmt");
					return reject();
				}
				if (+refAmt > +accMLeft) {
					$.messager.popover({msg: "余额不足", type: "info"});
					focusById("refAmt");
					return reject();
				}
			}
			if (CV.ReceiptType && (receiptNo == "")) {
				$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
				return reject();
			}
			
			if (isCheckUnPayBill()) {
				$.messager.popover({msg: "患者存在未缴费账单，不允许退预交金", type: "info"});
				return reject();
			}
			if (CV.ReceiptType && (receiptNo == "")) {
				$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
				return reject();
			}
			//只有门诊预交金才做二次校验
			if (depTypeId == CV.PreDepTypeId) {
				checkMCFPay().then(function (rtnValue) {
					if (!validateCard(rtnValue)) {
						return reject();
					}
					resolve();
				});
				return;
			}
			resolve();
		});
	};
	
	/**
	* openAccPDETPList()中获取原交押金记录Id，支付方式，重新计算退款金额
	*/
	var _resetRefInfo = function(obj) {
		return new Promise(function (resolve, reject) {
			if ($.isEmptyObject(obj)) {
				return resolve();
			}
			initPDRowId = obj.initId;
			payMode = obj.refmode;
			refAmt = obj.refAmt;    //这里重新取是因为在openAccPDETPList()中会修改refAmt
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("退款") + "：<font style='color:red;'>" + refAmt + "</font> " + $g("元，是否确认退款？")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 退预交金
	*/
	var _refund = function() {
		return new Promise(function (resolve, reject) {
			var accPDAry = [];
			accPDAry.push(refAmt);
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
			
			var paymAry = [];
			paymAry.push(payMode);
			paymAry.push(bank);
			paymAry.push(checkNo);
			paymAry.push(bankCardType);
			paymAry.push(company);
			paymAry.push(chequeDate);
			paymAry.push(payAccNo);
			paymAry.push(refAmt);
			var paymStr = paymAry.join("^");     //支付方式串
			
			var rtn = $.m({
				ClassName: "web.UDHCAccAddDeposit",
				MethodName: "NewDeposit",
				AccRowID: accMRowId,
				PDInfo: accPDStr,
				PDPMInfo: paymStr
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				abortPDRowId = myAry[1];
				return resolve();
			}
			$.messager.popover({msg: ($g("退款失败：") + (myAry[1] || myAry[0])), type: "error"});
			return reject();
		});
	};
	
	/**
	 * 第三方退费接口
	 */
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			if (!isCallPaySvr()) {
				return resolve();
			}
			//第三方退费接口 DHCBillPayService.js
			var tradeType = "PRE";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			srvRtnObj = RefundPayService(tradeType, initPDRowId, abortPDRowId, "", refAmt, tradeType, expStr);
			resolve();
		});
	};

	var _success = function() {
		var msg = $g("退款成功");
		var iconCls = "success";
		if (!$.isEmptyObject(srvRtnObj) && (srvRtnObj.ResultCode != 0)) {
			msg = $g("HIS退款成功，第三方退款失败：") + srvRtnObj.ResultMsg + $g("，错误代码：") + srvRtnObj.ResultCode + $g("，请补交易");
			iconCls = "error";
		}
		$.messager.alert("提示", msg, iconCls, function() {
			accPreDepPrint(abortPDRowId);
			reloadRefundMenu();
		});
	};
	
	if ($("#btn-refund").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refund").linkbutton("disable");	
	
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var receiptNo = getValueById("receiptNo");
	var accMLeft = getValueById("accMLeft");
	var refAmt = getValueById("refAmt");
	var password = "";
	var accMRowId = getValueById("accMRowId");
	var refReason = getValueById("refReason");
	var payMode = getValueById("payMode");
	var remark = getValueById("remark");
	var accPDType = "R";
	var depTypeId = getValueById("depositType");
	var accPayInvId = "";       //+2023-04-21 ZhYW 用于集中打印发票医保分解返钱
	var initPDRowId = "";       //待退预交金记录Id
	var abortPDRowId = "";      //退预交金记录Id
	//支付方式信息
	var bankCardType = getValueById("bankCardType");
	var checkNo = getValueById("checkNo");
	var bank = getValueById("bank");
	var company = getValueById("company");
	var payAccNo = getValueById("payAccNo");
	var chequeDate = getValueById("chequeDate");
	
	var srvRtnObj = {};         //第三方退费返回对象

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(openAppendDlg)
		.then(openAccPDETPList)
		.then(function (obj) {
			_resetRefInfo(obj);
		})
		.then(_cfr)
		.then(_refund)
		.then(_refSrv)
		.then(function () {
			_success();
			$("#btn-refund").linkbutton("enable");
		}, function () {
			$("#btn-refund").linkbutton("enable");
		});
}

function checkMCFPay() {
	return new Promise(function (resolve, reject) {
        var refAmt = getValueById("refAmt");
        var cardNo = getValueById("CardNo");
        var cardTypeId = getValueById("CardTypeRowId");
        DHCACC_CheckMCFPay(refAmt, cardNo, "", cardTypeId, "", resolve);
    });
}

function validateCard(rtnValue) {
	var bool = false;
    var myAry = rtnValue.split("^");
    switch (myAry[0]) {
    case "0":
        bool = true;
        break;
    case "-204":
        $.messager.popover({msg: "密码验证失败", type: "info"});
        break;
    case "-205":
        $.messager.popover({msg: "账户余额不足", type: "info"});
        break;
    case "-206":
        $.messager.popover({msg: "卡号不一致，请插入原卡", type: "info"});
        break;
    case "-208":
        bool = true;
        break;
    default:
    }
    return bool;
}

function openAppendDlg() {
    return new Promise(function (resolve, reject) {
        $("#appendDlg").form("clear");
        if (getValueById("requiredFlag") != "Y") {
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
				var patientId = getValueById("patientId");
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
                focusById("checkNo");
                var id = "";
                $("#appendDlg").find("input[id]").each(function (index, item) {
                    if ($(this).is(":hidden")) {
                        $(this).next("span").find("input").keydown(function (e) {
                            id = $(this).parents("td").find("input")[0].id;
                            var key = websys_getKey(e);
                            if (key == 13) {
                                _setNextFocus(id);
                            }
                        });
                    } else {
                        $(this).keydown(function (e) {
                            var key = websys_getKey(e);
                            if (key == 13) {
                                _setNextFocus(this.id);
                            }
                        });
                    }
                });

                function _setNextFocus(id) {
                    var myIdx = -1;
                    var inputAry = $("#appendDlg").find("input[id]");
                    inputAry.each(function (index, item) {
                        if (this.id == id) {
                            myIdx = index;
                            return false;
                        }
                    });
                    if (myIdx < 0) {
                        return;
                    }
                    var id = "";
                    var $obj = "";
                    var nextId = "";
                    for (var i = (myIdx + 1); i < inputAry.length; i++) {
                        id = inputAry[i].id;
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
                        } else {
                            if ($obj.attr("disabled") == "disabled") {
                                continue;
                            }
                        }
                        nextId = id;
                        break;
                    }
                    if (nextId) {
                        focusById(nextId);
                        return;
                    }
                	setTimeout(function () {
                     	focusById("btn-ok");
                	}, 20);
                }
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
                                $.messager.popover({msg: "请输入<font color=red>" + $(this).text() + "</font>", type: "info"});
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

/**
* 第三方支付列表
*/
function openAccPDETPList() {
    return new Promise(function (resolve, reject) {
	 	var refObj = {};
		if (!isCallPaySvr()) {
			return resolve(refObj);
		}
        $("#accPDETPDlg").show();
        var dlgObj = $HUI.dialog("#accPDETPDlg", {
            title: $("#payMode").combobox("getText") + $g("支付列表"),
            iconCls: 'icon-w-list',
            draggable: false,
            resizable: false,
            modal: true,
            onOpen: function () {
                $HUI.datagrid("#accPDETPList", {
                    fit: true,
                    border: false,
                    singleSelect: true,
                    rownumbers: true,
                    pagination: true,
                    pageSize: 10,
                    className: "web.UDHCAccAddDeposit",
					queryName: "QryAccPDETPList",
					onColumnsLoad: function(cm) {
						cm.unshift({field: 'ck', checkbox: true});  //将复选框添加到数组起始位置
						for (var i = (cm.length - 1); i >= 0; i--) {
							if ($.inArray(cm[i].field, ["Date"]) != -1) {
								cm.splice(i, 1);
								continue;
							}
							if ($.inArray(cm[i].field, ["PayMRowId", "PDRowId", "ETPRowId", "IsTimeout"]) != -1) {
								cm[i].hidden = true;
								continue;
							}
							if (cm[i].field == "Time") {
								cm[i].title = "交款时间";
								cm[i].formatter = function(value, row, index) {
									return row.Date + " " + value;
								}
							}
							if (cm[i].field == "RefableAmt") {
								cm[i].styler = function(value, row, index) {
									return "color: #21ba45;font-weight: bold;";
								}
							}
							if (cm[i].field == "UserName") {
								cm[i].title = "收费员";
							}
							if (!cm[i].width) {
								cm[i].width = 100;
								if (cm[i].field == "Time") {
									cm[i].width = 155;
								}
							}
						}
					},
                    url: $URL,
                    queryParams: {
                        ClassName: "web.UDHCAccAddDeposit",
                        QueryName: "QryAccPDETPList",
                        accMId: getValueById("accMRowId"),
                        paymId: getValueById("payMode"),
                        hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
                        depTypeId: getValueById("depositType")
                    },
                    rowStyler: function(index, row) {
						if (row.IsTimeout == 1) {
							return "color: #C0C0C0;";
						}
					},
                    onLoadSuccess: function (data) {
						//显示不可退费原因
						$.each(data.rows, function (index, row) {
							if (row.IsTimeout == 1) {
								$HUI.datagrid("#accPDETPList").getPanel().find(".datagrid-row[datagrid-row-index=" + index + "]>td>div:not(.datagrid-cell-rownumber)").mouseover(function() {
									$(this).popover({
										title: '不能退费原因',
										trigger: 'hover',
										content: "已经超过可退时限，不能退费"
									}).popover("show");
								});
							}
						});
					},
                    onDblClickRow: function (index, row) {
	                    if (row.IsTimeout == 1) {
		                    return;
		                }
	                    var refAmt = getValueById("refAmt");
	                    refAmt = (refAmt && (+refAmt < +row.RefableAmt)) ? refAmt : row.RefableAmt;
	                    setValueById("refAmt", refAmt);
                        GV.RefableAmt = row.RefableAmt;  //给全局变量可退金额赋值，方便校验
                       	refObj = {initId: row.PDRowId, refmode: row.PayMRowId, refAmt: refAmt};
                        resolve(refObj);
                   		dlgObj.close();
                    }
                });
            },
            onClose: function () {
	            reject();
            }
        });
    });
}

function reloadRefundMenu() {
	$("#remark, #refReason").val("");
	$("#refAmt").numberbox("clear");
	$("#payMode").combobox("reload");
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
	var depositTypeId = getValueById("depositType");
	return (accMRowId > 0) ? $.m({ClassName: "web.UDHCAccAddDeposit", MethodName: "GetPreDepLeftAmt", accM: accMRowId, depTypeId: depositTypeId}, false) : "";
}

function reprintClick() {
	if ($("#btn-reprint").linkbutton("options").disabled) {
		return;
	}
	var row = GV.AccDepList.getSelected();
	if (!row || !row.TAccPDRowID) {
		$.messager.popover({msg: "请选择要补打的预交金记录", type: "info"});
		return;
	}
	if (row.Tamt > 0) {
		$.messager.popover({msg: "预交金交款记录，请到【预交金交款】界面补打", type: "info"});
		return;
	}
	var accPDRowId = row.TAccPDRowID;
	var reprtFlag = 1;
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (!r) {
			return;
		}
		accPreDepPrint(accPDRowId + "#" + reprtFlag);
	});
}

function clearClick() {
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	setValueById("requiredFlag", "");
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	
	GV.RefableAmt = 0;
	$(".numberbox-f").numberbox("clear");
	$("#refAmt").numberbox("isValid");
	
	$(".combobox-f").combobox("reload");
	loadAccPreDepList();
	if (CV.ReceiptType) {
		getReceiptNo();
	}
	if ($("#depRcptNo").length > 0) {
		getIPDepRcptNo();
	}
	if ($("#admList").length > 0) {
		$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {
			total: 0,
			rows: []
		});
	}
}

function getIPDepRcptNo() {
	if (CV.IPReceiptType == 1) {
		return;   //2022-07-22 ZhYW 押金收据号自动生成时不取票据号
	}
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "GetRcptNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		var rcptId = myAry[0];
		var endNo = myAry[1];
		var currNo = myAry[2];
		var title = myAry[3];
		if (rcptId) {
			setValueById("depRcptNo", (title + "[" + currNo + "]"));
		}
	});
}

function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 490,
		panelHeight: 200,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'RowID',
		textField: 'RowID',
		lazy: true,
		columns: [[{field: 'RowID', title: 'RowID', hidden: true},
				   {field: 'AdmNo', title: 'AdmNo', hidden: true},
				   {field: 'PatNo', title: 'PatNo', hidden: true},
				   {field: 'PatName', title: 'PatName', hidden: true},
		           {field: 'AdmDate', title: '入院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.AdmTime;
							}
						}
					},
					{field: 'AdmDep', title: '科室病区', width: 180,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.AdmWard;
							}
						}
					},
					{field: 'AdmBed', title: '床号', width: 50},
					{field: 'AdmStatus', title: '就诊状态', width: 80}
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
		}
	});
}

function trans2IPDepClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!accMRowId) {
				$.messager.popover({msg: "账户不存在", type: "info"});
				return reject();
			}
			if (!episodeId) {
				$.messager.popover({msg: "请选择患者住院就诊", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetOutAdmInOutDateInfo", EpisodeID: episodeId}, false);
			var disChStatus = rtn.split("^")[8];
			if (disChStatus == "F") {
				if (IPBILL_CONF.PARAM.DischgPayDep == "N") {
					$.messager.popover({msg: "该患者已做最终结算，不能转押金", type: "info"});
					return reject();
				}
				var admBillFlag = getPropValById("PA_Adm", episodeId, "PAADM_BillFlag");
				if (admBillFlag == "Y") {
					$.messager.popover({msg: "该患者已做财务结算，不能转押金", type: "info"});
					return reject();
				}
			}
			if (!refAmt) {
				$.messager.popover({msg: "请输入金额", type: "info"});
				focusById("refAmt");
				return reject();
			}
			if (!(refAmt > 0)) {
				$.messager.popover({msg: "金额输入错误", type: "info"});
				focusById("refAmt");
				return reject();
			}
			if (CV.ReceiptType && !receiptNo) {
				$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
				return reject();
			}
			if ((CV.IPReceiptType != 1) && (!depRcptNo)) {
				$.messager.popover({msg: "没有可用的住院押金票据，请先领取", type: "info"});
				return reject();
			}
			if (!payMode) {
				$.messager.popover({msg: "请维护转账支付方式，系统默认取支付方式代码为:DEPZZ", type: "info"});
				return reject();
			}
			checkMCFPay().then(function (rtnValue) {
				if (!validateCard(rtnValue)) {
					return reject();
				}
				resolve();
			});
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("转账") + "：<font style='color:red;'>" + refAmt + "</font> " + $g("元，确认转入住院押金？")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _trans = function() {
		return new Promise(function (resolve, reject) {
			var password = "";
			var bankCardType = "";
			var checkNo = "";
			var bank = "";
			var company = "";
			var payAccNo = "";
			var chequeDate = "";
			var accPDType = "R";

			var accPDStr = accMRowId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + refReason;
			accPDStr += "^" + password + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
			accPDStr += "^" + company + "^" + payAccNo + "^" + chequeDate + "^" + remark + "^" + accPDType;
			accPDStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			var bankBranch = "";
			var transferFlag = "";
			var depStr = depTypeId + "^" + refAmt + "^" + payMode + "^" + company + "^" + bank;
			depStr += "^" + checkNo + "^" + payAccNo + "^" + episodeId + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
			depStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + remark + "^" + transferFlag + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			$.m({
				ClassName: "web.DHCBillDepConversion",
				MethodName: "AcountTransDeposit",
				RefAcountStr: accPDStr,
				AddDepositStr: depStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					accPDRowId = myAry[1];
					depositId = myAry[2];
					$.messager.popover({msg: "转账成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "转账失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	var _success = function() {
		accPreDepPrint(accPDRowId);
		depositPrint(depositId);
		reloadRefundMenu();
		getIPDepRcptNo();
	};
	
	if ($("#btn-trans2IPDep").linkbutton("options").disabled) {
		return;
	}
	$("#btn-trans2IPDep").linkbutton("disable");
	
	var accMRowId = getValueById("accMRowId");
	var episodeId = getValueById("admList");
	var refAmt = getValueById("refAmt");
	var receiptNo = getValueById("receiptNo");
	var depRcptNo = getValueById("depRcptNo");
	var refReason = getValueById("refReason");
	var remark = getValueById("remark");
	var depTypeId = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetIPDepositTypeId"}, false);
	var payMode = $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZPayModeID"}, false);
	var accPDRowId = "";
	var depositId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_trans)
		.then(function () {
		    _success();
		    $("#btn-trans2IPDep").linkbutton("enable");
		}, function () {
			$("#btn-trans2IPDep").linkbutton("enable");
		});
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

/**
* 是否调用第三方接口
*/
function isCallPaySvr() {
	var payMode = getValueById("payMode");
	var payCallInfo = $.m({ClassName: "DHCBILL.Common.DHCBILLCommon", MethodName: "GetCallModeByPayMode", PayMode: payMode}, false);
	var payCallAry = payCallInfo.split("^");
	var payCallFlag = payCallAry[0];
	return (payCallFlag != 0);
}

/**
* 读身份证
*/
function readIDCardClick() {
	try {
		var myHCTypeDR = "1";
		var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
		//测试串
		//var myInfo = "0^<IDRoot><Age>55</Age><Name>***</Name><Sex>1</Sex><NationDesc>汉</NationDesc><Birth>19620817</Birth><Address>湖南省岳阳市岳阳楼区七里山社区居委会*区**栋***号</Address><CredNo>430105196208171015</CredNo><PhotoInfo></PhotoInfo></IDRoot>"
		var myAry = myInfo.split("^");
		if ((myAry.length > 1) && (myAry[0] == 0)) {
			var IDCardXML = myAry[1];
			var IDObj = new X2JS().xml_str2json(IDCardXML).IDRoot;
			var credNo = IDObj["CredNo"];
			var name = IDObj["Name"];
			setValueById("remark", name + " " + credNo);
		}
	} catch (e) {
		$.messager.popover({msg: "读身份证失败：" + e.message, type: "error"});
	}
}

/**
* tangzf 2022-10-27
* 通用配置--是否判断存在未缴费账单 通用配置-门诊收费系统-退预交金->是否判断存在未缴费账单
*/
function isCheckUnPayBill() {
	var bool = false;
	var data = $.cm({
		ClassName: "BILL.CFG.COM.GeneralCfg",
		MethodName: "GetResultByRelaCode",
		RelaCode: "OPCHRG.PreDepRefd.SFPDCZWJFZD",
		SourceData: "",
		TgtData: "",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		Date: ""
	}, false);
	if(data.data.split("^")[1] == "Yes"){
		var rtn = $.m({ClassName: "web.DHCBillInterface", MethodName: "GetnotPayOrderByRegno", regNo: getValueById("patientNo"), expStr:PUBLIC_CONSTANT.SESSION.HOSPID}, false);
		if (rtn != 0) {
			bool = true;
		}
	}
	return bool;
}

/**
* WangXQ
* 2023-04-12
* 判断是否为配置的只能充值不能退款的卡类型
*/
function isAllowedRefDepByCardType(cardTypeId) {
	return ($.m({ClassName: "web.UDHCAccAddDeposit", MethodName: "IsAllowedRefDepByCardType", cardTypeId: cardTypeId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}