/**
 * FileName: dhcbill.ipbill.dailyhand.js
 * Anchor: ZhYW
 * Date: 2018-03-16
 * Description: 住院收费日结
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

	$HUI.linkbutton("#btnHandin", {
		onClick: function () {
			handinClick();
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
	disableById("btnHandin");
	$(".layout:first").layout("add", {
		region: 'east',
		width: 410,
		title: '结算记录',
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
	enableById("btnHandin");
	$(".layout:first").layout("remove", "east");
	setValueById("footId", "");    //取消勾选时，将结账Id赋空
	getStDateTime();
}

/**
* 取开始日期
*/
function getStDateTime() {
	var rtn = $.m({ClassName: "web.DHCIPBillDailyHandin", MethodName: "GetStDate", guser: PUBLIC_CONSTANT.SESSION.USERID, hospDR: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
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
		url: $URL + "?ClassName=web.DHCIPBillDailyHandin&MethodName=BuildReportsTree&ResultSetType=array&guser=" + PUBLIC_CONSTANT.SESSION.USERID + "&hospDR=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		animate: true,
		autoNodeHeight: true,
		formatter: function(node) {
			if (node.children) {
				return node.text;
			}else {
				return "<div>"
					+ "<div style='height:20px;line-height:20px;color:gray'>" + node.attributes.stDateTime + "—" + node.attributes.endDateTime + "</div>"
					+ "<div style='height:20px;line-height:20px;'>" + node.text + "</div>"
					+ "</div>";
			}
		},
		onSelect: function (node) {
			if ($(this).tree("isLeaf", node.target)) {
				scanReportsList(node.id);
			}
		}
	});
}

function scanReportsList(footId) {
	setValueById("footId", footId);
	var node = GV.ReportsTree.find(footId);
	$("#stDateTime").datetimebox("setValue", node.attributes.stDateTime);
	$("#endDateTime").datetimebox("disable").datetimebox("setValue", node.attributes.endDateTime);
	loadSelDetails();
}

/**
 * 结账
 */
function handinClick() {
	$.messager.confirm("确认", "是否确认结算?", function (r) {
		if (r) {
			var stDateTime = $("#stDateTime").datetimebox("getValue");
			var endDateTime = $("#endDateTime").datetimebox("getValue");
			stDateTime = stDateTime.replace(" ", "^");
			endDateTime = endDateTime.replace(" ", "^");
			var footInfo = stDateTime + "^" + endDateTime + "^" + "N";
			$.m({
				ClassName: "web.DHCIPBillDailyHandin",
				MethodName: "Handin",
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				hospDR: PUBLIC_CONSTANT.SESSION.HOSPID,
				footInfo: footInfo
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				switch(success) {
				case "0":
					$.messager.alert("提示", "结算成功", "info");
					setValueById("footId", myAry[1]);   //结账RowId
					disableById("btnHandin");
					loadSelDetails();           //刷新当前选中的tab
					break;
				case "ConfigErr":
					$.messager.alert("提示", "在系统配置时间已结账, 当天不能再次结账", "error");
					break;
				case "StTimeErr":
					$.messager.alert("提示", "开始时间不能大于结束时间", "error");
					break;
				case "EndTimeErr":
					$.messager.alert("提示", "结束时间不能大于当前时间", "error");
					break;
				default:
					$.messager.alert("提示", "结算失败, 错误代码: " + success, "error");
				}
			});
		}
	});
}

/**
 * 取消结账
 */
function cancelClick() {
	$.messager.confirm('确认', '确认取消最后一条结账记录？', function (r) {
		if (r) {
			$.m({
				ClassName: "web.DHCIPBillDailyHandin",
				MethodName: "GetLastHandinInfo",
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function (txtData) {
				var myAry = txtData.split('^');
				var footId = myAry[0];
				var footDate = myAry[1];
				var footTime = myAry[2];
				var receFlag = myAry[3]; //组长接收标识
				var todayFlag = myAry[4];
				if (footId == "") {
					return;
				}
				if (receFlag == "Y") {
					$.messager.alert("提示", "组长已经接收, 不能取消", "warning");
					return;
				}
				if (todayFlag == "N") {
					$.messager.alert("提示", "该记录结账日期为:" + footDate + " 隔日不能取消", "warning");
					return;
				}
				$.cm({
					ClassName: "web.DHCIPBillDailyHandin",
					MethodName: "CancelHandin",
					footId: footId
				}, function (jsonData) {
					$.messager.alert("提示", jsonData.msg, "info");
					setValueById("footId", "");
					if (jsonData.success == 0) {
						if ($("#reports-tree").length > 0) {
							$("#reports-tree").tree("reload");
						}
						getStDateTime();       //取消后重新获取新的日期时间
						loadSelDetails();      //刷新当前选中的tab
					}
				});
			});
		}
	});
	//以下代码控制焦点在取消按钮
	var okSpans = $('.l-btn-text');
	var len = okSpans.length;
	for (var i = 0; i < len; i++) {
		var $okSpan = $(okSpans[i]);
		var okSpanHtml = $okSpan.html();
		if (okSpanHtml == 'Cancel' || okSpanHtml == '取消') {
			$okSpan.parent().parent().trigger('focus');
		}
	}
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