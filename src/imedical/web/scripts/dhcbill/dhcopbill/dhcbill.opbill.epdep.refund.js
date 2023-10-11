/**
 * FileName: dhcbill.opbill.epdep.refund.js
 * Author: ZhYW
 * Date: 2019-08-13
 * Description: 急诊留观退押金
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
	initEPDepList();
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
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();
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
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//退押金金额
	$HUI.numberbox("#accMLeft", {
		onChange: function(newValue, oldValue) {
			GV.RefableAmt = newValue;   //初始化为账户余额
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
	
	$HUI.combogrid("#admList", {
		panelWidth: 730,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'TAdmRowID',
		textField: 'TAdmRowID',
		columns: [[ {field: 'TAdmRowID', title: '就诊ID', width: 60},
					{field: 'TAdmLoc', title: '科室病区', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TAdmWard;
							}
						}
					},
					{field: 'TBedCode', title: '床号', width: 50},
					{field: 'TAdmDate', title: '入院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TAdmTime;
							}
						}
					},
					{field: 'TDisDate', title: '出院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TDisTime;
							}
						}
					},
					{field: 'TStayStatus', title: '留观状态', width: 80,
						formatter: function (value, row, index) {
							if (value) {
								return (value == 1) ? $g("留观出院") : ((value == 2) ? $g("正在留观") : "非留观");
							}
						}
					},
					{field: 'TAdmInsType', title: '就诊费别', width: 80},
					{field: 'TAccMRowId', title: 'TAccMRowId', hidden: true},
					{field: 'TAccMLeft', title: 'TAccMLeft', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
			if (data.total > 0) {
				setValueById("admList", data.rows[0].TAdmRowID);
				return;
			}
			setValueById("admDate", "");
			setValueById("dept", "");
			setValueById("ward", "");
			setValueById("bedCode", "");
			setValueById("admReason", "");
			setValueById("refAmt", "");
			setValueById("accMRowId", "");
			setValueById("accMLeft", "");
			loadEPDepList();
		},
		onSelect: function (index, row) {
			setAdmInfo(row);
		}
	});
	
	//退款原因
	$HUI.combobox("#refReason", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryRefDepReason&ResultSetType=array',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
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
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {
			total: 0,
			rows: []
		});
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	
	if (patientId != "") {
		getPatInfo();
	}
}

function getReceiptNo() {
	if (!CV.ReceiptType) {
		return;
	}
	$.m({
		ClassName: "web.DHCOPBillEPAddDeposit",
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
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
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
		getPatInfo();
	}
}

function initEPDepList() {
	var selectRowIndex = undefined;
	GV.EPDepList = $HUI.datagrid("#accDepList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillEPAddDeposit",
		queryName: "GetEPDepDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tdate", "Tjkdate", "disDate", "prtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TInitPDDR", "AccPreRowID"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "Ttime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.Tdate + " " + value;
					};
				}
				if ($.inArray(cm[i].field, ["Tamt", "Ttype"]) != -1) {
					cm[i].styler = function (value, row, index) {
						var color = (row.Tamt >= 0) ? "#21ba45" : "#f16e57";
					 	return "font-weight: bold;color:" + color;
					 };
				}
				if (cm[i].field == "Tjktime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.Tjkdate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["Ttime", "Tjktime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		onLoadSuccess: function(data) {
			selectRowIndex = undefined;
		},
		onSelect: function(index, row) {
			if (selectRowIndex == index) {
				GV.EPDepList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			if ((GV.PartRefFlag != "Y") && (row.Tamt > 0)) {
				setValueById("refAmt", row.Tamt);
			}
			if (row.AccPreRowID) {
				enableById("btn-reprint");
			}else {
				disableById("btn-reprint");
			}
		},
		onUnselect: function(index, row) {
			selectRowIndex = undefined;
			if (GV.PartRefFlag != "Y") {
				setValueById("refAmt", "");
			}
			disableById("btn-reprint");
		}
	});
}

function loadEPDepList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEPAddDeposit",
		QueryName: "GetEPDepDetail",
		AccMRowID: getValueById("accMRowId"),
		SessionStr: getSessionStr()
	};
	loadDataGridStore("accDepList", queryParams);
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (!patientNo) {
		return;
	}
	var json = $.cm({ClassName: "web.DHCOPBillEPManageCLS", MethodName: "GetPatInfo", patientNo: patientNo, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	if (!json.PatientId) {
		$.messager.popover({msg: "患者不存在", type: "info"});
		focusById("patientNo");
		return;
	}
	
	setValueById("patientNo", json.PatientNo);
	setValueById("patientId", json.PatientId);
	setValueById("patName", json.PatName);
	setValueById("IDNo", json.ID);
	setValueById("mobPhone", json.MobPhone);
	
	//加载就诊列表
	$.cm({
		ClassName: "web.DHCOPBillEPManageCLS",
		QueryName: "SearchStayAdm",
		PatientID: json.PatientId,
		SessionStr: getSessionStr(),
		rows: 999999
	}, function(data) {
		$("#admList").combogrid("grid").datagrid("loadData", data);
		if (data.total == 0) {
			$.messager.popover({msg: "该患者无留观就诊", type: "info"});
			focusById("patientNo");
			return;
		}
	});
}

function setAdmInfo(row) {
	var episodeId = row.TAdmRowID;
	var accMLeft = row.TAccMLeft;
	setValueById("admDate", row.TAdmDate);
	setValueById("dept", row.TAdmLoc);
	setValueById("ward", row.TAdmWard);
	setValueById("bedCode", row.TBedCode);
	setValueById("admReason", row.TAdmInsType);
	setValueById("accMRowId", row.TAccMRowId);
	setValueById("accMLeft", accMLeft);
	
	//判断是否允许部分退
	$.m({
		ClassName: "web.DHCOPBillEPManageCLS",
		MethodName: "GetAdmBillStatus",
		Adm: episodeId
	}, function(rtn) {
		if (rtn == "Y") {
			GV.PartRefFlag = "Y";
			setValueById("refAmt", accMLeft);
			enableById("refAmt");
		}
	});
	
	loadEPDepList();
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
	}, 20);
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
			if (!episodeId) {
				$.messager.popover({msg: "请选择就诊", type: "info"});
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
			//急诊留观标志
			var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmStayStat", Adm: episodeId}, false);
			var stayFlag = rtn.split("^")[0];
			if (stayFlag != "Y") {
				$.messager.popover({msg: "不是急诊留观患者，不能交留观押金", type: "info"});
				return reject();
			}
			//只能全退时，取原Id
			if (GV.PartRefFlag != "Y") {
				var row = GV.EPDepList.getSelected();
				if (row && row.AccPreRowID) {
					initPDRowId = row.AccPreRowID;
				}
			}
			resolve();
		});
	};
	
	/**
	* openEPDETPList()中获取原交押金记录Id，支付方式，重新计算退款金额
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
	* 退留观金
	*/
	var _refund = function() {
		return new Promise(function (resolve, reject) {
			var bankCardType = getValueById("bankCardType");
			var checkNo = getValueById("checkNo");
			var bank = getValueById("bank");
			var company = getValueById("company");
			var payAccNo = getValueById("payAccNo");
			var chequeDate = getValueById("chequeDate");

			var credTypeId = "";
			var credNo = "";
			var accAry = [];
			accAry.push(episodeId);
			accAry.push(patientId);
			accAry.push(cardNo);
			accAry.push(PUBLIC_CONSTANT.SESSION.USERID);
			accAry.push(credTypeId);
			accAry.push(credNo);
			var accStr = accAry.join("^");
			
			var accPDAry = [];
			accPDAry.push(refAmt);
			accPDAry.push(PUBLIC_CONSTANT.SESSION.USERID);
			accPDAry.push(refReason);
			accPDAry.push(password);
			accPDAry.push(accPDType);
			accPDAry.push(remark);
			accPDAry.push(PUBLIC_CONSTANT.SESSION.HOSPID);
			accPDAry.push(initPDRowId);
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
			var paymStr = paymAry.join("^");
			
			$.m({
				ClassName: "web.DHCOPBillEPAddDeposit",
				MethodName: "NewDeposit",
				AccInfo: accStr,
				PDInfo: accPDStr,
				PDPMInfo: paymStr,
				PartRefFlag: GV.PartRefFlag
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					abortPDRowId = myAry[1];
					if (!getValueById("accMRowId")) {
						setValueById("accMRowId", abortPDRowId.split("||")[0]);
					}
					return resolve();
				}
				$.messager.popover({msg: $g("退款失败：") + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
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
			var tradeType = "EPDEP";
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
			emPreDepPrint(abortPDRowId);
			reloadRefundMenu();
		});
	};
	
	if ($("#btn-refund").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refund").linkbutton("disable");
	
	var receiptNo = getValueById("receiptNo");
	var accMLeft = getValueById("accMLeft");
	var refAmt = getValueById("refAmt");
	var episodeId = $("#admList").combogrid("getValue");
	var patientId = getValueById("patientId");
	var cardNo = getValueById("CardNo");
	var password = "";
	var refReason = getValueById("refReason");
	var payMode = getValueById("payMode");
	var remark = getValueById("remark");
	var accPDType = "R";
	
	var initPDRowId = "";       //待退押金记录的Id
	var abortPDRowId = "";
	var srvRtnObj = {};         //第三方退费返回对象
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(openAppendDlg)
		.then(openEPDETPList)
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
			onBeforeOpen: function() {
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
			onOpen: function() {
				focusById("checkNo");
				var id = "";
				$("#appendDlg").find("input[id]").each(function(index, item) {
					if ($(this).is(":hidden")) {
						$(this).next("span").find("input").keydown(function(e) {
							id = $(this).parents("td").find("input")[0].id;
							var key = websys_getKey(e);
							if (key == 13) {
								_setNextFocus(id);
							}
						});
					}else {
						$(this).keydown(function(e) {
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
					inputAry.each(function(index, item) {
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
						return;
					}
					setTimeout(function() {
						focusById("btn-ok");
					}, 20);
				}
			},
			buttons: [{
					text: '确认',
					id: 'btn-ok',
					handler: function () {
						var bool = true;
						var id = "";
						$("#appendDlg label.clsRequired").each(function(index, item) {
							id = $($(this).parent().next().find("input"))[0].id;
							if (!id) {
								return true;
							}
							if (!getValueById(id)) {
								bool = false;
								focusById(id);
								$.messager.popover({msg: ($g("请输入") + "<font color='red'>" + $(this).text() + "</font>"), type: "info"});
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
function openEPDETPList() {
    return new Promise(function (resolve, reject) {
	 	var refObj = {};
		if (!isCallPaySvr()) {
			return resolve(refObj);
		}
        $("#emPDETPDlg").show();
        var dlgObj = $HUI.dialog("#emPDETPDlg", {
            title: $("#payMode").combobox("getText") + $g("支付列表"),
            iconCls: 'icon-w-list',
            draggable: false,
            resizable: false,
            modal: true,
            onOpen: function () {
                $HUI.datagrid("#emPDETPList", {
                    fit: true,
                    border: false,
                    striped: true,
                    singleSelect: true,
                    rownumbers: true,
                    pagination: true,
                    pageSize: 10,
                    className: "web.DHCOPBillEPAddDeposit",
					queryName: "QryEPDETPList",
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
                        ClassName: "web.DHCOPBillEPAddDeposit",
                        QueryName: "QryEPDETPList",
                        accMId: getValueById("accMRowId"),
                        paymId: getValueById("payMode"),
                        hospId: PUBLIC_CONSTANT.SESSION.HOSPID
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
								$HUI.datagrid("#emPDETPList").getPanel().find(".datagrid-row[datagrid-row-index=" + index + "]>td>div:not(.datagrid-cell-rownumber)").mouseover(function() {
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
                        GV.RefableAmt = row.RefableAmt; //给全局变量可退金额赋值，方便校验
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
	$("#remark").val("");
	$("#refAmt").numberbox("clear");
	$("#payMode, #refReason").combobox("reload");
	$.m({
		ClassName: "web.DHCOPBillEPManageCLS",
		MethodName: "getAccBalance",
		Accid: getValueById("accMRowId")
	}, function(accMLeft) {
		setValueById("accMLeft", accMLeft);
	});
	
	if (CV.ReceiptType) {
		getReceiptNo();
	}
	
	loadEPDepList();
}

function reprintClick() {
	if ($("#btn-reprint").linkbutton("options").disabled) {
		return;
	}
	var row = GV.EPDepList.getSelected();
	if (!row || !row.AccPreRowID) {
		$.messager.popover({msg: "请选择要补打的急诊留观押金记录", type: "info"});
		return;
	}
	if (row.Tamt > 0) {
		$.messager.popover({msg: "交款记录，请到【急诊留观交押金】界面补打", type: "info"});
		return;
	}
	var emPDRowId = row.AccPreRowID;
	var reprtFlag = 1;
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (!r) {
			return;
		}
		emPreDepPrint(emPDRowId + "#" + reprtFlag);
	});
}

function clearClick() {
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	setValueById("requiredFlag", "");
	focusById("CardNo");
	$(":text:not(.pagination-num)").val("");
	GV.RefableAmt = 0;
	$(".numberbox-f").numberbox("clear");
	$("#refAmt").numberbox("isValid");
	$("#payMode").combobox("reload");
	$("#admList").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
	loadEPDepList();
	if (CV.ReceiptType) {
		getReceiptNo();
	}
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
