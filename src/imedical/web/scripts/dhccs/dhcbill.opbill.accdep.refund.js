/**
 * FileName: dhcbill.opbill.accdep.refund.js
 * Anchor: ZhYW
 * Date: 2019-07-29
 * Description: 门诊预交金退款
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkRefableAmt: {    //校验退费金额
	    validator: function(value) {
		    return !GV.RefableAmt || (+value <= +GV.RefableAmt);
		},
		message: "金额不能超过可退金额"
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
		readHFMagCardClick();
		break;
	case 118: //F7
		clearClick();
		break;
	case 120: //F9
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
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array',
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
			disableById("btn-refund");
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
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
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
	}else {
		setTimeout(function() {
			focusById("btn-refund");
		});
		return false;
	}
	return true;
}

function refundClick() {
	if ($("#btn-refund").hasClass("l-btn-disabled")) {
		return;
	}
	checkRefData().then(function () {
	    openAccPDETPList().then(function (initPDRowId) {
		    refundAccDep(initPDRowId);
		});
    });
}

function refundAccDep(initPDRowId) {
	var refAmt = getValueById("refAmt");
	$.messager.confirm("确认", "退款额：<font style='color:red;'>" + refAmt + "</font> 元，是否确认退款?", function (r) {
		if (r) {
			var password = "";
			var accMRowId = getValueById("accMRowId");
			var receiptNo = "";
			var refReason = getValueById("refReason");
			var payMode = getValueById("payMode");
			var bankCardType = getValueById("bankCardType");
			var checkNo = getValueById("checkNo");
			var bank = getValueById("bank");
			var company = getValueById("company");
			var payAccNo = getValueById("payAccNo");
			var chequeDate = getValueById("chequeDate");
			var remark = getValueById("remark");
			var accPDType = "R";
			var depTypeId = getValueById("depositType");
			
			var accPDStr = accMRowId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + receiptNo + "^" + refReason;
			accPDStr += "^" + password + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
			accPDStr += "^" + company + "^" + payAccNo + "^" + chequeDate + "^" + remark + "^" + accPDType;
			accPDStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + initPDRowId + "^" + depTypeId;
			
			accPDStr = accPDStr.replace(/undefined/g, "");   //替换所有的undefined
			
			$.m({
				ClassName: "web.UDHCAccAddDeposit",
				MethodName: "NewDeposit",
				AccPDStr: accPDStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					var accPDRowId = myAry[6];
					
					var msg = "退款成功";
					var iconCls = "success";
					if (isCallPaySvr()) {
						//2020-01-25 ZhYW 第三方退费接口 DHCBillPayService.js
						var tradeType = "PRE";
						var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
						var rtnValue = RefundPayService(tradeType, initPDRowId, accPDRowId, "", refAmt, tradeType, expStr);
						if (rtnValue.ResultCode != 0) {
						    msg = "HIS退费成功，第三方退费失败：" + rtnValue.ResultMsg + "，错误代码：" + rtnValue.ResultCode + "，请补交易";
							iconCls = "error";
						}
					}
					
					$.messager.alert("提示", msg, iconCls, function() {
						accPreDepPrint(accPDRowId);
						reloadRefundMenu();
					});
					break;
				case "passerr":
					$.messager.popover({msg: "密码验证失败", type: "error"});
					break;
				case "amterr":
					$.messager.popover({msg: "金额输入有误", type: "error"});
					break;
				case "noamt":
					$.messager.popover({msg: "余额不足", type: "error"});
					break;
				case "accerr":
					$.messager.popover({msg: "账户有误", type: "error"});
					break;
				case "PayModeErr":
					$.messager.popover({msg: "支付方式为空", type: "error"});
					break;
				default:
					$.messager.popover({msg: "退款失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

function checkRefData() {
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
		if (!isCallPaySvr()) {
			var refAmt = getValueById("refAmt");
			if (!refAmt) {
				$.messager.popover({msg: "请输入金额", type: "info"});
				focusById("refAmt");
				return;
			}
			if (!(refAmt > 0)) {
				$.messager.popover({msg: "金额输入错误", type: "info"});
				focusById("refAmt");
				return;
			}
			var accMLeft = getValueById("accMLeft");
			if (+refAmt > +accMLeft) {
				$.messager.popover({msg: "余额不足", type: "info"});
				focusById("refAmt");
				return;
			}
		}
		if (CV.ReceiptType && !getValueById("receiptNo")) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			return;
		}
		//只有门诊预交金才做二次校验
		if (getValueById("depositType") == getAccPreDepTypeId()) {
			checkMCFPay(resolve);
		}else {
			resolve();
		}
	}).then(function () {
		return openAppendDlg();
	});
}

function checkMCFPay(callback) {
	new Promise(function (resolve, reject) {
        var refAmt = getValueById("refAmt");
        var cardNo = getValueById("CardNo");
        var cardTypeRowId = getValueById("CardTypeRowId");
        DHCACC_CheckMCFPay(refAmt, cardNo, "", cardTypeRowId, "", resolve);
    }).then(function (rtnValue) {
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
        if (!bool) {
	        return;
	    }
        callback();
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

/**
* 第三方支付列表
*/
function openAccPDETPList() {
    return new Promise(function (resolve, reject) {
	 	var initPDRowId = "";
		if (!isCallPaySvr()) {
			return resolve(initPDRowId);
		}
        $("#accPDETPDlg").show();
        var dlgObj = $HUI.dialog("#accPDETPDlg", {
            title: $("#payMode").combobox("getText") + "支付列表",
            iconCls: 'icon-w-list',
            draggable: false,
            resizable: false,
            modal: true,
            onOpen: function () {
                $HUI.datagrid("#accPDETPList", {
                    fit: true,
                    border: false,
                    striped: true,
                    singleSelect: true,
                    rownumbers: true,
                    pagination: true,
                    pageSize: 10,
                    columns: [[{field: 'ck', checkbox: true},
							   {title: '交款时间', field: 'Date', width: 150,
								formatter: function (value, row, index) {
									return value + " " + row.Time;
								}
							   },
							   {title: '金额', field: 'Amt', width: 80, align: 'right'},
							   {title: '支付方式', field: 'PayMDesc', width: 75},
							   {title: '收费员', field: 'UserName', hidden: true},
							   {title: '收据号', field: 'ReceiptNo', hidden: true},
							   {title: 'PDRowId', field: 'PDRowId', hidden: true},
							   {title: '可退金额', field: 'RefableAmt', width: 80, align: 'right',
                                styler: function (value, row, index) {
                                    return 'color: #21ba45;font-weight: bold;';
                                }
							   },
							   {title: 'ETPRowId', field: 'ETPRowId', hidden: true},
							   {title: '卡号/账户号', field: 'ETPPan', width: 100},
							   {title: '交易流水号', field: 'ETPRRN', width: 100},
							   {title: 'HIS订单号', field: 'ETPHISTradeNo', width: 100},
							   {title: '第三方订单号', field: 'ETPExtTradeNo', width: 100}
                        ]],
                    url: $URL,
                    queryParams: {
                        ClassName: "web.UDHCAccAddDeposit",
                        QueryName: "QryAccPDETPList",
                        accMId: getValueById("accMRowId"),
                        paymId: getValueById("payMode"),
                        hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
                        depTypeId: getValueById("depositType")
                    },
                    onDblClickRow: function (index, row) {
	                    var refAmt = getValueById("refAmt");
	                    setValueById("refAmt", (row.RefableAmt < refAmt) ? row.RefableAmt : refAmt);
                        GV.RefableAmt = row.RefableAmt; //给全局变量可退金额赋值，方便校验
                        initPDRowId = row.PDRowId;
                        dlgObj.close();
                    }
                });
            },
            onClose: function () {
                if (initPDRowId) {
                    return resolve(initPDRowId);
                }
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
* 获取"门诊预交金"类型Id
*/
function getAccPreDepTypeId() {
	return $.m({ClassName: "web.UDHCAccAddDeposit",	MethodName: "GetAccPreDepTypeId"}, false);
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
	if (row.Tamt > 0) {
		$.messager.popover({msg: "预交金交款记录，请到【预交金交款】界面补打", type: "info"});
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
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'RowID',
		textField: 'RowID',
		lazy: true,
		data: [],
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
	var _checkTransData = function() {
		return new Promise(function (resolve, reject) {
			if (!accMRowId) {
				$.messager.popover({msg: "账户不存在", type: "info"});
				return;
			}
			if (!episodeId) {
				$.messager.popover({msg: "请选择患者住院就诊", type: "info"});
				return;
			}
			var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetOutAdmInOutDateInfo", EpisodeID: episodeId}, false);
			var disChStatus = rtn.split("^")[3];
			if (disChStatus == "护士办理出院") {
				if (IPBILL_CONF.PARAM.DischgPayDep == "N") {
					$.messager.popover({msg: "该患者已做最终结算，不能转押金", type: "info"});
					return;
				}else {
					var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PAAdm", id: episodeId}, false);
					if (jsonObj.PAADMBillFlag == "Y") {
						$.messager.popover({msg: "该患者已做财务结算，不能转押金", type: "info"});
						return;
					}
				}
			}
			if (!refAmt) {
				$.messager.popover({msg: "请输入金额", type: "info"});
				focusById("refAmt");
				return;
			}
			if (!(refAmt > 0)) {
				$.messager.popover({msg: "金额输入错误", type: "info"});
				focusById("refAmt");
				return;
			}
			if (CV.ReceiptType && !receiptNo) {
				$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
				return;
			}
			var depRcptNo = getValueById("depRcptNo");
			if (!depRcptNo){
				$.messager.popover({msg: "没有可用的住院押金票据，请先领取", type: "info"});
				return;
			}
			if (!payMode) {
				$.messager.popover({msg: "请维护转账支付方式，系统默认取支付方式代码为:DEPZZ", type: "info"});
				return;
			}
			checkMCFPay(resolve);
		});
	}
	
	var _trans2IP = function() {
		var refReason = getValueById("refReason");
		var remark = getValueById("remark");
		var depTypeId = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetIPDepositTypeId"}, false);
		$.messager.confirm("确认", "转账额：<font style='color:red;'>" + refAmt + "</font> 元，确认转入住院押金?", function (r) {
			if (r) {
				var password = "";
				var bankCardType = "";
				var checkNo = "";
				var bank = "";
				var company = "";
				var payAccNo = "";
				var chequeDate = "";
				var accPDType = "R";

				var accPDStr = accMRowId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + receiptNo + "^" + refReason;
				accPDStr += "^" + password + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
				accPDStr += "^" + company + "^" + payAccNo + "^" + chequeDate + "^" + remark + "^" + accPDType;
				accPDStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
				
				var bankBranch = "";
				var transferFlag = "";
				var depStr = depTypeId + "^" + refAmt + "^" + payMode + "^" + company + "^" + bank;
				depStr += "^" + checkNo + "^" + payAccNo + "^" + episodeId + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
				depStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + bankBranch + "^" + remark;
				depStr += "^" + password + "^" + transferFlag + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
				
				$.m({
					ClassName: "web.DHCBillDepConversion",
					MethodName: "AcountTransDeposit",
					RefAcountStr: accPDStr,
					AddDepositStr: depStr
				}, function(rtn) {
					var myAry = rtn.split("^");
					switch(myAry[0]) {
					case "0":
						var accPDRowId = myAry[1];
						var depositId = myAry[2];
						$.messager.alert("提示", "转账成功", "success", function() {
							accPreDepPrint(accPDRowId);
							depositPrint(depositId);
							reloadRefundMenu();
							getIPDepRcptNo();
						});
						break;
					default:
						$.messager.popover({msg: "转账失败：" + rtn, type: "error"});
					}
				});
			}
		});
	}
	
	if ($("#btn-trans2IPDep").hasClass("l-btn-disabled")) {
		return;
	}
	var accMRowId = getValueById("accMRowId");
	var episodeId = getValueById("admList");
	var refAmt = getValueById("refAmt");
	var receiptNo = getValueById("receiptNo");
	var payMode = $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZPayModeID"}, false);
	_checkTransData().then(function () {
	     _trans2IP();
    });
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