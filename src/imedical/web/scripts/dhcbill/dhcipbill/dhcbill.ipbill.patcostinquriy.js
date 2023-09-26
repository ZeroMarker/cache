/**
 * FileName: dhcbill.ipbill.patcostinquriy.js
 * Anchor: ZhYW
 * Date: 2018-06-27
 * Description: ���ҷ��ò�ѯ
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
 * ����tabs
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
					columns: [[{field: 'TCateDesc', title: 'ҽ������', width: 150},
							   {field: 'TCateAmt', title: '���', align: 'right', width: 150, formatter: formatAmt},
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
						if (rowData.TCateDesc != '�ϼ�') {
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
* ҽ�����б�
*/ 
function initOrdItmList() {
	$HUI.datagrid('#ordItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		title: 'ҽ�����б�',
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		toolbar: [],
		data: [],
		columns: [[{title: 'ҽ������', field: 'TCateDesc', width: 80},
				   {title: 'ҽ������', field: 'TArcimDesc', width: 180},
				   {title: '��λ', field: 'TUom', width: 60},
				   {title: '����', field: 'TPrice', align: 'right', width: 100},
				   {title: '����', field: 'TQty', width: 80},
				   {title: '���', field: 'TAmt', align: 'right', width: 100, formatter: formatAmt},
				   {title: 'ҽ����ID', field: 'TARCIM', width: 100},
				   {title: 'ҽ��ID', field: 'TOEORI', hidden: true}
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
* ִ�м�¼�б�
*/
function initOEItmList() {
	$HUI.datagrid('#oeItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		title: 'ִ�м�¼�б�',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 15,
		pageList: [15, 20, 25, 30],
		toolbar: [],
		data: [],
		columns: [[{field: 'TordPrior', title: 'ҽ������', width: 80},
				   {field: 'TExStDate', title: 'Ҫ��ִ��ʱ��', width: 160,
				   	formatter: function (value, row, index) {
						return value + " " + row.TExStTime;
					}
				   },
				   {field: 'DateExecuted', title: 'ִ��ʱ��', width: 160,
				    formatter: function (value, row, index) {
						return value + " " + row.TimeExecuted;
					}
				   },
				   {field: 'UserAddDesc', title: '��ҽ����', width: 80},
				   {field: 'OrderStatus', title: '״̬', width: 80},
				   {field: 'CareProvDesc', title: '������', width: 80},
				   {field: 'UserDeptDesc', title: '��������', width: 100},
				   {field: 'TBillFlag', title: '�˵�״̬', width: 80},
				   {field: 'TPatamt', title: '���', width: 100, align: 'right', formatter: formatAmt},
				   {field: 'TCollectQty', title: '��ҩ����', width: 70},
				   {field: 'TRefundQty', title: '��ҩ����', width: 70},
				   {field: 'TPBORowID', title: '�˵�ҽ��ID', width: 100},
				   {field: 'TOrdExcRowID', title: 'ִ�м�¼ID', width: 100}
			]]
	});
}

/**
 * ���¼���ҽ��grid
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
 * ���¼���ִ�м�¼grid
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
 * ��ѯ��ť����¼�
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
