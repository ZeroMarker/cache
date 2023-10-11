/**
 * FileName: dhcbill.opbill.refaudit.js
 * Author: ZhYW
 * Date: 2018-11-14
 * Description: 门诊退费审核
 */

$(function () {
	initQueryMenu();
	initInvList();
	for (var i = 1, len = getTabsLength(); i <= len; i++) {
		initOrdItmList(i);
	}
});

function initQueryMenu() {
	$("#stDate, #endDate").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});

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

	//发票回车查询事件
	$("#invNo").keydown(function (e) {
		invNoKeydown(e);
	});

	var $tb = $("#more-container");
	if(HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	};
	$("#more-container").click(function () {
		var t = $(this);
		if (t.find(".arrows-b-text").text() == $g("更多")) {
			t.find(".arrows-b-text").text($g("收起"));
			var ui = (HISUIStyleCode == "lite") ? "l" : "b";
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("更多"));
			var ui = (HISUIStyleCode == "lite") ? "l" : "b";
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
		}
	});
	
	$HUI.tabs("#audit-tabs", {
		onSelect: function(title, index) {
			loadOrdItmList();
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
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
			$("#CardNo").focus();
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
		loadInvList();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadInvList();
		});
	}
}

/**
 * 发票号回车查询
 */
function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "CheckInvIsReqByInvNo",
			invNo: $(e.target).val()
		}, function (rtn) {
			if (rtn == 0) {
				$.messager.alert("提示", "该发票不存在或未作申请.", "info");
				return;
			}
			loadInvList();
		});
	}
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout:eq(1)");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (num > 0) {
		$("tr.display-more-tr").show();
	} else {
		$("tr.display-more-tr").hide();
	}
	var c = l.layout("panel", "center");
	var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
	c.panel("resize", {
		height: ch,
		top: nh
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillRefundRequest",
		queryName: "FindReqInvInfo",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["prtRowId", "invFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.prtDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "prtTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				$(this).datagrid("checkAll");
			}else {
				$(this).datagrid("clearChecked");
			}
		},
		onCheck: function (rowIndex, rowData) {
			loadDefTabContent();
		},
		onUncheck: function (rowIndex, rowData) {
			loadDefTabContent();
		},
		onCheckAll: function (rows) {
			loadDefTabContent();
		},
		onUncheckAll: function (rows) {
			loadDefTabContent();
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: "FindReqInvInfo",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		receiptNo: getValueById("invNo"),
		patientNo: getValueById("patientNo"),
		patientName: getValueById("patName"),
		chargeUser: getValueById("userName"),
		sessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

function initOrdItmList(index) {
	var toolbar = [];
	if (index == 1) {
		toolbar = [{
				text: '审核',
				iconCls: 'icon-stamp-pass',
				handler: function () {
					auditClick();
				}
			}
		];
	}
	if (index == 3) {
		toolbar = [{
				text: '撤销审核',
				iconCls: 'icon-stamp-cancel',
				handler: function () {
					cancelClick();
				}
			}
		];
	};
	
	$HUI.datagrid("#ordItmList-" + index, {
		fit: true,
		border: false,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: toolbar,
		columns: [getOrdItmColumns(index)],
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
		},
		onCheck: function (index, row) {
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			ctrlMedItm(index, row);
		},
		onUncheck: function (index, row) {
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			ctrlMedItm(index, row);
		}
	});
}

function loadOrdItmList() {
	var invStr = getCheckedInvStr();
	var index = getSelTabIndex();
	var queryParams = {
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: (index == 2) ? "FindOrdItm" : "FindIOASubInfo",
		invStr: invStr,
		auditFlag: getAuditFlag(),
		sessionStr: getSessionStr(),
		rows: 999999999
	}
	loadDataGridStore("ordItmList-" + index, queryParams);
}

/**
 * 审核
 */
function auditClick() {
	var invSubStr = getCheckedInvSubStr();
	if (!invSubStr) {
		$.messager.popover({msg: "请勾选需要审核的医嘱", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认审核? ", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "RefundAudit",
			invSubStr: invSubStr,
			sessionStr: getSessionStr()
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: myAry[1], type: "success"});
				ordItmListObj().reload();
				return;
			}
			$.messager.popover({msg: myAry[1], type: "info"});
		});
	});
}

