/**
 * FileName: dhcbill.opbill.directlistreprt.js
 * Anchor: ZhYW
 * Date: 2019-12-13
 * Description: 补打导诊单
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
		checkOnSelect: false, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		pagination: true,
		rownumbers: true,
		pageSize: 30,
		idField: 'TOrderRowid',
		toolbar: [],
		data: [],
		columns: [[{title: '医嘱', field: 'TOrder', width: 180},
				   {title: '金额', field: 'TOrderSum', align: 'right', width: 100},
				   {title: '数量', field: 'TOrderQty', width: 80},
				   {title: '接收科室', field: 'TRecloc', width: 120},
				   {title: '已退药数量', field: 'TReturnQty', width: 100},
				   {title: '医嘱ID', field: 'TOrderRowid', width: 80}
			]]
	});
}

function loadOrdItmList(row) {
	var queryParams = {
		ClassName: "web.DHCOPBILLOrdDirectList",
		QueryName: "QueryAdmOrder",
		ReceipID: row.TINVRowid,
		sFlag: row.TabFlag
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
	var invRowId = row.TINVRowid;
	var tabFlag = row.TabFlag;
	switch (tabFlag) {
	case "PRT":
		directPrint(invRowId);
		break;
	case "API":
		$.messager.confirm("确认", "此发票为集中打印发票，是否确认打印?", function(r) {
			if (r) {
				$.m({
					ClassName: "web.DHCOPBILLOrdDirectList",
					MethodName: "GetPrtRowId",
					apiRowId: invRowId
				}, function(rtn) {
					var myAry = rtn.split("^");
					$.each(myAry, function(index, item) {
						directPrint(item);
					});
				});
			}
		});
		break;
	default:
	}
}

function clearOrdItmList() {
	$HUI.datagrid("#ordItmList").load({
		ClassName: "web.DHCOPBILLOrdDirectList",
		QueryName: "QueryAdmOrder",
		ReceipID: "",
		sFlag: ""
	});
}
