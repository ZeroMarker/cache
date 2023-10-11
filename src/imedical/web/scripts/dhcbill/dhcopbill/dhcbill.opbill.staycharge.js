/**
 * FileName: dhcbill.opbill.staycharge.js
 * Author: ZhYW
 * Date: 2019-08-19
 * Description: 急诊留观结算
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initChargeMenu();
	initBillList();
	initEPDepList();
	
	initTabs();
});

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();
		chargeClick();
		break;
	default:
	}
}

function initChargeMenu() {
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//结算
	$HUI.linkbutton("#btn-charge", {
		onClick: function () {
			chargeClick();
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
	
	getReceiptNo();
	
	//结算费别
	$HUI.combobox("#chargeInsType", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true
	});

	$HUI.combogrid("#admList", {
		panelWidth: 700,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'TAdmRowID',
		textField: 'TAdmRowID',
		columns: [[ {field: 'TAdmRowID', title: '就诊ID', width: 60},
					{field: 'TAdmLocDesc', title: '科室病区', width: 180,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TAdmWardDesc;
							}
						}
					},
					{field: 'TAdmBedDesc', title: '床号', width: 50},
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
					{field: 'TAccMRowId', title: 'TAccMRowId', hidden: true},
					{field: 'TAccMLeft', title: 'TAccMLeft', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
			if (data.total > 0) {
				setValueById("admList", data.rows[0].TAdmRowID);
				return;
			}
			delete GV.EpisodeID;
			delete GV.AccMRowID;
			
			$(".numberbox-f").numberbox("clear");
			$(".combobox-f").combobox("clear");
			
			loadBillList();    //清空账单列表
			loadEPDepList();   //清空押金列表
		},
		onSelect: function (index, row) {
			setAdmInfo(row);
		}
	});
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

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		getPatInfo();
	}
}

function initBillList() {
	var toolbar = [{
			text: $g('合并账单'),
			iconCls: 'icon-cancel-int-bill',
			handler: function () {
				delIntBillClick();
			}
		}, {
			text: $g('封账'),
			iconCls: 'icon-lock',
			handler: function () {
				closeAcountClick();
			}
		}, {
			text: $g('取消封账'),
			iconCls: 'icon-unlock',
			handler: function () {
				uncloseAcountClick();
			}
		}];
	GV.BillList = $HUI.datagrid("#billList", {
		fit: true,
		bodyCls: 'panel-body-gray',
		striped: true,
		singleSelect: true,
		pageSize: 9999999,
		toolbar: toolbar,
		className: "web.DHCOPBillStayCharge",
		queryName: "QryBillList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["admDate", "ward", "disDate", "prtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["insTypeDR", "prtRowId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "admTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.admDate + " " + value;
					};
				}
				if (cm[i].field == "dept") {
					cm[i].title = "科室病区";
					cm[i].formatter = function(value, row, index) {
					   	return value + " " + row.ward;
					};
				}
				if (cm[i].field == "stayStatus") {
					cm[i].formatter = function(value, row, index) {
					   	if (value) {
							return (value == 1) ? $g("留观出院") : ((value == 2) ? $g("正在留观") : "非留观");
						}
					};
				}
				if (cm[i].field == "disTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.disDate + " " + value;
					};
				}
				if (cm[i].field == "billId") {
					cm[i].formatter = function(value, row, index) {
						if (value) {
							return "<a href='javascript:;' class='datagrid-cell-img' title='医嘱明细' onclick='ordDtlClick(" + JSON.stringify(row) + ")'>" + value + "</a>";
						}
					}
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.prtDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "bed") {
						cm[i].width = 60;
					}
					if ($.inArray(cm[i].field, ["admTime", "dept", "disTime", "prtTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		rowStyler: function (index, row) {
			if (row.stayStatus == 1) {
				return "color: #FF0000;";     //留观出院的账单字体显示红色
			}
		},
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
			onLoadSuccessBillList(data);
		},
		onSelect: function (index, row) {
			onSelectBillListHanlder(index, row);
		}
	});
}

function onSelectBillListHanlder(index, row) {
	enableById("btn-charge");
	GV.BillID = row.billId;
	setValueById("insTypeId", row.insTypeDR);      //账单费别
	setValueById("chargeInsType", row.insTypeDR);  //结算费别默认为就诊费别
	setValueById("patShareAmt", row.patShareAmt);
	var accMLeft = getValueById("accMLeft");
	var amountToPay = Number(row.patShareAmt).sub(accMLeft).toFixed(2);
	setValueById("amountToPay", amountToPay);
}

function initEPDepList() {
	GV.EPDepList = $HUI.datagrid("#accDepList", {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		title: '押金列表',
		singleSelect: true,
		rownumbers: true,
		pageSize: 9999999,
		toolbar: [],
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
		onLoadSuccess: function (data) {
			setEPDepPanelTitle(data);
		}
	});
}

/**
* 押金支付方式汇总金额
*/
function setEPDepPanelTitle(data) {
	if (!GV.EPDepList.options().title) {
		return;
	}
	var paymObj = {};
	$.each(data.rows, function(index, row) {
		if (!row.AccPreRowID) {
			return true;
		}
		paymObj[row.Tpaymode] = Number(paymObj[row.Tpaymode] || 0).add(row.Tamt).toFixed(2);
	});

	var paymAry = [];
	$.each(Object.keys(paymObj), function(index, prop) {
		paymAry.push(prop + ": " + paymObj[prop]);
	});
	GV.EPDepList.getPanel().panel("setTitle", $g("押金列表") + "<span style=\"margin-left:30px;\">" + paymAry.join("&emsp;") + "</span>");
}

