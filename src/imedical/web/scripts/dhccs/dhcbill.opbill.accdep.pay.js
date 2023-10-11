/**
 * FileName: dhcbill.opbill.accdep.pay.js
 * Anchor: ZhYW
 * Date: 2019-07-29
 * Description: 门诊预交金充值
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 100000000;
		},
		message: "金额输入过大"
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
			altVoidInvClick();
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
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array',
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
			param.TypeFlag = "DEP";
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
}

function depositTypeLoadSuccess(data) {
	if (GV.WinFrom != "opcharge") {
		return true;
	}
	if (getValueById("depositType") != CV.PreDepTypeId) {
		$.each(data, function(index, item) {
			if (item.id == CV.PreDepTypeId) {
				setValueById("depositType", CV.PreDepTypeId);
				return false;
			}
		});
	}
	var accMLeft = getValueById("accMLeft");
	var myAmt = numCompute(getValueById("patFactPaySum"), accMLeft, "-");
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
		//setValueById("accMLeft", myAry[3]);
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
		}else {
			$.messager.popover({msg: "没有可用收据，请先领取", type: "info"});
			disableById("btn-pay");
		}
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
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '交款时间', field: 'Tdate', width: 150,
					formatter: function(value, row, index) {
					   	return value + " " + row.Ttime;
 					}
				   },
				   {title: '金额', field: 'Tamt', width: 100, align: 'right',
				  	 styler: function (value, row, index) {
					 	return 'font-weight: bold;color:' + ((row.Tamt >= 0) ? '#21ba45;' : '#f16e57;');
					 }
				   },
				   {title: '交款类型', field: 'Ttype', width: 80,
				   	styler: function (value, row, index) {
					   	return 'font-weight: bold;color:' + ((row.Tamt >= 0) ? '#21ba45;' : '#f16e57;');
					 }
				   },
				   {title: '收费员', field: 'Tuser', width: 80},
				   {title: '收据号', field: 'Treceiptsno', width: 150},
				   {title: '结账时间', field: 'Tjkdate', width: 150,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.Tjktime;
 					}
				   },
				   {title: '当时账户余额', field: 'Taccleft', width: 100, align: 'right'},
				   {title: '支付方式', field: 'Tpaymode', width: 80},
				   {title: '银行卡类型', field: 'Tbankcardtype', width: 100},
				   {title: '支票号', field: 'Tchequeno', width: 100},
				   {title: '银行', field: 'Tbank', width: 100},
				   {title: '支付单位', field: 'Tcompany', width: 100},
				   {title: '账户号', field: 'Tpayaccno', width: 100},
				   {title: '支票日期', field: 'Tchequedate', width: 100},
				   {title: '退款原因', field: 'Tbackreason', width: 100},
				   {title: '备注', field: 'Tremark', width: 100},
				   {title: 'TAccPDRowID', field: 'TAccPDRowID', hidden: true}
			]],
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
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		DepTypeId: getValueById("depositType")
	};
	loadDataGridStore("accDepList", queryParams);
}

function getPatInfo() {
	var patientId = getValueById("patientId");
	if (!patientId) {
		return;
	}
	
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetPatientInfo",
		patientId: patientId
	}, function(jsonObj) {
		setValueById("patName", jsonObj.PAPERName);
		setValueById("IDNo", jsonObj.PAPERID);
		setValueById("mobPhone", jsonObj.PAPERTelH);
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
	}else {
		setTimeout(function() {
			focusById("btn-pay");
		});
		return false;
	}
	return true;
}

function payClick() {
	if ($("#btn-pay").hasClass("l-btn-disabled")) {
		return;
	}
	checkPayData().then(function () {
	    payAccDep();
    });
}

function payAccDep() {
	var payAmt = getValueById("payAmt");
	var payMode = getValueById("payMode");
	var patientId = getValueById("patientId");
	var password = "";
	var accMRowId = getValueById("accMRowId");
	var receiptNo = "";
	var refReason = "";
	var bankCardType = getValueById("bankCardType");
	var checkNo = getValueById("checkNo");
	var bank = getValueById("bank");
	var company = getValueById("company");
	var payAccNo = getValueById("payAccNo");
	var chequeDate = getValueById("chequeDate");
	var remark = getValueById("remark");
	var accPDType = "P";
	var depTypeId = getValueById("depositType");
	var ETPRowID = "";   //第三方交易RowId
	
	//第三方支付回调函数
	var _callback = function (rtnValue) {
		if (rtnValue.ResultCode != 0) {
			$.messager.alert("提示", "支付失败：" + rtnValue.ResultMsg, "error");
			return;
		}
		ETPRowID = rtnValue.ETPRowID;
		_ok();
	}
	
	//充值
	var _ok = function () {
		var initPDRowId = "";
		var accPDStr = accMRowId + "^" + payAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + receiptNo + "^" + refReason;
		accPDStr += "^" + password + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
		accPDStr += "^" + company + "^" + payAccNo + "^" + chequeDate + "^" + remark + "^" + accPDType;
		accPDStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + initPDRowId + "^" + depTypeId;
		
		accPDStr = accPDStr.replace(/undefined/g, "");   //替换所有的undefined
		
		$.m({
			ClassName: "web.UDHCAccAddDeposit",
			MethodName: "NewDeposit",
			AccPDStr: accPDStr,
			ETPRowID: ETPRowID
		}, function(rtn) {
			var myAry = rtn.split("^");
			switch(myAry[0]) {
			case "0":
				var accPDRowId = myAry[6];
				$.messager.alert("提示", "交款成功", "success", function() {
					accPreDepPrint(accPDRowId);
					reloadPayMenu();
					if (getParam("winfrom") == "opcharge") {
						websys_showModal("options").callbackFunc();
						websys_showModal("close");
					}
				});
				break;
			case "passerr":
	            $.messager.popover({msg: "密码验证失败", type: "error"});
	            break;
	        case "amterr":
	            $.messager.popover({msg: "金额输入有误", type: "error"});
	            break;
	        case "accerr":
	            $.messager.popover({msg: "账户有误", type: "error"});
	            break;
	        case "PayModeErr":
	            $.messager.popover({msg: "支付方式为空", type: "error"});
	            break;
	        default:
	            $.messager.popover({msg: "交款失败：" + rtn, type: "error"});
	        }
		});
	}
	
	$.messager.confirm("确认", "收款额：<font style='color:red;'>" + payAmt + "</font> 元，是否确认交款?", function (r) {
		if (r) {
			var episodeId = "";
			var prtRowIdStr = "";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			expStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			expStr += "^" + patientId + "^" + episodeId + "^" + prtRowIdStr + "^^C";
			PayService("PRE", payMode, payAmt, expStr, _callback);
		}
	});
}

function checkPayData() {
	var _checkMCFPay = function (_callback) {
		new Promise(function (resolve, reject) {
			var cardNo = getValueById("CardNo");
			var cardTypeRowId = getValueById("CardTypeRowId");
	 		DHCACC_CheckCardNoForDeposit(cardNo, cardTypeRowId, resolve);
		}).then(function (bool) {
			if (!bool) {
				return;
			}
			_callback();
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
			return;
		}
		var accMRowId = getValueById("accMRowId");
		if (!accMRowId) {
			$.messager.popover({msg: "账户不存在", type: "info"});
			return;
		}
		var payAmt = getValueById("payAmt");
		if (!payAmt) {
			$.messager.popover({msg: "请输入金额", type: "info"});
			focusById("payAmt");
			return;
		}
		if (!(payAmt > 0)) {
			$.messager.popover({msg: "金额输入错误", type: "info"});
			focusById("payAmt");
			return;
		}
		if (CV.ReceiptType && !getValueById("receiptNo")) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			return;
		}
	 	_checkMCFPay(resolve);
	}).then(function () {
		return openAppendDlg();
	});
}

function openAppendDlg() {
    return new Promise(function (resolve, reject) {
        $("#appendDlg").form("clear");
        if (getValueById("requiredFlag") != "Y") {
            return resolve();
        }
        $("#appendDlg").show();
        var dlgObj = $HUI.dialog("#appendDlg", {
            title: '附加项',
            iconCls: 'icon-w-plus',
            draggable: false,
            resizable: false,
            cache: false,
            modal: true,
            onBeforeOpen: function () {
                setValueById("chequeDate", getDefStDate(0));

                //银行卡类型
                $HUI.combobox("#bankCardType", {
                    panelHeight: 'auto',
                    url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankCardType&ResultSetType=array&JSFunName=GetBankCardTypeToHUIJson',
                    method: 'GET',
                    valueField: 'id',
                    textField: 'text',
                    blurValidValue: true,
                    defaultFilter: 5
                });

                //银行
                $HUI.combobox("#bank", {
                    panelHeight: 150,
                    url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson',
                    method: 'GET',
                    valueField: 'id',
                    textField: 'text',
                    blurValidValue: true,
                    defaultFilter: 5
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
                        focusById('btn-ok');
                    }, 20);
                }
            },
            buttons: [{
                    text: '确认',
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
                    text: '关闭',
                    handler: function () {
                        dlgObj.close();
                    }
                }
            ]
        });
    });
}

function reloadPayMenu() {
	$("#remark").val("");
	$("#payAmt").numberbox("clear");
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
	var leftAmt = "";
	if (accMRowId) {
		leftAmt = $.m({ClassName: "web.UDHCAccAddDeposit",	MethodName: "GetPreDepLeftAmt", accM: accMRowId, depTypeId: getValueById("depositType")}, false);
	}
	return leftAmt;
}

function reprintClick() {
	if ($("#btn-reprint").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.AccDepList.getSelected();
	if (!row || !row.TAccPDRowID) {
		$.messager.popover({msg: "请选择要补打的预交金记录", type: "info"});
		return;
	}
	if (row.Tamt < 0) {
		$.messager.popover({msg: "预交金退款记录，请到【预交金退款】界面补打", type: "info"});
		return;
	}
	var accPDRowId = row.TAccPDRowID;
	var reprtFlag = 1;
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (r) {
			accPreDepPrint(accPDRowId + "#" + reprtFlag);
		}
	});
}

function clearClick() {
	delete GV.WinFrom;
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	setValueById("requiredFlag", "");
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
function altVoidInvClick() {
	var receiptType = "OD";
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&receiptType=" + receiptType;
	websys_showModal({
		width: 520,
		height: 227,
		iconCls: 'icon-skip-no',
		title: '门诊预交金跳号',
		url: url,
		onClose: function() {
			getReceiptNo();
		}
	});
}

function calcClick() {
	var iHeight = 400;
	var iWidth = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	websys_createWindow(lnk, "udhcOPCashExpCal", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}