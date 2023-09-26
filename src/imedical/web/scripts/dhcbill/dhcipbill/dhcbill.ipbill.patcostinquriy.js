/**
 * FileName: dhcbill.ipbill.patcostinquriy.js
 * Anchor: ZhYW
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
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			find_Click();
		}
	});
}

/**
 * 加载tabs
 * @method initTabs
 * @author ZhYW
 */
function initTabs() {
	$.m({
		ClassName: 'web.DHCIPBillPATCostInquriy',
		MethodName: 'GetTransLoc',
		episodeId: GV.EpisodeID
	}, function (rtn) {
		var myAry = rtn.split('#');
		$.each(myAry, function (index, itm) {
			var deptId = itm.split('^')[0];
			var deptDesc = itm.split('^')[1];
			if (!$('#tabItem').tabs('exists', deptDesc)) {
				$('#tabItem').tabs('add', {
					title: deptDesc,
					id: deptId.replace('.', 'c'),
					closable: false,
					content: '<table id=\"' + deptId.replace('.', 'c') + 'table' + '\"></table>'
				});
				$HUI.datagrid('#' + deptId.replace('.', 'c') + 'table', {
					fit: true,
					striped: true,
					border: false,
					singleSelect: true,
					url: $URL,
					toolbar: [],
					pageSize: 999999999,
					columns: [[{field: 'TCateDesc', title: '医嘱大类', width: 150},
							   {field: 'TCateAmt', title: '金额', align: 'right', width: 150, formatter: formatAmt},
							   {field: 'TCateId', title: 'TCateId', hidden: true}
						]],
					queryParams: {
						ClassName: 'web.DHCIPBillPATCostInquriy',
						QueryName: 'FindBillOrderDetail',
						billNo: GV.BillRowID,
						stDate: getValueById("stDate"),
						endate: getValueById("endDate"),
						deptIdStr: deptId,
						episodeId: GV.EpisodeID
					},
					onSelect: function (rowIndex, rowData) {
						if (rowData.TCateDesc != '合计') {
							loadOrdItmList(rowData);
						}
					}
				});
			}
			$('#tabItem').tabs({
				selected: 1
			});
		});
	});
}

/**
* 医嘱项列表
*/ 
function initOrdItmList() {
	$HUI.datagrid('#ordItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		title: '医嘱项列表',
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		toolbar: [],
		data: [],
		columns: [[{title: '医嘱大类', field: 'TCateDesc', width: 80},
				   {title: '医嘱名称', field: 'TArcimDesc', width: 180},
				   {title: '单位', field: 'TUom', width: 60},
				   {title: '单价', field: 'TPrice', align: 'right', width: 100},
				   {title: '数量', field: 'TQty', width: 80},
				   {title: '金额', field: 'TAmt', align: 'right', width: 100, formatter: formatAmt},
				   {title: '医嘱项ID', field: 'TARCIM', width: 100},
				   {title: '医嘱ID', field: 'TOEORI', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$("#oeItmList").datagrid("loadData", {
				total: 0,
				rows: []
			});
		},
		onSelect: function (rowIndex, rowData) {
			loadOEItmList(rowData);
		}
	});
}

/**
* 执行记录列表
*/
function initOEItmList() {
	$HUI.datagrid('#oeItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		title: '执行记录列表',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		toolbar: [],
		data: [],
		columns: [[{field: 'TordPrior', title: '医嘱类型', width: 80},
				   {field: 'TExStDate', title: '要求执行时间', width: 160,
				   	formatter: function (value, row, index) {
						return value + " " + row.TExStTime;
					}
				   },
				   {field: 'DateExecuted', title: '执行时间', width: 160,
				    formatter: function (value, row, index) {
						return value + " " + row.TimeExecuted;
					}
				   },
				   {field: 'UserAddDesc', title: '开医嘱人', width: 80},
				   {field: 'OrderStatus', title: '状态', width: 80},
				   {field: 'CareProvDesc', title: '处理人', width: 80},
				   {field: 'UserDeptDesc', title: '开单科室', width: 100},
				   {field: 'TBillFlag', title: '账单状态', width: 80},
				   {field: 'TPatamt', title: '金额', width: 100, align: 'right', formatter: formatAmt},
				   {field: 'TCollectQty', title: '发药数量', width: 70},
				   {field: 'TRefundQty', title: '退药数量', width: 70},
				   {field: 'TPBORowID', title: '账单医嘱ID', width: 100},
				   {field: 'TOrdExcRowID', title: '执行记录ID', width: 100}
			]]
	});
}

/**
 * 重新加载医嘱grid
 * @method loadOrdItmList
 * @author ZhYW
 */
function loadOrdItmList(rowData) {
	if (!rowData) {
		return;
	}
	var itemCateId = rowData.TCateId;
	var tabObj = $('#tabItem').tabs('getSelected');
	var tabId = tabObj.panel('options').id;
	var deptIdStr = tabId.replace('c', '.');
	var queryParams = {
		ClassName: 'web.DHCIPBillPATCostInquriy',
		QueryName: 'FindIPPatOrderDetail',
		billNo: GV.BillRowID,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		deptIdStr: deptIdStr,
		episodeId: GV.EpisodeID,
		itemCateId: itemCateId
	};
	loadDataGridStore('ordItmList', queryParams);
}

/**
 * 重新加载执行记录grid
 * @method loadOEItmList
 * @author ZhYW
 */
function loadOEItmList(rowData) {
	if (!rowData) {
		return;
	}
	var ordItmStr = rowData.TOEORI;
	var queryParams = {
		ClassName: 'web.DHCIPBillPATCostInquriy',
		QueryName: 'FindOrdExecInfo',
		ordItmStr: ordItmStr,
		billNo: GV.BillRowID
	};
	loadDataGridStore('oeItmList', queryParams);
}

/**
 * 查询按钮点击事件
 * @method find_Click
 * @author ZhYW
 */
function find_Click() {
	var tabs = $('#tabItem').tabs('tabs');
	$.each(tabs, function (index, tab) {
		if (index > 0) {
			var tabId = tab.panel('options').id;
			var deptIdStr = tabId.replace('c', '.');
			$('#' + tabId + 'table').datagrid('load', {
				ClassName: 'web.DHCIPBillPATCostInquriy',
				QueryName: 'FindBillOrderDetail',
				billNo: GV.BillRowID,
				stDate: getValueById("stDate"),
				endDate: getValueById("endDate"),
				deptIdStr: deptIdStr,
				episodeId: GV.EpisodeID
			});
		}
	});
}