function onLoadSuccessBillList(data) {
	if (data.total == 0) {
		disableById("btn-charge");
		$("#patShareAmt,#amountToPay").numberbox("clear");
		return true;
	}
	var selectRowIndex = 0;    //默认第一行
	$.each(data.rows, function (index, row) {
		if (row.billId && (row.billId == GV.BillID)) {
			selectRowIndex = index;
			return false;
		}
	});
	GV.BillList.selectRow(selectRowIndex);
}

/**
* 初始化Tab面板事件
*/
function initTabs() {
	$("#chargeTabs").tabs({
		onSelect: function (title, index) {
			var tabPanel = $("#chargeTabs").tabs("getTab", index);
			if (!tabPanel) {
				return;
			}
			var tabId = tabPanel.panel("options").id;
			if (tabId == "billListTab") {
				loadBillList();
				return;
			}
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				$(this).tabs("select", 0);
				return;
			}
			var paramObj = {};
			switch (tabId) {
			case "splitBillTab":
				//拆分账单
				if (!checkCanIntPay()) {
					$(this).tabs("select", 0);
					break;
				}
				paramObj = {BillID: GV.BillID};
				break;
			default:
			}
			
			if (!$.isEmptyObject(paramObj)) {
				initCfgTab(tabId, paramObj);
			}
		}
	});
}

function initCfgTab(tabId, paramObj) {
	var $obj = $("#" + tabId);
	var param = "";
	$.each(Object.keys(paramObj), function(index, prop) {
		param = param + "&" + prop + "=" + paramObj[prop];
	});
	var opt = {id: tabId, title: $obj.panel("options").title, url: ($obj.attr("data") + param)}
	addOneTab("chargeTabs", opt);
}

/**
* 添加tab面板
*/
function addOneTab(parentId, opt) {
	if ($("#" + parentId).tabs("exists", opt.title)) {
		$("#" + parentId).tabs("select", opt.title);
		refreshTab(opt.id, opt.url);
		return;
	}
	$("#" + parentId).tabs("add", {
		id: opt.id,
		fit: true,
		title: opt.title,
		closable: false,
		selected: false,
		border: false,
		cache: false
	});
}

function refreshTab(tabId, url) {
	var iframeId = "iframe_" + tabId;
	var content = "<iframe id=\"" + iframeId + "\" src=\"" + websys_writeMWToken(url) + "\" width=\"100%\" height=\"100%\" scrolling=\"auto\" frameborder=\"0\"></iframe>";
	$("#" + tabId).css("overflow", "hidden").panel({
		content: content
	}).panel("refresh");
	
	focusById(iframeId);
}

/**
 * 判断能否拆分账单
 */
function checkCanIntPay() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择需要拆分账单的账单", type: "info"});
		return false;
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "该账单已封账，不能拆分账单", type: "info"});
		return false;
	}
	if (isChgedBill()) {
		$.messager.popover({msg: "该账单已结算，不能拆分账单", type: "info"});
		return;
	}
	return true;
}

