/**
 * FileName: dhcbill.ipbill.deposit.refund.js
 * Author: ZhYW
 * Date: 2019-07-06
 * Description: 住院押金退款
 */

$(function () {
	initRefDepMenu();
	initRefDepList();
});

function initRefDepMenu() {
	$HUI.linkbutton("#btn-refund", {
		onClick: function () {
			refundClick();
		}
	});
	
	$HUI.linkbutton("#btn-refReprint", {
		onClick: function () {
			refReprintClick();
		}
	});
	
	$HUI.linkbutton("#btn-transOPAcc", {
		onClick: function () {
			transOPAccClick();
		}
	});
	
	getRefRcptNo();
	
	setAccPreRcptNo();
	
	//退费方式
	$HUI.combobox("#refMode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		disabled: (IPBILL_CONF.PARAM.RefDepModifyPayM != "Y"),
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "RDEP"
		}
	});
	
	//押金类型
	$HUI.combobox("#refDepositType", {
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
			loadRefDepList();
		}
	});
	
	//退款原因
	$HUI.combobox("#refReason", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryRefDepReason&ResultSetType=array",
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initRefDepList() {
	$HUI.datagrid("#refDepList", {
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
		},
		onSelect: function(index, row) {
			if (row.TDepRowId) {
				setValueById("refAmt", row.TLeftAmt);    //设置可退金额为退费金额
				loadRefModeData(row.TPaymodeDR);   //+2023-03-21 ZhYW 改为"退押金支付方式与交押金支付方式对照"配置
				/*
				//设置原支付方式为默认退费方式
				var refModeData = $("#refMode").combobox("getData");
				var isExist = refModeData.some(function(item) {
					if (item.CTPMRowID == row.TPaymodeDR) {
						setValueById("refMode", row.TPaymodeDR);
					}
					return item.CTPMRowID == row.TPaymodeDR;
				});
				if (!isExist) {
					refModeData.push({CTPMRowID: row.TPaymodeDR, CTPMDesc: row.Tpaymode, selected: true});
					$("#refMode").combobox("loadData", refModeData);
				}
				*/
			}
		}
	});
}

function refundClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var bool = true;
			$("#refDepList").parents(".layout-panel-center").prev(".layout-panel-north").find(".validatebox-text").each(function(index, item) {
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
			var rtn = checkPreIPOrd(episodeId);
			if ($.inArray(+rtn, [1, 2]) != -1) {
				var msg = ((rtn == 1) ? "该患者的预住院医嘱存在有效医嘱，" : "该患者由预住院转入门诊的费用未结清，") + "不能退押金";
				$.messager.popover({msg: msg, type: "info"});
				return reject();
			}
			var row = $("#refDepList").datagrid("getSelected");
			if (!row || !row.TDepRowId) {
				$.messager.popover({msg: "请选择要退的押金", type: "info"});
				return reject();
			}
			if (row.TLostRegistDR > 0) {
				$.messager.popover({msg: "该笔押金已挂失，不允许退", type: "info"});
				return reject();
			}
			if (row.TStrikeInvPrtId) {
				$.messager.popover({msg: "该笔押金为取消结算回冲押金，不允许退", type: "info"});
				return reject();
			}
			if (row.TPayedFlag == "Y") {
				$.messager.popover({msg: "该笔押金已结算，不允许退", type: "info"});
				return reject();
			}
			if (row.TPrtStatus != 1) {
				$.messager.popover({msg: "该笔押金已退款，不允许再退", type: "info"});
				return reject();
			}
			if ((CV.ReceiptType != 1) && (IPBILL_CONF.PARAM.StrikeDepRequireRcpt == "Y") && (receiptNo == "")) {
				if (row.TFootId || (row.TUserDR != PUBLIC_CONSTANT.SESSION.USERID)) {
					$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
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
			if (+refAmt > +row.TLeftAmt) {
				$.messager.popover({msg: "退款金额不能大于可退金额", type: "info"});
				focusById("refAmt");
				return reject();
			}
			if (!refModeId) {
				$.messager.popover({msg: "请选择支付方式", type: "info"});
				return reject();
			}
			//+2022-10-31 ZhYW 判断第三方支付的住院押金是否允许原路退
			var rtn = isAllowedInitModeToRefund(row.TDepRowId, refModeId);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
				return reject();
			}
			//判断是否是"押金转账"退款方式
			var transPayMId = getTransPayMId();
			if (transPayMId == refModeId) {
				$.messager.popover({msg: "不能以" + $("#refMode").combobox("getText") + "方式退款", type: "info"});
				return reject();
			}
			depositId = row.TDepRowId;
			resolve();
		});
	};

	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("退款") + "：<font style=\"color:red;\">" + refAmt + "</font> " + $g("元，是否确认退款？")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 退押金
	*/
	var _refund = function() {
		return new Promise(function (resolve, reject) {
			var expStr = refReason + "^" + remark;
			var rtn = $.m({
				ClassName: "web.DHCIPBillDeposit",
				MethodName: "RefundDepositIF",
				initDepId: depositId,
				refundAmt: refAmt,
				refModeId: refModeId,
				sessionStr: getSessionStr(),
				expStr: expStr
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				abortDepRowId = myAry[1];
				return resolve();
			}
			$.messager.popover({msg: "退款失败：" + (myAry[1] || myAry[0]), type: "error"});
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
			var tradeType = "DEP";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			srvRtnObj = RefundPayService(tradeType, depositId, abortDepRowId, "", refAmt, tradeType, expStr);
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
			var rcptno = getPropValById("dhc_sfprintdetail", abortDepRowId, "prt_rcptno");
			if (rcptno) {
				depositPrint(abortDepRowId + "#" + "");
			}
			reloadRefDepPanel();
		});
		_reloadToRefMsg();   //更新待退金额信息
	};

	/**
	 * 更新待退金额信息
	*/
	var _reloadToRefMsg = function() {
		if ($("#refedAmt").length > 0) {
			$("#refedAmt").text(Number($("#refedAmt").text()).add(refAmt).toFixed(2));
		}
		if ($("#toRefAmt").length > 0) {
			$("#toRefAmt").text(Number($("#totalRefAmt").text()).sub($("#refedAmt").text()).toFixed(2));
		}
	};

	if ($("#btn-refund").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refund").linkbutton("disable");
	
	var receiptNo = getValueById("refRcptNo");
	var episodeId = getValueById("EpisodeId");
	var refModeId = getValueById("refMode");
	var refAmt = getValueById("refAmt");
	var remark = getValueById("refRemark");
	var refReason = getValueById("refReason");

	var depositId = "";      //待退押金记录的Id
	var abortDepRowId = "";  //退押金记录Id
	var srvRtnObj = {};      //第三方退费返回对象

	var promise = Promise.resolve();
	promise
		.then(_validate)
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

function initRefDepDoc() {
	$("#refDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#refRcptNo,#accPreRcptNo)[id]").each(function(index, item) {
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
	getRefRcptNo();
}

function reloadRefDepPanel() {
	$("#refDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#refDepositType)[id]").each(function(index, item) {
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
	
	getRefRcptNo();
	loadRefDepList();
	
	setAccPreRcptNo();
}

function getRefRcptNo() {
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
		if (rcptId) {
			var receiptNo = title + "[" + currNo + "]";
			setValueById("refRcptNo", receiptNo);
			var color = "green";
			if ($("#refRcptNo").hasClass("newClsInvalid")) {
				$("#refRcptNo").removeClass("newClsInvalid");
			}
			if (tipFlag == 1) {
				color = "red";
				$("#refRcptNo").addClass("newClsInvalid");
			}
			var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
			$("#btn-refRcptTip").show().popover({cache: false, trigger: 'hover', content: content});
		}
	});
}

function setAccPreRcptNo() {
	if ($("#accPreRcptNo").length == 0) {
		return;
	}
	var rtn = getAccPreRcptNo();
	var myAry = rtn.split("^");
	if (myAry[3]) {
		setValueById("accPreRcptNo", "[" + myAry[3] + "]");
	}
}

function getAccPreRcptNo() {
	return $.m({ClassName: "web.UDHCAccAddDeposit", MethodName: "GetCurrentRecNo", userId: PUBLIC_CONSTANT.SESSION.USERID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
}

function loadRefDepList() {
	var episodeId = getValueById("EpisodeId");
	if (!episodeId) {
		return;
	}
	var queryParams = {
		ClassName: "web.DHCIPBillDeposit",
		QueryName: "FindDeposit",
		adm: episodeId,
		depositType: getValueById("refDepositType")
	}
	loadDataGridStore("refDepList", queryParams);
}

function refReprintClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = $("#refDepList").datagrid("getSelected");
			if (!row || !row.TDepRowId) {
				$.messager.popover({msg: "请选择要补打的押金记录", type: "info"});
				return reject();
			}
			if (row.TPrtStatus != 3) {
				$.messager.popover({msg: "该笔押金非冲红状态，不能补打", type: "info"});
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
	
	if ($("#btn-refReprint").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refReprint").linkbutton("disable");
	
	var depositId = "";
	var reprtFlag = "Y";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function () {
			depositPrint(depositId + "#" + reprtFlag);
			$("#btn-refReprint").linkbutton("enable");
		}, function () {
			$("#btn-refReprint").linkbutton("enable");
		});
}

function transOPAccClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!patientId || !episodeId) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			var rtn = checkPreIPOrd(episodeId);
			if ($.inArray(+rtn, [1, 2]) != -1) {
				$.messager.popover({msg: ((rtn == 1) ? "该患者的预住院医嘱存在有效医嘱" : "该患者由预住院转入门诊的费用未结清") + "，不能转入门诊账户", type: "info"});
				return reject();
			}
			var row = $("#refDepList").datagrid("getSelected");
			if (!row || !row.TDepRowId) {
				$.messager.popover({msg: "请选择要转的押金记录", type: "info"});
				return reject();
			}
			depositId = row.TDepRowId;
			if (row.TDepositTypeCode != "01") {
				$.messager.popover({msg: "非住院押金，不能转入门诊账户", type: "info"});
				return reject();
			}
			if (row.TLostRegistDR > 0) {
				$.messager.popover({msg: "该笔押金已挂失，不能转入门诊账户", type: "info"});
				return reject();
			}
			if (row.TStrikeInvPrtId) {
				$.messager.popover({msg: "该笔押金为取消结算回冲押金，不能转入门诊账户", type: "info"});
				return reject();
			}
			if (row.TPayedFlag == "Y") {
				$.messager.popover({msg: "该笔押金已结算，不能转入门诊账户", type: "info"});
				return reject();
			}
			if (row.TPrtStatus != 1) {
				$.messager.popover({msg: "该笔押金已退款，不能转入门诊账户", type: "info"});
				return reject();
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
			if (+refAmt > +row.TLeftAmt) {
				$.messager.popover({msg: "转账金额不能大于可退金额", type: "info"});
				focusById("refAmt");
				return reject();
			}
			if ((CV.ReceiptType != 1) && (IPBILL_CONF.PARAM.StrikeDepRequireRcpt == "Y") && !receiptNo) {
				if (row.TFootId || (row.TUserDR != PUBLIC_CONSTANT.SESSION.USERID)) {
					$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
					return reject();
				}
			}
			if (!transPayMId) {
				$.messager.popover({msg: "请维护转账支付方式，系统默认取支付方式代码为:DEPZZ", type: "info"});
				return reject();
			}
			accMId = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "GetPatAccMRowID", cardNo: cardNo, cardTypeId: cardTypeId, patientId: patientId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
			if (!accMId) {
				$.messager.popover({msg: "没有有效账户，不能转入门诊账户", type: "info"});
				return reject();
			}
			var rtn = getAccPreRcptNo();
			var myAry = rtn.split("^");
			var accPreRcptNo = myAry[3];
			var accPreRcptId = myAry[5];
			if (accPreRcptId && !accPreRcptNo) {
				$.messager.popover({msg: "您没有可用门诊收据，请先领取收据", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("转账") + "：<font style=\"color:red;\">" + refAmt + "</font> " + $g("元，确认转入门诊账户？")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _trans = function() {
		return new Promise(function (resolve, reject) {
			var backReason = "";
			var password = "";
			var bankCardType = "";
			var checkNo = "";
			var bank = "";
			var company = "";
			var payAccNo = "";
			var chequeDate = "";
			var remark = "";
			var accPDType = "P";
			var accPreDepStr = accMId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + backReason;
			accPreDepStr += "^" + password + "^" + transPayMId + "^" + bankCardType + "^" + checkNo;
			accPreDepStr += "^" + bank + "^" + company + "^" + payAccNo + "^" + chequeDate;
			accPreDepStr += "^" + remark + "^" + accPDType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			var depositStr = depositId + "^" + refAmt + "^" + refReason + "^" + transPayMId;
			var rtn = $.m({
				ClassName: "web.DHCBillDepConversion",
				MethodName: "DepositTransAcount",
				DepositStr: depositStr,
				AccPreDepStr: accPreDepStr,
				SessionStr: getSessionStr()
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				strikeDepRowId = myAry[1];  //住院押金Id
				accPreId = myAry[2];        //门诊预交金Id
				$.messager.alert("提示", "转入门诊账户成功", "success", function() {
					resolve();
				});
				return;
			}
			$.messager.popover({msg: "转入门诊账户失败：" + (myAry[1] || ""), type: "error"});
			reject();
		});
	};
	
	var _success = function() {
		var rcptno = getPropValById("dhc_sfprintdetail", strikeDepRowId, "prt_rcptno");
		if (rcptno) {
			depositPrint(strikeDepRowId + "#" + "");
		}
		//打印门诊收据
		accPreDepPrint(accPreId);
		reloadRefDepPanel();
	};
	
	if ($("#btn-transOPAcc").linkbutton("options").disabled) {
		return;
	}
	$("#btn-transOPAcc").linkbutton("disable");
	
	var cardNo =  getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var patientId = getValueById("PatientId");
	var episodeId = getValueById("EpisodeId");
	var receiptNo = getValueById("refRcptNo");
	var transPayMId = getTransPayMId();
	var refAmt = getValueById("refAmt");
	var refReason = getValueById("refReason");
	var accMId = "";
	var depositId = "";
	var strikeDepRowId = "";
	var accPreId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_trans)
		.then(function () {
			_success();
			$("#btn-transOPAcc").linkbutton("enable");
		}, function () {
			$("#btn-transOPAcc").linkbutton("enable");
		});
}

/**
* 是否调用第三方接口
*/
function isCallPaySvr() {
	var refModeId = getValueById("refMode");
	var payCallInfo = $.m({ClassName: "DHCBILL.Common.DHCBILLCommon", MethodName: "GetCallModeByPayMode", PayMode: refModeId}, false);
	var payCallAry = payCallInfo.split("^");
	var payCallFlag = payCallAry[0];
	return (payCallFlag != 0);
}

/**
* 是否有未结算的预住院医嘱
*/
function checkPreIPOrd(episodeId) {
	return $.m({ClassName: "web.DHCBillPreIPAdmTrans", MethodName: "CheckRefDeposit", episodeId: episodeId, sessionStr: getSessionStr()}, false);
}

/**
* 获取"押金转账"支付方式Id
*/
function getTransPayMId() {
	return $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZPayModeID"}, false);
}

/**
* 判断第三方支付的住院押金是否允许原路退
*/
function isAllowedInitModeToRefund(depRowId, refModeId) {
	return $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "IsAllowedInitModeToRefund", depRowId: depRowId, refModeId: refModeId}, false);
}

/**
* 2023-03-21
* ZhYW
* 获取加载退押金方式combobox的url
* 通用配置->住院收费系统->退押金->退押金支付方式与交押金支付方式对照
*/
function loadRefModeData(paymId) {
	$.cm({
		ClassName: "web.UDHCOPGSConfig",
		QueryName: "QryGSContraRefPMList",
		ResultSetType: "array",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID,
		TypeFlag: "RDEP",
		CfgCode: "IPCHRG.RefdDep.TYJZFFSYJYJZFFSDZ",
		PayMID: paymId
	}, function(data) {
		$("#refMode").combobox("loadData", data);
	});
};