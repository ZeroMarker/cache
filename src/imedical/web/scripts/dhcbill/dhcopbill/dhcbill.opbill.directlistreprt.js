/**
 * FileName: dhcbill.opbill.directlistreprt.js
 * Author: ZhYW
 * Date: 2019-12-13
 * Description: 补打导诊单
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
	GV.OEItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		striped: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
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
	var invRowId = row.TINVRowid;
	var tabFlag = row.TabFlag;
	var isStayInv = row.IsStayInv;
	if (isStayInv == "Y") {
		$.messager.popover({msg: '急诊留观结算记录不能打印导诊单', type: 'info'});
		return;
	}
	switch (tabFlag) {
	case "PRT":
		directPrint(invRowId);
		break;
	case "API":
		$.messager.confirm("确认", "此发票为集中打印发票，是否确认打印?", function(r) {
			if (!r) {
				return;
			}
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
		});
		break;
	default:
	}
}

function clearOrdItmList() {
	GV.OEItmList.options().pageNumber = 1;   //跳转到第一页
	GV.OEItmList.loadData({total: 0, rows: []});
}