function getReceiptNo() {
	var prtInvFlag = "";
	var fairType = "F";
	var insType = "";
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + prtInvFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + fairType + "^" + insType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var encmeth = getValueById("GetOPReceiptNoEncrypt");
	var rtn = cspRunServerMethod(encmeth, "setReceiptNo", "", expStr);
	if (rtn != 0) {
		disableById("btn-charge");
		$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
	}
}

function setReceiptNo(rtn) {
	var myAry = rtn.split("^");
	var currNo = myAry[0];
	var rowId = myAry[1];
	var leftNum = myAry[2];
	var endNo = myAry[3];
	var title = myAry[4];
	var tipFlag = myAry[5];
	if (rowId) {
		var receiptNo = title + "[" + currNo + "]";
		setValueById("receiptNo", receiptNo);
		var color = "green";
		if ($("#receiptNo").hasClass("newClsInvalid")) {
			$("#receiptNo").removeClass("newClsInvalid");
		}
		if (tipFlag == 1) {
			color = "red";
			$("#receiptNo").addClass("newClsInvalid");
		}
		var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
		$("#btn-tip").show().popover({cache: false, trigger: 'hover', content: content});
	}
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
		clearBanner();
		return;
	}
	setValueById("patientNo", json.PatientNo);
	setValueById("patientId", json.PatientId);
	
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
			refreshBar(json.PatientId, "");
			$.messager.popover({msg: "该患者无留观就诊", type: "info"});
			focusById("patientNo");
			return;
		}
	});
	setDefTabFromIframe();
}

function setAdmInfo(row) {
	GV.EpisodeID = row.TAdmRowID;
	GV.AccMRowID = row.TAccMRowId;
	setValueById("accMLeft", row.TAccMLeft);
	
	var patientId = getValueById("patientId");
	refreshBar(patientId, GV.EpisodeID);
	
	loadBillList();    //加载账单列表
	loadEPDepList();   //加载押金列表
}

/**
* 加载账单列表
*/
function loadBillList() {
	var queryParams = {
		ClassName: "web.DHCOPBillStayCharge",
		QueryName: "QryBillList",
		adm: GV.EpisodeID,
		sessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("billList", queryParams);
}

/**
* 加载押金列表
*/
function loadEPDepList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEPAddDeposit",
		QueryName: "GetEPDepDetail",
		AccMRowID: GV.AccMRowID,
		SessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("accDepList", queryParams);
}

/**
* 合并账单
*/
function delIntBillClick() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var notPayedNum = getNotPayedBillNum();
	if (!(notPayedNum > 1)) {
		$.messager.popover({msg: "患者无多个未结算账单，不需合并", type: "info"});
		return;
	}
	var url = "dhcbill.opbill.stay.mergebill.csp?EpisodeID=" + GV.EpisodeID;
	websys_showModal({
		url: url,
		title: $g('合并账单'),
		iconCls: 'icon-w-edit',
		width: 700,
		height: 400,
		callbackFun: function() {
			loadBillList();
		}
	});
}

