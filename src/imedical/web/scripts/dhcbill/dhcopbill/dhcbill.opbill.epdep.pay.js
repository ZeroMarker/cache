/**
 * FileName: dhcbill.opbill.epdep.pay.js
 * Author: ZhYW
 * Date: 2019-08-12
 * Description: 急诊留观交押金
 */
 
$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 100000000;
		},
		message: $g("金额输入过大")
	}
});

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initPayMenu();
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
			setValueById("payAmt", "");
			setValueById("accMRowId", "");
			setValueById("accMLeft", "");
			loadEPDepList();
		},
		onSelect: function (index, row) {
			setAdmInfo(row);
		},
		loadFilter: function(data) {
			if (CV.WinFrom != "opcharge") {
				return data;
			}
			var rows = $.grep(data.rows, function (row) {
            	return row.TAdmRowID == CV.EpisodeID;
    		});
    		return {total: rows.length, rows: rows};
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

$(window).load(function() {
  	if (CV.WinFrom == "opcharge") {
		getPatInfo();
	}
});

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
			if (row.AccPreRowID) {
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
	
	if (CV.WinFrom == "opcharge") {
		var myAmt = Number(getValueById("patFactPaySum")).sub(accMLeft).toFixed(2);
		myAmt = toRound(myAmt, 1, 1);
		$("#payAmt").focus().numberbox("setValue", myAmt);
	}else {
		getAdvPayAmt(episodeId);
	}
	
	loadEPDepList();
}

/**
* 获取押金评估金额
*/
function getAdvPayAmt(adm) {
	if (!adm) {
		return;
	}
	//获取账户信息
	$.m({
		ClassName: "web.DHCOPBillEPManageCLS",
		MethodName: "GetAdvPayAmt",
		adm: adm
	}, function(advAmt) {
		setValueById("payAmt", advAmt);
	});
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
	setTimeout(function () {
        focusById("btn-pay");
    }, 20);
    return false;
}

function payClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
	        var bool = true;
	        $(".validatebox-text").each(function (index, item) {
	            if (!$(this).validatebox("isValid")) {
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
	        //急诊留观标志
	        var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmStayStat", Adm: episodeId}, false);
	        var stayFlag = rtn.split("^")[0];
	        if (stayFlag != "Y") {
	            $.messager.popover({msg: "不是急诊留观患者，不能交留观押金", type: "info"});
	            return reject();
	        }

	        var billFlag = $.m({ClassName: "web.DHCOPBillEPManageCLS", MethodName: "GetBillFlag", adm: episodeId}, false);
	        if (billFlag == "Y") {
	            $.messager.popover({msg: "该患者已做急诊留观结算，不能再交留观押金", type: "info"});
	            return reject();
	        }
	      	resolve();
	    });
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var payAmt = getValueById("payAmt");
			$.messager.confirm("确认", $g("收款额") + "：<font style='color:red;'>" + payAmt + "</font> " + $g("元，是否确认交款？"), function (r) {
				return r ? resolve() : reject();
			});
		});
	}
	
	/**
	* 生成支付方式列表
	* 如果有第三方支付也在此方法中完成
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {			
			var argumentObj = {
				title: '收银台-留观押金交款',
				cardNo: cardNo,
		        cardTypeId: cardTypeId,
				patientId: patientId,
				accMRowId: accMRowId,
				accMLeft: accMLeft,
				episodeIdStr: episodeId,
				typeFlag: "DEP",
				payAmt: payAmt,
				bizType: "EPDEP"
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
			accPDAry.push(payAmt);
			accPDAry.push(PUBLIC_CONSTANT.SESSION.USERID);
			accPDAry.push(refReason);
			accPDAry.push(password);
			accPDAry.push(accPDType);
			accPDAry.push(remark);
			accPDAry.push(PUBLIC_CONSTANT.SESSION.HOSPID);
			accPDAry.push(initPDRowId);
			var accPDStr = accPDAry.join("^");
			
			$.m({
				ClassName: "web.DHCOPBillEPAddDeposit",
				MethodName: "NewDeposit",
				AccInfo: accStr,
				PDInfo: accPDStr,
				PDPMInfo: paymStr,
				PartRefFlag: ""
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					emPDRowId = myAry[1];
					if (accMRowId == "") {
						setValueById("accMRowId", emPDRowId.split("||")[0]);
					}
					$.messager.alert("提示", $g("交款成功"), "success", function() {
						return resolve();
					});
					return;
				}
		        $.messager.alert("提示", ($g("交款失败：") + (myAry[1] || myAry[0])), "error");
				return reject();
			});
		});
	};
	
	var _success = function() {
		emPreDepPrint(emPDRowId);
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
	var patientNo = getValueById("patientNo");
	var episodeId = $("#admList").combogrid("getValue");
	var payAmt = getValueById("payAmt");
	var accMRowId = getValueById("accMRowId");
	var accMLeft = getValueById("accMLeft");
	var password = "";
	var refReason = "";
	var remark = getValueById("remark");
	var accPDType = "P";
	var initPDRowId = "";
	var paymStr = "";        //支付方式串
	var emPDRowId = "";      //充值记录的Id
	
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
	if ($("#btn-reprint").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.EPDepList.getSelected();
	if (!row || !row.AccPreRowID) {
		$.messager.popover({msg: "请选择要补打的急诊留观押金记录", type: "info"});
		return;
	}
	if (row.Tamt < 0) {
		$.messager.popover({msg: "退款记录，请到【急诊留观退押金】界面补打", type: "info"});
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
	focusById("CardNo");
	$(":text:not(.pagination-num)").val("");
	$(".numberbox-f").numberbox("clear");
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
