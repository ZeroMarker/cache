/**
 * FileName: dhcbill.ipbill.dailycollect.js
 * Anchor: ZhYW
 * Date: 2018-03-12
 * Description: 住院收费日结汇总
 */

var GV = {};

$(function () {
	initQueryMenu();
});

function initQueryMenu() {
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadSelDetails();
		}
	});
	
	$HUI.linkbutton("#btnReceive", {
		onClick: function () {
			receiveClick();
		}
	});
	
	$HUI.checkbox("#checkReceive", {
		onCheckChange: function (e, value) {
			receCheckChange(value);
		}
	});
	
	$HUI.combobox("#userCombo", {
		panelHeight: 180,
		rowStyle: 'checkbox',
		multiple: true,
		url: $URL + "?ClassName=web.DHCIPBillDailyCollect&QueryName=FindIPCashier&ResultSetType=array",
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	getStDate();
}

function receCheckChange(checked) {
	if (checked) {
		disableById("btnReceive");
		$(".layout:first").layout("add", {
			region: 'east',
			width: 340,
			title: '接收记录',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			collapsible: false
		}).layout("panel", "east").append("<ul id='rece-tree'></ul>");
		initReceTree();
	}else {
		enableById("btnReceive");
		$(".layout:first").layout("remove", "east");
		setValueById("receId", "");    //取消勾选时，将结账Id赋空
		getStDate();
	}
}

/**
* 取开始日期
*/
function getStDate() {
	var defDate = getDefStDate(-1);
	$(".datebox-f").datebox("setValue", defDate);
}

/**
* 接收记录树
*/
function initReceTree() {
	GV.ReceTree = $HUI.tree("#rece-tree", {
		fit: true,
		url: $URL + "?ClassName=web.DHCIPBillDailyCollect&MethodName=BuildReceiveTree&ResultSetType=array&guser=" + PUBLIC_CONSTANT.SESSION.USERID,
		animate: true,
		autoNodeHeight: true,
		formatter: function(node) {
			if (node.children) {
				return node.text;
			}else {
				return "<div>"
					+ "<span data-id='" + node.id + "' class='icon-cancel' style='display:block;width:16px;height:16px;position:absolute;right:10px;top:5px;'></span>"
					+ "<div style='height:20px;line-height:20px;color:gray'>" + node.attributes.stDate + "—" + node.attributes.endDate + "</div>"
					+ "<div style='height:20px;line-height:20px;'>" + node.text + "</div>"
					+ "</div>";
			}
		},
		onSelect: function (node) {
			if ($(this).tree("isLeaf", node.target)) {
				scanReceList(node.id);
			}
		},
		onLoadSuccess: function (node, data) {
			$(".tree-title span[data-id]").popover({
				content: '取消接收',
				trigger: 'hover'
			});
		}
	});
	
	$("#rece-tree").on("click", ".tree-title span[data-id]", function(){
		var id = $(this).data('id');
		var node = GV.ReceTree.find(id);
		cancelReceive(node.id);
	});
}

function scanReceList(receId) {
	setValueById("receId", receId);
	var node = GV.ReceTree.find(receId);
	$("#stDate").datebox("setValue", node.attributes.stDate);
	$("#endDate").datebox("setValue", node.attributes.endDate);
	loadSelDetails();
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-14
 * Description: 组长接收
 */
function receiveClick() {
	var iframe = $('#tabMain')[0].contentWindow.$('#iframe_ipbillCollectList')[0].contentWindow;
	if (!iframe) {
		return;
	}
	var footIdStr = iframe.getCheckedFootIdStr();
	if (!footIdStr) {
		return;
	}
	$.messager.confirm("确认", "是否确认接收?", function (r) {
		if (r) {
			$.cm({
				ClassName: "web.DHCIPBillDailyCollect",
				MethodName: "Receive",
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				footIdStr: footIdStr
			}, function (jsonData) {
				$.messager.alert("提示", jsonData.msg, "info");
				if (jsonData.success == 0) {
					setValueById("receId", jsonData.rowId);  //接收Id
					loadSelDetails();
				}
			});
		}
	});
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-14
 * Description: 取消接收
 */
function cancelReceive(receId) {
	if (!receId) {
		return;
	}
	$.messager.confirm("确认", "是否确认取消?", function (r) {
		if (r) {
			$.cm({
				ClassName: "web.DHCIPBillDailyCollect",
				MethodName: "CancelReceive",
				receId: receId
			}, function (jsonData) {
				$.messager.alert("提示", jsonData.msg, "info");
				if (jsonData.success == 0) {
					setValueById("receId", "");
					if ($("#rece-tree").length > 0) {
						$("#rece-tree").tree("reload");
					}
					loadSelDetails();
				}
			});
		}
	});
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-15
 * Description: 加载iframe页签明细内容
 */
function loadSelDetails() {
	var iframe = $('#tabMain')[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}