/**
 * FileName: dhcbill.ipbill.useinvlist.js
 * Anchor: ZhYW
 * Date: 2019-12-05
 * Description: 收费员已使用发票查询
 */

var GV = {};

$(function () {
	initQueryMenu();
	initUseInvList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
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
		data: [{value: 'I', text: '住院发票', selected: true},
		       {value: 'O', text: '门诊发票'}
		],
		valueField: 'value',
		textField: 'text',
		editable: false
	});
}

function initUseInvList() {
	$HUI.datagrid("#useInvList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		columns:[[{title: '收费员', field: 'TCashier', width: 100},
				  {title: '工号', field: 'TCasherNo', width: 100},
				  {title: '发票号段', field: 'TinvNo', width: 200},
				  {title: '张数', field: 'TinvNum', width: 100},
				  {title: '金额总计', field: 'Tinvsum', align: 'right', width: 100},
				  {title: '作废发票', field: 'Tinvnozf', width: 200},
				  {title: '作废张数', field: 'Tinvnumzf', width: 100},
				  {title: '当前票号', field: 'Tcurrno', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFInvprt",
			QueryName: "Findinvsum",
			grp: 3,
			type: getValueById("rcptType"),
			stdate: getValueById("stDate"),
			enddate: getValueById("endDate"),
			stnum: getValueById("stNo"),
			endnum: getValueById("endNo"),
			Exp: getValueById("title")
		},
		rowStyler: function (index, row) {
			if (row.TCashier.indexOf("合计") != -1) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadUseInvList() {
	var queryParams = {
		ClassName: "web.UDHCJFInvprt",
		QueryName: "Findinvsum",
		grp: 3,
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
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f:not(#rcptType)").combobox("clear");
	$("#rcptType").combobox("setValue", "I");
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	loadUseInvList();
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-YSYFPMX.rpx" + "&grp=3" + "&type=" + getValueById("rcptType");
	fileName += "&stdate=" + getValueById("stDate") + "&enddate=" + getValueById("endDate");
	fileName += "&stnum=" + getValueById("stNo") + "&endnum=" + getValueById("endNo") + "&Exp=" + getValueById("title") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}