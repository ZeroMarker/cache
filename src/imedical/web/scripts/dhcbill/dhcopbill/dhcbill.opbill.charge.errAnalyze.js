/**
 * �����쳣����ԭ�����JS
 * FileName: dhcbill.opbill.charge.errAnalyze.js
 * Huang SF 2018-03-12
 * �汾��V1.0
 * hisui�汾:0.1.0
 */

$(function() {
	initPanel();
	loadPatInfo();
	loadChargeInfo();
});

function initPanel(){
	$HUI.datagrid("#ReBillLog", {
		fit: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
		rownumbers: true,
		pageSize: 9999999,
		columns:[[
			{field: 'Property', title: '���Է���', width: 80},
			{field: 'ChargeValue', title: '����ǰ��ֵ', width: 80},
			{field: 'ReBillValue', title: '������ֵ', width: 80},
			{field: 'Same', title: '�Ƿ���ͬ', width: 80}
		]],
		rowStyler: function(index, row) {
			if("��" == row.Same) {
				return 'background-color:#f03c3c;';
			}
		}
	});
	
	$HUI.datagrid("#AdmList", {
		fit: true,
		bodyCls: 'panel-header-gray',
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
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
			Job: GlobalObj.job
		}
	});
}

function loadPatInfo() {
	$.cm({
		ClassName: "web.DHCOPBillChargExcepitonAnalyse",
		MethodName: "GetChargeBasePara",
		Job: GlobalObj.job
	}, function(jsonObj) {
		setValueById("PayNum", jsonObj.PayNum);
		setValueById("BillNum", jsonObj.PatNum);
		setValueById("DNum", jsonObj.DNum);
		setValueById("RecLocFlag", jsonObj.RecLocFlag);
		setValueById("PayAmt", jsonObj.PaySum);
		setValueById("BillAmt", jsonObj.PatShareAmt);
		setValueById("BalanceAmt", jsonObj.BalanceAmt);
		setValueById("Guser", jsonObj.User);
		setValueById("Group", jsonObj.Group);
		setValueById("InsType", jsonObj.InsType);
	});
}

function loadChargeInfo() {
	$HUI.datagrid("#ChargeLog", {
		fit: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
		url: $URL,
		rownumbers: true,
		view: scrollview,  //��������
		pageSize: 20,
		columns:[[
			{field: 'TOrdItem1', title: 'ҽ��RowId', width: 100},
			{field: 'TArcimDesc1', title: '����ǰҽ������', width: 100},
			{field: 'TOrdPatShare1', title: '�ܽ��', width: 100},
			{field: 'TOrdItem2', title: 'OrdItem2', hidden:true, width: 100},
			{field: 'TArcimDesc2', title: '�����ҽ������', width: 100},
			{field: 'TOrdPatShare2', title: '�ܽ��', width: 100},
			{field: 'TSame', title: '��ͬ��ʶ', width: 100}
		]],
		queryParams: {
			ClassName: "web.DHCOPBillChargExcepitonAnalyse",
			QueryName: "FindOrdItem",
			Job: GlobalObj.job,
			Flag: ""
		},
		rowStyler: function (index, row) {
			if("N" == row.TSame) {
				return 'background-color:#f03c3c;';
			}else {
				return 'background-color:#cbe5ff;';
			}
		},
		onClickRow:function(rowIndex, rowData) {
			var input = "";
			if("" !== rowData.TOrdItem1) {
				input = rowData.TOrdItem1;
			}else {
				input = rowData.TOrdItem2;
			}
			loadDetailInfo(input);
		}
	});
}

function loadDetailInfo(input) {
	var queryParams = {
		ClassName: "web.DHCOPBillChargExcepitonAnalyse",
		QueryName: "GetOrdItemProperty",
		Job: GlobalObj.job,
		OEOrdItem: input
	};
	loadDataGridStore("ReBillLog", queryParams);
}