/**
* 封账
*/
function closeAcountClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择需要封账的账单", type: "info"});
				return reject();
			}
			if (isClosedBill()) {
				$.messager.popover({msg: "该账单已封账，不能重复封账", type: "info"});
				return reject();
			}
			var pbData = getPersistClsObj("User.DHCPatientBill", GV.BillID);
			if (pbData.PBRefundFlag == "B") {
				$.messager.popover({msg: "该账单已经红冲，不能封账", type: "info"});
				return reject();
			}
			if (pbData.PBPayedFlag == "P") {
				$.messager.popover({msg: "该账单已结算，不能封账", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认封账？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _closeAcount = function() {
		return new Promise(function (resolve, reject) {
			$.messager.progress({title: "提示",	msg: "封账中...."});
			$.m({
				ClassName: "BILL.OP.BL.CloseBill",
				MethodName: "CloseAcount",
				adm: GV.EpisodeID,
				billId: GV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				clientIP: ClientIPAddress
			}, function(rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "封账成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "封账失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 封账成功后重新加载账单列表
	*/
	var _success = function () {
		loadBillList();
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
		
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_closeAcount)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
* 取消封账
*/
function uncloseAcountClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择需要取消封账的账单", type: "info"});
				return reject();
			}
			if (!isClosedBill()) {
				$.messager.popover({msg: "该账单未封账，无需取消", type: "info"});
				return reject();
			}
			var refundFlag = getPropValById("DHC_PatientBill", GV.BillID, "PB_RefundFlag");
			if (refundFlag == "B") {
				$.messager.popover({msg: "该账单已经红冲，不能取消封账", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认取消封账？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _uncloseAcount = function() {
		return new Promise(function (resolve, reject) {
			$.messager.progress({title: "提示",	msg: "取消封账中...."});
			$.m({
				ClassName: "BILL.OP.BL.CloseBill",
				MethodName: "UnCloseAcount",
				adm: GV.EpisodeID,
				billId: GV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				clientIP: ClientIPAddress
			}, function(rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "取消封账成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "取消封账失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 取消封账成功后重新加载账单列表
	*/
	var _success = function () {
		loadBillList();
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_uncloseAcount)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
* 判断账单是否已封账
* true:已封账, false:未封账
*/
function isClosedBill() {
	return ($.m({ClassName: "BILL.OP.BL.CloseBill", MethodName: "GetPaidCAcountFlag", billId: GV.BillID}, false) == "Y");
}

/**
* 判断账单是否已结算
*/
function isChgedBill() {
	return ($.m({ClassName: "BILL.OP.COM.Method", MethodName: "GetPrtInvIdByBill", billId: GV.BillID}, false) > 0);
}

/**
* 结算
*/
function chargeClick() {
	/**
	* 校验结算必要条件
	*/
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: $g("该患者无急诊留观就诊信息，不能结算"), type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: $g("请先选择需要结算的账单，不能结算"), type: "info"});
				return reject();
			}
			var stayStatus = getStayStatus();
			if (stayStatus == -1) {
				$.messager.popover({msg: $g("非留观患者，不能结算"), type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认结算？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 获取结算扩展串参数
	*/
	var _getBillExpStr = function () {
		var requiredInvFlag = "Y";
	    var fairType = "F";
	    var actualMoney = "";  //实付
	    var changeAmt = "";    //找零
	    var roundErr = "";     //分币误差
	    var stayFlag = "Y";    //留观标识
	    return PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + GV.AccMRowID
	     + "^" + requiredInvFlag + "^" + fairType + "^" + actualMoney + "^" + changeAmt
	     + "^" + roundErr + "^" + chargeInsType + "^" + ClientIPAddress + "^" + stayFlag;
	};

	/**
	* HIS预结算
	*/
	var _chgBill = function () {
		return new Promise(function (resolve, reject) {
			var rtn = $.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "StayCharge",
				billId: GV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				insTypeId: curInsType,
				patPaySum: patPaySum,
				expStr: _getBillExpStr()
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				myPRTStr = myAry.slice(1).join("^");
				return resolve();
			}
			chargeErrorTip("preChargeError", rtn);
			return reject();
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(admSource > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1)  {
				return resolve();
			}
			var myYBHand = "";
			var myCPPFlag = "ECPP";
			var myLeftAmt = accMLeft;
			//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^账户余额^结算来源^数据库连接串^待遇类型^账户ID^院区DR^自费支付方式DR！Money^MoneyType
			var myStrikeFlag = "N";
			var myInsuNo = "";
			var myCardType = "";
			var myYLLB = "";
			var myDicCode = "";
			var myDicDesc = "";
			var myDYLB = "";
			var myChargeSource = "01";
			var myDBConStr = "";         //数据库连接串
			var myMoneyType = "";
			var selPaymId = "";
			var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
			myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + GV.AccMRowID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + myLeftAmt + "^" + myMoneyType;
			var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myPRTStr, admSource, chargeInsType, myYBExpStr, myCPPFlag);
			var myYBAry = myYBRtn.split("^");
			if (myYBAry[0] == "YBCancle") {
				return reject();
			}
			if (myYBAry[0] == "HisCancleFailed") {
				$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* 生成支付方式列表
	* 如果有第三方支付也在此方法中完成
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			myPRTStr = getSuccPrtRowIdStr(myPRTStr);
			var invAmtInfo = getInvAmtInfo(myPRTStr);
			var aryAmt = invAmtInfo.split("^");
		    var totalAmt = aryAmt[0];
		    var discAmt = aryAmt[1];
		    var payorAmt = aryAmt[2];
		    var patShareAmt = aryAmt[3];
		    var insuAmt = aryAmt[4];
		    var payAmt = Number(patShareAmt).sub(insuAmt).toFixed(2);   //自费支付额
		    if (payAmt == 0) {
		        return resolve();     //无需自费支付时，直接确认完成
		    }
		    if (+accMLeft >= +payAmt) {
			    myPayInfo = buildPayStr(myPRTStr);   //押金足额时，用留观押金结算，不再弹收银台
		        return resolve();
		    }
		    var argumentObj = {
		        title: "收银台-急诊留观结算",
		        cardNo: cardNo,
		        cardTypeId: cardTypeId,
		        accMRowId: GV.AccMRowID,
		        accMLeft: accMLeft,
		        patientId: patientId,
		        episodeIdStr: GV.EpisodeID,
		        allowPayMent: "Y",
		        insTypeId: insTypeId,
		        typeFlag: "OBS",
		        prtRowIdStr: myPRTStr,
		        totalAmt: totalAmt,
		        discAmt: discAmt,
		        payorAmt: payorAmt,
		        patShareAmt: patShareAmt,
		        insuAmt: insuAmt,
		        payAmt: payAmt,
		        bizType: "OP"
		    };
		    BILL_INF.showCheckout(argumentObj).then(function (payMList) {
			    myPayInfo = payMList;
		        resolve();
		    }, function () {
		        reject();
		    });
		});
	};
	
	/**
	* 确认完成
	*/
	var _complete = function () {
		return new Promise(function (resolve, reject) {
			var rtn = $.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "CompleteStayCharge",
				billId: GV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				insTypeId: curInsType,
				prtRowIdStr: myPRTStr,
				expStr: _getBillExpStr(),
				payInfo: myPayInfo
			}, false);
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "结算成功", type: "success"});
				clearDocWin();
				return resolve();
			}
			chargeErrorTip("completeError", rtn);
			_cancelPaySrv();
			return reject();
		});
	};
	
	/**
	* 打印发票
	*/
	var _printInv = function() {
		invPrint(myPRTStr);
	};
	
	/**
	* 撤销第三方交易
	*/
	var _cancelPaySrv = function() {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
		$.each(myPayInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2), function(index, item) {
			if (item) {
				var myPayMAry = item.split("^");
				var myETPRowID = myPayMAry[11];
				if (myETPRowID) {
					var rtnValue = CancelPayService(myETPRowID, expStr);
					if (rtnValue.ResultCode != 0) {
						$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
					}
				}
			}
		});
	};
	
	if ($("#btn-charge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-charge").linkbutton("disable");
	
	var patientId = getValueById("patientId");
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	
	var accMLeft = getValueById("accMLeft");
	var patPaySum = getValueById("patShareAmt");                  //总费用
	var curInsType = getValueById("insTypeId");
	var chargeInsType = getValueById("chargeInsType") || curInsType;   //结算费别
	var admSource = getPropValById("PAC_AdmReason", chargeInsType, "REA_AdmSource");
	
	var myPRTStr = "";
	var myPayInfo = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_chgBill)
		.then(_insuDiv)
		.then(_buildPayMList)
		.then(_complete)
		.then(function() {
			_printInv();
			$("#btn-charge").linkbutton("enable");
		}, function() {
			validPrtRowIDStr(myPRTStr);
			$("#btn-charge").linkbutton("enable");
		});
}

/**
* 返回重组发票rowId串(过滤回滚的发票rowId)
*/
function getSuccPrtRowIdStr(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillCons12", MethodName: "ValidatePrtRowID", prtRowIdStr: prtRowIdStr}, false);
}

/**
* 获取结算发票信息
*/
function getInvAmtInfo(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: prtRowIdStr}, false);
}

/**
* 判断是否离院
*/
function getStayStatus() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetObsPatYetDisHosp", episodeID: GV.EpisodeID}, false);
}

function invPrint(prtInvIdStr) {
	GV.INVXMLName = CV.INVXMLName;
	if (!GV.INVXMLName) {
		return;
	}
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			//根据实际发票的收费类别查找模板名称
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //此处只修改调用模板, 不需要修改PrtXMLName
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}

/**
* 验证结算记录，失败的倒序撤销
*/
function validPrtRowIDStr(prtRowIdStr) {
	var bool = true;
	if (!prtRowIdStr) {
		return bool;
	}
	//倒序
	prtRowIdStr = prtRowIdStr.split("^").sort(function(a, b) {
		return b - a;
	}).join("^");
	var inValidStr = $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetInvalidPrtIDStr", prtRowIdStr: prtRowIdStr}, false);
	if (inValidStr != "") {
		var inValidAry = inValidStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
		$.each(inValidAry, function(index, item) {
			var singleAry = item.split("^");
			var prtRowId = singleAry[0];
			var insTypeId = singleAry[1];
			var admSource = singleAry[2];
			var insuDivId = singleAry[3];
			bool = chgRollback(prtRowId, insTypeId, admSource, insuDivId);
			if (!bool) {
				return false;
			}
		});
	}
	return bool;
}

/**
* HIS撤销结算
*/
function chgRollback(prtRowId, insTypeId, admSource, insuDivId) {
	if (insuDivId > 0) {
		//撤销医保结算
		var myYBHand = "";
		var myCPPFlag = "";
		var myStrikeFlag = "S";
		var myInsuNo = "";
		var myCardType = "";
		var myYLLB = "";
		var myDicCode = "";
		var myDYLB = "";
		var myLeftAmt = "";
		var myMoneyType = "";  //卡类型
		var myLeftAmtStr = myLeftAmt + "!" + myLeftAmt + "^" + myMoneyType;
		var myExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDYLB + "^" + myLeftAmtStr;
		var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insTypeId, myExpStr, myCPPFlag);
		if (rtn != 0) {
			$.messager.alert("提示", "医保发票冲票错误", "error");
			return false;
		}
	}
	
	//HIS数据回滚
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	var myAry = rtn.split("^");
	if (myAry[0] != 0) {
		$.messager.alert("提示", "HIS回滚失败", "error");
		return false;
	}
	return true;
}

/**
* 清屏
*/
function clearClick() {
	setDefTabFromIframe();
	initAllDoc();
}

function clearDocWin() {
	$.m({
		ClassName: "web.DHCOPBillStayCharge",
		MethodName: "HasNotPayedBill",
		adm: GV.EpisodeID
	}, function(rtn) {
		if (rtn == 0) {
			initAllDoc();
			return;
		}
		initPartDoc();
	});
}

function initAllDoc() {
	clearGV();
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".numberbox-f").numberbox("clear");
	$(".combobox-f").combobox("clear");
	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
	disableById("btn-charge");
	setValueById("insTypeId", "");
	clearBanner();
	getReceiptNo();
}

function initPartDoc() {
	GV.BillID = "";
	getReceiptNo();
	loadBillList();
}

function clearGV() {
	GV.PatientID = "";
	GV.EpisodeID = "";
	GV.BillID = "";
	GV.AccMRowID = "";
}

function ordDtlClick(row) {
	if (!row.billId) {
		$.messager.popover({msg: "账单为空", type: "info"});
		return;
	}
	var url = "dhcbill.opbill.billoeitm.csp?billId=" + row.billId;
	websys_showModal({
		url: url,
		title: $g('医嘱费用明细'),
		iconCls: 'icon-w-list'
	});
}

function buildPayStr(prtRowIdStr) {
	var myPaymId = CV.PayMRowID;
	var myPayCard = "";
	var myUnit = ""
	var myBankDR = ""
	var myCheckNo = "";
	var myChequeDate = "";
	var myPayAccNo = "";
	
	var mySelfPayAmt = getPatSelfPayAmt(prtRowIdStr);
	var myInvRoundErrDetails = ""; //发票分币误差明细
	var actualMoney = "";    //实收
	var backChange = "";     //找零
	
	var payStr = myPaymId + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard + "^" + myUnit + "^" + myChequeDate + "^" + myPayAccNo + "^" + mySelfPayAmt + "^" + myInvRoundErrDetails + "^" + actualMoney + "^" + backChange;
	payStr = payStr.replace(/undefined/g, "");   //替换所有的undefined

	return payStr;
}

/**
* 2020-06-08
* Lid
* 获取患者自费金额
*/
function getPatSelfPayAmt(prtRowIdStr){
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetPatSelfPayAmt", prtRowIdStr: prtRowIdStr}, false);
}

/**
* iframe 调用父窗口方法来跳转到病人列表
*/
function setDefTabFromIframe() {
	$("#chargeTabs").tabs("select", 0);
}

function getNotPayedBillNum() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "JudgeBillNum", Adm: GV.EpisodeID}, false);
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	setValueById("patientNo", patientId);
	setValueById("admList", episodeId);
	getPatInfo();
}