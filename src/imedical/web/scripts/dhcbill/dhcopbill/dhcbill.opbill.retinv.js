/**
 * FileName: dhcbill.opbill.retinv.js
 * Author: ZhYW
 * Date: 2019-12-12
 * Description: 门诊退费收据查询
 */

$(function () {
	initQueryMenu();
	initRetInvList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadRetInvList();
		}
	});
	
	//操作员
	$HUI.combobox("#user", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.invType = "O";
		}
	});
}

function initRetInvList() {
	$HUI.datagrid("#refInvList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.DHCOPCashReturnTicket",
		queryName: "QryRefInvList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["RefDate", "HandinDate", "RefAuditDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "PrtRowId") {
					cm[i].formatter = function(value, row, index) {
				   		if (value) {
							return "<a href='javascript:;' onclick=\"orderDetail(\'" + value + "\')\">" + value + "</a>";
						}
					}
				}
				if (cm[i].field == "RefTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.RefDate + " " + value;
					}
				}
				if (cm[i].field == "HandinTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.HandinDate + " " + value;
					}
				}
				if (cm[i].field == "RefAuditTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.RefAuditDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["RefTime", "HandinTime", "RefAuditTime"]) != -1) {
						cm[i].width = 150;
					}
				}
			}
		}
	});
}

function loadRetInvList() {
	var queryParams = {
		ClassName: "web.DHCOPCashReturnTicket",
		QueryName: "QryRefInvList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userId: getValueById("user") || "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("refInvList", queryParams);
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
				className: "web.DHCOPCashReturnTicket",
				queryName: "FindDetail",
				onColumnsLoad: function(cm) {
					for (var i = (cm.length - 1); i >= 0; i--) {
						if (cm[i].field == "RefDate") {
							cm.splice(i, 1);
							continue;
						}
						if (cm[i].field == "RefTime") {
							cm[i].formatter = function(value, row, index) {
						   		return row.RefDate + " " + value;
							}
						}
						if (!cm[i].width) {
							cm[i].width = 100;
							if (cm[i].field == "ArcimDesc") {
								cm[i].width = 200;
							}
							if (cm[i].field == "RefTime") {
								cm[i].width = 150;
							}
						}
					}
				},
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