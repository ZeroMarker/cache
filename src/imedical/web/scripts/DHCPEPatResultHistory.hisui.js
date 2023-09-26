
//����	DHCPEPatResultHistory.hisui.js
//����	����ȶ�
//����	2018.10.10
//������  xy
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
				striped: true, //�Ƿ���ʾ������Ч��
				singleSelect: true,
				selectOnCheck: false,
				autoRowHeight: false,
				showFooter: true,
				nowrap:false,
				url: $URL,
				loadMsg: 'Loading...',
				pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
				rownumbers: true, //���Ϊtrue, ����ʾһ���к���
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