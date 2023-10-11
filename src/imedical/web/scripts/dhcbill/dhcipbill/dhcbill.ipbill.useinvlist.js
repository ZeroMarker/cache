/**
 * FileName: dhcbill.ipbill.useinvlist.js
 * Author: ZhYW
 * Date: 2019-12-05
 * Description: 收费员已使用发票查询
 */

$(function () {
	initQueryMenu();
	initUseInvList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadUseInvList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//发票类型
	$HUI.combobox("#rcptType", {
		panelHeight: 'auto',
		data: [{value: 'I', text: $g('住院发票'), selected: true},
		       {value: 'O', text: $g('门诊发票')}
		],
		valueField: 'value',
		textField: 'text',
		editable: false
	});
}

function initUseInvList() {
	GV.UseInvList = $HUI.datagrid("#useInvList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFInvprt",
		queryName: "Findinvsum",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TinvNo", "Tinvnozf"]) != -1) {
					cm[i].showTip = true;
				}
				if (!cm[i].width) {
					cm[i].width = 130;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFInvprt",
			QueryName: "Findinvsum",
			type: getValueById("rcptType"),
			stdate: getValueById("stDate"),
			enddate: getValueById("endDate"),
			stnum: getValueById("stNo"),
			endnum: getValueById("endNo"),
			Exp: getValueById("title") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
		},
		rowStyler: function (index, row) {
			if (row.TCashier.indexOf($g("合计")) != -1) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadUseInvList() {
	var queryParams = {
		ClassName: "web.UDHCJFInvprt",
		QueryName: "Findinvsum",
		type: getValueById("rcptType"),
		stdate: getValueById("stDate"),
		enddate: getValueById("endDate"),
		stnum: getValueById("stNo"),
		endnum: getValueById("endNo"),
		Exp: getValueById("title") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("useInvList", queryParams);
}

/**
* 清屏
*/
function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f:not(#rcptType)").combobox("clear");
	$("#rcptType").combobox("setValue", "I");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.UseInvList.options().pageNumber = 1;   //跳转到第一页
	GV.UseInvList.loadData({total: 0, rows: []});
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-YSYFPMX.rpx" + "&type=" + getValueById("rcptType");
	fileName += "&stdate=" + getValueById("stDate") + "&enddate=" + getValueById("endDate");
	fileName += "&stnum=" + getValueById("stNo") + "&endnum=" + getValueById("endNo") + "&Exp=" + getValueById("title") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}