/**
 * 撤销审核
 */
function cancelClick() {
	var invSubStr = getCheckedInvSubStr();
	if (!invSubStr) {
		$.messager.popover({msg: "请勾选需要撤销审核的医嘱", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认撤销审核? ", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "CancelAudit",
			invSubStr: invSubStr,
			sessionStr: getSessionStr()
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: myAry[1], type: "success"});
				ordItmListObj().reload();
				return;
			}
			$.messager.popover({msg: myAry[1], type: "info"});
		});
	});
}

/**
 * 取勾选中的票据Id串
 */
function getCheckedInvStr() {
	return GV.InvList.getChecked().map(function(row) {
		return row.prtRowId + ":" + row.invFlag;
	}).join("^");
}

/**
 * 控制草药按处方退费
 */
function ctrlMedItm(index, row) {
	var ordCateType = row.ordCateType;
	if (ordCateType != "R") {
		return;
	}
	var oeori = row.oeori;
	var prescNo = row.prescNo;
	var phdicId = row.phdicId;
	var isCNMedItem = row.isCNMedItem;    //草药标识(0:不是; 1:是)
	var isOweDrug = row.isOweDrug;        //欠药标识(0:欠药; 1:非欠药)
	
	var checked = getOrdItmRowChecked(index);
	var rows = ordItmListObj().getRows();

	//1.控制草药按处方退费
	if (isCNMedItem == 1) {
		$.each(rows, function (idx, r) {
			if (index == idx) {
				return true;
			}
			if (prescNo != r.prescNo) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	//2.控制欠药医嘱按处方退费
	if (isOweDrug == 0) {
		$.each(rows, function (idx, r) {
			if (isOweDrug != r.isOweDrug) {
				return true;
			}
			if (index == idx) {
				return true;
			}
			if (prescNo != r.prescNo) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	//3.控制静脉配液医嘱
	if (checked) {
		$.each(rows, function (idx, r) {
			if (r.phdicId) {
				return true;
			}
			if (index == idx) {
				return true;
			}
			if (oeori != r.oeori) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	if (!phdicId) {
		//未发药记录取消勾选时，所有记录都不勾选
		$.each(rows, function (idx, r) {
			if (index == idx) {
				return true;
			}
			if (oeori != r.oeori) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	//已发药的取消勾选时，判断是否还有其他勾选中的发药记录，如无，则取消勾选所有未发记录
	var disp = 0;
	$.each(rows, function (idx, r) {
		if (!r.phdicId) {
			return true;
		}
		if (index == idx) {
			return true;
		}
		if (oeori != r.oeori) {
			return true;
		}
		if (getOrdItmRowChecked(idx)) {
			disp = 1;
			return false;
		}
	});
	if (disp == 1) {
		//有其他勾选中的发药记录时，退出
		return;
	}
	$.each(rows, function (idx, r) {
		if (r.phdicId) {
			return true;
		}
		if (index == idx) {
			return true;
		}
		if (oeori != r.oeori) {
			return true;
		}
		setOrdItmRowChecked(idx, checked);
	});
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelRowIndex = index;
	if (checked) {
		ordItmListObj().checkRow(index);
	}else {
		ordItmListObj().uncheckRow(index);
	}
	GV.SelRowIndex = undefined;
}

/**
 * 获取勾选的datagrid行数据
 */
function getCheckedInvSubStr() {
	return ordItmListObj().getChecked().map(function(row) {
		return row.invSubId;
	}).join("^");
}

/**
 * 设置医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return ordItmListObj().getPanel().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(":checked");
}

/**
 * 获取选中的tabs索引
 */
function getSelTabIndex() {
	var tabsObj = $HUI.tabs("#audit-tabs");
	return tabsObj.getTabIndex(tabsObj.getSelected());
}

/**
 * 加载默认的tabs内容
 */
function loadDefTabContent() {
	var index = 1;
	$HUI.tabs("#audit-tabs").select(index);   //设置选中
	loadOrdItmList();
}

/**
 * 获取当前医嘱明细grid对象
 */
function ordItmListObj() {
	return $HUI.datagrid("#ordItmList-" + getSelTabIndex());
}

/**
 * 获取当前医嘱明细grid对象
 */
function getTabsLength() {
	return $("table[id^='ordItmList']").length;
}

/**
 * 获取当前tabs下的审核标识
 */
function getAuditFlag() {
	var index = getSelTabIndex();
	var auditFlag = "";
	switch (index) {
	case 1:
		auditFlag = "U";
		break;
	case 3:
		auditFlag = "A";
		break;
	default:
	}
	return auditFlag;
}

/**
 * 获取医嘱列数组
 */
function getOrdItmColumns(index) {
	var columns = [{field: 'ck', checkbox: true},
				   {title: '医嘱', field: 'arcimDesc', width: 220},
				   {title: '申请数量', field: 'reqQty', width: 80},
				   {title: '单位', field: 'packUom', width: 60},
				   {title: '金额', field: 'reqAmt', align: 'right', width: 60},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '接收科室', field: 'recDept', width: 100},
				   {title: '申请人', field: 'reqUserName', width: 90},
				   {title: '申请时间', field: 'reqDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.reqTime;
					}
				   },
				   {title: '退费原因', field: 'reqReason', width: 80},
				   {title: '审核人', field: 'auditUserName', width: 80},
				   {title: '审核时间', field: 'auditDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.auditTime;
					}
				   },
				   {title: '医嘱ID', field: 'oeori', width: 70},
				   {title: 'reqFlag', field: 'reqFlag',  hidden: true},
				   {title: 'invSubId', field: 'invSubId', hidden: true},
				   {title: 'ordCateType', field: 'ordCateType', hidden: true},
				   {title: 'phdicId', field: 'phdicId', hidden: true},
				   {title: 'isCNMedItem', field: 'isCNMedItem', hidden: true},
				   {title: 'isOweDrug', field: 'isOweDrug', hidden: true}];
				   
	switch (index) {
	case 1:
		var hideColAry = ["auditUserName", "auditDate"];    //不显示的列
		columns = columns.filter(function(item) {
			return hideColAry.indexOf(item.field) == -1;
		});
		break;
	case 2:
		columns = [{title: '医嘱', field: 'arcimDesc', width: 220},
				   {title: '数量', field: 'billQty', width: 80},
				   {title: '申请数量', field: 'alreadyReqQty', width: 80},
				   {title: '单位', field: 'packUom', width: 60},
				   {title: '金额', field: 'billAmt', align: 'right', width: 60},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '接收科室', field: 'recDept', width: 100},
				   {title: '执行情况', field: 'execInfo', width: 160},
				   {title: '审核人', field: 'auditUserName', width: 80},
				   {title: '审核时间', field: 'auditDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.auditTime;
					}
				   },
				   {title: 'ordCateType', field: 'ordCateType', hidden: true},
				   {title: '医嘱ID', field: 'oeori', width: 70}]
		break;
	default:
	}
	return columns;
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num)").val("");
	$("#stDate, #endDate").datebox("setValue", CV.DefDate);
	GV.InvList.load({
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: "FindReqInvInfo",
		stDate: "",
		endDate: "",
		receiptNo: "",
		patientNo: "",
		patientName: "",
		chargeUser: "",
		sessionStr: getSessionStr()
	});
	$HUI.tabs("#audit-tabs").select(1);   //设置选中
	for (var i = 1, len = getTabsLength(); i <= len; i++) {
		$("#ordItmList-" + i).datagrid("loadData", {
			total: 0,
			rows: []
		});
	}
}
