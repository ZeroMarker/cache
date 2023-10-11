
/*
 * FileName:    dhcpelisresulthistory.hisui.js
 * Author:      xy
 * Date:        20230517
 * Description: 检验结果对比
 */
 
$(function(){
	
	$.cm({
		ClassName: "web.DHCPE.ResultContrast",
		MethodName: "GetResultHistoryColumns",
		PAADMStr:PAADM
	}, function (txtData) {
		var columnAry = new Array();
		var columnum=txtData.length;
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["width"] = 1100/columnum-1;
			columnAry.push(column);
		});
		
		var ResultHistoryGridObj = $HUI.datagrid('#ResultHistoryGrid', {
				url: $URL,
				fit: true,
				striped: true,
				border: false,
				pagination: true,
				rownumbers: true,
				autoRowHeight : true,
				pageSize: 20,
				pageList: [20, 30, 40, 50],
				columns: [columnAry],
				queryParams: {
					ClassName: "web.DHCPE.ResultContrast",
					QueryName: "PatResultHistory",
					PAADMStr: PAADM,
					LocID:session['LOGON.CTLOCID']
				}
			});
	});
})


