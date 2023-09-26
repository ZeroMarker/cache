/**
 * FileName: dhcbill.itemlist.js
 * Anchor: ZhYW
 * Date: 2019-03-18
 * Description: 收费项目明细
 */

$(function () {
	initItmList();
	loadItmList();
});

function initItmList() {
	$HUI.datagrid("#itmList", {
		fit: true,
		striped: true,
		bodyCls: 'panel-header-gray',
		fitColumns: true,
		autoRowHeight: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 40, 60, 80],
		columns:[[{title: '收费项', field: 'Titm', width: 180},
				  {title: '计费时间', field: 'Tdate', width: 150,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.Ttime;
						}
					}
				  },
				  {title: '数量', field: 'Tqty', width: 70},
				  {title: '单价', field: 'Tunitprice', align: 'right', width: 70},
				  {title: '计费状态', field: 'Tbillflag', width: 70},
				  {title: '总费用', field: 'Tprice', align: 'right', width: 100},
				  {title: '折扣费用', field: 'Tdiscount', align: 'right', width: 100},
				  {title: '记帐费用', field: 'Tpayorshare', align: 'right', width: 100},
				  {title: '自付费用', field: 'Tpatshare', align: 'right', width: 100},
				  {title: '账单时间', field: 'Tupddate', width: 150,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.Tupdtime;
						}
					}
				  },
				  {title: 'PBDRowID', field: 'Trowid', width: 100},
			]]
	});
}

/**
 * 加载收费项Grid数据
 */
function loadItmList() {
	var queryParams = {
		ClassName: "web.UDHCJFITM",
		QueryName: "FindItmDetail",
		BillNo: getParam("BillNo")
	}
	loadDataGridStore("itmList", queryParams);
}
