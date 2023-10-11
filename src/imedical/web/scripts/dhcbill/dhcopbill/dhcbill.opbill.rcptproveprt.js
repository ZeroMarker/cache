/**
 * FileName: dhcbill.opbill.rcptproveprt.js
 * Author: ZhYW
 * Date: 2019-12-13
 * Description: 门诊收据证明打印
 */

$(function () {
	$(document).keydown(function (e) {
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
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 119: //F8
		e.preventDefault();
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
		className: "web.UDHCOEORDOP1",
		queryName: "ReadOEByINVRowID",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TOrder") {
						cm[i].width = 130;
					}
					if (cm[i].field == "TOrderQty") {
						cm[i].width = 60;
					}
					if (cm[i].field == "TPackUOM") {
						cm[i].width = 70;
					}
					if (cm[i].field == "TOEORIStartTime") {
						cm[i].width = 150;
					}
					if (cm[i].field == "TOEORIPresNo") {
						cm[i].width = 120;
					}
					if (cm[i].field == "TOEORILabNo") {
						cm[i].width = 120;
					}
				}
			}
		}
	});
}

function loadOrdItmList(row) {
	var queryParams = {
		ClassName: "web.UDHCOEORDOP1",
		QueryName: "ReadOEByINVRowID",
		invRowId: row.TINVRowid,
		invType: row.TabFlag
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
	var fileName = "DHCBILL-OPBILL-SJZM.rpx" + "&InvRowID=" + row.TINVRowid + "&PRTFlag=" + row.TabFlag;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function clearOrdItmList() {
	$HUI.datagrid("#ordItmList").options().pageNumber = 1;   //跳转到第一页
	$HUI.datagrid("#ordItmList").loadData({total: 0, rows: []});
}
