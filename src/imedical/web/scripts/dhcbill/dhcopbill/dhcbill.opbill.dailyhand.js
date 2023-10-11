/**
 * FileName: dhcbill.opbill.dailyhand.js
 * Author: ZhYW
 * Date: 2018-03-05
 * Description: 门诊收费日结
 */

$(function () {
	initQueryMenu();
});

function initQueryMenu() {
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadSelDetails();
		}
	});
	
	$HUI.linkbutton("#btnPreHandin, #btnHandin", {
		onClick: function () {
			handinClick(this.id);
		}
	});
	
	$HUI.linkbutton("#btnCancel", {
		onClick: function () {
			cancelClick();
		}
	});
	
	$HUI.checkbox("#checkHand", {
		onChecked: function(e, value) {
			handChecked();
		},
		onUnchecked: function(e, value) {
			handUnchecked();
		}
	});
	
	$HUI.linkbutton("#btnReset", {
		onClick: function () {
			resetClick();
		}
	});
	
	getStDateTime();
}

/**
* 结算历史选中事件
*/
function handChecked() {
	disableById("btnPreHandin");
	disableById("btnHandin");
	$(".layout:first").layout("add", {
		region: 'east',
		width: 410,
		title: $g('结算记录'),
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		collapsible: false
	}).layout("panel", "east").append("<ul id='reports-tree'></ul>");
	initReportsTree();
}

/**
* 结算历史取消选中事件
*/
function handUnchecked() {
	$("#endDateTime").datetimebox({
		disabled: (GV.EditEndDate != 1)
	});
	enableById("btnPreHandin");
	enableById("btnHandin");
	$(".layout:first").layout("remove", "east");
	setValueById("footId", "");    //取消勾选时，将结账Id赋空
	getStDateTime();
}

