/**
 * FileName: dhcbill.opbill.retinv.js
 * Anchor: ZhYW
 * Date: 2019-12-12
 * Description: 门诊退费收据查询
 */

var GV = {};

$(function () {
	initQueryMenu();
	initRetInvList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadRetInvList();
		}
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPCashReturnTicket&QueryName=FindOPCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initRetInvList() {
	$HUI.datagrid("#retInvList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns:[[{title: '导航号', field: 'prtRowId', width: 80,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick=\"orderDetail(\'" + value + "\')\">" + value + "</a>";
						}
					}
				  },
				  {title: '退费总额', field: 'refAcount', align: 'right', width: 100},
				  {title: '退费日期', field: 'date', width: 120},
				  {title: '原票据号', field: 'initInvNo', width: 120},
				  {title: '操作员', field: 'userName', width: 100},
				  {title: '退费原因', field: 'refundReason', width: 150},
				  {title: '结账时间', field: 'handinDate', width: 160,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.handinTime;
						}
					}
				  },
				  {title: '登记号', field: 'ipNo', width: 110},
				  {title: '患者姓名', field: 'papmiName', width: 110},
				  {title: '审核人', field: 'refundUser', width: 100},
				  {title: '审核日期', field: 'refundDate', width: 100}
			]]
	});
}

function loadRetInvList() {
	var queryParams = {
		ClassName: "web.DHCOPCashReturnTicket",
		QueryName: "FindInfo",
		startDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		guser: getValueById("guser") || "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("retInvList", queryParams);
}

/**
* 医嘱明细
*/
function orderDetail(prtRowId) {
	$("#ordItmDlg").show().dialog({
		width: 630,
		height: 450,
		iconCls: 'icon-w-list',
		title: '医嘱明细',
		draggable: false,
		modal: true,
		onBeforeOpen: function() {
			$HUI.datagrid("#ordItmList", {
				fit: true,
				striped: true,
				bodyCls: 'panel-body-gray',
				singleSelect: true,
				rownumbers: true,
				pagination: true,
				pageSize: 10,
				columns:[[{title: '医嘱名称', field: 'ArcimDesc', width: 220},
						  {title: '操作员', field: 'RefUser', width: 120},
						  {title: '退费日期', field: 'RefDate', width: 120},
						  {title: '退费金额', field: 'RefOrdAmt', width: 100, align: 'right'}
					]],
				url: $URL,
				queryParams: {
					ClassName: "web.DHCOPCashReturnTicket",
					QueryName: "FindDetail",
					prtRowId: prtRowId
				}
			});
		}
	});
}