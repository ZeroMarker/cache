/**
 * �����쳣����ԭ�����JS
 * FileName: dhcbill.opbill.charge.errAnalyze.js
 * Huang SF 2018-03-12
 * �汾��V1.0
 */

$(function() {
	initPanel();
	loadPatInfo();
});

function initPanel() {
	$HUI.datagrid("#AdmList", {
		fit: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: true,
		pageSize: 9999999,
		columns:[[
			{field: 'TLocDesc', title: '�������', width: 80},
			{field: 'TAdmDate', title: '��������', width: 80},
			{field: 'TAdmTime', title: '����ʱ��', width: 80}
		]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCOPBillChargExcepitonAnalyse",
			QueryName: "GetChargeAdmList",
			Job: CV.Job
		}
	});
	
	$HUI.datagrid("#ChargeLog", {
		fit: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		fitColumns: true,
		url: $URL,
		view: scrollview,  //��������
		pageSize: 20,
		columns:[[
			{field: 'TOrdItem1', title: 'ҽ��ID', width: 80},
			{field: 'TArcimDesc1', title: '����ǰҽ������', width: 140},
			{field: 'TOrdPatShare1', title: '�ܽ��', width: 80},
			{field: 'TOrdItem2', title: 'OrdItem2', hidden:true},
			{field: 'TArcimDesc2', title: '�����ҽ������', width: 140},
			{field: 'TOrdPatShare2', title: '�ܽ��', width: 80},
			{field: 'TSame', title: '�Ƿ���ͬ', width: 80,
				formatter: function (value, row, index) {
					return (value == "Y") ? "��": "��";
				}
			}
		]],
		queryParams: {
			ClassName: "web.DHCOPBillChargExcepitonAnalyse",
			QueryName: "FindOrdItem",
			Job: CV.Job,
			Flag: ""
		},
		rowStyler: function (index, row) {
			return "background-color:" + (("N" == row.TSame) ? "#f03c3c;" : "#cbe5ff;");
		},
		onSelect:function(index, row) {
			var input = row.TOrdItem1 ? row.TOrdItem1 : row.TOrdItem2;
			loadDetailInfo(input);
		}
	});
	
	$HUI.datagrid("#ReBillLog", {
		fit: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		fitColumns: true,
		pageSize: 9999999,
		columns:[[
			{field: 'Property', title: '���Է���', width: 80},
			{field: 'ChargeValue', title: '����ǰ��ֵ', width: 140},
			{field: 'ReBillValue', title: '������ֵ', width: 140},
			{field: 'Same', title: '�Ƿ���ͬ', width: 80}
		]],
		rowStyler: function(index, row) {
			if("��" == row.Same) {
				return 'background-color: #f03c3c;';
			}
		}
	});
}

function loadPatInfo() {
	$.cm({
		ClassName: "web.DHCOPBillChargExcepitonAnalyse",
		MethodName: "GetChargeBasePara",
		Job: CV.Job
	}, function(json) {
		setValueById("PayNum", json.PayNum);
		setValueById("BillNum", json.PatNum);
		setValueById("DNum", json.DNum);
		setValueById("RecLocFlag", json.RecLocFlag);
		setValueById("PayAmt", json.PaySum);
		setValueById("BillAmt", json.PatShareAmt);
		setValueById("BalanceAmt", json.BalanceAmt);
		setValueById("Guser", json.User);
		setValueById("Group", json.Group);
		setValueById("InsType", json.InsType);
	});
}

function loadDetailInfo(input) {
	var queryParams = {
		ClassName: "web.DHCOPBillChargExcepitonAnalyse",
		QueryName: "GetOrdItemProperty",
		Job: CV.Job,
		OEOrdItem: input
	};
	loadDataGridStore("ReBillLog", queryParams);
}