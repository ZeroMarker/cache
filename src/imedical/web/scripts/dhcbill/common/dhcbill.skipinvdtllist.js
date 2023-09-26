/**
 * FileName: dhcbill.skipinvdtllist.js
 * Anchor: ZhYW
 * Date: 2018-06-28
 * Description: 跳号查询
 */

$(function () {
	initQueryMenu();
	initListGrid();
});

var initQueryMenu = function () {
	var defDate = getDefStDate(0);
	setValueById('menu-stDate', defDate);
	setValueById('menu-endDate', defDate);

	$HUI.linkbutton('#btnSearch', {
		onClick: function () {
			loadSkipInvList();
		}
	});
	
	$HUI.linkbutton('#btnPrint', {
		onClick: function () {
			printClick();
		}
	});
	
	$HUI.combobox('#menu-invType', {
		panelHeight: 'auto',
		data: [{id: 'OP', text: '门诊发票'},
			   {id: 'ID', text: '住院押金'},
			   {id: 'IP', text: '住院发票'}],
		editable: false,
		valueField: 'id',
		textField: 'text',
		value: (getParam('InvType').indexOf('O') == 0) ? 'OP' : 'IP',
		onSelect: function () {
			$('#menu-guser').combobox('clear').combobox('reload');
		}
	});
	
	$HUI.combobox('#menu-guser', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillSkipInvoice&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.rcptType = getValueById("menu-invType").charAt(0);
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

var initListGrid = function () {
	$HUI.datagrid('#skipInvList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '操作员', field: 'TUserName', width: 80},
		           {title: '作废时间', field: 'TDateTime', width: 120},
				   {title: '票据类型', field: 'TVoidType', width: 100},
				   {title: '作废票据号', field: 'TInvNo', width: 120},
				   {title: '作废原因', field: 'TReason', width: 220},
				   {title: '是否结算', field: 'THandinFlag', width: 80,
					formatter: function (value, row, index) {
						if (value) {
							return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
						}
					}
				}
			]]
	});
}

/**
 * 加载明细grid
 * @method loadSkipInvList
 * @author ZhYW
 */
function loadSkipInvList() {
	var queryParams = {
		ClassName: 'web.DHCBillSkipInvoice',
		QueryName: 'FindSkipInv',
		stDate: getValueById('menu-stDate'),
		endDate: getValueById('menu-endDate'),
		invType: getValueById('menu-invType'),
		guser: getValueById('menu-guser') || '',
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore('skipInvList', queryParams);
}

/**
 * 打印清单和汇总单
 * @method printClick
 * @author ZhYW
 */
function printClick() {
	var stDate = getValueById('menu-stDate');
	var endDate = getValueById('menu-endDate');
	var invType = getValueById('menu-invType');
	var guser = getValueById('menu-guser') || '';
	var fileName = 'DHCBILL-THPJMX.rpx' + '&stDate=' + stDate + '&endDate=' + endDate;
	fileName += '&invType=' + invType + '&guser=' + guser + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID;

	var maxWidth = $(window).width() || 1366;
	var maxHeight = $(window).height() || 550;

	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}