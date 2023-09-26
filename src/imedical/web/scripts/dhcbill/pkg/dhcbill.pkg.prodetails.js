/**
 * FileName: dhcbill.pkg.prodetails.js
 * Anchor: ZhYW
 * Date: 2019-10-22
 * Description: 套餐产品明细
 */

var GV = {
	ProductId: getParam("ProductId")
};

$(function() {
	initProDetailList();
});

function initProDetailList() {
	$HUI.datagrid("#proDetailList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		fitColumns: true,
		autoRowHeight: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: [[{field:'ArcimDesc', title:'医嘱名称', width:120},
				   {field:'ItemPrice', title:'标准单价', width:90, align:'right'},
				   {field:'ActualPrice', title:'实售单价',width:90, align:'right'},
				   {field:'Qty', title:'数量', width:70},
				   {field:'TotalAmt', title:'金额', width:80, align:'right'},
				   {field:'SalesAmount', title:'实售金额', width:80, align:'right'},
				   {field:'PRODDayNum', title:'限制天数', width:80, hidden:true},
				   {field:'PRODArcimCode', title:'医嘱编码', hidden:true},
				   {field:'PRODMutex', title:'互斥标识', hidden:true},
				   {field:'ArcimRowID', title:'PRODArcimId', hidden:true},
				   {field:'Rowid', title:'Rowid', hidden:true}
			]],
		url: $URL,
		queryParams: {
			ClassName: 'BILL.PKG.BL.ProductDetails',
			QueryName: 'QueryProductDetails',
			ProdDr: GV.ProductId
		},
	});
}