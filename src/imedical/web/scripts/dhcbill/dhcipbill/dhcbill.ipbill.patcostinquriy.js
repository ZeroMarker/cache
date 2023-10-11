/**
 * FileName: dhcbill.ipbill.patcostinquriy.js
 * Author: ZhYW
 * Date: 2018-06-27
 * Description: 科室费用查询
 */

$(function () {
	getPatInfoByAdm(GV.EpisodeID); //dhcbill.inpatient.banner.csp
	initQueryMenu();
	initOrdItmList();
	initOEItmList();
	initTabs();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			findClick();
		}
	});

	//开单科室, 医嘱接收科室
	$HUI.combobox("#userDept, #recDept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
}

function initTabs() {
	$.cm({
		ClassName: "web.DHCIPBillPATCostInquriy",
		QueryName: "QryAdmTransLoc",
		ResultSetType: "array",
		adm: GV.EpisodeID
	}, function (data) {
		data.forEach(function(item) {
			var deptId = item.id;
			var dept = item.text;
			if ($("#tabItem").tabs("exists", item.text)) {
				return true;
			}
			var dgId = deptId + "-List";
			$("#tabItem").tabs("add", {
				title: dept,
				id: deptId,
				closable: false,
				content: "<table id=\"" + dgId + "\"></table>"
			});
			$HUI.datagrid("#" + dgId, {
				fit: true,
				border: false,
				singleSelect: true,
				url: $URL,
				toolbar: [],
				pageSize: 999999999,
				className: "web.DHCIPBillPATCostInquriy",
				queryName: "FindBillCateFee",
				onColumnsLoad: function(cm) {
					for (var i = (cm.length - 1); i >= 0; i--) {
						if (cm[i].field == "TCateId") {
							cm[i].hidden = true;
						}
						if (!cm[i].width) {
							cm[i].width = 150;
						}
					}
				},
				queryParams: {
					ClassName: "web.DHCIPBillPATCostInquriy",
					QueryName: "FindBillCateFee",
					billId: GV.BillRowID,
					stDate: getValueById("stDate"),
					endate: getValueById("endDate"),
					ordDeptId: deptId,
					episodeId: GV.EpisodeID,
					userDeptId: getValueById("userDept"),
					recDeptId: getValueById("recDept")
				},
				onSelect: function (index, row) {
					if (row.TCateId != "") {
						loadOrdItmList(row);
					}
				}
			});
		});

		if (data.length > 0) {
			$("#tabItem").tabs({
				selected: 1
			});
		}
	});
}

/**
* 医嘱项列表
*/ 
function initOrdItmList() {
	$HUI.datagrid("#ordItmList", {
		fit: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		title: '医嘱项列表',
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [],
		className: "web.DHCIPBillPATCostInquriy",
		queryName: "FindOrderDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (cm[i].field == "TOEORI") {
					cm[i].hidden = true;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TArcimDesc") {
						cm[i].width = 180;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$("#oeItmList").datagrid("loadData", {
				total: 0,
				rows: []
			});
		},
		onSelect: function (index, row) {
			loadOEItmList(row);
		}
	});
}

/**
* 执行记录列表
*/
function initOEItmList() {
	$HUI.datagrid("#oeItmList", {
		fit: true,
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		title: '执行记录列表',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [],
		className: "web.DHCIPBillPATCostInquriy",
		queryName: "FindOrdExecInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TExStDate", "TExecDate", "TConfFlag"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TExStTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TExStDate + " " + value;
					}
				}
				if (cm[i].field == "TExecTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TExecDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 80;
					if ($.inArray(cm[i].field, ["TExStTime", "TExecTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

/**
 * 重新加载医嘱grid
 * @method loadOrdItmList
 * @author ZhYW
 */
function loadOrdItmList(row) {
	if (!row) {
		return;
	}
	var itemCateId = row.TCateId;
	var tabObj = $("#tabItem").tabs("getSelected");
	var deptId = tabObj.panel("options").id;
	var queryParams = {
		ClassName: "web.DHCIPBillPATCostInquriy",
		QueryName: "FindOrderDetail",
		billId: GV.BillRowID,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		ordDeptId: deptId,
		episodeId: GV.EpisodeID,
		itemCateId: itemCateId,
		userDeptId: getValueById("userDept"),
		recDeptId: getValueById("recDept")
	};
	loadDataGridStore("ordItmList", queryParams);
}

/**
 * 重新加载执行记录grid
 * @method loadOEItmList
 * @author ZhYW
 */
function loadOEItmList(row) {
	if (!row) {
		return;
	}
	var queryParams = {
		ClassName: "web.DHCIPBillPATCostInquriy",
		QueryName: "FindOrdExecInfo",
		ordItmStr: row.TOEORI,
		billId: GV.BillRowID
	};
	loadDataGridStore("oeItmList", queryParams);
}

/**
 * 查询按钮点击事件
 * @method findClick
 * @author ZhYW
 */
function findClick() {
	$.each($("#tabItem").tabs("tabs"), function (index, tab) {
		if (index > 0) {
			var deptId = tab.panel("options").id;
			$("#" + deptId + "-List").datagrid("load", {
				ClassName: "web.DHCIPBillPATCostInquriy",
				QueryName: "FindBillCateFee",
				billId: GV.BillRowID,
				stDate: getValueById("stDate"),
				endDate: getValueById("endDate"),
				ordDeptId: deptId,
				episodeId: GV.EpisodeID,
				userDeptId: getValueById("userDept"),
				recDeptId: getValueById("recDept")
			});
		}
	});
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	$("#InpatListDiv").data("AutoOpen", 0);
	GV.EpisodeID = episodeId;
	GV.BillRowID = "";
	getPatInfoByAdm(GV.EpisodeID);
	closeTabs();
	initTabs();
}

/**
 * 清除除第一个页签外的所有页签
 */
function closeTabs() {
	var tabs = $("#tabItem").tabs("tabs");
    for(var i = 0, len = tabs.length; i < len; i++) {
        //因为tabs删除之后会重新对其元素进行排序，所以在删除方法时候只需要进行删除1即可(因为我想保留第一个元素，如果不想保留就改成0即可)
   		$("#tabItem").tabs("close", 1);
    }
}