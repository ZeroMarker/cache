/**
 * FileName: dhcbill.pkg.prodetails.js
 * Anchor: ZhYW
 * Date: 2019-10-22
 * Description: �ײͲ�Ʒ��ϸ
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
		columns: [[{field:'ArcimDesc', title:'ҽ������', width:120},
				   {field:'ItemPrice', title:'��׼����', width:90, align:'right'},
				   {field:'ActualPrice', title:'ʵ�۵���',width:90, align:'right'},
				   {field:'Qty', title:'����', width:70},
				   {field:'TotalAmt', title:'���', width:80, align:'right'},
				   {field:'SalesAmount', title:'ʵ�۽��', width:80, align:'right'},
				   {field:'PRODDayNum', title:'��������', width:80, hidden:true},
				   {field:'PRODArcimCode', title:'ҽ������', hidden:true},
				   {field:'PRODMutex', title:'�����ʶ', hidden:true},
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