/**
* 取开始日期
*/
function getStDateTime() {
	var rtn = $.m({ClassName: "web.DHCOPBillDailyHandin", MethodName: "GetStDate", userId: PUBLIC_CONSTANT.SESSION.USERID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	var myAry = rtn.split("^");
	var stDate = myAry[0];
	var stTime = myAry[1];
	var endDate = myAry[2];
	var endTime = myAry[3];
	var stDateTime = stDate + " " + stTime;
	var endDateTime = endDate + " " + endTime;
	$("#stDateTime").datetimebox("setValue", stDateTime);
	$("#endDateTime").datetimebox("setValue", endDateTime);
}

/**
* 结算记录树
*/
function initReportsTree() {
	GV.ReportsTree = $HUI.tree("#reports-tree", {
		fit: true,
		url: $URL + '?ClassName=web.DHCOPBillDailyHandin&MethodName=BuildReportsTree&ResultSetType=array',
		animate: true,
		autoNodeHeight: true,
		onBeforeLoad: function(node, param) {
			param.guser = PUBLIC_CONSTANT.SESSION.USERID;
			param.hospDR = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.langId = PUBLIC_CONSTANT.SESSION.LANGID;
		},
		formatter: function(node) {
			if (node.children) {
				return node.text;
			}
			return "<div>"
             + "<div style='height:20px;line-height:20px;color:gray;'>" + node.attributes.stDateTime + "—" + node.attributes.endDateTime + "</div>"
             + "<div style='height:20px;line-height:20px;'>" + node.text + "</div>"
             + "</div>";
		},
		onClick: function (node) {
			$(this).tree("toggle", node.target);
		},
		onSelect: function (node) {
			if ($(this).tree("isLeaf", node.target)) {
				scanReportsList(node);
			}
		}
	});
}

function scanReportsList(node) {
	setValueById("footId", node.id);
	$("#stDateTime").datetimebox("setValue", node.attributes.stDateTime);
	$("#endDateTime").datetimebox("disable").datetimebox("setValue", node.attributes.endDateTime);
	loadSelDetails();
}

/**
 * 结账
 */
function handinClick(btnId) {
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认结算？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _handin = function () {
		return new Promise(function (resolve, reject) {
			var preHandinFlag = (btnId == "btnHandin") ? "N" : "Y";  //预结算/结算标识
			var stDateTime = $("#stDateTime").datetimebox("getValue");
			var endDateTime = $("#endDateTime").datetimebox("getValue");
			stDateTime = stDateTime.replace(" ", "^");
			endDateTime = endDateTime.replace(" ", "^");
			var footInfo = stDateTime + "^" + endDateTime + "^" + "N" + "^" + preHandinFlag;
			$.m({
				ClassName: "web.DHCOPBillDailyHandin",
				MethodName: "Handin",
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				hospDr: PUBLIC_CONSTANT.SESSION.HOSPID,
				footInfo: footInfo
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					footId = myAry[1];
					$.messager.popover({msg: "结算成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "结算失败: " + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 成功后页面处理
	*/
	var _success = function () {
		setValueById("footId", footId);   //结账RowId
		loadSelDetails();         //刷新当前选中的tab
	};
	
	if ($("#" + btnId).linkbutton("options").disabled) {
		return;
	}
	$("#" + btnId).linkbutton("disable");
	
	var footId = "";   //结账RowId
	
	var promise = Promise.resolve();
	promise
		.then(_cfr)
		.then(_handin)
		.then(function() {
			_success();
		}, function () {
			$("#" + btnId).linkbutton("enable");
		});
}

/**
 * 取消结账
 */
function cancelClick() {	
	var _valid = function () {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCOPBillDailyHandin",
				MethodName: "GetLastHandinInfo",
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function (rtn) {
				var myAry = rtn.split("^");
				footId = myAry[0];
				var footDate = myAry[1];
				var footTime = myAry[2];
				var receFlag = myAry[3];    //组长接收标识
				var todayFlag = myAry[4];
				if (!footId) {
					return reject();
				}
				if (receFlag == "Y") {
					$.messager.popover({msg: $g("组长已经接收，不能取消"), type: "info"});
					return reject();
				}
				if (todayFlag == "N") {
					$.messager.popover({msg: $g("该记录结账日期为：") + footDate + $g('，隔日不能取消'), type: "info"});
					return reject();
				}
				return resolve();
			});
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认取消最后一条结账记录？", function (r) {
				return r ? resolve() : reject();
			});
			//以下代码控制焦点在取消按钮
			$(".messager-button>a .l-btn-text").each(function(index, item) {
				if ($.inArray($(this).text(), ["Cancel", $g("取消")]) != -1) {
					$(this).parent().parent().trigger("focus");   //取消按钮聚焦
					return false;
				}
			});
		});
	};

	var _cancel = function () {
		return new Promise(function (resolve, reject) {
			$.cm({
				ClassName: "web.DHCOPBillDailyHandin",
				MethodName: "CancelHandin",
				footId: footId
			}, function (json) {
				$.messager.popover({msg: json.msg, type: ((json.success == 0) ? "success" : "error")});
				if (json.success == 0) {
					return resolve();
				}
				return reject();
			});
		});
	};
	
	/**
	* 成功后页面处理
	*/
	var _success = function () {
		setValueById("footId", "");
		if ($("#reports-tree").length > 0) {
			$("#reports-tree").tree("reload");
		}else {
			$("#btnHandin, #btnPreHandin").linkbutton("enable");
		}
		getStDateTime();       //取消后重新获取新的日期时间
		loadSelDetails();      //刷新当前选中的tab
	};
	
	if ($("#btnCancel").linkbutton("options").disabled) {
		return;
	}
	$("#btnCancel").linkbutton("disable");
	
	var footId = "";   //结账RowId
	
	var promise = Promise.resolve();
	promise
		.then(_valid)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$("#btnCancel").linkbutton("enable");
		}, function () {
			$("#btnCancel").linkbutton("enable");
		});
}

/**
 * 加载iframe页签明细内容
 */
function loadSelDetails() {
	var iframe = $("#tabMain")[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}

/**
 * 重置
 */
function resetClick() {
	if (getValueById("checkHand")) {
		$HUI.checkbox("#checkHand").uncheck();
	}else {
		handUnchecked();
	}
	loadSelDetails();
}