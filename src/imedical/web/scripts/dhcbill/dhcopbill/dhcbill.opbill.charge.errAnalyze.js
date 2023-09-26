/**
 * 门诊异常错误原因分析JS
 * FileName: dhcbill.opbill.charge.errAnalyze.js
 * Huang SF 2018-03-12
 * 版本：V1.0
 * hisui版本:0.1.0
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
			{field: 'Property', title: '属性分类', width: 80},
			{field: 'ChargeValue', title: '结算前的值', width: 80},
			{field: 'ReBillValue', title: '结算后的值', width: 80},
			{field: 'Same', title: '是否相同', width: 80}
		]],
		rowStyler: function(index, row) {
			if("否" == row.Same) {
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
			{field: 'TLocDesc', title: '就诊科室', width: 80},
			{field: 'TAdmDate', title: '就诊日期', width: 80},
			{field: 'TAdmTime', title: '就诊时间', width: 80}
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
		view: scrollview,  //滚动加载
		pageSize: 20,
		columns:[[
			{field: 'TOrdItem1', title: '医嘱RowId', width: 100},
			{field: 'TArcimDesc1', title: '结算前医嘱描述', width: 100},
			{field: 'TOrdPatShare1', title: '总金额', width: 100},
			{field: 'TOrdItem2', title: 'OrdItem2', hidden:true, width: 100},
			{field: 'TArcimDesc2', title: '结算后医嘱描述', width: 100},
			{field: 'TOrdPatShare2', title: '总金额', width: 100},
			{field: 'TSame', title: '相同标识', width: 100}
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