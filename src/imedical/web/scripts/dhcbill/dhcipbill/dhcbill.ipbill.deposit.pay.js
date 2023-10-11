/**
 * FileName: dhcbill.ipbill.deposit.pay.js
 * Author: ZhYW
 * Date: 2019-07-03
 * Description: 住院押金充值
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkNegativeAmt: {    //校验负数
	    validator: function(value) {
		    return value > 0;
		},
		message: $g("金额须大于0")
	},
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 10000000;
		},
		message: $g("金额输入过大")
	}
});

$(function () {
	initPayDepMenu();
	initPayDepList();
});

function initPayDepMenu() {
	$HUI.linkbutton("#btn-pay", {
		onClick: function () {
			payClick();
		}
	});
	
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
	
	getPayRcptNo();
	
	//押金类型
	$HUI.combobox("#payDepositType", {
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
		onChange: function(newValue, oldValue) {
			loadPayDepList();
		}
	});
	
	$(".combo-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
}

function initPayDepList() {
	$HUI.datagrid("#payDepList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		className: 'web.DHCIPBillDeposit',
		queryName: 'FindDeposit',
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPrtDate", "Tbbackdate", "TDepositTypeDR", "TDepositTypeCode", "TAutoFlag", "TReRcptNo", "TLostRegistDR", "TLostRegUser", "TLostRegDate", "TLostRegTime", "TLostRegReason"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TDepRowId", "TPaymodeDR", "TPrtStatus", "TUserDR", "TFootId", "TInitPrtRowId", "TStrikeInvPrtId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TPrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TPrtDate + " " + value;
					};
				}
				if (cm[i].field == "TStatus") {
					cm[i].styler = function(value, row, index) {
						if ([1, 4].indexOf(+row.TPrtStatus) == -1) {
							return "color: #FF0000;";
						}
					};
				}
				if (cm[i].field == "TFootFlag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
						   	var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					};
				}
				if (cm[i].field == "TPayedFlag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
							return (value == "Y") ? $g("已结") : $g("未结");
						}
					};
				}
				if (cm[i].field == "Tbbackflag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
						   	var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					};
				}
				if (cm[i].field == "Tbbacktime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tbbackdate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TPrtTime", "Tbbacktime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		}
	});
}

function loadPayDepList() {
	var episodeId = getValueById("EpisodeId");
	if (episodeId) {
		var queryParams = {
			ClassName: "web.DHCIPBillDeposit",
			QueryName: "FindDeposit",
			adm: episodeId,
			depositType: getValueById("payDepositType")
		}
		loadDataGridStore("payDepList", queryParams);
	}
}

function initPayDepDoc() {
	$("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#payRcptNo)[id]").each(function(index, item) {
		if ($(this).prop("type") == "text") {
			if ($(this).prop("class").indexOf("combobox-f") != -1) {
				$(this).combobox("clear").combobox("reload");
			}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
				$(this).numberbox("clear");
			}else {
				$(this).val("");
			}
		}
	});
	getPayRcptNo();
	getPayDepConfig();
}

function getPayDepConfig() {
	enableById("btn-pay");
	var episodeId = getValueById("EpisodeId");
	if (episodeId) {
		var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetOutAdmInOutDateInfo", EpisodeID: episodeId}, false);
		var disChStatus = rtn.split("^")[3];
		if (disChStatus == "护士办理出院") {
			if (IPBILL_CONF.PARAM.DischgPayDep != "Y") {
				$.messager.popover({msg: "该患者已做最终结算，不能交押金", type: "info"});
				disableById("btn-pay");
				return;
			}
			var admBillFlag = getPropValById("PA_Adm", episodeId, "PAADM_BillFlag");
			if (admBillFlag == "Y") {
				$.messager.popover({msg: "该患者已做财务结算，不能交押金", type: "info"});
				disableById("btn-pay");
			}
		}
	}
}

function reloadPayDepPanel() {
	$("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#payDepositType)[id]").each(function(index, item) {
		if ($(this).prop("type") == "text") {
			if ($(this).prop("class").indexOf("combobox-f") != -1) {
				$(this).combobox("clear").combobox("reload");
			}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
				$(this).numberbox("clear");
			}else {
				$(this).val("");
			}
		}
	});
	refreshBar(getValueById("PatientId"), getValueById("EpisodeId"));
	getPayRcptNo();
	loadPayDepList();
}

function getPayRcptNo() {
	if (CV.ReceiptType == 1) {
		return;
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
		var leftNum = myAry[4];
		var tipFlag = myAry[6];
		if (!currNo) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			disableById("btn-pay");
			return;
		}
		if (rcptId) {
			var payRcptNo = title + "[" + currNo + "]";
			setValueById("payRcptNo", payRcptNo);
			var color = "green";
			if ($("#payRcptNo").hasClass("newClsInvalid")) {
				$("#payRcptNo").removeClass("newClsInvalid");
			}
			if (tipFlag == 1) {
				color = "red";
				$("#payRcptNo").addClass("newClsInvalid");
			}
			var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
			$("#btn-payRcptTip").show().popover({cache: false, trigger: 'hover', content: content});
		}
	});
}

function payClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var bool = true;
			$("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find(".validatebox-text").each(function(index, item) {
				if (!$(this).validatebox("isValid")) {
					bool = false;
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			if (!episodeId) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetBillFlag", adm: episodeId}, false);
			if (rtn == "Y") {
				$.messager.popover({msg: "该患者已做财务结算，不能交押金", type: "info"});
				return reject();
			}
			if (!payDepositType) {
				$.messager.popover({msg: "请选择押金类型", type: "info"});
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
			if ((CV.ReceiptType != 1) && (receiptNo == "")) {
				$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var payAmt = getValueById("payAmt");
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
				title: '收银台-住院押金交款',
				cardNo: cardNo,
		        cardTypeId: cardTypeId,
				patientId: patientId,
				accMLeft: accMLeft,
				episodeIdStr: episodeId,
				typeFlag: "DEP",
				payAmt: payAmt,
				bizType: "DEP"
			};
			return BILL_INF.showCheckout(argumentObj).then(function (payMList) {
			    paymStr = payMList;
		        resolve();
		    }, function () {
		        reject();
		    });
		});
	};
	
	var _pay = function() {
		return new Promise(function (resolve, reject) {
			var depAry = [];
			depAry.push(payDepositType);
			depAry.push(payAmt);
			depAry.push(episodeId);
			depAry.push(remark);
			depAry.push(transferFlag);
			var depStr = depAry.join("^");
			
			var rtn = $.m({
				ClassName: "web.DHCIPBillDeposit",
				MethodName: "InsertDeposit",
				depStr: depStr,
				paymStr: paymStr,
				sessionStr: getSessionStr()
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				depositId = myAry[1];
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
		depositPrint(depositId + "#" + "");
		reloadPayDepPanel();
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
	var receiptNo = getValueById("payRcptNo");
	var patientId = getValueById("PatientId");
	var episodeId = getValueById("EpisodeId");
	var payAmt = getValueById("payAmt");
	var payDepositType = getValueById("payDepositType");
	var remark = getValueById("payRemark");
	var transferFlag = getValueById("transferFlag");   //转账标识
	var accMLeft = getDepLeftAmt();
	var paymStr = "";        //支付方式串
	var depositId = "";      //交押金记录的Id
	
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

function focusNextEle(id) {
	var myIdx = -1;
	var inputAry = $("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input[id]");
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
	}, 20);
	return true;
}

/**
* 补打押金条
*/
function reprintClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = $("#payDepList").datagrid("getSelected");
			if (!row || !row.TDepRowId) {
				$.messager.popover({msg: "请选择要补打的押金记录", type: "info"});
				return reject();
			}
			if (row.TPrtStatus != 1) {
				var msg = "该笔押金已退款，" + ((row.TPrtStatus == 3) ? "请到【退押金】界面补打" : "不能补打");
				$.messager.popover({msg: msg, type: "info"});
				return reject();
			}
			var recepitNo = row.TRecepitNo;
			if (!recepitNo) {
				$.messager.popover({msg: "票据号为空，不能补打", type: "info"});
				return reject();
			}
			depositId = row.TDepRowId;
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
	
	var depositId = "";
	var reprtFlag = "Y";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function () {
			depositPrint(depositId + "#" + reprtFlag);
			$("#btn-reprint").linkbutton("enable");
		}, function () {
			$("#btn-reprint").linkbutton("enable");
		});
}

/**
 * 押金跳号
 */
function skipNoClick() {
	var argumentObj = {
		receiptType: "ID"
	};
	BILL_INF.showSkipInv(argumentObj).then(getPayRcptNo);
}

/**
* 取押金余额
*/
function getDepLeftAmt() {
	var episodeId = getValueById("EpisodeId");
	return (episodeId > 0) ? $.m({ClassName: "BILL.IP.COM.Method", MethodName: "GetDepositLeftAmt", episodeId: episodeId}, false) : "";
}
