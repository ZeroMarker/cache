
//名称	DHCPEPatResultHistory.hisui.js
//功能	结果比对
//创建	2018.10.10
//创建人  xy
$(function(){
	

	InitResultHistoryDataGrid();
	
})

function InitResultHistoryDataGrid() {
	
	$.cm({
		ClassName: "web.DHCPE.ResultContrast",
		MethodName: "GetRegColumns",
		'AdmId':AdmId
	}, function (txtData) {
		var columnAry = new Array();
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["halign"] = item.halign;
			column["width"] = item.width;
			columnAry.push(column);
		});
		var opbillInvListObj = $HUI.datagrid('#HistoryResult', {
				fit: true,
				striped: true, //是否显示斑马线效果
				singleSelect: true,
				selectOnCheck: false,
				autoRowHeight: false,
				showFooter: true,
				nowrap:false,
				url: $URL,
				loadMsg: 'Loading...',
				pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
				rownumbers: true, //如果为true, 则显示一个行号列
				pageSize: 15,
				pageList: [15, 20, 25, 30],
				columns: [columnAry],
				queryParams: {
					ClassName: "web.DHCPE.ResultContrast",
					QueryName: "SearchPatResultHistory",
					'RegNo':RegNo,
					'AdmId':AdmId,
					'DateFrom':DateFrom,
					'DateTo':DateTo
				}
			});
	});
}