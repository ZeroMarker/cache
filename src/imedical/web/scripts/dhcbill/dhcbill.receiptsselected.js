/**
 * FileName: dhcbill.receiptsselected.js
 * Anchor: ZhYW
 * Date: 2017-09-30
 * Description: 
 */

$(function () {
	$('#receiptsList').datagrid({
		fit: true,
		striped: true,
		singleSelect: true,
		bodyCls: 'panel-body-gray',
		pagination: true,
		rownumbers: false,
		pageSize: 10,
		columns: [[
			{title: 'TRowID', field: 'TRowID', hidden: true},
			{title: '开始号码', field: 'TStartNO', width: 100},
			{title: '结束号码', field: 'TEndNO', width: 100},
			{title: '当前号码', field: 'TCurrentNO', width: 100}, 
			{title: '开始字母', field: 'TTitle', width: 70}, 
			{title: '购入人', field: 'TBuyer', width: 100},
			{title: '购入日期', field: 'TDate', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: GV.CLS,
			QueryName: GV.QUERY,
			type: GV.Type,
			hospital: PUBLIC_CONSTANT.SESSION.HOSPID,
			guser: ""   //查询所有购入的可用发票
		},
		onDblClickRow: function (index, row) {
			getReceipts(row);
		}
	});
});

function getReceipts(row) {
	var selectedID = row.TRowID;
	var currentNO = row.TCurrentNO;
	var endNO = row.TEndNO;
	var title = row.TTitle;
	//将此号段置为启用
	$.m({
		ClassName: GV.CLS,
		MethodName: GV.UPDATE,
		rowID: selectedID
	}, function(rtn) {
		if (rtn == 0) {
			var receiptStr = selectedID + "^" + currentNO + "^" + endNO + "^" + title;
			websys_showModal("options").callbackFunc(receiptStr);
			websys_showModal("close");
		}
	});
}