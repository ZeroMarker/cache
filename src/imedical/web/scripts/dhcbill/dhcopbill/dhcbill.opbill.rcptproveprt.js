/**
 * FileName: dhcbill.opbill.rcptproveprt.js
 * Anchor: ZhYW
 * Date: 2019-12-13
 * Description: 门诊收据证明打印
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initInvList();
	initOrdItmList();
});

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		readHFMagCardClick();
		break;
	case 118: //F7
		clearClick();
		break;
	case 119: //F8
		loadInvList();
		break;
	default:
	}
}

function initOrdItmList() {
	$HUI.datagrid("#ordItmList", {
		fit: true,
		striped: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 30,
		toolbar: [],
		data: [],
		columns: [[{title: '医嘱', field: 'TOrder', width: 180},
				   {title: '金额', field: 'TOrderSum', align: 'right', width: 100},
				   {title: '数量', field: 'TOrderQty', width: 80},
				   {title: '接收科室', field: 'TRecloc', width: 100},
				   {title: '就诊医生', field: 'TAdmDoctorName', width: 100},
				   {title: '医嘱状态', field: 'TStatDesc', width: 80},
				   {title: '开医嘱人', field: 'TCareProDesc', width: 100},
				   {title: '折扣金额', field: 'TDiscSum', align: 'right', width: 100},
				   {title: '记账金额', field: 'TPayorSum', align: 'right', width: 100},
				   {title: '医嘱开始时间', field: 'TOEORIStartTime', width: 150},
				   {title: '处方号', field: 'TOEORIPresNo', width: 120},
				   {title: '检验标本号', field: 'TOEORILabNo', width: 120},
				   {title: '医嘱ID', field: 'TOrderRowid', width: 80}
			]]
	});
}

function loadOrdItmList(row) {
	var queryParams = {
		ClassName: "web.UDHCOEORDOP1",
		QueryName: "ReadOEByINVRowID",
		invRowId: row.TINVRowid,
		invType: row.TabFlag,
		rows: 999999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

function selectInvListRow(row) {
	enableById("btn-print");
	loadOrdItmList(row);
}

function unSelectInvListRow() {
	disableById("btn-print");
	clearOrdItmList();
}

function printClick() {
	var row = $HUI.datagrid("#invList").getSelected();
	if (!row) {
		return;
	}
	var fileName = "DHCBILL-OPBILL-门诊收据证明.raq" + "&InvRowID=" + row.TINVRowid + "&PRTFlag=" + row.TabFlag;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function clearOrdItmList() {
	$HUI.datagrid("#ordItmList").load({
		ClassName: "web.UDHCOEORDOP1",
		QueryName: "ReadOEByINVRowID",
		invRowId: "",
		invType: ""
	});
}
