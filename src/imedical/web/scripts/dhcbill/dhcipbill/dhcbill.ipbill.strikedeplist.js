/**
 * FileName: dhcbill.ipbill.strikedeplist.js
 * Anchor: ZhYW
 * Date: 2019-12-05
 * Description: 已冲退预交金查询
 */

var GV = {};

$(function () {
	initQueryMenu();
	initStrikeDepList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadStrikeDepList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFDepositSearch&QueryName=FindIPCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initStrikeDepList() {
	$HUI.datagrid("#strikeDepList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		columns:[[{title: '发票号', field: 'TInvNo', width: 100},
				  {title: '病案号', field: 'TMedicareCode', width: 100},
				  {title: '患者姓名', field: 'TPatName', width: 100},
				  {title: '收据号', field: 'TRcptNo', width: 100},
				  {title: '就诊科室', field: 'TLocDesc', width: 100},
				  {title: '收费时间', field: 'TPrintDate', width: 150,
					formatter: function (value, row, index) {
						return value + " " + row.TPrintTime;
					}
				  },
				  {title: '金额', field: 'TPayAmt', align: 'right', width: 100},
				  {title: '支付方式', field: 'TPayModeDesc', width: 150},
				  {title: '状态', field: 'TPrtStatus', width: 100},
				  {title: '操作员', field: 'TUserName', width: 100},
				  {title: '冲账日期', field: 'TPrtDate', width: 100},
				  {title: '结算操作员', field: 'TInvuserN', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFDepositSearch",
			QueryName: "FindDepositByStrike",
			StDate: getValueById("stDate"),
			EndDate: getValueById("endDate"),
			Guser: getValueById("guser") || "",
			flag: getValueById("isHandin") ? 1 : 0,
			HospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}
	});
}

function loadStrikeDepList() {
	var queryParams = {
		ClassName: "web.UDHCJFDepositSearch",
		QueryName: "FindDepositByStrike",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		Guser: getValueById("guser") || "",
		flag: getValueById("isHandin") ? 1 : 0,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("strikeDepList", queryParams);
}

/**
* 导出
*/
function exportClick() {
	var fileName = "DHCBILL-IPBILL-YCTYJJMX.rpx" + "&StDate=" + getValueById("stDate") + "&EndDate=" + getValueById("endDate");
	fileName += "&Guser=" + (getValueById("guser") || "") + "&flag=" + (getValueById("isHandin") ? 1 : 0);
	fileName += "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}