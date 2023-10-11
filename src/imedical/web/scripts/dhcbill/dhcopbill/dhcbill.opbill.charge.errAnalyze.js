/**
 * 门诊异常错误原因分析JS
 * FileName: dhcbill.opbill.charge.errAnalyze.js
 * Huang SF 2018-03-12
 * 版本：V1.0
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
			{field: 'TLocDesc', title: '就诊科室', width: 80},
			{field: 'TAdmDate', title: '就诊日期', width: 80},
			{field: 'TAdmTime', title: '就诊时间', width: 80}
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
		view: scrollview,  //滚动加载
		pageSize: 20,
		columns:[[
			{field: 'TOrdItem1', title: '医嘱ID', width: 80},
			{field: 'TArcimDesc1', title: '结算前医嘱描述', width: 140},
			{field: 'TOrdPatShare1', title: '总金额', width: 80},
			{field: 'TOrdItem2', title: 'OrdItem2', hidden:true},
			{field: 'TArcimDesc2', title: '结算后医嘱描述', width: 140},
			{field: 'TOrdPatShare2', title: '总金额', width: 80},
			{field: 'TSame', title: '是否相同', width: 80,
				formatter: function (value, row, index) {
					return (value == "Y") ? "是": "否";
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
			{field: 'Property', title: '属性分类', width: 80},
			{field: 'ChargeValue', title: '结算前的值', width: 140},
			{field: 'ReBillValue', title: '结算后的值', width: 140},
			{field: 'Same', title: '是否相同', width: 80}
		]],
		rowStyler: function(index, row) {
			if("否" == row.Same) {
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